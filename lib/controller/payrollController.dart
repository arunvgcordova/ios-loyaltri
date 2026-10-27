

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/controller/userAuthentication.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';
import 'package:loyaltri_minimal/models/payroll_model.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import '../services/api_services.dart';
import 'package:http/http.dart' as http;

class PayrollController extends GetxController {
  Rx<bool> isLoading = false.obs;
  Rx<bool> dataLoaded = false.obs;
  Rx<bool> isError = false.obs;
  Rx<bool> salaryShow = false.obs;
  Rx<double> netSalary = 0.0.obs;
  Rx<String> amount1 = "--".obs;
  Rx<String> amount2 = "--".obs;

  late Rx<PayrollModel> payrollApi = PayrollModel().obs;
  Rx<SalaryData> salaryData = SalaryData().obs;

  void resetStatus() {
    isLoading.value = false;
    isError.value = false;
    salaryShow.value = false;
    paySlipDownloading.value = false;
  }

  void resetData() {
    payrollApi.value = PayrollModel();
    salaryData.value = SalaryData();
    netSalary.value = 0;
    amount1.value = "--";
    amount2.value = "--";
    dataLoaded.value = false;
    isLoading.value = false;
    isError.value = false;
    salaryShow.value = false;
    paySlipDownloading.value = false;
  }

  Future<void> fetchPayrollData({required String compId, required String empId, required DateTime dateTime}) async {
    isLoading.value = true;
    resetData();
    String monthYear = DateFormat('MMMM yyyy').format(dateTime);
    try {
      Map<String, dynamic> resp = await ApiServices.getPayrollData(compId: compId, empId: empId, monthYear: monthYear);
      if(resp['status'] == 200) {
        payrollApi.value = PayrollModel.fromJson(resp);
        if(payrollApi.value.result!.isNotEmpty) {
          salaryData.value = payrollApi.value.result!.first;
          netSalary.value = salaryData.value.netSalary ?? 0.0;
          String salary = netSalary.value.toStringAsFixed(2);
          if(netSalary.value != 0) {
            amount1.value = salary.substring(0, 2);
            amount2.value = salary.substring(2);
          }
          // String formattedNumber = _formatIndianNumber(netSalary.value);
          // List<String> parts = formattedNumber.split(",");
          // amount1.value = netSalary.value != 0.0 ? parts.first : "--";
          // if(parts.length != 1) {
          //   amount2.value = parts.skip(1).join(",");
          // } else {
          //   amount2.value = "";
          // }
        }
        dataLoaded.value = true;
        // await SharedPrefs().setUserData(resp);
      }
    } catch(e) {
      isError.value = true;
      dataLoaded.value = false;
      AttendanceCommonWidgets().printF("------payroll error-------${e.toString()}");
    } finally {
      resetStatus();
    }
  }

  RxBool paySlipDownloading = false.obs;

  Future<void> downloadPaySlip({required DateTime monthYr}) async {
    if(paySlipDownloading.value) return;
    try {
      paySlipDownloading.value = true;
      String monthYear = DateFormat('yyyy-MM').format(monthYr);
      // String compId = Get.find<UserProfileController>().userData.value.result.companyId?.toString() ?? '';
      // String empId = Get.find<UserAuthController>().userData.value.userData?.employeeId ?? '';
      String path = await downloadFile(payrollApi.value.result?.first.paySlipUrl ?? '', 'paySlip$monthYear');
      // Uint8List resp = await _apiServices.getPaySlip(compId: compId, empId: empId, monthYear: monthYear);
      // final dir = await getApplicationDocumentsDirectory();
      // final file = File("${dir.path}/paySlip.pdf");
      OpenFile.open(path);
      // await file.writeAsBytes(resp);
      debugPrint('--------payslip resp------$path');
    } catch(e) {
      debugPrint('--------payslip error------${e.toString()}');
    } finally {
      paySlipDownloading.value = false;
    }
  }

  setSalary() {
    salaryShow.value = !salaryShow.value;
  }

  String _formatIndianNumber(num number) {
    String numberStr = number.toString();
    int length = numberStr.length;

    if (length <= 3) {
      return numberStr;
    } else if (length <= 5) {
      return '${numberStr.substring(0, length - 3)},${numberStr.substring(length - 3)}';
    } else {
      String last3Digits = numberStr.substring(length - 3);
      String restDigits = numberStr.substring(0, length - 3);
      String formattedNumber = '';

      while (restDigits.length > 2) {
        formattedNumber = ',${restDigits.substring(restDigits.length - 2)}$formattedNumber';
        restDigits = restDigits.substring(0, restDigits.length - 2);
      }

      formattedNumber = '$restDigits$formattedNumber,$last3Digits';
      return formattedNumber;
    }
  }

  Future<String> downloadFile(String url, String filename) async {
    // 1. Send request
    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception("Failed to download file: ${response.statusCode}");
    }

    String? contentType = response.headers['content-type'];

    String ext = _extensionFromContentType(contentType);

    // 2. Get app directory path
    final dir = await getApplicationDocumentsDirectory();
    final filePath = "${dir.path}/$filename$ext";

    // 3. Save bytes to file
    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);

    return file.path;
  }

  String _extensionFromContentType(String? contentType) {
    if (contentType == null) return "";

    final map = {
      "image/jpeg": ".jpg",
      "image/png": ".png",
      "application/pdf": ".pdf",
      "audio/mpeg": ".mp3",
      "audio/ogg": ".ogg",
      "video/mp4": ".mp4",
    };

    return map[contentType] ?? "";
  }
}