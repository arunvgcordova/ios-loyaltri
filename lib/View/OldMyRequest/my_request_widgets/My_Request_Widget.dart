
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../utils/color_utils.dart';
import '../model/myRequestListApiModel.dart';

class MyRequestWidget extends StatelessWidget {
  final RequestData requestData;
  const MyRequestWidget({super.key, required this.requestData});

  @override
  Widget build(BuildContext context) {
    int colorCode = 000000;
    String title = '--';
    String date = '--';
    try {
      title = requestData.requestType == "1" ? "Work From Home" : "Letter Request";
      String colorString = requestData.requestStatusColour?.split('#').last ?? '';
      colorCode = int.parse('0xFF$colorString');
      date = DateFormat('d MMM yyyy | EEE').format(DateTime.parse(requestData.fromDate!));
    } catch(e) {}
    return Container(
      height: 116.w,
      padding: const EdgeInsets.all(10).w,
      width: ScreenUtil().screenWidth,
      decoration: BoxDecoration(
          color: ColorUtils.backgroundBlack,
          borderRadius: BorderRadius.circular(14).w
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(height: 3.w),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50).w,
                      color: Color(colorCode),
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    requestData.requestStatusName ?? '--',
                    style: GoogleFonts.poppins(
                      color: Color(colorCode),
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Date : ",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                      color: ColorUtils.textWhite.withOpacity(0.5),
                    ),
                  ),
                  Text(
                    date,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                      color: ColorUtils.textWhite.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 3.w),
          Row(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: 12.sp,
                  color: ColorUtils.textWhite,
                ),
              ),
              // Text(
              //   "Letter Request :",
              //   style: LoyaltriFonts.poppinsW400_12sp_textWhite,
              // ),
              // SizedBox(width: 5.w),
              // Text(
              //   "Relieving Letter",
              //   style: LoyaltriFonts.poppinsW700_12sp_textWhite,
              // ),
            ],
          ),
          SizedBox(height: 3.w),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Reason",
                    style: GoogleFonts.inter(
                      color: ColorUtils.textWhite.withOpacity(0.5),
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(
                    width: ScreenUtil().screenWidth * 0.7,
                    child: Text(
                      requestData.requestDescription ?? '--',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: ColorUtils.textWhite.withOpacity(0.3),
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                        letterSpacing: -0.35,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 3).w,
                child: Text(
                  String.fromCharCode(Icons.arrow_forward_ios.codePoint),
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: ColorUtils.textWhite,
                    fontFamily: Icons.arrow_forward_ios.fontFamily,
                    package: Icons.arrow_forward_ios.fontPackage,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.w),
        ],
      ),
    );
  }
}
