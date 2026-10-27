import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Request/request_wigets_manager/regularize_bottomSheet_manager.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../controller/locationFetchController.dart';
import '../../../../models/manager/leave_request_list_model.dart';
import '../../../../models/manager/wfh_lr_list_model.dart' as wfh_model;
import '../../../../utils/color_utils.dart';
import '../../../Excuse_Page/my_excuse_widgets/RegularizeDetail_BottomSheet.dart';
import '../../Employee_Leave/employee_leave_controller/employee_leave_controller.dart';
import '../../Employee_Leave/leave_widgets_manager/employee_leave_bottomSheet.dart';
import '../manager_request_controller/manager_request_controller.dart';

class LeaveRequestBottomSheetManager extends StatelessWidget {
  final EmployeeLeaveData? leaveData;
  const LeaveRequestBottomSheetManager({super.key, this.leaveData});

  @override
  Widget build(BuildContext context) {
    List<ApprovalData> approvalData = [];
    leaveData?.approvalData?.forEach((element) => approvalData.add(ApprovalData.fromJson(element.toJson())));
    return SafeArea(
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Container(
              // height: MediaQuery.of(context).viewInsets.bottom + 530.h,
              width: ScreenUtil().screenWidth,
              decoration: BoxDecoration(
                borderRadius:
                BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ).r,
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 15.w, left: 15.w, right: 15.w),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RegularizeTitle(
                        title: "Leave Request",
                        image: "assets/images/manager_view/employee_leave_calendar.png",
                        action: () {
                          Get.find<ManagerRequestController>().reasonController.text = '';
                          Navigator.of(context).pop();
                        },
                      ),
                      SizedBox(height: 18.h),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              _EmployeeData(leaveData),
                              SizedBox(height: 25.h),
                              _RequestType(leaveData),
                              SizedBox(height: 20.h),
                              _RequestDate(leaveData),
                              SizedBox(height: 20.h),
                              ReasonTextField(
                                  requestType: RequestType.excuse,
                                  readOnly: true,
                                  fieldText: leaveData?.leaveReason,
                                fieldController: Get.find<ManagerRequestController>().reasonController,
                              ),
                              if(leaveData?.requestStatusName.toString().toLowerCase() == 'pending')
                                SizedBox(height: 15.h),
                              if(leaveData?.leaveAttachments?.isNotEmpty ?? false)
                                SizedBox(
                                  height: 100.h,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 9).h,
                                        child: InkWell(
                                          onTap: () async {
                                            try {
                                              await launchUrl(Uri.parse(leaveData!.leaveAttachments!));
                                            } catch(e) {}
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8).h,
                                            decoration: BoxDecoration(
                                              color: ColorUtils.lavenderMist,
                                              borderRadius: BorderRadius.circular(12).r,
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl: leaveData?.leaveAttachments ?? '',
                                              errorWidget: (context, url, error) => SizedBox(
                                                width: 100,
                                                height: 100.h,
                                                child: Center(
                                                  child: Icon(Icons.error_outline, color: Colors.orange),
                                                ),
                                              ),
                                              placeholder: (context, url) => SizedBox(
                                                width: 100,
                                                height: 100.h,
                                                child: Center(
                                                  child: CircularProgressIndicator(
                                                    color: ColorUtils.textWhite,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              if(leaveData?.leaveAttachments?.isNotEmpty ?? false)
                                SizedBox(height: 15.h),
                              if(leaveData?.requestStatusName.toString().toLowerCase() == 'pending')
                                ReasonTextField(
                                requestType: RequestType.wfh,
                                readOnly: false,
                                fieldController: Get.find<ManagerRequestController>().remarksController,
                              ),
                              if(leaveData?.requestStatusName.toString().toLowerCase() == 'pending')
                                SizedBox(height: 10.h),
                              GetX<ManagerRequestController>(
                                  builder: (ManagerRequestController controller) {
                                    if(controller.showReasonValidation.value) {
                                      return Row(
                                        children: [
                                          SizedBox(width: 6.h),
                                          Flexible(
                                            child: Text(
                                              'Please add your comments before approving.',
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.dmSans(
                                                fontSize: 13.h,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    } else {
                                      return SizedBox.shrink();
                                    }
                                  }
                              ),
                              SizedBox(height: 10.h),
                              if((leaveData?.approvalData?.isNotEmpty ?? false) || leaveData?.adminData != null)
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10.h),
                                  child: HierarchyApprovalStatus(approvalData: approvalData, adminData: leaveData?.adminData),
                                ),
                              SizedBox(
                                height:
                                MediaQuery.of(context).viewInsets.bottom + 70.h,
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
          ),
          if(leaveData?.requestStatusName.toString().toLowerCase() == 'pending')
            Positioned(
              bottom: 0,
              right: 15.w,
              left: 15.w,
              child: Column(
                children: [
                  ActionButtons(
                    cancelText: "Reject",
                    okText: "Approve",
                    action: (value) async {
                      ManagerRequestController managerController = Get.find<ManagerRequestController>();
                      managerController.validateRemarksField();
                      if(managerController.remarksController.text.trim().isNotEmpty) {
                        String? result = await Get.find<ManagerRequestController>().leaveRequestUpdate(
                          action: value,
                        );
                        Navigator.of(context).pop();
                        if(result != null) {
                          AttendanceCommonWidgets().showSnackBar(
                            context: context,
                            backgroundColor: Colors.green,
                            message: result,
                          );
                        } else {
                          AttendanceCommonWidgets().showSnackBar(
                            context: context,
                            backgroundColor: Colors.red,
                            message: "Failed to submit.",
                          );
                        }
                      }
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 5.h),
                ],
              ),
            ),
          if(leaveData?.requestStatusName?.toString().toLowerCase() == 'approved')
            Positioned(
              bottom: 10.h,
              right: 15.w,
              left: 15.w,
              child: CancelActionButtons(
                cancelText: "Back",
                okText: "Cancel Leave",
                leaveId: leaveData?.employeeLeaveApplicationId ?? '',
                callBack: () {
                  Navigator.of(context).pop();
                  ManagerRequestController managerRequestController = Get.find<ManagerRequestController>();
                  managerRequestController.fetchEmployeeLeaveList(
                    monthYr: managerRequestController.monthString[managerRequestController.currentMonthIndex.value],
                  );
                },
              ),
            )
        ],
      ),
    );
  }
}

class _EmployeeData extends StatelessWidget {
  final EmployeeLeaveData? leaveData;
  const _EmployeeData(this.leaveData);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Image.asset("assets/examples/user_request.png", height: 30.h),
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
        SizedBox(width: 10.h),
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
        // SizedBox(width: 10.h),
      ],
    );
  }
}

class _RequestType extends StatelessWidget {
  final EmployeeLeaveData? leaveData;
  const _RequestType(this.leaveData);

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
    return Row(
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
            SizedBox(height: 5.h),
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
            SizedBox(height: 5.h),
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
            SizedBox(height: 5.h),
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
    );
  }
}

class _RequestDate extends StatelessWidget {
  final EmployeeLeaveData? leaveData;
  const _RequestDate(this.leaveData);

  @override
  Widget build(BuildContext context) {
    String? requestedDate;
    try {
      DateTime from = DateTime.parse(leaveData!.requestedDate!.split(" ").first);
      requestedDate = DateFormat('dd MMM yyyy | EEE').format(from);
    } catch(e) {}
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Requested Date",
              style: GoogleFonts.poppins(
                fontSize: 11.h,
                fontWeight: FontWeight.w400,
                color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              requestedDate ?? '--',
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
              leaveData?.isHourBased == '1' ? "Total hour" : "No of Days",
              style: GoogleFonts.poppins(
                fontSize: 11.h,
                fontWeight: FontWeight.w400,
                color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              leaveData?.isHourBased == '1' ? leaveData?.totalLeaveTime ?? '--' : leaveData?.totalLeaveDays ?? '--',
              style: GoogleFonts.inter(
                fontSize: 11.h,
                fontWeight: FontWeight.w500,
                color: ColorUtils.workEntryHead,
              ),
            ),
          ],
        ),
        Container(width: 1.h, height: 15.h, color: Colors.transparent),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "End Date",
              style: GoogleFonts.poppins(
                fontSize: 11.h,
                fontWeight: FontWeight.w400,
                color: Colors.transparent,
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              "05 Sep 2023",
              style: GoogleFonts.inter(
                fontSize: 11.h,
                fontWeight: FontWeight.w500,
                color: Colors.transparent,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
