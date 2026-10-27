

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/models/manager/all_employee_list.dart';
import 'package:loyaltri_minimal/services/api_services.dart';
import '../../../../controller/userProfileController.dart';
import '../../../../models/leave_type_api_model.dart';
import '../../../../models/manager/leave_request_list_model.dart';
import '../../Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import '../../Manager_Request/manager_request_controller/manager_request_controller.dart';

class EmployeeLeaveController extends GetxController {
  RxInt currentTabIndex = 0.obs;
  Rx<LeaveType?> currentItem = Rx(null);
  Rx<DateTime> calendarCurrentMonth = DateTime.now().obs;
  RxString searchText = ''.obs;
  RxString selectedEmployeeId = ''.obs;

  void resetValues() {
    currentTabIndex.value = 0;
    currentItem.value = null;
    selectedEmployeeId.value = '';
    employeeCopyLeaveList.value = [];
    employeeCopyLeaveList.value = [];
    employeeAllLeaveList.value = [];
    employeePendingLeaveList.value = [];
    employeeApprovedLeaveList.value = [];
    employeeRejectedLeaveList.value = [];
  }

  RxBool leaveListLoading = false.obs;
  RxBool leaveListLoaded = false.obs;
  RxBool leaveListError = false.obs;
  Map<String, int> statusPriority = {
    'pending': 0,
    'approved': 1,
    'rejected': 2,
  };
  RxList<EmployeeLeaveData> employeeCopyLeaveList = <EmployeeLeaveData>[].obs;
  RxList<EmployeeLeaveData> employeeAllLeaveList = <EmployeeLeaveData>[].obs;
  RxList<EmployeeLeaveData> employeePendingLeaveList = <EmployeeLeaveData>[].obs;
  RxList<EmployeeLeaveData> employeeApprovedLeaveList = <EmployeeLeaveData>[].obs;
  RxList<EmployeeLeaveData> employeeRejectedLeaveList = <EmployeeLeaveData>[].obs;

  Future<void> fetchEmployeeLeaveList() async {
    leaveListLoading.value = true;
    leaveListLoaded.value = false;
    leaveListError.value = false;
    employeeCopyLeaveList.value = [];
    employeeAllLeaveList.value = [];
    employeePendingLeaveList.value = [];
    employeeApprovedLeaveList.value = [];
    employeeRejectedLeaveList.value = [];
    try {
      String empId = Get.find<UserProfileController>().userData.value.result.employeeId ?? '';
      String compId = Get.find<UserProfileController>().currentCompany.value?.companyId?.toString() ?? Get.find<UserProfileController>().userData.value.result.companyId ?? '';
      // DateTime date = DateFormat("MMM, yyyy").parse(monthYr);
      // String formatted = DateFormat("yyyy-MM").format(date);

      Map<String, dynamic> resp = await ApiServices.getEmployeeLeaveList(
        compId: compId,
        empId: empId,
        yrMonth: null,
        status: "All",
      );

      if(resp['status'].toString() == "200") {
        EmployeeLeaveReqApi employeeLeaveReqApi = EmployeeLeaveReqApi.fromJson(resp);
        employeeCopyLeaveList.value = employeeLeaveReqApi.result ?? [];

        // employeeCopyLeaveList.value.sort((a, b) {
        //   int aPriority = statusPriority[a.requestStatusName?.toLowerCase()] ?? 99;
        //   int bPriority = statusPriority[b.requestStatusName?.toLowerCase()] ?? 99;
        //   return aPriority.compareTo(bPriority);
        // });

        employeeAllLeaveList.value = employeeCopyLeaveList.value;
        employeePendingLeaveList.value = employeeCopyLeaveList.value.where((leave) => leave.requestStatusName?.trim().toLowerCase() == "pending").toList();
        employeeApprovedLeaveList.value = employeeCopyLeaveList.value.where((leave) => leave.requestStatusName?.trim().toLowerCase() == "approved").toList();
        employeeRejectedLeaveList.value = employeeCopyLeaveList.value.where((leave) => leave.requestStatusName?.trim().toLowerCase() == "rejected").toList();

        if(searchText.value.isNotEmpty) {
          filterByName(value: searchText.value);
        }
      }

      leaveListLoaded.value = true;
    } catch(e) {
      leaveListError.value = false;
      AttendanceCommonWidgets().printF("-----------leave req list error--------------");
    } finally {
      leaveListLoading.value = false;
    }
  }

  RxBool leaveCancelling = false.obs;
  RxBool showReasonTextValidation = false.obs;
  Rx<TextEditingController> cancellingReason = TextEditingController().obs;

  Future<void> cancelLeaveReq({required String leaveId, required BuildContext context}) async {
    try {
      leaveCancelling.value = true;
      Map<String, dynamic> resp = await ApiServices.deleteLeaveReq(leaveId: leaveId, reason: cancellingReason.value.text);
      if(resp['status']?.toString() == '200') {
        AttendanceCommonWidgets().showSnackBar(
          context: context,
          backgroundColor: Colors.green,
          message: resp['message']?.toString() ?? 'Something went wrong',
        );
      } else {
        AttendanceCommonWidgets().showSnackBar(
          context: context,
          backgroundColor: Colors.red,
          message: resp['message']?.toString() ?? 'Something went wrong',
        );
      }
    } catch(e) {
      AttendanceCommonWidgets().showSnackBar(
        context: context,
        backgroundColor: Colors.red,
        message: 'Something went wrong',
      );
    } finally {
      leaveCancelling.value = false;
      cancellingReason.value.clear();
    }
  }

  void filterByName({required String value}) {
    if(currentTabIndex.value == 3) {
      employeeAllLeaveList.value = employeeCopyLeaveList.value
          .where((leave) => leave.employeeName?.trim().toLowerCase()
          .contains(value.trim().toLowerCase()) ?? false,
      ).toList();
    } else if(currentTabIndex.value == 0) {
      employeePendingLeaveList.value = employeeCopyLeaveList.value
          .where((leave) => leave.requestStatusName?.trim().toLowerCase() == "pending"
          && (leave.employeeName?.trim().toLowerCase().contains(value.trim().toLowerCase()) ?? false)).toList();
    } else if(currentTabIndex.value == 1) {
      employeeRejectedLeaveList.value = employeeCopyLeaveList.value
          .where((leave) => leave.requestStatusName?.trim().toLowerCase() == "rejected"
          && (leave.employeeName?.trim().toLowerCase().contains(value.trim().toLowerCase()) ?? false)).toList();
    } else if(currentTabIndex.value == 2) {
      employeeApprovedLeaveList.value = employeeCopyLeaveList.value
          .where((leave) => leave.requestStatusName?.trim().toLowerCase() == "approved"
          && (leave.employeeName?.trim().toLowerCase().contains(value.trim().toLowerCase()) ?? false)).toList();
    }
  }
}