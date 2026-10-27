

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/color_utils.dart';

class TotalBreakHour extends StatelessWidget {
  final String breakDuration;
  const TotalBreakHour({super.key, required this.breakDuration});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          "assets/images/total_break_hour.png",
          height: 18.w,
          fit: BoxFit.fitHeight,
        ),
        SizedBox(width: 5.w),
        Text(
          "Total Break Time",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 12.sp,
            color: ColorUtils.textWhite.withOpacity(0.6),
          ),
        ),
        SizedBox(width: 5.w),
        Text(
          convertMinutesToHoursMinutes(breakDuration),
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 12.sp,
            color: ColorUtils.textWhite,
          ),
        ),
      ],
    );
  }

  String convertMinutesToHoursMinutes(String input) {
    // Extract the number from the input string
    int totalMinutes = int.parse(input.split(' ')[0]);

    // Calculate hours and remaining minutes
    int hours = totalMinutes ~/ 60;
    int minutes = totalMinutes % 60;

    // Format the result
    String formattedTime = '${hours}h:${minutes.toString().padLeft(2, '0')}m';
    return formattedTime;
  }
}
