
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../models/regularisation_request_model.dart';
import '../../../services/ui_model_services/leave_tab_model.dart';
import '../../../utils/color_utils.dart';

class ExcuseWidget extends StatelessWidget {
  final RequestData requestData;
  const ExcuseWidget({super.key, required this.requestData});

  @override
  Widget build(BuildContext context) {
    String excuseType = requestData.excuseType ?? '--';
    String excuseDate = requestData.attendanceDate ?? '--';
    try {
      excuseDate = DateFormat('d MMM yyyy | EEE').format(DateTime.parse(requestData.attendanceDate!));
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
                      color: colorStatus(requestData.status ?? '--'),
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    statusTitle(requestData.status ?? '--'),
                    style: GoogleFonts.poppins(
                      color: colorStatus(requestData.status ?? '--'),
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if(excuseType == "Late Entry")
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10).w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4).w,
                          color: requestData.color,
                          // gradient: const LinearGradient(
                          //   colors: [
                          //     ColorUtils.lf1,
                          //     ColorUtils.lf2,
                          //   ],
                          // )
                      ),
                      child: Text(
                        "LE",
                        style: GoogleFonts.inter(
                          color: ColorUtils.textWhite,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  // const SizedBox(width: 8),
                  // Container(
                  //   padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10).w,
                  //   decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(4).w,
                  //       gradient: const LinearGradient(
                  //         colors: [
                  //           ColorUtils.ot1,
                  //           ColorUtils.ot2,
                  //         ],
                  //       )
                  //   ),
                  //   child: Text(
                  //     "OT",
                  //     style: LoyaltriFonts.interW600_12sp_textWhite,
                  //   ),
                  // ),
                  // const SizedBox(width: 8),
                  if(excuseType == "Excess Break")
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10).w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4).w,
                        color: requestData.color,
                          // gradient: const LinearGradient(
                          //   colors: [
                          //     ColorUtils.eb1,
                          //     ColorUtils.eb2,
                          //   ],
                          // )
                      ),
                      child: Text(
                        "EB",
                        style: GoogleFonts.inter(
                          color: ColorUtils.textWhite,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  // const SizedBox(width: 8),
                  if(excuseType == "Early Exit")
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10).w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4).w,
                        color: requestData.color,
                          // gradient: const LinearGradient(
                          //   colors: [
                          //     ColorUtils.ee1,
                          //     ColorUtils.ee2,
                          //   ],
                          // )
                      ),
                      child: Text(
                        "EE",
                        style: GoogleFonts.inter(
                          color: ColorUtils.textWhite,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          SizedBox(height: 3.w),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "$excuseType :",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                      color: ColorUtils.textWhite,
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    // "55 min",
                    requestData.timeDifference ?? "--",
                    style: GoogleFonts.poppins(
                      color: ColorUtils.textWhite,
                      fontWeight: FontWeight.w700,
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
                    excuseDate,
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
                      requestData.excuseReason.toString() != "null" ? requestData.excuseReason ?? '--' : "--",
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

  Color colorStatus(String type) {
    switch(type.toLowerCase()) {
      case "pending": return const Color(0xFFF8A24E);
      case "pardon": return const Color(0xFF50BC61);
      case "fine": return const Color(0xFFD40000);
      default: return ColorUtils.textWhite;
    }
  }

  String statusTitle(String type) {
    switch(type.toLowerCase()) {
      case "pending": return "Pending";
      case "pardon": return "Pardon";
      case "fine": return "Fine";
      default: return "--";
    }
  }

  // String regularisationType(String type) {
  //   switch(type) {
  //     case "Late Entry": return "LE";
  //     case "Excess Break": return "EB";
  //     case "Early Exit": return "EE";
  //     case "Miss Punch": return "MP";
  //     default: return "";
  //   }
  // }
}
