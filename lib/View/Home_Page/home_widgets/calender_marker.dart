import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/color_utils.dart';

class CalenderMarkerBuilder extends StatelessWidget {
  final DateTime date;
  const CalenderMarkerBuilder({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 29.w,
        height: 29.w,
        decoration: BoxDecoration(
          color: ColorUtils.backgroundBlack,
          borderRadius: BorderRadius.circular(50).w,
          border: Border.all(
            color: ColorUtils.leaveCircle,
          ),
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
