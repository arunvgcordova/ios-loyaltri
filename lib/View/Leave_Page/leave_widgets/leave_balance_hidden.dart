import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/CWidgets/loyaltri_blue_text_button.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';

class LeaveBalanceHidden extends StatelessWidget {
  const LeaveBalanceHidden({super.key});

  /// Helper method to display this bottom sheet from anywhere
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const LeaveBalanceHidden(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF12141D),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24.r),
        ),
      ),
      padding: EdgeInsets.only(
        left: 20.h,
        right: 20.h,
        top: 12.h,
        bottom: 24.h + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 42.h,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFF4A4854),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 18.h),

          // Title & Close Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Leave balance hidden',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 16.h,
                  fontWeight: FontWeight.w600,
                ),
              ),
              InkWell(
                onTap: () => Navigator.of(context).pop(),
                borderRadius: BorderRadius.circular(20.r),
                child: Padding(
                  padding: EdgeInsets.all(4.h),
                  child: Icon(
                    Icons.close_rounded,
                    color: Colors.white.withValues(alpha: 0.7),
                    size: 22.h,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),

          // Description
          Text(
            'Your organisation has hidden the balance for this leave type. Contact your HR team if you need the details.',
            style: GoogleFonts.inter(
              color: Colors.white.withValues(alpha: 0.65),
              fontSize: 13.5.h,
              fontWeight: FontWeight.w400,
              height: 1.45,
            ),
          ),
          SizedBox(height: 28.h),

          // "Got it" button
          InkWell(
            borderRadius: BorderRadius.circular(37).r,
            onTap: () => Navigator.of(context).pop(),
            child: LoyaltriBlueTextButton(text: 'Got it'),
          ),
        ],
      ),
    );
  }
}

/// Standalone top-level helper function
Future<void> showLeaveBalanceHiddenBottomSheet(BuildContext context) {
  return LeaveBalanceHidden.show(context);
}
