import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/color_utils.dart';

class LeaveTypeCard extends StatelessWidget {
  final String imageIcon;
  final String title;
  final String? subTitle;
  final String? leaveBalance;
  const LeaveTypeCard(
      {super.key,
      required this.imageIcon,
      required this.title,
        this.leaveBalance,
        this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().screenWidth,
      decoration: BoxDecoration(
        color: (leaveBalance != null && leaveBalance == "0") ? const Color(0xFF3E3C42) : const Color(0xFF27252C),
        borderRadius: BorderRadius.circular(12).w,
      ),
      child: Padding(
        padding: const EdgeInsets.only(
                left: 8.0, right: 8.0, top: 10.0, bottom: 10.0)
            .w,
        child: Row(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0).w,
                  child: Image.asset(
                    imageIcon,
                    width: 34.w,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        color: ColorUtils.textWhite,
                      ),
                    ),
                    if(subTitle != null)
                      SizedBox(
                        width: ScreenUtil().screenWidth * 0.6,
                        child: Text(
                          subTitle!,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                            color: ColorUtils.textWhite.withOpacity(0.5),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: ColorUtils.textWhite.withOpacity(0.4),
              size: 16.w,
            ),
          ],
        ),
      ),
    );
  }
}

class AttachMenuCard extends StatelessWidget {
  final String imageIcon;
  final String title;
  final String subTitle;
  final Color? containerColor;
  final Color? textColor;
  const AttachMenuCard(
      {super.key,
      required this.imageIcon,
      required this.title,
        this.containerColor,
        this.textColor,
      required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().screenWidth,
      decoration: BoxDecoration(
        color: containerColor ?? const Color(0xFF27252C),
        borderRadius: BorderRadius.circular(12).w,
      ),
      child: Padding(
        padding: const EdgeInsets.only(
                left: 8.0, right: 8.0, top: 10.0, bottom: 10.0)
            .w,
        child: SizedBox(
          height: 42.w,
          child: Row(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0).w,
                    child: Image.asset(
                      imageIcon,
                      width: 34.w,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                          color: textColor ?? ColorUtils.textWhite,
                        ),
                      ),
                      // SizedBox(
                      //   width: ScreenUtil().screenWidth * 0.6,
                      //   child: FittedBox(
                      //     child: Text(
                      //       subTitle,
                      //       overflow: TextOverflow.ellipsis,
                      //       style: GoogleFonts.poppins(
                      //         fontWeight: FontWeight.w400,
                      //         fontSize: 12.sp,
                      //         color: ColorUtils.textWhite.withOpacity(0.5),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                color: textColor ?? ColorUtils.textWhite.withValues(alpha: 0.4),
                size: 16.w,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
