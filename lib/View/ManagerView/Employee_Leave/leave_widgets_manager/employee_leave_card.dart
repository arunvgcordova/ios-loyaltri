
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/ManagerView/Employee_Leave/employee_leave_controller/employee_leave_controller.dart';
import 'package:loyaltri_minimal/View/ManagerView/Employee_Leave/leave_widgets_manager/employee_leave_bottomSheet.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';

import '../../../../controller/userAuthentication.dart';
import '../../../../models/manager/leave_request_list_model.dart';
import '../../../../models/manager/wfh_lr_list_model.dart' as wfh_model;
import '../../../../utils/color_utils.dart';
import '../../../Login/login_widgets/custom_check_box.dart';
import '../../Manager_Request/manager_request_controller/manager_request_controller.dart';
import '../../Manager_Request/request_wigets_manager/leave_request_bottomSheet.dart';

class EmployeeLeaveCard extends StatelessWidget {
  final EmployeeLeaveData employeeLeaveData;
  const EmployeeLeaveCard({super.key, required this.employeeLeaveData});

  @override
  Widget build(BuildContext context) {
    String? startDate;
    String? endDate;
    String? requestDate;
    String employeeId = Get.find<UserAuthController>().userData.value.userData?.employeeId ?? '';
    List<ApprovalData> approvalData = [];
    employeeLeaveData.approvalData?.forEach((element) => approvalData.add(ApprovalData.fromJson(element.toJson())));
    ApprovalData? manager = approvalData
        .cast<ApprovalData?>()
        .firstWhere(
          (e) => e?.employeeId == employeeId,
      orElse: () => null,
    );
    try {
      DateTime from = DateTime.parse(employeeLeaveData.leaveDateFrom ?? '');
      startDate = DateFormat('MMM dd').format(from);
      DateTime to = DateTime.parse(employeeLeaveData.leaveDateTo ?? '');
      endDate = DateFormat('MMM dd').format(to);
      DateTime requested = DateTime.parse(employeeLeaveData.requestedDate?.split(' ').first ?? '');
      requestDate = DateFormat('MMM dd, yyyy').format(requested);
    } catch(e) {}
    return Padding(
      padding: EdgeInsets.only(
        bottom: 10.h,
      ),
      child: GestureDetector(
        onTap: () async {
          if(employeeLeaveData.requestStatusName.toString().toLowerCase() == 'pending') {
            employeeLeaveData.isSelected = true;
            Get.find<ManagerRequestController>().employeeLeaveList.value = [employeeLeaveData];
          }
          await showModalBottomSheet(
          backgroundColor: ColorUtils.textWhite,
          context: context,
          isScrollControlled: true,
          barrierColor: ColorUtils.workEntryHead.withValues(alpha: 0.5),
          isDismissible: false,
          useSafeArea: true,
          // constraints: BoxConstraints(
          //   maxHeight: ScreenUtil().screenHeight * 0.8,
          // ),
          builder: (BuildContext context) {
            return EmployeeLeaveBottomSheetManager(leaveData: employeeLeaveData, manager: manager, approvalData: approvalData, isCancelLeave: false);
          },
          ).then((value) {
            employeeLeaveData.isSelected = false;
            Get.find<ManagerRequestController>().reasonController.text = '';
            Get.find<ManagerRequestController>().remarksController.text = '';
            Get.find<ManagerRequestController>().showReasonValidation.value = false;
          });
          // showModalBottomSheet(
          //   backgroundColor: ColorUtils.textWhite,
          //   context: context,
          //   isScrollControlled: true,
          //   barrierColor: ColorUtils.workEntryHead.withValues(alpha: 0.5),
          //   // constraints: BoxConstraints(
          //   //   maxHeight: ScreenUtil().screenHeight * 0.8,
          //   // ),
          //   builder: (BuildContext context) {
          //     return EmployeeLeaveBottomSheetManager(isCancelLeave: index == 1);
          //   },
          // );
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 6.h,
            horizontal: 10.h,
          ),
          decoration: BoxDecoration(
            color: ColorUtils.textWhite,
            borderRadius: BorderRadius.circular(8).r,
            border: Border.all(
              color: ColorUtils.workEntryHead.withValues(alpha: 0.15),
              width: 1.h,
            ),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image.asset("assets/examples/user_request.png", height: 32.h),
                  AttendanceCommonWidgets().cachedNetworkImage(
                    employeeLeaveData.profilePicture ?? '',
                  ),
                  SizedBox(width: 8.h),
                  Expanded(
                    child: AttendanceCommonWidgets().nameWithDesignation(
                        name: employeeLeaveData.employeeName ?? '--',
                        designation: employeeLeaveData.designation ?? '--',
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 2.h,
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 2.h,
                        horizontal: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: AttendanceCommonWidgets().hexToColor(employeeLeaveData.requestStatusColour)?.withValues(alpha: 0.1) ?? ColorUtils.textWhite,
                        borderRadius: BorderRadius.circular(100).r,
                      ),
                      child: Text(
                        employeeLeaveData.requestStatusName ?? '--',
                        style: GoogleFonts.inter(
                          fontSize: 11.h,
                          fontWeight: FontWeight.w500,
                          color: AttendanceCommonWidgets().hexToColor(employeeLeaveData.requestStatusColour) ?? ColorUtils.workEntryHead,
                        ),
                      ),
                    ),
                  ),
                  if(employeeLeaveData.requestStatusName?.toString().toLowerCase() == 'pending' && (manager?.status?.toString().trim().toLowerCase() == 'pending' || manager == null))
                    SizedBox(width: 10.h),
                  if(employeeLeaveData.requestStatusName?.toString().toLowerCase() == 'pending' && (manager?.status?.toString().trim().toLowerCase() == 'pending' || manager == null))
                    Padding(
                      padding: EdgeInsets.only(
                        top: 2.h,
                      ),
                      child: CustomCheckbox(
                        size: 17.h,
                        iconSize: 12.h,
                        borderWidth: 0.5.h,
                        borderRadius: BorderRadius.circular(5).r,
                        checkIcon: const Icon(Icons.done_rounded),
                        borderColor: (employeeLeaveData.isSelected ?? false)
                            ? ColorUtils.secondaryBlue
                            : ColorUtils.silverGrey,
                        selectedColor: ColorUtils.secondaryBlue,
                        isChecked: employeeLeaveData.isSelected ?? false,
                        onChange: (bool? value) {
                          employeeLeaveData.isSelected = !(employeeLeaveData.isSelected ?? true);
                          Get.find<EmployeeLeaveController>().employeeAllLeaveList.refresh();
                          Get.find<EmployeeLeaveController>().employeePendingLeaveList.refresh();
                        },
                      ),
                    ),
                ],
              ),
              Divider(color: ColorUtils.softGrey, thickness: 1.h, height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Leave type",
                        style: GoogleFonts.poppins(
                          fontSize: 11.h,
                          fontWeight: FontWeight.w400,
                          color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                        ),
                      ),
                      Text(
                        employeeLeaveData.leaveTypeName ?? '--',
                        style: GoogleFonts.poppins(
                          fontSize: 11.h,
                          fontWeight: FontWeight.w500,
                          color: ColorUtils.workEntryHead.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                  Container(width: 1.h, height: 15.h, color: ColorUtils.paleSilver),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Leave Days",
                        style: GoogleFonts.poppins(
                          fontSize: 11.h,
                          fontWeight: FontWeight.w400,
                          color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                        ),
                      ),
                      Text(
                        "$startDate - $endDate",
                        style: GoogleFonts.poppins(
                          fontSize: 11.h,
                          fontWeight: FontWeight.w500,
                          color: ColorUtils.workEntryHead.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                  Container(width: 1.h, height: 15.h, color: ColorUtils.paleSilver),
                  Padding(
                    padding: EdgeInsets.only(right: 5.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Requested on",
                          style: GoogleFonts.poppins(
                            fontSize: 11.h,
                            fontWeight: FontWeight.w400,
                            color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                          ),
                        ),
                        Text(
                          requestDate ?? '--',
                          style: GoogleFonts.poppins(
                            fontSize: 11.h,
                            fontWeight: FontWeight.w500,
                            color: ColorUtils.workEntryHead.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color selectTextColor(String type) {
    switch(type) {
      case "pending": return ColorUtils.burntOrange;
      case "approved": return ColorUtils.royalPurple;
      case "rejected": return ColorUtils.crimsonRed;
      default: return ColorUtils.workEntryHead;
    }
  }

  Color selectBgColor(String type) {
    switch(type) {
      case "pending": return ColorUtils.creamyPeach;
      case "approved": return ColorUtils.lavenderWhisper;
      case "rejected": return ColorUtils.roseMist;
      default: return ColorUtils.workEntryHead;
    }
  }
}
