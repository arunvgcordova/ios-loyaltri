import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/View/field/features/customer/model/customer_response.dart';
import 'package:loyaltri_minimal/View/field/features/home/controller/home_controller.dart';
import 'package:loyaltri_minimal/View/field/features/work_details/model/work_details_response.dart';
import 'package:loyaltri_minimal/View/field/features/work_details/model/work_type_response.dart';
import 'package:loyaltri_minimal/controller/ui_controller/home_controller.dart';
import 'package:loyaltri_minimal/controller/userAuthentication.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';
import 'package:loyaltri_minimal/services/api_services.dart';

class AddWorkLogController extends GetxController {
  RxBool isScheduling = false.obs;
  RxBool isStartingNow = false.obs;

  bool get isAnyLoading => isScheduling.value || isStartingNow.value;

  String _getApiKey() {
    return "AIzaSyDcrfhtYO9E-fmpz384NN0RIY3-ArXQFhs";
  }

  Future<List<dynamic>> fetchPlacesAutocomplete(String query) async {
    if (query.trim().length < 3) return [];
    try {
      final apiKey = _getApiKey();
      final url = Uri.parse(
        "https://maps.googleapis.com/maps/api/place/autocomplete/json"
        "?input=${Uri.encodeComponent(query)}"
        "&components=country:in"
        "&key=$apiKey",
      );

      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data["status"] == "OK" || data["status"] == "ZERO_RESULTS") {
          return data["predictions"] ?? [];
        }
      }
    } catch (e) {
      debugPrint("Places autocomplete error: $e");
    }
    return [];
  }

  Future<Map<String, double>?> fetchPlaceDetails(String placeId) async {
    try {
      final apiKey = _getApiKey();
      final url = Uri.parse(
        "https://maps.googleapis.com/maps/api/place/details/json"
        "?place_id=$placeId"
        "&fields=geometry"
        "&key=$apiKey",
      );

      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data["status"] == "OK" && data["result"] != null) {
          final geometry = data["result"]["geometry"];
          if (geometry != null && geometry["location"] != null) {
            final location = geometry["location"];
            return {
              "lat": (location["lat"] as num).toDouble(),
              "lng": (location["lng"] as num).toDouble(),
            };
          }
        }
      }
    } catch (e) {
      debugPrint("Place details error: $e");
    }
    return null;
  }

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

  Future<void> addWorkLog({
    required BuildContext context,
    required String title,
    required int? workTypeId,
    required int? customerId,
    required String priority,
    required String date,
    required String startTime,
    required String endTime,
    required String location,
    required LatLng latLong,
    required bool? otpEnable,
    required bool? geofenceRequired,
    required String description,
    required List<String> attachment,
  }) async {
    try {
      isScheduling.value = true;
      final String empId =
          Get.find<UserAuthController>().userData.value.userData?.employeeId ??
          '';
      String compId =
          Get.find<UserProfileController>().userData.value.result.companyId
              ?.toString() ??
          '';
      final data = {
        "company_id": compId,
        "title": title,
        "workType": workTypeId,
        "customer": customerId,
        "email": "",
        "assignedEmployee": empId,
        "priority": priority,
        "date": date,
        "startTime": startTime,
        "endTime": endTime,
        "location": location,
        "latLng": {"lat": latLong.lat, "lng": latLong.lng},
        "otpEnable": otpEnable,
        "geofenceRequired": geofenceRequired,
        "description": description,
        "attachments": attachment,
        "repeat": false,
        "created_by":empId
        // "frequency": "Selected Days",
        // "repeatStart": "2026-06-24",
        // "repeatEnd": "2026-06-24",
        // "noEndDate": true,
        // "days": ["Sun"],
        // "customDates": ["2026-06-24"],
        // "status": "string",
      };

      final resp = await ApiServices.addWorkLog(data: data);

      if (resp['status'] == 201) {
        AttendanceCommonWidgets().printF("dahsuidahdiudhiuisd ----- ${resp}");
        if(Get.isRegistered<FieldHomeController>()) {
          await Get.find<FieldHomeController>().fetchHomeDetail();
        }
        await Get.find<HomeController>().fetchWorkLogByDate();
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
    } finally {
      isScheduling.value = false;
    }
  }

  Future<void> startWorkNow({
    required BuildContext context,
    required String title,
    required int? workTypeId,
    required int? customerId,
    required String priority,
    required String date,
    required String startTime,
    required String endTime,
    required String location,
    required LatLng latLong,
    required bool? otpEnable,
    required bool? geofenceRequired,
    required String description,
    required List<String> attachment,
  }) async {
    try {
      isStartingNow.value = true;
      final String empId =
          Get.find<UserAuthController>().userData.value.userData?.employeeId ??
          '';
      String compId =
          Get.find<UserProfileController>().userData.value.result.companyId
              ?.toString() ??
          '';
      final data = {
        "company_id": compId,
        "title": title,
        "workType": workTypeId,
        "customer": customerId,
        "email": "",
        "assignedEmployee": empId,
        "priority": priority,
        "date": date,
        "startTime": startTime,
        "endTime": endTime,
        "location": location,
        "latLng": {"lat": latLong.lat, "lng": latLong.lng},
        "otpEnable": otpEnable,
        "geofenceRequired": geofenceRequired,
        "description": description,
        "attachments": attachment,
        "repeat": false,
        "created_by":empId
        // "frequency": "Selected Days",
        // "repeatStart": "2026-06-24",
        // "repeatEnd": "2026-06-24",
        // "noEndDate": true,
        // "days": ["Sun"],
        // "customDates": ["2026-06-24"],
        // "status": "string",
      };

      final resp = await ApiServices.addWorkLog(data: data);

      if (resp['status'] == 201) {
        AttendanceCommonWidgets().printF("dahsuidahdiudhiuisd ----- ${resp}");
        if(Get.isRegistered<FieldHomeController>()) {
          await Get.find<FieldHomeController>().fetchHomeDetail();
        }
        await Get.find<HomeController>().fetchWorkLogByDate();

        final instances = resp['data']?['instances'];
        final int? instanceId = (instances is List && instances.isNotEmpty)
            ? instances[0]['id']
            : null;

        if (instanceId != null) {
          final body = {
            "company_id": compId,
            "employee_id": empId,
            "work_instance_id": instanceId,
            "work_id": resp['data']?['id'],
            "date": date,
            "status": 'in_progress',
          };

          await ApiServices.workStatusUpdate(body: body);
        }

        if(Get.isRegistered<FieldHomeController>()) {
          await Get.find<FieldHomeController>().fetchHomeDetail();
        }
        await Get.find<HomeController>().fetchWorkLogByDate();
        Navigator.pop(context, true);
      } else {
        AttendanceCommonWidgets().showSnackBar(
          context: context,
          backgroundColor: Colors.red,
          message: resp["message"],
        );
        }
    } catch (e) {
      debugPrint('Customer list error: $e');
      AttendanceCommonWidgets().showSnackBar(
        context: context,
        backgroundColor: Colors.red,
        message: "Something went wrong.",
      );
    } finally {
      isStartingNow.value = false;
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

        // return customerList
        //     .map((e) => e.dynamicFields?.name ?? '')
        //     .where((name) => name.isNotEmpty)
        //     .toList();
      }

      return [];
    } catch (e) {
      debugPrint('Customer list error: $e');
      return [];
    }
  }

  Future<List<WorkTypeData>> fetchWorktype() async {
    try {
      String compId =
          Get.find<UserProfileController>().userData.value.result.companyId
              ?.toString() ??
          '';

      final resp = await ApiServices.getWorktype(companyId: compId);

      if (resp['status']?.toString() == "200") {
        WorkTypeResponse customerData = WorkTypeResponse.fromJson(resp);

        final workTypeList = customerData.data ?? [];
        return workTypeList;

        // return workTypeList
        //     .map((e) => e.name ?? '')
        //     .where((name) => name.isNotEmpty)
        //     .toList();
      }

      return [];
    } catch (e) {
      debugPrint('Customer list error: $e');
      return [];
    }
  }

}