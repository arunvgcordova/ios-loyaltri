import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';

class CalenderWeek extends StatelessWidget {
  final String week;
  const CalenderWeek({super.key, required this.week});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          week,
          style: GoogleFonts.poppins(
            color: ColorUtils.textWhite.withOpacity(0.5),
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }
}

class LeaveCalenderWeek extends StatelessWidget {
  final String week;
  final bool isDark;
  const LeaveCalenderWeek({super.key, required this.week, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          week,
          style: GoogleFonts.inter(
            color: isDark ? const Color(0xFFB5BEC6) : ColorUtils.workEntryHead,
            fontWeight: FontWeight.w500,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }
}
