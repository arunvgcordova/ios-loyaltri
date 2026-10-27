import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/Leave_Page/leave_widgets/leave_balance_hidden.dart';

import '../../../utils/color_utils.dart';

class LeaveRow extends StatelessWidget {
  final List<Color> colors;
  final String title;
  final num count;
  final bool hideBalance;
  const LeaveRow(
      {super.key,
      required this.colors,
      required this.title,
      required this.count,
      required this.hideBalance,
      });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 3, bottom: 3).w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50).w,
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: colors,
                      )),
                ),
              ),
              SizedBox(
                width: 120.w,
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: ColorUtils.textWhite.withOpacity(0.8),
                    fontWeight: FontWeight.w300,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 2.w),
          if(hideBalance)
            InkWell(
              borderRadius: BorderRadius.circular(4).w,
              onTap: () {
                showLeaveBalanceHiddenBottomSheet(context);
              },
              child: Container(
                width: 20.w,
                height: 20.w,
                padding: const EdgeInsets.symmetric(vertical: 5).w,
                decoration: BoxDecoration(
                    color: const Color(0xFF34373D),
                    borderRadius: BorderRadius.circular(4).w),
                child: Center(
                  child: FittedBox(
                    child: Transform.scale(
                      scale: 1.5,
                      child: SvgPicture.asset(
                        'assets/images/Info.svg',
                      ),
                    ),
                  ),
                ),
              ),
            )
          else
            Container(
              width: 20.w,
              height: 20.w,
              padding: const EdgeInsets.symmetric(vertical: 5).w,
              decoration: BoxDecoration(
                  color: const Color(0xFF34373D),
                  borderRadius: BorderRadius.circular(4).w),
              child: Center(
                child: FittedBox(
                  child: Text(
                    "$count",
                    style: GoogleFonts.inter(
                      color: ColorUtils.textWhite,
                      fontWeight: FontWeight.w500,
                      fontSize: 10.sp,
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
