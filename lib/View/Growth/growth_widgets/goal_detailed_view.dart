import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loyaltri_minimal/View/Growth/growth_widgets/app_bar.dart';
import 'package:loyaltri_minimal/View/Growth/growth_widgets/goal_activities.dart';
import 'package:loyaltri_minimal/View/Growth/growth_widgets/goal_comments.dart';
import 'package:loyaltri_minimal/View/Growth/growth_widgets/goal_overview.dart';
import 'package:loyaltri_minimal/View/Growth/growth_widgets/subgoal_actions_sheet.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Task/task_controller/task_controller.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';

import '../../../controller/userProfileController.dart';
import '../../../models/goals_and_subgoals_model.dart';
import '../../CWidgets/cwidgets.dart';
import '../../ManagerView/Manager_Task/task_widgets/task_add_screen.dart';
import '../growth_controller/growth_controller.dart';

class GoalDetailedView extends StatefulWidget {
  final int? goalId;
  const GoalDetailedView({super.key, this.goalId});

  @override
  State<GoalDetailedView> createState() => _GoalDetailedViewState();
}

class _GoalDetailedViewState extends State<GoalDetailedView>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final List<String> tabTitles = ['Overview', 'Comments', 'Activities'];

  TabController? _tabController;

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  Future<void> _initialize() async {
    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(length: tabTitles.length, vsync: this);
    context.loaderOverlay.show();
    await Get.find<GrowthController>().fetchGoalDetails(widget.goalId, fetchForGoal: true);
    context.loaderOverlay.hide();
    await Get.find<GrowthController>().fetchGoalComments(goalId: widget.goalId, fetchForGoal: true);
    String? employeeId = Get.find<UserProfileController>().userData.value.result.employeeId;
    String? companyId = Get.find<UserProfileController>().userData.value.result.companyId;
    await Get.find<ManagerTaskController>().fetchTaskListData(empId: employeeId ?? '', compId: companyId ?? '');
  }

  @override
  void didChangeMetrics() {
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyleDark);
    super.didChangeMetrics();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tabController?.dispose();
    Get.find<GrowthController>().goalDataLoaded.value = false;
    super.dispose();
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
                  title: 'Goal',
                  callback: () async {
                    int? action = await showModalBottomSheet(
                      context: context,
                      backgroundColor: ColorUtils.veryDarkNaturalDGrey,
                      builder: (context) {
                        return GoalActionsSheet();
                      },
                    );
                    if(action == 3) {
                      ManagerTaskController managerTaskController = Get.find<ManagerTaskController>();
                      managerTaskController.activityLogList.value = [];
                      managerTaskController.activityLogList.refresh();
                      managerTaskController.detailedTaskData.value = null;
                      Navigator.of(context).push(
                          fadeNavigation(TaskAddScreen(
                            taskCreate: true,
                            isDarkMode: true,
                            subGoalCreate: true,
                            fromGoals: true,
                          ))
                      );
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GetX<GrowthController>(
                              builder: (GrowthController controller) {
                                return Text(
                                  controller.goalDetails.value?.goalTitile ?? '--',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 19.h,
                                    color: ColorUtils.textWhite.withValues(
                                      alpha: 0.9,
                                    ),
                                  ),
                                );
                              }
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
                                GetX<GrowthController>(
                                    builder: (GrowthController controller) {
                                    return Text(
                                      '${controller.goalDetails.value?.goalProgress ?? 0}%',
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13.h,
                                        color: ColorUtils.textWhite.withValues(
                                          alpha: 0.7,
                                        ),
                                      ),
                                    );
                                  }
                                ),
                              ],
                            ),
                            SizedBox(height: 6.h),
                            GetX<GrowthController>(
                                builder: (GrowthController controller) {
                                return GreenProgressBar(value: (controller.goalDetails.value?.goalProgress ?? 0)/100);
                              }
                            ),
                            SizedBox(height: 15.h),
                          ],
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
                    GoalOverview(isGoal: true),
                    GoalComments(isGoal: true),
                    GoalActivities(isGoal: true),
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

class GreenProgressBar extends StatelessWidget {
  final double value; // 0.0 → 1.0

  const GreenProgressBar({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final barWidth = constraints.maxWidth;
        final progressWidth = barWidth * value;

        return Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              height: 4.h,
              decoration: BoxDecoration(
                color: ColorUtils.appBackground,
                borderRadius: BorderRadius.circular(500.r),
              ),
            ),

            Container(
              height: 4.h,
              width: progressWidth,
              decoration: BoxDecoration(
                color: ColorUtils.successGreen,
                borderRadius: BorderRadius.circular(500.r),
              ),
            ),
          ],
        );
      },
    );
  }
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate(this._tabBar);
  final Widget _tabBar;

  @override
  double get minExtent => 50.h;
  @override
  double get maxExtent => 50.h;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: ColorUtils.workEntryHead, child: _tabBar);
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) => false;
}
