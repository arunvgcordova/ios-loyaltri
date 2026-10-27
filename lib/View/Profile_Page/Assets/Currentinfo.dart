import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/color_utils.dart';
class CurrentInfo extends StatelessWidget {
  final String? text1;
  final String? text2;
  const CurrentInfo({super.key, this.text1, this.text2});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 79.w,
      padding: const EdgeInsets.all(15).h,
      width: ScreenUtil().screenWidth,
      decoration: BoxDecoration(
          color: const Color(0xff101012),
          borderRadius: BorderRadius.circular(14.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text1 ?? '--',
            style: GoogleFonts.poppins(
              color: ColorUtils.textWhite.withValues(alpha: 0.9),
              fontWeight: FontWeight.w500,
              fontSize: 15.h,
            ),
          ),
          Text(
            text2 ?? '--',
            style: GoogleFonts.poppins(
                color: ColorUtils.textWhite.withValues(alpha: 0.5),
                fontWeight: FontWeight.w400,
                fontSize: 14.h,
            ),
          ),
        ],
      ),
    );
  }
}
