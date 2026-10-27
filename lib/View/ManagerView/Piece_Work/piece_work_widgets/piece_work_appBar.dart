
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/ManagerView/Piece_Work/piece_work_controller/piece_work_controller.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';

class PieceWorkAppBar extends StatelessWidget {
  const PieceWorkAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              width: 48.h,
              height: 48.h,
              decoration: BoxDecoration(
                color: ColorUtils.textWhite,
                borderRadius: BorderRadius.circular(14).r,
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: ColorUtils.workEntryHead,
                  size: 20.h,
                ),
              ),
            ),
          ),
          Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/images/manager_view/piece_work_icon.png",
                height: 24.h,
              ),
              SizedBox(width: 5.h),
              Text(
                "Piece Work",
                style: GoogleFonts.poppins(
                  color: ColorUtils.workEntryHead,
                  fontWeight: FontWeight.w500,
                  fontSize: 15.h,
                ),
              ),
            ],
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.all(8).h,
            decoration: BoxDecoration(
              color: ColorUtils.textWhite,
              borderRadius: BorderRadius.circular(14).r,
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  "assets/images/manager_view/punch_approval_month.svg",
                  height: 15.h,
                ),
                SizedBox(width: 3.h),
                GetX<PieceWorkController>(
                    builder: (PieceWorkController controller) {
                      return Text(
                        DateFormat('MMM, yyyy').format(controller.dateList.value[controller.currentDateIndex.value]),
                        style: GoogleFonts.poppins(
                          fontSize: 11.h,
                          fontWeight: FontWeight.w500,
                          color: ColorUtils.workEntryHead,
                        ),
                      );
                    }
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
