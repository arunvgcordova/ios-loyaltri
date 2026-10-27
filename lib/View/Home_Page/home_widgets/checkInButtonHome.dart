
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/CWidgets/error_dialog.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/controller/attendanceUploadController.dart';
import '../../../utils/color_utils.dart';
import 'bottomSheet_chooseCheckType.dart';

class CheckInButtonHome extends StatelessWidget {
  final bool isChecked;
  final bool isPunchMethodsEmpty;
  const CheckInButtonHome({super.key, required this.isChecked, required this.isPunchMethodsEmpty});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          SizedBox(
            height: 50.w,
            child: FilledButton(
              onPressed: isPunchMethodsEmpty ? null : () async {
                String? msg = await Get.find<AttendanceUploadController>().checkInGuard();
                if(msg == null) {
                  chooseCheckTypeBottomSheet(
                    mainContext: context,
                    isIn: !isChecked,
                  );
                } else {
                  await HapticFeedback.lightImpact();
                  String? msg = "${!isChecked ? 'Check in' : 'Check out'} is not allowed within 3 minutes after ${!isChecked ? 'checkout' : 'check in'}. Please try again later.";
                  ErrorDialog().showWarn(
                      context: context,
                      title: "Message",
                      subTitle: msg);
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                    return ColorUtils.textWhite;
                  },
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!isChecked)
                    SvgPicture.asset(
                      "assets/images/finger_print.svg",
                    ),
                  if (isChecked)
                    SvgPicture.asset(
                      "assets/images/material-symbols_fingerprint.svg",
                    ),
                  SizedBox(width: 10.w),
                  Text(
                    !isChecked ? "Check In" : "Check Out",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                      color: !isChecked
                          ? ColorUtils.checkInBlue
                          : ColorUtils.checkOutRed,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if(isPunchMethodsEmpty)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  AttendanceCommonWidgets().showSnackBar(
                    context: context,
                    backgroundColor: ColorUtils.foregroundBlack4,
                    message: "Action Not Allowed",
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
