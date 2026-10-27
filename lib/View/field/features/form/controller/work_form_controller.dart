import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/View/field/features/customer/model/customer_response.dart';
import 'package:loyaltri_minimal/View/field/features/form/model/otp_override_response.dart';
import 'package:loyaltri_minimal/View/field/features/form/model/work_form_detail_response.dart';
import 'package:loyaltri_minimal/View/field/features/home/controller/home_controller.dart';
import 'package:loyaltri_minimal/View/field/features/tracking/tracker_controller.dart';
import 'package:loyaltri_minimal/View/field/features/work_details/controller/work_details_controller.dart';
import 'package:loyaltri_minimal/View/field/features/work_details/model/work_details_response.dart';
import 'package:loyaltri_minimal/controller/ui_controller/home_controller.dart';
import 'package:loyaltri_minimal/controller/userAuthentication.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';
import 'package:loyaltri_minimal/services/api_services.dart';

class WorkFormController extends GetxController {
  RxBool isloading = false.obs;
  RxBool isSubmitting = false.obs;

  Rx<WorkFormDetailResponse?> workFromDetail = Rx(null);
  Rx<OtpOverrideResponse?> OtpOverrideDetail = Rx(null);

  RxBool isOtpVerified = false.obs;
  RxBool hasOtpError = false.obs;

  Future<void> fetchWorkFormDetail({required String id,required String workInstanceId}) async {
    isloading.value = true;
    isOtpVerified.value = false;
    hasOtpError.value = false;

    try {
      final resp = await ApiServices.getWorkFormDetils(id: id);

      if (resp['status']?.toString() == '200') {
        workFromDetail.value = WorkFormDetailResponse.fromJson(resp);
        fetchOTPOverrideStatus(workInstanceId: workInstanceId);
      } else {
        workFromDetail.value = null;
      }
    } catch (e, stackTrace) {
      workFromDetail.value = null;

      debugPrint('fetchWorkLogList error: $e');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      isloading.value = false;
    }
  }

  Future<void> fetchOTPOverrideStatus({required String workInstanceId}) async {
    try {
      final resp = await ApiServices.otpOverride(workInstanceId: workInstanceId);

      if (resp['status']?.toString() == '200') {
        OtpOverrideDetail.value = OtpOverrideResponse.fromJson(resp);
      } else {
        OtpOverrideDetail.value = null;
      }
    } catch (e, stackTrace) {
      OtpOverrideDetail.value = null;

      debugPrint('fetchWorkLogList error: $e');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
    }
  }

  Future<List<CustomerData>> fetchCustomerList() async {
    try {
      String empId =
          Get.find<UserProfileController>().userData.value.result.employeeId
              ?.toString() ??
              '';
      String compId =
          Get.find<UserProfileController>().userData.value.result.companyId
              ?.toString() ??
          '';

      final resp = await ApiServices.getCustomerList(companyId: compId,empId: empId);

      if (resp['status']?.toString() == "200") {
        CustomerModelResponse customerData = CustomerModelResponse.fromJson(
          resp,
        );

        final customerList = customerData.data ?? [];
        return customerList;
      }

      return [];
    } catch (e) {
      debugPrint('Customer list error: $e');
      return [];
    }
  }

  Future<bool> submitWork({
    required BuildContext context,
    required int workId,
    required int workInstanceId,
    required Map<String, dynamic> data,
  }) async {
    isSubmitting.value = true;
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
        "work_id": workId,
        "work_instance_id": workInstanceId,
        "employee_id": empId,
        "submitted_data": data,
        "submitted_at": DateTime.now().toString(),
      };

      final resp = await ApiServices.submitWork(body: body);
      AttendanceCommonWidgets().printF("dahsuidahdiudhiuisd ----- ${body}");
      if (resp['status'] == 201) {
        AttendanceCommonWidgets().printF("dahsuidahdiudhiuisd ----- ${resp}");
        try {
          if (Get.isRegistered<TrackingController>()) {
            await Get.find<TrackingController>().endWork(
              workId: workId,
            );
          }
          if (Get.isRegistered<FieldHomeController>()) {
            await Get.find<FieldHomeController>().fetchHomeDetail();
          }
          if (Get.isRegistered<WorkDetailController>()) {
            await Get.find<WorkDetailController>().fetchWorkLogDetail(id: workId.toString());
          }
          if (Get.isRegistered<HomeController>()) {
            await Get.find<HomeController>().fetchWorkLogByDate();
          }
        } catch (postError) {
          debugPrint('Post submit refresh error: $postError');
        }
        return true;
      } else {
        AttendanceCommonWidgets().showSnackBar(
          context: context,
          backgroundColor: Colors.red,
          message: resp["message"],
        );
        return false;
      }
    } catch (e) {
      debugPrint('Submit work error: $e');
      AttendanceCommonWidgets().showSnackBar(
        context: context,
        backgroundColor: Colors.red,
        message: "Something went wrong.",
      );
      return false;
    } finally {
      isSubmitting.value = false;
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



  Future<void> OtpOverrideRequested({
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
        "override_for": "otp_override",
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
        // print("Error =============== ${resp["message"]}");
      }
    } catch (e) {
      debugPrint('Customer list error: $e');
    }
  }
  
}
