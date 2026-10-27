
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/ManagerView/Employee_Leave/create_leave_request.dart';
import 'package:loyaltri_minimal/View/ManagerView/Employee_Leave/employee_leave_controller/employee_leave_controller.dart';
import 'package:loyaltri_minimal/View/ManagerView/Employee_Leave/leave_widgets_manager/employee_leave_actionRow.dart';
import 'package:loyaltri_minimal/View/ManagerView/Employee_Leave/leave_widgets_manager/employee_leave_card.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Request/request_wigets_manager/request_shimmer_widget.dart';
import 'package:loyaltri_minimal/controller/leaveTypeController.dart';
import 'package:loyaltri_minimal/models/detailed_attendance_api_model.dart';
import '../../../models/manager/leave_request_list_model.dart';
import '../../../utils/color_utils.dart';
import '../../CWidgets/cwidgets.dart';
import '../Manager_Attendance/manager_attendance_controller/manager_attendance_controller.dart';
import '../Manager_Request/manager_request_controller/manager_request_controller.dart';
import '../Manager_Request/request_wigets_manager/bulk_regularization_bottomSheet.dart';
import '../Manager_Request/request_wigets_manager/searchAndFilter.dart';
import 'leave_widgets_manager/employee_leave_appBar.dart';

class EmployeeLeavePage extends StatelessWidget {
  const EmployeeLeavePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        top: false,
        left: false,
        right: false,
        bottom: true,
        child: Scaffold(
          backgroundColor: ColorUtils.textWhite,
          body: Stack(
            children: [
              Container(
                height: ScreenUtil().screenHeight,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      ColorUtils.lavenderPurple,
                      ColorUtils.lavenderMist,
                      Color(0xFFF2F2F2),
                      Color(0xFFF2F2F2),
                      Color(0xFFF2F2F2),
                      Color(0xFFF2F2F2),
                      Color(0xFFF2F2F2),
                      Color(0xFFF2F2F2),
                      ColorUtils.whiteSmoke,
                      ColorUtils.whiteSmoke,
                      ColorUtils.whiteSmoke,
                      ColorUtils.whiteSmoke,
                      ColorUtils.whiteSmoke,
                      ColorUtils.whiteSmoke,
                    ],
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 15.h,
                    left: 15.w,
                    right: 15.w,
                    bottom: 10.h,
                  ),
                  child: RefreshIndicator(
                    onRefresh: () async {
                      EmployeeLeaveController employeeLeaveController = Get.find<EmployeeLeaveController>();
                      // employeeLeaveController.resetValues();
                      await employeeLeaveController.fetchEmployeeLeaveList();
                    },
                    child: Column(
                      children: [
                        ManagerScreensAppBar(
                          title: "Employee Leave",
                          icon: "assets/images/manager_view/employee_leave_calendar.png",
                          cancelAction: () {
                            Navigator.of(context).pop();
                          },
                          okAction: () {
                            Get.find<LeaveTypeController>().leaveTypeList.value = [];
                            Navigator.of(context).push(
                              newSlideFromBottomNavigation(CreateEmployeeLeave()),
                            );
                          },
                        ),
                        SizedBox(height: 15.h),
                        EmployeeLeaveActionRow(),
                        SizedBox(height: 15.h),
                        SearchAndFilter(
                          filterPage: FilterPage.leave,
                            color: ColorUtils.textWhite,
                          result: (value) {
                            Get.find<EmployeeLeaveController>().searchText.value = value;
                              Get.find<EmployeeLeaveController>().filterByName(value: value);
                          },
                          showFilter: false,
                          isDarkMode: false,
                        ),
                        SizedBox(height: 15.h),
                        Expanded(
                          child: GetX<EmployeeLeaveController>(
                            builder: (EmployeeLeaveController controller) {
                              List<EmployeeLeaveData> allLeaves = controller.employeeAllLeaveList.value;
                              List<EmployeeLeaveData> pendingLeaves = controller.employeePendingLeaveList.value;
                              List<EmployeeLeaveData> approvedLeaves = controller.employeeApprovedLeaveList.value;
                              List<EmployeeLeaveData> rejectedLeaves = controller.employeeRejectedLeaveList.value;
                              return IndexedStack(
                                index: controller.currentTabIndex.value,
                                children: [
                                  if(pendingLeaves.isEmpty && !controller.leaveListLoading.value)
                                    LeaveEmptyView(requestType: LeaveRequestType.pending)
                                  else
                                    ListView.builder(
                                      itemCount: controller.leaveListLoading.value ? 10 : pendingLeaves.length,
                                      itemBuilder: (context, index) {
                                        if(controller.leaveListLoading.value) {
                                          return LeaveRequestPageCardShimmer();
                                        } else {
                                          return EmployeeLeaveCard(employeeLeaveData: pendingLeaves[index]);
                                        }
                                      },
                                    ),
                                  if(rejectedLeaves.isEmpty && !controller.leaveListLoading.value)
                                    LeaveEmptyView(requestType: LeaveRequestType.rejected)
                                  else
                                    ListView.builder(
                                      itemCount: controller.leaveListLoading.value ? 10 : rejectedLeaves.length,
                                      itemBuilder: (context, index) {
                                        if(controller.leaveListLoading.value) {
                                          return LeaveRequestPageCardShimmer();
                                        } else {
                                          return EmployeeLeaveCard(employeeLeaveData: rejectedLeaves[index]);
                                        }
                                      },
                                    ),
                                  if(approvedLeaves.isEmpty && !controller.leaveListLoading.value)
                                    LeaveEmptyView(requestType: LeaveRequestType.approved)
                                  else
                                    ListView.builder(
                                      itemCount: controller.leaveListLoading.value ? 10 : approvedLeaves.length,
                                      itemBuilder: (context, index) {
                                        if(controller.leaveListLoading.value) {
                                          return LeaveRequestPageCardShimmer();
                                        } else {
                                          return EmployeeLeaveCard(employeeLeaveData: approvedLeaves[index]);
                                        }
                                      },
                                    ),
                                  if(allLeaves.isEmpty && !controller.leaveListLoading.value)
                                    LeaveEmptyView(requestType: LeaveRequestType.all)
                                  else
                                    ListView.builder(
                                      itemCount: controller.leaveListLoading.value ? 10 : allLeaves.length,
                                      itemBuilder: (context, index) {
                                        if(controller.leaveListLoading.value) {
                                          return LeaveRequestPageCardShimmer();
                                        } else {
                                          return EmployeeLeaveCard(employeeLeaveData: allLeaves[index]);
                                        }
                                      },
                                    ),
                                ],
                              );
                            }
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: GetX<EmployeeLeaveController>(
            builder: (EmployeeLeaveController controller) {
              List<EmployeeLeaveData> leaveList = [];
              leaveList = controller.employeePendingLeaveList
                  .where((request) => (request.requestStatusName.toString().toLowerCase() == 'pending' && request.isSelected == true))
                  .toList();

              if (leaveList.isNotEmpty) {
                return Container(
                  height: 70.h,
                  padding: EdgeInsets.symmetric(horizontal: 15.h),
                  decoration: BoxDecoration(
                    color: ColorUtils.textWhite,
                    border: Border(
                      top: BorderSide(color: ColorUtils.cloudGrey, width: 1.h),
                    ),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        spreadRadius: 5,
                        color: ColorUtils.stoneGrey.withValues(alpha: 0.1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Text(
                        leaveList.length.toString().padLeft(2, '0'),
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 13.h,
                          color: ColorUtils.secondaryBlue,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          " Request Selected",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.h,
                            color: ColorUtils.secondaryBlue,
                          ),
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(37).r,
                        onTap: () async {
                          await showModalBottomSheet(
                            backgroundColor: ColorUtils.textWhite,
                            context: context,
                            isScrollControlled: true,
                            barrierColor: ColorUtils.workEntryHead.withValues(
                              alpha: 0.5,
                            ),
                            // constraints: BoxConstraints(
                            //   maxHeight: ScreenUtil().screenHeight * 0.5,
                            // ),
                            builder: (BuildContext context) {
                              Get.find<ManagerRequestController>().currentTabIndex.value = 5;
                              Get.find<ManagerRequestController>().employeeLeaveList.value = controller.employeePendingLeaveList.value;
                              return BulkRegularizationBottomSheetManager(
                                leaveList: leaveList,
                                isLeave: true,
                              );
                            },
                          ).then((value) {
                            Get.find<ManagerRequestController>().reasonController.text = '';
                            Get.find<ManagerRequestController>().remarksController.text = '';
                            Get.find<ManagerRequestController>().showReasonValidation.value = false;
                          });
                        },
                        child: Container(
                          height: 50.h,
                          padding: EdgeInsets.symmetric(horizontal: 20.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(37).r,
                            color: ColorUtils.secondaryBlue,
                          ),
                          child: Center(
                            child: Row(
                              children: [
                                Text(
                                  "Choose Action",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14.h,
                                    fontWeight: FontWeight.w500,
                                    color: ColorUtils.textWhite,
                                  ),
                                ),
                                SizedBox(width: 8.h),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: ColorUtils.textWhite,
                                  size: 16.h,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }
}

enum LeaveRequestType {pending, approved, rejected, all}

class LeaveEmptyView extends StatelessWidget {
  final LeaveRequestType requestType;
  const LeaveEmptyView({super.key, required this.requestType});

  @override
  Widget build(BuildContext context) {
    String viewItem = '';

    if(requestType == LeaveRequestType.pending) {
      viewItem = "Approval";
    } else if(requestType == LeaveRequestType.approved) {
      viewItem = "Approved";
    } else if(requestType == LeaveRequestType.rejected) {
      viewItem = "Rejected";
    } else if(requestType == LeaveRequestType.all) {
      viewItem = "";
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight, // Fill remaining space
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 50.w,
                  right: 50.w,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFF1F0F7),
                            Color(0xFFF8F8F8),
                          ],
                        ),
                      ),
                      padding: EdgeInsets.all(30.h),
                      child: Image.asset(
                        "assets/images/manager_view/empty_request.png",
                        height: 37.h,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      "No Leave $viewItem Request",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w600,
                        color: ColorUtils.workEntryHead,
                        fontSize: 15.h,
                      ),
                    ),
                    // SizedBox(height: 5.h),
                    Text(
                      "Leave $viewItem request data is not available.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w400,
                        color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                        fontSize: 12.h,
                      ),
                    ),
                    SizedBox(height: 50.h),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
