import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/CWidgets/app_bar.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Request/request_wigets_manager/request_app_bar.dart';
import 'package:loyaltri_minimal/controller/ui_controller/home_controller.dart';
import 'package:loyaltri_minimal/controller/ui_controller/page_controller.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';
import 'package:timeago/timeago.dart' as time_ago;
import '../CWidgets/cwidgets.dart';

class NotificationScreen extends GetView<UserProfileController> {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.fetchAllNotifications();
    });
    AppView appView = Get.find<UserPageController>().appView.value;
    return SafeArea(
      top: false,
      bottom: true,
      left: false,
      right: false,
      child: Scaffold(
        backgroundColor: appView == AppView.manager ? ColorUtils.textWhite : ColorUtils.workEntryHead,
        body: Stack(
          children: [
            if(appView == AppView.manager)
              gradientContainer1,
            SafeArea(
              top: true,
              bottom: false,
              left: false,
              right: false,
              child: Obx(() {
                return Column(
                  children: [
                    if(appView == AppView.manager)
                      Padding(
                        padding: EdgeInsets.only(
                          top: 15.h,
                          left: 15.w,
                          right: 15.w,
                          bottom: 5.h,
                        ),
                        child: RequestAppBar(title: "Notifications"),
                      )
                    else
                      Padding(
                        padding: EdgeInsets.only(
                          top: 5.h,
                          right: 5.h,
                          left: 5.h,
                        ),
                        child: const CustomAppBar(title: 'Notifications', isActionVisible: true),
                      ),
                    SizedBox(height: 20.h),
                    if (controller.notificationLoading.value)
                      Expanded(
                        child: Center(
                          child: SpinKitThreeInOut(
                            color: ColorUtils.primaryBlue,
                            size: 28.h,
                          ),
                        ),
                      )
                    else if (controller.notificationLoaded.value)
                      if (controller.notifications.value.isEmpty)
                        Expanded(
                          child: Center(
                            child: Text(
                              "No notifications",
                              style: GoogleFonts.poppins(
                                color: appView == AppView.manager ? ColorUtils.workEntryHead.withValues(alpha: 0.5) : ColorUtils.textWhite.withValues(alpha: 0.7),
                                fontWeight: FontWeight.w400,
                                fontSize: 13.h,
                              ),
                            ),
                          ),
                        )
                      else
                        Expanded(
                          child: ListView.separated(
                            itemCount: controller.notifications.value.length,
                            itemBuilder: (context, index) {
                              String timeAgo = '';
                              try {
                                timeAgo = time_ago.format(DateTime.parse(controller.notifications.value[index].createdOn ?? ''));
                              } catch(e) {}
                              if(controller.notifications.value[index].type == "Recent" || controller.notifications.value[index].type == "Earlier") {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    left: 25.h,
                                    bottom: 15.h,
                                  ),
                                  child: Text(
                                      controller.notifications.value[index].type ?? '--',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13.h,
                                      color: appView == AppView.manager ? ColorUtils.workEntryHead : ColorUtils.textWhite,
                                    ),
                                  ),
                                );
                              } else {
                                return Container(
                                  color: appView == AppView.manager ? Colors.transparent : const Color(0xFF101012),
                                  height: 90.h,
                                  child: Center(
                                    child: ListTile(
                                      leading: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // Container(
                                          //   width: 10.h,
                                          //   height: 10.h,
                                          //   decoration: BoxDecoration(
                                          //     color: ColorUtils.calenderDatesCircle,
                                          //     borderRadius: BorderRadius.circular(50).w,
                                          //   ),
                                          // ),
                                          SizedBox(width: 5.h),
                                          AttendanceCommonWidgets().cachedNetworkImage(
                                            controller
                                                .notifications
                                                .value[index]
                                                .profilePicture ??
                                                '',
                                            height: 40.h,
                                          ),
                                        ],
                                      ),
                                      title: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: controller.notifications.value[index].employeeName ?? '',
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13.h,
                                                color: appView == AppView.manager ? ColorUtils.workEntryHead : ColorUtils.textWhite,
                                              ),
                                            ),
                                            TextSpan(
                                              text: ' has requested ',
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 13.h,
                                                color: appView == AppView.manager ? ColorUtils.workEntryHead : ColorUtils.textWhite,
                                              ),
                                            ),
                                            TextSpan(
                                              text: controller.notifications.value[index].type ?? '',
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 13.h,
                                                color: appView == AppView.manager ? ColorUtils.workEntryHead : ColorUtils.textWhite,
                                              ),
                                            ),
                                            // TextSpan(
                                            //   text: notificationResentList[i].hoursAgo,
                                            //   style: GoogleFonts.inter(
                                            //     fontWeight: FontWeight.w400,
                                            //     fontSize: 12.sp,
                                            //     color: ColorUtils.textWhite.withValues(alpha: 0.5),
                                            //   ),
                                            // ),
                                          ],
                                        ),

                                        // child: Text(
                                        //   "${controller.notifications.value[index].employeeName ?? ''} has requested a ${controller.notifications.value[index].type ?? ''} - ${controller.notifications.value[index].details ?? ''}",
                                        //   overflow: TextOverflow.ellipsis,
                                        //   maxLines: 3,
                                        //   style: GoogleFonts.poppins(
                                        //     fontWeight: FontWeight.w400,
                                        //     fontSize: 13.h,
                                        //     color: appView == AppView.manager ? ColorUtils.workEntryHead : ColorUtils.textWhite,
                                        //   ),
                                        // ),
                                      ),
                                      trailing: Text(
                                        timeAgo,
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12.sp,
                                          color: appView == AppView.manager ? ColorUtils.workEntryHead.withValues(alpha: 0.5) : ColorUtils.textWhite.withValues(alpha: 0.5),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                            separatorBuilder: (context, index) {
                              final current = controller.notifications[index];

                              // if() {}

                              // Don't show separator if this or next/prev item is a header
                              final isCurrentHeader = current.type == 'Recent' || current.type == 'Earlier';
                              // final isNextHeader = (index + 1 < controller.notifications.length) &&
                              //     (controller.notifications[index + 1].type == 'Recent' || controller.notifications[index + 1].type == 'Earlier');
                              final isPrevHeader = (index > 0) &&
                                  (controller.notifications[index + 1].type == 'Earlier');

                              if (isCurrentHeader || isPrevHeader) {
                                return SizedBox.shrink();
                              }

                              return Divider(
                                height: 0,
                                thickness: 0.2.h,
                                color: appView == AppView.manager
                                    ? ColorUtils.workEntryHead.withValues(alpha: 0.5)
                                    : ColorUtils.textWhite.withValues(alpha: 0.5),
                              );
                            },
                          ),
                        )
                    else if (controller.notificationError.value)
                        Expanded(
                          child: Center(
                            child: Text(
                              "Something went wrong",
                              style: GoogleFonts.poppins(
                                color: appView == AppView.manager ? ColorUtils.workEntryHead.withValues(alpha: 0.5) : ColorUtils.textWhite.withValues(alpha: 0.7),
                                fontWeight: FontWeight.w400,
                                fontSize: 13.h,
                              ),
                            ),
                          ),
                        ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
