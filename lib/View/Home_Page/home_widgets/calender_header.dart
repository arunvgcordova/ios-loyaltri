import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../utils/color_utils.dart';
import 'calender_hints.dart';

class CalenderHeader extends StatelessWidget {
  final DateTime focusedDate;
  final Function(DateTime) loadMonthData;
  final bool isDark;
  const CalenderHeader({
    super.key,
    required this.focusedDate,
    required this.loadMonthData,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 12.h, bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Month navigation: [ < ] Sep 2024 [ > ]
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  DateTime prevMonth = DateTime(
                    focusedDate.year,
                    focusedDate.month - 1,
                    1,
                  );
                  loadMonthData(prevMonth);
                },
                child: Container(
                  height: 30.h,
                  width: 30.h,
                  decoration: BoxDecoration(
                    color: isDark
                        ? ColorUtils.foregroundBlack
                        : ColorUtils.workEntryHead.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: 13.h,
                      color: isDark
                          ? ColorUtils.textWhite
                          : ColorUtils.workEntryHead,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 14.w),
              Text(
                DateFormat('MMM yyyy').format(focusedDate),
                style: GoogleFonts.poppins(
                  fontSize: 13.h,
                  fontWeight: FontWeight.w500,
                  color: ColorUtils.textWhite,
                ),
              ),
              SizedBox(width: 14.w),
              GestureDetector(
                onTap: () {
                  DateTime nextMonth = DateTime(
                    focusedDate.year,
                    focusedDate.month + 1,
                    1,
                  );
                  loadMonthData(nextMonth);
                },
                child: Container(
                  height: 30.h,
                  width: 30.h,
                  decoration: BoxDecoration(
                    color: isDark
                        ? ColorUtils.foregroundBlack
                        : ColorUtils.workEntryHead.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 13.h,
                      color: isDark
                          ? ColorUtils.textWhite
                          : ColorUtils.workEntryHead,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Legend and Info
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                barrierColor: ColorUtils.workEntryHead.withValues(
                  alpha: 0.9,
                ),
                isScrollControlled: true,
                builder: (context) {
                  return CalenderHints();
                },
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // P
                Container(
                  width: 8.h,
                  height: 8.h,
                  decoration: const BoxDecoration(
                    color: ColorUtils.calenderDatesCircle,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  "P",
                  style: GoogleFonts.poppins(
                    color: ColorUtils.textWhite.withValues(alpha: 0.5),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(width: 12.w),
                // UL
                Container(
                  width: 8.h,
                  height: 8.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: ColorUtils.leaveCircle,
                      width: 1.5.h,
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  "UL",
                  style: GoogleFonts.poppins(
                    color: ColorUtils.textWhite.withValues(alpha: 0.5),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(width: 12.w),
                // OFF
                Container(
                  width: 8.h,
                  height: 8.h,
                  decoration: const BoxDecoration(
                    color: ColorUtils.gunMetalGrey,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  "OFF",
                  style: GoogleFonts.poppins(
                    color: ColorUtils.textWhite.withValues(alpha: 0.5),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(width: 12.w),
                // Info
                SvgPicture.asset(
                  'assets/images/Info.svg',
                  height: 17.h,
                  fit: BoxFit.fitHeight,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
