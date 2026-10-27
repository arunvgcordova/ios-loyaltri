
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';

class MoreAppBar extends StatelessWidget {
  const MoreAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/manager_view/more_title_image.png",
            height: 27.h,
          ),
          SizedBox(width: 5.h),
          Text(
            "More",
            style: GoogleFonts.poppins(
              color: ColorUtils.workEntryHead,
              fontWeight: FontWeight.w500,
              fontSize: 16.h,
            ),
          ),
        ],
      ),
    );
  }
}
