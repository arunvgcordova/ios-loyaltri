import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/color_utils.dart';

class HolidayBuilder extends StatelessWidget {
  final DateTime date;
  const HolidayBuilder({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 29.w,
        height: 29.w,
        decoration: BoxDecoration(
          color: ColorUtils.deepForestGreen,
          borderRadius: BorderRadius.circular(50).w,
        ),
        child: Center(
          child: Text(
            '${date.day}',
            style: GoogleFonts.poppins(
              color: ColorUtils.textWhite,
              fontWeight: FontWeight.w400,
              fontSize: 12.sp,
            ),
          ),
        ),
      ),
    );
  }
}
