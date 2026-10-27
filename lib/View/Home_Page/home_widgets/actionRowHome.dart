import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loyaltri_minimal/View/CWidgets/cwidgets.dart';
import 'package:loyaltri_minimal/View/CWidgets/error_dialog.dart';
import 'package:loyaltri_minimal/View/Home_Page/home_widgets/bottomSheet_chooseCheckType.dart';
import 'package:loyaltri_minimal/View/Home_Page/home_widgets/home_action.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/View/field/features/home/home_screen.dart';
import 'package:loyaltri_minimal/controller/attendanceUploadController.dart';
import 'package:loyaltri_minimal/controller/punchTypeController.dart';
import 'package:loyaltri_minimal/controller/ui_controller/home_controller.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';
import '../../Growth/growth_home.dart';
import '../../Leave_Page/Leave_Request.dart';
import '../../ManagerView/Manager_Task/Manager_Task_Screen.dart';
import '../../ManagerView/Manager_Task/task_controller/task_controller.dart';
import '../../ManagerView/Manager_Task/task_widgets/task_add_screen.dart';
import '../../Work_Entry/Work_Entry.dart';
import '../../Work_Expenses/My_Work_Expenses.dart';

class HomeActionRow extends StatelessWidget {
  final Function()? callBack;
  final bool whichCheck;
  const HomeActionRow({super.key, required this.whichCheck, this.callBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.only(left: 6.0, right: 6.0, top: 8.0, bottom: 3.0).w,
        child: GetX<UserProfileController>(
          builder: (UserProfileController controller) {
            if(controller.homeActions.length == 2) {
              return Row(
                children: [
                  for(int index = 0; index < controller.homeActions.length; index++)
                    Expanded(
                      child: SizedBox(
                          height: 110.w,
                        child: InkWell(
                          onTap: () async {
                            if (controller.homeActions.value[index].id == 1) {
                              PunchTypeController punchTypeController = Get.find<PunchTypeController>();
                              bool isPunchMethodsEmpty = punchTypeController.checkInMethods.value.isEmpty || punchTypeController.checkOutMethods.value.isEmpty;
                              if(isPunchMethodsEmpty) {
                                AttendanceCommonWidgets().showSnackBar(
                                  context: context,
                                  backgroundColor: ColorUtils.foregroundBlack4,
                                  message: "Action Not Allowed",
                                );
                              } else {
                                String? msg = await Get.find<AttendanceUploadController>().checkInGuard();
                                if(msg == null) {
                                  chooseCheckTypeBottomSheet(mainContext: context, isIn: whichCheck,);
                                } else {
                                  await HapticFeedback.lightImpact();
                                  String? msg = "${whichCheck ? 'Check in' : 'Check out'} is not allowed within 3 minutes after ${whichCheck ? 'checkout' : 'check in'}. Please try again later.";
                                  ErrorDialog().showWarn(
                                      context: context,
                                      title: "Message",
                                      subTitle: msg);
                                }
                              }
                            }
                            if (controller.homeActions.value[index].id == 2) {
                              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LeavePage()));
                              Navigator.of(context).push(
                                newSlideNavigation(const LeaveRequest()),
                              );
                            }
                            if (controller.homeActions.value[index].id == 3) {
                              Navigator.of(context).push(
                                newSlideNavigation( WorkEntry(isQuickActionEnable: true, callBack: callBack!)),
                              );
                            }
                            if (controller.homeActions.value[index].id == 4) {
                              Navigator.of(context).push(
                                newSlideNavigation(const MyWorkExpenses(isQuickActionEnable: true)),
                              );
                            }
                            if (controller.homeActions.value[index].id == 9) {
                              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => TaskScreen(fromEmployee: true)));
                              ManagerTaskController managerTaskController = Get.find<ManagerTaskController>();
                              managerTaskController.activityLogList.value = [];
                              managerTaskController.activityLogList.refresh();
                              managerTaskController.detailedTaskData.value = null;
                              Navigator.of(context).push(
                                newSlideFromBottomNavigation(TaskAddScreen(taskCreate: true, isDarkMode: true)),
                              );
                            }
                            if (controller.homeActions.value[index].id == 5) {
                              Navigator.of(context).push(
                                  fadeNavigation(GrowthScreen())
                              );
                            }
                            if (controller.homeActions.value[index].id == 11) {
                              Navigator.of(context).push(
                                  fadeNavigation((FieldHomeScreen()))
                              ).then((_) {
                                if (Get.isRegistered<HomeController>()) {
                                  Get.find<HomeController>().fetchWorkLogByDate();
                                }
                              });
                            }
                          },
                          child: HomeAction(actionEntry: controller.homeActions.value[index]),
                        ),
                      ),
                    ),
                ],
              );
            } else {
              return SizedBox(
                height: 110.w,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.homeActions.value.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () async {
                        if (controller.homeActions.value[index].id == 1) {
                          PunchTypeController punchTypeController = Get.find<PunchTypeController>();
                          bool isPunchMethodsEmpty = punchTypeController.checkInMethods.value.isEmpty || punchTypeController.checkOutMethods.value.isEmpty;
                          if(isPunchMethodsEmpty) {
                            AttendanceCommonWidgets().showSnackBar(
                              context: context,
                              backgroundColor: ColorUtils.foregroundBlack4,
                              message: "Action Not Allowed",
                            );
                          } else {
                            String? msg = await Get.find<AttendanceUploadController>().checkInGuard();
                            if(msg == null) {
                              chooseCheckTypeBottomSheet(mainContext: context, isIn: whichCheck,);
                            } else {
                              await HapticFeedback.lightImpact();
                              String? msg = "${whichCheck ? 'Check in' : 'Check out'} is not allowed within 3 minutes after ${whichCheck ? 'checkout' : 'check in'}. Please try again later.";
                              ErrorDialog().showWarn(
                                  context: context,
                                  title: "Message",
                                  subTitle: msg);
                            }
                          }
                        }
                        if (controller.homeActions.value[index].id == 2) {
                          // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LeavePage()));
                          Navigator.of(context).push(
                            newSlideNavigation(const LeaveRequest()),
                          );
                        }
                        if (controller.homeActions.value[index].id == 3) {
                          Navigator.of(context).push(
                            newSlideNavigation( WorkEntry(isQuickActionEnable: true, callBack: callBack!)),
                          );
                        }
                        if (controller.homeActions.value[index].id == 4) {
                          Navigator.of(context).push(
                            newSlideNavigation(const MyWorkExpenses(isQuickActionEnable: true)),
                          );
                        }
                        if (controller.homeActions.value[index].id == 9) {
                          // Navigator.of(context).push(MaterialPageRoute(builder: (context) => TaskScreen(fromEmployee: true)));
                          ManagerTaskController managerTaskController = Get.find<ManagerTaskController>();
                          managerTaskController.activityLogList.value = [];
                          managerTaskController.activityLogList.refresh();
                          managerTaskController.detailedTaskData.value = null;
                          Navigator.of(context).push(
                            newSlideFromBottomNavigation(TaskAddScreen(taskCreate: true, isDarkMode: true)),
                          );
                        }
                        if (controller.homeActions.value[index].id == 5) {
                          Navigator.of(context).push(
                            fadeNavigation(GrowthScreen())
                          );
                        }
                        if (controller.homeActions.value[index].id == 11) {
                          Navigator.of(context).push(
                              fadeNavigation((FieldHomeScreen()))
                          ).then((_) {
                            if (Get.isRegistered<HomeController>()) {
                              Get.find<HomeController>().fetchWorkLogByDate();
                            }
                          });
                        }
                      },
                      child: HomeAction(actionEntry: controller.homeActions.value[index]),
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
