import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/Growth/growth_controller/growth_controller.dart';
import 'package:loyaltri_minimal/View/Growth/growth_widgets/goalsAndSubgoalSearchField.dart';
import 'package:loyaltri_minimal/View/Growth/growth_widgets/goals_expansion_title.dart';
import 'package:loyaltri_minimal/View/Growth/growth_widgets/subgoal_card.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';
import 'growth_widgets/app_bar.dart';

class GoalsAndSubGoals extends StatelessWidget {
  GoalsAndSubGoals({super.key});
  final GrowthController growthController = Get.find<GrowthController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: ColorUtils.workEntryHead,
          body: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.h),
            child: Column(
              children: [
                GrowthAppBar2(title: 'Goals & Subgoals'),
                SizedBox(height: 15.h),
                GoalsSearchAndFilter(
                  color: ColorUtils.veryDarkGrey,
                  result: (p0) {
                    growthController.filterText.value = p0;
                    growthController.filterGoals();
                  },
                  isDarkMode: true,
                ),
                SizedBox(height: 15.h),
                Expanded(
                  child: Obx(() {
                    return RefreshIndicator(
                      onRefresh: () async {
                        await growthController.fetchGoalsAndSubGoals(
                          removeList: false,
                        );
                      },
                      child: growthController.goalsLoading.value
                          ? Center(
                              child: Text(
                                "Loading...",
                                style: GoogleFonts.inter(
                                  color: ColorUtils.textWhite.withValues(
                                    alpha: 0.5,
                                  ),
                                  fontSize: 12.h,
                                ),
                              ),
                            )
                          : growthController.goalsAndSubgoalsList.value.isEmpty
                          ? LayoutBuilder(
                              builder: (context, constraints) {
                                return SingleChildScrollView(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minHeight: constraints.maxHeight,
                                    ),
                                    child: IntrinsicHeight(
                                      child: Center(
                                        child: Text(
                                          "No Data Found",
                                          style: GoogleFonts.inter(
                                            color: ColorUtils.textWhite
                                                .withValues(alpha: 0.5),
                                            fontSize: 12.h,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : ListView.separated(
                              itemCount: growthController
                                  .goalsAndSubgoalsList
                                  .value
                                  .length,
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                final goal = growthController.goalsAndSubgoalsList.value[index];
                                final search = growthController.filterText.value.trim().toLowerCase();
                                final parentMatch = search.isNotEmpty && (goal.goalTitile?.trim().toLowerCase().contains(search) ?? false);
                                final childMatch = search.isNotEmpty && (goal.children?.any((child) => child.goalTitile?.trim().toLowerCase().contains(search) ?? false) ?? false);
                                final shouldExpand = childMatch && !parentMatch;

                                return Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0D0D0D),
                                    borderRadius: BorderRadius.circular(14.r),
                                    border: Border.all(
                                      color: ColorUtils.textWhite.withValues(
                                        alpha: 0.15,
                                      ),
                                      width: 0.6.h,
                                    ),
                                  ),
                                  child: Theme(
                                    data: Theme.of(context).copyWith(
                                      dividerColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                    ),
                                    child: ExpansionTile(
                                      key: ValueKey('${goal.goalId}_$shouldExpand'),
                                      showTrailingIcon: false,
                                      splashColor: Colors.transparent,
                                      tilePadding: EdgeInsets.zero,
                                      childrenPadding: EdgeInsets.zero,
                                      initiallyExpanded: shouldExpand,
                                      onExpansionChanged: (value) {
                                        growthController
                                                .expansionNotifier[index]
                                                .value =
                                            value;
                                      },
                                      title: GoalsExpansionTitle(
                                        goalData: goal,
                                        isExpanded: growthController
                                            .expansionNotifier[index],
                                      ),
                                      children: [
                                        if (goal.children?.isNotEmpty ?? false)
                                          Divider(
                                            color: ColorUtils.textWhite
                                                .withValues(alpha: 0.15),
                                            thickness: 0.6.h,
                                            height: 1.h,
                                          ),
                                        if (goal.children?.isNotEmpty ?? false)
                                          ListView.separated(
                                            key: ValueKey('list_${goal.goalId}'),
                                            itemCount: goal.children?.length ?? 0,
                                            shrinkWrap: true,
                                            padding: EdgeInsets.zero,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, childIndex) {
                                              return SubGoalCard(
                                                subGoal: goal.children?[childIndex],
                                              );
                                            },
                                            separatorBuilder: (context, index) =>
                                                Divider(
                                                  color: ColorUtils.workEntryHead,
                                                  thickness: 0.6.h,
                                                  height: 0,
                                                ),
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 10.h),
                            ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
