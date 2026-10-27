

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_More/more_widgets_manager/app_bar.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Request/Manager_Reqest_Page.dart';
import 'package:loyaltri_minimal/View/ManagerView/Piece_Work/Piece_Work_Page.dart';
import 'package:loyaltri_minimal/View/ManagerView/Shift_Scheduler/shift_scheduler_controller/shift_scheduler_controller.dart';
import 'package:loyaltri_minimal/View/ManagerView/Shift_Scheduler/shift_scheduler_page.dart';
import '../../../controller/userProfileController.dart';
import '../../../utils/color_utils.dart';
import '../../CWidgets/cwidgets.dart';
import '../Employee_Leave/Employee_Leave_Page.dart';
import '../Employee_Leave/employee_leave_controller/employee_leave_controller.dart';
import '../Manager_Request/manager_request_controller/manager_request_controller.dart';
import '../Manager_Task/Manager_Task_Screen.dart';



class ManagerMorePage extends StatefulWidget {
  const ManagerMorePage({super.key});

  @override
  State<ManagerMorePage> createState() => _ManagerMorePageState();
}

class _ManagerMorePageState extends State<ManagerMorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.textWhite,
      body: Stack(
        children: [
          gradientContainer1,
          SafeArea(
            child: GetX<UserProfileController>(
              builder: (UserProfileController controller) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 15.h),
                  child: Column(
                    children: [
                      MoreAppBar(),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
                          child: GridView.builder(
                            itemCount: controller.moreActions.value.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 1.1.w,
                                crossAxisCount: 3, crossAxisSpacing: 19.w, mainAxisSpacing: 19.w),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  if (controller.moreActions.value[index].id == 1) {
                                    EmployeeLeaveController employeeLeaveController = Get.find<EmployeeLeaveController>();
                                    employeeLeaveController.resetValues();
                                    employeeLeaveController.fetchEmployeeLeaveList();
                                    Navigator.of(context).push(
                                      newSlideNavigation(const EmployeeLeavePage()),
                                    );
                                  }
                                  if (controller.moreActions.value[index].id == 2) {
                                    Navigator.of(context).push(
                                      newSlideNavigation(TaskScreen(fromEmployee: false)),
                                    );
                                  }
                                  // if (controller.serviceActions.value[index].id == 3) {
                                  //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MyWorkExpenses(isQuickActionEnable: false)));
                                  // }
                                  if (controller.moreActions.value[index].id == 4) {
                                    Navigator.of(context).push(
                                        newSlideNavigation(const ManagerRequestPage()),
                                    );
                                  }
                                  if (controller.moreActions.value[index].id == 5) {
                                    Navigator.of(context).push(
                                      newSlideNavigation(const TaskScreen(fromEmployee: false)),
                                    );
                                  }
                                  if (controller.moreActions.value[index].id == 6) {
                                    Navigator.of(context).push(
                                        newSlideNavigation(const PieceWorkPage()),
                                    );
                                  }
                                  // if (controller.moreActions.value[index].id == 7) {
                                  //   final ShiftSchedulerController controller = Get.put(ShiftSchedulerController());
                                  //   controller.fetchInitialData();
                                  //   Navigator.of(context).push(
                                  //       newSlideNavigation(ShiftSchedulerScreen()),
                                  //   );
                                  // }
                                  // if (controller.serviceActions.value[index].id == 5) {
                                  //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MyExcuse()));
                                  // }
                                  // if (controller.serviceActions.value[index].id == 6) {
                                  //   Get.find<MyRequestFilterController>().resetFilter();
                                  //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MyRequest()));
                                  // }
                                  // if (controller.serviceActions.value[index].id == 7) {
                                  //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MySchedule()));
                                  // }
                                },
                                child: Container(
                                  width: 100.w,
                                  height: 85.h,
                                  decoration: BoxDecoration(
                                      color: ColorUtils.pastelPurple,
                                      borderRadius: BorderRadius.circular(18).r),
                                  child: Column(
                                    children: [
                                      Flexible(flex: 3, child: Container()),
                                      Image.asset(
                                        controller.moreActions.value[index].svgIcon,
                                        height: 30.h,
                                      ),
                                      Flexible(flex: 1, child: Container()),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 10, right: 10).w,
                                        child: Text(
                                          controller.moreActions.value[index].title,
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            color: ColorUtils.workEntryHead,
                                            fontSize: 12.h,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      Flexible(flex: 3, child: Container()),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
