import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../controller/ui_controller/home_controller.dart';
import '../../../controller/ui_controller/page_controller.dart';
import '../../../utils/color_utils.dart';

class OutsideBuilder extends StatelessWidget {
  final DateTime date;
  const OutsideBuilder({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    bool isDark = Get.find<UserPageController>().appView.value == AppView.employee;
    return Center(
      child: Container(
        width: 29.w,
        height: 29.w,
        decoration: BoxDecoration(
          color: isDark ? ColorUtils.backgroundBlack : ColorUtils.workEntryHead.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(50).w,
        ),
        child: Center(
          child: Text(
            '${date.day}',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w400,
              fontSize: 12.sp,
              color: isDark ? ColorUtils.textWhite.withValues(alpha: 0.5) : ColorUtils.workEntryHead,
            ),
          ),
        ),
      ),
    );
  }
}
