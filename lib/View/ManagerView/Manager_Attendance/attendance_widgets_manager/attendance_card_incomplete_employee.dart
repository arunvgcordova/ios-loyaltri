
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/color_utils.dart';
import '../../../CWidgets/cwidgets.dart';

class AttendanceCardIncompleteEmployee extends StatelessWidget {
  const AttendanceCardIncompleteEmployee({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6).h,
      decoration: BoxDecoration(
        color: ColorUtils.textWhite,
        borderRadius: BorderRadius.circular(14).r,
        border: Border.all(
          color: ColorUtils.workEntryHead.withValues(alpha: 0.1),
          width: 1.h,
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/examples/user_request.png", height: 32.h),
              SizedBox(width: 8.h),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Brendon Stokes",
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 11.h,
                        fontWeight: FontWeight.w500,
                        color: ColorUtils.workEntryHead.withValues(alpha: 0.9),
                      ),
                    ),
                    Text(
                      "Chief Operations Officer",
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 11.h,
                        fontWeight: FontWeight.w400,
                        color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 5.h,
                  horizontal: 18.h,
                ),
                decoration: BoxDecoration(
                  color: ColorUtils.softPearl,
                  borderRadius: BorderRadius.circular(14).r,
                ),
                child: Text(
                  "Shift Name",
                  style: GoogleFonts.inter(
                    fontSize: 11.h,
                    fontWeight: FontWeight.w400,
                    color: ColorUtils.workEntryHead.withValues(alpha: 0.54),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 10.h,
              bottom: 13.h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 9.h,
                      height: 9.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: statusColor('incomplete'),
                      ),
                    ),
                    SizedBox(width: 3.h),
                    Text(
                      "incomplete",
                      style: GoogleFonts.poppins(
                        fontSize: 13.h,
                        fontWeight: FontWeight.w500,
                        color: statusColor('incomplete'),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 32.h,
                  height: 25.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3).r,
                    gradient: LinearGradient(
                      colors: [ColorUtils.ee2, ColorUtils.ee1],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "EE",
                      style: GoogleFonts.inter(
                        fontSize: 13.h,
                        fontWeight: FontWeight.w600,
                        color: ColorUtils.textWhite,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 3.h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "29 Sep | Fri",
                  style: GoogleFonts.poppins(
                    fontSize: 11.h,
                    fontWeight: FontWeight.w400,
                    color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Total Hours: ",
                      style: GoogleFonts.poppins(
                        fontSize: 11.h,
                        fontWeight: FontWeight.w400,
                        color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                      ),
                    ),
                    Text(
                      "7:45 hrs",
                      style: GoogleFonts.poppins(
                        fontSize: 11.h,
                        fontWeight: FontWeight.w600,
                        color: ColorUtils.workEntryHead.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 3.h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Check in",
                          style: GoogleFonts.poppins(
                            fontSize: 11.h,
                            fontWeight: FontWeight.w400,
                            color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                          ),
                        ),
                        Text(
                          "08:30 AM",
                          style: GoogleFonts.poppins(
                            fontSize: 11.h,
                            fontWeight: FontWeight.w500,
                            color: ColorUtils.workEntryHead.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 25.h),
                    Container(width: 30.h, height: 1.h, color: Color(0xFF3D3D3D).withValues(alpha: 0.5)),
                    SizedBox(width: 25.h),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Check out",
                          style: GoogleFonts.poppins(
                            fontSize: 11.h,
                            fontWeight: FontWeight.w400,
                            color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                          ),
                        ),
                        Text(
                          "--:-- PM",
                          style: GoogleFonts.poppins(
                            fontSize: 11.h,
                            fontWeight: FontWeight.w500,
                            color: ColorUtils.workEntryHead.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(width: 1.h, height: 13.h, color: Color(0xFF3D3D3D).withValues(alpha: 0.5)),
                Icon(Icons.arrow_forward_ios_outlined, color: ColorUtils.workEntryHead, size: 16.h)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
