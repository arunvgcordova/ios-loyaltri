
import 'dart:ui' as ui;
import 'dart:math' as math;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/controller/userAuthentication.dart';
import '../../../../controller/locationFetchController.dart';
import '../../../../models/leave_list_api_model.dart';
import '../../../../models/manager/employee_excuseList_model.dart';
import '../../../../models/manager/leave_request_list_model.dart';
import '../../../../models/manager/wfh_lr_list_model.dart';
import '../../../../utils/color_utils.dart';
import '../../../CWidgets/cwidgets.dart';
import '../../../Excuse_Page/my_excuse_widgets/RegularizeDetail_BottomSheet.dart';
import '../manager_request_controller/manager_request_controller.dart';

class RegularizationBottomSheetManager extends StatelessWidget {
  final Employees? employee;
  const RegularizationBottomSheetManager({
    super.key,
    this.employee,
  });

  @override
  Widget build(BuildContext context) {
    ManagerRequestController managerRequestController = Get.find<ManagerRequestController>();
    return SafeArea(
      child: GestureDetector(
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
                    title: "Regularize",
                    image: "assets/images/Hourglass-3d.webp",
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
                          _EmployeeData(),
                          SizedBox(height: 25.h),
                          _RequestType(),
                          SizedBox(height: 20.h),
                          _WorkTimeWidget(employee),
                          SizedBox(height: 20.h),
                          // if (isMissPunch)
                          if(Get.find<ManagerRequestController>().deductionData.value?.punctualityBreachCount != null && !Get.find<UserAuthController>().restrictRsInfo.value)
                            _MissPunchDeductionAmount(),
                          // else
                          if(Get.find<ManagerRequestController>().deductionData.value?.punctualityBreachCount != null)
                            SizedBox(height: 20.h),
                          // if (isMissPunch)
                          // else
                          //   SizedBox(height: 30.h),
                          if(Get.find<ManagerRequestController>().currentTabIndex.value != 2)
                            Obx(() {
                              return ReasonTextField(
                                requestType: RequestType.excuse,
                                readOnly: true,
                                fieldText: Get.find<ManagerRequestController>().deductionData.value?.excuseReason ?? '',
                                fieldController: Get.find<ManagerRequestController>().reasonController,
                              );
                            }
                            ),
                          if(managerRequestController.filters.value[managerRequestController.currentTabIndex.value].filter == RequestFilterTypes.pending)
                            SizedBox(height: 15.h),
                          if(managerRequestController.filters.value[managerRequestController.currentTabIndex.value].filter == RequestFilterTypes.pending)
                            ReasonTextField(
                            requestType: RequestType.wfh,
                            readOnly: false,
                            fieldController: Get.find<ManagerRequestController>().remarksController,
                          ),
                          if(managerRequestController.filters.value[managerRequestController.currentTabIndex.value].filter == RequestFilterTypes.pending)
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
                          // if (!isMissPunch) SizedBox(height: 10.h),
                          SizedBox(height: 10.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.h),
                            child: HierarchyApprovalStatus(
                                approvalData: Get.find<ManagerRequestController>().deductionData.value?.approvers?.map((e) => ApprovalData(
                                  profilePicture: e.profilePicture,
                                  firstName: e.approverName,
                                  status: e.status,
                                  designation: e.designation,
                                  employeeId: e.employeeId,
                                  remarks: e.remarks,
                                  modifiedOn: e.date,
                                )).toList(),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          if(managerRequestController.filters.value[managerRequestController.currentTabIndex.value].filter == RequestFilterTypes.pending)
                            if(managerRequestController.currentTabIndex.value != 2)
                              ActionButtons(
                              cancelText: "Apply Fine",
                              okText: "Pardon",
                              action: (value) async {
                                ManagerRequestController managerController = Get.find<ManagerRequestController>();
                                managerController.validateRemarksField();
                                if(managerController.remarksController.text.trim().isNotEmpty) {
                                  String? result = await Get.find<ManagerRequestController>().submitForRegularization(
                                    action: value,
                                    regularizeId: Get.find<ManagerRequestController>().deductionData.value?.employeeAttendanceDeductionId?.toString()
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
                            )
                            else
                              ActionButtons(
                              cancelText: "Reject",
                              okText: "Approve",
                              action: (value) async {
                                ManagerRequestController managerController = Get.find<ManagerRequestController>();
                                managerController.validateRemarksField();
                                if(managerController.remarksController.text.trim().isNotEmpty) {
                                  String? result = await Get.find<ManagerRequestController>().submitOvertimeUpdate(
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
                          SizedBox(height: 10.h),

                          SizedBox(
                            height:
                            MediaQuery.of(context).viewInsets.bottom,
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
    );
  }
}

class RegularizeTitle extends StatelessWidget {
  final String title;
  final Function action;
  final String image;
  const RegularizeTitle({super.key, required this.title, required this.action, required this.image});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: 48.h, height: 48.h),
        const Spacer(),
        Image.asset(image, width: 35.h),
        Text(
          title,
          style: GoogleFonts.poppins(
            color: ColorUtils.workEntryHead,
            fontWeight: FontWeight.w500,
            fontSize: 15.h,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () async {
            await action.call();
          },
          child: Container(
            padding: EdgeInsets.all(1).h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14).r,
              color: ColorUtils.charcoalBlue.withValues(alpha: 0.1),
            ),
            child: Container(
              height: 46.h,
              width: 46.h,
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

class _EmployeeData extends GetView<ManagerRequestController> {
  const _EmployeeData();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Row(
        children: [
          AttendanceCommonWidgets().cachedNetworkImage(
              controller.deductionData.value?.profilePicture ?? '',
            height: 28.h,
          ),
          // Image.asset("assets/examples/user_request.png", height: 30.h),
          SizedBox(width: 8.h),
          Expanded(
            child: AttendanceCommonWidgets().nameWithDesignation(
                name: controller.deductionData.value?.employeeName ?? '--',
              designation: controller.deductionData.value?.designation?? '--',
            ),
          ),
          SizedBox(width: 10.h),
          AttendanceCommonWidgets().dateView(controller.currentTabIndex.value == 2 ? controller.deductionData.value?.overTimeDate ?? '--' : controller.deductionData.value?.deductionDate ?? '--'),
        ],
      );
    }
    );
  }
}

class _RequestType extends GetView<ManagerRequestController> {
  const _RequestType();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Request Type",
                style: GoogleFonts.inter(
                  fontSize: 11.h,
                  fontWeight: FontWeight.w400,
                  color: ColorUtils.steelBlue,
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                controller.currentTabIndex.value == 2 ? controller.deductionData.value?.overTimeDetails ?? '--' : controller.deductionData.value?.deductionDetails ?? '--',
                style: GoogleFonts.inter(
                  fontSize: 13.h,
                  fontWeight: FontWeight.w500,
                  color: ColorUtils.workEntryHead,
                ),
              ),
            ],
          ),
          Container(width: 1.h, height: 20.h, color: ColorUtils.paleSilver),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.currentTabIndex.value == 2 ? "Time Extra" : "Fine Type",
                style: GoogleFonts.poppins(
                  fontSize: 11.h,
                  fontWeight: FontWeight.w400,
                  color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                ),
              ),
              SizedBox(height: 5.h),
              Container(
                padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 6.h),
                decoration: BoxDecoration(
                  color: ColorUtils.lavenderWhisper,
                  borderRadius: BorderRadius.circular(16).r,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6.h,
                      height: 6.h,
                      decoration: BoxDecoration(
                        color: ColorUtils.neonViolet,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 6.h),
                    Text(
                      controller.currentTabIndex.value == 2 ? controller.deductionData.value?.timeExtra ?? '--' : controller.deductionData.value?.deductionType ?? '--',
                      style: GoogleFonts.inter(
                        fontSize: 11.h,
                        fontWeight: FontWeight.w500,
                        color: ColorUtils.amethystPurple,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WorkTimeWidget extends StatelessWidget {
  final Employees? employee;
  const _WorkTimeWidget(this.employee);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Check in",
              style: GoogleFonts.poppins(
                fontSize: 11.h,
                fontWeight: FontWeight.w400,
                color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
              ),
            ),
            Text(
              employee?.firstCheckInTime ?? '--',
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
              "Check out",
              style: GoogleFonts.poppins(
                fontSize: 11.h,
                fontWeight: FontWeight.w400,
                color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
              ),
            ),
            Text(
              employee?.lastCheckOutTime ?? '--',
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
                "Worked Hours",
                style: GoogleFonts.poppins(
                  fontSize: 11.h,
                  fontWeight: FontWeight.w400,
                  color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                ),
              ),
              Text(
                employee?.totalWorkHours ?? '--',
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

class ReasonTextField extends StatefulWidget {
  final RequestType requestType;
  final bool? readOnly;
  final String? fieldText;
  final TextEditingController fieldController;
  const ReasonTextField({super.key, required this.requestType, this.readOnly, this.fieldText, required this.fieldController});

  @override
  State<ReasonTextField> createState() => _ReasonTextFieldState();
}

class _ReasonTextFieldState extends State<ReasonTextField> {

  final FocusNode reasonFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {

      reasonFocusNode.requestFocus();

      await Future.delayed(const Duration(milliseconds: 0));

      SystemChannels.textInput.invokeMethod('TextInput.hide');
    });
  }

  @override
  Widget build(BuildContext context) {
    Get.find<ManagerRequestController>().reasonController.text = widget.fieldText ?? Get.find<ManagerRequestController>().reasonController.text;
    return Obx(() {
        return Container(
          padding: const EdgeInsets.all(1).h,
          decoration: BoxDecoration(
            color: Get.find<ManagerRequestController>().showReasonValidation.value && !(widget.readOnly ?? false) ? Colors.red : textFieldBoarder(widget.requestType),
            borderRadius: BorderRadius.circular(15).r,
          ),
          child: Container(
            padding: const EdgeInsets.all(15).h,
            decoration: BoxDecoration(
              color: !(widget.readOnly ?? false) ? ColorUtils.textWhite : ColorUtils.softPearl,
              borderRadius: BorderRadius.circular(15).r,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fieldLabel(widget.requestType, (widget.readOnly ?? false)),
                  style: GoogleFonts.inter(
                    color: Get.find<ManagerRequestController>().showReasonValidation.value && !(widget.readOnly ?? false) ? Colors.red : ColorUtils.workEntryHead,
                    fontWeight: FontWeight.w400,
                    fontSize: 11.h,
                  ),
                ),
                TextField(
                  controller: widget.fieldController,
                  focusNode: (widget.readOnly ?? false) ? null : reasonFocusNode,
                  onChanged: (value) {
                    ManagerRequestController requestController = Get.find<ManagerRequestController>();
                    if(requestController.showReasonValidation.value) {
                      requestController.validateRemarksField();
                    }
                  },
                  textInputAction: TextInputAction.newline,
                  minLines: 1,
                  maxLines: null,
                  showCursor: !(widget.readOnly ?? false),
                  readOnly: widget.readOnly ?? false,
                  style: GoogleFonts.inter(
                    color: ColorUtils.workEntryHead,
                    fontWeight: FontWeight.w400,
                    fontSize: 11.h,
                  ),
                  decoration: InputDecoration(
                    hintText:
                        !isHintEnable(widget.requestType) ? "" : "Description (Optional)",
                    contentPadding: EdgeInsets.zero,
                    border: const OutlineInputBorder(borderSide: BorderSide.none),
                    hintStyle: GoogleFonts.inter(
                      color: ColorUtils.workEntryHead,
                      fontWeight: FontWeight.w400,
                      fontSize: 11.h,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}

String fieldLabel(RequestType type, bool isReadOnly) {
  switch (type) {
    case RequestType.excuse:
      return "Reason";
    case RequestType.punchApproval:
      return "Remarks";
    case RequestType.wfh:
      return isReadOnly ? "Reason" : "Remarks";
    case RequestType.letterRequest:
      return isReadOnly ? "Reason" : "Purpose";
    case RequestType.leaveRequest:
      return "Reason";
    case RequestType.bulkApproval:
      return "Remarks";
    case RequestType.overtime:
      return "Remarks";
  }
}

bool isHintEnable(RequestType type) {
  switch (type) {
    case RequestType.excuse:
      return true;
    case RequestType.punchApproval:
      return false;
    case RequestType.wfh:
      return false;
    case RequestType.letterRequest:
      return false;
    case RequestType.leaveRequest:
      return true;
    default:
      return false;
  }
}

int noOfLines(RequestType type) {
  switch (type) {
    case RequestType.excuse:
      return 5;
    case RequestType.punchApproval:
      return 5;
    case RequestType.wfh:
      return 2;
    case RequestType.letterRequest:
      return 2;
    case RequestType.leaveRequest:
      return 5;
    default:
      return 5;
  }
}

Color? textFieldBoarder(RequestType type) {
  switch (type) {
    case RequestType.excuse:
      return null;
    case RequestType.punchApproval:
      return ColorUtils.workEntryHead.withValues(alpha: 0.1);
    case RequestType.wfh:
      return ColorUtils.workEntryHead.withValues(alpha: 0.1);
    case RequestType.letterRequest:
      return ColorUtils.workEntryHead.withValues(alpha: 0.1);
    case RequestType.leaveRequest:
      return null;
    case RequestType.bulkApproval:
      return ColorUtils.workEntryHead.withValues(alpha: 0.1);
    // default: return null;
    case RequestType.overtime:
      return null;
  }
}

class HierarchyApprovalStatus extends StatelessWidget {
  final List<ApprovalData?>? approvalData;
  final AdminData? adminData;
  final String? mainStatus;
  const HierarchyApprovalStatus({super.key, this.approvalData, this.adminData, this.mainStatus});

  @override
  Widget build(BuildContext context) {
    AdminData? currentAdminData = adminData;

    if (currentAdminData?.status?.trim().toLowerCase() == 'pending' || mainStatus == null) {
      currentAdminData = null;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (approvalData?.isNotEmpty ?? false)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15).h,
            child: Row(
              children: [
                Text(
                  "Hierarchy Approval Status",
                  style: GoogleFonts.inter(
                    color: ColorUtils.workEntryHead,
                    fontWeight: FontWeight.w400,
                    fontSize: 11.h,
                  ),
                ),
              ],
            ),
          ),
        if (currentAdminData != null)
          Row(
            children: [
              if (mainStatus != null)
                Text(
                  "${mainStatus ?? ''} ",
                  style: TextStyle(
                    color: ColorUtils.workEntryHead,
                    fontWeight: FontWeight.w400,
                    fontSize: 12.h,
                  ),
                ),
              Text(
                "By Admin",
                style: TextStyle(
                  color: ColorUtils.workEntryHead,
                  fontWeight: FontWeight.w400,
                  fontSize: 12.h,
                ),
              ),
            ],
          ),
        if (currentAdminData != null)
          SizedBox(height: 10.h),
        if (currentAdminData != null)
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 5,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AttendanceCommonWidgets().cachedNetworkImage(
                          currentAdminData.profilePicture ?? '',
                          height: 28.h,
                          color: (mainStatus?.toLowerCase() == "approved" || mainStatus?.toLowerCase() == "pardon")
                              ? Colors.green.shade700
                              : ((mainStatus?.toLowerCase() == "rejected" || mainStatus?.toLowerCase() == "fine")
                                  ? const Color(0xFFD40000)
                                  : ColorUtils.lightSilver),
                        ),
                        SizedBox(width: 8.h),
                        Expanded(
                          child: AttendanceCommonWidgets().nameWithDesignation(
                            name: currentAdminData.fullName ?? '--',
                            designation: currentAdminData.designation ?? '--',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.h),
                  Expanded(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (mainStatus != null)
                            if (mainStatus?.toLowerCase() == "approved")
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SvgPicture.asset("assets/images/thumb_green.svg"),
                                  SizedBox(
                                    width: 4.w,
                                  ),
                                  Flexible(
                                    child: Text(
                                      mainStatus ?? '--',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 11.h,
                                        color: ColorUtils.approved,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              )
                            else if (mainStatus?.toLowerCase() == "rejected")
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SvgPicture.asset("assets/images/thumb_red.svg"),
                                  SizedBox(
                                    width: 4.w,
                                  ),
                                  Flexible(
                                    child: Text(
                                      mainStatus ?? '--',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 11.h,
                                        color: const Color(0xFFFF5454),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              )
                            else
                              Text(
                                mainStatus ?? '--',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11.h,
                                  color: ColorUtils.workEntryHead.withValues(alpha: 0.7),
                                ),
                                overflow: TextOverflow.ellipsis,
                              )
                          else
                            Text(
                              "Not updated",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 11.h,
                                color: const Color(0xFF666666),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          Text(
                            currentAdminData.modifiedOn ?? "--",
                            style: GoogleFonts.poppins(
                              color: ColorUtils.darkGrey,
                              fontWeight: FontWeight.w400,
                              fontSize: 11.h,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 36.h),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 6.h, bottom: 0.h),
                      child: Text(
                        "Remarks : ${currentAdminData.remarks ?? '--'}",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          fontSize: 11.h,
                          color: ColorUtils.workEntryHead.withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.h),
            ],
          ),
        ...List.generate((approvalData?.length ?? 0), (index) {
          final status = approvalData?[index]?.status;
          final isApproved = status?.toLowerCase() == "approved";
          final isRejected = status?.toLowerCase() == "rejected";
          final isLast = index == ((approvalData?.length ?? 1) - 1);

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 3,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AttendanceCommonWidgets().cachedNetworkImage(
                          approvalData?[index]?.profilePicture ?? '',
                          height: 28.h,
                          color: isApproved
                              ? Colors.green.shade700
                              : (isRejected
                                  ? const Color(0xFFD40000)
                                  : ColorUtils.lightSilver),
                        ),
                        SizedBox(width: 8.h),
                        Expanded(
                          child: AttendanceCommonWidgets().nameWithDesignation(
                            name: approvalData?[index]?.firstName != null && approvalData?[index]?.lastName != null ? '${approvalData?[index]?.firstName} ${approvalData?[index]?.lastName}' : approvalData?[index]?.firstName ?? approvalData?[index]?.lastName ?? '--',
                            designation: approvalData?[index]?.designation ?? '--',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.h),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (status != null)
                            if (status.toLowerCase() == "approved")
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SvgPicture.asset("assets/images/thumb_green.svg"),
                                  SizedBox(
                                    width: 4.w,
                                  ),
                                  Flexible(
                                    child: Text(
                                      status,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 11.h,
                                        color: ColorUtils.approved,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              )
                            else if (status.toLowerCase() == "rejected")
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SvgPicture.asset("assets/images/thumb_red.svg"),
                                  SizedBox(
                                    width: 4.w,
                                  ),
                                  Flexible(
                                    child: Text(
                                      status,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 11.h,
                                        color: const Color(0xFFFF5454),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              )
                            else
                              Text(
                                status,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11.h,
                                  color: ColorUtils.workEntryHead.withValues(alpha: 0.7),
                                ),
                                overflow: TextOverflow.ellipsis,
                              )
                          else
                            Text(
                              "Not updated",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 11.h,
                                color: const Color(0xFF666666),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          Text(
                            approvalData?[index]?.modifiedOn ?? "--",
                            style: GoogleFonts.poppins(
                              color: ColorUtils.darkGrey,
                              fontWeight: FontWeight.w400,
                              fontSize: 11.h,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (!isLast)
                      Padding(
                        padding: const EdgeInsets.only(left: 14).h,
                        child: CustomPaint(
                          size: Size(3.w, double.infinity),
                          painter: HierarchyLinePainter(
                            isApproved: isApproved,
                            isRejected: isRejected,
                          ),
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.only(left: 14).h,
                        child: SizedBox(
                          width: 3.w,
                          height: double.infinity,
                        ),
                      ),
                    SizedBox(width: 22.h),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 6.h, bottom: 15.h),
                        child: Text(
                          "Remarks : ${approvalData?[index]?.remarks ?? '--'}",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 11.h,
                            color: ColorUtils.workEntryHead.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}

class ActionButtons extends StatelessWidget {
  final String cancelText;
  final String okText;
  final Function(bool) action;
  const ActionButtons({
    super.key,
    required this.cancelText,
    required this.okText,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: [
          Expanded(
            child: Obx(() => InkWell(
                borderRadius: BorderRadius.circular(37).r,
                onTap: () {
                  if(!Get.find<ManagerRequestController>().fineLoading.value && !Get.find<ManagerRequestController>().rejectLoading.value) {
                    action.call(false);
                  }
                },
                child: Container(
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: ColorUtils.fieryRed,
                    borderRadius: BorderRadius.circular(37).r,
                  ),
                  child: Center(
                    child: (Get.find<ManagerRequestController>().fineLoading.value || Get.find<ManagerRequestController>().rejectLoading.value)
                        ? SizedBox(
                      width: 20.h,
                      height: 20.h,
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                        : Text(
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
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Obx(() => InkWell(
                borderRadius: BorderRadius.circular(37).r,
                onTap: () {
                  if(!Get.find<ManagerRequestController>().pardonLoading.value && !Get.find<ManagerRequestController>().approveLoading.value) {
                    action.call(true);
                  }
                },
                child: Container(
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: ColorUtils.secondaryBlue,
                    borderRadius: BorderRadius.circular(37).r,
                  ),
                  child: Center(
                    child: (Get.find<ManagerRequestController>().pardonLoading.value || Get.find<ManagerRequestController>().approveLoading.value)
                        ? SizedBox(
                      width: 20.h,
                        height: 20.h,
                        child: CircularProgressIndicator(color: Colors.white),
                    )
                        : Text(
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
          ),
        ],
      ),
    );
  }
}

class _MissPunchDeductionAmount extends GetView<ManagerRequestController> {
  const _MissPunchDeductionAmount();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Late By :",
                    style: GoogleFonts.poppins(
                      fontSize: 11.h,
                      fontWeight: FontWeight.w400,
                      color: ColorUtils.pureRed,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/manager_view/regularize_time.png",
                        height: 20.h,
                      ),
                      SizedBox(width: 5.h),
                      Text(
                        controller.deductionData.value?.timeDifference ?? '--',
                        style: GoogleFonts.inter(
                          color: ColorUtils.fieryScarlet,
                          fontSize: 13.h,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Amount :",
                    style: GoogleFonts.poppins(
                      fontSize: 11.h,
                      fontWeight: FontWeight.w400,
                      color: ColorUtils.pureRed,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/manager_view/regularize_amount.png",
                        height: 20.h,
                      ),
                      SizedBox(width: 5.h),
                      Text(
                        controller.deductionData.value?.deductionAmount ?? '--',
                        style: GoogleFonts.inter(
                          color: ColorUtils.fieryScarlet,
                          fontSize: 13.h,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 15.h),
          Container(
            height: 52.h,
            decoration: BoxDecoration(
              color: ColorUtils.creamyPeach,
              borderRadius: BorderRadius.circular(14).r,
            ),
            child: Row(
              children: [
                SizedBox(width: 10.h),
                Image.asset(
                  "assets/images/manager_view/expired_fg.png",
                  height: 28.h,
                ),
                SizedBox(width: 10.h),
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          "Monthly Punctuality Breach count : ",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.dmSans(
                            color: ColorUtils.burntOrange,
                            fontSize: 13.h,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Text(
                        controller.deductionData.value?.punctualityBreachCount ?? '--',
                        style: GoogleFonts.dmSans(
                          color: ColorUtils.burntOrange,
                          fontSize: 15.h,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<bool?> _showSuccessMessage({required BuildContext context}) async {
  return showGeneralDialog<bool>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black,
    pageBuilder: (ctx, a1, a2) {
      return Container();
    },
    transitionDuration: const Duration(milliseconds: 300),
    transitionBuilder: (ctx, a1, a2, child) {
      var curve = Curves.easeInOut.transform(a1.value);
      return Transform.scale(
        scale: curve,
        child: PopScope(
          canPop: false,
          child: AlertDialog(
            backgroundColor: ColorUtils.backgroundBlack,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(29.0).w,
              side: BorderSide(color: const Color(0xFF666666), width: 1.w),
            ),
            title: Image.asset(
              "assets/images/Success-icon3d.webp",
              // width: 10.w,
              height: 60.w,
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Your excuse has been submitted successfully.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                    color: ColorUtils.textWhite,
                  ),
                ),
                SizedBox(height: 5.w),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "assets/images/attendance-3d.webp",
                      width: 20.w,
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      DateFormat('hh:mm a').format(DateTime.now()),
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                        color: ColorUtils.textWhite,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.w),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "assets/images/navigation-3d.webp",
                      width: 25.w,
                      fit: BoxFit.fitWidth,
                    ),
                    SizedBox(width: 5.w),
                    SizedBox(
                      width: ScreenUtil().screenWidth * 0.3,
                      child: GetX<LocationFetchController>(
                        builder: (LocationFetchController controller) {
                          return Text(
                            "${controller.locName}",
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              color: ColorUtils.textWhite,
                              fontWeight: FontWeight.w300,
                              fontSize: 12.sp,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class HierarchyLinePainter extends CustomPainter {
  final bool isApproved;
  final bool isRejected;
  HierarchyLinePainter({required this.isApproved, this.isRejected = false});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = (isApproved || isRejected) ? 1.5 : 1.0
      ..style = PaintingStyle.stroke;

    if (isApproved) {
      paint.shader = ui.Gradient.linear(
        Offset(size.width / 2, 0),
        Offset(size.width / 2, size.height),
        [const Color(0xFF238D63), const Color(0xFF7AE9BD)],
      );
      canvas.drawLine(Offset(size.width / 2, 0), Offset(size.width / 2, size.height), paint);
    } else if (isRejected) {
      paint.shader = ui.Gradient.linear(
        Offset(size.width / 2, 0),
        Offset(size.width / 2, size.height),
        [const Color(0xFFD40000), const Color(0xFFFF5454)],
      );
      canvas.drawLine(Offset(size.width / 2, 0), Offset(size.width / 2, size.height), paint);
    } else {
      paint.color = ColorUtils.lightSilver;
      
      double dashHeight = 2.0;
      double dashSpace = 2.0;
      double startY = 0.0;
      while (startY < size.height) {
        canvas.drawLine(
          Offset(size.width / 2, startY),
          Offset(size.width / 2, math.min(startY + dashHeight, size.height)),
          paint,
        );
        startY += dashHeight + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
