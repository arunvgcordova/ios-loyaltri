

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/CWidgets/cwidgets.dart';
import 'package:loyaltri_minimal/View/ManagerView/Feed_Page/Feed_Home.dart';
import 'package:loyaltri_minimal/controller/userAuthentication.dart';

import '../Manager_Attendance/attendance_widgets_manager/common_widgets.dart';

import '../../../utils/color_utils.dart';
import '../../NotificationScreen/NotificationScreen.dart';
import '../Feed_Page/create_feed.dart';
import '../Manager_Request/request_wigets_manager/request_app_bar.dart';

class ManagerFeedPage extends StatefulWidget {
  const ManagerFeedPage({super.key});

  @override
  State<ManagerFeedPage> createState() => _ManagerFeedPageState();
}

class _ManagerFeedPageState extends State<ManagerFeedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          gradientContainer1,
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: 15.h,
                    left: 15.w,
                    right: 15.w,
                    bottom: 10.h,
                  ),
                  child: SizedBox(
                    height: 50.h,
                    child: GetX<UserAuthController>(
                      builder: (UserAuthController controller) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if(controller.postFeed.value)
                              InkWell(
                              onTap: () {
                                if(controller.postFeed.value) {
                                  Navigator.of(context).push(
                                    newSlideNavigation(CreateFeed()),
                                  );
                                } else {
                                  AttendanceCommonWidgets().showGetSnackBar(
                                    title: 'Message',
                                    message: 'You don\'t have permission to post to the feed.',
                                    backgroundColor: ColorUtils.offDayColor,
                                    colorText: ColorUtils.workEntryHead,
                                  );
                                }
                              },
                              child: Container(
                                width: 48.h,
                                height: 48.h,
                                decoration: BoxDecoration(
                                  color: ColorUtils.textWhite,
                                  borderRadius: BorderRadius.circular(14).r,
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    "assets/images/manager_view/add_feed_blue.svg",
                                    width: 18.h,
                                  ),
                                ),
                              ),
                            )
                            else
                              Container(
                                width: 48.h,
                                height: 48.h,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(14).r,
                                ),
                              ),
                            Spacer(),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  width: 25.w,
                                  "assets/images/feed_icon.svg",
                                ),
                                SizedBox(width: 5.h),
                                Text(
                                  "Feed",
                                  style: GoogleFonts.poppins(
                                    color: ColorUtils.workEntryHead,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.h,
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Container(
                              width: 48.h,
                              height: 48.h,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(14).r,
                              ),
                            )
                          ],
                        );
                      }
                    ),
                  ),
                ),
                Expanded(child: FeedViewHomeEmployee()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
