
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/Attendance_Page/attendance_widgets/regularizationBottomSheet.dart';

import '../../../controller/attendanceListController.dart';
import '../../../controller/userAuthentication.dart';
import '../../../controller/userProfileController.dart';
import '../../../models/attendance_details_api_model.dart';
import '../../../services/ui_model_services/regularization_submit_model.dart';
import '../../../utils/color_utils.dart';
import '../../CWidgets/cwidgets.dart';
import '../../CWidgets/error_dialog.dart';
import '../Attendance_Details.dart';

class RosterAttendanceWidget extends StatefulWidget {
  final Attendance activity;
  const RosterAttendanceWidget({super.key, required this.activity});

  @override
  State<RosterAttendanceWidget> createState() => _RosterAttendanceWidgetState();
}

class _RosterAttendanceWidgetState extends State<RosterAttendanceWidget> {
  TextEditingController _reasonController = TextEditingController();

  final FocusNode _reasonFocusNode = FocusNode();

  final String _companyId = Get.find<UserProfileController>().userData.value.result.companyId?.toString() ?? '';

  final String _employeeId = Get.find<UserAuthController>().userData.value.userData?.employeeId ?? '--';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0).h,
      child: GestureDetector(
        onTap: () {
          if(widget.activity.isNotSync ?? false) {
            ErrorDialog().syncPopUp(
              title: "Sync Attendance Data",
              mainContext: context,
            );
          } else {
            String empId = Get.find<UserAuthController>().userData.value.userData?.employeeId ?? '';
            Navigator.of(context).push(
              newSlideNavigation(AttendanceDetails(attendanceId: widget.activity.employeeDailyAttendanceId.toString(), employeeId: empId)),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12).h,
          decoration: BoxDecoration(
              color: ColorUtils.deepMidnightPurple,
              borderRadius: BorderRadius.circular(14).r,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3).h,
                            child: CircleAvatar(
                              backgroundColor: getColor(widget.activity.status.toString()),
                              radius: 6.r,
                            ),
                          ),
                          if(widget.activity.status != null)
                            Padding(
                              padding: const EdgeInsets.only(left: 4, bottom: 3).h,
                              child: Text(
                                widget.activity.status.toString(),
                                style: GoogleFonts.poppins(
                                  color: getColor(widget.activity.status.toString()),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13.h,
                                ),
                              ),
                            ),
                          if(widget.activity.status == null)
                            Padding(
                              padding: const EdgeInsets.only(left: 8, bottom: 3).h,
                              child: Text(
                                getStatus(),
                                style: GoogleFonts.poppins(
                                  color: getColor(getStatus()),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13.h,
                                ),
                              ),
                            ),
                        ],
                      ),
                      Text(
                        formatDate(widget.activity.date!),
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 11.h,
                          color: ColorUtils.textWhite.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Daily Total: ",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 11.h,
                          color: ColorUtils.textWhite.withValues(alpha: 0.5),
                        ),
                      ),
                      Text(
                        widget.activity.totalWorkHours == null || widget.activity.totalWorkHours == "" ? "-- --" : widget.activity.totalWorkHours!,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 11.h,
                          color: ColorUtils.textWhite,
                        ),
                      ),
                      SizedBox(width: 12.h),
                      Text(
                        String.fromCharCode(Icons.arrow_forward_ios.codePoint),
                        style: TextStyle(
                          fontSize: 18.h,
                          fontWeight: FontWeight.w500,
                          color: ColorUtils.textWhite,
                          fontFamily: Icons.arrow_forward_ios.fontFamily,
                          package: Icons.arrow_forward_ios.fontPackage,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if(widget.activity.shiftData?.isNotEmpty ?? false)
                SizedBox(height: 10.h),

              ListView.separated(
                itemCount: widget.activity.shiftData?.length ?? 0,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    ShiftData? shiftAtt = widget.activity.shiftData?[index];
                    return Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 10.h,
                        horizontal: 13.h,
                      ),
                      decoration: BoxDecoration(
                        color: ColorUtils.datePickColor,
                        borderRadius: BorderRadius.circular(10).r,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 4.h,
                                    horizontal: 8.h,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6).r,
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        ColorUtils.royalBlue,
                                        ColorUtils.sapphireBlue,
                                      ],
                                    ),
                                  ),
                                  child: Text(
                                    shiftAtt?.shiftName ?? '--',
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      color: ColorUtils.textWhite,
                                      fontSize: 11.h,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.h),
                              Flexible(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Total Hours: ",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 10.h,
                                        color: ColorUtils.textWhite.withValues(alpha: 0.5),
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        shiftAtt?.totalWorkHours ?? '-- --',
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 10.h,
                                          color: ColorUtils.textWhite,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 13.h),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/images/manager_view/edit_att_time.svg",
                                        colorFilter: ColorFilter.mode(ColorUtils.steelGrey, BlendMode.srcIn),
                                        height: 10.h,
                                        fit: BoxFit.fitHeight,
                                      ),
                                      SizedBox(width: 5.h),
                                      Text(
                                        'Check in',
                                        style: GoogleFonts.poppins(
                                          color: ColorUtils.steelGrey,
                                          fontSize: 10.h,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    (shiftAtt?.firstCheckInTime?.isEmpty ?? true) ? '--' : shiftAtt?.firstCheckInTime ?? '--',
                                    style: GoogleFonts.poppins(
                                      color: ColorUtils.textWhite,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13.h,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 20.h),
                              Container(
                                width: 2.h,
                                height: 25.h,
                                color: ColorUtils.charcoalPurple,
                              ),
                              SizedBox(width: 20.h),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/images/manager_view/edit_att_time.svg",
                                        colorFilter: ColorFilter.mode(ColorUtils.steelGrey, BlendMode.srcIn),
                                        height: 10.h,
                                        fit: BoxFit.fitHeight,
                                      ),
                                      SizedBox(width: 5.h),
                                      Text(
                                        'Check out',
                                        style: GoogleFonts.poppins(
                                          color: ColorUtils.steelGrey,
                                          fontSize: 10.h,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    (shiftAtt?.lastCheckOutTime?.isEmpty ?? true) ? '--' : shiftAtt?.lastCheckOutTime ?? '--',
                                    style: GoogleFonts.poppins(
                                      color: ColorUtils.textWhite,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13.h,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 10.h),
                              Flexible(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    physics: AlwaysScrollableScrollPhysics(),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                      if(shiftAtt?.isLateEntry == '1')
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                if(widget.activity.missPunchData?.remarks != null) {
                                                  _reasonController.text = widget.activity.missPunchData?.remarks ?? '';
                                                } else {
                                                  _reasonController.clear();
                                                }
                                                Get.find<AttendanceList>().fetchDeductionDetails(
                                                  attendanceId: widget.activity.employeeDailyAttendanceId.toString(),
                                                  type: widget.activity.lateEntryData?.deductionDetails ?? "Late Entry",
                                                  shiftId: widget.activity.shiftId
                                                );
                                                Get.find<AttendanceList>().deductionToggle.value = false;
                                                Get.find<AttendanceList>().selectedLeave.value = null;
                                                showModalBottomSheet(
                                                  backgroundColor: ColorUtils.backgroundBlack,
                                                  context: context,
                                                  isScrollControlled: true,
                                                  barrierColor: const Color(0xFF000000).withOpacity(0.55),
                                                  useSafeArea: true,
                                                  isDismissible: false,
                                                  builder: (BuildContext context) {
                                                    return RegularizationBottomSheet(
                                                      regularizationType: RegularizationType.le,
                                                      employeeDailyAttendanceId: widget.activity.employeeDailyAttendanceId.toString(),
                                                      employeeId: widget.activity.employeeId,
                                                      reasonController: _reasonController,
                                                      reasonFocusNode: _reasonFocusNode,
                                                    );
                                                  },
                                                );
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 4).h,
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10).h,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(4).r,
                                                    color: shiftAtt?.lateEntryData?.color,
                                                  ),
                                                  child: Text(
                                                    "LE",
                                                    style: GoogleFonts.inter(
                                                      color: (shiftAtt?.lateEntryData?.status?.isEmpty ?? true) ? Color(0xFFD52A2A) : ColorUtils.textWhite,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 12.h,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      if(shiftAtt?.isOverTime == '1')
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                if(widget.activity.missPunchData?.remarks != null) {
                                                  _reasonController.text = widget.activity.missPunchData?.remarks ?? '';
                                                } else {
                                                  _reasonController.clear();
                                                }
                                                Get.find<AttendanceList>().fetchDeductionDetails(
                                                  attendanceId: widget.activity.employeeDailyAttendanceId.toString(),
                                                  type: "Over Time",
                                                    shiftId: widget.activity.shiftId
                                                );
                                                Get.find<AttendanceList>().deductionToggle.value = false;
                                                Get.find<AttendanceList>().selectedLeave.value = null;
                                                showModalBottomSheet(
                                                  backgroundColor: ColorUtils.backgroundBlack,
                                                  context: context,
                                                  isScrollControlled: true,
                                                  barrierColor: const Color(0xFF000000).withOpacity(0.55),
                                                  useSafeArea: true,
                                                  isDismissible: false,
                                                  builder: (BuildContext context) {
                                                    return RegularizationBottomSheet(
                                                      regularizationType: RegularizationType.ot,
                                                      employeeDailyAttendanceId: widget.activity.employeeDailyAttendanceId.toString(),
                                                      employeeId: widget.activity.employeeId,
                                                      reasonController: _reasonController,
                                                      reasonFocusNode: _reasonFocusNode,
                                                    );
                                                  },
                                                );
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 4).h,
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10).h,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(4).r,
                                                    color:  shiftAtt?.overTimeData?.color,
                                                  ),
                                                  child: Text(
                                                    "OT",
                                                    style: GoogleFonts.inter(
                                                      color: (shiftAtt?.overTimeData?.status?.isEmpty ?? true) ? Color(0xFFD52A2A) : ColorUtils.textWhite,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 12.h,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      if(shiftAtt?.isExcessBreak == '1')
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                if(widget.activity.missPunchData?.remarks != null) {
                                                  _reasonController.text = widget.activity.missPunchData?.remarks ?? '';
                                                } else {
                                                  _reasonController.clear();
                                                }
                                                Get.find<AttendanceList>().fetchDeductionDetails(
                                                  attendanceId: widget.activity.employeeDailyAttendanceId.toString(),
                                                  type: widget.activity.excessBreakData?.deductionDetails ?? "Excess Break",
                                                    shiftId: widget.activity.shiftId
                                                );
                                                Get.find<AttendanceList>().deductionToggle.value = false;
                                                Get.find<AttendanceList>().selectedLeave.value = null;
                                                showModalBottomSheet(
                                                  backgroundColor: ColorUtils.backgroundBlack,
                                                  context: context,
                                                  isScrollControlled: true,
                                                  barrierColor: const Color(0xFF000000).withOpacity(0.55),
                                                  useSafeArea: true,
                                                  isDismissible: false,
                                                  builder: (BuildContext context) {
                                                    return RegularizationBottomSheet(
                                                      reasonController: _reasonController,
                                                      regularizationType: RegularizationType.eb,
                                                      employeeDailyAttendanceId: widget.activity.employeeDailyAttendanceId.toString(),
                                                      employeeId: widget.activity.employeeId,
                                                      reasonFocusNode: _reasonFocusNode,
                                                    );
                                                  },
                                                );
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 4).h,
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10).h,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(4).r,
                                                    color: shiftAtt?.excessBreakData?.color,
                                                  ),
                                                  child: Text(
                                                    "EB",
                                                    style: GoogleFonts.inter(
                                                      color: (shiftAtt?.excessBreakData?.status?.isEmpty ?? true) ? Color(0xFFD52A2A) : ColorUtils.textWhite,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 12.h,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      if(shiftAtt?.isEarlyExit == '1')
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                if(widget.activity.missPunchData?.remarks != null) {
                                                  _reasonController.text = widget.activity.missPunchData?.remarks ?? '';
                                                } else {
                                                  _reasonController.clear();
                                                }
                                                Get.find<AttendanceList>().fetchDeductionDetails(
                                                  attendanceId: widget.activity.employeeDailyAttendanceId.toString(),
                                                  type: widget.activity.earlyExitData?.deductionDetails ?? "Early Exit",
                                                    shiftId: widget.activity.shiftId
                                                );
                                                Get.find<AttendanceList>().deductionToggle.value = false;
                                                Get.find<AttendanceList>().selectedLeave.value = null;
                                                showModalBottomSheet(
                                                  backgroundColor: ColorUtils.backgroundBlack,
                                                  context: context,
                                                  isScrollControlled: true,
                                                  barrierColor: const Color(0xFF000000).withOpacity(0.55),
                                                  useSafeArea: true,
                                                  isDismissible: false,
                                                  builder: (BuildContext context) {
                                                    return RegularizationBottomSheet(
                                                      reasonController: _reasonController,
                                                      regularizationType: RegularizationType.ee,
                                                      employeeDailyAttendanceId: widget.activity.employeeDailyAttendanceId.toString(),
                                                      employeeId: widget.activity.employeeId,
                                                      reasonFocusNode: _reasonFocusNode,
                                                    );
                                                  },
                                                );
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 4).h,
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10).h,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(4).r,
                                                    color: shiftAtt?.earlyExitData?.color,
                                                  ),
                                                  child: Text(
                                                    "EE",
                                                    style: GoogleFonts.inter(
                                                      color: (shiftAtt?.earlyExitData?.status?.isEmpty ?? true) ? Color(0xFFD52A2A) : ColorUtils.textWhite,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 12.h,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      if(shiftAtt?.isMissPunch == '1')
                                        InkWell(
                                          onTap: () {
                                            if(widget.activity.missPunchData?.remarks != null) {
                                              _reasonController.text = widget.activity.missPunchData?.remarks ?? '';
                                            } else {
                                              _reasonController.clear();
                                            }
                                            Get.find<AttendanceList>().fetchDeductionDetails(
                                              attendanceId: widget.activity.employeeDailyAttendanceId.toString(),
                                              type: widget.activity.missPunchData?.deductionDetails ?? "Miss Punch",
                                                shiftId: widget.activity.shiftId
                                            );
                                            Get.find<AttendanceList>().deductionToggle.value = false;
                                            Get.find<AttendanceList>().selectedLeave.value = null;
                                            showModalBottomSheet(
                                              backgroundColor: ColorUtils.backgroundBlack,
                                              context: context,
                                              isScrollControlled: true,
                                              barrierColor: const Color(0xFF000000).withOpacity(0.55),
                                              useSafeArea: true,
                                              isDismissible: false,
                                              builder: (BuildContext context) {
                                                return RegularizationBottomSheet(
                                                  reasonController: _reasonController,
                                                  regularizationType: RegularizationType.mp,
                                                  employeeDailyAttendanceId: widget.activity.employeeDailyAttendanceId.toString(),
                                                  employeeId: widget.activity.employeeId,
                                                  reasonFocusNode: _reasonFocusNode,
                                                );
                                              },
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 4).h,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10).h,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(4).r,
                                                color: shiftAtt?.missPunchData?.color,
                                              ),
                                              child: Text(
                                                "MP",
                                                style: GoogleFonts.inter(
                                                  color: (shiftAtt?.missPunchData?.status?.isEmpty ?? true) ? Color(0xFFD52A2A) : ColorUtils.textWhite,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12.h,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      if(shiftAtt?.isShortTime == '1')
                                        InkWell(
                                          onTap: () {
                                            if(widget.activity.missPunchData?.remarks != null) {
                                              _reasonController.text = widget.activity.missPunchData?.remarks ?? '';
                                            } else {
                                              _reasonController.clear();
                                            }
                                            Get.find<AttendanceList>().fetchDeductionDetails(
                                              attendanceId: widget.activity.employeeDailyAttendanceId.toString(),
                                              type: widget.activity.shortTimeData?.deductionDetails ?? "Short Time",
                                                shiftId: widget.activity.shiftId
                                            );
                                            Get.find<AttendanceList>().deductionToggle.value = false;
                                            Get.find<AttendanceList>().selectedLeave.value = null;
                                            showModalBottomSheet(
                                              backgroundColor: ColorUtils.backgroundBlack,
                                              context: context,
                                              isScrollControlled: true,
                                              barrierColor: const Color(0xFF000000).withOpacity(0.55),
                                              useSafeArea: true,
                                              isDismissible: false,
                                              builder: (BuildContext context) {
                                                return RegularizationBottomSheet(
                                                  reasonController: _reasonController,
                                                  regularizationType: RegularizationType.st,
                                                  employeeDailyAttendanceId: widget.activity.employeeDailyAttendanceId.toString(),
                                                  employeeId: widget.activity.employeeId,
                                                  reasonFocusNode: _reasonFocusNode,
                                                );
                                              },
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 4).h,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10).h,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(4).r,
                                                color: shiftAtt?.shortTimeData?.color,
                                              ),
                                              child: Text(
                                                "ST",
                                                style: GoogleFonts.inter(
                                                  color: (shiftAtt?.shortTimeData?.status?.isEmpty ?? true) ? Color(0xFFD52A2A) : ColorUtils.textWhite,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12.h,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => Divider(color: ColorUtils.darkSlatePurple, indent: 7.h, endIndent: 7.h, height: 18.h),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color getColor(String type) {
    switch(type.replaceAll(" ", "").toUpperCase()) {
      case "PRESENT": return ColorUtils.workingDayColor;
      case "INCOMPLETE": return ColorUtils.incompleteDayColor;
      case "ABSENT": return ColorUtils.absentColor;
      case "OFFDAY": return ColorUtils.offDayColor;
      default: return Colors.yellow;
    }
  }

  String getStatus() {
    if(widget.activity.isRegularizationNeeded == '1') {
      return "Incomplete";
    } else if(widget.activity.isHoliday == '1') {
      return "Holiday";
    } else if(widget.activity.isOffDay == '1') {
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
