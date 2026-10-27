
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/color_utils.dart';
import 'calender_date_selector.dart';

class PieceWorkCalendarSheet extends StatelessWidget {
  const PieceWorkCalendarSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 10.h,
          horizontal: 15.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 48.h,
                  width: 48.h,
                ),
                Text(
                  "Choose Date",
                  style: GoogleFonts.inter(
                    fontSize: 16.h,
                    fontWeight: FontWeight.w500,
                    color: ColorUtils.workEntryHead,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height: 49.h,
                    width: 49.h,
                    decoration: BoxDecoration(
                      color: ColorUtils.charcoalBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14.5).r,
                    ),
                    child: Center(
                      child: Container(
                        height: 48.h,
                        width: 48.h,
                        decoration: BoxDecoration(
                          color: ColorUtils.textWhite,
                          borderRadius: BorderRadius.circular(14).r,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.close,
                            size: 20.h,
                            color: ColorUtils.workEntryHead,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Container(
              padding: EdgeInsets.all(1.h),
              decoration: BoxDecoration(
                color: ColorUtils.workEntryHead.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(18).r,
              ),
              child: PieceWorkCalender(
                selectedDate: (p0) {
                  Navigator.of(context).pop(p0);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
