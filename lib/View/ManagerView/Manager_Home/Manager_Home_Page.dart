import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loyaltri_minimal/View/CWidgets/cwidgets.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Home/home_widgets/action_centre.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Home/home_widgets/manager_appBar.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Home/home_widgets/search_field.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Home/manager_home_controller/manager_home_controller.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Task/task_controller/task_controller.dart';
import 'package:loyaltri_minimal/controller/ui_controller/page_controller.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';
import '../../../controller/ui_controller/home_controller.dart';
import '../../../controller/userAuthentication.dart';
import '../../../controller/userProfileController.dart';
import '../../Excuse_Page/Excuse_Page.dart';
import '../../Leave_Page/Leave_Page.dart';
import '../../NotificationScreen/NotificationScreen.dart';
import '../Employee_Leave/Employee_Leave_Page.dart';
import '../Employee_Leave/employee_leave_controller/employee_leave_controller.dart';
import '../Manager_Attendance/manager_attendance_controller/manager_attendance_controller.dart';
import '../Manager_Request/Manager_Reqest_Page.dart';
import 'home_widgets/attendance_summary.dart';
import 'home_widgets/task_view.dart';

class ManagerHomePage extends StatefulWidget {
  const ManagerHomePage({super.key});

  @override
  State<ManagerHomePage> createState() => _ManagerHomePageState();
}

class _ManagerHomePageState extends State<ManagerHomePage> {

  @override
  void initState() {
    setupInteractedMessage();
    initialize();
    super.initState();
  }

  Future<void> initialize() async {
    context.loaderOverlay.show();
    // if(!Get.find<ManagerHomeController>().actionCentreLoading.value) {
    //   Get.find<ManagerHomeController>().fetchActionCentre();
    // }
    // if(!Get.find<ManagerAttendanceController>().next7DaysLeaveLoading.value) {
    //   Get.find<ManagerAttendanceController>().fetchNextSevenDaysLeave();
    // }
    await Get.find<HomeController>().getHomeData(context);
    context.loaderOverlay.hide();
    ManagerAttendanceController managerAttendanceController = Get.find<ManagerAttendanceController>();
    String formated = DateFormat('yyyy-MM-dd').format(managerAttendanceController.dateList.value[managerAttendanceController.currentDateIndex.value]);
    await managerAttendanceController.fetchManagerAttSummary(
      date: formated,
    );
    await managerAttendanceController.fetchManagerAttDetails(
      date: formated,
    );
  }

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    if(message.data['category'] == 'my_leave') {
      Navigator.of(context).push(
        newSlideNavigation(const LeavePage()),
      );
    } else if(message.data['category'] == 'my_excuse') {
      Navigator.of(context).push(
        newSlideNavigation(const MyExcuse()),
      );
    } else if(message.data['category'] == 'leave') {
      Get.find<UserPageController>().setPages(AppView.manager);
      EmployeeLeaveController employeeLeaveController = Get.find<EmployeeLeaveController>();
      employeeLeaveController.resetValues();
      employeeLeaveController.fetchEmployeeLeaveList();
      Navigator.of(context).push(
        newSlideNavigation(const EmployeeLeavePage()),
      );
    } else if(message.data['category'] == 'excuse') {
      Get.find<UserPageController>().setPages(AppView.manager);
      Navigator.of(context).push(
        newSlideNavigation(const ManagerRequestPage()),
      );
    } else if(message.data['category'] == 'Feed') {
      Get.find<UserPageController>().currentIndex.value = 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        top: false,
        bottom: true,
        left: false,
        right: false,
        child: Scaffold(
          backgroundColor: ColorUtils.snowWhite,
          appBar: ManagerAppBar(),
          // extendBodyBehindAppBar: true,
          // extendBody: true,
          body: RefreshIndicator(
            onRefresh: () async {
              await Get.find<ManagerHomeController>().fetchActionCentre();
              UserProfileController userProfileController = Get.find<UserProfileController>();
              String companyId = userProfileController.currentCompany.value?.companyId?.toString() ?? userProfileController.userData.value.result.companyId.toString();
              String employeeId = Get.find<UserAuthController>().userData.value.userData?.employeeId ?? '--';
              await Get.find<ManagerTaskController>().fetchTaskDashboardCount(compId: companyId, empId: employeeId);
              await Get.find<ManagerTaskController>().fetchTaskListData(compId: companyId, empId: employeeId);
              await Get.find<ManagerAttendanceController>().fetchNextSevenDaysLeave();
              ManagerAttendanceController managerAttendanceController = Get.find<ManagerAttendanceController>();
              String formated = DateFormat('yyyy-MM-dd').format(managerAttendanceController.dateList.value[managerAttendanceController.currentDateIndex.value]);
              await Get.find<ManagerAttendanceController>().fetchManagerAttSummary(
                date: formated,
              );
              await Get.find<ManagerAttendanceController>().fetchManagerAttDetails(
                date: formated,
              );
              await Get.find<UserProfileController>().fetchAllNotifications();
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  // SafeArea(child: SizedBox(height: 0.h)),
                  HomeSearchField(),
                  ActionCentre(),
                  SizedBox(height: 10.h),
                  TaskView(isDarkMode: false),
                  SizedBox(height: 10.h),
                  AttendanceSummary(),
                  // DocumentsView(),
                  SizedBox(height: Platform.isIOS ? 150.h : 100.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
