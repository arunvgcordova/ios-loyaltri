import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/color_utils.dart';

class CalenderHints extends StatelessWidget {
  const CalenderHints({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: ColorUtils.deepMidnightPurple,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
          border: Border(top: BorderSide(color: ColorUtils.eerieBlack)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 50.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: ColorUtils.charcoalGrey,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
            SizedBox(height: 15.h),
            Text(
              "Attendance Status Guide",
              style: GoogleFonts.poppins(
                color: ColorUtils.textWhite,
                fontSize: 15.h,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 6.h),
            _buildGuideRow(
              indicator: Container(
                width: 18.h,
                height: 18.h,
                decoration: const BoxDecoration(
                  color: ColorUtils.calenderDatesCircle,
                  shape: BoxShape.circle,
                ),
              ),
              label: "Present",
            ),
            _buildDivider(),
            _buildGuideRow(
              indicator: Container(
                width: 18.h,
                height: 18.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ColorUtils.paidLeaveColor,
                    width: 2.h,
                  ),
                ),
              ),
              label: "Paid Leave",
            ),
            _buildDivider(),
            _buildGuideRow(
              indicator: Container(
                width: 18.h,
                height: 18.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: ColorUtils.leaveCircle, width: 2.h),
                ),
              ),
              label: "Unpaid Leave / Absent",
            ),
            _buildDivider(),
            _buildGuideRow(
              indicator: Container(
                width: 18.h,
                height: 18.h,
                decoration: const BoxDecoration(
                  color: ColorUtils.gunMetalGrey,
                  shape: BoxShape.circle,
                ),
              ),
              label: "Off Day",
            ),
            _buildDivider(),
            _buildGuideRow(
              indicator: Container(
                width: 18.h,
                height: 18.h,
                decoration: const BoxDecoration(
                  color: ColorUtils.deepForestGreen,
                  shape: BoxShape.circle,
                ),
              ),
              label: "Holiday",
            ),
            _buildDivider(),
            _buildGuideRow(
              indicator: Container(
                width: 9.h,
                height: 9.h,
                decoration: const BoxDecoration(
                  color: ColorUtils.incompleteDayColor,
                  shape: BoxShape.circle,
                ),
              ),
              label: "Irregular Attendance",
            ),
            _buildDivider(),
            _buildGuideRow(
              indicator: Container(
                height: 15.h,
                width: 15.h,
                child: Center(
                  child: Image.asset(
                    'assets/images/overtime-icon.png',
                  ),
                ),
              ),
              label: "Overtime",
            ),
            _buildDivider(),
            _buildGuideRow(
              indicator: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 18.h,
                    height: 18.h,
                    decoration: BoxDecoration(
                      color: ColorUtils.calenderDatesCircle,
                      borderRadius: BorderRadiusGeometry.circular(500.r),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(500.r),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8.h,
                          height: 16.h,
                          decoration: const BoxDecoration(
                            color: ColorUtils.calenderDatesCircle,
                          ),
                        ),
                        Container(
                          width: 8.h,
                          height: 16.h,
                          decoration: const BoxDecoration(
                            color: ColorUtils.gunMetalGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              label: "Half Day",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideRow({required Widget indicator, required String label}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          SizedBox(
            width: 30.w,
            child: Center(child: indicator),
          ),
          SizedBox(width: 12.w),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: ColorUtils.textWhite,
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: ColorUtils.textWhite.withValues(alpha: 0.05),
      height: 1,
      thickness: 1,
    );
  }
}
