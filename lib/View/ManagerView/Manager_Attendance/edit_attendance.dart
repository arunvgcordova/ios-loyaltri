import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/absent_view.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/attendance_type_buttons.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/edit_att_save_button.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/employee_title.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/fine_view.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/overtime_view.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/paid_leave_view.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/present_view.dart';
import 'package:loyaltri_minimal/models/manager/manager_attendance_list_model.dart';
import '../../../controller/userAuthentication.dart';
import '../../../utils/color_utils.dart';
import '../../CWidgets/cwidgets.dart';
import '../Employee_Leave/employee_leave_controller/employee_leave_controller.dart';
import '../Manager_Request/request_wigets_manager/request_app_bar.dart';
import 'attendance_widgets_manager/halfDay_view.dart';
import 'manager_attendance_controller/manager_attendance_controller.dart';

class EditAttendance extends StatefulWidget {
  final String? status;
  const EditAttendance({super.key, this.status});

  @override
  State<EditAttendance> createState() => _EditAttendanceState();
}

class _EditAttendanceState extends State<EditAttendance> {
  bool canEditAttendance = Get.find<UserAuthController>().userData.value.userData?.attendanceEdit ?? false;

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  Future<void> _initialize() async {
    context.loaderOverlay.show();
    ManagerEmployeeData? employeeData = Get.find<ManagerAttendanceController>().selectedEmployeeData.value;
    if(widget.status != null || (widget.status?.isNotEmpty ?? false)) {
      Get.find<ManagerAttendanceController>().resetPunchValues();
      if(widget.status == 'present') {
        Get.find<ManagerAttendanceController>().editType.value = leaveTypes[0];
        Get.find<ManagerAttendanceController>().savedEditType.value = leaveTypes[0];
        await Get.find<ManagerAttendanceController>().fetchEmployeeShift();
        await Get.find<ManagerAttendanceController>().fetchEmployeeAttDetail(attId: employeeData?.employeeDailyAttendanceId.toString() ?? '');
      } else if(widget.status == 'halfday') {
        Get.find<ManagerAttendanceController>().editType.value = leaveTypes[1];
        Get.find<ManagerAttendanceController>().savedEditType.value = leaveTypes[1];
        await Get.find<ManagerAttendanceController>().fetchEmployeeShift();
        await Get.find<ManagerAttendanceController>().fetchEmployeeLeaveType();
        await Get.find<ManagerAttendanceController>().fetchEmployeeAttDetail(attId: employeeData?.employeeDailyAttendanceId.toString() ?? '');
      } else if(widget.status == 'absent') {
        Get.find<ManagerAttendanceController>().editType.value = leaveTypes[2];
        Get.find<ManagerAttendanceController>().savedEditType.value = leaveTypes[2];
        await Get.find<ManagerAttendanceController>().fetchEmployeeAttDetail(attId: employeeData?.employeeDailyAttendanceId.toString() ?? '');
      } else if(widget.status == 'fine') {
        Get.find<ManagerAttendanceController>().editType.value = leaveTypes[3];
        Get.find<ManagerAttendanceController>().savedEditType.value = leaveTypes[3];
        await Get.find<ManagerAttendanceController>().fetchEmployeeAttDetail(attId: employeeData?.employeeDailyAttendanceId.toString() ?? '');
      } else if(widget.status == 'overtime') {
        Get.find<ManagerAttendanceController>().editType.value = leaveTypes[4];
        Get.find<ManagerAttendanceController>().savedEditType.value = leaveTypes[4];
        await Get.find<ManagerAttendanceController>().fetchEmployeeAttDetail(attId: employeeData?.employeeDailyAttendanceId.toString() ?? '');
      } else if(widget.status == 'paidleave') {
        Get.find<ManagerAttendanceController>().editType.value = leaveTypes[5];
        Get.find<ManagerAttendanceController>().savedEditType.value = leaveTypes[5];
        await Get.find<ManagerAttendanceController>().fetchEmployeeLeaveType();
      } else if(widget.status == 'offday') {
        Get.find<ManagerAttendanceController>().editType.value = leaveTypes[0];
        Get.find<ManagerAttendanceController>().savedEditType.value = leaveTypes[0];
        Get.find<ManagerAttendanceController>().isOffDay.value = true;
        await Get.find<ManagerAttendanceController>().fetchEmployeeShift();
        await Get.find<ManagerAttendanceController>().fetchEmployeeAttDetail(attId: employeeData?.employeeDailyAttendanceId.toString() ?? '');
      } else {
        Get.find<ManagerAttendanceController>().editType.value = leaveTypes[0];
        Get.find<ManagerAttendanceController>().savedEditType.value = leaveTypes[0];
        await Get.find<ManagerAttendanceController>().fetchEmployeeShift();
        await Get.find<ManagerAttendanceController>().fetchEmployeeAttDetail(attId: employeeData?.employeeDailyAttendanceId.toString() ?? '');
      }
    } else {
      Get.find<ManagerAttendanceController>().editType.value = leaveTypes[0];
      Get.find<ManagerAttendanceController>().savedEditType.value = leaveTypes[0];
      await Get.find<ManagerAttendanceController>().fetchEmployeeShift();
      await Get.find<ManagerAttendanceController>().fetchEmployeeAttDetail(attId: employeeData?.employeeDailyAttendanceId.toString() ?? '');
    }
    context.loaderOverlay.hide();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        top: false,
        bottom: true,
        left: false,
        right: false,
        child: Scaffold(
          body: Stack(
            children: [
              gradientContainer2,
              SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: 15.h,
                        left: 15.w,
                        right: 15.w,
                        bottom: 10.h,
                      ),
                      child: RequestAppBar(
                        title: "Edit Attendance",
                        icon: "assets/images/manager_view/request_icon.png",
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            EmployeeTitle(),
                            AttendanceTypeButtons(),
                            GetX<ManagerAttendanceController>(
                              builder: (ManagerAttendanceController controller) {
                                if (controller.editType.value?.type ==
                                    EditAttType.present) {
                                  return PresentView();
                                } else if (controller.editType.value?.type ==
                                    EditAttType.halfDay) {
                                  return HalfDayView();
                                } else if (controller.editType.value?.type ==
                                    EditAttType.absent) {
                                  return AbsentView();
                                } else if (controller.editType.value?.type ==
                                    EditAttType.fine) {
                                  return FineView();
                                } else if (controller.editType.value?.type ==
                                    EditAttType.overTime) {
                                  return OverTimeView();
                                } else if (controller.editType.value?.type ==
                                    EditAttType.paidLeave) {
                                  return PaidLeaveView();
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar:
              canEditAttendance
                  ? Container(
                width: ScreenUtil().screenWidth,
                height: 80.h,
                decoration: BoxDecoration(
                  color: ColorUtils.textWhite,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFB9B8FF).withValues(alpha: 0.18),
                      offset: Offset(0, -16),
                      blurRadius: 31,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Padding(
                  padding:
                  const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 10,
                    bottom: 20,
                  ).h,
                  child: EditAttSaveButton(
                    cancelText: "Cancel",
                    confirmText: "Save Changes",
                    confirmIcon:
                    "assets/images/manager_view/save_icon.svg",
                    actionCancel: () {
                      Navigator.of(context).pop();
                    },
                    actionSuccess: () async {
                      if (!Get.find<ManagerAttendanceController>().attSubmissionLoading.value) {
                        await Get.find<ManagerAttendanceController>().validateAndSubmitAttendance(
                          context,
                        );
                      }
                    },
                  ),
                ),
              )
                  : null,
        ),
      ),
    );
  }
}
