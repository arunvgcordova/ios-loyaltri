
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';

import '../models/leave_list_api_model.dart';
import '../services/api_services.dart';

class AppliedLeaveList extends GetxController {
  RxBool isLoading = false.obs;
  RxBool dataLoaded = false.obs;
  RxBool isError = false.obs;
  RxList<AppliedLeave> leaveList = <AppliedLeave>[].obs;
  RxList<AppliedLeave> approvedLeaveList = <AppliedLeave>[].obs;
  RxList<AppliedLeave> pendingLeaveList = <AppliedLeave>[].obs;
  RxList<AppliedLeave> rejectedLeaveList = <AppliedLeave>[].obs;

  void resetStatus() {
    isLoading.value = false;
    isError.value = false;
  }

  Future fetchLeaveList({required String monthYr}) async {
    isLoading.value = true;
    approvedLeaveList.value = [];
    pendingLeaveList.value = [];
    rejectedLeaveList.value = [];
    try {
      String empId = Get.find<UserProfileController>().userData.value.result.employeeId ?? '';
      String compId = Get.find<UserProfileController>().userData.value.result.companyId ?? '';
      Map<String, dynamic> resp = await ApiServices.appliedLeaveList(empId: empId, compId: compId, monthYear: monthYr);
      AttendanceCommonWidgets().printF("--------leave list resp----------$resp");
      LeaveListAPI leaveListAPI = LeaveListAPI.fromJson(resp);
      if (resp['status']?.toString() == "200") {
        leaveList.value = leaveListAPI.result ?? [];
        // leaveList.value.sort((a, b) {
        //   DateTime dateA = DateTime.parse(a.createdOn ?? '');
        //   DateTime dateB = DateTime.parse(b.createdOn ?? '');
        //   return dateA.compareTo(dateB);
        // });
        await fetchDataPerMonth(
            // selectedData: monthYr,
        );
        dataLoaded.value = true;
      }
    } catch(e) {
      isError.value = true;
      AttendanceCommonWidgets().printF("------leave list error-------${e.toString()}");
    } finally {
      resetStatus();
    }
  }

  fetchDataPerMonth(
      // {required String selectedData},
) {
    try {
      List<AppliedLeave> approved = [];
      List<AppliedLeave> pending = [];
      List<AppliedLeave> rejected = [];

      // List<String> dateParts = selectedData.split('-');

      // int year = int.parse(dateParts[0]);
      // int month = int.parse(dateParts[1]);

      for(int i = 0; i < leaveList.value.length; i++) {
        if (leaveList.value[i].requestStatusName == "Approved") {
          // if (year == int.parse(leaveList.value[i].leaveDateFrom?.split('-')[0] ?? '') &&
          //     month == int.parse(leaveList.value[i].leaveDateFrom?.split('-')[1] ?? '')) {
            approved.add(leaveList.value[i]);
          // }
        } else if (leaveList.value[i].requestStatusName == "Pending") {
          // if (year == int.parse(leaveList.value[i].leaveDateFrom?.split('-')[0] ?? '') &&
          //     month == int.parse(leaveList.value[i].leaveDateFrom?.split('-')[1] ?? '')) {
            pending.add(leaveList.value[i]);
          // }
        } else if (leaveList.value[i].requestStatusName == "Rejected") {
          // if (year == int.parse(leaveList.value[i].leaveDateFrom?.split('-')[0] ?? '') &&
          //     month == int.parse(leaveList.value[i].leaveDateFrom?.split('-')[1] ?? '')) {
            rejected.add(leaveList.value[i]);
          // }
        }
      }
      approvedLeaveList.value = approved;
      pendingLeaveList.value = pending;
      rejectedLeaveList.value = rejected;
    } catch(e) {
      throw Exception('Data per month error');
    }
  }
}