import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Home/home_widgets/action_centre_tile.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Home/manager_home_controller/manager_home_controller.dart';
import '../../../../utils/color_utils.dart';

class ActionCentre extends StatelessWidget {
  const ActionCentre({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<ManagerHomeController>( builder: (ManagerHomeController controller) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.h),
        child: Container(
          width: ScreenUtil().screenWidth,
          // height: 282.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20).r,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                ColorUtils.flameOrange,
                ColorUtils.electricMagenta,
                ColorUtils.secondaryBlue,
              ],
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 3.h, left: 3.h, right: 3.h),
                child: Container(
                  // height: 247.h,
                  width: ScreenUtil().screenWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16).r,
                    color: ColorUtils.textWhite,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          right: 10.h,
                          left: 10.h,
                          top: 10.h,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  "assets/images/manager_view/request_icon.png",
                                  height: 23.h,
                                ),
                                SizedBox(width: 5.h),
                                Text(
                                  'Action Center',
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    fontSize: 13.h,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 6.h),
                                if (controller.actionDataList.isNotEmpty)
                                  Container(
                                    width: 20.h,
                                    height: 18.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4).r,
                                      color: ColorUtils.secondaryBlue,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "${controller.actionDataList.length}",
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.inter(
                                          color: ColorUtils.textWhite,
                                          fontSize: 10.h,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            // Row(
                            //   children: [
                            //     Text(
                            //       'View All',
                            //       overflow: TextOverflow.ellipsis,
                            //       style: GoogleFonts.inter(
                            //         color: ColorUtils.workEntryHead,
                            //         fontSize: 12.h,
                            //         fontWeight: FontWeight.w500,
                            //       ),
                            //     ),
                            //     SizedBox(width: 3.h),
                            //     Icon(
                            //       Icons.arrow_forward_ios_outlined,
                            //       color: ColorUtils.workEntryHead,
                            //       size: 9.h,
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Divider(
                        color: ColorUtils.workEntryHead.withValues(alpha: 0.1),
                        height: 0,
                      ),
                      // _NoActionView(),
                      SizedBox(height: 8.h),
                      if (controller.actionDataList.isNotEmpty)
                        for (
                        int index = 0;
                        index < controller.actionDataList.length;
                        index++
                        )
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ActionCentreTile(
                                actionData: controller.actionDataList[index],
                              ),
                              SizedBox(height: 8.h),
                            ],
                          )
                      else
                        _NoActionView(),
                      SizedBox(height: 8.h),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 6.h),
                child: Row(
                  children: [
                    Expanded(
                      child: AnimatedOpacity(
                        opacity: controller.opacity.value,
                        duration: Duration(milliseconds: 500),
                        child: Text(
                          controller.progressTextContent.value,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 13.h,
                            color: ColorUtils.textWhite,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _NoActionView extends StatelessWidget {
  const _NoActionView();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 13.h),
      child: Row(
        children: [
          Image.asset(
            "assets/images/manager_view/no_actions.png",
            height: 57.h,
          ),
          SizedBox(width: 10.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "No actions for now!",
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 15.h,
                  color: ColorUtils.workEntryHead,
                ),
              ),
              Text(
                "Time to focus on what matters!",
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w400,
                  fontSize: 12.h,
                  color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
