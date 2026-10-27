import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/color_utils.dart';

class FilterButton extends StatelessWidget {
  final Color color;
  final String count;
  final String title;
  final bool isSelected;
  const FilterButton({
    super.key,
    required this.color,
    required this.count,
    required this.title,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(5).r,
        border: isSelected ? Border.all(width: 1.h, color: color) : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(backgroundColor: color, radius: 5.h),
              SizedBox(width: 5.h),
              Text(
                title,
                style: GoogleFonts.poppins(
                  color: ColorUtils.workEntryHead,
                  fontWeight: FontWeight.w400,
                  fontSize: 13.h,
                ),
              ),
            ],
          ),
          Text(
            count,
            style: GoogleFonts.poppins(
              color: ColorUtils.workEntryHead,
              fontWeight: FontWeight.w500,
              fontSize: 13.h,
            ),
          ),
        ],
      ),
    );
  }
}

class FilterButtonExpanded extends StatelessWidget {
  final Color color;
  final String count;
  final String title;
  final bool isSelected;
  const FilterButtonExpanded({
    super.key,
    required this.color,
    required this.count,
    required this.title,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 6, right: 6).h,
      decoration: BoxDecoration(
        color: isSelected ? color.withValues(alpha: 0.1) : null,
        borderRadius: BorderRadius.circular(6).r,
        border: isSelected ? Border.all(width: 1.h, color: color) : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(backgroundColor: color, radius: 5.h),
              SizedBox(width: 5.h),
              Text(
                title,
                style: GoogleFonts.poppins(
                  color: ColorUtils.workEntryHead,
                  fontWeight: FontWeight.w400,
                  fontSize: 13.h,
                ),
              ),
            ],
          ),
          Text(
            count,
            style: GoogleFonts.poppins(
              color: ColorUtils.workEntryHead,
              fontWeight: FontWeight.w500,
              fontSize: 13.h,
            ),
          ),
        ],
      ),
    );
  }
}

class SummaryDivider extends StatelessWidget {
  const SummaryDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: ColorUtils.workEntryHead.withValues(alpha: 0.1),
      thickness: 1.h,
      height: 6.h,
    );
  }
}
