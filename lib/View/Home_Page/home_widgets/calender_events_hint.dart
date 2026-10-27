import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/color_utils.dart';

class CalenderEventsHint extends StatelessWidget {
  const CalenderEventsHint({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.circle,
              color: ColorUtils.dutyCircle,
              size: 8.43,
            ),
            Padding(
              padding: EdgeInsets.only(left: 2.w, right: 4.w),
              child: Text(
                "Duty",
                style: GoogleFonts.poppins(
                  color: ColorUtils.textWhite.withOpacity(0.5),
                  fontWeight: FontWeight.w400,
                  fontSize: 10.sp,
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.circle_outlined,
              color: ColorUtils.leaveCircle,
              size: 8.43,
            ),
            Padding(
              padding: EdgeInsets.only(left: 2.w, right: 4.w),
              child: Text(
                "Leave",
                style: GoogleFonts.poppins(
                  color: ColorUtils.textWhite.withOpacity(0.5),
                  fontWeight: FontWeight.w400,
                  fontSize: 10.sp,
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.circle,
              color: Colors.orange,
              size: 8.43,
            ),
            Padding(
              padding: EdgeInsets.only(left: 2.w, right: 4.w),
              child: Text(
                "Holiday",
                style: GoogleFonts.poppins(
                  color: ColorUtils.textWhite.withOpacity(0.5),
                  fontWeight: FontWeight.w400,
                  fontSize: 10.sp,
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.circle,
              color: ColorUtils.offDayCircle,
              size: 8.43,
            ),
            Padding(
              padding: EdgeInsets.only(left: 2.w, right: 4.w),
              child: Text(
                "Offday",
                style: GoogleFonts.poppins(
                  color: ColorUtils.textWhite.withOpacity(0.5),
                  fontWeight: FontWeight.w400,
                  fontSize: 10.sp,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
