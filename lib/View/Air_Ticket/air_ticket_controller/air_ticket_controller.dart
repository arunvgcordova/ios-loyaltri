
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loyaltri_minimal/View/Air_Ticket/AirTicketHome.dart';
import 'package:loyaltri_minimal/services/api_services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../controller/userAuthentication.dart';
import '../../../controller/userProfileController.dart';
import '../../../models/manager/air_ticket_list_api_model.dart';
import '../../../services/attachment_service.dart';
import '../../ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';

class AirTicketController extends GetxController {
  RxInt selectedFieldNumber = 0.obs; // for ui boarder (total 22)
  int currentTabIndex = 0;
  Rxn<RequestCardType> selectedTicketType = Rxn(null);
  RxBool expansionChanged = false.obs;
  UserProfileController userProfileController = Get.find<UserProfileController>();

  RxBool airTicketListLoading = false.obs;
  RxBool airTicketListLoaded = false.obs;
  RxBool airTicketListError = false.obs;
  RxList<AirTicketData> airTicketListCopy = <AirTicketData>[].obs;
  RxList<AirTicketData> airTicketList = <AirTicketData>[].obs;

  Future<void> fetchAirTicketCreatedList({required BuildContext context}) async {
    try {
      airTicketListLoading.value = true;
      airTicketListLoaded.value = false;
      airTicketListError.value = false;
      String companyId = userProfileController.currentCompany.value?.companyId?.toString() ?? userProfileController.userData.value.result.companyId.toString();
      String employeeId = Get.find<UserAuthController>().userData.value.userData?.employeeId ?? '--';
      var resp = await ApiServices.airTicketList(compId: companyId, empId: employeeId);
      if(resp['status']?.toString() == '200') {
        AirTicketListApi airTicketListApi = AirTicketListApi.fromJson(resp);
        airTicketListCopy.value = airTicketListApi.result?.data ?? [];
        airTicketList.value = airTicketListApi.result?.data ?? [];
        filterByStatus();
        airTicketListLoaded.value = true;
      } else {
        AttendanceCommonWidgets().showSnackBar(
          context: context,
          backgroundColor: Colors.red,
          message: resp['message']?.toString() ?? 'Something went wrong',
        );
      }
    } catch(e) {
      AttendanceCommonWidgets().printF('----------air ticket list error------------');
      airTicketListError.value = true;
      AttendanceCommonWidgets().showSnackBar(
        context: context,
        backgroundColor: Colors.red,
        message: 'Something went wrong',
      );
    } finally {
      airTicketListLoading.value = false;
    }
  }

  void filterByStatus() {
    switch(currentTabIndex) {
      case 1: airTicketList.value = airTicketListCopy.value.where((ticket) => ticket.reqStatusLabel?.toString().toLowerCase() == 'pending').toList();
      break;
      case 2: airTicketList.value = airTicketListCopy.value.where((ticket) => ticket.reqStatusLabel?.toString().toLowerCase() == 'approved').toList();
      break;
      case 3: airTicketList.value = airTicketListCopy.value.where((ticket) => ticket.reqStatusLabel?.toString().toLowerCase() == 'rejected').toList();
      break;
      default: airTicketList.value = airTicketListCopy.value;
      break;
    }
  }

  RxBool airTicketDetailsLoading = false.obs;
  Rxn<AirTicketDetails> airTicketDetails = Rxn(null);

  Future<void> fetchAirTicketDetails() async {
    try {
      airTicketDetailsLoading.value = true;
      String employeeId = Get.find<UserAuthController>().userData.value.userData?.employeeId ?? '--';
      var resp = await ApiServices.airTicketDetails(empId: employeeId);
      if(resp['status']?.toString() == '200') {
        AirTicketDetailsApi airTicketDetailsApi = AirTicketDetailsApi.fromJson(resp);
        airTicketDetails.value = airTicketDetailsApi.result;
        if(airTicketDetails.value?.policyRequestType?.isNotEmpty ?? false) {
          selectedTicketType.value = getDartTicketType(airTicketDetails.value?.policyRequestType?.first);
        }
        airTicketCreateData.value.employeePassport = Get.find<UserProfileController>().userData.value.result.passportNo;
        airTicketCreateData.value.passengerData = [];
        if((airTicketCreateData.value.passengerData?.isEmpty ?? false) && int.parse(airTicketDetails.value?.pocilyMaxDependents ?? "0") != 0) {
          airTicketCreateData.value.passengerData?.add(PassengerData(passengerType: 'Adult'));
        }
        airTicketCreateData.refresh();
      }
    } catch(e) {} finally {
      airTicketDetailsLoading.value = false;
    }
  }

  RequestCardType? getDartTicketType(String? ticketType) {
    switch(ticketType) {
      case 'reimbursement': return RequestCardType.reimbursement;
      case 'companyBooking': return RequestCardType.companyBooking;
      case 'encashment': return RequestCardType.encashment;
      default: return null;
    }
  }

  String? getStringTicketType(RequestCardType? ticketType) {
    switch(ticketType) {
      case RequestCardType.reimbursement: return 'reimbursement';
      case RequestCardType.companyBooking: return 'companyBooking';
      case RequestCardType.encashment: return 'encashment';
      default: return null;
    }
  }

  String? getTicketTypeName(RequestCardType? ticketType) {
    switch(ticketType) {
      case RequestCardType.reimbursement: return 'Reimbursement';
      case RequestCardType.companyBooking: return 'Company Booking';
      case RequestCardType.encashment: return 'Encashment';
      default: return null;
    }
  }

  RxBool requestingAirTicket = false.obs;
  Rx<AirTicketCreatingModel> airTicketCreateData = AirTicketCreatingModel().obs;

  Future<void> requestForAirTicket(BuildContext context) async {
    try {
      requestingAirTicket.value = true;
      String companyId = userProfileController.currentCompany.value?.companyId?.toString() ?? userProfileController.userData.value.result.companyId.toString();
      String employeeId = Get.find<UserAuthController>().userData.value.userData?.employeeId ?? '--';
      airTicketCreateData.value.companyId = companyId;
      airTicketCreateData.value.reqEmployeeId = employeeId;
      airTicketCreateData.value.createdBy = employeeId;
      airTicketCreateData.value.isActive = 1;
      airTicketCreateData.value.reqType = getStringTicketType(selectedTicketType.value);
      // AttendanceCommonWidgets().printF("-------airTicketCreateData------${airTicketCreateData.value.toJson()}");
      var resp = await ApiServices.airTicketBooking(airTicketCreate: airTicketCreateData.value, selectedFiles: AttachmentService().selectedFiles.value);
      AttendanceCommonWidgets().printF("----------air ticket resp--------------$resp");
      if(resp['status']?.toString() == '200') {
        await fetchAirTicketCreatedList(context: context);
        // AttendanceCommonWidgets().showSnackBar(
        //   context: context,
        //   backgroundColor: Colors.green,
        //   message: resp['message']?.toString() ?? 'Air Ticket Request Send',
        // );
        Get.snackbar(
          'Success',
          resp['message']?.toString() ?? 'Air Ticket Request Send',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Navigator.of(context).pop();
      } else {
        Get.snackbar(
          'Failed',
          resp['message']?.toString() ?? 'Something went wrong',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch(e) {
      Get.snackbar(
        'Failed',
        'Something went wrong',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      requestingAirTicket.value = false;
    }
  }

  RxBool fileDownloading = false.obs;

  Future<void> downloadMultipleFiles(List<String> urls) async {
    fileDownloading.value = true;
    int successCount = 0;
    int failureCount = 0;

    for (final url in urls) {
      try {
        await downloadFile(url);
        successCount++;
      } catch (e) {
        failureCount++;
        AttendanceCommonWidgets().printF('Download failed for $url: $e');
      }
    }

    // Show snackbar based on result
    if (successCount > 0 && failureCount == 0) {
      Get.snackbar(
        'Download Complete',
        'Downloaded $successCount file${successCount > 1 ? 's' : ''} successfully.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: EdgeInsets.only(bottom: 5.h),
      );
    } else if (successCount > 0 && failureCount > 0) {
      Get.snackbar(
        'Partial Success',
        'Downloaded $successCount file${successCount > 1 ? 's' : ''}, failed $failureCount.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        margin: EdgeInsets.only(bottom: 5.h),
      );
    } else {
      Get.snackbar(
        'Download Failed',
        'File download failed.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: EdgeInsets.only(bottom: 5.h),
      );
    }
    fileDownloading.value = false;
  }

  Future<void> downloadFile(String url) async {
    await requestStoragePermission();

    final dirPath = await getDownloadPath();
    final originalName = getFileNameFromUrl(url);
    final filename = getUniqueFileName(originalName);
    final filePath = '$dirPath/$filename';

    // try {
      final dio = Dio();
      await dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            AttendanceCommonWidgets().printF('${(received / total * 100).toStringAsFixed(0)}% downloaded');
          }
        },
      );

    //   print("✅ Download completed: $filePath");
    // } catch (e) {
    //   print("❌ Download failed: $e");
    // }
  }

  Future<String> getDownloadPath() async {
    if (Platform.isAndroid) {
      Directory? directory = Directory('/storage/emulated/0/Download');
      if (await directory.exists()) {
        return directory.path;
      } else {
        directory = await getExternalStorageDirectory(); // fallback
        return directory!.path;
      }
    } else if (Platform.isIOS) {
      // iOS doesn't have a Downloads folder; use app document directory
      Directory directory = await getApplicationDocumentsDirectory();
      return directory.path;
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  Future<void> requestStoragePermission() async {
    if (await Permission.storage.isDenied) {
      await Permission.storage.request();
    }
  }

  String getUniqueFileName(String filename) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return filename.replaceAllMapped(RegExp(r'(\.\w+)$'), (match) {
      return '_$timestamp${match[1]}';
    });
  }

  String getFileNameFromUrl(String url) {
    Uri uri = Uri.parse(url);
    return uri.pathSegments.isNotEmpty ? uri.pathSegments.last : 'file_${DateTime.now().millisecondsSinceEpoch}';
  }
}