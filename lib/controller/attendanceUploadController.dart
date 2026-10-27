
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/View/field/features/tracking/tracker_controller.dart';
import 'package:loyaltri_minimal/controller/userAuthentication.dart';
import 'package:loyaltri_minimal/models/checkIn_model.dart';
import 'package:loyaltri_minimal/services/attachment_service.dart';
import 'package:loyaltri_minimal/sqflite_db/punch_db.dart';
import 'package:path_provider/path_provider.dart';
import '../services/api_services.dart';
import '../services/flutter_secure_storage.dart';
import '../services/ui_model_services/api_request_model.dart';
import 'attSummaryController.dart';
import 'attendanceListController.dart';

class AttendanceUploadController extends GetxController {
  Rx<bool> isLoading = false.obs;
  Rx<bool> dataLoaded = false.obs;
  Rx<bool> isError = false.obs;
  RxnString errorMsg = RxnString();

  void resetStatus() {
    isLoading.value = false;
    // isError.value = false;
  }

  Future<String?> checkInGuard() async {
    try {
      AttendanceCheckModel? punchData = await PunchDatabase.instance.readLastSavedPunch();
      if(punchData != null) {
        DateTime lastPunchDateTime = DateTime.parse("${punchData.punchDate} ${punchData.punchTime}").add(const Duration(minutes: 3));
        if (lastPunchDateTime.isBefore(DateTime.now())) {

        } else {
          return "msg";
        }
      }
    } catch(_) {}
    return null;
  }

  Future sendAttendance({AttendanceCheckModel? attendance}) async {
    bool fieldAccess = Get.find<UserAuthController>().fieldAccess.value;

    final trackingCtr = Get.isRegistered<TrackingController>()
        ? Get.find<TrackingController>()
        : Get.put(TrackingController());
    isLoading.value = true;
    errorMsg.value = null;
    try {
      if(fieldAccess && attendance != null) {
        // --- Loyaltri field ---- check is working started true//
        final workStatus =await  trackingCtr.checkEmployeWorkStatus();

        if (workStatus) {
          String? state = attendance.punchState == "punchIn" ? "check in" : attendance.punchState == "punchOut" ? 'check out' : '';
          Get.snackbar(
            'Action Required',
            'Please end your work session before ${state ?? ''}.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
            borderRadius: 12.0,
            margin: const EdgeInsets.all(16.0),
          );
          return;
        }
        // --- Loyaltri field ---- check is working started true//
      }

      Get.find<AttendanceList>().dataLoaded.value = false;
      Get.find<AttendanceSummaryController>().dataLoaded.value = false;
      List<AttendanceCheckModel> punchData = await PunchDatabase.instance.readAllPunchData();

      if(attendance != null) {
        if(punchData.isEmpty) {
          AttendanceCheckModel newPunch = await PunchDatabase.instance.create(attendance.copy(isSynced: 0));
          punchData.add(newPunch);
        } else {
          DateTime lastPunchDateTime = DateTime.parse("${punchData.last.punchDate} ${punchData.last.punchTime}").add(const Duration(minutes: 3));

          AttendanceCommonWidgets().printF("------lastPunchDateTime-------$lastPunchDateTime");
          AttendanceCommonWidgets().printF("------now-------${DateTime.now()}");

          if (lastPunchDateTime.isBefore(DateTime.now())) {
            AttendanceCheckModel newPunch = await PunchDatabase.instance.create(attendance.copy(isSynced: 0));
            punchData.add(newPunch);
          } else {
            errorMsg.value = "msg";
            dataLoaded.value = false;
            isError.value = true;
            throw Exception("Error: Please try after three minutes.");
          }
        }
      }

      log('---------punchData.length---------${punchData.length}');
      AttendanceCheckModel? prevPunch;
      for (var punch in punchData) {
        log('---------punchData---------${punch.toJson()}');
        if(prevPunch?.punchDate == punch.punchDate &&
            prevPunch?.punchTime == punch.punchTime) {
          await AttachmentService.deleteFaceImage(filePath: punch.punchImage);
          await PunchDatabase.instance.delete(punch.id!);
          continue;
        }
        prevPunch = punch;
        if(punch.isSynced == 0 && (punch.punchState == "punchIn" || punch.punchState == "punchOut")) {
          Map<String, dynamic> resp = await ApiServices.sendCheckInData(attendance: punch);
          AttendanceCommonWidgets().printF("-------upload resp--------$resp");
          if (resp['status'] == 200) {
            if(resp['result'] != null) {
              AttendanceCommonWidgets().printF("------result--------${resp['result']}");
              AttendanceCommonWidgets().printF("------punchState--------${punch.punchState}");
              if((resp['result'] == "punchIn" && punch.punchState == "punchIn") || (resp['result'] == "punchOut" && punch.punchState == "punchOut")) {
                await AttachmentService.deleteFaceImage(filePath: punch.punchImage);
                await PunchDatabase.instance.update(punch.copy(isSynced: 1));
              } else if(resp['result'] == "punchIn" && punch.punchState == "punchOut") {
                await AttachmentService.deleteFaceImage(filePath: punch.punchImage);
                await PunchDatabase.instance.update(punch.copy(isSynced: 1, punchState: "punchIn"));
              } else if(resp['result'] == "punchOut" && punch.punchState == "punchIn") {
                await AttachmentService.deleteFaceImage(filePath: punch.punchImage);
                await PunchDatabase.instance.update(punch.copy(isSynced: 1, punchState: "punchOut"));
              } else {
                await PunchDatabase.instance.delete(punch.id!);
              }
            } else {
              await AttachmentService.deleteFaceImage(filePath: punch.punchImage);
              await PunchDatabase.instance.update(punch.copy(isSynced: 1));
            }
          } else {
            await AttachmentService.deleteFaceImage(filePath: punch.punchImage);
            await PunchDatabase.instance.update(punch.copy(isSynced: 1, punchState: "conditionally synced"));
          }
          await SecureStorageUtils().setErrorOccurs(resp.toString());
        } else if(punch.isSynced == 0 && (punch.punchState == "breakIn" || punch.punchState == "breakOut")) {
          BreakRequestModel breakRequestModel = BreakRequestModel(
            employeeId: punch.employeeId,
            breakType: punch.punchState == "breakOut"
                ? BreakType.endBreak
                : BreakType.startBreak,
            date: punch.punchDate,
            time: punch.punchTime,
          );
          Map<String, dynamic> resp = await ApiServices.sendBreakDetails(breakRequest: breakRequestModel);
          if (resp['status'] == 200) {
            await PunchDatabase.instance.delete(punch.id!);
            await PunchDatabase.instance.create(punch.copy(isSynced: 1));
          } else {
            await PunchDatabase.instance.delete(punch.id!);
            await PunchDatabase.instance.create(punch.copy(isSynced: 1, punchState: "conditionally synced"));
          }
          await SecureStorageUtils().setErrorOccurs(resp.toString());
        }
      }

      dataLoaded.value = true;
    } catch (e) {
      dataLoaded.value = false;
      isError.value = true;
      await SecureStorageUtils().setErrorOccurs(e.toString());
      AttendanceCommonWidgets().printF("------attendance upload error-------${e.toString()}");
    } finally {
      resetStatus();
      if(fieldAccess) {
        try {
          //------------- Loyaltri field ------------- //
          if(attendance != null){
            AttendanceCheckModel? punchData = await PunchDatabase.instance.readLastSavedPunch();
            if (punchData?.punchState == "punchIn") {
              trackingCtr.startTracking();
            } else if(punchData?.punchState == "punchOut") {
              trackingCtr.endTracking();
            }

          }
          //------------- Loyaltri field ------------- //
        } catch (e) {

        }
      }
    }
  }

  Future<bool> sendFaceData() async {
    isLoading.value = true;
    try {
      String? userImage = await SecureStorageUtils().getFace();
      if(userImage != null) {
        Map<String, dynamic> resp =
        await ApiServices.faceAuth(source: userImage.toString(), user: userImage.toString());
        if (resp['result'] == true) {
          return true;
        }
      }
    } catch (e) {
      isError.value = true;
      AttendanceCommonWidgets().printF("------face upload error-------${e.toString()}");
    } finally {
      resetStatus();
    }
    return false;
  }
}