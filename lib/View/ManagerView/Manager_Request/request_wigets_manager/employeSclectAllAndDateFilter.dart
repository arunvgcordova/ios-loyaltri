import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Request/manager_request_controller/manager_request_controller.dart';
import 'package:loyaltri_minimal/models/manager/employee_excuseList_model.dart';
import '../../../../models/manager/leave_request_list_model.dart';
import '../../../../models/manager/punch_approval_list_model.dart';
import '../../../../models/manager/wfh_lr_list_model.dart';
import '../../../../utils/color_utils.dart';
import '../../../Login/login_widgets/custom_check_box.dart';

class EmployeeSelectAllAndDateFilter extends GetView<ManagerRequestController> {
  final bool dateOnly;
  const EmployeeSelectAllAndDateFilter({super.key, required this.dateOnly});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // bool isSelected = controller.selectedEmployeeList.value == controller.allExcuseEmployeeList.value;
      // bool isSelected = false;
      // print("--------isSelected--------$isSelected");
      // print("--------selectedEmployeeList--------${controller.selectedEmployeeList.value.length}");
      // print("--------excuseEmployeeListAll--------${controller.allExcuseEmployeeList.value.length}");
      ManagerRequestController managerReqController = Get.find<ManagerRequestController>();
      bool? isSelected;
      int? requestListCount;
      if(managerReqController.currentTabIndex.value == 0) {
        if(controller.searchText.value.trim().isEmpty) {
          if(managerReqController.excuseList.value.isNotEmpty) {
            isSelected = managerReqController.excuseList.value.every((excuse) => excuse.employees?.every((emp) => emp.isSelected == true) ?? false);
          } else {
            isSelected = null;
          }
        } else {
          if(managerReqController.excuseEmployeeList.value.isNotEmpty) {
            isSelected = managerReqController.excuseEmployeeList.value.every((emp) => emp.isSelected == true);
          } else {
            isSelected = null;
          }
        }
      } else if(managerReqController.currentTabIndex.value == 1) {
        if(controller.searchText.value.trim().isEmpty) {
          if(managerReqController.punchApprovalList.value.isNotEmpty) {
            isSelected = managerReqController.punchApprovalList.value.every((excuse) => excuse.employees?.every((emp) => emp.isSelected == true) ?? false);
          } else {
            isSelected = null;
          }
        } else {
          if(managerReqController.punchApprovalEmployeeList.value.isNotEmpty) {
            isSelected = managerReqController.punchApprovalEmployeeList.value.every((excuse) => excuse.isSelected == true);
          } else {
            isSelected = null;
          }
        }
      } else if(managerReqController.currentTabIndex.value == 2) {
        if(controller.searchText.value.trim().isEmpty) {
          if(managerReqController.excuseList.value.isNotEmpty) {
            isSelected = managerReqController.excuseList.value.every((excuse) => excuse.employees?.every((emp) => emp.isSelected == true) ?? false);
          } else {
            isSelected = null;
          }
        } else {
          if(managerReqController.excuseEmployeeList.value.isNotEmpty) {
            isSelected = managerReqController.excuseEmployeeList.value.every((emp) => emp.isSelected == true);
          } else {
            isSelected = null;
          }
        }
      } else if(managerReqController.currentTabIndex.value == 3 || managerReqController.currentTabIndex.value == 4) {
        if(managerReqController.wfhLrListPending.value.isNotEmpty) {
          isSelected = managerReqController.wfhLrListPending.value.every((emp) => emp.isSelected == true ?? false);
          List<WfhLrData> requestList = managerReqController.wfhLrListPending
              .where((request) => (request.requestStatusName.toString().toLowerCase() == 'pending'))
              .toList();
          requestListCount = requestList.length;
        } else {
          isSelected = null;
        }
      } else if(managerReqController.currentTabIndex.value == 5) {
        if(managerReqController.employeeLeaveList.value.isNotEmpty) {
          isSelected = managerReqController.employeeLeaveList.value.where((emp) => emp.requestStatusName.toString().toLowerCase() == 'pending')
          .toList().every((emp) => emp.isSelected == true);
          List<EmployeeLeaveData> requestList = managerReqController.employeeLeaveList
              .where((request) => (request.requestStatusName.toString().toLowerCase() == 'pending'))
              .toList();
          requestListCount = requestList.length;
        } else {
          isSelected = null;
        }
      }
        return Row(
          children: [
            if (!dateOnly)
              if((controller.filters.value[controller.currentTabIndex.value].filter == RequestFilterTypes.pending && controller.currentTabIndex.value == 0 && controller.excuseList.value.isNotEmpty) || (controller.filters.value[controller.currentTabIndex.value].filter == RequestFilterTypes.pending && controller.currentTabIndex.value == 2 && controller.excuseList.value.isNotEmpty) || (controller.filters.value[controller.currentTabIndex.value].filter == RequestFilterTypes.pending && controller.currentTabIndex.value == 1 && controller.punchApprovalList.value.isNotEmpty) || (controller.filters.value[controller.currentTabIndex.value].filter == RequestFilterTypes.pending && (controller.currentTabIndex.value == 3) && controller.wfhLrListPending.value.isNotEmpty) || (controller.filters.value[controller.currentTabIndex.value].filter == RequestFilterTypes.pending && controller.currentTabIndex.value == 5 && controller.employeeLeaveList.value.isNotEmpty) || (controller.currentTabIndex.value != 0 && controller.currentTabIndex.value != 1 && controller.currentTabIndex.value != 2 && controller.currentTabIndex.value != 3 && controller.currentTabIndex.value != 4 && controller.currentTabIndex.value != 5))
                Expanded(
                  child: Row(
                    children: [
                      CustomCheckbox(
                        size: 16.h,
                        iconSize: 12.h,
                        borderRadius: BorderRadius.circular(5).r,
                        checkIcon: const Icon(Icons.done_rounded),
                        borderColor:
                        isSelected ?? false
                            ? ColorUtils.secondaryBlue
                            : ColorUtils.silverGrey,
                        selectedColor: ColorUtils.secondaryBlue,
                        isChecked: isSelected ?? false,
                        onChange: (bool? value) {
                          if(managerReqController.currentTabIndex.value == 0 || managerReqController.currentTabIndex.value == 2) {
                            if(controller.searchText.value.trim().isEmpty) {
                              for (var excuse in managerReqController.excuseList.value) {
                                for (Employees emp in excuse.employees ?? []) {
                                  if(isSelected ?? false) {
                                    managerReqController.markSelectEmployee(emp.employeeDailyAttendanceId!, setBool: false);
                                  } else {
                                    managerReqController.markSelectEmployee(emp.employeeDailyAttendanceId!, setBool: true);
                                  }
                                }
                              }
                            } else {
                              for (var emp in managerReqController.excuseEmployeeList.value) {
                                if(isSelected ?? false) {
                                  managerReqController.markSelectEmployee(emp.employeeDailyAttendanceId!, setBool: false);
                                } else {
                                  managerReqController.markSelectEmployee(emp.employeeDailyAttendanceId!, setBool: true);
                                }
                              }
                            }
                          } else if(managerReqController.currentTabIndex.value == 1) {
                            if(controller.searchText.value.trim().isEmpty) {
                              for (var excuse in managerReqController.punchApprovalList.value) {
                                for (EmployeesApproval emp in excuse.employees ?? []) {
                                  if(isSelected ?? false) {
                                    managerReqController.markSelectEmployee(emp.employeeDailyAttendanceId!, setBool: false);
                                  } else {
                                    managerReqController.markSelectEmployee(emp.employeeDailyAttendanceId!, setBool: true);
                                  }
                                }
                              }
                            } else {
                              for (var emp in managerReqController.punchApprovalEmployeeList.value) {
                                if(isSelected ?? false) {
                                  managerReqController.markSelectEmployee(emp.employeeDailyAttendanceId!, setBool: false);
                                } else {
                                  managerReqController.markSelectEmployee(emp.employeeDailyAttendanceId!, setBool: true);
                                }
                              }
                            }
                          } else if(managerReqController.currentTabIndex.value == 3) {
                            for (var request in managerReqController.wfhLrListPending.value) {
                              if(isSelected ?? false) {
                                managerReqController.markSelectEmployee(request.specialRequestId!, setBool: false);
                              } else {
                                managerReqController.markSelectEmployee(request.specialRequestId!, setBool: true);
                              }
                            }
                          } else if(managerReqController.currentTabIndex.value == 5) {
                            for (var request in managerReqController.employeeLeaveList.value) {
                              if(isSelected ?? false) {
                                managerReqController.markSelectEmployee(request.employeeLeaveApplicationId!, setBool: false);
                              } else {
                                managerReqController.markSelectEmployee(request.employeeLeaveApplicationId!, setBool: true);
                              }
                            }
                          }
                          // if(value!) {
                          //   controller.selectedEmployeeList.value = controller.allExcuseEmployeeList.value;
                          // } else {
                          //   controller.selectedEmployeeList.value = [];
                          // }
                          // controller.selectedEmployeeList.refresh();
                        },
                      ),
                      SizedBox(width: 6.h),
                      Expanded(
                        child: Text(
                          isSelected ?? false
                              ? "Select all"
                              : "Select all employees",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 12.h,
                            fontWeight: FontWeight.w400,
                            color:
                            isSelected ?? false
                                ? ColorUtils.secondaryBlue
                                : ColorUtils.workEntryHead.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Expanded(child: SizedBox())
            else
              Expanded(child: SizedBox()),
            Row(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(10).r,
                  onTap: () async {
                    if (controller.currentMonthIndex.value !=
                        (controller.monthString.length - 1)) {
                      try {
                        // context.loaderOverlay.show();
                        controller.currentMonthIndex.value += 1;
                        String switchedDate = controller.monthString[controller.currentMonthIndex.value];
                        if(controller.currentTabIndex.value == 0) {
                          if(controller.filters.value[controller.currentTabIndex.value].filter == RequestFilterTypes.pending) {
                            await controller.fetchExcuseList(monthYear: switchedDate);
                          } else {
                            await controller.fetchExcuseListFilter(monthYear: switchedDate);
                          }
                        }
                        if(controller.currentTabIndex.value == 1) {
                          await controller.fetchPunchApprovalReqList(monthYr: switchedDate);
                        }
                        if(controller.currentTabIndex.value == 2) {
                          await controller.fetchOvertimeList(monthYear: switchedDate);
                        }
                        if(controller.currentTabIndex.value == 3 || controller.currentTabIndex.value == 4) {
                          await controller.fetchWfhOrLrList(monthYr: switchedDate);
                        }
                        if(controller.currentTabIndex.value == 5) {
                          await controller.fetchEmployeeLeaveList(monthYr: switchedDate);
                        }
                      } catch(e) {} finally {
                        // context.loaderOverlay.hide();
                      }
                    }
                  },
                  child: Container(
                    width: 32.h,
                    height: 32.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10).r,
                      border: Border.all(
                        width: 1.h,
                        color: ColorUtils.workEntryHead.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        "assets/images/manager_view/arrow_left_month_select.svg",
                        height: 10.h,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.h),
                GetX<ManagerRequestController>(
                  builder: (ManagerRequestController controller) {
                    return SvgPicture.asset(
                      controller.currentTabIndex.value == 0
                          ? "assets/images/manager_view/month_select_manager.svg"
                          : "assets/images/manager_view/punch_approval_month.svg",
                      height: 12.h,
                    );
                  },
                ),
                SizedBox(width: 5.h),
                Text(
                  controller.monthString[controller.currentMonthIndex.value],
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 11.h,
                    color: ColorUtils.workEntryHead,
                  ),
                ),
                SizedBox(width: 8.h),
                InkWell(
                  borderRadius: BorderRadius.circular(10).r,
                  onTap: () async {
                    if (controller.currentMonthIndex.value != 0) {
                      controller.currentMonthIndex.value -= 1;
                      try {
                        // context.loaderOverlay.show();
                        String switchedDate = controller.monthString[controller.currentMonthIndex.value];
                        if(controller.currentTabIndex.value == 0) {
                          if(controller.filters.value[controller.currentTabIndex.value].filter == RequestFilterTypes.pending) {
                            await controller.fetchExcuseList(monthYear: switchedDate);
                          } else {
                            await controller.fetchExcuseListFilter(monthYear: switchedDate);
                          }
                        }
                        if(controller.currentTabIndex.value == 1) {
                          await controller.fetchPunchApprovalReqList(monthYr: switchedDate);
                        }
                        if(controller.currentTabIndex.value == 2) {
                          await controller.fetchOvertimeList(monthYear: switchedDate);
                        }
                        if(controller.currentTabIndex.value == 3 || controller.currentTabIndex.value == 4) {
                          await controller.fetchWfhOrLrList(monthYr: switchedDate);
                        }
                        if(controller.currentTabIndex.value == 5) {
                          await controller.fetchEmployeeLeaveList(monthYr: switchedDate);
                        }
                      } catch(e) {} finally {
                        // context.loaderOverlay.hide();
                      }
                    }
                  },
                  child: Container(
                    width: 32.h,
                    height: 32.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10).r,
                      border: Border.all(
                        width: 1.h,
                        color: ColorUtils.workEntryHead.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Center(
                      child: Transform.rotate(
                        angle: 180 * (pi / 180),
                        child: SvgPicture.asset(
                          "assets/images/manager_view/arrow_left_month_select.svg",
                          height: 10.h,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
