
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/ManagerView/Employee_Leave/employee_leave_controller/employee_leave_controller.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Request/manager_request_controller/manager_request_controller.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Request/request_wigets_manager/regularize_bottomSheet_manager.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../controller/userAuthentication.dart';
import '../../../../models/manager/wfh_lr_list_model.dart' as wfh_model;
import '../../../../models/manager/leave_request_list_model.dart';
import '../../../../utils/color_utils.dart';
import '../../Manager_Attendance/attendance_widgets_manager/common_widgets.dart';

class EmployeeLeaveBottomSheetManager extends StatelessWidget {
  final bool isCancelLeave;
  final EmployeeLeaveData? leaveData;
  final List<ApprovalData> approvalData;
  final ApprovalData? manager;
  const EmployeeLeaveBottomSheetManager({super.key, required this.isCancelLeave, this.leaveData, required this.approvalData, this.manager});

  @override
  Widget build(BuildContext context) {
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
                      EmployeeLeaveTitle(title: "Leave Request", image: "assets/images/manager_view/employee_leave_calendar.png"),
                      SizedBox(height: 18.h),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              _EmployeeData(leaveData),
                              SizedBox(height: 18.h),
                              _LeaveType(leaveData),
                              SizedBox(height: 15.h),
                              ReasonTextField(
                                  requestType: RequestType.excuse,
                                  readOnly: true,
                                  fieldText: leaveData?.leaveReason,
                                fieldController: Get.find<ManagerRequestController>().reasonController,
                              ),
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
                              if((leaveData?.approvalData?.isNotEmpty ?? false) || leaveData?.adminData != null)
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10.h),
                                  child: HierarchyApprovalStatus(
                                      approvalData: approvalData,
                                    adminData: leaveData?.adminData,
                                    mainStatus: leaveData?.mainStatus,
                                  ),
                                ),
                              SizedBox(
                                height:
                                MediaQuery.of(context).viewInsets.bottom + (((leaveData?.requestStatusName?.toString().toLowerCase() == 'pending' || leaveData?.requestStatusName?.toString().toLowerCase() == 'approved') && (manager?.status?.toString().trim().toLowerCase() == 'pending' || manager == null)) ? 70.h : 20.h),
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
          if((leaveData?.requestStatusName?.toString().toLowerCase() == 'pending' || leaveData?.requestStatusName?.toString().toLowerCase() == 'approved') && (manager?.status?.toString().trim().toLowerCase() == 'pending' || manager == null))
            Positioned(
              bottom: 0,
              right: 15.w,
              left: 15.w,
              child: Column(
                children: [
                  if(leaveData?.requestStatusName?.toString().toLowerCase() == 'approved')
                    CancelActionButtons(
                      cancelText: "Back",
                      okText: "Cancel Leave",
                      leaveId: leaveData?.employeeLeaveApplicationId ?? '',
                      callBack: () {
                        Navigator.of(context).pop();
                        EmployeeLeaveController employeeLeaveController = Get.find<EmployeeLeaveController>();
                        employeeLeaveController.fetchEmployeeLeaveList();
                      },
                    )
                  else
                    ActionButtons(
                      cancelText: "Reject",
                      okText: "Approve",
                      action: (value) async {
                        ManagerRequestController managerController = Get.find<ManagerRequestController>();
                        managerController.validateRemarksField();
                        if(managerController.remarksController.text.trim().isNotEmpty) {
                          Get.find<ManagerRequestController>().currentTabIndex.value = 5;
                          Get.find<ManagerRequestController>().employeeLeaveList.value = Get.find<EmployeeLeaveController>().employeePendingLeaveList.value;
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
    String? requestDate;
    try {
      DateTime requested = DateTime.parse(leaveData?.requestedDate?.split(' ').first ?? '');
      requestDate = DateFormat('dd MMM yyyy | EEE').format(requested);
    } catch(e) {}
    return Row(
      children: [
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "Requested on",
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 11.h,
                fontWeight: FontWeight.w400,
                color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
              ),
            ),
            Text(
              requestDate ?? '--',
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 11.h,
                fontWeight: FontWeight.w400,
                color: ColorUtils.workEntryHead,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _LeaveType extends StatelessWidget {
  final EmployeeLeaveData? leaveData;
  const _LeaveType(this.leaveData);

  @override
  Widget build(BuildContext context) {
    String? startDate;
    String? endDate;
    int totalLeaveHour = 0;
    try {
      DateTime from = DateTime.parse(leaveData?.leaveDateFrom ?? '');
      startDate = DateFormat('MMM dd').format(from);
      DateTime to = DateTime.parse(leaveData?.leaveDateTo ?? '');
      endDate = DateFormat('MMM dd').format(to);
      totalLeaveHour = int.tryParse(leaveData?.totalLeaveTime ?? '0') ?? 0;
    } catch(e) {}
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: ScreenUtil().screenWidth > 700 ? ScreenUtil().screenWidth * 0.3 : ScreenUtil().screenWidth * 0.4,
          child: Column(
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
                leaveData?.leaveTypeName ?? '--',
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 11.h,
                  fontWeight: FontWeight.w500,
                  color: ColorUtils.workEntryHead.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ),
        Container(width: 1.h, height: 15.h, color: ColorUtils.paleSilver),
        SizedBox(
          width: ScreenUtil().screenWidth > 700 ? ScreenUtil().screenWidth * 0.3 : ScreenUtil().screenWidth * 0.4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
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
                leaveData?.isHourBased == '1' ? "$startDate - ${leaveData?.totalLeaveTime ?? '--'} ${totalLeaveHour > 1 ? 'hours' : 'hour'}" : "$startDate - $endDate (${leaveData?.totalLeaveDays} days)",
                overflow: TextOverflow.ellipsis,
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
    );
  }
}

class EmployeeLeaveTitle extends StatelessWidget {
  final String title;
  final String image;
  const EmployeeLeaveTitle({super.key, required this.title, required this.image});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: 48.h, height: 48.h),
        const Spacer(),
        Image.asset(image, width: 30.h),
        SizedBox(width: 3.h),
        Text(
          title,
          style: GoogleFonts.poppins(
            color: ColorUtils.workEntryHead,
            fontWeight: FontWeight.w500,
            fontSize: 15.h,
          ),
        ),
        SizedBox(width: 15.h),
        const Spacer(),
        GestureDetector(
          onTap: () async {
            Navigator.of(context).pop();
          },
          child: Container(
            padding: EdgeInsets.all(1).h,
            decoration: BoxDecoration(
              color: ColorUtils.charcoalBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14).r,
            ),
            child: Container(
              height: 47.h,
              width: 47.h,
              decoration: BoxDecoration(
                color: ColorUtils.textWhite,
                borderRadius: BorderRadius.circular(13).r,
                // border: Border.all(
                //   width: 1.h,
                //   color: ColorUtils.charcoalBlue.withValues(alpha: 0.1),
                // ),
              ),
              child: Center(
                child: Icon(
                  Icons.close,
                  size: 18.h,
                  color: ColorUtils.workEntryHead,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CancelActionButtons extends StatelessWidget {
  final String cancelText;
  final String okText;
  final String leaveId;
  final Function? callBack;
  const CancelActionButtons({super.key,
    required this.cancelText,
    required this.okText,
    required this.leaveId, this.callBack,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(37).r,
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              height: 50.h,
              decoration: BoxDecoration(
                color: ColorUtils.resendSMS,
                borderRadius: BorderRadius.circular(37).r,
              ),
              child: Center(
                child: Text(
                  cancelText,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 15.h,
                    color: ColorUtils.textWhite,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 15.w),
        Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(37).r,
            onTap: () async {
              await showModalBottomSheet(
                backgroundColor: ColorUtils.textWhite,
                context: context,
                isScrollControlled: true,
                isDismissible: false,
                barrierColor: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                // constraints: BoxConstraints(
                //   maxHeight: ScreenUtil().screenHeight * 0.8,
                // ),
                builder: (BuildContext context) {
                  return CancelLeaveBottomSheetManager(leaveId: leaveId, callBack: () => callBack?.call());
                },
              ).then((value) {
                Get.find<EmployeeLeaveController>().cancellingReason.value.clear();
                Get.find<EmployeeLeaveController>().showReasonTextValidation.value = false;
              });
            },
            child: Container(
              height: 50.h,
              decoration: BoxDecoration(
                color: ColorUtils.crimsonBlaze,
                borderRadius: BorderRadius.circular(37).r,
              ),
              child: Center(
                child: Text(
                  okText,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 15.h,
                    color: ColorUtils.textWhite,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CancelReasonTextField extends StatelessWidget {
  const _CancelReasonTextField();

  @override
  Widget build(BuildContext context) {
    return GetX<EmployeeLeaveController>(
      builder: (EmployeeLeaveController controller) {
        return Container(
          padding: const EdgeInsets.all(1).h,
          decoration: BoxDecoration(
            color: controller.showReasonTextValidation.value ? Colors.red : ColorUtils.workEntryHead.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(15).r,
            // border: textFieldBoarder(requestType),
          ),
          child: Container(
            // height: 185.h,
            // width: ScreenUtil().screenWidth * 0.9,
            padding: const EdgeInsets.all(15).h,
            decoration: BoxDecoration(
              color: ColorUtils.softPearl,
              borderRadius: BorderRadius.circular(15).r,
              // border: textFieldBoarder(requestType),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Reason for cancellation",
                  style: GoogleFonts.inter(
                    color: controller.showReasonTextValidation.value ? Colors.red : ColorUtils.workEntryHead,
                    fontWeight: FontWeight.w400,
                    fontSize: 13.h,
                  ),
                ),
                TextField(
                  // controller: reasonController,
                  // focusNode: reasonFocusNode,
                  // readOnly: hideButton,
                  controller: controller.cancellingReason.value,
                  onChanged: (value) {
                    controller.showReasonTextValidation.value = false;
                  },
                  style: GoogleFonts.inter(
                    color: ColorUtils.workEntryHead,
                    fontWeight: FontWeight.w400,
                    fontSize: 11.h,
                  ),
                  decoration: InputDecoration(
                    hintText: "",
                    contentPadding: const EdgeInsets.all(0),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    hintStyle: GoogleFonts.inter(
                      color: ColorUtils.workEntryHead,
                      fontWeight: FontWeight.w400,
                      fontSize: 11.h,
                    ),
                  ),
                  maxLines: 5,
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}


class CancelLeaveBottomSheetManager extends StatelessWidget {
  final String leaveId;
  final Function? callBack;
  const CancelLeaveBottomSheetManager({super.key, required this.leaveId, this.callBack});

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                    EmployeeLeaveTitle(title: "Cancel Leave Request", image: "assets/images/manager_view/employee_leave_calendar.png"),
                    SizedBox(height: 5.h),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.h,
                              ),
                              child: Text(
                                "Are you sure you want to cancel the leave request? This action cannot be undone.",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 11.h,
                                ),
                              ),
                            ),
                            SizedBox(height: 30.h),
                            _CancelReasonTextField(),
                            SizedBox(height: 15.h),
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
        Positioned(
          bottom: 5.h,
          right: 15.w,
          left: 15.w,
          child: Column(
            children: [
              _ActionButtons(
                cancelText: "No",
                okText: "Yes",
                leaveId: leaveId,
                callBack: () {
                  Navigator.of(context).pop();
                  callBack?.call();
                },
              ),
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 5.h),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final String cancelText;
  final String okText;
  final String leaveId;
  final Function? callBack;
  const _ActionButtons({
    required this.cancelText,
    required this.okText,
    required this.leaveId, this.callBack,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              height: 50.h,
              decoration: BoxDecoration(
                color: ColorUtils.fieryRed,
                borderRadius: BorderRadius.circular(37).r,
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.close, color: ColorUtils.textWhite, size: 18.h),
                    SizedBox(width: 3.h),
                    Text(
                      cancelText,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 15.h,
                        color: ColorUtils.textWhite,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 15.w),
        Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(37).r,
            onTap: () {
              if(Get.find<EmployeeLeaveController>().cancellingReason.value.text.trim().isEmpty) {
                Get.find<EmployeeLeaveController>().showReasonTextValidation.value = true;
              } else {
                cancelSuccessPopUp(
                    context: context,
                    title: "Cancel Leave Request",
                    subTitle: "Are you sure you want to cancel the leave request? This action cannot be undone.",
                    leaveId: leaveId,
                    callBack: () {
                      callBack?.call();
                    }
                );
              }
            },
            child: Container(
              height: 50.h,
              decoration: BoxDecoration(
                color: ColorUtils.secondaryBlue,
                borderRadius: BorderRadius.circular(37).r,
              ),
              child: Center(
                child: Text(
                  okText,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 15.h,
                    color: ColorUtils.textWhite,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<bool?> cancelSuccessPopUp({
    required BuildContext context,
    String? title,
    String? subTitle,
    required String leaveId,
    Function? callBack,
  }) async {
    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: false,
      barrierColor: ColorUtils.workEntryHead.withValues(alpha: 0.5),
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: PopScope(
            canPop: true,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(1).h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(29.0).r,
                      color: ColorUtils.charcoalBlue.withValues(alpha: 0.1),
                    ),
                    child: Container(
                      width: 300.h,
                      height: 238.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28.0).r,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFE4DFFF),
                            ColorUtils.textWhite,
                            ColorUtils.textWhite,
                            ColorUtils.textWhite,
                            ColorUtils.textWhite,
                          ],
                        ),
                      ),
                      child: AlertDialog(
                        backgroundColor: Colors.transparent,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10.h,
                          horizontal: 10.h,
                        ),
                        insetPadding: EdgeInsets.all(0),
                        content: Column(
                          children: [
                            SizedBox(height: 15.h),
                            Image.asset(
                              "assets/images/manager_view/cancel_leave_warn.png",
                              // width: 10.w,
                              height: 50.h,
                              fit: BoxFit.fitHeight,
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              title ?? "",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 15.h,
                                color: ColorUtils.workEntryHead,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              subTitle ?? "",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 11.h,
                                color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                              ),
                            ),
                            Spacer(),
                            Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(37).r,
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      height: 40.h,
                                      decoration: BoxDecoration(
                                        color: ColorUtils.fieryRed,
                                        borderRadius: BorderRadius.circular(37).r,
                                      ),
                                      child: Center(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.close, color: ColorUtils.textWhite, size: 16.h),
                                            SizedBox(width: 3.h),
                                            Text(
                                              cancelText,
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12.h,
                                                color: ColorUtils.textWhite,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15.h),
                                Expanded(
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(37).r,
                                    onTap: () async {
                                      EmployeeLeaveController employeeLeaveController = Get.find<EmployeeLeaveController>();
                                      await employeeLeaveController.cancelLeaveReq(leaveId: leaveId, context: context);
                                      Navigator.of(context).pop();
                                      callBack?.call();
                                    },
                                    child: Container(
                                      height: 40.h,
                                      decoration: BoxDecoration(
                                        color: ColorUtils.secondaryBlue,
                                        borderRadius: BorderRadius.circular(37).r,
                                      ),
                                      child: Center(
                                        child: GetX<EmployeeLeaveController>(
                                          builder: (EmployeeLeaveController controller) {
                                            if(controller.leaveCancelling.value) {
                                              return SizedBox(
                                                width: 15.h,
                                                height: 15.h,
                                                child: CircularProgressIndicator(color: Colors.white),
                                              );
                                            } else {
                                              return Text(
                                                okText,
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12.h,
                                                  color: ColorUtils.textWhite,
                                                ),
                                              );
                                            }
                                          }
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}


