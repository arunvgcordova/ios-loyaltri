import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Request/manager_request_controller/manager_request_controller.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Request/request_wigets_manager/regularize_bottomSheet_manager.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Request/request_wigets_manager/request_shimmer_widget.dart';
import 'package:loyaltri_minimal/utils/api_constants.dart';

import '../../../../models/manager/employee_excuseList_model.dart';
import '../../../../utils/color_utils.dart';
import '../../../Login/login_widgets/custom_check_box.dart';
import 'overtime_bottomSheet_manager.dart';

class EmployeeRequestDayCard extends StatelessWidget {
  final ExcuseData excuseData;
  const EmployeeRequestDayCard({super.key, required this.excuseData});

  @override
  Widget build(BuildContext context) {
    String date = '--';
    try {
      date = DateFormat('MMM dd, yyyy').format(DateTime.parse(excuseData.date!));
    } catch(e) {}
    bool isSelected = excuseData.employees?.every((element) => element.isSelected == true) ?? false;
    ManagerRequestController controller = Get.find<ManagerRequestController>();
    return Container(
      // padding: EdgeInsets.all(8).h,
      decoration: BoxDecoration(
        color: ColorUtils.paleLavenderMist,
        borderRadius: BorderRadius.circular(11).r,
        border: Border.all(color: ColorUtils.lightLavender, width: 1.h),
      ),
      child: Column(
        children: [
          SizedBox(height: 6.h),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.h),
            child: Row(
              children: [
                if(controller.filters.value[controller.currentTabIndex.value].filter == RequestFilterTypes.pending)
                  CustomCheckbox(
                    size: 16.h,
                    iconSize: 12.h,
                    borderWidth: 0.5.h,
                    borderRadius: BorderRadius.circular(5).r,
                    checkIcon: const Icon(Icons.done_rounded),
                    borderColor: isSelected
                        ? ColorUtils.secondaryBlue
                        : ColorUtils.silverGrey,
                    selectedColor: ColorUtils.secondaryBlue,
                    fillColor: ColorUtils.textWhite,
                    isChecked: isSelected,
                    onChange: (bool? value) {
                      for(Employees emp in excuseData.employees!) {
                        if(isSelected) {
                          Get.find<ManagerRequestController>().markSelectEmployee(emp.employeeDailyAttendanceId!, setBool: false);
                        } else {
                          Get.find<ManagerRequestController>().markSelectEmployee(emp.employeeDailyAttendanceId!, setBool: true);
                        }
                      }
                      // if(value == true) {
                      //   controller.selectedEmployeeList.value.addAll(excuseData.employees!);
                      // } else if(value == false) {
                      //   excuseData.employees?.forEach((employee) {
                      //     controller.selectedEmployeeList.value.removeWhere((emp) => emp.employeeDailyAttendanceId == employee.employeeDailyAttendanceId);
                      //   });
                      // }
                      // controller.selectedEmployeeList.refresh();
                    },
                  ),
                SizedBox(width: 5.h),
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
          SizedBox(height: 2.h),
          Column(
            children: [
              for(int i = 0; i < (excuseData.employees?.length ?? 0); i++)
                EmployeeRequestCard(employee: excuseData.employees?[i]),
            ],
          ),
        ],
      ),
    );
  }
}

class EmployeeRequestCard extends GetView<ManagerRequestController> {
  final Employees? employee;
  const EmployeeRequestCard({super.key, this.employee});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 5.h,
        right: 4.h,
        left: 4.h,
      ),
      child: Container(
        padding: EdgeInsets.all(6).h,
        decoration: BoxDecoration(
          color: ColorUtils.textWhite,
          borderRadius: BorderRadius.circular(8).r,
          border: Border.all(
            color: (employee?.isSelected ?? false) ? Color(0xFFA5A3FF) : ColorUtils.workEntryHead.withValues(alpha: 0.1),
            width: 1.h,
          ),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AttendanceCommonWidgets().cachedNetworkImage(employee?.profilePicture ?? ''),
                // Image.asset("assets/examples/user_request.png", height: 32.h),
                SizedBox(width: 8.h),
                Expanded(
                  child: AttendanceCommonWidgets().nameWithDesignation(name: employee?.employeeName ?? '--', designation: employee?.designation ?? '--'),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 3.h,
                        horizontal: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: controller.statusColor().withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16).r,
                      ),
                      child: Text(
                        controller.statusTitle(),
                        style: GoogleFonts.inter(
                          fontSize: 11.h,
                          fontWeight: FontWeight.w500,
                          color: controller.statusColor(),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.h),
                    if(controller.filters.value[controller.currentTabIndex.value].filter == RequestFilterTypes.pending)
                      CustomCheckbox(
                        size: 17.h,
                        iconSize: 12.h,
                        borderWidth: 0.5.h,
                        borderRadius: BorderRadius.circular(5).r,
                        checkIcon: const Icon(Icons.done_rounded),
                        borderColor: employee?.isSelected ?? false
                            ? ColorUtils.secondaryBlue
                            : ColorUtils.silverGrey,
                        selectedColor: ColorUtils.secondaryBlue,
                        isChecked: employee?.isSelected ?? false,
                        onChange: (bool? value) {
                          controller.markSelectEmployee(employee?.employeeDailyAttendanceId ?? '');
                        },
                      ),
                  ],
                ),
              ],
            ),
            Divider(color: ColorUtils.softGrey, thickness: 1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AttendanceCommonWidgets().checkInTime(employee?.firstCheckInTime ?? '--'),
                Container(width: 1.h, height: 15.h, color: ColorUtils.paleSilver),
                AttendanceCommonWidgets().checkOutTime(employee?.lastCheckOutTime ?? '--'),
                Container(width: 1.h, height: 15.h, color: ColorUtils.paleSilver),
                Padding(
                  padding: EdgeInsets.only(right: 5.h),
                  child: AttendanceCommonWidgets().workedHours(employee?.totalWorkHours ?? '--'),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            Align(
              alignment: Alignment.centerLeft,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for(int i = 0; i < (employee?.status?.length ?? 0); i++)
                      InkWell(
                        borderRadius: BorderRadius.circular(6).r,
                        onTap: () async {
                          // if(controller.currentTabIndex.value != 2) {
                          ApiConstants apiConstants = ApiConstants();
                            controller.fetchEmployeeDeductionDetails(
                                dedId: employee?.status?[i].employeeAttendanceDeductionId ??'',
                                action: controller.currentTabIndex.value == 2 ? apiConstants.getEmployeeAttendanceOverTimeById : apiConstants.deductionDetailsAction,
                            );

                          final selectedId = employee?.employeeDailyAttendanceId;

                          if(controller.searchText.value.trim().isEmpty) {
                            for (var element in controller.excuseList) {
                              for(Employees? emp in (element.employees ?? [])) {
                                emp?.isSelected = emp.employeeDailyAttendanceId == selectedId;
                              }
                            }
                            controller.excuseList.refresh();
                          } else {
                            for (var element in controller.excuseEmployeeList) {
                              element.isSelected = element.employeeDailyAttendanceId == selectedId;
                            }
                            controller.excuseEmployeeList.refresh();
                          }

                            await showModalBottomSheet(
                              backgroundColor: ColorUtils.textWhite,
                              context: context,
                              isScrollControlled: true,
                              barrierColor: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                              useSafeArea: true,
                              // constraints: BoxConstraints(
                              //   maxHeight: ScreenUtil().screenHeight * 0.7,
                              // ),
                              builder: (BuildContext context) {
                                // employee?.isSelected = true;
                                return Obx(() {
                                  // final controller = Get.find<ManagerRequestController>();
                                  bool isMissPunch = (employee?.status?[i].excuseType ?? '').toLowerCase().replaceAll(' ', '') == "misspunch";
                                  return controller.bottomsheetloaded.value
                                      ? RegularizationBottomSheetManager(employee: employee)
                                      : BottomSheetShimmer(isMissPunch: isMissPunch);
                                });
                              },
                            ).then((value) {
                              // employee?.isSelected = false;
                              controller.reasonController.text = '';
                              controller.remarksController.text = '';
                              controller.showReasonValidation.value = false;
                              if(controller.searchText.value.trim().isEmpty) {
                                for (var element in controller.excuseList) {
                                  for(Employees? emp in (element.employees ?? [])) {
                                    emp?.isSelected = false;
                                    controller.excuseList.refresh();
                                  }
                                }
                              } else {
                                for (var element in controller.excuseEmployeeList) {
                                  if(element.employeeDailyAttendanceId == selectedId) {
                                    element.isSelected = false;
                                    controller.excuseEmployeeList.refresh();
                                    break;
                                  }
                                }
                              }
                            });
                          // } else {
                          //   await showModalBottomSheet(
                          //     backgroundColor: ColorUtils.textWhite,
                          //     context: context,
                          //     isScrollControlled: true,
                          //     barrierColor: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                          //     // constraints: BoxConstraints(
                          //     //   maxHeight: ScreenUtil().screenHeight * 0.7,
                          //     // ),
                          //     builder: (BuildContext context) {
                          //       employee?.isSelected = true;
                          //       return OvertimeBottomSheetManager(employee: employee);
                          //     },
                          //   ).then((value) {
                          //     employee?.isSelected = false;
                          //     controller.reasonController.text = '';
                          //   });
                          // }
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: 8.h),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6).r,
                              border: Border.all(
                                color: ColorUtils.deepViolet.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Row(
                              children: [
                                if((employee?.status?[i].excuseType ?? '').toLowerCase().replaceAll(' ', '') == "misspunch")
                                  Container(
                                    width: 32.h,
                                    height: 25.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6).r,
                                      gradient: LinearGradient(
                                        colors: [ColorUtils.eb2, ColorUtils.eb1],
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "MP",
                                        style: GoogleFonts.inter(
                                          fontSize: 13.h,
                                          fontWeight: FontWeight.w400,
                                          color: ColorUtils.textWhite,
                                        ),
                                      ),
                                    ),
                                  )
                                else if((employee?.status?[i].excuseType ?? '').toLowerCase().replaceAll(' ', '') == "lateentry")
                                  Container(
                                    width: 32.h,
                                    height: 25.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6).r,
                                      gradient: LinearGradient(
                                        colors: [ColorUtils.lf2, ColorUtils.lf1],
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "LE",
                                        style: GoogleFonts.inter(
                                          fontSize: 13.h,
                                          fontWeight: FontWeight.w400,
                                          color: ColorUtils.textWhite,
                                        ),
                                      ),
                                    ),
                                  )
                                else if((employee?.status?[i].excuseType ?? '').toLowerCase().replaceAll(' ', '') == "earlyexit")
                                    Container(
                                      width: 32.h,
                                      height: 25.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6).r,
                                        gradient: LinearGradient(
                                          colors: [ColorUtils.ee2, ColorUtils.ee1],
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "EE",
                                          style: GoogleFonts.inter(
                                            fontSize: 13.h,
                                            fontWeight: FontWeight.w400,
                                            color: ColorUtils.textWhite,
                                          ),
                                        ),
                                      ),
                                    )
                                else if((employee?.status?[i].excuseType ?? '').toLowerCase().replaceAll(' ', '') == "overtime")
                                    Container(
                                      width: 32.h,
                                      height: 25.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6).r,
                                        gradient: LinearGradient(
                                          colors: [
                                            ColorUtils.ot1,
                                            ColorUtils.ot2,
                                          ],
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "OT",
                                          style: GoogleFonts.inter(
                                            fontSize: 13.h,
                                            fontWeight: FontWeight.w400,
                                            color: ColorUtils.textWhite,
                                          ),
                                        ),
                                      ),
                                    )
                                  else
                                    Container(
                                      width: 32.h,
                                      height: 25.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6).r,
                                        gradient: LinearGradient(
                                          colors: [ColorUtils.electricAqua, ColorUtils.aquaGreen],
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          getInitials(employee?.status?[i].excuseType),
                                          style: GoogleFonts.inter(
                                          fontSize: 13.h,
                                          fontWeight: FontWeight.w400,
                                          color: ColorUtils.textWhite,
                                        ),
                                        ),
                                      ),
                                    ),
                                SizedBox(width: 5.w),
                                Text(
                                  employee?.status?[i].timeDifference ?? '--',
                                  style: GoogleFonts.inter(
                                    fontSize: 12.h,
                                    fontWeight: FontWeight.w500,
                                    color: ColorUtils.workEntryHead,
                                  ),
                                ),
                                SizedBox(width: 5.w),
                              ],
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getInitials(String? excuseType) {
    if (excuseType == null || excuseType.trim().isEmpty) return "--";
    List<String> words = excuseType.trim().split(RegExp(r"\s+"));
    if (words.length == 1) return words[0][0].toUpperCase();
    return "${words[0][0].toUpperCase()}${words[1][0].toUpperCase()}";
  }
}
