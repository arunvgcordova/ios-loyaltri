
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/models/upcoming_shift_api_model.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';

class ScheduledItemRowWidget extends StatelessWidget {
  final ShiftDetails shiftDetails;
  final int intNum;
  const ScheduledItemRowWidget({super.key, required this.shiftDetails, required this.intNum});

  @override
  Widget build(BuildContext context) {
    bool isNight = shiftDetails.shift?.toLowerCase().contains("night") ?? false;
    int randomNumber = shiftDetails.shift == "Off Day" ? 3 : intNum % 3;
    return Container(
      width: 205.w,
      height: 142.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15).w,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ColorUtils.shiftColors1[randomNumber],
              ColorUtils.shiftColors2[randomNumber],
            ],
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 6.w),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6).w,
            child: Container(
              // width: 192.w,
              height: 66.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10).w,
                gradient: LinearGradient(
                  colors: [
                    ColorUtils.shiftColors3[randomNumber],
                    ColorUtils.shiftColors4[randomNumber],
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0).w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Shift Name",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                            color: ColorUtils.textWhite,
                          ),
                        ),
                        SizedBox(
                          width: 280.w,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              shiftDetails.shift ?? '--',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                                color: ColorUtils.textWhite,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SvgPicture.asset(
                      isNight ? "assets/images/moon_icon.svg" : "assets/images/sun_icon.svg",
                      width: 20.w,
                      fit: BoxFit.fitWidth,
                      colorFilter: ColorFilter.mode(
                          ColorUtils.textWhite.withOpacity(0.5),
                          BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8).w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      shiftDetails.shift == "Off Day" ? "Day Off" : shiftDetails.shiftTime ?? '--',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                        color: ColorUtils.textWhite,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                SizedBox(height: 10.w),
                if((shiftDetails.startTime?.trim().isNotEmpty ?? false) || (shiftDetails.endTime?.trim().isNotEmpty ?? false))
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            "assets/images/timer_icon.svg",
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            // DateFormat('HH:mm a').format(DateTime.now()),
                            shiftDetails.startTime ?? '--',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                              color: ColorUtils.textWhite,
                              letterSpacing: -0.3.w,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 2.w,
                        height: 25.w,
                        color: ColorUtils.shiftColors5[randomNumber],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            "assets/images/timer_icon.svg",
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            // DateFormat('HH:mm a').format(DateTime.now()),
                            shiftDetails.endTime ?? '--',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                              color: ColorUtils.textWhite,
                              letterSpacing: -0.3.w,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
