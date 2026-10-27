import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/controller/appliedLeaveList.dart';
import '../../../models/leave_list_api_model.dart';
import '../../../utils/color_utils.dart';
import '../../ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'leave_detail_bottomSheet.dart';

class LeaveInfoCard extends StatelessWidget {
  final AppliedLeave appliedLeave;
  const LeaveInfoCard({super.key, required this.appliedLeave});

  @override
  Widget build(BuildContext context) {
    String fromDate = '--';
    String fromMonthYr = '--';
    String toDate = '--';
    String toMonthYr = '--';
    int totalLeaveHour = 0;
    try {
      if(appliedLeave.isHourBased == '1') {
        if(appliedLeave.leaveDate != null) {
          fromDate = DateFormat('dd').format(DateTime.parse(appliedLeave.leaveDate!));
          fromMonthYr = DateFormat('MMM | E').format(DateTime.parse(appliedLeave.leaveDate!));
          toDate = DateFormat('dd').format(DateTime.parse(appliedLeave.leaveDate!));
          toMonthYr = DateFormat('MMM | E').format(DateTime.parse(appliedLeave.leaveDate!));
          totalLeaveHour = int.tryParse(appliedLeave.totalLeaveTime ?? '0') ?? 0;
        }
      } else {
        if(appliedLeave.leaveDateFrom != null) {
          fromDate = DateFormat('dd').format(DateTime.parse(appliedLeave.leaveDateFrom!));
          fromMonthYr = DateFormat('MMM | E').format(DateTime.parse(appliedLeave.leaveDateFrom!));
        }
        if(appliedLeave.leaveDateTo != null) {
          toDate = DateFormat('dd').format(DateTime.parse(appliedLeave.leaveDateTo!));
          toMonthYr = DateFormat('MMM | E').format(DateTime.parse(appliedLeave.leaveDateTo!));
        }
      }
    } catch(e) {}
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          useSafeArea: true,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) {
            return LeaveDetailBottomSheet(appliedLeave: appliedLeave);
          },
        );
      },
      child: Container(
        width: ScreenUtil().screenWidth,
        height: 117.w,
        padding: const EdgeInsets.all(10).w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14).w,
          color: ColorUtils.backgroundBlack,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: ScreenUtil().screenWidth * 0.6,
                  child: Text(
                    appliedLeave.leaveType ?? '--',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                      color: ColorUtils.textWhite.withValues(alpha: 0.8),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 10.w,
                      height: 10.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50).w,
                        color: AttendanceCommonWidgets().hexToColor(appliedLeave.requestStatusColour),
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      appliedLeave.requestStatusName ?? '--',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                        color: AttendanceCommonWidgets().hexToColor(appliedLeave.requestStatusColour),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if(appliedLeave.isHourBased == '1')
              Row(
                children: [
                  Image.asset(
                    "assets/images/leave-calendar3d.webp",
                    width: 25.w,
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    fromDate,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 14.sp,
                      color: ColorUtils.textWhite,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    fromMonthYr,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                      color: ColorUtils.textWhite,
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    "-",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 14.sp,
                      color: ColorUtils.textWhite.withOpacity(0.5),
                    ),
                  ),
                  SizedBox(width: 5.w),
                  // Text(
                  //   toDate,
                  //   style: GoogleFonts.poppins(
                  //     fontWeight: FontWeight.w700,
                  //     fontSize: 14.sp,
                  //     color: ColorUtils.textWhite,
                  //   ),
                  // ),
                  // SizedBox(width: 3.w),
                  Text(
                    "$totalLeaveHour ${totalLeaveHour > 1 ? 'hours' : 'hour'}",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                      color: ColorUtils.textWhite,
                    ),
                  ),
                ],
              )
            else
              Row(
                children: [
                  Image.asset(
                    "assets/images/leave-calendar3d.webp",
                    width: 25.w,
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    fromDate,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 14.sp,
                      color: ColorUtils.textWhite,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    fromMonthYr,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                      color: ColorUtils.textWhite,
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    "-",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 14.sp,
                      color: ColorUtils.textWhite.withOpacity(0.5),
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    toDate,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 14.sp,
                      color: ColorUtils.textWhite,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    toMonthYr,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                      color: ColorUtils.textWhite,
                    ),
                  ),
                ],
              ),
            Row(
              children: [
                SizedBox(
                  width: 270.w,
                  child: Text(
                    appliedLeave.leaveReason ?? '--',
                    style: GoogleFonts.inter(
                      color: ColorUtils.textWhite.withValues(alpha: 0.5),
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
