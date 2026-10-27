import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../utils/color_utils.dart';

class CalenderHeaderTitle extends StatelessWidget {
  final DateTime date;
  const CalenderHeaderTitle({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        DateFormat('MMMM yyyy').format(date),
        style: GoogleFonts.poppins(
          fontSize: 13.h,
          fontWeight: FontWeight.w400,
          color: ColorUtils.textWhite,
        ),
      ),
    );
  }
}

class LeaveCalenderHeaderTitle extends StatelessWidget {
  final DateTime date;
  const LeaveCalenderHeaderTitle({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Text(
      DateFormat.yMMM().format(date),
      style: GoogleFonts.poppins(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: ColorUtils.textWhite,
      ),
    );
  }
}
