
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';

class RequestAppBar extends StatelessWidget {
  final String title;
  final String? icon;
  const RequestAppBar({super.key, required this.title, this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              width: 48.h,
              height: 48.h,
              decoration: BoxDecoration(
                color: ColorUtils.textWhite,
                borderRadius: BorderRadius.circular(14).r,
              ),
              child: Center(
                  child: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: ColorUtils.workEntryHead,
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
                  height: title.toLowerCase().contains('shift') ? 25.h : 21.h,
                ),
              if(icon != null)
                SizedBox(width: 5.h),
              Text(
                title,
                style: GoogleFonts.poppins(
                  color: ColorUtils.workEntryHead,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.h,
                ),
              ),
            ],
          ),
          Spacer(),
          Container(
            width: 48.h,
            height: 48.h,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(14).r,
            ),
          ),
        ],
      ),
    );
  }
}
