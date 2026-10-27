import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/color_utils.dart';

class SignInWithButton extends StatelessWidget {
  final String icon;
  final String text;
  final double iconWidth;
  const SignInWithButton(
      {super.key,
      required this.icon,
      required this.text,
      required this.iconWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().screenWidth,
      height: 52.w,
      decoration: BoxDecoration(
        color: ColorUtils.backgroundBlack1,
        border: Border.all(
          width: 1.w,
          color: ColorUtils.foregroundBlack1,
        ),
        borderRadius: BorderRadius.circular(37).w,
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              icon,
              width: iconWidth.w,
              fit: BoxFit.fitWidth,
            ),
            SizedBox(width: 5.w),
            Text(
              text,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
                color: ColorUtils.textWhite.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
