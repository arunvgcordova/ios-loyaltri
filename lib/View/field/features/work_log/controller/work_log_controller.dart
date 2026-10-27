
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/View/field/features/customer/model/customer_response.dart';
import 'package:loyaltri_minimal/View/field/features/work_details/model/work_type_response.dart';
import 'package:loyaltri_minimal/View/field/features/work_log/model/work_log_response.dart';
import 'package:loyaltri_minimal/controller/userAuthentication.dart';
import '../../../../../controller/userProfileController.dart';
import '../../../../../services/api_services.dart';

class WorkLogController extends GetxController {
  DateTime selectedDate = DateTime.now();
  RxBool isloading = false.obs;
  // RxBool isError = false.obs;
  RxList<CompletedWorks> WorkLogCompletedList = <CompletedWorks>[].obs;
  RxList<PendingWorks> WorkLogPendingList = <PendingWorks>[].obs;
  RxList<OverdueWorks> overdueList = <OverdueWorks>[].obs;
  List<String> customerList = [];
  int pendingCount = 0;
  int completedCount = 0;
  int overdueCount = 0;

  Future<void> fetchWorkLogList({
    // required String date,
    required String status,
    required String search,
  }) async {
    pendingCount = 0;
    completedCount = 0;
    overdueCount = 0;
    isloading.value = true;
    // isError.value = false;

    try {
      final authController = Get.find<UserAuthController>();
      final profileController = Get.find<UserProfileController>();

      final String empId =
          authController.userData.value.userData?.employeeId ?? '';

      final String compId =
          profileController.userData.value.result.companyId?.toString() ?? '';

      final data = {
        "company_id": int.parse(compId),
        "dateStr": formatDate(selectedDate),
        "status": status,
        "employee_id": int.parse(empId),
        "search": search,
      };

      final resp = await ApiServices.getWorkLogList(data: data);

      if (resp['status']?.toString() == '200') {
        final workData = WorkLogResponse.fromJson(resp);

        WorkLogCompletedList.value = workData.data?.isNotEmpty == true
            ? workData.data!.first.completedWorks ?? []
            : [];
        WorkLogPendingList.value = workData.data?.isNotEmpty == true
            ? workData.data!.first.pendingWorks ?? []
            : [];
        overdueList.value = workData.data?.isNotEmpty == true
            ? workData.data!.first.overdueWorks ?? []
            : [];
        completedCount = WorkLogCompletedList.length;
        pendingCount = WorkLogPendingList.length;
        overdueCount = overdueList.length;
      } else {
        // isError.value = true;
        WorkLogCompletedList.clear();
        WorkLogPendingList.clear();
        overdueList.clear();
      }
    } catch (e, stackTrace) {
      // isError.value = true;
      WorkLogCompletedList.clear();
      WorkLogPendingList.clear();
      overdueList.clear();

      debugPrint('fetchWorkLogList error: $e');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      isloading.value = false;
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  String getWorkStatusByDate(
    List<Instances>? instances,
    DateTime selectedDate,
  ) {
    if (instances == null || instances.isEmpty) return "";

    final date =
        "${selectedDate.year.toString().padLeft(4, '0')}-"
        "${selectedDate.month.toString().padLeft(2, '0')}-"
        "${selectedDate.day.toString().padLeft(2, '0')}";

    try {
      return instances.firstWhere((e) => e.scheduledDate == date).workStatus ??
          "";
    } catch (_) {
      return "";
    }
  }

  String getWorkStartTimeByDate(
    List<Instances>? instances,
    DateTime selectedDate,
  ) {
    if (instances == null || instances.isEmpty) return "";

    final date =
        "${selectedDate.year.toString().padLeft(4, '0')}-"
        "${selectedDate.month.toString().padLeft(2, '0')}-"
        "${selectedDate.day.toString().padLeft(2, '0')}";

    try {
      return instances
              .firstWhere((e) => e.scheduledDate == date)
              .plannedStartTime ??
          "";
    } catch (_) {
      return "";
    }
  }

  String getWorkDateByDate(List<Instances>? instances, DateTime selectedDate) {
    if (instances == null || instances.isEmpty) return "";

    final date =
        "${selectedDate.year.toString().padLeft(4, '0')}-"
        "${selectedDate.month.toString().padLeft(2, '0')}-"
        "${selectedDate.day.toString().padLeft(2, '0')}";

    try {
      return instances
              .firstWhere((e) => e.scheduledDate == date)
              .scheduledDate ??
          "";
    } catch (_) {
      return "";
    }
  }
}
