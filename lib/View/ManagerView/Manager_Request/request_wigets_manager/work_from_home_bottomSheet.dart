import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Request/manager_request_controller/manager_request_controller.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Request/request_wigets_manager/regularize_bottomSheet_manager.dart';

import '../../../../models/manager/wfh_lr_list_model.dart';
import '../../../../utils/color_utils.dart';

class AttendanceOption {
  final int id;
  final String label;
  final String icon;
  AttendanceOption({required this.label, required this.icon, required this.id});
}

class WorkFromHomeBottomSheetManager extends StatelessWidget {
  final WfhLrData? wfhLrData;
  const WorkFromHomeBottomSheetManager({super.key, this.wfhLrData});

  @override
  Widget build(BuildContext context) {
    final RxInt selectedOption = (wfhLrData?.specialRequestJson?.allowedPunchMethod ?? 5).obs;

    final List<AttendanceOption> attendanceOptions = [
      AttendanceOption(
        id: 5,
        label: "Mobile Punch Normal",
        icon: "assets/images/manager_view/mobile_punch_normal.png",
      ),
      // AttendanceOption(
      //   id: 0,
      //   label: "Mobile Punch Approval",
      //   icon: "assets/images/manager_view/mobile_punch_approval.png",
      // ),
      AttendanceOption(
        id: 2,
        label: "Web Punch",
        icon: "assets/images/manager_view/web_punch.png",
      ),
      AttendanceOption(
        id: 3,
        label: "Mobile Punch Selfie",
        icon: "assets/images/manager_view/mobile_punch_selfie.png",
      ),
      AttendanceOption(
        id: 1,
        label: "Punch not required",
        icon: "assets/images/manager_view/punch_not_required.png",
      ),
    ];

    String? fromDate;
    String? toDate;
    try {
      DateTime fromDateTime = DateTime.parse(wfhLrData?.fromDate ?? '');
      DateTime toDateTime = DateTime.parse(wfhLrData?.toDate ?? '');
      fromDate = DateFormat("dd/MM/yyyy").format(fromDateTime);
      toDate = DateFormat("dd/MM/yyyy").format(toDateTime);
    } catch(e) {}

    bool isPending = wfhLrData?.requestStatusName.toString().toLowerCase() == 'pending';

    return KeyboardAvoider(
      child: Container(
        width: ScreenUtil().screenWidth,
        decoration: BoxDecoration(
          color: ColorUtils.textWhite,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(30),
            topRight: const Radius.circular(30),
          ).r,
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: EdgeInsets.only(
                  left: 16.h,
                  right: 16.h,
                  top: 16.h,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.find<ManagerRequestController>().reasonController.text = '';
                        Get.find<ManagerRequestController>().remarksController.text = '';
                        Get.find<ManagerRequestController>().showReasonValidation.value = false;
                        Navigator.of(context).pop();
                      },
                      child: CircleAvatar(
                        radius: 20.r,
                        backgroundColor: const Color(0xFFF1F3F6),
                        child: Icon(
                          Icons.close,
                          color: Colors.black.withValues(alpha: 0.6),
                          size: 20.r,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.h),
                    Text(
                      "Work From Home Request",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 15.h,
                      ),
                    ),
                    SizedBox(width: 8.h),
                    CircleAvatar(
                      radius: 20.r,
                      backgroundColor: Colors.transparent,
                      child: Icon(
                        Icons.close,
                        color: Colors.transparent,
                        size: 20.r,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.h),
              Divider(color: Colors.grey.shade200, height: 1.h),
              SizedBox(height: 20.h),

              // Scrollable Content
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 16.h,
                    right: 16.h,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Employee Info
                        Row(
                          children: [
                            AttendanceCommonWidgets().cachedNetworkImage(
                              wfhLrData?.profilePicture ?? '--',
                              height: 35.h,
                            ),
                            SizedBox(width: 8.h),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    wfhLrData?.employeeName ?? '--',
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12.h,
                                      fontWeight: FontWeight.w500,
                                      color: ColorUtils.workEntryHead.withValues(alpha: 0.9),
                                    ),
                                  ),
                                  Text(
                                    wfhLrData?.employeeDesignation ?? '--',
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      fontSize: 11.h,
                                      fontWeight: FontWeight.w400,
                                      color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),

                        // Request Type
                        Text(
                          "Request Type",
                          style: GoogleFonts.poppins(
                            fontSize: 11.h,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF8C96A3),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Remote Work',
                          style: GoogleFonts.poppins(
                            fontSize: 12.h,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 20.h),

                        // From & To Dates
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "From Date",
                                    style: GoogleFonts.poppins(
                                      fontSize: 11.h,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF8C96A3),
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    fromDate ?? '--',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12.h,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "To Date",
                                    style: GoogleFonts.poppins(
                                      fontSize: 11.h,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF8C96A3),
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    toDate ?? '--',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12.h,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),

                        // Reason
                        Text(
                          "Reason",
                          style: GoogleFonts.poppins(
                            fontSize: 11.h,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF8C96A3),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          wfhLrData?.requestDescription ?? '--',
                          style: GoogleFonts.poppins(
                            fontSize: 12.h,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 20.h),

                        // Attendance Options
                        Text(
                          "Select Attendance Options",
                          style: GoogleFonts.poppins(
                            fontSize: 11.h,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF8C96A3),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Wrap(
                          spacing: 12.h,
                          runSpacing: 12.h,
                          children: List.generate(attendanceOptions.length, (index) {
                            final option = attendanceOptions[index];
                            final cardWidth = (ScreenUtil().screenWidth - 40.h - 12.h) / 2;
                            return Obx(() {
                              bool isSelected = selectedOption.value == option.id;
                              return GestureDetector(
                                onTap: () {
                                  if(isPending) {
                                    selectedOption.value = option.id;
                                  }
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      width: cardWidth,
                                      height: 54.h,
                                      padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 8.h),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10).r,
                                        border: Border.all(
                                          color: isSelected ? const Color(0xFF6366F1) : const Color(0xFFE2E8F0),
                                          width: 1.h,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 36.h,
                                            height: 36.h,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF8FAFC),
                                              borderRadius: BorderRadius.circular(8).r,
                                            ),
                                            child: Center(
                                                child: Image.asset(
                                                  option.icon,
                                                ),
                                            ),
                                          ),
                                          SizedBox(width: 8.h),
                                          Expanded(
                                            child: Text(
                                              option.label,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                fontSize: 11.h,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black.withValues(alpha: 0.8),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (isSelected)
                                      Positioned(
                                        top: 4.h,
                                        right: 4.h,
                                        child: CircleAvatar(
                                          radius: 6.r,
                                          backgroundColor: const Color(0xFF6366F1),
                                          child: Icon(
                                            Icons.check,
                                            size: 8.r,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            });
                          }),
                        ),
                        SizedBox(height: 20.h),

                        // Comment / Remarks Input
                        if (isPending) ...[
                          Obx(() {
                            final controller = Get.find<ManagerRequestController>();
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Comment",
                                  style: GoogleFonts.poppins(
                                    fontSize: 11.h,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF8C96A3),
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 8.h),
                                  decoration: BoxDecoration(
                                    color: ColorUtils.textWhite,
                                    borderRadius: BorderRadius.circular(8).r,
                                    border: Border.all(
                                      color: controller.showReasonValidation.value
                                          ? Colors.red
                                          : const Color(0xFFE2E8F0),
                                      width: 1.h,
                                    ),
                                  ),
                                  child: TextField(
                                    controller: controller.remarksController,
                                    onChanged: (value) {
                                      if (controller.showReasonValidation.value) {
                                        controller.validateRemarksField();
                                      }
                                    },
                                    maxLines: 4,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13.h,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Type here..",
                                      hintStyle: GoogleFonts.poppins(
                                        fontSize: 13.h,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xFFB2BAC6),
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                ),
                                if (controller.showReasonValidation.value) ...[
                                  SizedBox(height: 6.h),
                                  Text(
                                    'Please add your comments before approving.',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12.h,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ],
                            );
                          }),
                          SizedBox(height: 20.h),
                        ],

                        if (!isPending) ...[
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.h),
                            child: HierarchyApprovalStatus(
                              approvalData: wfhLrData?.approvalData ?? [],
                              mainStatus: wfhLrData?.mainStatus,
                              adminData: wfhLrData?.adminData,
                            ),
                          ),
                          SizedBox(height: 20.h),
                        ],
                      ],
                    ),
                  ),
                ),
              ),

              // Footer Action Buttons
              if (isPending) ...[
                Divider(color: Colors.grey.shade200, height: 1.h),
                SizedBox(height: 15.h),
                _CustomActionButtons(
                  cancelText: "Reject",
                  okText: "Approve",
                  action: (value) async {
                    ManagerRequestController managerController = Get.find<ManagerRequestController>();
                    managerController.validateRemarksField();
                    if (managerController.remarksController.text.trim().isNotEmpty) {
                      String? result = await managerController.submitWfhLrRequestUpdate(
                        action: value,
                        attOption: selectedOption.value
                      );
                      Navigator.of(context).pop();
                      if (result != null) {
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
                SizedBox(height: 8.h),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomActionButtons extends StatelessWidget {
  final String cancelText;
  final String okText;
  final Function(bool) action;
  const _CustomActionButtons({
    required this.cancelText,
    required this.okText,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ManagerRequestController>();
    return Padding(
      padding: EdgeInsets.only(
        left: 16.h,
        right: 16.h,
      ),
      child: Row(
        children: [
          Expanded(
            child: Obx(() {
              bool isLoading = controller.rejectLoading.value;
              return GestureDetector(
                onTap: () {
                  if (!controller.approveLoading.value && !controller.rejectLoading.value) {
                    action.call(false);
                  }
                },
                child: Container(
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDC2626),
                    borderRadius: BorderRadius.circular(10).r,
                  ),
                  child: Center(
                    child: isLoading
                        ? SizedBox(
                            width: 20.h,
                            height: 20.h,
                            child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : Text(
                            cancelText,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 14.h,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              );
            }),
          ),
          SizedBox(width: 12.h),
          Expanded(
            child: Obx(() {
              bool isLoading = controller.approveLoading.value;
              return GestureDetector(
                onTap: () {
                  if (!controller.approveLoading.value && !controller.rejectLoading.value) {
                    action.call(true);
                  }
                },
                child: Container(
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1),
                    borderRadius: BorderRadius.circular(10).r,
                  ),
                  child: Center(
                    child: isLoading
                        ? SizedBox(
                            width: 20.h,
                            height: 20.h,
                            child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : Text(
                            okText,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 14.h,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
