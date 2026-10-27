
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/Attendance_Page/Attendance_Details.dart';
import 'package:loyaltri_minimal/View/Attendance_Page/attendance_widgets/regularizationBottomSheet.dart';
import 'package:loyaltri_minimal/View/CWidgets/cwidgets.dart';
import 'package:loyaltri_minimal/View/CWidgets/error_dialog.dart';
import 'package:loyaltri_minimal/controller/userAuthentication.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';
import 'package:loyaltri_minimal/services/ui_model_services/regularization_submit_model.dart';
import 'package:loyaltri_minimal/sqflite_db/punch_db.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';
import '../../../controller/attendanceListController.dart';
import '../../../controller/attendanceUploadController.dart';
import '../../../models/attendance_details_api_model.dart';
import '../../../models/checkIn_model.dart';

class DailyActivityWidget extends StatefulWidget {
  final Attendance activity;
  const DailyActivityWidget({super.key, required this.activity});

  @override
  State<DailyActivityWidget> createState() => _DailyActivityWidgetState();
}

class _DailyActivityWidgetState extends State<DailyActivityWidget> {
  TextEditingController _reasonController = TextEditingController();
  final FocusNode _reasonFocusNode = FocusNode();
  final String _companyId = Get.find<UserProfileController>().userData.value.result.companyId?.toString() ?? '';
  final String _employeeId = Get.find<UserAuthController>().userData.value.userData?.employeeId ?? '--';

  @override
  Widget build(BuildContext context) {

    // Color getFineColor() {
    //   if(employeeData?.finedCount == 0 && employeeData?.pardonedCount == 0 && employeeData?.requestsCount == 0) {
    //     return Color(0xFFFFE0E0);
    //   } else if(employeeData?.finedCount != 0 && employeeData?.pardonedCount == 0 && employeeData?.requestsCount == 0) {
    //     return Color(0xFFD52A2A);
    //   } else if(employeeData?.finedCount == 0 && employeeData?.pardonedCount != 0 && employeeData?.requestsCount == 0) {
    //     return Color(0xFF349C5E);
    //   } else if(employeeData?.finedCount == 0 && employeeData?.pardonedCount == 0 && employeeData?.requestsCount != 0) {
    //     return Color(0xFFF0B208);
    //   } else {
    //     return ColorUtils.workEntryHead;
    //   }
    // }
    //
    // Color getFineTextColor() {
    //   if(employeeData?.finedCount == 0 && employeeData?.pardonedCount == 0 && employeeData?.requestsCount == 0) {
    //     return Color(0xFFD52A2A);
    //   } else {
    //     return ColorUtils.textWhite;
    //   }
    // }

    return Padding(
      padding: const EdgeInsets.all(8.0).w,
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
          padding: const EdgeInsets.symmetric(horizontal: 8).w,
          width: ScreenUtil().screenWidth,
          height: 120.w,
          decoration: BoxDecoration(
              color: ColorUtils.backgroundBlack,
              borderRadius: BorderRadius.circular(14).w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: 3.w),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3).w,
                    child: CircleAvatar(
                      backgroundColor: getColor(widget.activity.status.toString().replaceAll(" ", "").toUpperCase()),
                      radius: 6.w,
                    ),
                  ),
                  if(widget.activity.status != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 3).w,
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
                  Spacer(),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if(widget.activity.isLateEntry == '1')
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
                                padding: const EdgeInsets.symmetric(horizontal: 4).w,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10).w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4).w,
                                      color: widget.activity.lateEntryData?.color,
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
                                      color: (widget.activity.lateEntryData?.status?.isEmpty ?? true) ? Color(0xFFD52A2A) : ColorUtils.textWhite,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      if(widget.activity.isOverTime == '1')
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
                                      overTimeData: widget.activity.overTimeData,
                                      reasonController: _reasonController,
                                      reasonFocusNode: _reasonFocusNode,
                                    );
                                  },
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4).w,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10).w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4).w,
                                      color:  widget.activity.overTimeData?.color,
                                      // gradient: const LinearGradient(
                                      //   colors: [
                                      //     ColorUtils.ot1,
                                      //     ColorUtils.ot2,
                                      //   ],
                                      // )
                                  ),
                                  child: Text(
                                    "OT",
                                    style: GoogleFonts.inter(
                                      color: (widget.activity.overTimeData?.status?.isEmpty ?? true) ? Color(0xFFD52A2A) : ColorUtils.textWhite,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      if(widget.activity.isExcessBreak == '1')
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
                                padding: const EdgeInsets.symmetric(horizontal: 4).w,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10).w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4).w,
                                      color: widget.activity.excessBreakData?.color,
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
                                      color: (widget.activity.excessBreakData?.status?.isEmpty ?? true) ? Color(0xFFD52A2A) : ColorUtils.textWhite,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      if(widget.activity.isEarlyExit == '1')
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
                                padding: const EdgeInsets.symmetric(horizontal: 4).w,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10).w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4).w,
                                      color: widget.activity.earlyExitData?.color,
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
                                      color: (widget.activity.earlyExitData?.status?.isEmpty ?? true) ? Color(0xFFD52A2A) : ColorUtils.textWhite,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      if(widget.activity.isMissPunch == '1')
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
                            padding: const EdgeInsets.symmetric(horizontal: 4).w,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10).w,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4).w,
                                  color: widget.activity.missPunchData?.color,
                                  // gradient: const LinearGradient(
                                  //   colors: [
                                  //     ColorUtils.mp1,
                                  //     ColorUtils.mp2,
                                  //   ],
                                  // )
                              ),
                              child: Text(
                                "MP",
                                style: GoogleFonts.inter(
                                  color: (widget.activity.missPunchData?.status?.isEmpty ?? true) ? Color(0xFFD52A2A) : ColorUtils.textWhite,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          ),
                        ),
                      if(widget.activity.isShortTime == '1')
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
                            padding: const EdgeInsets.symmetric(horizontal: 4).w,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10).w,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4).w,
                                  color: widget.activity.shortTimeData?.color,
                                  // gradient: const LinearGradient(
                                  //   colors: [
                                  //     ColorUtils.mp1,
                                  //     ColorUtils.mp2,
                                  //   ],
                                  // )
                              ),
                              child: Text(
                                "ST",
                                style: GoogleFonts.inter(
                                  color: (widget.activity.shortTimeData?.status?.isEmpty ?? true) ? Color(0xFFD52A2A) : ColorUtils.textWhite,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 3.w),
              Row(
                children: [
                  Text(
                    formatDate(widget.activity.date!),
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                      color: ColorUtils.textWhite.withOpacity(0.5),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Total Hours: ",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp,
                          color: ColorUtils.textWhite.withOpacity(0.5),
                        ),
                      ),
                      Text(
                        widget.activity.totalWorkHours == null || widget.activity.totalWorkHours == "" ? "-- --" : widget.activity.totalWorkHours!,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                          color: ColorUtils.textWhite,
                        ),
                      ),
                      // Text(
                      //   " hrs",
                      //   style: LoyaltriFonts.poppinsW400_12sp_textWhiteOp60,
                      // ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 3.w),
              Row(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 3).w,
                        child: Text(
                          "Check In",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                            color: ColorUtils.textWhite.withOpacity(0.5),
                          ),
                        ),
                      ),
                      Text(
                        "${widget.activity.firstCheckInTime != null && widget.activity.firstCheckInTime != '' ? widget.activity.firstCheckInTime : '--'}",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 12.sp,
                          color: ColorUtils.textWhite.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(flex: 5),
                  Container(
                    color: ColorUtils.divider.withOpacity(0.5),
                    width: 35.w,
                    height: 1.w,
                  ),
                  const Spacer(flex: 5),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 3).w,
                        child: Text(
                          "Check Out",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                            color: ColorUtils.textWhite.withOpacity(0.5),
                          ),
                        ),
                      ),
                      Text(
                        "${widget.activity.lastCheckOutTime != null && widget.activity.lastCheckOutTime != '' ? widget.activity.lastCheckOutTime : '--'}",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 12.sp,
                          color: ColorUtils.textWhite.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(flex: 5),
                  Container(
                    color: ColorUtils.divider.withOpacity(0.5),
                    width: 1.w,
                    height: 14.w,
                  ),
                  const Spacer(flex: 5),
                  Text(
                    String.fromCharCode(Icons.arrow_forward_ios.codePoint),
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: ColorUtils.textWhite,
                      fontFamily: Icons.arrow_forward_ios.fontFamily,
                      package: Icons.arrow_forward_ios.fontPackage,
                    ),
                  ),
                  const Spacer(flex: 1),
                ],
              ),
              SizedBox(height: 3.w),
              // const Spacer(),
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Row(
              //       children: [
              //         Padding(
              //           padding: const EdgeInsets.only(bottom: 3).w,
              //           child: CircleAvatar(
              //             backgroundColor: getColor(widget.activity.status.toString().replaceAll(" ", "").toUpperCase()),
              //             radius: 7.w,
              //           ),
              //         ),
              //         if(widget.activity.status != null)
              //           Padding(
              //             padding: const EdgeInsets.only(left: 8, bottom: 3).w,
              //             child: Text(
              //               widget.activity.status.toString(),
              //               style: GoogleFonts.poppins(
              //                 color: getColor(widget.activity.status.toString().replaceAll(" ", "").toUpperCase()),
              //                 fontWeight: FontWeight.w500,
              //                 fontSize: 14.sp,
              //               ),
              //             ),
              //           ),
              //         if(widget.activity.status == null)
              //           Padding(
              //             padding: const EdgeInsets.only(left: 8, bottom: 3).w,
              //             child: Text(
              //               getStatus(),
              //               style: GoogleFonts.poppins(
              //                 color: getColor(getStatus().replaceAll(" ", "").toUpperCase()),
              //                 fontWeight: FontWeight.w500,
              //                 fontSize: 14.sp,
              //               ),
              //             ),
              //           ),
              //       ],
              //     ),
              //     Row(
              //       children: [
              //         CircleAvatar(
              //           backgroundColor: Colors.transparent,
              //           radius: 8.w,
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.only(left: 8).w,
              //           child: Text(
              //             formatDate(widget.activity.date!),
              //             style: GoogleFonts.poppins(
              //               color: const Color(0xFF959CBD),
              //               fontWeight: FontWeight.w400,
              //               fontSize: 12.sp,
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ],
              // ),
              // const Spacer(flex: 5),
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Padding(
              //       padding: const EdgeInsets.only(bottom: 3).w,
              //       child: Text(
              //         "Check In",
              //         style: GoogleFonts.poppins(
              //           color: const Color(0xFF959CBD),
              //           fontWeight: FontWeight.w400,
              //           fontSize: 12.sp,
              //         ),
              //       ),
              //     ),
              //     Text(
              //       widget.activity.firstCheckInTime ?? "__",
              //       style: GoogleFonts.poppins(
              //         color: ColorUtils.textWhite.withOpacity(0.9),
              //         fontWeight: FontWeight.w500,
              //         fontSize: 12.sp,
              //       ),
              //     ),
              //   ],
              // ),
              // const Spacer(),
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Padding(
              //       padding: const EdgeInsets.only(bottom: 3).w,
              //       child: Text(
              //         "Check Out",
              //         style: GoogleFonts.poppins(
              //           color: const Color(0xFF959CBD),
              //           fontWeight: FontWeight.w400,
              //           fontSize: 12.sp,
              //         ),
              //       ),
              //     ),
              //     Text(
              //       widget.activity.lastCheckOutTime ?? "__",
              //       style: GoogleFonts.poppins(
              //         color: ColorUtils.textWhite.withOpacity(0.9),
              //         fontWeight: FontWeight.w500,
              //         fontSize: 12.sp,
              //       ),
              //     ),
              //   ],
              // ),
              // const Spacer(flex: 3),
            ],
          ),
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