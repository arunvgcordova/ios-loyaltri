import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Request/request_wigets_manager/regularize_bottomSheet_manager.dart';
import 'package:loyaltri_minimal/models/manager/employee_excuseList_model.dart';

import '../../../../controller/userProfileController.dart';
import '../../../../utils/color_utils.dart';
import '../../Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import '../manager_request_controller/manager_request_controller.dart';

class OvertimeBottomSheetManager extends StatelessWidget {
  final Employees? employee;
  const OvertimeBottomSheetManager({super.key, this.employee,});

  @override
  Widget build(BuildContext context) {
    ManagerRequestController managerRequestController = Get.find<ManagerRequestController>();
    return GestureDetector(
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
                  title: "Overtime",
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
                        _EmployeeData(employee),
                        SizedBox(height: 25.h),
                        _RequestType(employee),
                        SizedBox(height: 20.h),
                        _WorkTimeWidget(employee),
                        SizedBox(height: 30.h),
                        if(managerRequestController.filters.value[managerRequestController.currentTabIndex.value].filter == RequestFilterTypes.pending)
                          ActionButtons(
                            cancelText: "Reject",
                            okText: "Approve",
                            action: (value) async {
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
    );
  }
}

class _EmployeeData extends StatelessWidget {
  final Employees? employee;
  const _EmployeeData(this.employee);

  @override
  Widget build(BuildContext context) {
    String? date;
    try {
      DateTime dateTime = DateTime.parse(employee?.date ?? '');
      date = DateFormat("dd MMM yyyy | E").format(dateTime);
    } catch(e) {}
    return Row(
      children: [
        AttendanceCommonWidgets().cachedNetworkImage(
          employee?.profilePicture ?? '--',
          height: 28.h,
        ),
        // Image.asset("assets/examples/user_request.png", height: 30.h),
        SizedBox(width: 8.h),
        Expanded(
          child: AttendanceCommonWidgets().nameWithDesignation(
            name: employee?.employeeName ?? '--',
            designation: employee?.designation ?? '--',
          ),
        ),
        SizedBox(width: 10.h),
        AttendanceCommonWidgets().dateView(date ??'--'),
      ],
    );
  }
}

class _RequestType extends StatelessWidget {
  final Employees? employee;
  const _RequestType(this.employee);

  @override
  Widget build(BuildContext context) {
    return Row(
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
              'Overtime',
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
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "Amount",
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
                  // Container(
                  //   width: 6.h,
                  //   height: 6.h,
                  //   decoration: BoxDecoration(
                  //     color: ColorUtils.neonViolet,
                  //     shape: BoxShape.circle,
                  //   ),
                  // ),
                  // SizedBox(width: 6.h),
                  if(employee?.status?.isNotEmpty ?? false)
                    Text(
                      "${Get.find<UserProfileController>().userCompanyData.value.result?.currency?.toString() ?? '-'} ${employee?.status?.first.deductionAmount ?? "--"}",
                      style: GoogleFonts.inter(
                        fontSize: 13.h,
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