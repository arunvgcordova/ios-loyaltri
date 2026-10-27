
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../services/ui_model_services/leave_tab_model.dart';
import '../../../utils/color_utils.dart';

class MyRequestTabButton extends StatelessWidget {
  final int tabId;
  final int tabValue;
  final Function(int) onButtonClick;
  const MyRequestTabButton(
      {super.key,
        required this.tabId,
        required this.onButtonClick,
        required this.tabValue});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onButtonClick(myRequestTabItem[tabId].id);
      },
      child: Container(
        height: 31.h,
        width: 87.w,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 8).h,
        decoration: BoxDecoration(
          color: tabValue == tabId
              ? ColorUtils.foregroundBlack
              : ColorUtils.backgroundBlack,
          borderRadius: BorderRadius.circular(22).r,
        ),
        child: Text(
          myRequestTabItem[tabId].title,
          style: GoogleFonts.poppins(
            color: tabValue == tabId
                ? ColorUtils.textWhite
                : ColorUtils.textWhite.withValues(alpha: 0.5),
            fontWeight: FontWeight.w500,
            fontSize: 11.h,
          ),
        ),
      ),
    );
  }
}
