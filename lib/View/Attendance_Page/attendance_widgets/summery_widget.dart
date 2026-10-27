import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/Attendance_Page/attendance_widgets/strip_graph.dart';
import 'package:loyaltri_minimal/controller/attSummaryController.dart';
import 'package:loyaltri_minimal/models/attendance_summary_model.dart';
import '../../../services/ui_model_services/attandance_summary_model.dart';
import '../../../utils/color_utils.dart';

class SummeryWidget extends StatefulWidget {
  const SummeryWidget({super.key});

  @override
  State<SummeryWidget> createState() => _SummeryWidgetState();
}

class _SummeryWidgetState extends State<SummeryWidget> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10).w,
      child: GetX<AttendanceSummaryController>(
        builder: (AttendanceSummaryController controller) {
          AttSummary result = controller.attendanceSummary.value.result ?? AttSummary();
          double workingDayCount = result.workingDays ?? 0;
          double incompleteDayCount = (result.fine?.finedCount ?? 0) + (result.fine?.pardonedFineCount ?? 0);
          double overtimeDayCount = result.overTime?.approvedOverTimeCount ?? 0;
          double absentDayCount = result.absent ?? 0;
          double offDayCount = result.offDays ?? 0;
          double total = 1;
          total = workingDayCount + incompleteDayCount + overtimeDayCount + absentDayCount + offDayCount;
          int workdays = 1;
          int incomplete = 1;
          int overtime = 1;
          int absent = 1;
          int offday = 1;

          if (total != 0) {
            workdays = (333 * workingDayCount) ~/ total;
            incomplete = (333 * incompleteDayCount) ~/ total;
            overtime = (333 * overtimeDayCount) ~/ total;
            absent = (333 * absentDayCount) ~/ total;
            offday = (333 * offDayCount) ~/ total;
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    "Summary",
                    style: GoogleFonts.poppins(
                      color: ColorUtils.textWhite,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 8.0).w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    StripGraphManager(
                      width: workdays,
                      height: 40,
                      radius: BorderRadius.only(
                        topLeft: const Radius.circular(8),
                        bottomLeft: const Radius.circular(8),
                        topRight: incomplete == 0 && overtime == 0 && absent == 0 && offday == 0 ? const Radius.circular(8) : const Radius.circular(0),
                        bottomRight: incomplete == 0 && overtime == 0 && absent == 0 && offday == 0 ? const Radius.circular(8) : const Radius.circular(0),
                      ).w,
                      colors: const [
                        Color(0xFF229B63),
                        Color(0xFF2E875D),
                      ],
                    ),
                    StripGraphManager(
                      width: incomplete,
                      height: 40,
                      radius: BorderRadius.only(
                        topLeft: workdays == 0 ? const Radius.circular(8) : const Radius.circular(0),
                        bottomLeft: workdays == 0 ? const Radius.circular(8) : const Radius.circular(0),
                        topRight: overtime == 0 && absent == 0 && offday == 0 ? const Radius.circular(8) : const Radius.circular(0),
                        bottomRight: overtime == 0 && absent == 0 && offday == 0 ? const Radius.circular(8) : const Radius.circular(0),
                      ).w,
                      colors: const [
                        Color(0xFFED8E1F),
                        Color(0xFFFBA759),
                      ],
                    ),
                    StripGraphManager(
                      width: overtime,
                      height: 40,
                      radius: BorderRadius.only(
                        topLeft: incomplete == 0 && workdays == 0 ? const Radius.circular(8) : const Radius.circular(0),
                        bottomLeft: incomplete == 0 && workdays == 0 ? const Radius.circular(8) : const Radius.circular(0),
                        topRight: absent == 0 && offday == 0 ? const Radius.circular(8) : const Radius.circular(0),
                        bottomRight: absent == 0 && offday == 0 ? const Radius.circular(8) : const Radius.circular(0),
                      ).w,
                      colors: const [
                        Color(0xFF8B0FAE),
                        Color(0xFFB736DC),
                      ],
                    ),
                    StripGraphManager(
                      width: absent,
                      height: 40,
                      radius: BorderRadius.only(
                        topLeft: overtime == 0 && workdays == 0 && incomplete == 0 ? const Radius.circular(8) : const Radius.circular(0),
                        bottomLeft: overtime == 0 && workdays == 0 && incomplete == 0 ? const Radius.circular(8) : const Radius.circular(0),
                        topRight: offday == 0 ? const Radius.circular(8) : const Radius.circular(0),
                        bottomRight: offday == 0 ? const Radius.circular(8) : const Radius.circular(0),
                      ).w,
                      colors: const [
                        Color(0xFFAF2B21),
                        Color(0xFFC83C31),
                      ],
                    ),
                    StripGraphManager(
                      width: offday,
                      height: 40,
                      radius: BorderRadius.only(
                        topLeft: workdays == 0 && incomplete == 0 && overtime == 0 && absent == 0 ? const Radius.circular(8) : const Radius.circular(0),
                        bottomLeft: workdays == 0 && incomplete == 0 && overtime == 0 && absent == 0 ? const Radius.circular(8) : const Radius.circular(0),
                        topRight: const Radius.circular(8),
                        bottomRight: const Radius.circular(8),
                      ).w,
                      colors: const [
                        Color(0xFFE0E0E4),
                        Color(0xFFC6C6C6),
                      ],
                    ),
                  ],
                ),
              ),
              ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0).w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: const Color(0xFF259662),
                              radius: 5.w,
                            ),
                            SizedBox(width: 5.w),
                            Text(
                              "Working days",
                              style: GoogleFonts.poppins(
                                color: ColorUtils.textWhite,
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                        Text(
                            formatNumber(workingDayCount),
                          style: GoogleFonts.poppins(
                            color: ColorUtils.textWhite,
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1.w,
                    color: ColorUtils.textWhite.withOpacity(0.1),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0).w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: const Color(0xFFF49B3D),
                              radius: 5.w,
                            ),
                            SizedBox(width: 5.w),
                            Text(
                              "Incomplete Duty",
                              style: GoogleFonts.poppins(
                                color: ColorUtils.textWhite,
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                        Text(
                            formatNumber(incompleteDayCount),
                          style: GoogleFonts.poppins(
                            color: ColorUtils.textWhite,
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1.w,
                    color: ColorUtils.textWhite.withOpacity(0.1),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0).w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: const Color(0xFFB736DC),
                              radius: 5.w,
                            ),
                            SizedBox(width: 5.w),
                            Text(
                              "Overtime",
                              style: GoogleFonts.poppins(
                                color: ColorUtils.textWhite,
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                        Text(
                            formatNumber(overtimeDayCount),
                          style: GoogleFonts.poppins(
                            color: ColorUtils.textWhite,
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1.w,
                    color: ColorUtils.textWhite.withOpacity(0.1),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0).w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: const Color(0xFFD0453B),
                              radius: 5.w,
                            ),
                            SizedBox(width: 5.w),
                            Text(
                              "Absent",
                              style: GoogleFonts.poppins(
                                color: ColorUtils.textWhite,
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                        Text(
                            formatNumber(absentDayCount),
                          style: GoogleFonts.poppins(
                            color: ColorUtils.textWhite,
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1.w,
                    color: ColorUtils.textWhite.withOpacity(0.1),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 15.0).w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: const Color(0xFFCCCCCD),
                              radius: 5.w,
                            ),
                            SizedBox(width: 5.w),
                            Text(
                              "Days Off",
                              style: GoogleFonts.poppins(
                                color: ColorUtils.textWhite,
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                        Text(
                            formatNumber(offDayCount),
                          style: GoogleFonts.poppins(
                            color: ColorUtils.textWhite,
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  String formatNumber(double input) {
    // Check if the number is an integer.
    if (input % 1 == 0) {
      return input.toInt().toString(); // Return as an integer string
    }
    // Otherwise, return the original number as a string.
    return input.toString();
  }
}

