
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/manager_attendance_controller/manager_attendance_controller.dart';

import '../../../../utils/color_utils.dart';

class LeaveReasonSelector extends StatelessWidget {
  const LeaveReasonSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<ManagerAttendanceController>(
      builder: (ManagerAttendanceController controller) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15).h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12).r,
                color: ColorUtils.textWhite,
                border: Border.all(color: controller.showLeaveReasonValidation.value ? Colors.red : Color(0xFFB9B0B0), width: 0.5.h),
                // border: textFieldBoarder(requestType),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Reason ",
                        style: GoogleFonts.inter(
                          color: ColorUtils.workEntryHead,
                          fontWeight: FontWeight.w400,
                          fontSize: 13.h,
                        ),
                      ),
                      Text(
                        "*",
                        style: GoogleFonts.inter(
                          color: Colors.red,
                          fontWeight: FontWeight.w400,
                          fontSize: 13.h,
                        ),
                      ),
                    ],
                  ),
                  TextField(
                    // controller: reasonController,
                    // focusNode: reasonFocusNode,
                    // readOnly: hideButton,
                    onChanged: (value) => controller.halfDayReasonText.value = value,
                    style: GoogleFonts.inter(
                      color: ColorUtils.workEntryHead,
                      fontWeight: FontWeight.w400,
                      fontSize: 11.h,
                    ),
                    decoration: InputDecoration(
                      hintText: "Eg: Due to fever",
                      contentPadding: const EdgeInsets.all(0),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      hintStyle: GoogleFonts.dmSans(
                        color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                        fontWeight: FontWeight.w400,
                        fontSize: 15.h,
                      ),
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            if(controller.showLeaveReasonValidation.value)
              Padding(
                padding: EdgeInsets.only(top: 5, left: 5).h,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Reason is required",
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
      }
    );
  }
}
