
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loyaltri_minimal/View/CWidgets/cwidgets.dart';
import 'package:loyaltri_minimal/View/Home_Page/home_widgets/notificationIcon.dart';
import 'package:loyaltri_minimal/View/ManagerView/Feed_Page/create_feed.dart';
import 'package:loyaltri_minimal/View/NotificationScreen/NotificationScreen.dart';
import 'package:loyaltri_minimal/controller/attSummaryController.dart';
import 'package:loyaltri_minimal/controller/attendanceListController.dart';
import 'package:loyaltri_minimal/controller/leaveTypeController.dart';
import 'package:loyaltri_minimal/controller/network_controller.dart';
import 'package:loyaltri_minimal/controller/userAuthentication.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';
import 'package:matomo_tracker/matomo_tracker.dart';
import '../controller/ui_controller/home_controller.dart';
import '../controller/ui_controller/page_controller.dart';
import '../controller/userProfileController.dart';
import '../controller/versionCheckController.dart';
import 'ManagerView/Feed_Page/feed_view_controller/feed_view_controller.dart';
import 'ManagerView/Manager_Attendance/manager_attendance_controller/manager_attendance_controller.dart';
import 'ManagerView/Manager_Employee/employee_page_controller/employee_page_controller.dart';

class MenuPage extends StatefulWidget {
  final bool? afterCheck;
  const MenuPage({super.key, this.afterCheck});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  // int currentIndex = 0;
  // List<String>? titles;
  // List<String>? iconImages;
  VersionCheckController versionCheckController =
      Get.find<VersionCheckController>();
  HomeController homeController = Get.find<HomeController>();
  UserPageController userPageController = Get.find<UserPageController>();

  // switchPage(int index) {
  //   setState(() {
  //     currentIndex = index;
  //   });
  // }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await initialize();
    });
    userPageController.currentIndex.listen((index) async {
      if (index == 2 && !Get.find<FeedViewController>().feedLoaded.value) {
        if (homeController.dataLoaded.value) {
          if (mounted) context.loaderOverlay.show();
          await Get.find<FeedViewController>().fetchFeedListUser();
          if (mounted) context.loaderOverlay.hide();
        }
        // else if (homeController.isLoading.value) {
        //   if (mounted) context.loaderOverlay.show();
        // } else {
        //   if (mounted) context.loaderOverlay.show();
        //   await Get.find<FeedViewController>().fetchFeedListUser();
        //   if (mounted) context.loaderOverlay.hide();
        // }
      }
    });

    homeController.isLoading.listen((loading) async {
      if (!loading && userPageController.currentIndex.value == 2 && !Get.find<FeedViewController>().feedLoaded.value) {
        if (homeController.dataLoaded.value) {
          if (mounted) context.loaderOverlay.show();
          await Get.find<FeedViewController>().fetchFeedListUser();
          if (mounted) context.loaderOverlay.hide();
        } else {
          if (mounted) context.loaderOverlay.hide();
        }
      }
    });
    super.initState();
  }

  initialize() async {
    try {
      MatomoTracker.instance.trackPageView(
        context: context,
        campaign: Campaign(
          name: userPageController.appView.value == AppView.employee ? "Employee Home" : "Manager Home",
        ),
        path: "/home",
      );
      if(widget.afterCheck ?? false) {
        await homeController.getHomeData(context);
      }
      
      if (userPageController.currentIndex.value == 2 && !Get.find<FeedViewController>().feedLoaded.value) {
        if (homeController.dataLoaded.value) {
          if (mounted) context.loaderOverlay.show();
          await Get.find<FeedViewController>().fetchFeedListUser();
          if (mounted) context.loaderOverlay.hide();
        }
      }
    } catch (e) {} finally {}
  }

  // @override
  // void didChangeDependencies() {
  //   setItems();
  //   super.didChangeDependencies();
  // }
  //
  // @override
  // void didUpdateWidget(covariant MenuPage oldWidget) {
  //   setItems();
  //   super.didUpdateWidget(oldWidget);
  // }
  //
  // setItems() {
  //   titles = ["", "Attendance", "Services", "My Profile"];
  //
  //   iconImages = [
  //     "",
  //     "assets/images/leave-calendar3d.webp",
  //     "assets/images/services3d.webp",
  //     "assets/images/userprofile.webp",
  //   ];
  // }

  @override
  Widget build(BuildContext context) {
    return GetX<UserPageController>(
      builder: (UserPageController controller) {
        return Scaffold(
          appBar:
          controller.currentIndex.value != 0 && controller.appView.value == AppView.employee
              ? AppBar(
            backgroundColor: const Color(0xff000000),
            centerTitle: true,
            leading: (controller.currentIndex.value == 2 && Get.find<UserAuthController>().postFeed.value)
                ? Center(
                  child: InkWell(
                    onTap: () {
                      if(Get.find<UserAuthController>().postFeed.value) {
                        Navigator.of(context).push(
                          newSlideNavigation(CreateFeed()),
                        );
                      } else {
                        AttendanceCommonWidgets().showGetSnackBar(
                          title: 'Message',
                          message: 'You don\'t have permission to post to the feed.',
                          backgroundColor: ColorUtils.foregroundBlack,
                          colorText: Colors.white,
                        );
                      }
                    },
                    child: SvgPicture.asset(
                    "assets/images/manager_view/add_feed_icon.svg",
                    width: 30.h,
                      colorFilter: ColorFilter.mode(ColorUtils.textWhite, BlendMode.srcIn),
                    ),
                  ),
                )
                : null,
            shape: controller.currentIndex.value == 2 ? Border(
              bottom: BorderSide(
                color: ColorUtils.textWhite.withValues(alpha: 0.11),
                width: 1.h,
              )
            ) : null,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if(controller.currentIndex.value == 2)
                  SvgPicture.asset(
                    width: 25.w,
                    controller.currentPages[controller.currentIndex.value].appBarTitleImage,
                  )
                  else
                    Image.asset(controller.currentPages[controller.currentIndex.value].appBarTitleImage, width: 25.w),
                SizedBox(width: 10.w),
                Text(
                  controller.currentPages[controller.currentIndex.value].appBarTitle,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp,
                    color: ColorUtils.textWhite,
                  ),
                ),
              ],
            ),
          )
              : null,
          backgroundColor: Colors.black,
          // bottomNavigationBar: ,
          body: Stack(
            children: [
              IndexedStack(
                index: controller.currentIndex.value,
                children: controller.currentPages.map((item) => item.page).toList(),
              ),
              // screens![currentIndex],
              if (controller.appView.value == AppView.manager)
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: ScreenUtil().screenWidth,
                    // height: Platform.isIOS ? 120.h : 80.h,
                    height: 80.h + MediaQuery.of(context).padding.bottom,
                    decoration: BoxDecoration(
                      color: ColorUtils.pastelPurple,
                      border: Border(
                        top: BorderSide(
                          width: 1.h,
                          color: ColorUtils.shadowGrey.withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                    child: Theme(
                      data: Theme.of(
                        context,
                      ).copyWith(splashFactory: NoSplash.splashFactory),
                      child: BottomNavigationBar(
                        currentIndex: controller.currentIndex.value,
                        type: BottomNavigationBarType.fixed,
                        // onTap: (index) => controller.currentIndex.value = index,
                        onTap: (index) async {
                          controller.currentIndex.value = index;

                          if(index == 1 && (!Get.find<ManagerAttendanceController>().attDetailsLoaded.value || !Get.find<ManagerAttendanceController>().summaryLoaded.value)) {
                            context.loaderOverlay.show();
                            Get.find<ManagerAttendanceController>().searchText.value = '';
                            ManagerAttendanceController managerAttendanceController = Get.find<ManagerAttendanceController>();
                            String formated = DateFormat('yyyy-MM-dd').format(managerAttendanceController.dateList.value[managerAttendanceController.currentDateIndex.value]);
                            await managerAttendanceController.fetchManagerAttSummary(
                              date: formated,
                            );
                            await managerAttendanceController.fetchManagerAttDetails(
                              date: formated,
                            );
                            context.loaderOverlay.hide();
                          }
                          if(index == 3) {
                            context.loaderOverlay.show();
                            await Get.find<ManagerEmployeeController>().fetchAllEmployee(isAll: Get.find<UserAuthController>().userData.value.userData?.unrestrictedList ?? false);
                            context.loaderOverlay.hide();
                          }
                        },
                        unselectedLabelStyle: GoogleFonts.poppins(
                          color: ColorUtils.stormySlate,
                          fontSize: 12.h,
                          fontWeight: FontWeight.w400,
                          height: 2.h,
                        ),
                        selectedLabelStyle: GoogleFonts.poppins(
                          color: ColorUtils.calenderDatesCircle,
                          fontSize: 12.h,
                          fontWeight: FontWeight.w400,
                          height: 2.h,
                        ),
                        unselectedItemColor: ColorUtils.stormySlate,
                        items: [
                          for(int i = 0; i < controller.currentPages.length; i++)
                            BottomNavigationBarItem(
                              icon: Image.asset(
                                controller.currentIndex.value == i
                                    ? controller.currentPages.value[i].selectedIcon
                                    : controller.currentPages.value[i].unselectIcon,
                                height: 25.h,
                                color:
                                controller.currentIndex.value != i
                                    ? ColorUtils.stormySlate
                                    : null,
                              ),
                              label: controller.currentPages.value[i].title,
                            ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: ScreenUtil().screenWidth,
                    // height: Platform.isIOS ? 120.h : 80.h,
                    height: 80.h + MediaQuery.of(context).padding.bottom,
                    // margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    decoration: BoxDecoration(
                      // borderRadius: const BorderRadius.all(Radius.circular(34)).w,
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          ColorUtils.navGrad1,
                          ColorUtils.navGrad2,
                          // Color(0xFF070707),
                          // Color(0xFF272626),
                          // Color(0xFF272626),
                          // Color(0xFF222222),
                        ], // Replace with your colors
                      ),
                      border: Border(
                        top: BorderSide(
                          width: 1.h,
                          color: const Color(0xFF262626),
                        ),
                      ),
                    ),
                    child: Theme(
                      data: Theme.of(
                        context,
                      ).copyWith(splashFactory: NoSplash.splashFactory),
                      child: BottomNavigationBar(
                        currentIndex: controller.currentIndex.value,
                        backgroundColor: Colors.transparent,
                        type: BottomNavigationBarType.fixed,
                        selectedItemColor: Colors.white,
                        // onTap: (index) => controller.currentIndex.value = index,
                        onTap: (index) async {
                          controller.currentIndex.value = index;

                          if(index == 1 && (!Get.find<AttendanceList>().dataLoaded.value || !Get.find<AttendanceSummaryController>().dataLoaded.value)) {
                            context.loaderOverlay.show();
                            DateTime date = DateFormat.yMMM().parse(Get.find<AttendanceList>().monthString[0]);
                            Get.find<AttendanceSummaryController>().totalDays.value = DateTime(date.year, date.month + 1, 0).day;
                            String companyId = Get.find<UserProfileController>().userData.value.result.companyId?.toString() ?? '';
                            await Get.find<AttendanceList>().fetchMonthCycleData(compId: companyId);
                            await Get.find<AttendanceList>().fetchAttendanceList(empId: Get.find<UserAuthController>().userData.value.userData?.employeeId ?? '--', compId: companyId);
                            await Get.find<AttendanceSummaryController>().getAttendanceSummary(empId: Get.find<UserAuthController>().userData.value.userData?.employeeId ?? '--', compId: companyId);
                            context.loaderOverlay.hide();
                          }
                        },
                        unselectedLabelStyle: GoogleFonts.poppins(
                          color: ColorUtils.textWhite,
                          fontSize: 12.h,
                          fontWeight: FontWeight.w400,
                          height: 2.h,
                        ),
                        selectedLabelStyle: GoogleFonts.poppins(
                          color: ColorUtils.textWhite,
                          fontSize: 12.h,
                          fontWeight: FontWeight.w400,
                          height: 2.h,
                        ),
                        unselectedItemColor: const Color(0xFF707486),
                        items: [
                          for(int i = 0; i < controller.currentPages.length; i++)
                            BottomNavigationBarItem(
                              icon: SvgPicture.asset(
                                controller.currentIndex.value == i
                                    ? controller.currentPages.value[i].selectedIcon
                                    : controller.currentPages.value[i].unselectIcon,
                                height: 21.w,
                                colorFilter: controller.currentIndex.value != i
                                    ? ColorFilter.mode(ColorUtils.stormySlate, BlendMode.srcIn)
                                    : null,
                              ),
                              label: controller.currentPages.value[i].title,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
