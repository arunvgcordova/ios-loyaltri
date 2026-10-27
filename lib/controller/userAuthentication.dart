import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyaltri_minimal/View/CWidgets/cwidgets.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Request/request_wigets_manager/letter_request_bottomSheet.dart';
import 'package:loyaltri_minimal/View/field/features/tracking/services/database_services.dart';
import 'package:loyaltri_minimal/View/field/features/tracking/tracker_controller.dart';
import 'package:loyaltri_minimal/controller/ui_controller/home_controller.dart';
import 'package:loyaltri_minimal/controller/ui_controller/page_controller.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';
import 'package:loyaltri_minimal/models/task_api_models.dart';
import 'package:loyaltri_minimal/models/user_profile_api_model.dart';
import '../View/CWidgets/error_dialog.dart';
import '../View/Leave_Page/leave_widgets/success_dialogue.dart';
import '../View/Login/Login_Screen.dart';
import '../models/checkIn_model.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import '../models/user_api_model.dart';
import '../services/api_services.dart';
import '../services/controller_handling.dart';
import '../services/flutter_secure_storage.dart';
import '../sqflite_db/punch_db.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;

class UserAuthController extends GetxController with WidgetsBindingObserver {
  Rx<bool> isLoading = false.obs;
  Rx<bool> dataLoaded = false.obs;
  Rx<bool> isPinError = false.obs;
  Rx<bool> isNetworkError = false.obs;
  Rx<bool> isError = false.obs;
  Rx<String?> errorMessage = Rx(null);
  Rx<UserAPI> userData = const UserAPI().obs;
  Rx<bool> restrictRsInfo = false.obs;
  Rx<bool> postFeedComment = false.obs;
  Rx<bool> fieldAccess = false.obs;
  Rx<bool> allowUploadDocument = false.obs;
  Rx<bool> postFeed = false.obs;

  bool get offlineMode => userData.value.userData?.offlineMode ?? false;

  bool _isFetchingToken = false;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    tokenTimer?.cancel();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      if (userData.value.userData?.employeeId != null &&
          userData.value.userData!.employeeId!.isNotEmpty) {
        debugPrint('App resumed, refreshing token immediately...');
        try {
          tokenTimer?.cancel();
          tokenTimer = null;
          await fetchTokenContinues();
        } catch (e) {
          debugPrint('Error refreshing token on app resume: $e');
        }
      }
    }
  }

  void resetStatus() {
    isPinError.value = false;
    isNetworkError.value = false;
    isLoading.value = false;
    isError.value = false;
  }

  Future fetchUserData({
    required String username,
    required String password,
  }) async {
    isLoading.value = true;
    try {
      Map<String, dynamic> resp = await ApiServices.userLogin(
        userName: username,
        psw: password,
        thirdPartyLogin: 0,
      );
      userData.value = UserAPI.fromJson(resp);
      if (userData.value.status ?? false) {
        await SecureStorageUtils().setUserData(resp);
        dataLoaded.value = true;
      } else {
        dataLoaded.value = false;
        errorMessage.value = resp['message'] ?? "Login Failed!";
        throw Exception(resp['message']);
      }
    } catch (e) {
      isError.value = true;
      dataLoaded.value = false;
      if (e.toString().contains("Exception")) {
        errorMessage.value = e.toString().replaceAll("Exception:", "");
      } else {
        errorMessage.value = "Something went wrong";
      }
      AttendanceCommonWidgets().printF(
        "------login error-------${e.toString()}",
      );
    } finally {
      resetStatus();
    }
  }

  Future fetchUser({required UserAPI user}) async {
    isLoading.value = true;
    try {
      userData.value = user;
      dataLoaded.value = true;
    } catch (e) {
      isError.value = true;
      AttendanceCommonWidgets().printF(
        "------login error-------${e.toString()}",
      );
    } finally {
      resetStatus();
    }
  }

  RxBool logOutLoading = false.obs;

  Future<void> logOut(BuildContext context, {bool? forceLogout}) async {
    try {
      logOutLoading.value = true;
      File file = Get.find<UserProfileController>().profileImageLocation.value;
      List<AttendanceCheckModel> punchData = await PunchDatabase.instance
          .readUncSyncPunchData();
      if (punchData.isNotEmpty && !(forceLogout ?? false)) {
        ErrorDialog().syncPopUp(
          title: "Please Sync Attendance Data",
          mainContext: context,
        );
      } else {
        uiNotifier.value = AppView.employee;
        try {
          String? empId = Get.find<UserAuthController>()
              .userData
              .value
              .userData
              ?.employeeId;
          String? lastTime = DateTime.now().toString();
          await ApiServices.versionCheck(
            empId: empId,
            deviceId: null,
            fcmToken: null,
            lastTime: lastTime,
            logoutChecker: null,
          ).timeout(Duration(seconds: 10));
          Get.find<UserAuthController>().tokenTimer?.cancel();
        } catch (e) {}
        if (await file.exists()) {
          await file.delete();
        }
        await SecureStorageUtils().removeUserData();
        await SecureStorageUtils().removeProfileData();
        await SecureStorageUtils().removePunchTypeData();
        await SecureStorageUtils().removeErrorOccurs();
        await PunchDatabase.instance.deleteTable();
        // Loyaltri Field //
        try {
          if (Get.isRegistered<TrackingController>()) {
            final trackingCtr = Get.find<TrackingController>();
            // Reset working state to prevent early return in any calls
            trackingCtr.isWorking.value = false;
            await trackingCtr.clearLogs();
          }
          await bg.BackgroundGeolocation.stop();
          await DatabaseService.instance.clearAllDatabase();
        } catch (e) {
          debugPrint('Error clearing tracking logs or stopping services on logout: $e');
        }
        // Loyaltri Field //
        HandleControllers.deleteAllGetControllers();
        HandleControllers.createGetControllers();
        Navigator.of(context).pushAndRemoveUntil(
          newSlideNavigation(const LoginScreen()),
              (route) => false,
        );
      }
    } catch (e) {
    } finally {
      logOutLoading.value = false;
    }
  }

  Rx<bool> forgetLoading = false.obs;

  Future<bool?> sendMail({
    required String emailId,
    required BuildContext context,
  }) async {
    forgetLoading.value = true;
    try {
      final resp = await ApiServices.forgotPassword(email: emailId);

      if (resp['status']?.toString() == '200') {
        await ShowSuccessDialog().showSuccess(
          context: context,
          title: 'Successful',
          subTitle: resp['message'],
        );
        forgetLoading.value = false;
        return true;
      } else {
        await ShowSuccessDialog().showSuccess(
          context: context,
          title: 'Successful',
          subTitle: resp['message'],
        );
        forgetLoading.value = false;
        return true;
      }
    } catch (e) {
      final isNoInternet = e.toString().contains("NO_INTERNET");

      await ErrorDialog().showWarn(
        context: context,
        title: isNoInternet
            ? "Please check your network connection and try again."
            : "Something went wrong",
      );
    } finally {
      forgetLoading.value = false;
    }
    return null;
  }

  RxBool changePswLoader = false.obs;

  Future<TaskDashCountModel?> changePassword({
    String? oldP,
    String? newP,
  }) async {
    try {
      changePswLoader.value = true;
      final resp = await ApiServices.changePassword(
        empId: userData.value.userData?.employeeId,
        oldPsw: oldP,
        newPsw: newP,
      );
      debugPrint('----------resp---------$resp');
      if (resp['status']?.toString() == '200') {
        return TaskDashCountModel(
          status: 200,
          message: resp['message'] ?? 'Password Changed',
        );
      } else {
        return TaskDashCountModel(
          status: 0,
          message: resp['message'] ?? resp['error'] ?? 'Something went wrong',
        );
      }
    } catch (e, stackTrace) {
      debugPrint('Change password error: $e');
      debugPrint('StackTrace: $stackTrace');

      return TaskDashCountModel(
        status: 0,
        message: 'Something went wrong',
      );
    } finally {
      changePswLoader.value = false;
    }
  }

  Timer? tokenTimer;

  Future<void> fetchTokenContinues() async {
    if (_isFetchingToken) return;
    _isFetchingToken = true;
    try {
      UserProfileController userProfileController = Get.find<UserProfileController>();
      String? companyId = userProfileController.userData.value.result.companyId;
      if(companyId == null) {
        UserProfileApiModel? profileData = await SecureStorageUtils().getProfileData();
        if(profileData != null) {
          userProfileController.userData.value = profileData;
          companyId = profileData.result.companyId;
        }
      }
      var initResp;
      try {
        initResp = await ApiServices.getToken(username: userData.value.userData?.email, compId: companyId).timeout(Duration(seconds: 15));
      } catch(e) {}
      if(initResp?['result'] != null && initResp?['result'] is String && (initResp?['result'].toString().trim().isNotEmpty ?? false)) {
        userData.value.userData?.token = initResp?['result'];
        await SecureStorageUtils().removeUserData();
        await SecureStorageUtils().setUserData(userData.value.toJson());
        userData.refresh();
      }
      tokenTimer ??= Timer.periodic(Duration(minutes: 20), (timer) async {
        try {
          final resp = await ApiServices.getToken(username: userData.value.userData?.email, compId: companyId);
          if(resp?['result'] != null && resp?['result'] is String && (resp?['result'].toString().trim().isNotEmpty ?? false)) {
            userData.value.userData?.token = resp?['result'];
            await SecureStorageUtils().removeUserData();
            await SecureStorageUtils().setUserData(userData.value.toJson());
            userData.refresh();
          }
        } catch (e) {
          debugPrint("Error fetching token periodically: $e");
        }
      });
    } finally {
      _isFetchingToken = false;
    }
  }
}