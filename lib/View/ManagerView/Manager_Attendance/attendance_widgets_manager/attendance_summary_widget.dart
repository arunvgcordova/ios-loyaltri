

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/filter_button.dart';

import '../../../../utils/color_utils.dart';
import '../../../Attendance_Page/attendance_widgets/strip_graph.dart';
import '../manager_attendance_controller/manager_attendance_controller.dart';

class AttendanceSummaryWidget extends StatelessWidget {
  const AttendanceSummaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorUtils.textWhite,
        borderRadius: BorderRadius.circular(14).r,
        border: Border.all(
          color: ColorUtils.workEntryHead.withValues(alpha: 0.1),
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent, splashColor: Colors.transparent),
        child: GetX<ManagerAttendanceController>(
            builder: (ManagerAttendanceController controller) {
              int workingDayCount = controller.summaryData.value?.present ?? 0;
              int halfDayCount = controller.summaryData.value?.halfDay ?? 0;
              int overtimeDayCount = controller.summaryData.value?.overTime?.overTimeCount ?? 0;
              int absentDayCount = controller.summaryData.value?.absent ?? 0;
              int offDayCount = controller.summaryData.value?.offDays ?? 0;
              int fineDayCount = controller.summaryData.value?.fine?.finedCount??0;
              int paidLeaveDayCount  =controller.summaryData.value?.paidLeave??0;
              num total = 1;
              // total =
              //     workingDayCount +
              //         halfDayCount +
              //         overtimeDayCount +
              //         absentDayCount +
              //         offDayCount;
              total =
                  workingDayCount +
                      halfDayCount +
                      absentDayCount +
                      offDayCount+overtimeDayCount+fineDayCount+paidLeaveDayCount;
              int workdays = 1;
              int halfDay = 1;
              int overtime = 1;
              int absent = 1;
              int offday = 1;
              int fineday = 1;
              int paidLeave = 1;
              

              if (total != 0) {
                workdays = (320 * workingDayCount) ~/ total;
                halfDay = (320 * halfDayCount) ~/ total;
                overtime = (320 * overtimeDayCount) ~/ total;
                absent = (320 * absentDayCount) ~/ total;
                offday = (320 * offDayCount) ~/ total;
                fineday =(320 * fineDayCount) ~/ total;
                paidLeave= (320 * paidLeaveDayCount) ~/ total;
              }
              bool isZero = false;
              // if(workdays == 0 && halfDay == 0 && overtime == 0 && absent == 0 && offday == 0) {
              //   isZero = true;
              // }
              if(total == 0) {
                isZero = true;
              }
              int stripHeight = controller.summaryExpansionChanged.value ? 40 : 8;
              if(isZero) {
                return SizedBox.shrink();
              } else {
                return ExpansionTile(
                  collapsedIconColor: ColorUtils.workEntryHead,
                  iconColor: ColorUtils.workEntryHead,
                  tilePadding: const EdgeInsets.symmetric(horizontal: 12).h,
                  childrenPadding: const EdgeInsets.only(left: 6, right: 6, top: 5, bottom: 6).h,
                  showTrailingIcon: false,
                  onExpansionChanged: (value) {
                    controller.summaryExpansionChanged.value = value;
                  },
                  title: controller.summaryExpansionChanged.value
                      ? Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: 4.h,
                          right: 8.h,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Summary",
                              style: GoogleFonts.poppins(
                                color: ColorUtils.workEntryHead,
                                fontSize: 13.h,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            AnimatedRotation(
                              turns: controller.summaryExpansionChanged.value ? 0.5 : 0.0,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              child: SvgPicture.asset(
                                "assets/images/manager_view/arrow_up.svg",
                                height: 7.h,
                                colorFilter: ColorFilter.mode(ColorUtils.workEntryHead, BlendMode.srcIn),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if(isZero)
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, bottom: 8.0).h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              StripGraph(
                                width: workdays,
                                height: stripHeight,
                                radius: BorderRadius.only(
                                  topLeft: const Radius.circular(8),
                                  bottomLeft: const Radius.circular(8),
                                  // topRight: halfDay == 0 && overtime == 0 && absent == 0 && offday == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                  // bottomRight: halfDay == 0 && overtime == 0 && absent == 0 && offday == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                  topRight: halfDay == 0 && absent == 0 && offday == 0 && overtime ==0 && fineday ==0 && paidLeave == 0? const Radius.circular(8) : const Radius.circular(0),
                                  bottomRight: halfDay == 0 && absent == 0 && offday == 0 && overtime ==0 && fineday ==0 && paidLeave == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                ).r,
                                colors: const [
                                  Color(0xFF229B63),
                                  Color(0xFF2E875D),
                                ],
                              ),
                              StripGraph(
                                width: absent,
                                height: stripHeight,
                                radius: BorderRadius.only(
                                  // topLeft: overtime == 0 && workdays == 0 && halfDay == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                  // bottomLeft: overtime == 0 && workdays == 0 && halfDay == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                  topLeft: workdays == 0 && halfDay == 0 &&overtime ==0 ? const Radius.circular(8) : const Radius.circular(0),
                                  bottomLeft: workdays == 0 && halfDay == 0 &&overtime ==0 ? const Radius.circular(8) : const Radius.circular(0),
                                  topRight: offday == 0 && fineday ==0 && paidLeave == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                  bottomRight: offday == 0 && fineday ==0 && paidLeave == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                ).r,
                                colors: const [
                                  Color(0xFFAF2B21),
                                  Color(0xFFC83C31),
                                ],
                              ),
                              StripGraph(
                                width: halfDay,
                                height: stripHeight,
                                radius: BorderRadius.only(
                                  topLeft: workdays == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                  bottomLeft: workdays == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                  // topRight: overtime == 0 && absent == 0 && offday == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                  // bottomRight: overtime == 0 && absent == 0 && offday == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                  topRight: absent == 0 && offday == 0 && overtime == 0 && fineday ==0 && paidLeave == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                  bottomRight: absent == 0 && offday == 0 && overtime == 0&& fineday ==0 && paidLeave == 0? const Radius.circular(8) : const Radius.circular(0),
                                ).r,
                                colors: const [
                                  Color(0xFFED8E1F),
                                  Color(0xFFFBA759),
                                ],
                              ),
                              StripGraph(
                                width: offday,
                                height: stripHeight,
                                radius: BorderRadius.only(
                                  // topLeft: workdays == 0 && halfDay == 0 && overtime == 0 && absent == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                  // bottomLeft: workdays == 0 && halfDay == 0 && overtime == 0 && absent == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                  topLeft: workdays == 0 && halfDay == 0 && absent == 0 && overtime ==0 && fineday ==0 && paidLeave == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                  bottomLeft: workdays == 0 && halfDay == 0 && absent == 0 && overtime ==0 && fineday ==0 && paidLeave == 0? const Radius.circular(8) : const Radius.circular(0),
                                  topRight: const Radius.circular(8),
                                  bottomRight: const Radius.circular(8),
                                ).r,
                                colors: const [
                                  Color(0xFFE0E0E4),
                                  Color(0xFFC6C6C6),
                                ],
                              ),
                              StripGraph(
                                width: fineday,
                                height: stripHeight,
                                radius: BorderRadius.only(
                                  topLeft: workdays == 0 && halfDay == 0 &&overtime ==0  && absent == 0? const Radius.circular(8) : const Radius.circular(0),
                                  bottomLeft: workdays == 0 && halfDay == 0 &&overtime ==0  && absent == 0? const Radius.circular(8) : const Radius.circular(0),
                                  // topRight: overtime == 0 && absent == 0 && offday == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                  // bottomRight: overtime == 0 && absent == 0 && offday == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                  topRight: paidLeave == 0 && offday == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                  bottomRight: paidLeave == 0 && offday == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                ).r,
                                colors: const [
                                  Color(0xFFFFCACA),
                                  Color(0xFFFFCACA),
                                ],
                              ),
                              StripGraph(
                                width: overtime,
                                height: stripHeight,
                                radius: BorderRadius.only(
                                  topLeft: halfDay == 0 && workdays == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                  bottomLeft: halfDay == 0 && workdays == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                  topRight: absent == 0 && offday == 0 && fineday ==0 && paidLeave == 0? const Radius.circular(8) : const Radius.circular(0),
                                  bottomRight: absent == 0 && offday == 0 && fineday ==0 && paidLeave == 0? const Radius.circular(8) : const Radius.circular(0),
                                ).r,
                                colors: const [
                                  Color(0xFF8B0FAE),
                                  Color(0xFFB736DC),
                                ],
                              ),
                              StripGraph(
                                width: paidLeave,
                                height: stripHeight,
                                radius: BorderRadius.only(
                                  topLeft:workdays == 0 && halfDay == 0 &&overtime ==0  && absent == 0 && fineday ==0? const Radius.circular(8) : const Radius.circular(0),
                                  bottomLeft: workdays == 0 && halfDay == 0 &&overtime ==0  && absent == 0 && fineday ==0? const Radius.circular(8) : const Radius.circular(0),
                                  // topRight: overtime == 0 && absent == 0 && offday == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                  // bottomRight: overtime == 0 && absent == 0 && offday == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                  topRight:  offday == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                  bottomRight:  offday == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                ).r,
                                colors: const [
                                  Color(0xFFED8E1F),
                                  Color(0xFFFBA759),
                                ],
                              ),
                            ],
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0).h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: workdays,
                                child: StripGraph(
                                  width: workdays,
                                  height: stripHeight,
                                  radius: BorderRadius.only(
                                    topLeft: const Radius.circular(8),
                                    bottomLeft: const Radius.circular(8),
                                    topRight: absent == 0 && halfDay == 0 && offday == 0 && fineday == 0 && overtime == 0 && paidLeave == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                    bottomRight: absent == 0 && halfDay == 0 && offday == 0 && fineday == 0 && overtime == 0 && paidLeave == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                  ).r,
                                  colors: const [
                                    Color(0xFF229B63),
                                    Color(0xFF2E875D),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: absent,
                                child: StripGraph(
                                  width: absent,
                                  height: stripHeight,
                                  radius: BorderRadius.only(
                                    topLeft: workdays == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                    bottomLeft: workdays == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                    topRight: halfDay == 0 && offday == 0 && fineday == 0 && overtime == 0 && paidLeave == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                    bottomRight: halfDay == 0 && offday == 0 && fineday == 0 && overtime == 0 && paidLeave == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                  ).r,
                                  colors: const [
                                    Color(0xFFAF2B21),
                                    Color(0xFFC83C31),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: halfDay,
                                child: StripGraph(
                                  width: halfDay,
                                  height: stripHeight,
                                  radius: BorderRadius.only(
                                    topLeft: workdays == 0 && absent == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                    bottomLeft: workdays == 0 && absent == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                    topRight: offday == 0 && fineday == 0 && overtime == 0 && paidLeave == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                    bottomRight: offday == 0 && fineday == 0 && overtime == 0 && paidLeave == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                  ).r,
                                  colors: const [
                                    Color(0xFFED8E1F),
                                    Color(0xFFFBA759),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: offday,
                                child: StripGraph(
                                  width: offday,
                                  height: stripHeight,
                                  radius: BorderRadius.only(
                                    topLeft: workdays == 0 && absent == 0 && halfDay == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                    bottomLeft: workdays == 0 && absent == 0 && halfDay == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                    topRight: fineday == 0 && overtime == 0 && paidLeave == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                    bottomRight: fineday == 0 && overtime == 0 && paidLeave == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                  ).r,
                                  colors: const [
                                    Color(0xFFE0E0E4),
                                    Color(0xFFC6C6C6),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: fineday,
                                child: StripGraph(
                                  width: fineday,
                                  height: stripHeight,
                                  radius: BorderRadius.only(
                                    topLeft: workdays == 0 && absent == 0 && halfDay == 0 && offday == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                    bottomLeft:  workdays == 0 && absent == 0 && halfDay == 0 && offday == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                    topRight: overtime == 0 && paidLeave == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                    bottomRight: overtime == 0 && paidLeave == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                  ).r,
                                  colors: const [
                                    Color(0xFFFFCACA),
                                    Color(0xFFFFCACA),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: overtime,
                                child: StripGraph(
                                  width: overtime,
                                  height: stripHeight,
                                  radius: BorderRadius.only(
                                    topLeft: workdays == 0 && absent == 0 && halfDay == 0 && offday == 0 && fineday == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                    bottomLeft: workdays == 0 && absent == 0 && halfDay == 0 && offday == 0 && fineday == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                    topRight: paidLeave == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                    bottomRight: paidLeave == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                  ).r,
                                  colors: const [
                                    Color(0xFF8B0FAE),
                                    Color(0xFFB736DC),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: paidLeave,
                                child: StripGraph(
                                  width: paidLeave,
                                  height: stripHeight,
                                  radius: BorderRadius.only(
                                    topLeft: workdays == 0 && absent == 0 && halfDay == 0 && offday == 0 && fineday == 0 && overtime == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                    bottomLeft: workdays == 0 && absent == 0 && halfDay == 0 && offday == 0 && fineday == 0 && overtime == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                    topRight: const Radius.circular(8),
                                    bottomRight: const Radius.circular(8),
                                  ).r,
                                  colors: const [
                                    Color(0xFFED8E1F),
                                    Color(0xFFFBA759),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  )
                      : Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: 4.h,
                          right: 8.h,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Summary",
                              style: GoogleFonts.poppins(
                                color: ColorUtils.workEntryHead,
                                fontSize: 13.h,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            AnimatedRotation(
                              turns: controller.summaryExpansionChanged.value ? 0.5 : 0.0,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              child: SvgPicture.asset(
                                "assets/images/manager_view/arrow_up.svg",
                                height: 7.h,
                                colorFilter: ColorFilter.mode(ColorUtils.workEntryHead, BlendMode.srcIn),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if(isZero)
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, bottom: 8.0).h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              StripGraph(
                                width: workdays,
                                height: stripHeight,
                                radius: BorderRadius.only(
                                  topLeft: const Radius.circular(8),
                                  bottomLeft: const Radius.circular(8),
                                  // topRight: halfDay == 0 && overtime == 0 && absent == 0 && offday == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                  // bottomRight: halfDay == 0 && overtime == 0 && absent == 0 && offday == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                  topRight: halfDay == 0 && absent == 0 && offday == 0 && overtime ==0 && fineday ==0 && paidLeave == 0? const Radius.circular(8) : const Radius.circular(0),
                                  bottomRight: halfDay == 0 && absent == 0 && offday == 0 && overtime ==0 && fineday ==0 && paidLeave == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                ).r,
                                colors: const [
                                  Color(0xFF229B63),
                                  Color(0xFF2E875D),
                                ],
                              ),
                              StripGraph(
                                width: absent,
                                height: stripHeight,
                                radius: BorderRadius.only(
                                  // topLeft: overtime == 0 && workdays == 0 && halfDay == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                  // bottomLeft: overtime == 0 && workdays == 0 && halfDay == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                  topLeft: workdays == 0 && halfDay == 0 &&overtime ==0 ? const Radius.circular(8) : const Radius.circular(0),
                                  bottomLeft: workdays == 0 && halfDay == 0 &&overtime ==0 ? const Radius.circular(8) : const Radius.circular(0),
                                  topRight: offday == 0 && fineday ==0 && paidLeave == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                  bottomRight: offday == 0 && fineday ==0 && paidLeave == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                ).r,
                                colors: const [
                                  Color(0xFFAF2B21),
                                  Color(0xFFC83C31),
                                ],
                              ),
                              StripGraph(
                                width: halfDay,
                                height: stripHeight,
                                radius: BorderRadius.only(
                                  topLeft: workdays == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                  bottomLeft: workdays == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                  // topRight: overtime == 0 && absent == 0 && offday == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                  // bottomRight: overtime == 0 && absent == 0 && offday == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                  topRight: absent == 0 && offday == 0 && overtime == 0 && fineday ==0 && paidLeave == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                  bottomRight: absent == 0 && offday == 0 && overtime == 0&& fineday ==0 && paidLeave == 0? const Radius.circular(8) : const Radius.circular(0),
                                ).r,
                                colors: const [
                                  Color(0xFFED8E1F),
                                  Color(0xFFFBA759),
                                ],
                              ),
                              StripGraph(
                                width: offday,
                                height: stripHeight,
                                radius: BorderRadius.only(
                                  // topLeft: workdays == 0 && halfDay == 0 && overtime == 0 && absent == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                  // bottomLeft: workdays == 0 && halfDay == 0 && overtime == 0 && absent == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                  topLeft: workdays == 0 && halfDay == 0 && absent == 0 && overtime ==0 && fineday ==0 && paidLeave == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                  bottomLeft: workdays == 0 && halfDay == 0 && absent == 0 && overtime ==0 && fineday ==0 && paidLeave == 0? const Radius.circular(8) : const Radius.circular(0),
                                  topRight: const Radius.circular(8),
                                  bottomRight: const Radius.circular(8),
                                ).r,
                                colors: const [
                                  Color(0xFFE0E0E4),
                                  Color(0xFFC6C6C6),
                                ],
                              ),
                              StripGraph(
                                width: fineday,
                                height: stripHeight,
                                radius: BorderRadius.only(
                                  topLeft: workdays == 0 && halfDay == 0 &&overtime ==0  && absent == 0? const Radius.circular(8) : const Radius.circular(0),
                                  bottomLeft: workdays == 0 && halfDay == 0 &&overtime ==0  && absent == 0? const Radius.circular(8) : const Radius.circular(0),
                                  // topRight: overtime == 0 && absent == 0 && offday == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                  // bottomRight: overtime == 0 && absent == 0 && offday == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                  topRight: paidLeave == 0 && offday == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                  bottomRight: paidLeave == 0 && offday == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                ).r,
                                colors: const [
                                  Color(0xFFFFCACA),
                                  Color(0xFFFFCACA),
                                ],
                              ),
                              StripGraph(
                                width: overtime,
                                height: stripHeight,
                                radius: BorderRadius.only(
                                  topLeft: halfDay == 0 && workdays == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                  bottomLeft: halfDay == 0 && workdays == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                  topRight: absent == 0 && offday == 0 && fineday ==0 && paidLeave == 0? const Radius.circular(8) : const Radius.circular(0),
                                  bottomRight: absent == 0 && offday == 0 && fineday ==0 && paidLeave == 0? const Radius.circular(8) : const Radius.circular(0),
                                ).r,
                                colors: const [
                                  Color(0xFF8B0FAE),
                                  Color(0xFFB736DC),
                                ],
                              ),
                              StripGraph(
                                width: paidLeave,
                                height: stripHeight,
                                radius: BorderRadius.only(
                                  topLeft:workdays == 0 && halfDay == 0 &&overtime ==0  && absent == 0 && fineday ==0? const Radius.circular(8) : const Radius.circular(0),
                                  bottomLeft: workdays == 0 && halfDay == 0 &&overtime ==0  && absent == 0 && fineday ==0? const Radius.circular(8) : const Radius.circular(0),
                                  // topRight: overtime == 0 && absent == 0 && offday == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                  // bottomRight: overtime == 0 && absent == 0 && offday == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                  topRight:  offday == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                  bottomRight:  offday == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                ).r,
                                colors: const [
                                  Color(0xFFED8E1F),
                                  Color(0xFFFBA759),
                                ],
                              ),
                            ],
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, bottom: 8.0).h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: workdays,
                                child: StripGraph(
                                  width: workdays,
                                  height: stripHeight,
                                  radius: BorderRadius.only(
                                    topLeft: const Radius.circular(8),
                                    bottomLeft: const Radius.circular(8),
                                    topRight: absent == 0 && halfDay == 0 && offday == 0 && fineday == 0 && overtime == 0 && paidLeave == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                    bottomRight: absent == 0 && halfDay == 0 && offday == 0 && fineday == 0 && overtime == 0 && paidLeave == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                  ).r,
                                  colors: const [
                                    Color(0xFF229B63),
                                    Color(0xFF2E875D),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: absent,
                                child: StripGraph(
                                  width: absent,
                                  height: stripHeight,
                                  radius: BorderRadius.only(
                                    topLeft: workdays == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                    bottomLeft: workdays == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                    topRight: halfDay == 0 && offday == 0 && fineday == 0 && overtime == 0 && paidLeave == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                    bottomRight: halfDay == 0 && offday == 0 && fineday == 0 && overtime == 0 && paidLeave == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                  ).r,
                                  colors: const [
                                    Color(0xFFAF2B21),
                                    Color(0xFFC83C31),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: halfDay,
                                child: StripGraph(
                                  width: halfDay,
                                  height: stripHeight,
                                  radius: BorderRadius.only(
                                    topLeft: workdays == 0 && absent == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                    bottomLeft: workdays == 0 && absent == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                    topRight: offday == 0 && fineday == 0 && overtime == 0 && paidLeave == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                    bottomRight: offday == 0 && fineday == 0 && overtime == 0 && paidLeave == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                  ).r,
                                  colors: const [
                                    Color(0xFFED8E1F),
                                    Color(0xFFFBA759),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: offday,
                                child: StripGraph(
                                  width: offday,
                                  height: stripHeight,
                                  radius: BorderRadius.only(
                                    topLeft: workdays == 0 && absent == 0 && halfDay == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                    bottomLeft: workdays == 0 && absent == 0 && halfDay == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                    topRight: fineday == 0 && overtime == 0 && paidLeave == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                    bottomRight: fineday == 0 && overtime == 0 && paidLeave == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                  ).r,
                                  colors: const [
                                    Color(0xFFE0E0E4),
                                    Color(0xFFC6C6C6),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: fineday,
                                child: StripGraph(
                                  width: fineday,
                                  height: stripHeight,
                                  radius: BorderRadius.only(
                                    topLeft: workdays == 0 && absent == 0 && halfDay == 0 && offday == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                    bottomLeft:  workdays == 0 && absent == 0 && halfDay == 0 && offday == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                    topRight: overtime == 0 && paidLeave == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                    bottomRight: overtime == 0 && paidLeave == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                  ).r,
                                  colors: const [
                                    Color(0xFFFFCACA),
                                    Color(0xFFFFCACA),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: overtime,
                                child: StripGraph(
                                  width: overtime,
                                  height: stripHeight,
                                  radius: BorderRadius.only(
                                    topLeft: workdays == 0 && absent == 0 && halfDay == 0 && offday == 0 && fineday == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                    bottomLeft: workdays == 0 && absent == 0 && halfDay == 0 && offday == 0 && fineday == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                    topRight: paidLeave == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                    bottomRight: paidLeave == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                  ).r,
                                  colors: const [
                                    Color(0xFF8B0FAE),
                                    Color(0xFFB736DC),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: paidLeave,
                                child: StripGraph(
                                  width: paidLeave,
                                  height: stripHeight,
                                  radius: BorderRadius.only(
                                    topLeft: workdays == 0 && absent == 0 && halfDay == 0 && offday == 0 && fineday == 0 && overtime == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                    bottomLeft: workdays == 0 && absent == 0 && halfDay == 0 && offday == 0 && fineday == 0 && overtime == 0 ? const Radius.circular(8) : const Radius.circular(0),
                                    topRight: const Radius.circular(8),
                                    bottomRight: const Radius.circular(8),
                                  ).r,
                                  colors: const [
                                    Color(0xFFED8E1F),
                                    Color(0xFFFBA759),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(height: 1.h),
                      SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(5).r,
                              onTap: () {
                                controller.filterManagerAttDetails(type: AttendanceFilterTypes.present);
                              },
                              child: FilterButton(
                                color: Color(0xFF259662),
                                count: formatNumber(workingDayCount),
                                title: "Present ",
                                isSelected: controller.selectedFilters.contains(AttendanceFilterTypes.present),
                              ),
                            ),
                            SizedBox(width: 9.h),
                            InkWell(
                              borderRadius: BorderRadius.circular(5).r,
                              onTap: () {
                                controller.filterManagerAttDetails(type: AttendanceFilterTypes.absent);
                              },
                              child: FilterButton(
                                color: Color(0xFFD0453B),
                                count: formatNumber(absentDayCount),
                                title: "Absent ",
                                isSelected: controller.selectedFilters.contains(AttendanceFilterTypes.absent),
                              ),
                            ),
                            SizedBox(width: 9.h),
                            InkWell(
                              borderRadius: BorderRadius.circular(5).r,
                              onTap: () {
                                controller.filterManagerAttDetails(type: AttendanceFilterTypes.halfDay);
                              },
                              child: FilterButton(
                                color: ColorUtils.incompleteDayColor,
                                count: formatNumber(halfDayCount),
                                title: "Half Day ",
                                isSelected: controller.selectedFilters.contains(AttendanceFilterTypes.halfDay),
                              ),
                            ),
                            SizedBox(width: 9.h),
                            InkWell(
                              borderRadius: BorderRadius.circular(5).r,
                              onTap: () {
                                controller.filterManagerAttDetails(type: AttendanceFilterTypes.offDay);
                              },
                              child: FilterButton(
                                color: Color(0xFFCCCCCD),
                                count: formatNumber(offDayCount),
                                title: "Off Day ",
                                isSelected: controller.selectedFilters.contains(AttendanceFilterTypes.offDay),
                              ),
                            ),
                            SizedBox(width: 9.h),
                            InkWell(
                              borderRadius: BorderRadius.circular(5).r,
                              onTap: () {
                                controller.filterManagerAttDetails(type: AttendanceFilterTypes.fine);
                              },
                              child: FilterButton(
                                color: Color(0xFFFFCACA),
                                count: formatNumber(fineDayCount),
                                title: "Fine ",
                                isSelected: controller.selectedFilters.contains(AttendanceFilterTypes.fine),
                              ),
                            ),
                            SizedBox(width: 9.h),
                            InkWell(
                              borderRadius: BorderRadius.circular(5).r,
                              onTap: () {
                                controller.filterManagerAttDetails(type: AttendanceFilterTypes.overtime);
                              },
                              child: FilterButton(
                                color: ColorUtils.ot2,
                                count: formatNumber(overtimeDayCount),
                                title: "Overtime ",
                                isSelected: controller.selectedFilters.contains(AttendanceFilterTypes.overtime),
                              ),
                            ),
                            SizedBox(width: 9.h),
                            InkWell(
                              borderRadius: BorderRadius.circular(5).r,
                              onTap: () {
                                controller.filterManagerAttDetails(type: AttendanceFilterTypes.paidLeave);
                              },
                              child: FilterButton(
                                color: Color(0xFFED8E1F),
                                count: formatNumber(paidLeaveDayCount),
                                title: "Paid Leave ",
                                isSelected: controller.selectedFilters.contains(AttendanceFilterTypes.paidLeave),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 3.h),
                    ],
                  ),
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(6).r,
                      onTap: () {
                        controller.filterManagerAttDetails(type: AttendanceFilterTypes.present);
                      },
                      child: FilterButtonExpanded(
                        color: Color(0xFF259662),
                        count: formatNumber(workingDayCount),
                        title: "Present",
                        isSelected: controller.selectedFilters.contains(AttendanceFilterTypes.present),
                      ),
                    ),
                    SummaryDivider(),
                    InkWell(
                      borderRadius: BorderRadius.circular(6).r,
                      onTap: () {
                        controller.filterManagerAttDetails(type: AttendanceFilterTypes.absent);
                      },
                      child: FilterButtonExpanded(
                        color: Color(0xFFD0453B),
                        count: formatNumber(absentDayCount),
                        title: "Absent",
                        isSelected: controller.selectedFilters.contains(AttendanceFilterTypes.absent),
                      ),
                    ),
                    SummaryDivider(),
                    InkWell(
                      borderRadius: BorderRadius.circular(6).r,
                      onTap: () {
                        controller.filterManagerAttDetails(type: AttendanceFilterTypes.halfDay);
                      },
                      child: FilterButtonExpanded(
                        color: ColorUtils.incompleteDayColor,
                        count: formatNumber(halfDayCount),
                        title: "Half Day",
                        isSelected: controller.selectedFilters.contains(AttendanceFilterTypes.halfDay),
                      ),
                    ),
                    // Divider(
                    //   color: ColorUtils.workEntryHead.withValues(alpha: 0.1),
                    //   thickness: 1.h,
                    //   height: 0,
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 10.0, bottom: 10.0).h,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Row(
                    //         children: [
                    //           CircleAvatar(
                    //             backgroundColor: const Color(0xFFB736DC),
                    //             radius: 5.h,
                    //           ),
                    //           SizedBox(width: 5.h),
                    //           Text(
                    //             "Overtime",
                    //             style: GoogleFonts.poppins(
                    //               color: ColorUtils.workEntryHead,
                    //               fontWeight: FontWeight.w400,
                    //               fontSize: 13.h,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //       Text(
                    //         formatNumber(overtimeDayCount),
                    //         style: GoogleFonts.poppins(
                    //           color: ColorUtils.workEntryHead,
                    //           fontWeight: FontWeight.w500,
                    //           fontSize: 13.h,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    SummaryDivider(),
                    InkWell(
                      borderRadius: BorderRadius.circular(6).r,
                      onTap: () {
                        controller.filterManagerAttDetails(type: AttendanceFilterTypes.offDay);
                      },
                      child: FilterButtonExpanded(
                        color: Color(0xFFCCCCCD),
                        count: formatNumber(offDayCount),
                        title: "Off Day",
                        isSelected: controller.selectedFilters.contains(AttendanceFilterTypes.offDay),
                      ),
                    ),
                    SummaryDivider(),
                    InkWell(
                      borderRadius: BorderRadius.circular(6).r,
                      onTap: () {
                        controller.filterManagerAttDetails(type: AttendanceFilterTypes.fine);
                      },
                      child: FilterButtonExpanded(
                        color: Color(0xFFFFCACA),
                        count: formatNumber(fineDayCount),
                        title: "Fine",
                        isSelected: controller.selectedFilters.contains(AttendanceFilterTypes.fine),
                      ),
                    ),
                    SummaryDivider(),
                    InkWell(
                      borderRadius: BorderRadius.circular(6).r,
                      onTap: () {
                        controller.filterManagerAttDetails(type: AttendanceFilterTypes.overtime);
                      },
                      child: FilterButtonExpanded(
                        color: ColorUtils.ot2,
                        count: formatNumber(overtimeDayCount),
                        title: "Overtime",
                        isSelected: controller.selectedFilters.contains(AttendanceFilterTypes.overtime),
                      ),
                    ),
                    SummaryDivider(),
                    InkWell(
                      borderRadius: BorderRadius.circular(6).r,
                      onTap: () {
                        controller.filterManagerAttDetails(type: AttendanceFilterTypes.paidLeave);
                      },
                      child: FilterButtonExpanded(
                        color: Color(0xFFED8E1F),
                        count: formatNumber(paidLeaveDayCount),
                        title: "Paid Leave",
                        isSelected: controller.selectedFilters.contains(AttendanceFilterTypes.paidLeave),
                      ),
                    ),
                  ],
                );
              }
            }
        ),
      ),
    );
  }

  String formatNumber(int input) {
    // Check if the number is an integer.
    if (input % 1 == 0) {
      return input.toInt().toString(); // Return as an integer string
    }
    // Otherwise, return the original number as a string.
    return input.toString();
  }
}
