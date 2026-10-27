import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../services/ui_model_services/leave_tab_model.dart';
import '../../../utils/color_utils.dart';

class LeaveTabButton extends StatelessWidget {
  final int tabId;
  final int tabValue;
  final Function(int) onButtonClick;
  const LeaveTabButton(
      {super.key,
      required this.tabId,
      required this.onButtonClick,
      required this.tabValue});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onButtonClick(leaveTabItem[tabId].id);
      },
      child: Container(
        height: 31.w,
        // width: 88.w,
        padding: const EdgeInsets.symmetric(horizontal: 8).w,
        decoration: BoxDecoration(
          color: tabValue == tabId
              ? ColorUtils.foregroundBlack
              : ColorUtils.backgroundBlack,
          borderRadius: BorderRadius.circular(22).w,
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50).w,
                  color: leaveTabItem[tabId].color,
                ),
              ),
              SizedBox(width: 5.w),
              Text(
                leaveTabItem[tabId].title,
                style: GoogleFonts.poppins(
                  color: tabValue == tabId
                      ? ColorUtils.textWhite
                      : ColorUtils.textWhite.withOpacity(0.5),
                  fontWeight: FontWeight.w500,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
