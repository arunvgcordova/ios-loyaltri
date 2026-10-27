
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/manager_attendance_controller/manager_attendance_controller.dart';

import '../../../../utils/color_utils.dart';
import 'leaveType_selector.dart';
import 'leave_reason_selector.dart';

class PaidLeaveView extends StatelessWidget {
  const PaidLeaveView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 13.h, vertical: 10.h),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 8.h,
              horizontal: 8.h,
            ),
            decoration: BoxDecoration(
              color: Color(0xFFE4E8EB),
              borderRadius: BorderRadius.circular(7).r,
            ),
            child: Row(
              children: [
                Image.asset(
                  "assets/images/manager_view/attendance.png",
                  color: ColorUtils.workEntryHead,
                  height: 20.h,
                ),
                SizedBox(width: 8.h),
                Text(
                  "Total Leave Balance",
                  style: GoogleFonts.dmSans(
                    fontSize: 12.h,
                    fontWeight: FontWeight.w500,
                    color: ColorUtils.workEntryHead,
                  ),
                ),
                Spacer(),
                Obx(() {
                    return Text(
                      Get.find<ManagerAttendanceController>().employeeLeaveData.value?.leaveBalance ?? '--',
                      style: GoogleFonts.dmSans(
                        fontSize: 15.h,
                        fontWeight: FontWeight.w500,
                        color: ColorUtils.workEntryHead,
                      ),
                    );
                  }
                ),
              ],
            ),
          ),
          SizedBox(height: 18.h),
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
          SizedBox(height: 6.h),
          LeaveTypeSelector(),
          // Container(
          //   padding: EdgeInsets.all(0.5).h,
          //   decoration: BoxDecoration(
          //     color: Color(0xFFB9B0B0),
          //     borderRadius: BorderRadius.circular(12).r,
          //   ),
          //   child: Container(
          //     padding: EdgeInsets.symmetric(horizontal: 13.h, vertical: 12.h),
          //     decoration: BoxDecoration(
          //       color: ColorUtils.textWhite,
          //       borderRadius: BorderRadius.circular(11).r,
          //       // border: Border.all(
          //       //   color: Color(0xFFB9B0B0),
          //       //   width: 0.5.h,
          //       // ),
          //     ),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Text(
          //           "Select shift name",
          //           style: GoogleFonts.dmSans(
          //             fontSize: 14.h,
          //             fontWeight: FontWeight.w400,
          //             color: Color(0xFFABABAB),
          //           ),
          //         ),
          //         SvgPicture.asset(
          //           "assets/images/manager_view/arrow_down_deductionType.svg",
          //           height: 8.h,
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          SizedBox(height: 20.h),
          LeaveReasonSelector(),
          // Container(
          //   padding: const EdgeInsets.all(15).h,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(12).r,
          //     color: ColorUtils.textWhite,
          //     border: Border.all(color: Color(0xFFB9B0B0), width: 0.5.h),
          //     // border: textFieldBoarder(requestType),
          //   ),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text(
          //         "Reason",
          //         style: GoogleFonts.inter(
          //           color: ColorUtils.workEntryHead,
          //           fontWeight: FontWeight.w400,
          //           fontSize: 13.h,
          //         ),
          //       ),
          //       TextField(
          //         // controller: reasonController,
          //         // focusNode: reasonFocusNode,
          //         // readOnly: hideButton,
          //         style: GoogleFonts.inter(
          //           color: ColorUtils.workEntryHead,
          //           fontWeight: FontWeight.w400,
          //           fontSize: 11.h,
          //         ),
          //         decoration: InputDecoration(
          //           hintText: "Eg: heavy fever...",
          //           contentPadding: const EdgeInsets.all(0),
          //           border: const OutlineInputBorder(
          //             borderSide: BorderSide.none,
          //           ),
          //           hintStyle: GoogleFonts.dmSans(
          //             color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
          //             fontWeight: FontWeight.w400,
          //             fontSize: 15.h,
          //           ),
          //         ),
          //         maxLines: 2,
          //       ),
          //     ],
          //   ),
          // ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
