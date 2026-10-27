
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Request/manager_request_controller/manager_request_controller.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Request/request_wigets_manager/regularize_bottomSheet_manager.dart';

import '../../../../models/manager/punch_approval_list_model.dart';
import '../../../../utils/color_utils.dart';

class PunchApprovalBottomSheetManager extends StatelessWidget {
  final EmployeesApproval? employeesApproval;
  const PunchApprovalBottomSheetManager({super.key, this.employeesApproval});

  @override
  Widget build(BuildContext context) {
    ManagerRequestController managerRequestController = Get.find<ManagerRequestController>();
    bool isPending = managerRequestController.filters.value[managerRequestController.currentTabIndex.value].filter == RequestFilterTypes.pending;
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
                        title: "Punch Approval",
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
                              _EmployeeData(employeesApproval),
                              // SizedBox(height: 25.h),
                              Divider(
                                color: ColorUtils.softGrey,
                                height: 30.h,
                                thickness: 1.h,
                              ),
                              _CheckInData(employeesApproval),
                              SizedBox(height: 18.h),
                              _LocationData(employeesApproval),
                              SizedBox(height: 15.h),
                              ReasonTextField(
                                requestType: RequestType.punchApproval,
                                readOnly: true,
                                fieldController: Get.find<ManagerRequestController>().reasonController,
                                fieldText: employeesApproval?.reason ?? '',
                              ),
                              if(isPending)
                                SizedBox(height: 15.h),
                              if(isPending)
                                ReasonTextField(
                                requestType: RequestType.wfh,
                                readOnly: false,
                                fieldController: Get.find<ManagerRequestController>().remarksController,
                              ),
                              if(isPending)
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
                              // Padding(
                              //   padding: EdgeInsets.symmetric(horizontal: 10.h),
                              //   child: HierarchyApprovalStatus(),
                              // ),
                              SizedBox(
                                height:
                                MediaQuery.of(context).viewInsets.bottom + (isPending ? 70.h : 10.h),
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
          if(isPending)
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
                        String? result = await Get.find<ManagerRequestController>().submitPunchRequestUpdate(
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
  final EmployeesApproval? employeesApproval;
  const _EmployeeData(this.employeesApproval);

  @override
  Widget build(BuildContext context) {
    String? date;
    try {
      DateTime dateTime = DateTime.parse(employeesApproval?.date ?? '');
      date = DateFormat("dd MMM yyyy | E").format(dateTime);
    } catch(e) {}
    return Row(
      children: [
        // Image.asset("assets/examples/user_request.png", height: 30.h),
        AttendanceCommonWidgets().cachedNetworkImage(
          employeesApproval?.profilePicture ?? '',
          height: 28.h,
        ),
        SizedBox(width: 8.h),
        Expanded(
          child: AttendanceCommonWidgets().nameWithDesignation(
              name: employeesApproval?.employeeName ?? '--',
              designation: employeesApproval?.designation?? "--",
          ),
        ),
        SizedBox(width: 10.h),
        AttendanceCommonWidgets().dateView(date ?? '--'),
      ],
    );
  }
}

class _CheckInData extends StatelessWidget {
  final EmployeesApproval? employeesApproval;
  const _CheckInData(this.employeesApproval);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            AttendanceCommonWidgets().cachedNetworkImageSquare(
                employeesApproval?.profilePicture ?? '--',
                height: 28.h
            ),
            SizedBox(width: 8.w),
            AttendanceCommonWidgets().checkInTime(
              employeesApproval?.firstCheckInTime ?? '--',
            ),
          ],
        ),
        Container(width: 1.h, height: 15.h, color: ColorUtils.paleSilver),
        Row(
          children: [
            AttendanceCommonWidgets().cachedNetworkImageSquare(
                employeesApproval?.profilePicture ?? '--',
                height: 28.h
            ),
            SizedBox(width: 8.w),
            AttendanceCommonWidgets().checkOutTimeStart(
              employeesApproval?.lastCheckOutTime ?? '--',
            ),
          ],
        ),
      ],
    );
  }
}

class _LocationData extends StatelessWidget {
  final EmployeesApproval? employeesApproval;
  const _LocationData(this.employeesApproval);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          "assets/examples/map_preview.png",
          height: 50.h,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(width: 6.h),
                  Image.asset(
                    "assets/images/manager_view/regularize_time.png",
                    height: 15.h,
                  ),
                  SizedBox(width: 6.h),
                  Text(
                    "Worked Hrs: ",
                    style: GoogleFonts.poppins(
                      fontSize: 11.h,
                      fontWeight: FontWeight.w400,
                      color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      employeesApproval?.totalWorkHours ?? '--',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 11.h,
                        fontWeight: FontWeight.w500,
                        color: ColorUtils.workEntryHead,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              Row(
                children: [
                  SizedBox(width: 6.h),
                  SvgPicture.asset(
                    "assets/images/location-att-details.svg",
                    height: 15.h,
                  ),
                  SizedBox(width: 6.h),
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
            ],
          ),
        ),
      ],
    );
  }
}

