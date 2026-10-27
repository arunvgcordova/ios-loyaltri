import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Request/manager_request_controller/manager_request_controller.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Request/request_wigets_manager/regularize_bottomSheet_manager.dart';
import 'package:loyaltri_minimal/models/manager/employee_excuseList_model.dart';
import 'package:loyaltri_minimal/models/manager/leave_request_list_model.dart';
import 'package:loyaltri_minimal/services/api_services.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';

import '../../../../controller/userProfileController.dart';
import '../../../../models/manager/punch_approval_list_model.dart';
import '../../../../models/manager/wfh_lr_list_model.dart';
import '../../../Login/login_widgets/custom_check_box.dart';

class BulkRegularizationBottomSheetManager extends StatelessWidget {
  final List<Employees>? empList;
  final List<EmployeesApproval>? approvalList;
  final List<WfhLrData>? requestList;
  final List<EmployeeLeaveData>? leaveList;
  final bool isLeave;
  const BulkRegularizationBottomSheetManager({super.key, this.empList, this.approvalList, this.requestList, this.leaveList, required this.isLeave});

  @override
  Widget build(BuildContext context) {
    List<Employees> employeeList = [];
    List<EmployeesApproval> punchApprovalList = [];
    List<WfhLrData> spcRequestList = [];
    List<EmployeeLeaveData> empLeaveList = [];
    int index = isLeave ? 5 : Get.find<ManagerRequestController>().currentTabIndex.value;
    if(index == 0 || index == 2) {
      employeeList = empList ?? [];
    } else if(index == 1) {
      punchApprovalList = approvalList ?? [];
    } else if(index == 3) {
      spcRequestList = requestList ?? [];
    } else if(index == 5) {
      empLeaveList = leaveList ?? [];
    }
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        Get.find<ManagerRequestController>().showReasonValidation.value = false;
      },
      child: SafeArea(
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
                        if(isLeave)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(width: 48.h, height: 48.h),
                              const Spacer(),
                              // Image.asset("assets/images/Hourglass-3d.webp", width: 35.h),
                              Image.asset(
                                "assets/images/manager_view/employee_leave_calendar.png",
                                height: 27.h,
                              ),
                              Text(
                                "Leave Request",
                                style: GoogleFonts.poppins(
                                  color: ColorUtils.workEntryHead,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15.h,
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
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
                          )
                        else
                          RegularizeTitle(
                            image: "assets/images/Hourglass-3d.webp",
                            title: index == 2 ? "Overtime" : "Regularize",
                            action: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        SizedBox(height: 20.h),
                        Expanded(
                          child: SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      backgroundColor: ColorUtils.textWhite,
                                      context: context,
                                      isScrollControlled: true,
                                      barrierColor: ColorUtils.workEntryHead
                                          .withValues(alpha: 0.5),
                                      constraints: BoxConstraints(
                                        maxHeight: ScreenUtil().screenHeight * 0.6,
                                      ),
                                      builder: (BuildContext context) {
                                        return SelectedEmployeesBottomSheet(
                                            empList: employeeList,
                                          approvalList: punchApprovalList,
                                          requestList: spcRequestList,
                                          leaveList: empLeaveList,
                                          isLeave: isLeave,
                                        );
                                      },
                                    );
                                  },
                                  child: _EmployeesSelected(isLeave: isLeave),
                                ),
                                SizedBox(height: 15.h),
                                ReasonTextField(
                                    requestType: RequestType.bulkApproval,
                                  fieldController: Get.find<ManagerRequestController>().remarksController,
                                ),
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
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).viewInsets.bottom +
                                      70.h,
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
              bottom: 0,
              right: 15.w,
              left: 15.w,
              child: Column(
                children: [
                  if(Get.find<ManagerRequestController>().currentTabIndex.value == 0)
                    ActionButtons(
                      cancelText: "Apply Fine",
                      okText: "Pardon",
                      action: (value) async {
                        ManagerRequestController requestController = Get.find<ManagerRequestController>();
                        requestController.validateRemarksField();
                        if(Get.find<ManagerRequestController>().remarksController.text.trim().isNotEmpty) {
                          String? result = await Get.find<ManagerRequestController>().submitForRegularization(
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
                    )
                  else
                    ActionButtons(
                      cancelText: "Reject",
                      okText: "Approve",
                      action: (value) async {
                        ManagerRequestController requestController = Get.find<ManagerRequestController>();
                        requestController.validateRemarksField();
                        if(requestController.remarksController.text.trim().isNotEmpty) {
                          if(requestController.currentTabIndex.value == 1) {
                            String? result = await requestController.submitPunchRequestUpdate(
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
                          if(requestController.currentTabIndex.value == 2) {
                            String? result = await requestController.submitOvertimeUpdate(
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
                          if(requestController.currentTabIndex.value == 3) {

                            String? result = await requestController.submitWfhLrRequestUpdate(
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
                          if(requestController.currentTabIndex.value == 5 || isLeave) {
                            String? result = await requestController.leaveRequestUpdate(
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
                        }
                      },
                    ),
                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 5.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SelectedEmployeesBottomSheet extends StatelessWidget {
  final List<Employees>? empList;
  final List<EmployeesApproval>? approvalList;
  final List<WfhLrData>? requestList;
  final List<EmployeeLeaveData>? leaveList;
  final bool isLeave;
  const SelectedEmployeesBottomSheet({super.key, this.empList, this.approvalList, this.requestList, this.leaveList, required this.isLeave});

  @override
  Widget build(BuildContext context) {
    List<Employees> employeeList = [];
    List<EmployeesApproval> punchApprovalList = [];
    List<WfhLrData> spcRequestList = [];
    List<EmployeeLeaveData> empLeaveList = [];
    int index = isLeave ? 5 : Get.find<ManagerRequestController>().currentTabIndex.value;
    if(index == 0 || index == 2) {
      employeeList = empList ?? [];
    } else if(index == 1) {
      punchApprovalList = approvalList ?? [];
    } else if(index == 3) {
      spcRequestList = requestList ?? [];
    } else if(index == 5) {
      empLeaveList = leaveList ?? [];
    }

    bool isCloseAll() {
      switch(index) {
        case 0: return Get.find<ManagerRequestController>().excuseList.value
            .expand((excuse) => excuse.employees ?? <Employees>[])
            .where((emp) => emp.isSelected == true)
            .toList().isEmpty;
        case 1: return Get.find<ManagerRequestController>().punchApprovalList
            .expand((punch) => punch.employees ?? <EmployeesApproval>[])
            .where((emp) => emp.isSelected == true)
            .toList().isEmpty;
        case 2: return Get.find<ManagerRequestController>().excuseList.value
            .expand((excuse) => excuse.employees ?? <Employees>[])
            .where((emp) => emp.isSelected == true)
            .toList().isEmpty;
        case 3: return Get.find<ManagerRequestController>().wfhLrListPending
            .where((emp) => emp.isSelected == true)
            .toList().isEmpty;
        case 5: return Get.find<ManagerRequestController>().employeeLeaveList
            .where((emp) => emp.isSelected == true)
            .toList().isEmpty;
        default: return false;
      }
    }

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
                title: index == 2 ? "Overtime" : "Regularize",
                  image: "assets/images/Hourglass-3d.webp",
                action: () {
                  if(isCloseAll()) {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  } else {
                    Navigator.of(context).pop();
                  }
                },
              ),
                  // Obx(() {
                  //     return RegularizeTitle(
                  //         title: "Regularize",
                  //       action: () {
                  //         Navigator.of(context).pop();
                  //         Navigator.of(context).pop();
                  //       },
                  //     );
                  //   }
                  // ),
                  SizedBox(height: 20.h),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          _EmployeesSelected(isLeave: isLeave),
                          SizedBox(height: 25.h),
                          _SelectedEmployeeTile(
                              empList: employeeList,
                            approvalList: punchApprovalList,
                            requestList: spcRequestList,
                            leaveList: empLeaveList,
                            isLeave: isLeave,
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

class _EmployeesSelected extends GetView<ManagerRequestController> {
  final bool isLeave;
  const _EmployeesSelected({required this.isLeave});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      int tabIndex = isLeave ? 5 : Get.find<ManagerRequestController>().currentTabIndex.value;
      List<Employees> selectedEmployees = [];
      List<EmployeesApproval> selectedEmployeesApproval = [];
      List<WfhLrData> selectedEmployeesRequest = [];
      List<EmployeeLeaveData> selectedEmployeesLeave = [];
      int loopCount = 0;

      if(tabIndex == 0 || tabIndex == 2) {
        if(controller.searchText.value.trim().isEmpty) {
          List<Employees> allEmployees = controller.excuseList
              .expand((excuse) => excuse.employees ?? <Employees>[])
              .toList();
          selectedEmployees = allEmployees.where((e) => e.isSelected == true).toList();
        } else {
          List<Employees> allEmployees = controller.excuseEmployeeList.value;
          selectedEmployees = allEmployees.where((e) => e.isSelected == true).toList();
        }
        loopCount = selectedEmployees.length;
      } else if(tabIndex == 1) {
        if(controller.searchText.value.trim().isEmpty) {
          List<EmployeesApproval> allEmployeesApproval = controller.punchApprovalList
              .expand((excuse) => excuse.employees ?? <EmployeesApproval>[])
              .toList();
          selectedEmployeesApproval = allEmployeesApproval.where((e) => e.isSelected == true).toList();
        } else {
          selectedEmployeesApproval = controller.punchApprovalEmployeeList.value.where((e) => e.isSelected == true).toList();
        }
        loopCount = selectedEmployeesApproval.length;
      } else if(tabIndex == 3) {
        List<WfhLrData> allEmployeesRequest = controller.wfhLrListPending.value;
        selectedEmployeesRequest = allEmployeesRequest.where((e) => e.isSelected == true).toList();
        loopCount = selectedEmployeesRequest.length;
      } else if(tabIndex == 5) {
        List<EmployeeLeaveData> allEmployeesLeave = controller.employeeLeaveList.value;
        selectedEmployeesLeave = allEmployeesLeave.where((e) => e.isSelected == true).toList();
        loopCount = selectedEmployeesLeave.length;
      }

      int getListLength() {
        switch(tabIndex) {
          case 0: return selectedEmployees.length;
          case 1: return selectedEmployeesApproval.length;
          case 2: return selectedEmployees.length;
          case 3: return selectedEmployeesRequest.length;
          case 5: return selectedEmployeesLeave.length;
          default: return 0;
        }
      }

      String getProfilePic(int i) {
        switch(tabIndex) {
          case 0: return selectedEmployees[i].profilePicture ?? '';
          case 1: return selectedEmployeesApproval[i].profilePicture ?? '';
          case 2: return selectedEmployees[i].profilePicture ?? '';
          case 3: return selectedEmployeesRequest[i].profilePicture ?? '';
          case 5: return selectedEmployeesLeave[i].profilePicture ?? '';
          default: return '';
        }
      }

      return Row(
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "$loopCount",
                  style: GoogleFonts.dmSans(
                    fontSize: 14.h,
                    fontWeight: FontWeight.w600,
                    color: ColorUtils.workEntryHead,
                  ),
                ),
                TextSpan(
                  text: " request selected",
                  // text: " ${loopCount == 1
                  //     ? 'employee selected'
                  //     : 'employees selected'}",
                  style: GoogleFonts.dmSans(
                    fontSize: 12.h,
                    fontWeight: FontWeight.w600,
                    color: ColorUtils.workEntryHead,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 5.h),
          SizedBox(
            width: 70.h,
            height: 40.h,
            child: Stack(
              children: [
                for (int i = 0; i < getListLength(); i++)
                  if (i < 3)
                    Positioned(
                      left: (i * 15).h,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        height: 29.h,
                        width: 29.h,
                        child: FittedBox(
                          child: AttendanceCommonWidgets().cachedNetworkImage(
                            getProfilePic(i),
                            height: 29.h,
                          ),
                        ),
                      ),
                    ),
              ],
            ),
          ),
        ],
      );
    },
    );
  }
}

class _SelectedEmployeeTile extends GetView<ManagerRequestController> {
  final List<Employees>? empList;
  final List<EmployeesApproval>? approvalList;
  final List<WfhLrData>? requestList;
  final List<EmployeeLeaveData>? leaveList;
  final bool isLeave;
  const _SelectedEmployeeTile({required this.isLeave, this.leaveList, this.requestList, this.empList, this.approvalList});

  @override
  Widget build(BuildContext context) {
    List<Employees> employeeList = [];
    List<EmployeesApproval> punchApprovalList = [];
    List<WfhLrData> spcRequestList = [];
    List<EmployeeLeaveData> empLeaveList = [];
    int index = isLeave ? 5 : Get.find<ManagerRequestController>().currentTabIndex.value;
    if(index == 0 || index == 2) {
      employeeList = empList ?? [];
    } else if(index == 1) {
      punchApprovalList = approvalList ?? [];
    } else if(index == 3) {
      spcRequestList = requestList ?? [];
    } else if(index == 5) {
      empLeaveList = leaveList ?? [];
    }
    int getCount() {
      switch(index) {
        case 0: return employeeList.length;
        case 1: return punchApprovalList.length;
        case 2: return employeeList.length;
        case 3: return spcRequestList.length;
        case 5: return empLeaveList.length;
        default: return 0;
      }
    }
    Color getColor(int i) {
      switch(index) {
        case 0: return controller.excuseList.value
            .expand((excuse) => excuse.employees ?? <Employees>[])
            .where((emp) => emp.isSelected == true)
            .toList().any((emp) => emp.employeeDailyAttendanceId == employeeList[i].employeeDailyAttendanceId) ? ColorUtils.secondaryBlue : ColorUtils.silverGrey;
        case 1: return controller.punchApprovalList.value
            .expand((excuse) => excuse.employees ?? <EmployeesApproval>[])
            .where((emp) => emp.isSelected == true)
            .toList().any((emp) => emp.employeeDailyAttendanceId == punchApprovalList[i].employeeDailyAttendanceId) ? ColorUtils.secondaryBlue : ColorUtils.silverGrey;
        case 2: return controller.excuseList.value
            .expand((excuse) => excuse.employees ?? <Employees>[])
            .where((emp) => emp.isSelected == true)
            .toList().any((emp) => emp.employeeDailyAttendanceId == employeeList[i].employeeDailyAttendanceId) ? ColorUtils.secondaryBlue : ColorUtils.silverGrey;
        case 3: return controller.wfhLrListPending.value
            .where((emp) => emp.isSelected == true)
            .toList().any((emp) => emp.specialRequestId == spcRequestList[i].specialRequestId) ? ColorUtils.secondaryBlue : ColorUtils.silverGrey;
        case 5: return controller.employeeLeaveList.value
            .where((emp) => emp.isSelected == true)
            .toList().any((emp) => emp.employeeLeaveApplicationId == empLeaveList[i].employeeLeaveApplicationId) ? ColorUtils.secondaryBlue : ColorUtils.silverGrey;
        default: return ColorUtils.silverGrey;
      }
    }

    bool getIsChecked(int i) {
      switch(index) {
        case 0: return controller.searchText.value.trim().isEmpty
            ? controller.excuseList.value
            .expand((excuse) => excuse.employees ?? <Employees>[])
            .where((emp) => emp.isSelected == true)
            .toList().any((emp) => emp.employeeDailyAttendanceId == employeeList[i].employeeDailyAttendanceId)
            : controller.excuseEmployeeList.value
            .where((emp) => emp.isSelected == true)
            .toList().any((emp) => emp.employeeDailyAttendanceId == employeeList[i].employeeDailyAttendanceId);
        case 1: return controller.searchText.value.trim().isEmpty
            ? controller.punchApprovalList.value
            .expand((excuse) => excuse.employees ?? <EmployeesApproval>[])
            .where((emp) => emp.isSelected == true)
            .toList().any((emp) => emp.employeeDailyAttendanceId == punchApprovalList[i].employeeDailyAttendanceId)
            : controller.punchApprovalEmployeeList.value
            .where((emp) => emp.isSelected == true)
            .toList().any((emp) => emp.employeeDailyAttendanceId == punchApprovalList[i].employeeDailyAttendanceId) ;
        case 2: return controller.searchText.value.trim().isEmpty
            ? controller.excuseList.value
            .expand((excuse) => excuse.employees ?? <Employees>[])
            .where((emp) => emp.isSelected == true)
            .toList().any((emp) => emp.employeeDailyAttendanceId == employeeList[i].employeeDailyAttendanceId)
            : controller.excuseEmployeeList.value
            .where((emp) => emp.isSelected == true)
            .toList().any((emp) => emp.employeeDailyAttendanceId == employeeList[i].employeeDailyAttendanceId);
        case 3: return controller.wfhLrListPending.value
            .where((emp) => emp.isSelected == true)
            .toList().any((emp) => emp.specialRequestId == spcRequestList[i].specialRequestId);
        case 5: return controller.employeeLeaveList.value
            .where((emp) => emp.isSelected == true)
            .toList().any((emp) => emp.employeeLeaveApplicationId == empLeaveList[i].employeeLeaveApplicationId);
        default: return false;
      }
    }

    String getProfileImage(int i) {
      switch(index) {
        case 0: return employeeList[i].profilePicture ?? '';
        case 1: return punchApprovalList[i].profilePicture ?? '';
        case 2: return employeeList[i].profilePicture ?? '';
        case 3: return spcRequestList[i].profilePicture ?? '';
        case 5: return empLeaveList[i].profilePicture ?? '';
        default: return '';
      }
    }

    String getEmployeeName(int i) {
      switch(index) {
        case 0: return employeeList[i].employeeName ?? '--';
        case 1: return punchApprovalList[i].employeeName ?? '--';
        case 2: return employeeList[i].employeeName ?? '--';
        case 3: return spcRequestList[i].employeeName ?? '--';
        case 5: return empLeaveList[i].employeeName ?? '--';
        default: return '--';
      }
    }

    String getEmployeeDesignation(int i) {
      switch(index) {
        case 0: return employeeList[i].employeeName ?? '--';
        case 1: return punchApprovalList[i].designation ?? '--';
        case 2: return employeeList[i].designation ?? '--';
        case 3: return spcRequestList[i].employeeDesignation ?? '--';
        case 5: return empLeaveList[i].designation ?? '--';
        default: return '--';
      }
    }

    return Column(
      children: [
        for (int i = 0; i < getCount(); i++)
          Column(
            children: [
              Row(
                children: [
                  Obx(() => CustomCheckbox(
                    size: 16.h,
                    iconSize: 12.h,
                    borderWidth: 0.5.h,
                    borderRadius:
                    BorderRadius.circular(5).r,
                    checkIcon: const Icon(
                      Icons.done_rounded,
                    ),
                    borderColor: getIsChecked(i) ? ColorUtils.secondaryBlue : ColorUtils.silverGrey,
                    selectedColor: ColorUtils.secondaryBlue,
                    isChecked: getIsChecked(i),
                    onChange: (bool? value) {
                      if(index == 0 || index == 2) {
                        Get.find<ManagerRequestController>().markSelectEmployee(employeeList[i].employeeDailyAttendanceId ?? '');
                        if(employeeList.length == 1) {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        }
                      } else if(index == 1) {
                        Get.find<ManagerRequestController>().markSelectEmployee(punchApprovalList[i].employeeDailyAttendanceId ?? '');
                        if(punchApprovalList.length == 1) {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        }
                      } else if(index == 3) {
                        Get.find<ManagerRequestController>().markSelectEmployee(spcRequestList[i].specialRequestId ?? '');
                        if(spcRequestList.length == 1) {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        }
                      } else if(index == 5) {
                        Get.find<ManagerRequestController>().markSelectEmployee(empLeaveList[i].employeeLeaveApplicationId ?? '');
                        if(empLeaveList.length == 1) {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        }
                      }
                    },
                  ),
                  ),
                  SizedBox(width: 8.h),
                  AttendanceCommonWidgets().cachedNetworkImage(
                    getProfileImage(i),
                  ),
                  SizedBox(width: 8.h),
                  Expanded(
                    child: AttendanceCommonWidgets().nameWithDesignation(
                      name: getEmployeeName(i),
                      designation: getEmployeeDesignation(i),
                    ),
                  ),
                  if(index == 0)
                    Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Late By",
                          style: GoogleFonts.poppins(
                            color: ColorUtils.pureRed,
                            fontWeight: FontWeight.w400,
                            fontSize: 11.h,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if(employeeList[i].status?.isNotEmpty ?? false)
                          Text(
                            employeeList[i].status?.first.timeDifference ?? '--',
                            style: GoogleFonts.inter(
                              color: ColorUtils.fieryScarlet,
                              fontWeight: FontWeight.w600,
                              fontSize: 11.h,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                ],
              ),
              Divider(
                color:
                i != (getCount() - 1)
                    ? ColorUtils.workEntryHead
                    .withValues(alpha: 0.1)
                    : Colors.transparent,
                height: 30.h,
                thickness: 1.h,
              ),
            ],
          ),
      ],
    );
  }
}

