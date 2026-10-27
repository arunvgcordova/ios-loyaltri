
import 'dart:ui';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/controller/attendanceListController.dart';
import 'package:loyaltri_minimal/models/attendance_summary_model.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/manager_attendance_controller/manager_attendance_controller.dart';
import '../models/leave_type_api_model.dart';
import '../services/api_services.dart';
import '../services/ui_model_services/leave_dates_model.dart';

class AttendanceSummaryController extends GetxController {
  Rx<bool> isLoading = false.obs;
  Rx<bool> dataLoaded = false.obs;
  Rx<bool> isError = false.obs;
  Rx<String> changedMonth = "".obs;
  RxBool summaryExpansionChanged = false.obs;
  RxInt totalDays = 0.obs;
  Rx<AttendanceSummaryModel> attendanceSummary = AttendanceSummaryModel().obs;

  void resetStatus() {
    isLoading.value = false;
    isError.value = false;
  }

  Future getAttendanceSummary({required String empId, required String compId}) async {
    isLoading.value = true;
    try {
      if(changedMonth.value == "") {
        List<String> monthString = Get.find<AttendanceList>().monthString.value;
        if(monthString.isNotEmpty) {
          DateTime date = DateFormat.yMMM().parse(monthString[0]);
          changedMonth.value = DateFormat('yyyy-MM').format(date);
        }
      }
      Map<String, dynamic> resp = await ApiServices.getAttSummary(empId: empId, compId: compId, monthYr: changedMonth.value);
      AttendanceCommonWidgets().printF("-------resp--------$resp");
      if (resp['status'] == 200) {
        attendanceSummary.value = AttendanceSummaryModel.fromJson(resp);
        dataLoaded.value = true;
      }
    } catch(e) {
      isError.value = true;
      AttendanceCommonWidgets().printF("------attendance summary error-------${e.toString()}");
    } finally {
      resetStatus();
    }
  }
}

class AttendanceGridItem {
  final String label;
  final double count;
  final Color color;
  final AttendanceFilterTypes filterType;

  AttendanceGridItem({
    required this.label,
    required this.count,
    required this.color,
    required this.filterType,
  });
}