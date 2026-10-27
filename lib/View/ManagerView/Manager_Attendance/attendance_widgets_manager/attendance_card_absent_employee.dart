
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/controller/userAuthentication.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';
import '../../../../models/manager/manager_attendance_list_model.dart';
import '../../../../utils/color_utils.dart';
import '../../../CWidgets/cwidgets.dart';
import '../edit_attendance.dart';
import '../manager_attendance_controller/manager_attendance_controller.dart';
import '../manager_attendance_detail.dart';
import '../../../../controller/attendanceListController.dart';
import '../../../../services/ui_model_services/regularization_submit_model.dart';
import '../../../Attendance_Page/attendance_widgets/regularizationBottomSheet.dart';

class AttendanceCardAbsentEmployee extends StatelessWidget {
  final ManagerEmployeeData? employeeData;
  const AttendanceCardAbsentEmployee({super.key, this.employeeData});

  void _openRegularizationBottomSheet({
    required BuildContext context,
    required RegularizationType type,
    required String deductionDetails,
  }) {
    final empId = employeeData?.employeeId?.toString() ?? '';
    final attId = employeeData?.employeeDailyAttendanceId?.toString() ?? '';

    final TextEditingController reasonController = TextEditingController();
    final FocusNode reasonFocusNode = FocusNode();

    Get.find<AttendanceList>().fetchDeductionDetails(
      attendanceId: attId,
      type: deductionDetails,
    );

    Get.find<AttendanceList>().deductionToggle.value = false;
    Get.find<AttendanceList>().selectedLeave.value = null;

    showModalBottomSheet(
      backgroundColor: ColorUtils.textWhite,
      context: context,
      isScrollControlled: true,
      barrierColor: const Color(0xFF000000).withValues(alpha: 0.55),
      useSafeArea: true,
      isDismissible: false,
      builder: (BuildContext context) {
        return RegularizationBottomSheet(
          regularizationType: type,
          employeeId: empId,
          employeeDailyAttendanceId: attId,
          reasonController: reasonController,
          reasonFocusNode: reasonFocusNode,
          isWhiteMode: true,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    Color getFineColor() {
      if(employeeData?.finedCount == 0 && employeeData?.pardonedCount == 0 && employeeData?.requestsCount == 0) {
        return Color(0xFFFFE0E0);
      } else if(employeeData?.finedCount != 0 && employeeData?.pardonedCount == 0 && employeeData?.requestsCount == 0) {
        return Color(0xFFD52A2A);
      } else if(employeeData?.finedCount == 0 && employeeData?.pardonedCount != 0 && employeeData?.requestsCount == 0) {
        return Color(0xFF349C5E);
      } else if(employeeData?.finedCount == 0 && employeeData?.pardonedCount == 0 && employeeData?.requestsCount != 0) {
        return Color(0xFFF0B208);
      } else {
        return ColorUtils.workEntryHead;
      }
    }

    Color getFineTextColor() {
      if(employeeData?.finedCount == 0 && employeeData?.pardonedCount == 0 && employeeData?.requestsCount == 0) {
        return Color(0xFFD52A2A);
      } else {
        return ColorUtils.textWhite;
      }
    }

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AttendanceCommonWidgets().cachedNetworkImage(employeeData?.profilePicture ?? ''),
              SizedBox(width: 8.h),
              Expanded(
                child: AttendanceCommonWidgets().nameWithDesignation(name: employeeData?.employeeName ?? '--', designation: employeeData?.designation ?? '--'),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 5.h,
                  horizontal: 18.h,
                ),
                constraints: BoxConstraints(
                  maxWidth: 150.w,
                ),
                decoration: BoxDecoration(
                  color: ColorUtils.softPearl,
                  borderRadius: BorderRadius.circular(14).r,
                ),
                child: Text(
                  employeeData?.shiftName ?? 'No Shift',
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 11.h,
                    fontWeight: FontWeight.w400,
                    color: ColorUtils.workEntryHead.withValues(alpha: 0.54),
                  ),
                ),
              ),
            ],
          ),
          Divider(color: ColorUtils.softGrey, thickness: 1.h, indent: 3.h, endIndent: 3.h),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 3.h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AttendanceCommonWidgets().checkInTime(employeeData?.firstCheckInTime ?? '--'),
                Container(width: 1.h, height: 20.h, color: ColorUtils.paleSilver),
                AttendanceCommonWidgets().checkOutTime(employeeData?.lastCheckOutTime ?? '--'),
                Container(width: 1.h, height: 20.h, color: ColorUtils.paleSilver),
                AttendanceCommonWidgets().workedHours(employeeData?.totalWorkHours ?? '--'),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 3.h,
              vertical: 2.h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 9.h,
                        height: 9.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: statusColor(employeeData?.status ?? ''),
                        ),
                      ),
                      SizedBox(width: 3.h),
                      Flexible(
                        child: Text(
                          employeeData?.status ?? '--',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 13.h,
                            fontWeight: FontWeight.w500,
                            color: statusColor(employeeData?.status ?? ''),
                          ),
                        ),
                      ),
                      SizedBox(width: 3.h),
                      if(employeeData?.isLateEntry ?? false)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4).h,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(4).r,
                            onTap: () {
                              _openRegularizationBottomSheet(
                                context: context,
                                type: RegularizationType.le,
                                deductionDetails: "Late Entry",
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8).h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4).r,
                                  color: getFineColor(),
                              ),
                              child: Text(
                                "LE",
                                style: GoogleFonts.inter(
                                  color: getFineTextColor(),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11.h,
                                ),
                              ),
                            ),
                          ),
                        ),
                      if(employeeData?.isOverTime ?? false)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4).h,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(4).r,
                            onTap: () {
                              Get.find<ManagerAttendanceController>().selectedEmployeeData.value = employeeData;
                              // Get.find<ManagerAttendanceController>().resetPunchValues();
                              // Get.find<ManagerAttendanceController>().editType.value = leaveTypes[4];
                              // Get.find<ManagerAttendanceController>().savedEditType.value = leaveTypes[4];
                              // Get.find<ManagerAttendanceController>().fetchEmployeeAttDetail(attId: employeeData?.employeeDailyAttendanceId.toString() ?? '');
                              Navigator.of(context).push(
                                newSlideNavigation(EditAttendance(status: 'overtime')),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8).h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4).r,
                                color: getFineColor(),
                              ),
                              child: Text(
                                "OT",
                                style: GoogleFonts.inter(
                                  color: getFineTextColor(),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11.h,
                                ),
                              ),
                            ),
                          ),
                        ),
                      if(employeeData?.isExcessBreak ?? false)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4).h,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(4).r,
                            onTap: () {
                              _openRegularizationBottomSheet(
                                context: context,
                                type: RegularizationType.eb,
                                deductionDetails: "Excess Break",
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8).h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4).r,
                                color: getFineColor(),
                              ),
                              child: Text(
                                "EB",
                                style: GoogleFonts.inter(
                                  color: getFineTextColor(),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11.h,
                                ),
                              ),
                            ),
                          ),
                        ),
                      if(employeeData?.isEarlyExit ?? false)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4).h,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(4).r,
                            onTap: () {
                              _openRegularizationBottomSheet(
                                context: context,
                                type: RegularizationType.ee,
                                deductionDetails: "Early Exit",
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8).h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4).r,
                                color: getFineColor(),
                              ),
                              child: Text(
                                "EE",
                                style: GoogleFonts.inter(
                                  color: getFineTextColor(),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11.h,
                                ),
                              ),
                            ),
                          ),
                        ),
                      if(employeeData?.isMissPunch ?? false)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4).h,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(4).r,
                            onTap: () {
                              _openRegularizationBottomSheet(
                                context: context,
                                type: RegularizationType.mp,
                                deductionDetails: "Miss Punch",
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8).h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4).r,
                                color: getFineColor(),
                              ),
                              child: Text(
                                "MP",
                                style: GoogleFonts.inter(
                                  color: getFineTextColor(),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11.h,
                                ),
                              ),
                            ),
                          ),
                        ),
                      if(employeeData?.isShortTime ?? false)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4).h,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(4).r,
                            onTap: () {
                              _openRegularizationBottomSheet(
                                context: context,
                                type: RegularizationType.st,
                                deductionDetails: "Short Time",
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8).h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4).r,
                                color: getFineColor(),
                              ),
                              child: Text(
                                "ST",
                                style: GoogleFonts.inter(
                                  color: getFineTextColor(),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11.h,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if(employeeData?.status?.toString().toLowerCase().trim() != 'absent')
                      InkWell(
                        borderRadius: BorderRadius.circular(20).r,
                        onTap: () {
                          Navigator.of(context).push(
                            newSlideNavigation(ManagerAttendanceDetails(attendanceId: employeeData?.employeeDailyAttendanceId?.toString() ?? '', employeeId: employeeData?.employeeId?.toString() ?? '')),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 6.h,
                            horizontal: 10.h,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFDDDDDD),
                            borderRadius: BorderRadius.circular(20).r,
                            border: Border.all(
                              color: ColorUtils.frostedPearl,
                              width: 1.h,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                "assets/images/manager_view/view_log_icon.svg",
                                height: 12.h,
                              ),
                              SizedBox(width: 1.h),
                              Text(
                                "View Log",
                                style: GoogleFonts.inter(
                                  fontSize: 11.h,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF020202),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if(employeeData?.status?.toString().toLowerCase().trim() != 'absent')
                      SizedBox(width: 8.h),
                    InkWell(
                      borderRadius: BorderRadius.circular(20).r,
                      onTap: () {
                        if(Get.find<UserAuthController>().userData.value.userData?.attendanceEdit ?? false) {
                          String? status = employeeData?.status?.replaceAll(" ", "").trim().toLowerCase();

                          AttendanceCommonWidgets().printF("--------status-------$status");

                          Get.find<ManagerAttendanceController>().selectedEmployeeData.value = employeeData;
                          Navigator.of(context).push(
                            newSlideNavigation(EditAttendance(status: status)),
                          );
                          // if(status != null || status!.isNotEmpty) {
                          //   Get.find<ManagerAttendanceController>().selectedEmployeeData.value = employeeData;
                          //   Get.find<ManagerAttendanceController>().resetPunchValues();
                          //   if(status == 'present') {
                          //     Get.find<ManagerAttendanceController>().editType.value = leaveTypes[0];
                          //     Get.find<ManagerAttendanceController>().savedEditType.value = leaveTypes[0];
                          //     Get.find<ManagerAttendanceController>().fetchEmployeeShift();
                          //     Get.find<ManagerAttendanceController>().fetchEmployeeAttDetail(attId: employeeData?.employeeDailyAttendanceId.toString() ?? '');
                          //     Navigator.of(context).push(
                          //       newSlideNavigation(EditAttendance()),
                          //     );
                          //   } else if(status == 'halfday') {
                          //     Get.find<ManagerAttendanceController>().editType.value = leaveTypes[1];
                          //     Get.find<ManagerAttendanceController>().savedEditType.value = leaveTypes[1];
                          //     Get.find<ManagerAttendanceController>().fetchEmployeeShift();
                          //     Get.find<ManagerAttendanceController>().fetchEmployeeLeaveType();
                          //     Get.find<ManagerAttendanceController>().fetchEmployeeAttDetail(attId: employeeData?.employeeDailyAttendanceId.toString() ?? '');
                          //     Navigator.of(context).push(
                          //       newSlideNavigation(EditAttendance()),
                          //     );
                          //   } else if(status == 'absent') {
                          //     Get.find<ManagerAttendanceController>().editType.value = leaveTypes[2];
                          //     Get.find<ManagerAttendanceController>().savedEditType.value = leaveTypes[2];
                          //     Get.find<ManagerAttendanceController>().fetchEmployeeAttDetail(attId: employeeData?.employeeDailyAttendanceId.toString() ?? '');
                          //     Navigator.of(context).push(
                          //       newSlideNavigation(EditAttendance()),
                          //     );
                          //   } else if(status == 'fine') {
                          //     Get.find<ManagerAttendanceController>().editType.value = leaveTypes[3];
                          //     Get.find<ManagerAttendanceController>().savedEditType.value = leaveTypes[3];
                          //     Get.find<ManagerAttendanceController>().fetchEmployeeAttDetail(attId: employeeData?.employeeDailyAttendanceId.toString() ?? '');
                          //     Navigator.of(context).push(
                          //       newSlideNavigation(EditAttendance()),
                          //     );
                          //   } else if(status == 'overtime') {
                          //     Get.find<ManagerAttendanceController>().editType.value = leaveTypes[4];
                          //     Get.find<ManagerAttendanceController>().savedEditType.value = leaveTypes[4];
                          //     Navigator.of(context).push(
                          //       newSlideNavigation(EditAttendance()),
                          //     );
                          //   } else if(status == 'paidleave') {
                          //     Get.find<ManagerAttendanceController>().editType.value = leaveTypes[5];
                          //     Get.find<ManagerAttendanceController>().savedEditType.value = leaveTypes[5];
                          //     Get.find<ManagerAttendanceController>().fetchEmployeeLeaveType();
                          //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditAttendance()));
                          //   } else if(status == 'offday') {
                          //     Get.find<ManagerAttendanceController>().editType.value = leaveTypes[0];
                          //     Get.find<ManagerAttendanceController>().savedEditType.value = leaveTypes[0];
                          //     Get.find<ManagerAttendanceController>().fetchEmployeeShift();
                          //     Get.find<ManagerAttendanceController>().fetchEmployeeAttDetail(attId: employeeData?.employeeDailyAttendanceId.toString() ?? '');
                          //     Navigator.of(context).push(
                          //       newSlideNavigation(EditAttendance()),
                          //     );
                          //   } else {
                          //     Get.find<ManagerAttendanceController>().editType.value = leaveTypes[0];
                          //     Get.find<ManagerAttendanceController>().savedEditType.value = leaveTypes[0];
                          //     Get.find<ManagerAttendanceController>().fetchEmployeeShift();
                          //     Get.find<ManagerAttendanceController>().fetchEmployeeAttDetail(attId: employeeData?.employeeDailyAttendanceId.toString() ?? '');
                          //     Navigator.of(context).push(
                          //       newSlideNavigation(EditAttendance()),
                          //     );
                          //   }
                          // } else {
                          //   Get.find<ManagerAttendanceController>().editType.value = leaveTypes[0];
                          //   Get.find<ManagerAttendanceController>().savedEditType.value = leaveTypes[0];
                          //   Get.find<ManagerAttendanceController>().fetchEmployeeShift();
                          //   Get.find<ManagerAttendanceController>().fetchEmployeeAttDetail(attId: employeeData?.employeeDailyAttendanceId.toString() ?? '');
                          //   Navigator.of(context).push(
                          //     newSlideNavigation(EditAttendance()),
                          //   );
                          // }
                        } else {
                          AttendanceCommonWidgets().showSnackBar(context: context, backgroundColor: Colors.deepOrangeAccent, message: "You can't edit Attendance");
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 6.h,
                          horizontal: 10.h,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFF6A4BFC),
                          borderRadius: BorderRadius.circular(20).r,
                          border: Border.all(
                            color: Color(0xFF7658FF),
                            width: 1.h,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              "assets/images/manager_view/pencil_icon.svg",
                              height: 11.h,
                            ),
                            SizedBox(width: 3.h),
                            Text(
                              "Manage ",
                              style: GoogleFonts.inter(
                                fontSize: 11.h,
                                fontWeight: FontWeight.w400,
                                color: ColorUtils.textWhite
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
