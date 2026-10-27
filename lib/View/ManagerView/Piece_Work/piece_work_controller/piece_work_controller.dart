import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';

import '../../../../controller/userProfileController.dart';
import '../../../../models/manager/piece_work_model.dart';
import '../../../../services/api_services.dart';

class PieceWorkController extends GetxController {
  RxList<DateTime> dateList =
      List.generate(
        365,
        (index) => DateTime.now().subtract(Duration(days: index)),
      ).obs;
  RxInt currentDateIndex = 0.obs;
  RxBool isChangedFromMonth = false.obs;
  RxString searchText = ''.obs;

  RxBool listLoading = false.obs;
  RxBool listLoaded = false.obs;
  RxBool listError = false.obs;
  RxList<EmployeePiece> pieceWorkListCopy = <EmployeePiece>[].obs;
  RxList<EmployeePiece> pieceWorkList = <EmployeePiece>[].obs;

  Future<void> fetchPieceWorkList(String date) async {
    try {
      listLoading.value = true;
      listError.value = false;
      UserProfileController userProfileController =
          Get.find<UserProfileController>();
      String compId =
          userProfileController.currentCompany.value?.companyId?.toString() ??
          userProfileController.userData.value.result.companyId ??
          '';
      final resp = await ApiServices.pieceWorkList(compId: compId, date: date);
      if (resp?['status']?.toString() == '200') {
        PieceWorkListApi pieceWorkListApi = PieceWorkListApi.fromJson(resp);
        pieceWorkListCopy.value = pieceWorkListApi.result ?? [];
        pieceWorkList.value = pieceWorkListApi.result ?? [];
        filterPieceWorkListByName(searchText.value);
        listLoaded.value = true;
      }
    } catch (e) {
      AttendanceCommonWidgets().printF(
        '----------piece work list error----------',
      );
      listError.value = true;
    } finally {
      listLoading.value = false;
    }
  }

  void filterPieceWorkListByName(String name) {
    pieceWorkList.value =
        pieceWorkListCopy.value
            .where(
              (emp) =>
                  emp.employeeName?.toLowerCase().contains(
                    name.toLowerCase(),
                  ) ??
                  false,
            )
            .toList();
  }

  RxList<PieceRate> pieceRateList = <PieceRate>[].obs;
  RxBool pieceRateLoading = false.obs;
  RxBool pieceRateLoaded = false.obs;
  RxBool pieceRateError = false.obs;
  Rx<PieceRate> selectedPiece = PieceRate().obs;

  Future<void> fetchAllPieceRate() async {
    try {
      pieceRateLoading.value = true;
      pieceRateError.value = false;
      UserProfileController userProfileController =
          Get.find<UserProfileController>();
      String compId =
          userProfileController.currentCompany.value?.companyId?.toString() ??
          userProfileController.userData.value.result.companyId ??
          '';
      final resp = await ApiServices.getAllPieceRate(compId: compId);
      if (resp?['status']?.toString() == '200') {
        AllPieceRateApi pieceRateApi = AllPieceRateApi.fromJson(resp);
        pieceRateList.value = pieceRateApi.result ?? [];
        pieceRateLoaded.value = true;
      }
    } catch (e) {
      AttendanceCommonWidgets().printF(
        '----------piece rate list error----------',
      );
      pieceRateError.value = true;
    } finally {
      pieceRateLoading.value = false;
    }
  }

  RxBool pieceWorkSaving = false.obs;
  RxBool pieceWorkSavingMore = false.obs;

  Future<bool> addPieceWork({String? createFor, required bool addMore}) async {
    try {
      if (addMore) {
        pieceWorkSavingMore.value = true;
      } else {
        pieceWorkSaving.value = true;
      }
      UserProfileController userProfileController =
          Get.find<UserProfileController>();
      String empId =
          userProfileController.userData.value.result.employeeId ?? '';
      String compId =
          userProfileController.currentCompany.value?.companyId?.toString() ??
          userProfileController.userData.value.result.companyId ??
          '';
      String formated = DateFormat(
        'yyyy/MM/d',
      ).format(dateList.value[currentDateIndex.value]);
      AddPieceWork addPieceWork = AddPieceWork(
        loggedInEmployeeId: empId,
        companyId: compId,
        date: formated,
        data: [
          PieceWorkEmployeeData(
            employeeId: createFor,
            totalAmount:
                selectedPiece.value.totalAmount != null
                    ? num.parse(selectedPiece.value.totalAmount!)
                    : null,
            records: [
              Record(
                pieceWorkEmpMappingId: null,
                code: selectedPiece.value.code,
                itemName: selectedPiece.value.unitName,
                pieceRateId: selectedPiece.value.pieceRateId,
                type: selectedPiece.value.type,
                subType: selectedPiece.value.subType,
                rate:
                    selectedPiece.value.ratePerUnit != null
                        ? num.parse(selectedPiece.value.ratePerUnit!)
                        : null,
                units: selectedPiece.value.unitCount,
                totalAmount:
                    selectedPiece.value.totalAmount != null
                        ? num.parse(selectedPiece.value.totalAmount!)
                        : null,
              ),
            ],
          ),
        ],
      );
      final resp = await ApiServices.savePieceRatePayment(
        pieceWork: addPieceWork,
      );
      if (resp?['status']?.toString() == '200') {
        await fetchPieceWorkList(formated);
        Get.snackbar(
          'Success',
          resp?['message']?.toString() ?? 'Piece Work Added Successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: EdgeInsets.all(10.h),
        );
        selectedPiece.value = PieceRate();
        return true;
      } else {
        Get.snackbar(
          'Failed',
          resp?['message']?.toString() ?? 'Something went wrong',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: EdgeInsets.all(10.h),
        );
      }
    } catch (e) {
      AttendanceCommonWidgets().printF(
        '----------piece work save error----------',
      );
      Get.snackbar(
        'Failed',
        'Something went wrong',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: EdgeInsets.all(10.h),
      );
    } finally {
      if (addMore) {
        pieceWorkSavingMore.value = false;
      } else {
        pieceWorkSaving.value = false;
      }
    }
    return false;
  }

  RxString pieceDeletingId = ''.obs;

  Future<void> deletePieceRate(String? id, String? empId) async {
    try {
      pieceDeletingId.value = id ?? '';
      final resp = await ApiServices.deletePieceRate(pieceWorkId: id);
      if (resp?['status']?.toString() == '200') {
        final empIndex = pieceWorkList.indexWhere((e) => e.employeeId == empId);
        if (empIndex != -1) {
          final emp = pieceWorkList[empIndex];

          emp.paymetArr?.removeWhere(
            (piece) => piece.pieceWorkEmpMappingId == id,
          );

          pieceWorkList[empIndex] = emp;
          pieceWorkList.refresh();
        }

        Get.snackbar(
          'Success',
          resp?['message']?.toString() ?? 'Piece rate has been deleted.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: EdgeInsets.all(10.h),
        );
      } else {
        Get.snackbar(
          'Failed',
          resp?['message']?.toString() ?? 'Something went wrong',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: EdgeInsets.all(10.h),
        );
      }
    } catch (e) {
    } finally {
      pieceDeletingId.value = '';
    }
  }
}
