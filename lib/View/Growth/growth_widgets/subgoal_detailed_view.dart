import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loyaltri_minimal/View/Growth/growth_widgets/app_bar.dart';
import 'package:loyaltri_minimal/View/Growth/growth_widgets/goal_activities.dart';
import 'package:loyaltri_minimal/View/Growth/growth_widgets/goal_comments.dart';
import 'package:loyaltri_minimal/View/Growth/growth_widgets/goal_detailed_view.dart';
import 'package:loyaltri_minimal/View/Growth/growth_widgets/subGoal_tasks.dart';
import 'package:loyaltri_minimal/View/Growth/growth_widgets/subgoal_actions_sheet.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';

import '../../../controller/userProfileController.dart';
import '../../../models/goals_and_subgoals_model.dart';
import '../../CWidgets/cwidgets.dart';
import '../../ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import '../../ManagerView/Manager_Task/task_controller/task_controller.dart';
import '../../ManagerView/Manager_Task/task_widgets/task_add_screen.dart';
import '../growth_controller/growth_controller.dart';
import 'goal_overview.dart';

class SubGoalDetailedView extends StatefulWidget {
  final int? subGoalId;
  const SubGoalDetailedView({super.key, this.subGoalId});

  @override
  State<SubGoalDetailedView> createState() => _SubGoalDetailedViewState();
}

class _SubGoalDetailedViewState extends State<SubGoalDetailedView>
    with SingleTickerProviderStateMixin {
  final List<String> tabTitles = [
    'Overview',
    'Tasks',
    'Comments',
    'Activities',
  ];

  TabController? _tabController;

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  Future<void> _initialize() async {
    _tabController = TabController(length: tabTitles.length, vsync: this);
    context.loaderOverlay.show();
    await Get.find<GrowthController>().fetchGoalDetails(widget.subGoalId, fetchForGoal: false);
    context.loaderOverlay.hide();
    await Get.find<GrowthController>().fetchSubGoalTaskList(id: widget.subGoalId);
    await Get.find<GrowthController>().fetchGoalComments(goalId: widget.subGoalId, fetchForGoal: false);
    String? employeeId = Get.find<UserProfileController>().userData.value.result.employeeId;
    String? companyId = Get.find<UserProfileController>().userData.value.result.companyId;
    await Get.find<ManagerTaskController>().fetchTaskListData(empId: employeeId ?? '', compId: companyId ?? '');
  }

  @override
  void dispose() {
    _tabController?.dispose();
    Get.find<GrowthController>().subGoalDetails.value = null;
    Get.find<GrowthController>().subGoalDataLoaded.value = false;
    super.dispose();
  }

  bool showOverdue(String? date) {
    if (date == null || date.isEmpty) return false;
    DateTime dueDate = DateFormat('yyyy-MM-dd').parse(date);
    return dueDate.isBefore(DateTime.now());
  }

  String findOverDueDuration(String? date) {
    if (date == null || date.isEmpty) return '--';
    DateTime dueDate = DateFormat('yyyy-MM-dd').parse(date);
    debugPrint('-------dueDate-------$dueDate');
    return DateTime.now().difference(dueDate).inDays.toString();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorUtils.workEntryHead,
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.h),
              child: GrowthAppBar3(
                title: 'Sub-Goal',
                callback: () async {
                  int? action = await showModalBottomSheet(
                    context: context,
                    backgroundColor: ColorUtils.veryDarkNaturalDGrey,
                    builder: (context) {
                      return SubGoalActionsSheet(isTaskAction: false);
                    },
                  );

                  if(action == 1) {
                    ManagerTaskController managerTaskController = Get.find<ManagerTaskController>();
                    managerTaskController.activityLogList.value = [];
                    managerTaskController.activityLogList.refresh();
                    managerTaskController.detailedTaskData.value = null;
                    Navigator.of(context).push(
                        fadeNavigation(TaskAddScreen(
                          taskCreate: true,
                          isDarkMode: true,
                          subGoalCreate: true,
                          subGoalEdit: true,
                          fromGoals: true,
                        ))
                    );
                  } else if(action == 2) {
                    ManagerTaskController managerTaskController = Get.find<ManagerTaskController>();
                    managerTaskController.activityLogList.value = [];
                    managerTaskController.activityLogList.refresh();
                    managerTaskController.detailedTaskData.value = null;
                    Navigator.of(context).push(
                        fadeNavigation(TaskAddScreen(
                          taskCreate: true,
                          isDarkMode: true,
                          fromGoals: true,
                        ))
                    );
                  } else if(action == 3) {
                    context.loaderOverlay.show();
                    final result = await Get.find<GrowthController>().deleteGoal(id: widget.subGoalId);
                    context.loaderOverlay.hide();
                    AttendanceCommonWidgets().showSnackBar(
                      context: context,
                      backgroundColor: result?.status == 200 ? Colors.green : Colors.red,
                      message: result?.message ?? ' Something went wrong',
                    );
                    if(result?.status == 200) {
                      Navigator.of(context).pop();
                    }
                  }
                },
              ),
            ),
            SizedBox(height: 15.h),
            Expanded(
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.h),
                        child: GetX<GrowthController>(
                          builder: (GrowthController controller) {
                            return Column(
                              children: [
                                if(showOverdue(controller.subGoalDetails.value?.goalDueDate))
                                  Container(
                                  padding: EdgeInsets.all(13.h),
                                  decoration: BoxDecoration(
                                    color: ColorUtils.alertRed.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(14.r),
                                    border: Border.all(
                                      color: ColorUtils.alertRed.withValues(
                                        alpha: 0.3,
                                      ),
                                      width: 0.6.h,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/growth/exclemation-red.png',
                                        height: 20.h,
                                        color: ColorUtils.coralRed,
                                      ),
                                      SizedBox(width: 8.h),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Subgoal Overdue',
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 13.h,
                                              color: ColorUtils.coralRed,
                                            ),
                                          ),
                                          SizedBox(height: 2.h),
                                          Text(
                                            '${findOverDueDuration(controller.subGoalDetails.value?.goalDueDate)} days past deadline',
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 11.h,
                                              color: ColorUtils.coralRed.withValues(
                                                alpha: 0.7,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                if(showOverdue(controller.subGoalDetails.value?.goalDueDate))
                                  SizedBox(height: 10.h),
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        controller.subGoalDetails.value?.goalTitile ?? '--',
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 19.h,
                                          color: ColorUtils.textWhite.withValues(
                                            alpha: 0.9,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.h),
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/growth/exclemation-red.png',
                                      height: 14.h,
                                      color: ColorUtils.coralRed,
                                    ),
                                    SizedBox(width: 6.h),
                                    Text(
                                      'Deadline: ${controller.subGoalDetails.value?.goalTimePeriodLabel ?? '--'}',
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13.h,
                                        color: ColorUtils.coralRed,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Progress',
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 11.h,
                                        color: ColorUtils.textWhite.withValues(
                                          alpha: 0.4,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${controller.subGoalDetails.value?.goalProgress ?? 0}%',
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13.h,
                                        color: ColorUtils.textWhite.withValues(
                                          alpha: 0.7,
                                        ),
                                      ),
                                    ),
                                    // InkWell(
                                    //   splashColor: Colors.transparent,
                                    //   onTap: () {
                                    //     showModalBottomSheet(
                                    //       context: context,
                                    //       backgroundColor: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                                    //       builder: (context) {
                                    //         return UpdateProgressBottomSheet();
                                    //       },
                                    //     );
                                    //   },
                                    //   child: Container(
                                    //     width: 24.h,
                                    //     height: 24.h,
                                    //     decoration: BoxDecoration(
                                    //       color: ColorUtils.textWhite.withValues(
                                    //         alpha: 0.05,
                                    //       ),
                                    //       borderRadius: BorderRadius.circular(8.r),
                                    //     ),
                                    //     child: Center(
                                    //       child: Image.asset(
                                    //         'assets/images/growth/sub-goal-edit.png',
                                    //         height: 12.h,
                                    //         color: ColorUtils.textWhite,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                                SizedBox(height: 6.h),
                                GreenProgressBar(value: (controller.subGoalDetails.value?.goalProgress ?? 0) / 100),
                                SizedBox(height: 15.h),
                              ],
                            );
                          }
                        ),
                      ),
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: SliverAppBarDelegate(
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.h),
                          child: TabBar(
                            controller: _tabController,
                            dividerColor: ColorUtils.secondaryBlue.withValues(
                              alpha: 0.2,
                            ),
                            indicatorColor: ColorUtils.secondaryBlue,
                            dividerHeight: 2.h,
                            padding: EdgeInsets.zero,
                            indicatorWeight: 2.h,
                            indicatorSize: TabBarIndicatorSize.tab,
                            tabs: tabTitles.map((title) {
                              return SizedBox(
                                height: 50.h,
                                child: Center(
                                  child: Text(
                                    title,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      color: ColorUtils.textWhite.withValues(
                                        alpha: 0.4,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ];
                },
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    GoalOverview(isGoal: false),
                    SubGoalTasks(),
                    GoalComments(isGoal: false),
                    GoalActivities(isGoal: false),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
