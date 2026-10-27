import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/color_utils.dart';
import 'app_bar.dart';

class QuarterScore extends StatelessWidget {
  const QuarterScore({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.workEntryHead,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 13.h, vertical: 10.h),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/growth/growth-home-pattern.png'),
            alignment: Alignment.topCenter,
            fit: BoxFit.fitWidth,
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.6],
            colors: [ColorUtils.mediumViolet, ColorUtils.workEntryHead],
          ),
        ),
        child: Column(
          children: [
            GrowthAppBar(title: ''),
            SizedBox(height: 30.h),
            Row(
              children: [
                SizedBox(width: 8.h),
                Text(
                  'Q3',
                  style: GoogleFonts.urbanist(
                    fontSize: 19.h,
                    fontWeight: FontWeight.w600,
                    color: ColorUtils.textWhite,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(width: 8.h),
                Text(
                  '30 Mar 2025',
                  style: GoogleFonts.urbanist(
                    fontSize: 13.h,
                    fontWeight: FontWeight.w500,
                    color: ColorUtils.textWhite.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(width: 8.h),
                Text(
                  '65%',
                  style: GoogleFonts.inter(
                    fontSize: 57.h,
                    fontWeight: FontWeight.w600,
                    color: ColorUtils.textWhite,
                  ),
                ),
                SizedBox(width: 4.h),
                Padding(
                  padding: EdgeInsets.only(bottom: 13.h),
                  child: Text(
                    'Performance Score',
                    style: GoogleFonts.urbanist(
                      fontSize: 21.h,
                      fontWeight: FontWeight.w600,
                      color: ColorUtils.textWhite,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 80.h),
            Container(
              padding: EdgeInsets.all(15.h),
              decoration: BoxDecoration(
                color: ColorUtils.deepMidnightPurple,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 19.h,
                        height: 16.h,
                        decoration: BoxDecoration(
                          color: ColorUtils.textWhite,
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                        child: Icon(
                          Icons.menu,
                          color: ColorUtils.deepMidnightPurple,
                          size: 15.h,
                        ),
                      ),
                      SizedBox(width: 10.h),
                      Text(
                        'Comment',
                        style: GoogleFonts.urbanist(
                          color: ColorUtils.textWhite,
                          fontWeight: FontWeight.w400,
                          fontSize: 13.h,
                          letterSpacing: -0.1,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  SelectableText(
                    'Good progress observed in task execution. With a bit more '
                    'focus on time management and communication, performance'
                    ' can reach an even higher level.',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: 15.h,
                      color: ColorUtils.textWhite,
                      letterSpacing: -0.1,
                    ),
                  ),
                  SizedBox(height: 15.h),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(15.h),
        child: InkWell(
          borderRadius: BorderRadius.circular(37).r,
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            width: ScreenUtil().screenWidth,
            height: 50.h,
            decoration: BoxDecoration(
              color: ColorUtils.darkIndigoGrey,
              borderRadius: BorderRadius.circular(37).r,
            ),
            child: Center(
              child: Text(
                'Close',
                style: GoogleFonts.inter(
                  color: ColorUtils.textWhite,
                  fontWeight: FontWeight.w600,
                  fontSize: 13.h,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
