import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/halfDay_time_selector.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/leaveSession_selector.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/leaveType_selector.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/leave_reason_selector.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/shift_selector.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/manager_attendance_controller/manager_attendance_controller.dart';

import '../../../../utils/color_utils.dart';

class HalfDayView extends StatelessWidget {
  const HalfDayView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 13.h),
      child: Column(
        children: [
          SizedBox(height: 15.h),
          Row(
            children: [
              Text(
                "Shift Name ",
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
          SizedBox(height: 5.h),
          ShiftSelector(),
          SizedBox(height: 15.h),
          HalfDayTimeSelector(),
          SizedBox(height: 20.h),
          Divider(color: Color(0xFFE5E5E5), height: 0.h, thickness: 1.h),
          SizedBox(height: 15.h),
          Row(
            children: [
              Text(
                "Leave Type ",
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
          SizedBox(height: 5.h),
          LeaveTypeSelector(),
          SizedBox(height: 18.h),
          LeaveSessionSelector(),
          SizedBox(height: 20.h),
          LeaveReasonSelector(),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
