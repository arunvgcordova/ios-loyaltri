

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Request/manager_request_controller/manager_request_controller.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Request/request_wigets_manager/leave_request_bottomSheet.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Request/request_wigets_manager/work_from_home_bottomSheet.dart';

import '../../../../models/manager/leave_request_list_model.dart';
import '../../../../utils/color_utils.dart';
import '../../../Login/login_widgets/custom_check_box.dart';

class LeaveRequestCard extends StatelessWidget {
  final EmployeeLeaveData? leaveData;
  const LeaveRequestCard({super.key, this.leaveData});

  @override
  Widget build(BuildContext context) {
    String? formattedFromDate;
    String? formattedToDate;
    try {
      DateTime from = DateTime.parse(leaveData!.leaveDateFrom!);
      formattedFromDate = DateFormat('dd MMM yyyy').format(from);
      DateTime to = DateTime.parse(leaveData!.leaveDateTo!);
      formattedToDate = DateFormat('dd MMM yyyy').format(to);
    } catch(e) {}
    return Padding(
      padding: EdgeInsets.only(
        bottom: 10.h,
        right: 6.h,
        left: 6.h,
      ),
      child: GestureDetector(
        onTap: () async {
          final controller = Get.find<ManagerRequestController>();

          final selectedId = leaveData?.employeeLeaveApplicationId;

          for (var element in controller.employeeLeaveList) {
            element.isSelected = element.employeeLeaveApplicationId == selectedId;
          }

          controller.employeeLeaveList.refresh();
          await showModalBottomSheet(
            backgroundColor: ColorUtils.textWhite,
            context: context,
            isScrollControlled: true,
            barrierColor: ColorUtils.workEntryHead.withValues(alpha: 0.5),
            isDismissible: false,
            useSafeArea: true,
            builder: (BuildContext context) {
              return LeaveRequestBottomSheetManager(leaveData: leaveData);
            },
          ).then((value) {
            controller.reasonController.text = '';
            controller.remarksController.text = '';
            controller.showReasonValidation.value = false;
            for (var element in controller.employeeLeaveList) {
              if(element.employeeLeaveApplicationId == selectedId) {
                element.isSelected = false;
                controller.employeeLeaveList.refresh();
                break;
              }
            }
          });
        },
        child: Container(
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
                  // Image.asset("assets/examples/user_request.png", height: 32.h),
                  AttendanceCommonWidgets().cachedNetworkImage(
                    leaveData?.profilePicture ?? '',
                    height: 28.h,
                  ),
                  SizedBox(width: 8.h),
                  Expanded(
                    child: AttendanceCommonWidgets().nameWithDesignation(
                        name: leaveData?.employeeName ?? '--',
                        designation: leaveData?.designation ?? '--',
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 2.h,
                      horizontal: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: AttendanceCommonWidgets().hexToColor(leaveData?.requestStatusColour)?.withValues(alpha: 0.1) ?? ColorUtils.textWhite,
                      borderRadius: BorderRadius.circular(100).r,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 6.h,
                          height: 6.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AttendanceCommonWidgets().hexToColor(leaveData?.requestStatusColour) ?? ColorUtils.workEntryHead,
                          ),
                        ),
                        SizedBox(width: 6.h),
                        Text(
                          leaveData?.requestStatusName ?? '--',
                          style: GoogleFonts.inter(
                            fontSize: 13.h,
                            fontWeight: FontWeight.w500,
                            color: AttendanceCommonWidgets().hexToColor(leaveData?.requestStatusColour) ?? ColorUtils.workEntryHead,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if(leaveData?.requestStatusName.toString().toLowerCase() == 'pending')
                    SizedBox(width: 10.h),
                  if(leaveData?.requestStatusName.toString().toLowerCase() == 'pending')
                    Padding(
                      padding: EdgeInsets.only(
                        right: 3.h,
                      ),
                      child: CustomCheckbox(
                        size: 17.h,
                        iconSize: 12.h,
                        borderWidth: 0.5.h,
                        borderRadius: BorderRadius.circular(5).r,
                        checkIcon: const Icon(Icons.done_rounded),
                        borderColor: leaveData?.isSelected ?? false
                            ? ColorUtils.secondaryBlue
                            : ColorUtils.silverGrey,
                        selectedColor: ColorUtils.secondaryBlue,
                        isChecked: leaveData?.isSelected ?? false,
                        onChange: (bool? value) {
                          Get.find<ManagerRequestController>().markSelectEmployee(leaveData?.employeeLeaveApplicationId ?? '');
                          // controller.selectedAllEmployee.value = value ?? false;
                        },
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Leave Type",
                          style: GoogleFonts.poppins(
                            fontSize: 11.h,
                            fontWeight: FontWeight.w400,
                            color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                          ),
                        ),
                        Text(
                          leaveData?.leaveTypeName ?? '--',
                          style: GoogleFonts.inter(
                            fontSize: 11.h,
                            fontWeight: FontWeight.w500,
                            color: ColorUtils.workEntryHead,
                          ),
                        ),
                      ],
                    ),
                    Container(width: 1.h, height: 15.h, color: ColorUtils.paleSilver),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Start Date",
                          style: GoogleFonts.poppins(
                            fontSize: 11.h,
                            fontWeight: FontWeight.w400,
                            color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                          ),
                        ),
                        Text(
                          formattedFromDate ?? '--',
                          style: GoogleFonts.inter(
                            fontSize: 11.h,
                            fontWeight: FontWeight.w500,
                            color: ColorUtils.workEntryHead,
                          ),
                        ),
                      ],
                    ),
                    Container(width: 1.h, height: 15.h, color: ColorUtils.paleSilver),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "End Date",
                          style: GoogleFonts.poppins(
                            fontSize: 11.h,
                            fontWeight: FontWeight.w400,
                            color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                          ),
                        ),
                        Text(
                          formattedToDate ?? '--',
                          style: GoogleFonts.inter(
                            fontSize: 11.h,
                            fontWeight: FontWeight.w500,
                            color: ColorUtils.workEntryHead,
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
                  vertical: 2.h,
                ),
                child: Row(
                  children: [
                    Text(
                      "Reason ",
                      style: GoogleFonts.poppins(
                        fontSize: 11.h,
                        fontWeight: FontWeight.w400,
                        color: ColorUtils.workEntryHead,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        leaveData?.leaveReason ?? '--',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 11.h,
                          fontWeight: FontWeight.w400,
                          color: ColorUtils.steelBlue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
