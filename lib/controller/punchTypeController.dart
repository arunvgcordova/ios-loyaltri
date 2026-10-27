
import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import '../models/punch_type_model.dart';
import '../services/api_services.dart';
import '../services/flutter_secure_storage.dart';
import '../services/ui_model_services/check_type_model.dart';

class PunchTypeController extends GetxController {
  Rx<bool> isLoading = false.obs;
  Rx<bool> dataLoaded = false.obs;
  Rx<bool> isError = false.obs;
  Rx<PunchTypeModel> punchType = punchTypeModel.obs;
  RxList checkInMethods = [].obs;
  RxList checkOutMethods = [].obs;

  void resetStatus() {
    isLoading.value = false;
    isError.value = false;
  }

  Future checkPunchType({required String empId, required String compId}) async {
    checkInMethods.value = [];
    checkOutMethods.value = [];
    isLoading.value = true;
    try {
      Map<String, dynamic> resp = await ApiServices.getPunchType(compId: compId, empId: empId);
      AttendanceCommonWidgets().printF("-------resp--------$resp");
      if (resp['status'] == 200) {
        dataLoaded.value = true;
        punchType.value = PunchTypeModel.fromJson(resp);
        setPunchMethods();

        await SecureStorageUtils().setPunchTypeData(resp);
      }
    } catch(e) {
      PunchTypeModel? punchTypeModel = await SecureStorageUtils().getPunchTypeData();
      AttendanceCommonWidgets().printF("------message-------${punchTypeModel?.message}");
      if(punchTypeModel != null) {
        dataLoaded.value = true;
        punchType.value = punchTypeModel;
        setPunchMethods();
      } else {
        isError.value = true;
        dataLoaded.value = false;
      }
      AttendanceCommonWidgets().printF("------punch type error-------${e.toString()}");
    } finally {
      resetStatus();
    }
  }

  void setPunchMethods() {
    if(punchType.value.result.punchMethodId!.isNotEmpty) {
      checkInMethods.value = [];
      checkOutMethods.value = [];
      for (var type in punchType.value.result.punchMethodId!) {
        if(type == 5) {
          checkInMethods.add(
            const CheckType(typeId: 5, icon: "assets/images/finger_print.svg", iconType: CustomImageType.svg, title: "Button Punch", subTitle: "Tap to check in."),
          );
          checkOutMethods.add(
            const CheckType(typeId: 5, icon: "assets/images/finger_print.svg", iconType: CustomImageType.svg, title: "Button Punch", subTitle: "Tap to check out."),
          );
        }
        if(type == 3) {
          checkInMethods.add(
            const CheckType(typeId: 3, icon: "assets/images/Selfie-3d.webp", iconType: CustomImageType.webm, title: "Selfie", subTitle: "Verify your check in with a selfie."),
          );
          checkOutMethods.add(
            const CheckType(typeId: 3, icon: "assets/images/Selfie-3d.webp", iconType: CustomImageType.webm, title: "Selfie", subTitle: "Verify your check out with a selfie."),
          );
        }
        if(type == 6) {
          checkInMethods.add(
            const CheckType(typeId: 6, icon: "assets/images/qr_checkIn.webp", iconType: CustomImageType.webm, title: "QR Code", subTitle: "Scan the QR code to check in."),
          );
          checkOutMethods.add(
            const CheckType(typeId: 6, icon: "assets/images/qr_checkIn.webp", iconType: CustomImageType.webm, title: "QR Code", subTitle: "Scan the QR code to check out."),
          );
        }
        if(type == 4) {
          checkInMethods.add(
            const CheckType(typeId: 4, icon: "assets/images/geo-fencing-punch.webp", iconType: CustomImageType.webm, title: "Geo Punch", subTitle: "Tap to punch using Geo-fencing."),
          );
          checkOutMethods.add(
            const CheckType(typeId: 4, icon: "assets/images/geo-fencing-punch.webp", iconType: CustomImageType.webm, title: "Geo Punch", subTitle: "Tap to punch using Geo-fencing."),
          );
        }
        if(type == 9) {
          checkInMethods.value.add(
            const CheckType(typeId: 9, icon: "assets/images/geo+selfie.png", iconType: CustomImageType.webm, title: "Geo Selfie", subTitle: "Verify your check in with geo-fencing and selfie"),
          );
          checkOutMethods.value.add(
            const CheckType(typeId: 9, icon: "assets/images/geo+selfie.png", iconType: CustomImageType.webm, title: "Geo Selfie", subTitle: "Verify your check out with geo-fencing and selfie"),
          );
        }
      }
    }
  }
}