import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/calendar_api_model.dart';
import '../../../utils/color_utils.dart';

class PresentDayBuilder extends StatelessWidget {
  final DateTime date;
  final Leaves data;

  const PresentDayBuilder({
    super.key,
    required this.date,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final bool isHalfDay = data.isHalfDay == true;
    final bool isIrregular = data.isIrregular == true;
    final bool isOvertime = data.isOvertime == true;

    final double circleSize = 29.w;
    final double indicatorAreaSize = isOvertime ? 44.w : circleSize;

    return Center(
      child: SizedBox(
        width: indicatorAreaSize,
        height: indicatorAreaSize,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            // Main date circle
            Positioned(
              top: isOvertime ? 1.5.h : 0,
              child: _DateCircle(
                date: date,
                isHalfDay: isHalfDay,
              ),
            ),

            // Irregular attendance indicator
            if (isIrregular)
              Positioned(
                top: isOvertime ? 3.h : 1.5.h,
                right: isOvertime ? 8.w : 1.5.w,
                child: Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorUtils.incompleteDayColor,
                    border: Border.all(
                      color: ColorUtils.workEntryHead.withValues(alpha: 0.7),
                      width: 1.w,
                    ),
                  ),
                ),
              ),

            // Overtime indicator
            if (isOvertime)
              Positioned(
                bottom: 0,
                child: Image.asset(
                  'assets/images/overtime-icon.png',
                  width: 12.w,
                  height: 12.w,
                  fit: BoxFit.contain,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DateCircle extends StatelessWidget {
  final DateTime date;
  final bool isHalfDay;

  const _DateCircle({
    required this.date,
    required this.isHalfDay,
  });

  @override
  Widget build(BuildContext context) {
    final double size = 29.w;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipOval(
            child: isHalfDay
                ? Row(
              children: [
                Expanded(
                  child: Container(
                    color: ColorUtils.calenderDatesCircle,
                  ),
                ),
                Expanded(
                  child: Container(
                    color: ColorUtils.gunMetalGrey,
                  ),
                ),
              ],
            )
                : Container(
              color: ColorUtils.calenderDatesCircle,
            ),
          ),
          Text(
            '${date.day}',
            style: GoogleFonts.poppins(
              color: ColorUtils.textWhite,
              fontWeight: FontWeight.w400,
              fontSize: 12.sp,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}