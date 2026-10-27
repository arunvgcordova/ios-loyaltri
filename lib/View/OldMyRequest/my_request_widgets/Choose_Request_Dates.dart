
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../services/ui_model_services/leave_dates_model.dart';
import '../../../utils/color_utils.dart';
import '../../CWidgets/app_bar.dart';
import '../../CWidgets/loyaltri_blue_text_button.dart';
import '../../Leave_Page/leave_widgets/leave_calender.dart';

class ChooseRequestDates extends StatefulWidget {
  const ChooseRequestDates({super.key});

  @override
  State<ChooseRequestDates> createState() => _ChooseRequestDatesState();
}

class _ChooseRequestDatesState extends State<ChooseRequestDates> {
  ValueNotifier<DateTime?> leaveStart = ValueNotifier(null);
  ValueNotifier<DateTime?> leaveEnd = ValueNotifier(null);
  ValueNotifier<DateTime> currentDate = ValueNotifier(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorUtils.workEntryHead,
        extendBody: true,
        body: Padding(
          padding: const EdgeInsets.only(top: 8).w,
          child: Container(
            width: ScreenUtil().screenWidth,
            height: ScreenUtil().screenHeight,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 80).w,
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  const CustomAppBar(
                    title: "Choose Date",
                    isActionVisible: true,
                    image: "assets/images/leave-calendar3d.webp",
                  ),
                  Container(
                    height: ScreenUtil().screenHeight,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 300).w,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10).w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "From",
                                      style: GoogleFonts.poppins(
                                        color: ColorUtils.textWhite.withOpacity(0.5),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                    ValueListenableBuilder(
                                      valueListenable: leaveStart,
                                      builder: (BuildContext context, value, Widget? child) {
                                        if (value != null) {
                                          return Row(
                                            children: [
                                              Text(
                                                DateFormat('dd').format(value),
                                                style: GoogleFonts.poppins(
                                                  color: ColorUtils.textWhite,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16.sp,
                                                ),
                                              ),
                                              Text(
                                                " ${DateFormat('MMM | E').format(value)}",
                                                style: GoogleFonts.poppins(
                                                  color: ColorUtils.textWhite,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16.sp,
                                                ),
                                              ),
                                            ],
                                          );
                                        } else {
                                          return Text(
                                            "____",
                                            style: GoogleFonts.poppins(
                                              color: ColorUtils.textWhite,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16.sp,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "-",
                                      style: GoogleFonts.poppins(
                                        color: ColorUtils.textWhite.withOpacity(0.5),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "To",
                                      style: GoogleFonts.poppins(
                                        color: ColorUtils.textWhite.withOpacity(0.5),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                    ValueListenableBuilder(
                                      valueListenable: leaveEnd,
                                      builder: (BuildContext context, value, Widget? child) {
                                        if (value != null) {
                                          return Row(
                                            children: [
                                              Text(
                                                DateFormat('dd').format(value),
                                                style: GoogleFonts.poppins(
                                                  color: ColorUtils.textWhite,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16.sp,
                                                ),
                                              ),
                                              Text(
                                                " ${DateFormat('MMM | E').format(value)}",
                                                style: GoogleFonts.poppins(
                                                  color: ColorUtils.textWhite,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16.sp,
                                                ),
                                              ),
                                            ],
                                          );
                                        } else {
                                          return ValueListenableBuilder(
                                            valueListenable: leaveStart,
                                            builder: (BuildContext context, value, Widget? child) {
                                              if (value != null) {
                                                return Row(
                                                  children: [
                                                    Text(
                                                      DateFormat('dd').format(value),
                                                      style: GoogleFonts.poppins(
                                                        color: ColorUtils.textWhite,
                                                        fontWeight: FontWeight.w700,
                                                        fontSize: 16.sp,
                                                      ),
                                                    ),
                                                    Text(
                                                      " ${DateFormat('MMM | E').format(value)}",
                                                      style: GoogleFonts.poppins(
                                                        color: ColorUtils.textWhite,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 16.sp,
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              } else {
                                                return Text(
                                                  "____",
                                                  style: GoogleFonts.poppins(
                                                    color: ColorUtils.textWhite,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16.sp,
                                                  ),
                                                );
                                              }
                                            },
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0).w,
                            child: LeaveCalender(
                              isRangeSelection: true,
                              leaveDates: (LeaveDates leaveDays) {
                                leaveStart.value = leaveDays.startDate;
                                leaveEnd.value = leaveDays.endDate;
                              },
                              onMonthChange: (DateTime date) {
                                currentDate.value = date;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          width: ScreenUtil().screenWidth,
          height: 70.w,
          decoration: blueTextButtonDecoration,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20).w,
                child: GestureDetector(
                  onTap: () {
                    if (leaveStart.value != null && leaveEnd.value != null) {
                      Navigator.pop(context, LeaveDates(startDate: leaveStart.value, endDate: leaveEnd.value));
                    } else if (leaveStart.value != null && leaveEnd.value == null) {
                      Navigator.pop(context, LeaveDates(startDate: leaveStart.value, endDate: leaveStart.value));
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: const LoyaltriBlueIconTextButton(
                    text: 'Save Date Range',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
