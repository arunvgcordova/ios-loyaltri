import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loyaltri_minimal/View/ManagerView/Feed_Page/feed_view_controller/feed_view_controller.dart';
import 'package:loyaltri_minimal/controller/WorkEntryListController.dart';
import 'package:loyaltri_minimal/controller/attSummaryController.dart';
import 'package:loyaltri_minimal/controller/attendanceListController.dart';
import 'package:loyaltri_minimal/controller/calendarEventsController.dart';
import 'package:loyaltri_minimal/controller/checkInController.dart';
import 'package:loyaltri_minimal/controller/punchTypeController.dart';
import 'package:loyaltri_minimal/controller/ui_controller/home_controller.dart';
import 'package:loyaltri_minimal/controller/ui_controller/page_controller.dart';
import 'package:loyaltri_minimal/controller/userAuthentication.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';
import 'package:loyaltri_minimal/sqflite_db/punch_db.dart';

import '../View/Growth/growth_controller/growth_controller.dart';
import '../View/ManagerView/Manager_Attendance/manager_attendance_controller/manager_attendance_controller.dart';
import '../View/ManagerView/Manager_Employee/employee_page_controller/employee_page_controller.dart';
import '../View/ManagerView/Manager_Home/manager_home_controller/manager_home_controller.dart';
import '../View/ManagerView/Manager_Task/task_controller/task_controller.dart';
import '../models/checkIn_model.dart';
import '../services/connectivity_service.dart';
import 'attendanceUploadController.dart';
import 'leaveTypeController.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  RxBool showSnackBar = false.obs;

  void networkListener() {
    _connectivity.onConnectivityChanged.listen(
          (event) async {
        if(Get.find<UserAuthController>().userData.value.userData == null) {
          Timer.periodic(Duration(milliseconds: 500), (timer) async {
            if(Get.find<UserAuthController>().userData.value.userData != null) {
              timer.cancel();
              await _handleConnectivityUpdate();
            }
          });
          if (Get.isSnackbarOpen) {
            showSnackBar.value = false;
            Get.closeCurrentSnackbar();
          }
          return;
        }
        await _handleConnectivityUpdate();
      },
    );
  }

  Future<void> _handleConnectivityUpdate() async {
    bool offlineMode = false;
    try {
      offlineMode = Get.find<UserAuthController>().offlineMode;
    } catch (_) {}

    if (!offlineMode) {
      if (Get.isSnackbarOpen) {
        showSnackBar.value = false;
        Get.closeCurrentSnackbar();
      }
      return;
    }

    bool hasInternet = true;
    if (offlineMode) {
      bool hardwareConnection = await ConnectivityService().check();
      if (!hardwareConnection) {
        hasInternet = false;
      } else {
        hasInternet = await ConnectivityService.goodConnection();
      }
    }
    _updateConnectivityStatus(hasInternet);
  }

  void _updateConnectivityStatus(bool connectivityResult) async {
    if (!connectivityResult) {
      showSnackBar.value = true;
      Get.rawSnackbar(
          messageText: GetX<NetworkController>(
            builder: (controller) {
              return Container(
                padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                color: showSnackBar.value ? Colors.black : Colors.green,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if(showSnackBar.value)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 15.h,
                            width: 15.h,
                            child: Image.asset(
                              "assets/images/no_internet.png",
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(width: 8.h),
                        ],
                      ),
                    Text(
                      showSnackBar.value
                          ? "Please connect to the internet"
                          : "Online",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 12.h,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          duration: Duration(days: 1),
          // icon: Icon(
          //   Icons.signal_cellular_off,
          //   color: ColorUtil.grey,
          //   size: 10,
          // ),
          snackStyle: SnackStyle.GROUNDED,
          isDismissible: false,
          snackPosition: SnackPosition.BOTTOM,
          // backgroundColor: showSnackBar.value ? ColorUtil.black : ColorUtil.green,
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero
        // padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      );
    } else {
      if (Get.isSnackbarOpen) {
        showSnackBar.value = false;
        await refreshData();
      }
    }
  }

  Future<void> refreshData() async {
    if (Get.context != null) {
      Get.context!.loaderOverlay.show();
    }
    await Future.delayed(const Duration(milliseconds: 500));
    if (Get.isSnackbarOpen) {
      showSnackBar.value = false;
      Get.closeCurrentSnackbar();
    }
    List<AttendanceCheckModel> unSyncData = await PunchDatabase.instance.readUncSyncPunchData();
    if(unSyncData.isNotEmpty) {
      await Get.find<AttendanceUploadController>().sendAttendance();
    }
    String employeeId = Get.find<UserAuthController>().userData.value.userData?.employeeId ?? '';
    String companyId = Get.find<UserProfileController>().userData.value.result.companyId?.toString() ?? '';
    String managerCompanyId = Get.find<UserProfileController>().userData.value.result.companyId?.toString() ?? '';
    AppView appView = Get.find<UserPageController>().appView.value;
    if(appView == AppView.manager) {
      managerCompanyId = Get.find<UserProfileController>().currentCompany.value?.companyId?.toString() ?? Get.find<UserProfileController>().userData.value.result.companyId?.toString() ?? '';
    }
    DateTime dateTime = DateTime.now();

    if(employeeId.isNotEmpty && companyId.isNotEmpty) {
      await Get.find<UserAuthController>().fetchTokenContinues();
      if(appView == AppView.employee) {
        await Get.find<CheckInController>().getCheckInData(compId: companyId, empId: employeeId);
        await Get.find<HomeController>().getTimer();
        await Get.find<PunchTypeController>().checkPunchType(empId: employeeId, compId: companyId);

        if (Get.context != null) {
          Get.context!.loaderOverlay.hide();
        }
      }

      if(appView == AppView.manager) {
        await Get.find<ManagerHomeController>().fetchActionCentre();
        await Get.find<ManagerAttendanceController>().fetchNextSevenDaysLeave();
      }

      await Get.find<UserProfileController>().fetchAllNotifications();

      if(Get.find<UserAuthController>().userData.value.userData?.loginType == 2 || Get.find<UserAuthController>().userData.value.userData?.loginType == 3) {
        await Get.find<UserProfileController>().fetchAllCompanyList();

        if (Get.context != null) {
          Get.context!.loaderOverlay.hide();
        }
      }

      if(appView == AppView.manager) {
        ManagerAttendanceController managerAttendanceController = Get.find<ManagerAttendanceController>();
        String formated = DateFormat('yyyy-MM-dd').format(managerAttendanceController.dateList.value[managerAttendanceController.currentDateIndex.value]);
        await Get.find<ManagerAttendanceController>().fetchManagerAttSummary(
          date: formated,
        );
        await Get.find<ManagerAttendanceController>().fetchManagerAttDetails(
          date: formated,
        );
      }
      ManagerTaskController managerTaskController = Get.find<ManagerTaskController>();
      await Get.find<ManagerEmployeeController>().fetchAllEmployee(isAll: Get.find<UserAuthController>().userData.value.userData?.unrestrictedList ?? false);
      await managerTaskController.fetchTaskDashboardCount(compId: managerCompanyId, empId: employeeId);
      await managerTaskController.fetchTaskListData(compId: managerCompanyId, empId: employeeId);

      await Get.find<WorkEntryListController>().fetchWorkEntryList(month: dateTime, empId: employeeId);
      if(appView == AppView.employee) {
        GrowthController growthController = Get.find<GrowthController>();
        await Get.find<CalendarEventController>().fetchCalendarData(empId: employeeId, monthYear: DateFormat('yyyy-MM').format(DateTime.now()));
        await growthController.fetchMissionVision();
        await growthController.fetchProgressData();
        await growthController.fetchEvaluationList();
        // bool showGoals = (Get.find<UserAuthController>().userData.value.userData?.isGrowthModule ?? false) && (Get.find<UserAuthController>().userData.value.userData?.permissions?.contains(166) ?? false);
        // if(showGoals) {
        //   await growthController.fetchGoalsAndSubGoals();
        // }
      }
      await Get.find<AttendanceList>().fetchMonthCycleData(compId: companyId);
      await Get.find<AttendanceList>().fetchAttendanceList(empId: employeeId, compId: companyId);
      await Get.find<FeedViewController>().fetchFeedListUser(loadMore: false);
      await Get.find<AttendanceSummaryController>().getAttendanceSummary(empId: employeeId, compId: companyId);
    }
  }
}