import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loyaltri_minimal/View/CWidgets/error_dialog.dart';
import 'package:loyaltri_minimal/View/Growth/growth_controller/growth_controller.dart';
import 'package:loyaltri_minimal/View/Login/Login_Screen.dart';
import 'package:loyaltri_minimal/View/ManagerView/Feed_Page/feed_view_controller/feed_view_controller.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/manager_attendance_controller/manager_attendance_controller.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Home/manager_home_controller/manager_home_controller.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Task/task_controller/task_controller.dart';
import 'package:loyaltri_minimal/View/field/features/time_line/controller/timeline_controller.dart';
import 'package:loyaltri_minimal/View/field/features/tracking/services/track_v2_uploader.dart';
import 'package:loyaltri_minimal/View/field/features/tracking/tracker_controller.dart';
import 'package:loyaltri_minimal/View/field/features/widgets/location_always_permission_dialog.dart';
import 'package:loyaltri_minimal/View/field/features/widgets/physicalActivityPermissionDialog.dart';
import 'package:loyaltri_minimal/controller/leaveTypeController.dart';
import 'package:loyaltri_minimal/controller/payrollController.dart';
import 'package:loyaltri_minimal/controller/ui_controller/page_controller.dart';
import 'package:loyaltri_minimal/controller/versionCheckController.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import '../../View/ManagerView/Manager_Employee/employee_page_controller/employee_page_controller.dart';
import '../../View/field/features/work_log/model/work_log_response.dart';
import '../../services/api_services.dart';
import '../../services/connectivity_service.dart';
import '../../services/flutter_secure_storage.dart';
import '../../services/warning_message.dart';
import '../WorkEntryListController.dart';
import '../attSummaryController.dart';
import '../attendanceListController.dart';
import '../calendarEventsController.dart';
import '../checkInController.dart';
import '../locationFetchController.dart';
import '../punchTypeController.dart';
import '../userAuthentication.dart';
import '../userProfileController.dart';
import '../work_expence_controller.dart';

enum AppView { employee, manager }

class HomeController extends GetxController {
  Rx<bool> isLoading = false.obs;
  Rx<bool> dataLoaded = false.obs;
  Rx<bool> isError = false.obs;
  Rx<String> punchTime = "".obs;
  final UserAuthController userAuthController = Get.find<UserAuthController>();
  final UserProfileController userProfileController =
      Get.find<UserProfileController>();
  final PunchTypeController punchTypeController =
      Get.find<PunchTypeController>();
  WorkEntryListController workEntryListController =
      Get.find<WorkEntryListController>();
  CalendarEventController calendarEventController =
      Get.find<CalendarEventController>();
  CheckInController checkInController = Get.find<CheckInController>();
  AttendanceSummaryController attendanceSummaryController =
      Get.find<AttendanceSummaryController>();
  FeedViewController feedViewController = Get.find<FeedViewController>();
  AttendanceList attendanceListController = Get.find<AttendanceList>();
  WorkExpenseController workExpenseController =
      Get.find<WorkExpenseController>();
  PayrollController payrollController = Get.find<PayrollController>();
  LocationFetchController locationFetchController =
      Get.find<LocationFetchController>();
  VersionCheckController versionCheckController =
      Get.find<VersionCheckController>();

  void resetStatus() {
    isLoading.value = false;
    isError.value = false;
  }

  Future<void> getHomeData(BuildContext context, {bool? fromPopUp}) async {
    isLoading.value = true;
    context.loaderOverlay.show();
    try {
      UserPageController userPageController = Get.find<UserPageController>();
      AppView appView = userPageController.appView.value;
      if (appView == AppView.manager) {
        Get.find<ManagerTaskController>().taskLoading.value = true;
        Get.find<ManagerAttendanceController>().summaryLoading.value = true;
        Get.find<ManagerAttendanceController>().attDetailsLoading.value = true;
        Get.find<ManagerEmployeeController>().allEmployeeLoading.value = true;
        feedViewController.feedLoading.value = true;
      }
      await locationFetchController.initialize();

      // await versionCheckController.checkVersionUpdates();
      String employeeId =
          userAuthController.userData.value.userData?.employeeId ?? '--';
      DateTime dateTime = DateTime.now();
      String formattedYrMonth = DateFormat('yyyy-MM').format(dateTime);

      await userAuthController.fetchTokenContinues();
      await userProfileController.fetchUserData(empId: employeeId);

      String companyId = userProfileController.userData.value.result.companyId
          .toString();
      String managerCompanyId = userProfileController
          .userData
          .value
          .result
          .companyId
          .toString();
      if (appView == AppView.manager) {
        managerCompanyId =
            userProfileController.currentCompany.value?.companyId?.toString() ??
            userProfileController.userData.value.result.companyId.toString();
      }
      AttendanceCommonWidgets().printF("-------companyId--------$companyId");

      if (appView == AppView.manager) {
        await Get.find<ManagerHomeController>().fetchActionCentre();
        await Get.find<ManagerAttendanceController>().fetchNextSevenDaysLeave();
        if (context.mounted && userPageController.currentIndex.value != 2)
          context.loaderOverlay.hide();
        if (fromPopUp ?? false) {
          if (context.mounted) Navigator.of(context).pop();
        }
      }

      // bool connection = await ConnectivityService().check();
      // if(!connection) {
      //   // Get.offAll(() => const InternetWarningMessage());
      //   context.loaderOverlay.hide();
      //   await ErrorDialog().internetWarn(
      //       context: context,
      //     title: "No Internet Connection",
      //     subTitle: "Please check if your connection is stable.",
      //   );
      // } else {

      if (appView == AppView.employee) {
        await checkInController.getCheckInData(
          compId: companyId,
          empId: employeeId,
        );

        await getTimer(context: context);

        await punchTypeController.checkPunchType(
          empId: employeeId,
          compId: companyId,
        );
      }

      if (!(fromPopUp ?? false)) {
        if (userPageController.currentIndex.value != 2) context.loaderOverlay.hide();
      }

      if (appView == AppView.employee) {
        bool fieldAccess = Get.find<UserAuthController>().fieldAccess.value;
        if (fieldAccess) {
          await fetchWorkLogByDate(date: DateTime.now());
        }
        GrowthController growthController = Get.find<GrowthController>();
        await calendarEventController.fetchCalendarData(
          empId: employeeId,
          monthYear: DateFormat('yyyy-MM').format(DateTime.now()),
        );
        await growthController.fetchMissionVision();
        await growthController.fetchProgressData();
        await growthController.fetchEvaluationList();
        // bool showGoals =
        //     (Get.find<UserAuthController>()
        //             .userData
        //             .value
        //             .userData
        //             ?.isGrowthModule ??
        //         false) &&
        //     (Get.find<UserAuthController>().userData.value.userData?.permissions
        //             ?.contains(166) ??
        //         false);
        // if (showGoals) {
        //   await growthController.fetchGoalsAndSubGoals();
        // }
      }

      userProfileController.fetchAllNotifications();

      if (userAuthController.userData.value.userData?.loginType == 2 ||
          userAuthController.userData.value.userData?.loginType == 3) {
        if (!(fromPopUp ?? false)) {
          await userProfileController.fetchAllCompanyList();
        }
      }

      ManagerTaskController managerTaskController =
          Get.find<ManagerTaskController>();
      await managerTaskController.fetchTaskDashboardCount(
        compId: managerCompanyId,
        empId: employeeId,
      );
      await managerTaskController.fetchTaskListData(
        compId: managerCompanyId,
        empId: employeeId,
      );
      // commented because this api call added in menu button
      // if(appView == AppView.manager) {
      //   ManagerAttendanceController managerAttendanceController = Get.find<ManagerAttendanceController>();
      //   String formated = DateFormat('yyyy-MM-dd').format(managerAttendanceController.dateList.value[managerAttendanceController.currentDateIndex.value]);
      //   await managerAttendanceController.fetchManagerAttSummary(
      //     date: formated,
      //   );
      //   await managerAttendanceController.fetchManagerAttDetails(
      //     date: formated,
      //   );
      // }
      // commented because added the api call in menu button click
      // await Get.find<ManagerEmployeeController>().fetchAllEmployee(isAll: userAuthController.userData.value.userData?.unrestrictedList ?? false);

      // commented because added the api call in menu button click
      // if(appView == AppView.employee) {
      //   await workEntryListController.fetchWorkEntryList(month: dateTime, empId: employeeId);
      //   await attendanceListController.fetchMonthCycleData(compId: companyId);
      //   await attendanceListController.fetchAttendanceList(empId: employeeId, compId: companyId);
      //   await attendanceSummaryController.getAttendanceSummary(empId: employeeId, compId: companyId);
      //   await Get.find<LeaveTypeController>().fetchLeaveType(compId: Get.find<UserProfileController>().userData.value.result.companyId?.toString() ?? '', empId: employeeId);
      // }

      // await feedViewController.fetchFeedListUser(loadMore: false);
      if (appView == AppView.employee) {
        await workExpenseController.fetchWorkExpenseCategory();
        String formatted = DateFormat('MMMM yyyy').format(DateTime.now());
        await workExpenseController.fetchWorkExpenseList(
          compId: companyId,
          empId: employeeId,
          monthYear: formatted,
        );
      }
      final resp = await versionCheckController.checkVersionUpdates();
      bool fieldAccess = Get.find<UserAuthController>().fieldAccess.value;
      if (fieldAccess) {
        await versionCheckController.sentDeviceInfo();
      }

      if (resp == true) {
        await Get.find<UserAuthController>().logOut(context, forceLogout: true);
      }
      // if(appView == AppView.employee) {
      //   await payrollController.fetchPayrollData(compId: companyId, empId: employeeId, dateTime: dateTime);
      // }

      dataLoaded.value = true;
      // }
    } catch (e) {
      dataLoaded.value = false;
    } finally {
      if (!(fromPopUp ?? false)) {
        if (context.mounted) context.loaderOverlay.hide();
      }
      resetStatus();
    }
  }

  Future<void> getTimer({BuildContext? context}) async {
    final SecureStorageUtils prefs = SecureStorageUtils();
    punchTime.value = await prefs.getString("punch") ?? "";
    bool fieldAccess = Get.find<UserAuthController>().fieldAccess.value;

    if (!fieldAccess) return;

    userProfileController.serviceActions.value = userProfileController
        .getActionList();
    if (punchTime.value != "") {
      //---------field-----------
      try {
        await TrackV2Uploader.openShift();
        final bgState = await bg.BackgroundGeolocation.state;
        if (!bgState.enabled) {
          bool canStart = true;
          bool location = true;

          if (Platform.isAndroid) {
            if(context != null) context.loaderOverlay.hide();
            canStart =
                await ActivityPermissionHelper.checkAndRequestPermission();
            location =
                await LocationAlwaysPermissionHelper.checkAndRequestPermission(
                  context: context,
                );
            if(context != null) context.loaderOverlay.show();
          }

          if (canStart && location) {
            await bg.BackgroundGeolocation.start();
          }
        }
        // if (!bgState.enabled) {
        //   final hasActivityPermission =
        //       await ActivityPermissionHelper.checkAndRequestPermission();
        //   if (hasActivityPermission) {
        //     await bg.BackgroundGeolocation.start();
        //   }
        // }

        if (Get.isRegistered<TrackingController>()) {
          Get.find<TrackingController>().isTracking.value = true;
        }
        if (Get.isRegistered<TimelineController>()) {
          Get.find<TimelineController>().refreshShifts(keepSelection: false);
        }
      } catch (_) {}
      //---------field-----------

      // DateTime currentDate = DateTime.now();
      // DateTime punchDate = DateTime.parse(punchTime.value);
      // if(punchDate.day != currentDate.day || punchDate.month != currentDate.month || punchDate.year != currentDate.year) {
      //   // await prefs.remove("punch");
      //   punchTime.value = "";
      // }
    } else {
      final trackingCtr = Get.isRegistered<TrackingController>()
          ? Get.find<TrackingController>()
          : Get.put(TrackingController());
      trackingCtr.endTracking();
    }
  }

  Future<void> getWorkList() async {
    final UserAuthController userAuthController =
        Get.find<UserAuthController>();
    WorkEntryListController workEntryListController =
        Get.find<WorkEntryListController>();
    await workEntryListController.fetchWorkEntryList(
      month: DateTime.now(),
      empId: userAuthController.userData.value.userData?.employeeId ?? '--',
    );
  }

  Future<void> getMonthData(DateTime date) async {
    CalendarEventController calendarEventController =
        Get.find<CalendarEventController>();
    await calendarEventController.fetchDataPerMonth(selectedData: date);
  }

  // <------------------ Work Logs By Date ---------------------> //
  Rx<DateTime> worksSelectedDate = DateTime.now().obs;
  RxBool isWorkLogLoading = false.obs;
  Rx<WorkLogResponse?> workLogResponse = Rx<WorkLogResponse?>(null);
  RxList<CompletedWorks> dashboardCompletedWorks = <CompletedWorks>[].obs;
  RxList<PendingWorks> dashboardPendingWorks = <PendingWorks>[].obs;
  RxList<OverdueWorks> dashboardOverdueWorks = <OverdueWorks>[].obs;

  Future<void> fetchWorkLogByDate({DateTime? date}) async {
    if (date != null) {
      worksSelectedDate.value = date;
    }
    final DateTime targetDate = date ?? worksSelectedDate.value;
    isWorkLogLoading.value = true;
    try {
      workLogResponse.value = null;
      dashboardCompletedWorks.clear();
      dashboardPendingWorks.clear();
      dashboardOverdueWorks.clear();
      final UserAuthController userAuthController =
          Get.find<UserAuthController>();
      final UserProfileController userProfileController =
          Get.find<UserProfileController>();

      final String empIdStr =
          userAuthController.userData.value.userData?.employeeId ?? '';
      final String compIdStr =
          userProfileController.userData.value.result.companyId?.toString() ??
          '';

      final int? empId = int.tryParse(empIdStr);
      final int? compId = int.tryParse(compIdStr);
      final String dateStr = DateFormat('yyyy-MM-dd').format(targetDate);

      final Map<String, dynamic> data = {
        "company_id": compId,
        "dateStr": dateStr,
        "employee_id": empId,
      };

      final resp = await ApiServices.getWorkLogList(data: data);

      if (resp['status']?.toString() == '200') {
        final workData = WorkLogResponse.fromJson(resp);
        workLogResponse.value = workData;

        if (workData.data != null && workData.data!.isNotEmpty) {
          final firstData = workData.data!.first;
          dashboardCompletedWorks.value = firstData.completedWorks ?? [];
          dashboardPendingWorks.value = firstData.pendingWorks ?? [];
          dashboardOverdueWorks.value = firstData.overdueWorks ?? [];
        } else {
          dashboardCompletedWorks.clear();
          dashboardPendingWorks.clear();
          dashboardOverdueWorks.clear();
        }
      } else {
        workLogResponse.value = null;
        dashboardCompletedWorks.clear();
        dashboardPendingWorks.clear();
        dashboardOverdueWorks.clear();
      }
    } catch (e, stackTrace) {
      AttendanceCommonWidgets().printF("fetchWorkLogByDate error: $e");
      workLogResponse.value = null;
      dashboardCompletedWorks.clear();
      dashboardPendingWorks.clear();
      dashboardOverdueWorks.clear();
    } finally {
      isWorkLogLoading.value = false;
    }
  }
}
