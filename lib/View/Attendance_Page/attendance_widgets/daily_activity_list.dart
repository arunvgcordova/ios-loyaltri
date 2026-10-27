import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';
import '../../../models/attendance_details_api_model.dart';

class DailyActivityWidget extends StatefulWidget {
  final Attendance activity;
  const DailyActivityWidget({super.key, required this.activity});

  @override
  State<DailyActivityWidget> createState() => _DailyActivityWidgetState();
}

class _DailyActivityWidgetState extends State<DailyActivityWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0).w,
      child: Container(
        width: ScreenUtil().screenWidth,
        height: 76.h,
        decoration: BoxDecoration(
            color: ColorUtils.backgroundBlack,
            borderRadius: BorderRadius.circular(14).w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3).w,
                      child: CircleAvatar(
                        backgroundColor: getColor(widget.activity.status.toString().replaceAll(" ", "").toUpperCase()),
                        radius: 7.w,
                      ),
                    ),
                    if(widget.activity.status != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 8, bottom: 3).w,
                        child: Text(
                          widget.activity.status.toString(),
                          style: GoogleFonts.poppins(
                            color: getColor(widget.activity.status.toString().replaceAll(" ", "").toUpperCase()),
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    if(widget.activity.status == null)
                      Padding(
                        padding: const EdgeInsets.only(left: 8, bottom: 3).w,
                        child: Text(
                          getStatus(),
                          style: GoogleFonts.poppins(
                            color: getColor(getStatus().replaceAll(" ", "").toUpperCase()),
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                  ],
                ),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 8.w,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8).w,
                      child: Text(
                        formatDate(widget.activity.date!),
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF959CBD),
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(flex: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 3).w,
                  child: Text(
                    "Check In",
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF959CBD),
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
                Text(
                  widget.activity.firstCheckInTime ?? "__",
                  style: GoogleFonts.poppins(
                    color: ColorUtils.textWhite.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 3).w,
                  child: Text(
                    "Check Out",
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF959CBD),
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
                Text(
                  widget.activity.lastCheckOutTime ?? "__",
                  style: GoogleFonts.poppins(
                    color: ColorUtils.textWhite.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }

  Color getColor(String type) {
    switch(type) {
      case "PRESENT": return ColorUtils.workingDayColor;
      case "INCOMPLETE": return ColorUtils.incompleteDayColor;
      case "ABSENT": return ColorUtils.absentColor;
      case "OFFDAY": return ColorUtils.offDayColor;
      default: return Colors.yellow;
    }
  }

  String getStatus() {
    if(widget.activity.isRegularizationNeeded == 1) {
      return "Incomplete";
    } else if(widget.activity.isHoliday == "1") {
      return "Holiday";
    } else if(widget.activity.isOffDay == 1) {
      return "Off Day";
    } else {
      return "";
    }
  }

  String formatDate(String dateString) {
    // Parse the input string into a DateTime object
    List<String> dateParts = dateString.split('-');

    int year = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int day = int.parse(dateParts[2]);

    DateTime date = DateTime(year, month, day);

    // Get the day of the month, month abbreviation, and day abbreviation
    String dayOfMonth = date.day.toString();
    String monthAbbrev = _getMonthAbbreviation(date.month);
    String dayAbbrev = _getDayAbbreviation(date.weekday);

    // Format the date as "dayOfMonth monthAbbrev | dayAbbrev"
    return '$dayOfMonth $monthAbbrev | $dayAbbrev';
  }

  String _getMonthAbbreviation(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
  }

  String _getDayAbbreviation(int day) {
    switch (day) {
      case DateTime.monday:
        return 'Mon';
      case DateTime.tuesday:
        return 'Tue';
      case DateTime.wednesday:
        return 'Wed';
      case DateTime.thursday:
        return 'Thu';
      case DateTime.friday:
        return 'Fri';
      case DateTime.saturday:
        return 'Sat';
      case DateTime.sunday:
        return 'Sun';
      default:
        return '';
    }
  }
}
