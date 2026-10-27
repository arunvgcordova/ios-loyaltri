import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/Attendance_Page/attendance_widgets/strip_graph.dart';
import 'package:loyaltri_minimal/controller/attSummaryController.dart';
import 'package:loyaltri_minimal/controller/attendanceListController.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/manager_attendance_controller/manager_attendance_controller.dart';

import '../../../models/attendance_summary_model.dart';
import '../../../utils/color_utils.dart';

class NewAttendanceSummary extends StatefulWidget {
  const NewAttendanceSummary({super.key});

  @override
  State<NewAttendanceSummary> createState() => _NewAttendanceSummaryState();
}

class _NewAttendanceSummaryState extends State<NewAttendanceSummary> {
  final ExpansibleController expansionController = ExpansibleController();

  @override
  Widget build(BuildContext context) {
    final AttendanceList attListController = Get.find<AttendanceList>();
    return GetX<AttendanceSummaryController>(
      builder: (AttendanceSummaryController controller) {
        AttSummary? result = controller.attendanceSummary.value.result;
        double present = result?.present ?? 0;
        double halfDay = result?.halfDay ?? 0;
        double offDay = result?.offDays ?? 0;
        double holiDay = result?.holiDayCount ?? 0;
        double paidLeave = result?.paidLeave ?? 0;
        double unpaidLeave = result?.absentLOP ?? 0;
        double overtime = (result?.overTime?.pendingOverTimeCount ?? 0) + (result?.overTime?.approvedOverTimeCount ?? 0);
        double fine = (result?.fine?.finedCount ?? 0) + (result?.fine?.pardonedFineCount ?? 0);
        double total = 1;
        total = present + halfDay + offDay + holiDay + paidLeave + unpaidLeave;
        int presentCount = 1;
        int halfDayCount = 1;
        int offDayCount = 1;
        int holidayCount = 1;
        int paidLeaveCount = 1;
        int unpaidLeaveCount = 1;
        int overtimeCount = 1;
        int fineCount = 1;

        if (total != 0) {
          presentCount = (333 * present) ~/ total;
          halfDayCount = (333 * halfDay) ~/ total;
          offDayCount = (333 * offDay) ~/ total;
          holidayCount = (333 * holiDay) ~/ total;
          paidLeaveCount = (333 * paidLeave) ~/ total;
          unpaidLeaveCount = (333 * unpaidLeave) ~/ total;
          overtimeCount = (333 * overtime) ~/ total;
          fineCount = (333 * fine) ~/ total;
        }

        final List<AttendanceGridItem> attendanceItems1 = [
          AttendanceGridItem(label: "Present", count: present, color: ColorUtils.workingDayColor, filterType: AttendanceFilterTypes.present),
          AttendanceGridItem(label: "Half-Day", count: halfDay, color: ColorUtils.incompleteDayColor, filterType: AttendanceFilterTypes.halfDay),
          AttendanceGridItem(label: "Off Day", count: offDay, color: ColorUtils.offDayColor, filterType: AttendanceFilterTypes.offDay),
          AttendanceGridItem(label: "Holiday", count: holiDay, color: ColorUtils.holidayColor, filterType: AttendanceFilterTypes.holiday),
          AttendanceGridItem(label: "Paid Leave", count: paidLeave, color: ColorUtils.paidLeaveColor, filterType: AttendanceFilterTypes.paidLeave),
          AttendanceGridItem(label: "Unpaid Leave", count: unpaidLeave, color: ColorUtils.errorRedBorder, filterType: AttendanceFilterTypes.unpaidLeave),
        ];

        final List<AttendanceGridItem> attendanceItems2 = [
          AttendanceGridItem(label: "Overtime", count: overtime, color: ColorUtils.otColorForAttDetail2, filterType: AttendanceFilterTypes.overtime),
          AttendanceGridItem(label: "Fine", count: fine, color: ColorUtils.generalShift9, filterType: AttendanceFilterTypes.fine),
        ];

        final List<AttendanceGridItem> allFilterItems = [
          ...attendanceItems1,
          ...attendanceItems2,
        ];
        return Container(
          padding: const EdgeInsets.only(left: 12, right: 12).w,
          decoration: BoxDecoration(
            color: ColorUtils.backgroundBlack,
            borderRadius: BorderRadius.circular(14).r,
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent, splashColor: Colors.transparent),
            child: ExpansionTile(
              controller: expansionController,
              collapsedIconColor: ColorUtils.textWhite,
              iconColor: ColorUtils.textWhite,
              tilePadding: EdgeInsets.zero,
              childrenPadding: EdgeInsets.zero,
              showTrailingIcon: false,
              initiallyExpanded: false,
              onExpansionChanged: (value) {
                controller.summaryExpansionChanged.value = value;
              },
              title: SizedBox(
                // height: 310.w,
                width: ScreenUtil().screenWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Summary",
                          style: GoogleFonts.poppins(
                            color: ColorUtils.textWhite,
                            fontSize: 15.h,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: ColorUtils.foregroundBlack,
                                borderRadius: BorderRadius.circular(10).r,
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 8.h,
                                horizontal: 12.h,
                              ),
                              child: Text(
                                "${controller.totalDays.value} Days",
                                style: GoogleFonts.poppins(
                                  color: ColorUtils.textWhite,
                                  fontSize: 12.h,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            SizedBox(width: 12.h),
                            AnimatedRotation(
                              turns: controller.summaryExpansionChanged.value
                                  ? 0.5
                                  : 0.0,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              child: SvgPicture.asset(
                                "assets/images/manager_view/arrow_up.svg",
                                height: 7.h,
                                colorFilter: ColorFilter.mode(
                                  ColorUtils.textWhite,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (total != 0)
                      Padding(
                      padding: const EdgeInsets.only(top: 15.0, bottom: 8.0).w,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8).r,
                        child: Row(
                          children: [
                            if (present > 0)
                              Flexible(
                                flex: (present * 100).ceil(),
                                child: StripGraph(
                                  width: presentCount,
                                  height: 18,
                                  colors: const [ColorUtils.workingDayColor, ColorUtils.workingDayColor],
                                ),
                              ),
                            if (halfDay > 0)
                              Flexible(
                                flex: (halfDay * 100).ceil(),
                                child: StripGraph(
                                  width: halfDayCount,
                                  height: 18,
                                  colors: const [ColorUtils.incompleteDayColor, ColorUtils.incompleteDayColor],
                                ),
                              ),
                            if (offDay > 0)
                              Flexible(
                                flex: (offDay * 100).ceil(),
                                child: StripGraph(
                                  width: offDayCount,
                                  height: 18,
                                  colors: const [ColorUtils.offDayColor, ColorUtils.offDayColor],
                                ),
                              ),
                            if (holiDay > 0)
                              Flexible(
                                flex: (holiDay * 100).ceil(),
                                child: StripGraph(
                                  width: holidayCount,
                                  height: 18,
                                  colors: const [ColorUtils.holidayColor, ColorUtils.holidayColor],
                                ),
                              ),
                            if (paidLeave > 0)
                              Flexible(
                                flex: (paidLeave * 100).ceil(),
                                child: StripGraph(
                                  width: paidLeaveCount,
                                  height: 18,
                                  colors: const [ColorUtils.paidLeaveColor, ColorUtils.paidLeaveColor],
                                ),
                              ),
                            if (unpaidLeave > 0)
                              Flexible(
                                flex: (unpaidLeave * 100).ceil(),
                                child: StripGraph(
                                  width: unpaidLeaveCount,
                                  height: 18,
                                  colors: const [ColorUtils.errorRedBorder, ColorUtils.errorRedBorder],
                                ),
                              ),
                            if (overtime > 0)
                              Flexible(
                                flex: (overtime * 100).ceil(),
                                child: StripGraph(
                                  width: overtimeCount,
                                  height: 18,
                                  colors: const [ColorUtils.otColorForAttDetail2, ColorUtils.otColorForAttDetail2],
                                ),
                              ),
                            if (fine > 0)
                              Flexible(
                                flex: (fine * 100).ceil(),
                                child: StripGraph(
                                  width: fineCount,
                                  height: 18,
                                  colors: const [ColorUtils.generalShift9, ColorUtils.generalShift9],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    if (!controller.summaryExpansionChanged.value) ...[
                      SizedBox(height: 10.h),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Obx(() {
                          return Row(
                            children: allFilterItems.map((item) {
                              bool isSelected = attListController.selectedFilters.contains(item.filterType);
                              return Padding(
                                padding: EdgeInsets.only(right: 8.h),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(5).r,
                                  onTap: () {
                                    attListController.filterAttendanceDetails(type: item.filterType);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 6.h),
                                    decoration: BoxDecoration(
                                      color: isSelected ? item.color.withValues(alpha: 0.25) : ColorUtils.foregroundBlack,
                                      borderRadius: BorderRadius.circular(5).r,
                                      border: isSelected
                                          ? Border.all(width: 1.5.h, color: item.color)
                                          : Border.all(width: 1.h, color: ColorUtils.letterTypeUnselected.withValues(alpha: 0.3)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CircleAvatar(backgroundColor: item.color, radius: 5.h),
                                        SizedBox(width: 5.h),
                                        Text(
                                          "${item.label} ",
                                          style: GoogleFonts.poppins(
                                            color: ColorUtils.textWhite,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12.h,
                                          ),
                                        ),
                                        Text(
                                          formatNumber(item.count),
                                          style: GoogleFonts.poppins(
                                            color: ColorUtils.textWhite,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12.h,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }),
                      ),
                      SizedBox(height: 6.h),
                    ],
                  ],
                ),
              ),
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: attendanceItems1.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10.h,
                    crossAxisSpacing: 10.h,
                    mainAxisExtent: 40.h,
                  ),
                  itemBuilder: (context, index) {
                    final item = attendanceItems1[index];

                    return Obx(() {
                      bool isSelected = attListController.selectedFilters.contains(item.filterType);
                      return InkWell(
                        borderRadius: BorderRadius.circular(6).r,
                        onTap: () {
                          attListController.filterAttendanceDetails(type: item.filterType);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected ? item.color.withValues(alpha: 0.25) : null,
                            border: Border.all(
                              color: isSelected ? item.color : ColorUtils.letterTypeUnselected,
                              width: isSelected ? 1.5.h : 1.h,
                            ),
                            borderRadius: BorderRadius.circular(6).r,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: item.color,
                                      radius: 5.h,
                                    ),
                                    SizedBox(width: 5.h),
                                    Expanded(
                                      child: Text(
                                        item.label,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(
                                          color: ColorUtils.textWhite,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12.h,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 4.h),
                              Text(
                                formatNumber(item.count),
                                style: GoogleFonts.poppins(
                                  color: ColorUtils.textWhite,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.h,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
                  },
                ),
                SizedBox(height: 15.h),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: attendanceItems2.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10.h,
                    crossAxisSpacing: 10.h,
                    mainAxisExtent: 100.h,
                  ),
                  itemBuilder: (context, index) {
                    final item = attendanceItems2[index];

                    return Obx(() {
                      bool isSelected = attListController.selectedFilters.contains(item.filterType);
                      return InkWell(
                        borderRadius: BorderRadius.circular(6).r,
                        onTap: () {
                          attListController.filterAttendanceDetails(type: item.filterType);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.h,
                            vertical: 10.h,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected ? item.color.withValues(alpha: 0.25) : null,
                            border: Border.all(
                              color: isSelected ? item.color : ColorUtils.letterTypeUnselected,
                              width: isSelected ? 1.5.h : 1.h,
                            ),
                            borderRadius: BorderRadius.circular(6).r,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        if(item.label == 'Overtime')
                                          Container(
                                            height: 14.h,
                                            width: 21.h,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF3d2871),
                                              borderRadius: BorderRadius.circular(500).r,
                                              border: Border.all(
                                                color: Color(0xFF532c9c),
                                              ),
                                            ),
                                            child: Center(
                                              child: Container(
                                                height: 6.h,
                                                width: 13.h,
                                                decoration: BoxDecoration(
                                                  color: item.color,
                                                  borderRadius: BorderRadius.circular(500).r,
                                                ),
                                              ),
                                            ),
                                          )
                                        else
                                          CircleAvatar(
                                            backgroundColor: item.color,
                                            radius: 7.h,
                                          ),
                                        SizedBox(width: 5.h),
                                        Expanded(
                                          child: Text(
                                            item.label,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                              color: ColorUtils.textWhite,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12.h,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 4.h),
                                  Text(
                                    formatNumber(item.count),
                                    style: GoogleFonts.poppins(
                                      color: ColorUtils.textWhite,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.h,
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                height: 0,
                                color: ColorUtils.letterTypeUnselected,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.label == 'Overtime' ? 'Approved' : 'Pardon',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        color: ColorUtils.textWhite.withValues(alpha: 0.5),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 10.h,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 4.h),
                                  Flexible(
                                    child: Text(
                                      item.label == 'Overtime' ? result?.overTime?.approvedOverTimeHours ?? '--' : result?.fine?.pardonedHours ?? '--',
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        color: ColorUtils.textWhite,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10.h,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    item.label == 'Overtime' ? 'Pending' : 'Fine',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      color: ColorUtils.textWhite.withValues(alpha: 0.5),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 10.h,
                                    ),
                                  ),
                                  SizedBox(width: 4.h),
                                  Flexible(
                                    child: Text(
                                      item.label == 'Overtime' ? result?.overTime?.pendingOverTimeHours ?? '--' : result?.fine?.finedHours ?? '--',
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        color: ColorUtils.textWhite,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10.h,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    });
                  },
                ),
                SizedBox(height: 12.h),
              ],
            ),
          ),
        );
      },
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
