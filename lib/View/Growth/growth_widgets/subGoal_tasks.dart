import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loyaltri_minimal/View/Growth/growth_controller/growth_controller.dart';
import 'package:loyaltri_minimal/View/Growth/growth_widgets/subgoal_actions_sheet.dart';
import 'package:loyaltri_minimal/models/subgoal_tasks_model.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';
import '../../CWidgets/cwidgets.dart';
import '../../ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import '../../ManagerView/Manager_Task/task_controller/task_controller.dart';
import '../../ManagerView/Manager_Task/task_widgets/task_add_screen.dart';

class SubGoalTasks extends StatelessWidget {
  const SubGoalTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Get.find<GrowthController>().fetchSubGoalTaskList(
          id: Get.find<GrowthController>().subGoalDetails.value?.goalId,
        );
      },
      child: SingleChildScrollView(
        controller: Get.find<GrowthController>().taskScrollController,
        physics: AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.h),
          child: GetX<GrowthController>(
            builder: (GrowthController controller) {
              return Column(
                children: [
                  SizedBox(height: 15.h),
                  if (!controller.subGoalTasksLoading.value && controller.subGoalTasks.value.isEmpty)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 50.h),
                        Container(
                          width: 64.h,
                          height: 64.h,
                          decoration: BoxDecoration(
                            color: ColorUtils.textWhite.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Image.asset(
                              'assets/images/manager_view/task-logo.png',
                              height: 32.h,
                              opacity: AlwaysStoppedAnimation(0.2),
                            ),
                          ),
                        ),
                        SizedBox(height: 15.h),
                        Text(
                          'No tasks yet',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 13.h,
                            color: ColorUtils.textWhite.withValues(alpha: 0.4),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          'Tasks will appear here once created',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 11.h,
                            color: ColorUtils.textWhite.withValues(alpha: 0.3),
                          ),
                        ),
                      ],
                    ),
                  if (controller.subGoalTasksLoading.value)
                    Center(
                      child: SpinKitThreeInOut(
                        color: ColorUtils.primaryBlue,
                        size: 28.h,
                      ),
                    )
                  else
                    ListView.separated(
                    itemCount: controller.subGoalTasks.value.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      bool isDue = false;
                      int daysAfterDue = 0;
                      SubGoalTasksData task =
                          controller.subGoalTasks.value[index];
                      String formattedDate = '--';
                      try {
                        DateTime date = DateTime.parse(task.dueDate!);
                        formattedDate = DateFormat('MMM dd').format(date);
                        isDue = date.isBefore(DateTime.now());
                        daysAfterDue = DateTime.now().difference(date).inDays;
                      } catch (e) {}
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15.h,
                          // vertical: 18.h,
                        ),
                        decoration: BoxDecoration(
                          color: isDue
                              ? ColorUtils.alertRed.withValues(alpha: 0.05)
                              : ColorUtils.textWhite.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(
                            color: isDue
                                ? ColorUtils.alertRed.withValues(alpha: 0.3)
                                : ColorUtils.textWhite.withValues(alpha: 0.1),
                            width: 0.6.h,
                          ),
                        ),
                        child: Column(
                          children: [
                            if (isDue) SizedBox(height: 10.h),
                            if (isDue)
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/images/growth/exclemation-red.png',
                                    height: 16.h,
                                  ),
                                  SizedBox(width: 10.h),
                                  Text(
                                    'OVERDUE • $daysAfterDue ${daysAfterDue > 1 ? 'days' : 'day'}',
                                    style: GoogleFonts.inter(
                                      fontSize: 11.h,
                                      fontWeight: FontWeight.w700,
                                      color: ColorUtils.coralRed,
                                    ),
                                  ),
                                ],
                              ),
                            if (isDue) SizedBox(height: 10.h),
                            if (isDue)
                              Divider(
                                color: ColorUtils.alertRed.withValues(
                                  alpha: 0.3,
                                ),
                                height: 0,
                                thickness: 0.6.h,
                              ),
                            if (isDue) SizedBox(height: 10.h),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    task.workName ?? '--',
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.inter(
                                      fontSize: 13.h,
                                      fontWeight: FontWeight.w400,
                                      color: ColorUtils.textWhite.withValues(
                                        alpha: 0.9,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.h),
                                GestureDetector(
                                  onTap: () async {
                                    int? action = await showModalBottomSheet(
                                      context: context,
                                      backgroundColor:
                                          ColorUtils.veryDarkNaturalDGrey,
                                      builder: (context) {
                                        return SubGoalActionsSheet(
                                          isTaskAction: true,
                                        );
                                      },
                                    );

                                    if(action == 1) {
                                      ManagerTaskController managerTaskController = Get.find<ManagerTaskController>();
                                      managerTaskController.activityLogList.value = [];
                                      managerTaskController.activityLogList.refresh();
                                      managerTaskController.detailedTaskData.value = null;
                                      Navigator.of(context).push(
                                        newSlideFromBottomNavigation(TaskAddScreen(
                                          taskCreate: false,
                                          taskId: task.workEntryId,
                                          isDarkMode: true,
                                          fromGoals: true,
                                        )),
                                      );
                                    } else if(action == 3) {
                                      context.loaderOverlay.show();
                                      final result = await Get.find<GrowthController>().taskDelete(taskId: task.workEntryId);
                                      context.loaderOverlay.hide();
                                      if(result != null) {
                                        AttendanceCommonWidgets().showSnackBar(
                                          context: context,
                                          backgroundColor: result.status == 200 ? Colors.green : Colors.red,
                                          message: result.message ?? ' Something went wrong',
                                        );
                                      }
                                    } else if(action == 4) {
                                      context.loaderOverlay.show();
                                      final result = await Get.find<GrowthController>().unlinkTask(taskId: task.workEntryId);
                                      context.loaderOverlay.hide();
                                      if(result != null) {
                                        AttendanceCommonWidgets().showSnackBar(
                                          context: context,
                                          backgroundColor: result.status == 200 ? Colors.green : Colors.red,
                                          message: result.message ?? ' Something went wrong',
                                        );
                                      }
                                    }
                                  },
                                  child: Container(
                                    height: 50.h,
                                    width: 40.h,
                                    color: Colors.transparent,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Icon(
                                        Icons.more_horiz_outlined,
                                        color: ColorUtils.textWhite.withValues(
                                          alpha: 0.4,
                                        ),
                                        size: 15.h,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Container(
                                    //   width: 20.h,
                                    //   height: 20.h,
                                    //   decoration: BoxDecoration(
                                    //     shape: BoxShape.circle,
                                    //     gradient: LinearGradient(
                                    //       begin: Alignment.topLeft,
                                    //       end: Alignment.bottomRight,
                                    //       colors: [
                                    //         ColorUtils.secondaryBlue,
                                    //         ColorUtils.accentPurple,
                                    //       ],
                                    //     ),
                                    //   ),
                                    //   child: Center(
                                    //     child: Text(
                                    //       'AR',
                                    //       style: GoogleFonts.inter(
                                    //         fontWeight: FontWeight.w700,
                                    //         fontSize: 8.h,
                                    //         color: ColorUtils.textWhite,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                        1000,
                                      ).r,
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            task.assignedEmployeeProfile ?? '',
                                        height: 20.h,
                                        width: 20.h,
                                        alignment: Alignment.center,
                                        placeholder: (context, url) {
                                          return Container(
                                            width: 20.h,
                                            height: 20.h,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  ColorUtils.secondaryBlue,
                                                  ColorUtils.accentPurple,
                                                ],
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                employeeNameShortForm(
                                                  task.assignedEmployee ?? '',
                                                ),
                                                style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 8.h,
                                                  color: ColorUtils.textWhite,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        errorWidget: (context, url, error) {
                                          return Container(
                                            width: 20.h,
                                            height: 20.h,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  ColorUtils.secondaryBlue,
                                                  ColorUtils.accentPurple,
                                                ],
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                employeeNameShortForm(
                                                  task.assignedEmployee ?? '',
                                                ),
                                                style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 8.h,
                                                  color: ColorUtils.textWhite,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(width: 6.h),
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth: 130.h,
                                      ),
                                      child: Text(
                                        task.assignedEmployee ?? '--',
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.inter(
                                          fontSize: 11.h,
                                          fontWeight: FontWeight.w400,
                                          color: ColorUtils.textWhite
                                              .withValues(alpha: 0.4),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  ' • ',
                                  style: GoogleFonts.inter(
                                    fontSize: 11.h,
                                    fontWeight: FontWeight.w400,
                                    color: ColorUtils.textWhite.withValues(
                                      alpha: 0.4,
                                    ),
                                  ),
                                ),
                                Text(
                                  'Due: $formattedDate',
                                  style: GoogleFonts.inter(
                                    fontSize: 11.h,
                                    fontWeight: FontWeight.w400,
                                    color: ColorUtils.textWhite.withValues(
                                      alpha: 0.4,
                                    ),
                                  ),
                                ),
                                if(task.status?.trim().isNotEmpty ?? false)
                                  Text(
                                  ' • ',
                                  style: GoogleFonts.inter(
                                    fontSize: 11.h,
                                    fontWeight: FontWeight.w400,
                                    color: ColorUtils.textWhite.withValues(
                                      alpha: 0.4,
                                    ),
                                  ),
                                ),
                                if(task.status?.trim().isNotEmpty ?? false)
                                  Flexible(
                                  child: Text(
                                    task.status ?? '--',
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.inter(
                                      fontSize: 11.h,
                                      fontWeight: FontWeight.w400,
                                      color: AttendanceCommonWidgets().hexToColor(task.statusColor),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 13.h),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 10.h),
                  ),
                  if (!controller.subGoalTasksLoading.value)
                    Padding(
                    padding: EdgeInsets.all(15.h),
                    child: InkWell(
                      onTap: () {
                        ManagerTaskController managerTaskController =
                            Get.find<ManagerTaskController>();
                        managerTaskController.activityLogList.value = [];
                        managerTaskController.activityLogList.refresh();
                        managerTaskController.detailedTaskData.value = null;
                        Navigator.of(context).push(
                          fadeNavigation(
                            TaskAddScreen(
                              taskCreate: true,
                              isDarkMode: true,
                              fromGoals: true,
                            ),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(10.r),
                      child: Container(
                        padding: EdgeInsets.all(13.h),
                        decoration: BoxDecoration(
                          color: ColorUtils.secondaryBlue.withValues(
                            alpha: 0.7,
                          ),
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color: ColorUtils.secondaryBlue.withValues(
                              alpha: 0.2,
                            ),
                            width: 0.6.h,
                          ),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.add,
                                color: ColorUtils.textWhite,
                                size: 16.h,
                              ),
                              SizedBox(width: 10.h),
                              Text(
                                'Create Task',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13.h,
                                  color: ColorUtils.textWhite,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
