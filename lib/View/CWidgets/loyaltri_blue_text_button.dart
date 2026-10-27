import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/color_utils.dart';

class LoyaltriBlueTextButton extends StatelessWidget {
  final String text;
  final bool? showLoading;
  const LoyaltriBlueTextButton({
    super.key,
    required this.text,
    this.showLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().screenWidth,
      height: 52.h,
      decoration: BoxDecoration(
        color: ColorUtils.secondaryBlue,
        borderRadius: BorderRadius.circular(37).r,
      ),
      child: Center(
        child: (showLoading ?? false)
            ? SizedBox(
                width: 15.h,
                height: 15.h,
                child: CircularProgressIndicator(color: ColorUtils.textWhite),
              )
            : Text(
                text,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 14.h,
                  color: ColorUtils.textWhite,
                ),
              ),
      ),
    );
  }
}

class LoyaltriBlueIconTextButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  const LoyaltriBlueIconTextButton({super.key, required this.text, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().screenWidth,
      height: 52.h,
      decoration: BoxDecoration(
        color: ColorUtils.secondaryBlue,
        borderRadius: BorderRadius.circular(37).r,
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              const Icon(Icons.add, color: ColorUtils.textWhite),
            Text(
              text,
              style: GoogleFonts.poppins(
                color: ColorUtils.textWhite,
                fontWeight: FontWeight.w500,
                fontSize: 16.h,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

BoxDecoration blueTextButtonDecoration = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      ColorUtils.workEntryHead.withOpacity(0),
      ColorUtils.workEntryHead.withOpacity(0.2),
      ColorUtils.workEntryHead.withOpacity(0.4),
      ColorUtils.workEntryHead.withOpacity(1),
      ColorUtils.workEntryHead.withOpacity(1),
      ColorUtils.workEntryHead.withOpacity(1),
    ],
  ),
);
