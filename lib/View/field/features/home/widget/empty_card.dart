import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/field/core/colour_utils.dart';
import 'package:loyaltri_minimal/View/field/core/utils.dart';

class EmptyWorkInProgressCard extends StatelessWidget {
   const EmptyWorkInProgressCard({super.key});
 
   @override
   Widget build(BuildContext context) {
     return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        // color: ColourUtils.cardBackground,
        gradient: LinearGradient(
          begin: AlignmentGeometry.topCenter,
          end: AlignmentGeometry.bottomCenter,
          colors: [
            ColourUtils.gdColour1S,
            ColourUtils.gdColour1E,
            ColourUtils.gdColour1E,
          ],
        ),
        borderRadius: BorderRadius.circular(12.h),
        border: Border.all(color: ColourUtils.borderColour, width: 1.h),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          pngWidget(height: 120.h, width: 145.w, icon: 'empty_work'),
          SizedBox(height: 10.h),
          Text(
            "No work for now",
            style: GoogleFonts.inter(
              fontSize: 16.h,
              fontWeight: FontWeight.w600,
              color: ColourUtils.textWhite,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            "You have no upcoming work or work in progress",
            style: GoogleFonts.inter(
              fontSize: 14.h,
              fontWeight: FontWeight.w400,
              color: ColourUtils.textWhite.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );;
   }
 }
