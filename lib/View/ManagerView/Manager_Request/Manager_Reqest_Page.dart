import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/manager_attendance_controller/manager_attendance_controller.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Home/manager_home_controller/manager_home_controller.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_More/more_widgets_manager/app_bar.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Request/request_wigets_manager/bulk_regularization_bottomSheet.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Request/request_wigets_manager/employeSclectAllAndDateFilter.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Request/request_wigets_manager/employee_request_day_card.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Request/request_wigets_manager/leave_request_card.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Request/request_wigets_manager/letter_request_card.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Request/request_wigets_manager/punch_approval_day_card.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Request/request_wigets_manager/request_action_row.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Request/request_wigets_manager/request_app_bar.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Request/request_wigets_manager/request_shimmer_widget.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Request/request_wigets_manager/searchAndFilter.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Request/request_wigets_manager/work_from_home_bottomSheet.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Request/request_wigets_manager/work_from_home_card.dart';
import 'package:loyaltri_minimal/models/manager/employee_excuseList_model.dart';
import '../../../controller/userProfileController.dart';
import '../../../models/manager/leave_request_list_model.dart';
import '../../../models/manager/punch_approval_list_model.dart';
import '../../../models/manager/wfh_lr_list_model.dart';
import '../../../utils/color_utils.dart';
import '../../CWidgets/cwidgets.dart';
import 'manager_request_controller/manager_request_controller.dart';

class ManagerRequestPage extends StatefulWidget {
  const ManagerRequestPage({super.key});

  @override
  State<ManagerRequestPage> createState() => _ManagerRequestPageState();
}

class _ManagerRequestPageState extends State<ManagerRequestPage> {
  ManagerRequestController managerRequestController = Get.find<ManagerRequestController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initialize();
    });
    super.initState();
  }

  Future<void> initialize() async {
    // context.loaderOverlay.show();
    managerRequestController.searchText.value = '';
    managerRequestController.currentMonthIndex.value = 10;
    Get.find<ManagerAttendanceController>().employeeSerachcontroller.clear();
    if(managerRequestController.currentTabIndex.value == 0) {
      if(managerRequestController.filters.value[managerRequestController.currentTabIndex.value].filter == RequestFilterTypes.pending) {
        await managerRequestController.fetchExcuseList(
          monthYear: managerRequestController.monthString[managerRequestController.currentMonthIndex.value],
        );
      } else {
        await managerRequestController.fetchExcuseListFilter(
          monthYear: managerRequestController.monthString[managerRequestController.currentMonthIndex.value],
        );
      }
    } else if(managerRequestController.currentTabIndex.value == 1) {
      await managerRequestController.fetchPunchApprovalReqList(
        monthYr: managerRequestController.monthString[managerRequestController.currentMonthIndex.value],
      );
    } else if(managerRequestController.currentTabIndex.value == 2) {
      await managerRequestController.fetchOvertimeList(
        monthYear: managerRequestController.monthString[managerRequestController.currentMonthIndex.value],
      );
    } else if(managerRequestController.currentTabIndex.value == 3 || managerRequestController.currentTabIndex.value == 4) {
      await managerRequestController.fetchWfhOrLrList(
        monthYr: managerRequestController.monthString[managerRequestController.currentMonthIndex.value],
      );
    } else if(managerRequestController.currentTabIndex.value == 5) {
      await managerRequestController.fetchEmployeeLeaveList(
        monthYr: managerRequestController.monthString[managerRequestController.currentMonthIndex.value],
      );
    }
    // context.loaderOverlay.hide();
  }

  @override
  void dispose() {
    Get.find<ManagerHomeController>().fetchActionCentre();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      left: false,
      right: false,
      child: Scaffold(
        backgroundColor: ColorUtils.textWhite,
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Stack(
            children: [
              gradientContainer1,
              SafeArea(
                top: true,
                bottom: false,
                left: false,
                right: false,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: 15.h,
                        left: 15.w,
                        right: 15.w,
                        bottom: 10.h,
                      ),
                      child: RequestAppBar(title: "Request", icon: "assets/images/manager_view/request_icon.png"),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15.w),
                      child: RequestActionRow(),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15.w,
                        vertical: 10.h,
                      ),
                      child: SearchAndFilter(
                        filterPage: FilterPage.requests,
                          color: ColorUtils.snowGrey,
                        showFilter: true,
                        isDarkMode: false,
                        result: (value) {
                          managerRequestController.searchText.value = value;
                          if(managerRequestController.currentTabIndex.value == 0) {
                            managerRequestController.filterByName(type: RequestType.excuse, name: value);
                          }
                          if(managerRequestController.currentTabIndex.value == 1) {
                            managerRequestController.filterByName(type: RequestType.punchApproval, name: value);
                          }
                          if(managerRequestController.currentTabIndex.value == 2) {
                            managerRequestController.filterByName(type: RequestType.overtime, name: value);
                          }
                          if(managerRequestController.currentTabIndex.value == 3) {
                            managerRequestController.filterByName(type: RequestType.wfh, name: value);
                          }
                          if(managerRequestController.currentTabIndex.value == 4) {
                            managerRequestController.filterByName(type: RequestType.letterRequest, name: value);
                          }
                          if(managerRequestController.currentTabIndex.value == 5) {
                            managerRequestController.filterByName(type: RequestType.leaveRequest, name: value);
                          }
                        },
                      ),
                    ),
                    Obx(
                      () {
                        return Padding(
                          padding:
                          managerRequestController
                              .currentTabIndex
                              .value ==
                              3
                              ? EdgeInsets.only(
                            left: 15.w,
                            right: 15.w,
                            top: 6.h,
                          )
                              : EdgeInsets.symmetric(
                            horizontal: 15.w,
                            vertical: 3.h,
                          ),
                          child: EmployeeSelectAllAndDateFilter(
                            dateOnly: managerRequestController.currentTabIndex.value == 4 ||
                                managerRequestController.currentTabIndex.value == 3,
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 8.h),
                    GetX<ManagerRequestController>(
                      builder: (ManagerRequestController controller) {
                        if (controller.currentTabIndex.value == 0) {
                          if(controller.excuseList.value.isEmpty && controller.excuseShimmerloading.value) {
                            return EmptyView(requestType: RequestType.excuse);
                          } else {
                            if(controller.searchText.value.trim().isEmpty) {
                              return Expanded(
                                child: ListView.separated(
                                  padding: EdgeInsets.only(
                                    left: 10.w,
                                    right: 10.w,
                                    top: 0,
                                    bottom: 10.h,
                                  ),
                                  itemCount: !controller.excuseShimmerloading.value?2: controller.excuseList.value.length,
                                  shrinkWrap: true,
                                  cacheExtent: 100,
                                  itemBuilder: (context, index) => !controller.excuseShimmerloading.value?EmployeeRequestDayCardShimmer(): EmployeeRequestDayCard(excuseData: controller.excuseList.value[index]),
                                  separatorBuilder: (context, index) => SizedBox(height: 10.h),
                                ),
                              );
                            } else {
                              return Expanded(
                                child: ListView.separated(
                                  padding: EdgeInsets.only(
                                    left: 10.w,
                                    right: 10.w,
                                    top: 0,
                                    bottom: 10.h,
                                  ),
                                  itemCount: controller.excuseEmployeeList.value.length,
                                  shrinkWrap: true,
                                  cacheExtent: 100,
                                  itemBuilder: (context, index) => EmployeeRequestCard(employee: controller.excuseEmployeeList.value[index]),
                                  separatorBuilder: (context, index) => SizedBox(height: 5.h),
                                ),
                              );
                            }
                          }
                        } else if (controller.currentTabIndex.value == 1) {
                          if(controller.punchApprovalList.value.isEmpty && controller.punchShimmerLoded.value) {
                            return EmptyView(requestType: RequestType.punchApproval);
                          } else {
                            if(controller.searchText.value.trim().isEmpty) {
                              return Expanded(
                                child: ListView.separated(
                                  padding: EdgeInsets.only(
                                    left: 10.w,
                                    right: 10.w,
                                    top: 0,
                                    bottom: 10.h,
                                  ),
                                  itemCount:!controller.punchShimmerLoded.value? 8: controller.punchApprovalList.value.length,
                                  shrinkWrap: true,
                                  cacheExtent: 100,
                                  itemBuilder: (context, index) => !controller.punchShimmerLoded.value?  PunchApprovalShimmmer(): PunchApprovalDayCard(approvalData: controller.punchApprovalList.value[index]),
                                  separatorBuilder: (context, index) => SizedBox(height: 5.h),
                                ),
                              );
                            } else {
                              return Expanded(
                                child: ListView.separated(
                                  padding: EdgeInsets.only(
                                    left: 10.w,
                                    right: 10.w,
                                    top: 0,
                                    bottom: 10.h,
                                  ),
                                  itemCount: controller.punchApprovalEmployeeList.value.length,
                                  shrinkWrap: true,
                                  cacheExtent: 100,
                                  itemBuilder: (context, index) => PunchApprovalRequestCard(employeesApproval: controller.punchApprovalEmployeeList.value[index]),
                                  separatorBuilder: (context, index) => SizedBox(height: 5.h),
                                ),
                              );
                            }
                          }
                        } else if (controller.currentTabIndex.value == 2) {
                          if(controller.excuseList.value.isEmpty && controller.excuseShimmerloading.value) {
                            return EmptyView(requestType: RequestType.excuse);
                          } else {
                            if(controller.searchText.value.trim().isEmpty) {
                              return Expanded(
                                child: ListView.separated(
                                  padding: EdgeInsets.only(
                                    left: 10.w,
                                    right: 10.w,
                                    top: 0,
                                    bottom: 10.h,
                                  ),
                                  itemCount: !controller.excuseShimmerloading.value?2: controller.excuseList.value.length,
                                  shrinkWrap: true,
                                  cacheExtent: 100,
                                  itemBuilder: (context, index) => !controller.excuseShimmerloading.value?EmployeeRequestDayCardShimmer(): EmployeeRequestDayCard(excuseData: controller.excuseList.value[index]),
                                  separatorBuilder: (context, index) => SizedBox(height: 10.h),
                                ),
                              );
                            } else {
                              return Expanded(
                                child: ListView.separated(
                                  padding: EdgeInsets.only(
                                    left: 10.w,
                                    right: 10.w,
                                    top: 0,
                                    bottom: 10.h,
                                  ),
                                  itemCount: controller.excuseEmployeeList.value.length,
                                  shrinkWrap: true,
                                  cacheExtent: 100,
                                  itemBuilder: (context, index) => EmployeeRequestCard(employee: controller.excuseEmployeeList.value[index]),
                                  separatorBuilder: (context, index) => SizedBox(height: 5.h),
                                ),
                              );
                            }
                          }
                        } else if (controller.currentTabIndex.value == 3) {
                          List<WfhLrData> wfhLrList = [];
                          if(controller.filters.value[controller.currentTabIndex.value].filter == RequestFilterTypes.pending) {
                            wfhLrList = controller.wfhLrListPending.value;
                          }
                          if(controller.filters.value[controller.currentTabIndex.value].filter == RequestFilterTypes.approved) {
                            wfhLrList = controller.wfhLrListApproved.value;
                          }
                          if(controller.filters.value[controller.currentTabIndex.value].filter == RequestFilterTypes.rejected) {
                            wfhLrList = controller.wfhLrListRejected.value;
                          }
                          if(wfhLrList.isEmpty && controller.wfhLrShimmerLoaded.value) {
                            return EmptyView(requestType: RequestType.wfh);
                          } else {
                            return Expanded(
                              child: ListView.separated(
                                padding: EdgeInsets.only(
                                  left: 10.w,
                                  right: 10.w,
                                  top: 10.h,
                                  bottom: 10.h,
                                ),
                                itemCount:!controller.wfhLrShimmerLoaded.value? 7: wfhLrList.length,
                                shrinkWrap: true,
                                cacheExtent: 100,
                                itemBuilder: (context, index) => !controller.wfhLrShimmerLoaded.value?WorkFromHomeCardShimmer(): WorkFromHomeCard(wfhLrList: wfhLrList[index]),
                                separatorBuilder: (context, index) => SizedBox(height: 5.h),
                              ),
                            );
                          }
                        } else if (controller.currentTabIndex.value == 4) {
                          List<WfhLrData> wfhLrList = [];
                          if(controller.filters.value[controller.currentTabIndex.value].filter == RequestFilterTypes.pending) {
                            wfhLrList = controller.wfhLrListPending.value;
                          }
                          if(controller.filters.value[controller.currentTabIndex.value].filter == RequestFilterTypes.approved) {
                            wfhLrList = controller.wfhLrListApproved.value;
                          }
                          if(controller.filters.value[controller.currentTabIndex.value].filter == RequestFilterTypes.rejected) {
                            wfhLrList = controller.wfhLrListRejected.value;
                          }
                          if(wfhLrList.isEmpty && controller.wfhLrShimmerLoaded.value) {
                            return EmptyView(requestType: RequestType.letterRequest);
                          } else {
                            return Expanded(
                              child: ListView.separated(
                                padding: EdgeInsets.only(
                                  left: 10.w,
                                  right: 10.w,
                                  top: 10.h,
                                  bottom: 10.h,
                                ),
                                itemCount:!controller.wfhLrShimmerLoaded.value? 10: wfhLrList.length,
                                shrinkWrap: true,
                                cacheExtent: 100,
                                itemBuilder: (context, index) => !controller.wfhLrShimmerLoaded.value? LetterRequestCardShimmer() : LetterRequestCard(wfhLrList: wfhLrList[index]),
                                separatorBuilder: (context, index) => SizedBox(height: 5.h),
                              ),
                            );
                          }
                          // return Expanded(
                          //   child: Padding(
                          //     padding: EdgeInsets.symmetric(horizontal: 8.h),
                          //     child: SingleChildScrollView(
                          //       child: Column(
                          //         children: [
                          //           SizedBox(height: 10.h),
                          //           LetterRequestCard(),
                          //           SizedBox(height: 5.h),
                          //           LetterRequestCard(),
                          //           SizedBox(height: 5.h),
                          //           LetterRequestCard(),
                          //           SizedBox(height: 5.h),
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // );
                        } else {
                          if(controller.employeeLeaveList.value.isEmpty && controller.leaveListShimmerLoading.value) {
                            return EmptyView(requestType: RequestType.leaveRequest);
                          } else {
                            return Expanded(
                              child: ListView.separated(
                                padding: EdgeInsets.only(
                                  left: 10.w,
                                  right: 10.w,
                                  top: 10.h,
                                  bottom: 10.h,
                                ),
                                itemCount: !controller.leaveListShimmerLoading.value? 10: controller.employeeLeaveList.value.length,
                                shrinkWrap: true,
                                cacheExtent: 100,
                                itemBuilder: (context, index) => !controller.leaveListShimmerLoading.value
                                    ? LeaveRequestCardShimmer()
                                    : LeaveRequestCard(leaveData: controller.employeeLeaveList.value[index]),
                                separatorBuilder: (context, index) => SizedBox(height: 5.h),
                              ),
                            );
                          }
                          // return Expanded(
                          //   child: Padding(
                          //     padding: EdgeInsets.symmetric(horizontal: 8.h),
                          //     child: SingleChildScrollView(
                          //       child: Column(
                          //         children: [
                          //           SizedBox(height: 10.h),
                          //           LeaveRequestCard(),
                          //           SizedBox(height: 5.h),
                          //           LeaveRequestCard(),
                          //           SizedBox(height: 5.h),
                          //           LeaveRequestCard(),
                          //           SizedBox(height: 5.h),
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: GetX<ManagerRequestController>(
          builder: (ManagerRequestController controller) {
            List<Employees> empList = [];
            List<EmployeesApproval> approvalList = [];
            List<WfhLrData> requestList = [];
            List<EmployeeLeaveData> leaveList = [];
            int tabIndex = controller.currentTabIndex.value;
            if(tabIndex == 0 || tabIndex == 2) {
              if(controller.searchText.value.trim().isEmpty) {
                empList = controller.excuseList.value
                    .expand((excuse) => excuse.employees ?? <Employees>[])
                    .where((emp) => emp.isSelected == true)
                    .toList();
              } else {
                empList = controller.excuseEmployeeList.value
                    .where((emp) => emp.isSelected == true)
                    .toList();
              }
            }
            if(tabIndex == 1) {
              if(controller.searchText.value.trim().isEmpty) {
                approvalList = controller.punchApprovalList
                    .expand((punch) => punch.employees ?? <EmployeesApproval>[])
                    .where((emp) => emp.isSelected == true)
                    .toList();
              } else {
                approvalList = controller.punchApprovalEmployeeList
                    .where((emp) => emp.isSelected == true)
                    .toList();
              }
            }
            if(tabIndex == 3 || tabIndex == 4) {
              requestList = controller.wfhLrListPending
                  .where((request) => (request.requestStatusName.toString().toLowerCase() == 'pending' && request.isSelected == true))
                  .toList();
            }
            if(tabIndex == 5) {
              leaveList = controller.employeeLeaveList
                  .where((request) => (request.requestStatusName.toString().toLowerCase() == 'pending' && request.isSelected == true))
                  .toList();
            }
            if (((tabIndex == 0 || tabIndex == 2) && empList.isNotEmpty) || (tabIndex == 1 && approvalList.isNotEmpty) || ((tabIndex == 3 || tabIndex == 4) && requestList.isNotEmpty) || (tabIndex == 5 && leaveList.isNotEmpty)) {

              String getCount() {
                switch(tabIndex) {
                  case 0: return empList.length.toString().padLeft(2, '0');
                  case 1: return approvalList.length.toString().padLeft(2, '0');
                  case 2: return empList.length.toString().padLeft(2, '0');
                  case 3: return requestList.length.toString().padLeft(2, '0');
                  case 4: return requestList.length.toString().padLeft(2, '0');
                  case 5: return leaveList.length.toString().padLeft(2, '0');
                  default: return '--';
                }
              }

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
                      getCount(),
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
                            return BulkRegularizationBottomSheetManager(
                                empList: empList,
                              approvalList: approvalList,
                              requestList: requestList,
                              leaveList: leaveList,
                              isLeave: false,
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
    );
  }
}

class EmptyView extends StatelessWidget {
  final RequestType requestType;
  const EmptyView({super.key, required this.requestType});

  @override
  Widget build(BuildContext context) {
    String viewItem = '';

    if(requestType == RequestType.excuse) {
      viewItem = "Excuse";
    } else if(requestType == RequestType.punchApproval) {
      viewItem = "Punch";
    } else if(requestType == RequestType.wfh) {
      viewItem = "Work From Home";
    } else if(requestType == RequestType.letterRequest) {
      viewItem = "Letter";
    } else if(requestType == RequestType.leaveRequest) {
      viewItem = "Leave";
    }

    return Expanded(
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
              SizedBox(height: 15.h),
              Text(
                "No $viewItem Approval Request",
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w600,
                  color: ColorUtils.workEntryHead,
                  fontSize: 15.h,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                "$viewItem Approval request data is not available for the selected month.",
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
    );
  }
}

