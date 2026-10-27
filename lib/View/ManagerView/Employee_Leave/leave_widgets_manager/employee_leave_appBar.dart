
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';

class ManagerScreensAppBar extends StatelessWidget {
  final String title;
  final String? icon;
  final Function? cancelAction;
  final Function? okAction;
  final bool? isDark;
  const ManagerScreensAppBar({super.key, required this.title, this.icon, this.cancelAction, this.okAction, this.isDark});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if(cancelAction != null)
            InkWell(
              borderRadius: BorderRadius.circular(14).r,
              onTap: () {
                cancelAction!.call();
              },
              child: Container(
                width: 48.h,
                height: 48.h,
                decoration: BoxDecoration(
                  color: (isDark ?? false) ? ColorUtils.backgroundBlack : ColorUtils.textWhite,
                  borderRadius: BorderRadius.circular(14).r,
                ),
                child: Center(
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: (isDark ?? false) ? ColorUtils.textWhite : ColorUtils.workEntryHead,
                    size: 20.h,
                  ),
                ),
              ),
            ),
          Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if(icon != null)
                Image.asset(
                  icon!,
                  height: 23.h,
                  fit: BoxFit.fitHeight,
                ),
              if(icon != null)
                SizedBox(width: 5.h),
              Text(
                title,
                style: GoogleFonts.dmSans(
                  color: (isDark ?? false) ? ColorUtils.textWhite : ColorUtils.workEntryHead,
                  fontWeight: FontWeight.w500,
                  fontSize: 15.h,
                ),
              ),
            ],
          ),
          Spacer(),
          if(okAction != null)
            InkWell(
              borderRadius: BorderRadius.circular(14).r,
              onTap: () {
                okAction!.call();
              },
              child: Container(
                width: 48.h,
                height: 48.h,
                decoration: BoxDecoration(
                  color: (isDark ?? false) ? ColorUtils.backgroundBlack : ColorUtils.textWhite,
                  // color: Colors.transparent,
                  borderRadius: BorderRadius.circular(14).r,
                ),
                child: Center(
                  child: Icon(
                    Icons.add,
                    // color: Colors.transparent,
                    color: ColorUtils.secondaryBlue,
                    size: 25.h,
                  ),
                ),
              ),
            )
          else
            Container(
              width: 48.h,
              height: 48.h,
              color: Colors.transparent,
            ),
        ],
      ),
    );
  }
}
