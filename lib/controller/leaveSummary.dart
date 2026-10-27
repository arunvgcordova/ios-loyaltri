
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/models/leave_summary_model.dart';
import '../services/api_services.dart';

class LeaveSummaryController extends GetxController {
  Rx<bool> isLoading = false.obs;
  Rx<bool> dataLoaded = false.obs;
  Rx<bool> isError = false.obs;

  Rx<num> totalLeave = Rx<num>(0);
  late Rx<LeaveSummaryModel> leaveSummary = leaveSummaryAPI.obs;

  void resetStatus() {
    isLoading.value = false;
    isError.value = false;
  }

  Future fetchLeaveSummary({required String empId, required String monthYr}) async {
    isLoading.value = true;
    leaveSummary.value = leaveSummaryAPI;
    totalLeave.value = 0;
    try {
      Map<String, dynamic> resp = await ApiServices.getLeaveSummary(empId: empId, monthYr: monthYr);
      leaveSummary.value = LeaveSummaryModel.fromJson(resp);
      if (leaveSummary.value.status == 200) {
        totalLeave.value = 0;
        for (var leave in leaveSummary.value.result) {
          totalLeave.value += num.parse(leave.leaveBalance);
        }
        totalLeave.value = (totalLeave.value * 100).round() / 100;
        dataLoaded.value = true;
      }
    } catch(e) {
      isError.value = true;
      AttendanceCommonWidgets().printF("------leave summary error-------${e.toString()}");
    } finally {
      resetStatus();
    }
  }
}