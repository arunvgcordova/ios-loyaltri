
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/manager_attendance_controller/manager_attendance_controller.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/attendance_type_buttons.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';

class EditAttSaveButton extends StatelessWidget {
  final String cancelText;
  final String confirmText;
  final String? confirmIcon;
  final Function actionSuccess;
  final Function actionCancel;
  const EditAttSaveButton({super.key, required this.cancelText, required this.confirmText, this.confirmIcon, required this.actionSuccess, required this.actionCancel});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(37).r,
            onTap: () {
              actionCancel.call();
            },
            child: Container(
              padding: EdgeInsets.all(1).h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(37).r,
                color: ColorUtils.ashGrey,
              ),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(36).r,
                  color: ColorUtils.textWhite,
                ),
                child: Text(
                  cancelText,
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w500,
                    fontSize: 15.h,
                    color: ColorUtils.workEntryHead,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 10.h),
        Expanded(
          child: Obx(() => InkWell(
              borderRadius: BorderRadius.circular(37).r,
              onTap: () async {
                await actionSuccess.call();
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(37).r,
                  color: ColorUtils.secondaryBlue,
                ),
                child: Get.find<ManagerAttendanceController>().attSubmissionLoading.value
                    ? SizedBox(
                  width: 20.h,
                    height: 20.h,
                    child: CircularProgressIndicator(color: Colors.white),
                )
                    : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if(confirmIcon != null)
                      SvgPicture.asset(
                        confirmIcon!,
                        height: 19.h,
                      ),
                    if(confirmIcon != null)
                      SizedBox(width: 5.h),
                    Text(
                      confirmText,
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w500,
                        fontSize: 15.h,
                        color: ColorUtils.textWhite,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
