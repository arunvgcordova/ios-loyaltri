
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loyaltri_minimal/View/Attendance_Page/Attendance_Page.dart';
import 'package:loyaltri_minimal/View/Home_Page/Home_Page.dart';
import 'package:loyaltri_minimal/View/ManagerView/Feed_Page/Feed_Home.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/Manager_Attendance_Page.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Feed/Manager_Feed_Page.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Home/Manager_Home_Page.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Home/manager_home_controller/manager_home_controller.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_More/Manager_More_Page.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Task/task_controller/task_controller.dart';
import 'package:loyaltri_minimal/View/Profile_Page/Profile_Page.dart';
import 'package:loyaltri_minimal/View/Services_Page/Services_Page.dart';
import 'package:loyaltri_minimal/controller/ui_controller/home_controller.dart';
import '../../View/ManagerView/Employee_Leave/employee_leave_controller/employee_leave_controller.dart';
import '../../View/ManagerView/Manager_Attendance/manager_attendance_controller/manager_attendance_controller.dart';
import '../../View/ManagerView/Manager_Employee/Manager_Employee_Page.dart';
import '../../View/ManagerView/Manager_Employee/employee_page_controller/employee_page_controller.dart';
import '../../View/ManagerView/Manager_Request/manager_request_controller/manager_request_controller.dart';
import '../../models/page_model.dart';
import '../../utils/color_utils.dart';

final ValueNotifier<AppView> uiNotifier = ValueNotifier(AppView.employee);

class UserPageController extends GetxController {
  RxInt currentIndex = 0.obs;
  RxList<PageModel> currentPages = <PageModel>[].obs;
  Rx<AppView> appView = AppView.employee.obs;

  void setPages(AppView view) {
    appView.value = view;
    uiNotifier.value = view;
    if(appView.value == AppView.employee) {
      // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      //   statusBarColor: ColorUtils.workEntryHead, // Status bar color
      //   statusBarIconBrightness: Brightness.light, // Status bar icons color
      //   systemNavigationBarColor: ColorUtils.workEntryHead, // Navigation bar color
      //   systemNavigationBarIconBrightness: Brightness.light, // Navigation bar icons color
      // ));
      // SystemChrome.setSystemUIOverlayStyle(
      //   const SystemUiOverlayStyle(
      //     systemNavigationBarColor: ColorUtils.workEntryHead,
      //     statusBarColor: ColorUtils.pastelPurple,
      //   ),
      // );
      currentPages.value = [
        PageModel(title: "Home", appBarTitle: "", appBarTitleImage: "", selectedIcon: "assets/images/home_icon_selected.svg", unselectIcon: "assets/images/home_unselected.svg", page: HomePage()),
        PageModel(title: "Attendance", appBarTitle: "Attendance", appBarTitleImage: "assets/images/leave-calendar3d.webp", selectedIcon: "assets/images/attendance_selected.svg", unselectIcon: "assets/images/attendance_unselected.svg", page: Attendance()),
        PageModel(title: "Feed", appBarTitle: "Feed", appBarTitleImage: "assets/images/feed_icon.svg", selectedIcon: "assets/images/employee_feed_active_icon.svg", unselectIcon: "assets/images/employee_feed_icon.svg", page: FeedViewHomeEmployee()),
        PageModel(title: "Services", appBarTitle: "Services", appBarTitleImage: "assets/images/services3d.webp", selectedIcon: "assets/images/services_selected.svg", unselectIcon: "assets/images/services_unselected.svg", page: Services()),
        PageModel(title: "Profile", appBarTitle: "My Profile", appBarTitleImage: "assets/images/userprofile.webp", selectedIcon: "assets/images/profile_selected.svg", unselectIcon: "assets/images/profile_unselected.svg", page: Profile()),
      ];
    } else {
      // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      //   statusBarColor: Colors.transparent, // Status bar color
      //   statusBarIconBrightness: Brightness.dark, // Status bar icons color
      //   systemNavigationBarColor: ColorUtils.textWhite, // Navigation bar color
      //   systemNavigationBarIconBrightness: Brightness.dark, // Navigation bar icons color
      //   statusBarBrightness: Brightness.dark,
      // ));

      ManagerAttendanceController managerAttendanceController = Get.find<ManagerAttendanceController>();
      managerAttendanceController.resetValues();
      ManagerRequestController managerRequestController = Get.find<ManagerRequestController>();
      managerRequestController.resetValues();

      // SystemChrome.setSystemUIOverlayStyle(
      //   const SystemUiOverlayStyle(
      //     systemNavigationBarColor: ColorUtils.pastelPurple,
      //     statusBarColor: ColorUtils.workEntryHead,
      //   ),
      // );
      currentPages.value = [
        PageModel(title: "Home", appBarTitle: "", appBarTitleImage: "", selectedIcon: "assets/images/manager_view/home-active.png", unselectIcon: "assets/images/manager_view/home.png", page: ManagerHomePage()),
        PageModel(title: "Attendance", appBarTitle: "", appBarTitleImage: "", selectedIcon: "assets/images/manager_view/attendance-active.png", unselectIcon: "assets/images/manager_view/attendance.png", page: ManagerAttendancePage()),
        PageModel(title: "Feed", appBarTitle: "", appBarTitleImage: "", selectedIcon: "assets/images/manager_view/feed-active.png", unselectIcon: "assets/images/manager_view/feed.png", page: ManagerFeedPage()),
        PageModel(title: "People", appBarTitle: "", appBarTitleImage: "", selectedIcon: "assets/images/manager_view/user-active.png", unselectIcon: "assets/images/manager_view/user.png", page: ManagerEmployeePage(isSelectEmployee: false, isDarkMode: false)),
        PageModel(title: "More", appBarTitle: "", appBarTitleImage: "", selectedIcon: "assets/images/manager_view/more-active.png", unselectIcon: "assets/images/manager_view/more.png", page: ManagerMorePage()),
      ];
    }
  }
}