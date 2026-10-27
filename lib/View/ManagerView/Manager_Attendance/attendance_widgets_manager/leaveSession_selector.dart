
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/color_utils.dart';
import '../manager_attendance_controller/manager_attendance_controller.dart';

class LeaveSessionSelector extends StatelessWidget {
  const LeaveSessionSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<ManagerAttendanceController>(
      builder: (ManagerAttendanceController controller) {
        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Leave Session ",
                      style: GoogleFonts.dmSans(
                        fontSize: 13.h,
                        fontWeight: FontWeight.w500,
                        color: ColorUtils.workEntryHead,
                      ),
                    ),
                    Text(
                      "*",
                      style: GoogleFonts.dmSans(
                        fontSize: 13.h,
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 5.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(12).r,
                  onTap: () {
                    controller.selectedLeaveSession.value =
                        LeaveSessionType.firstHalf;
                  },
                  child: Container(
                    width: 150.w,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                      // horizontal: 13.h,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: ColorUtils.textWhite,
                      borderRadius: BorderRadius.circular(12).r,
                      border: Border.all(
                        color:
                        controller.selectedLeaveSession.value ==
                            LeaveSessionType.firstHalf
                            ? ColorUtils.secondaryBlue
                            : Color(0xFFB9B0B0),
                        width: 0.5.h,
                      ),
                      boxShadow:
                      controller.selectedLeaveSession.value ==
                          LeaveSessionType.firstHalf
                          ? [
                        BoxShadow(
                          color: ColorUtils.secondaryBlue
                              .withValues(alpha: 0.1),
                          blurRadius: 2,
                          spreadRadius: 0,
                          offset: Offset(0, 1),
                        ),
                        BoxShadow(
                          color: ColorUtils.secondaryBlue
                              .withValues(alpha: 0.09),
                          blurRadius: 3,
                          spreadRadius: 0,
                          offset: Offset(0, 3),
                        ),
                        BoxShadow(
                          color: ColorUtils.secondaryBlue
                              .withValues(alpha: 0.05),
                          blurRadius: 4,
                          spreadRadius: 0,
                          offset: Offset(0, 7),
                        ),
                        BoxShadow(
                          color: ColorUtils.secondaryBlue
                              .withValues(alpha: 0.01),
                          blurRadius: 5,
                          spreadRadius: 0,
                          offset: Offset(0, 12),
                        ),
                        BoxShadow(
                          color: ColorUtils.secondaryBlue
                              .withValues(alpha: 0),
                          blurRadius: 5,
                          spreadRadius: 0,
                          offset: Offset(0, 18),
                        ),
                      ]
                          : [],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset(
                          "assets/images/manager_view/first_half.svg",
                          height: 23.h,
                          colorFilter: ColorFilter.mode(
                            controller.selectedLeaveSession.value ==
                                LeaveSessionType.firstHalf
                                ? ColorUtils.secondaryBlue
                                : Color(0xFFABABAB),
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(width: 8.h),
                        Text(
                          "First Half",
                          style: GoogleFonts.dmSans(
                            fontSize: 15.h,
                            fontWeight: FontWeight.w400,
                            color:
                            controller.selectedLeaveSession.value ==
                                LeaveSessionType.firstHalf
                                ? ColorUtils.workEntryHead
                                : Color(0xFFABABAB),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 15.h),
                InkWell(
                  borderRadius: BorderRadius.circular(12).r,
                  onTap: () {
                    controller.selectedLeaveSession.value =
                        LeaveSessionType.secondHalf;
                  },
                  child: Container(
                    width: 150.w,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                      // horizontal: 13.h,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: ColorUtils.textWhite,
                      borderRadius: BorderRadius.circular(12).r,
                      border: Border.all(
                        color:
                        controller.selectedLeaveSession.value ==
                            LeaveSessionType.secondHalf
                            ? ColorUtils.secondaryBlue
                            : Color(0xFFB9B0B0),
                        width: 0.5.h,
                      ),
                      boxShadow:
                      controller.selectedLeaveSession.value ==
                          LeaveSessionType.secondHalf
                          ? [
                        BoxShadow(
                          color: ColorUtils.secondaryBlue
                              .withValues(alpha: 0.1),
                          blurRadius: 2,
                          spreadRadius: 0,
                          offset: Offset(0, 1),
                        ),
                        BoxShadow(
                          color: ColorUtils.secondaryBlue
                              .withValues(alpha: 0.09),
                          blurRadius: 3,
                          spreadRadius: 0,
                          offset: Offset(0, 3),
                        ),
                        BoxShadow(
                          color: ColorUtils.secondaryBlue
                              .withValues(alpha: 0.05),
                          blurRadius: 4,
                          spreadRadius: 0,
                          offset: Offset(0, 7),
                        ),
                        BoxShadow(
                          color: ColorUtils.secondaryBlue
                              .withValues(alpha: 0.01),
                          blurRadius: 5,
                          spreadRadius: 0,
                          offset: Offset(0, 12),
                        ),
                        BoxShadow(
                          color: ColorUtils.secondaryBlue
                              .withValues(alpha: 0),
                          blurRadius: 5,
                          spreadRadius: 0,
                          offset: Offset(0, 18),
                        ),
                      ]
                          : [],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset(
                          "assets/images/manager_view/second_half.svg",
                          height: 23.h,
                          colorFilter: ColorFilter.mode(
                            controller.selectedLeaveSession.value ==
                                LeaveSessionType.secondHalf
                                ? ColorUtils.secondaryBlue
                                : Color(0xFFABABAB),
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(width: 8.h),
                        Text(
                          "Second Half",
                          style: GoogleFonts.dmSans(
                            fontSize: 15.h,
                            fontWeight: FontWeight.w400,
                            color:
                            controller.selectedLeaveSession.value ==
                                LeaveSessionType.secondHalf
                                ? ColorUtils.workEntryHead
                                : Color(0xFFABABAB),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if(controller.showLeaveSessionValidation.value)
              Padding(
                padding: EdgeInsets.only(top: 5, left: 5).h,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Leave Session is required",
                        style: GoogleFonts.inter(
                          height: 1.h,
                          color: Colors.red,
                          fontSize: 12.h,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
