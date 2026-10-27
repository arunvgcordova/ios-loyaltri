import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/View/field/features/work_details/model/work_details_response.dart';
import 'package:loyaltri_minimal/controller/userAuthentication.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';
import 'package:loyaltri_minimal/models/user_profile_api_model.dart';
import '../../../../../services/api_services.dart';

class WorkDetailController extends GetxController {
  RxBool isloading = false.obs;
  // RxList<Works> WorkLogList = <Works>[].obs;

  Rx<WorkDetailsResponse?> workDetail = Rx(null);
  RxString assignedEmployee = "".obs;
  RxString assignedEmployeeNumber = "".obs;
  // int pendingCount = 0;
  // int completedCount = 0;

  Future<void> fetchWorkLogDetail({required String id}) async {
    assignedEmployee.value = "";
    assignedEmployeeNumber.value = "";
    // pendingCount = 0;
    // completedCount = 0;
    isloading.value = true;

    try {
      final resp = await ApiServices.getWorkLogDetail(id: id);

      if (resp['status']?.toString() == '200') {
        workDetail.value = WorkDetailsResponse.fromJson(resp);
        if(workDetail.value?.data?.createdBy != null){
          Map<String, dynamic> userResp = await ApiServices.getUserProfileDetails(
          empId: workDetail.value?.data?.createdBy.toString() ??"",
        );
        final userData = UserProfileApiModel.fromJson(userResp);
        assignedEmployee.value = userData.result.firstName ?? "" ;
        assignedEmployeeNumber.value = userData.result.phone ?? "" ;
        }
      } else {
        workDetail.value = null;
      }
    } catch (e, stackTrace) {
      workDetail.value = null;

      debugPrint('fetchWorkLogList error: $e');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      isloading.value = false;
    }
  }

  Future<void> workStatusUpdate({
    required BuildContext context,
    required int workId,
    required int workInstanceId,
    required String date,
    required String status,
  }) async {
    try {
      final int empId =
          int.tryParse(
            Get.find<UserAuthController>()
                    .userData
                    .value
                    .userData
                    ?.employeeId ??
                '',
          ) ??
          0;

      int compId =
          int.tryParse(
            Get.find<UserProfileController>().userData.value.result.companyId ??
                '',
          ) ??
          0;

      final body = {
        "company_id": compId,
        "employee_id": empId,
        "work_instance_id": workInstanceId,
        "work_id": workId,
        "date": date,
        "status": status,
      };

      final resp = await ApiServices.workStatusUpdate(body: body);
      AttendanceCommonWidgets().printF("dahsuidahdiudhiuisd ----- ${body}");
      if (resp['status'] == 200) {
        AttendanceCommonWidgets().printF("dahsuidahdiudhiuisd ----- ${resp}");
        AttendanceCommonWidgets().showSnackBar(
          context: context,
          backgroundColor: Colors.green,
          message: resp["message"],
        );
        Navigator.pop(context, true);
      } else {
        AttendanceCommonWidgets().showSnackBar(
          context: context,
          backgroundColor: Colors.red,
          message: resp["message"],
        );
        AttendanceCommonWidgets().printF(
          "Error =============== ${resp["message"]}",
        );
      }
    } catch (e) {
      debugPrint('Customer list error: $e');
    }
  }

  int getWorkInstanceId(List<Instances>? instances, DateTime selectedDate) {
    if (instances == null || instances.isEmpty) return 0;

    final date =
        "${selectedDate.year.toString().padLeft(4, '0')}-"
        "${selectedDate.month.toString().padLeft(2, '0')}-"
        "${selectedDate.day.toString().padLeft(2, '0')}";

    try {
      return instances.firstWhere((e) => e.scheduledDate == date).id ?? 0;
    } catch (_) {
      return 0;
    }
  }

  String getWorkInstanceStatus(
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

  String? getOverrideRequestStatus(
  List<Instances>? instances,
  DateTime selectedDate,
) {
  if (instances == null || instances.isEmpty) return null;

  final date =
      "${selectedDate.year.toString().padLeft(4, '0')}-"
      "${selectedDate.month.toString().padLeft(2, '0')}-"
      "${selectedDate.day.toString().padLeft(2, '0')}";

  try {
    final instance = instances.firstWhere(
      (e) => e.scheduledDate == date,
    );

    final request = instance.overrideRequests?.firstWhere(
      (e) => e.overrideFor == 'geofence_override',
    );

    return request?.status;
  } catch (_) {
    return null;
  }
}

  // String getWorkStartTimeByDate(
  //   List<Instances>? instances,
  //   DateTime selectedDate,
  // ) {
  //   if (instances == null || instances.isEmpty) return "";

  //   final date =
  //       "${selectedDate.year.toString().padLeft(4, '0')}-"
  //       "${selectedDate.month.toString().padLeft(2, '0')}-"
  //       "${selectedDate.day.toString().padLeft(2, '0')}";

  //   try {
  //     return instances
  //             .firstWhere((e) => e.scheduledDate == date)
  //             .plannedStartTime ??
  //         "";
  //   } catch (_) {
  //     return "";
  //   }
  // }

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
      final time = instances
          .firstWhere((e) => e.scheduledDate == date)
          .plannedStartTime;

      if (time == null || time.isEmpty) return "";

      final parsedTime = DateFormat("HH:mm:ss").parse(time);
      return DateFormat("h:mm a").format(parsedTime);
    } catch (_) {
      return "";
    }
  }

  String getWorkEndTimeByDate(
    List<Instances>? instances,
    DateTime selectedDate,
  ) {
    if (instances == null || instances.isEmpty) return "";

    final date =
        "${selectedDate.year.toString().padLeft(4, '0')}-"
        "${selectedDate.month.toString().padLeft(2, '0')}-"
        "${selectedDate.day.toString().padLeft(2, '0')}";

    try {
      final time = instances
          .firstWhere((e) => e.scheduledDate == date)
          .plannedEndTime;

      if (time == null || time.isEmpty) return "";

      final parsedTime = DateFormat("HH:mm:ss").parse(time);
      return DateFormat("h:mm a").format(parsedTime);
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
      final scheduledDate = instances
          .firstWhere((e) => e.scheduledDate == date)
          .scheduledDate;

      if (scheduledDate == null || scheduledDate.isEmpty) return "";

      final parsedDate = DateFormat("yyyy-MM-dd").parse(scheduledDate);
      return DateFormat("dd MMM, yyyy").format(parsedDate);
    } catch (_) {
      return "";
    }
  }

  Future<void> GeofenceOverrideRequeste({
    required BuildContext context,
    required int workId,
    required int workInstanceId,
    required String note,
  }) async {
    try {
      final int empId =
          int.tryParse(
            Get.find<UserAuthController>()
                    .userData
                    .value
                    .userData
                    ?.employeeId ??
                '',
          ) ??
          0;

      final body = {
        "work_id": workId,
        "work_instance_id": workInstanceId,
        "request_by": empId,
        "override_for": "geofence_override",
        "note": note,
        "request_datetime": DateTime.now().toString(),
      };
      AttendanceCommonWidgets().printF("dahsuidahdiudhiuisd ----- ${body}");
      final resp = await ApiServices.otpOverrideRequest(body: body);

      if (resp['status'] == 201 || resp['status'] == 400) {
        AttendanceCommonWidgets().printF("dahsuidahdiudhiuisd ----- ${resp}");
        AttendanceCommonWidgets().showSnackBar(
          context: context,
          backgroundColor: Colors.green,
          message: resp["message"],
        );
        Navigator.pop(context, true);
      } else {
        AttendanceCommonWidgets().showSnackBar(
          context: context,
          backgroundColor: Colors.red,
          message: resp["message"],
        );
        print("Error =============== ${resp["message"]}");
      }
    } catch (e) {
      debugPrint('Customer list error: $e');
    }
  }

  // String getWorkDateByDate(List<Instances>? instances, DateTime selectedDate) {
  //   if (instances == null || instances.isEmpty) return "";

  //   final date =
  //       "${selectedDate.year.toString().padLeft(4, '0')}-"
  //       "${selectedDate.month.toString().padLeft(2, '0')}-"
  //       "${selectedDate.day.toString().padLeft(2, '0')}";

  //   try {
  //     return instances
  //             .firstWhere((e) => e.scheduledDate == date)
  //             .scheduledDate ??
  //         "";
  //   } catch (_) {
  //     return "";
  //   }
  // }
}
