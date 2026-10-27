import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/color_utils.dart';

class DocInfo extends StatelessWidget {
  final String fstname;
  final String scndname;
  const DocInfo({super.key, required this.fstname, required this.scndname});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 91.w,
      // width: 362.w,
      padding: EdgeInsets.symmetric(
        vertical: 15.h,
        horizontal: 10.h,
      ),
      decoration: BoxDecoration(
        color: Color(0xff101012),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/images/Files.svg',
            width: 32.w,
            height: 32.w,
          ),
          SizedBox(width: 10.h),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Spacer(),
                Text(
                  fstname,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: ColorUtils.textWhite.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w500,
                    fontSize: 14.h,
                  ),
                ),
                Text(
                  scndname,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: ColorUtils.textWhite.withValues(alpha: 0.5),
                    fontWeight: FontWeight.w400,
                    fontSize: 14.h,
                    textStyle: TextStyle(overflow: TextOverflow.ellipsis),
                  ),
                ),
                // Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
