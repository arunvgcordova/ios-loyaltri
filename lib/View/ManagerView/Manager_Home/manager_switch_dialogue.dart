
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/ManagerView/Feed_Page/feed_view_controller/feed_view_controller.dart';
import 'package:loyaltri_minimal/controller/userAuthentication.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../../controller/ui_controller/home_controller.dart';
import '../../../controller/ui_controller/page_controller.dart';
import '../../../utils/color_utils.dart';
import '../Manager_Attendance/manager_attendance_controller/manager_attendance_controller.dart';

class AppViewSwitch {
  AppViewSwitch._privateConstructor();

  static final AppViewSwitch _instance = AppViewSwitch._privateConstructor();

  factory AppViewSwitch() {
    return _instance;
  }

  Future<void> showAppViewSwitcher(BuildContext context) async {
    await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Cancel',
      barrierColor: Colors.black.withValues(alpha: 0.8),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (ctx, a1, a2) {
        return const SizedBox();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        final curve = Curves.easeInOut.transform(a1.value);
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(-0.1, -0.5),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: a1, curve: Curves.easeOut));

        return SlideTransition(
          position: offsetAnimation,
          child: Transform.scale(
            scale: curve,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 116.h,
                ),
                padding: EdgeInsets.all(0.5.h), // Border thickness
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    stops: [
                      0.1,
                      0.2,
                      0.3,
                      1.0,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF575757),
                      Color(0xFF3E3E3E),
                      Color(0xFF535353),
                      Color(0xFF1F1F1F),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(18.r),
                ),
                child: Material(
                  borderRadius: BorderRadius.circular(18.r),
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF121212),
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 12.h),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 48.h,
                                width: 48.h,
                                color: Colors.transparent,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    "assets/images/manager_view/switch_mode.svg",
                                    height: 15.h,
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    "Switch Modes?",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15.h,
                                      color: ColorUtils.textWhite,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  height: 48.h,
                                  width: 48.h,
                                  decoration: BoxDecoration(
                                    color: ColorUtils.foregroundBlack,
                                    borderRadius: BorderRadius.circular(14.r),
                                    border: Border.all(
                                      width: 1.h,
                                      color: const Color(0xFF3F4450),
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.close,
                                      size: 18.h,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 40.h,
                            ),
                            child: Text(
                              "You can switch between these modes:",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 13.h,
                                color: ColorUtils.textWhite.withValues(alpha: 0.5),
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          GetX<UserPageController>(
                              builder: (UserPageController controller) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      borderRadius: BorderRadius.circular(8.r),
                                      onTap: () {
                                        controller.setPages(AppView.employee);
                                        Future.delayed(const Duration(milliseconds: 50), () {
                                          Get.back();
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 5.h,
                                          horizontal: 5.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: controller.appView.value == AppView.employee
                                              ? Color(0xFF27252C)
                                              : Color(0xFF121212),
                                          borderRadius: BorderRadius.circular(8.r),
                                          border: Border.all(
                                            color: Color(0xFF27252C),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 52.h,
                                              height: 56.h,
                                              decoration: BoxDecoration(
                                                color: Color(0xFFD9D9D9).withValues(alpha: 0.1),
                                                borderRadius: BorderRadius.circular(5.r),
                                              ),
                                              child: Center(
                                                child: Image.asset(
                                                  "assets/images/manager_view/employee_mode.png",
                                                  height: 25.h,
                                                  fit: BoxFit.fitHeight,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 8.h),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Employee Mode",
                                                  style: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 13.h,
                                                    color: ColorUtils.textWhite,
                                                    decoration: TextDecoration.none,
                                                  ),
                                                ),
                                                Text(
                                                  "Focuses on your personal tasks.",
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 11.h,
                                                    color: ColorUtils.textWhite.withValues(alpha: 0.5),
                                                    decoration: TextDecoration.none,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Spacer(),
                                            if(controller.appView.value == AppView.employee)
                                              SvgPicture.asset(
                                                "assets/images/manager_view/selected_appView.svg",
                                                height: 20.h,
                                              ),
                                            SizedBox(width: 15.h),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    InkWell(
                                      borderRadius: BorderRadius.circular(8.r),
                                      onTap: () {
                                        controller.setPages(AppView.manager);
                                        Future.delayed(const Duration(milliseconds: 50), () {
                                          Get.back();
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 5.h,
                                          horizontal: 5.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: controller.appView.value == AppView.manager
                                              ? Color(0xFF27252C)
                                              : Color(0xFF121212),
                                          borderRadius: BorderRadius.circular(8.r),
                                          border: Border.all(
                                            color: Color(0xFF27252C),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 52.h,
                                              height: 56.h,
                                              decoration: BoxDecoration(
                                                color: Color(0xFFD9D9D9).withValues(alpha: 0.1),
                                                borderRadius: BorderRadius.circular(5.r),
                                              ),
                                              child: Center(
                                                child: Image.asset(
                                                  "assets/images/manager_view/manager_mode.png",
                                                  height: 31.h,
                                                  fit: BoxFit.fitHeight,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 8.h),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Manager Mode",
                                                  style: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 13.h,
                                                    color: ColorUtils.textWhite,
                                                    decoration: TextDecoration.none,
                                                  ),
                                                ),
                                                Text(
                                                  "Lets you manage team insights",
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 11.h,
                                                    color: ColorUtils.textWhite.withValues(alpha: 0.5),
                                                    decoration: TextDecoration.none,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Spacer(),
                                            if(controller.appView.value == AppView.manager)
                                              SvgPicture.asset(
                                                "assets/images/manager_view/selected_appView.svg",
                                                height: 20.h,
                                              ),
                                            SizedBox(width: 15.h),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> showAppViewSwitcherManager(BuildContext context) async {
    final AutoScrollController scrollController = AutoScrollController();
    bool hasScrolled = false;
    await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Cancel',
      barrierColor: Colors.black.withValues(alpha: 0.8),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (ctx, a1, a2) {
        return const SizedBox();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        final curve = Curves.easeInOut.transform(a1.value);
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(-0.1, -0.5),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: a1, curve: Curves.easeOut));
        return SlideTransition(
          position: offsetAnimation,
          child: Transform.scale(
            scale: curve,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 116.h,
                ),
                padding: EdgeInsets.all(0.5.h),
                child: Material(
                  borderRadius: BorderRadius.circular(18.r),
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      color: ColorUtils.textWhite,
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 12.h),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 48.h,
                                width: 48.h,
                                color: Colors.transparent,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    "assets/images/manager_view/switch_mode_black.svg",
                                    height: 15.h,
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    "Switch Modes?",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15.h,
                                      color: ColorUtils.workEntryHead,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  height: 48.h,
                                  width: 48.h,
                                  decoration: BoxDecoration(
                                    color: ColorUtils.lightSilver,
                                    borderRadius: BorderRadius.circular(14.r),
                                    border: Border.all(
                                      width: 1.h,
                                      color: const Color(0xFFE6E6E6),
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.close,
                                      size: 18.h,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.h,
                            ),
                            child: Text(
                              "You can switch between these modes:",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 13.h,
                                color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          GetX<UserPageController>(
                              builder: (UserPageController controller) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if(Get.find<UserAuthController>().userData.value.userData?.loginType != 2)
                                      InkWell(
                                        borderRadius: BorderRadius.circular(8.r),
                                        onTap: () {
                                          controller.setPages(AppView.employee);
                                          Future.delayed(const Duration(milliseconds: 50), () {
                                            Get.back();
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(1.h),
                                          decoration: BoxDecoration(
                                            color: ColorUtils.lightSilver,
                                            borderRadius: BorderRadius.circular(8.r),
                                          ),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 5.h,
                                              horizontal: 5.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: controller.appView.value == AppView.employee
                                                  ? ColorUtils.secondaryBlue
                                                  : ColorUtils.textWhite,
                                              borderRadius: BorderRadius.circular(7.r),
                                              // border: Border.all(
                                              //   color: ColorUtils.lightSilver,
                                              // ),
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 52.h,
                                                  height: 56.h,
                                                  decoration: BoxDecoration(
                                                    color: controller.appView.value == AppView.employee ? ColorUtils.textWhite : ColorUtils.lightSilver,
                                                    borderRadius: BorderRadius.circular(5.r),
                                                  ),
                                                  child: Center(
                                                    child: Image.asset(
                                                      "assets/images/manager_view/employee_mode_black.png",
                                                      height: 25.h,
                                                      fit: BoxFit.fitHeight,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 8.h),
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Employee Mode",
                                                      style: GoogleFonts.inter(
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 13.h,
                                                        color: ColorUtils.workEntryHead,
                                                        decoration: TextDecoration.none,
                                                      ),
                                                    ),
                                                    Text(
                                                      "Focuses on your personal tasks.",
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: GoogleFonts.poppins(
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 11.h,
                                                        color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                                                        decoration: TextDecoration.none,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Spacer(),
                                                if(controller.appView.value == AppView.employee)
                                                  SvgPicture.asset(
                                                    "assets/images/manager_view/selected_appView_manager.svg",
                                                    height: 20.h,
                                                  ),
                                                SizedBox(width: 15.h),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    if(Get.find<UserAuthController>().userData.value.userData?.loginType != 2)
                                      SizedBox(height: 8.h),
                                    Column(
                                      children: [
                                        InkWell(
                                          borderRadius: BorderRadius.circular(8.r),
                                          onTap: () {
                                            controller.setPages(AppView.manager);
                                            Future.delayed(const Duration(milliseconds: 50), () {
                                              Get.back();
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.only(
                                              left: 1.h,
                                              right: 1.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: ColorUtils.lightSilver,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(8.r),
                                                topRight: Radius.circular(8.r),
                                              ),
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: ColorUtils.textWhite,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(8.r),
                                                  topRight: Radius.circular(8.r),
                                                ),
                                              ),
                                              child: Container(
                                                padding: EdgeInsets.all(1.h),
                                                decoration: BoxDecoration(
                                                  color: ColorUtils.lightSilver,
                                                  borderRadius: BorderRadius.circular(8.r),
                                                ),
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 5.h,
                                                    horizontal: 5.h,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: controller.appView.value == AppView.manager
                                                        ? ColorUtils.secondaryBlue
                                                        : ColorUtils.textWhite,
                                                    borderRadius: BorderRadius.circular(7.r),
                                                    // border: Border.all(
                                                    //   color: ColorUtils.lightSilver,
                                                    // ),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: 52.h,
                                                        height: 56.h,
                                                        decoration: BoxDecoration(
                                                          color: controller.appView.value == AppView.manager ? ColorUtils.textWhite : ColorUtils.lightSilver,
                                                          borderRadius: BorderRadius.circular(5.r),
                                                        ),
                                                        child: Center(
                                                          child: Image.asset(
                                                            "assets/images/manager_view/manager_mode_black.png",
                                                            height: 31.h,
                                                            fit: BoxFit.fitHeight,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 8.h),
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            "Manager Mode",
                                                            style: GoogleFonts.inter(
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: 13.h,
                                                              color: ColorUtils.textWhite,
                                                              decoration: TextDecoration.none,
                                                            ),
                                                          ),
                                                          Text(
                                                            "Lets you manage team insights",
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: GoogleFonts.poppins(
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: 11.h,
                                                              color: ColorUtils.textWhite.withValues(alpha: 0.5),
                                                              decoration: TextDecoration.none,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Spacer(),
                                                      if(controller.appView.value == AppView.manager)
                                                        SvgPicture.asset(
                                                          "assets/images/manager_view/selected_appView_manager.svg",
                                                          height: 20.h,
                                                        ),
                                                      SizedBox(width: 15.h),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                            right: 1.h,
                                            left: 1.h,
                                            bottom: 1.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: ColorUtils.lightSilver,
                                            borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(8.r),
                                              bottomLeft: Radius.circular(8.r),
                                            ),
                                          ),
                                          child: Container(
                                            padding: EdgeInsets.only(
                                              left: 10.h,
                                              right: 10.h,
                                              bottom: 10.h,
                                              top: 15.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: ColorUtils.textWhite,
                                              borderRadius: BorderRadius.only(
                                                bottomRight: Radius.circular(7.r),
                                                bottomLeft: Radius.circular(7.r),
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Choose Company",
                                                      style: GoogleFonts.poppins(
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 10.h,
                                                        color: ColorUtils.workEntryHead.withValues(alpha: 0.3),
                                                        decoration: TextDecoration.none,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 8.h),
                                                ConstrainedBox(
                                                  constraints: BoxConstraints(
                                                    maxHeight: 200.h,
                                                  ),
                                                   child: GetX<UserProfileController>(
                                                     builder: (UserProfileController controller) {
                                                       int selectedIndex = controller.allCompanyList.indexWhere((comp) => comp.companyId == controller.currentCompany.value?.companyId);
                                                       if (selectedIndex != -1 && !hasScrolled) {
                                                         hasScrolled = true;
                                                         WidgetsBinding.instance.addPostFrameCallback((_) {
                                                           if (scrollController.hasClients) {
                                                             scrollController.scrollToIndex(
                                                               selectedIndex,
                                                               preferPosition: AutoScrollPosition.middle,
                                                             );
                                                           }
                                                         });
                                                       }
                                                       return ListView.separated(
                                                         controller: scrollController,
                                                         itemCount: controller.allCompanyList.value.length,
                                                         itemBuilder: (context, index) {
                                                           return AutoScrollTag(
                                                             key: ValueKey(index),
                                                             controller: scrollController,
                                                             index: index,
                                                             child: InkWell(
                                                               borderRadius: BorderRadius.circular(8.r),
                                                               onTap: () async {
                                                                 controller.currentCompany.value = controller.allCompanyList.value[index];

                                                                 try {
                                                                   // controller.userData.value.result.companyId = controller.currentCompany.value?.companyId?.toString() ?? '';
                                                                   // Get.back();
                                                                   await Get.find<HomeController>().getHomeData(context, fromPopUp: true);
                                                                   ManagerAttendanceController managerAttendanceController = Get.find<ManagerAttendanceController>();
                                                                   String formated = DateFormat('yyyy-MM-dd').format(managerAttendanceController.dateList.value[managerAttendanceController.currentDateIndex.value]);
                                                                   await managerAttendanceController.fetchManagerAttSummary(
                                                                     date: formated,
                                                                   );
                                                                   await managerAttendanceController.fetchManagerAttDetails(
                                                                     date: formated,
                                                                   );
                                                                   await Get.find<FeedViewController>().fetchFeedListUser(loadMore: false);
                                                                 } catch (e) {
                                                                 } finally {
                                                                 }
                                                                 // Navigator.of(context).pop();
                                                               },
                                                               child: Container(
                                                                 padding: EdgeInsets.symmetric(
                                                                   vertical: 5.h,
                                                                   horizontal: 5.h,
                                                                 ),
                                                                 decoration: BoxDecoration(
                                                                   color: controller.allCompanyList.value[index].companyId == controller.currentCompany.value?.companyId ? ColorUtils.snowGrey : ColorUtils.textWhite,
                                                                   borderRadius: BorderRadius.circular(8.r),
                                                                 ),
                                                                 child: Row(
                                                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                   children: [
                                                                     Expanded(
                                                                       child: Row(
                                                                         mainAxisSize: MainAxisSize.min,
                                                                         children: [
                                                                           ClipRRect(
                                                                             borderRadius: BorderRadius.circular(1000).r,
                                                                             child: CachedNetworkImage(
                                                                                 imageUrl: controller.allCompanyList.value[index].logo ?? '',
                                                                               height: 32.h,
                                                                               width: 32.h,
                                                                               fit: BoxFit.cover,
                                                                               placeholder: (context, url) {
                                                                                 return Icon(Icons.apartment, color: Colors.grey, size: 20.h);
                                                                               },
                                                                               errorWidget: (context, url, error) {
                                                                                 return Icon(Icons.apartment, color: Colors.grey, size: 20.h);
                                                                               },
                                                                             ),
                                                                           ),
                                                                           SizedBox(width: 8.h),
                                                                           Expanded(
                                                                             child: Text(
                                                                               controller.allCompanyList.value[index].company ?? '--',
                                                                               overflow: TextOverflow.ellipsis,
                                                                               style: GoogleFonts.poppins(
                                                                                 fontWeight: FontWeight.w500,
                                                                                 fontSize: 10.h,
                                                                                 color: ColorUtils.workEntryHead.withValues(alpha: 0.7),
                                                                                 decoration: TextDecoration.none,
                                                                               ),
                                                                             ),
                                                                           ),
                                                                         ],
                                                                       ),
                                                                     ),
                                                                     SizedBox(width: 5.h),
                                                                     if(controller.allCompanyList.value[index].companyId == controller.currentCompany.value?.companyId)
                                                                       Padding(
                                                                         padding: EdgeInsets.only(
                                                                           right: 6.h,
                                                                         ),
                                                                         child: SvgPicture.asset(
                                                                           "assets/images/manager_view/selected_appView.svg",
                                                                           height: 16.h,
                                                                         ),
                                                                       ),
                                                                     // SizedBox(width: 0.1.h),
                                                                   ],
                                                                 ),
                                                               ),
                                                             ),
                                                           );
                                                         },
                                                         separatorBuilder: (context, index) => SizedBox(height: 5.h),
                                                        shrinkWrap: true,
                                                        padding: EdgeInsets.zero,
                                                      );
                                                    }
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}