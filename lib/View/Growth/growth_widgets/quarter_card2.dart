
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/color_utils.dart';

class QuarterCard2 extends StatelessWidget {
  const QuarterCard2({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10).h,
      child: Container(
        padding: EdgeInsets.only(
          top: 2.h,
          bottom: 8.h,
          left: 10.h,
          right: 10.h,
        ),
        decoration: BoxDecoration(
          color: ColorUtils.midnightIndigo,
          borderRadius: BorderRadius.circular(10).r,
          border: Border.all(
            color: ColorUtils.carbonGrey,
            width: 0.5.h,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(4.h),
                  decoration: BoxDecoration(
                    color: ColorUtils.workEntryHead.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6).r,
                  ),
                  child: Image.asset(
                    'assets/images/growth/quarter-green.png',
                    height: 32.h,
                  ),
                ),
                SizedBox(width: 8.h),
                Expanded(
                  child: Text(
                    'Quarter 1',
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 12.h,
                      fontWeight: FontWeight.w500,
                      color: ColorUtils.textWhite,
                    ),
                  ),
                ),
                SizedBox(width: 10.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 4.h,
                    horizontal: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: ColorUtils.powderBlue,
                    borderRadius: BorderRadius.circular(40).r,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/growth/hint-blue.png',
                        height: 13.h,
                      ),
                      SizedBox(width: 5.h),
                      Text(
                        'Completed',
                        style: GoogleFonts.inter(
                          fontSize: 11.h,
                          fontWeight: FontWeight.w500,
                          color: ColorUtils.deepForestGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            Row(
              children: [
                Image.asset(
                  'assets/images/growth/calendar-fullwhite.png',
                  height: 10.h,
                ),
                SizedBox(width: 6.h),
                Text(
                  'Jan - Mar',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                    fontSize: 11.h,
                    color: ColorUtils.textWhite,
                  ),
                ),
                Spacer(),
                Text(
                  'Score :',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                    fontSize: 11.h,
                    color: ColorUtils.textWhite,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
