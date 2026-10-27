import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/View/field/features/customer_form/model/customer_template_response.dart';
import 'package:loyaltri_minimal/controller/userAuthentication.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';
import 'package:loyaltri_minimal/services/api_services.dart';

class CustomerFormController extends GetxController {
  RxBool isloading = false.obs;

  Rx<CustomerTemplateResponse?> customerTemplateData = Rx(null);

  Future<Map<String, dynamic>?> getCurrentDeviceLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        Position pos = await Geolocator.getCurrentPosition(
          locationSettings:
              const LocationSettings(accuracy: LocationAccuracy.high),
        );

        List<Placemark> placemarks = await placemarkFromCoordinates(
          pos.latitude,
          pos.longitude,
        );

        String addr =
            "${pos.latitude.toStringAsFixed(4)}, ${pos.longitude.toStringAsFixed(4)}";
        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          final parts = [p.name, p.subLocality, p.locality, p.administrativeArea]
              .where((s) => s != null && s.isNotEmpty)
              .toList();
          if (parts.isNotEmpty) {
            addr = parts.join(', ');
          }
        }

        return {
          "lat": pos.latitude,
          "lng": pos.longitude,
          "address": addr,
        };
      }
    } catch (e) {
      debugPrint("Get current location error: $e");
    }
    return null;
  }

  Future<void> getcustomerTemplate() async {
    isloading.value = true;
    // final authController = Get.find<UserAuthController>();
    final profileController = Get.find<UserProfileController>();

    // final String empId =
    //     authController.userData.value.userData?.employeeId ?? '';

    final String compId =
        profileController.userData.value.result.companyId?.toString() ?? '';

    try {
      final resp = await ApiServices.getcustomerTemplate(companyId: compId);

      if (resp['status']?.toString() == '200') {
        customerTemplateData.value = CustomerTemplateResponse.fromJson(resp);
      } else {
        customerTemplateData.value = null;
      }
    } catch (e, stackTrace) {
      customerTemplateData.value = null;

      debugPrint('fetchWorkLogList error: $e');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      isloading.value = false;
    }
  }

  Future<void> addCustomer({
    required BuildContext context,
    required Map<String, dynamic> data,
    required String name,
    required String number,
    required String email,
    required String? locationName,
    required Map<String, dynamic>? location,
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
        // "customer_code": "string",
        "name": name,
        "phone": number,
        "email": email,
        "location_name":locationName,
        "location":location,
        "dynamic_fields": data,
        "employee_assign_type": "assigned_employees",
        "assigned_employee_ids": [empId],
        "profile_photo": "string",
      };

      final resp = await ApiServices.addCustomer(body: body);
      AttendanceCommonWidgets().printF("dahsuidahdiudhiuisd ----- ${body}");
      if (resp['status'] == 201) {
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

  // Future<List<CustomerData>> fetchCustomerList() async {
  //   try {
  //     String compId =
  //         Get.find<UserProfileController>().userData.value.result.companyId
  //             ?.toString() ??
  //         '';

  //     final resp = await ApiServices.getCustomerList(companyId: compId);

  //     if (resp['status']?.toString() == "200") {
  //       CustomerModelResponse customerData = CustomerModelResponse.fromJson(
  //         resp,
  //       );

  //       final customerList = customerData.data ?? [];
  //       return customerList;

  //       // return customerList
  //       //     .map((e) => e.dynamicFields?.name ?? '')
  //       //     .where((name) => name.isNotEmpty)
  //       //     .toList();
  //     }

  //     return [];
  //   } catch (e) {
  //     debugPrint('Customer list error: $e');
  //     return [];
  //   }
  // }
}
