import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Request/manager_request_controller/manager_request_controller.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Request/request_wigets_manager/punch_approval_bottomSheet.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Request/request_wigets_manager/regularize_bottomSheet_manager.dart';

import '../../../../models/manager/punch_approval_list_model.dart';
import '../../../../utils/color_utils.dart';
import '../../../Login/login_widgets/custom_check_box.dart';

class PunchApprovalDayCard extends StatelessWidget {
  final PunchApprovalData approvalData;
  const PunchApprovalDayCard({super.key, required this.approvalData});

  @override
  Widget build(BuildContext context) {
    String date = '--';
    try {
      date = DateFormat('MMM dd, yyyy').format(DateTime.parse(approvalData.date!));
    } catch(e) {}
    return Column(
      children: [
        SizedBox(height: 8.h),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.h),
          child: Row(
            children: [
              Text(
                date,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 13.h,
                  fontWeight: FontWeight.w500,
                  color: ColorUtils.workEntryHead,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 4.h),
        Column(
          children: [
            for(int i = 0; i < (approvalData.employees?.length ?? 0); i++)
              PunchApprovalRequestCard(employeesApproval: approvalData.employees?[i]),
          ],
        ),
      ],
    );
  }
}

class PunchApprovalRequestCard extends StatelessWidget {
  final EmployeesApproval? employeesApproval;
  const PunchApprovalRequestCard({super.key, this.employeesApproval});

  @override
  Widget build(BuildContext context) {
    ManagerRequestController managerRequestController = Get.find<ManagerRequestController>();
    return Padding(
      padding: EdgeInsets.only(
        bottom: 14.h,
        right: 6.h,
        left: 6.h,
      ),
      child: GestureDetector(
        onTap: () async {
          await showModalBottomSheet(
            backgroundColor: ColorUtils.textWhite,
            context: context,
            isScrollControlled: true,
            barrierColor: ColorUtils.workEntryHead.withValues(alpha: 0.5),
            // constraints: BoxConstraints(
            //   maxHeight: ScreenUtil().screenHeight * 0.6,
            // ),
            builder: (BuildContext context) {
              employeesApproval?.isSelected = true;
              return PunchApprovalBottomSheetManager(employeesApproval: employeesApproval);
            },
          ).then((value) {
            employeesApproval?.isSelected = false;
            Get.find<ManagerRequestController>().reasonController.text = '';
            Get.find<ManagerRequestController>().remarksController.text = '';
            Get.find<ManagerRequestController>().showReasonValidation.value = false;
          });
        },
        child: Container(
          padding: EdgeInsets.all(6).h,
          decoration: BoxDecoration(
            color: ColorUtils.textWhite,
            borderRadius: BorderRadius.circular(14).r,
            border: Border.all(
              color: employeesApproval?.isSelected ?? false
                  ? Color(0xFFC4B8FF)
                  : ColorUtils.workEntryHead.withValues(alpha: 0.1),
              width: 1.h,
            ),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AttendanceCommonWidgets().cachedNetworkImage(
                      employeesApproval?.profilePicture ?? '',
                  ),
                  // Image.asset("assets/examples/user_request.png", height: 32.h),
                  SizedBox(width: 8.h),
                  Expanded(
                    child: AttendanceCommonWidgets().nameWithDesignation(
                        name: employeesApproval?.employeeName ?? '--',
                      designation:employeesApproval?.designation?? "--",
                    ),
                  ),
                  if(managerRequestController.filters.value[managerRequestController.currentTabIndex.value].filter == RequestFilterTypes.pending)
                    CustomCheckbox(
                      size: 17.h,
                      iconSize: 12.h,
                      borderWidth: 0.5.h,
                      borderRadius: BorderRadius.circular(5).r,
                      checkIcon: const Icon(Icons.done_rounded),
                      borderColor: employeesApproval?.isSelected ?? false
                          ? ColorUtils.secondaryBlue
                          : ColorUtils.silverGrey,
                      selectedColor: ColorUtils.secondaryBlue,
                      isChecked: employeesApproval?.isSelected ?? false,
                      onChange: (bool? value) {
                        Get.find<ManagerRequestController>().markSelectEmployee(employeesApproval?.employeeDailyAttendanceId ?? '');
                      },
                    ),
                ],
              ),
              Divider(color: ColorUtils.softGrey),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      AttendanceCommonWidgets().cachedNetworkImageSquare(
                          employeesApproval?.punchInImage ?? '',
                      ),
                      // Container(
                      //   decoration: BoxDecoration(
                      //     color: ColorUtils.whisperGrey,
                      //     borderRadius: BorderRadius.circular(4).r,
                      //     border: Border.all(
                      //       color: ColorUtils.lightSilver,
                      //       width: 1.h,
                      //     ),
                      //   ),
                      //   child: Image.asset(
                      //     "assets/examples/user_request_sqare.png",
                      //     height: 30.h,
                      //   ),
                      // ),
                      SizedBox(width: 8.h),
                      AttendanceCommonWidgets().checkInTime(
                        employeesApproval?.firstCheckInTime ?? '--',
                      ),
                    ],
                  ),
                  Container(width: 1.h, height: 15.h, color: ColorUtils.paleSilver),
                  Row(
                    children: [
                      AttendanceCommonWidgets().cachedNetworkImageSquare(
                        employeesApproval?.punchOutImage ?? '',
                      ),
                      SizedBox(width: 8.h),
                      AttendanceCommonWidgets().checkOutTimeStart(
                        employeesApproval?.lastCheckOutTime ?? '--',
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/manager_view/regularize_time.png",
                        height: 15.h,
                      ),
                      SizedBox(width: 8.h),
                      Text(
                        "Worked Hrs: ",
                        style: GoogleFonts.poppins(
                          fontSize: 11.h,
                          fontWeight: FontWeight.w400,
                          color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                        ),
                      ),
                      Text(
                        employeesApproval?.totalWorkHours ?? '--',
                        style: GoogleFonts.poppins(
                          fontSize: 11.h,
                          fontWeight: FontWeight.w600,
                          color: ColorUtils.workEntryHead,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 8.h),
                  Expanded(
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/images/location-att-details.svg",
                          height: 15.h,
                        ),
                        SizedBox(width: 5.h),
                        Expanded(
                          child: Text(
                            employeesApproval?.punchOutRemarks ?? employeesApproval?.punchInRemarks ?? employeesApproval?.punchRemarks ?? '--',
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 11.h,
                              fontWeight: FontWeight.w400,
                              color: ColorUtils.workEntryHead,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }
}
