import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/CWidgets/cwidgets.dart';
import 'package:loyaltri_minimal/View/Growth/growth_controller/growth_controller.dart';
import 'package:loyaltri_minimal/View/Growth/growth_widgets/subgoal_detailed_view.dart';
import '../../../models/goals_and_subgoals_model.dart';
import '../../../utils/color_utils.dart';
import '../../ManagerView/Manager_Task/task_controller/task_controller.dart';
import '../../ManagerView/Manager_Task/task_widgets/task_add_screen.dart';

class GoalOverview extends StatelessWidget {
  final bool isGoal;
  const GoalOverview({super.key, required this.isGoal});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Get.find<GrowthController>().fetchGoalsAndSubGoals();
        await Get.find<GrowthController>().fetchGoalDetails(
            isGoal ? Get.find<GrowthController>().goalDetails.value?.goalId : Get.find<GrowthController>().subGoalDetails.value?.goalId,
            fetchForGoal: isGoal,
        );
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.h),
          child: Column(
            children: [
              SizedBox(height: 15.h),
              Container(
                decoration: BoxDecoration(
                  color: ColorUtils.deepBackground,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: ColorUtils.textWhite.withValues(alpha: 0.05),
                    width: 0.6.h,
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(15.h),
                      child: Row(
                        children: [
                          Container(
                            width: 32.h,
                            height: 32.h,
                            decoration: BoxDecoration(
                              color: ColorUtils.textWhite.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Center(
                              child: Image.asset(
                                'assets/images/growth/assigned_user.png',
                                height: 16.h,
                              ),
                            ),
                          ),
                          SizedBox(width: 12.h),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(1000).r,
                            child: GetX<GrowthController>(
                              builder: (GrowthController controller) {
                                return CachedNetworkImage(
                                  imageUrl: isGoal 
                                      ? controller.goalDetails.value?.assignedEmployeeId?.toString() ?? '' 
                                      : controller.subGoalDetails.value?.assignedEmployeeId?.toString() ?? '',
                                  // subGoalData?.employee?.profilePicture ?? goalData?.employee?.profilePicture ??
                                  //     '--',
                                  height: 29.h,
                                  width: 29.h,
                                  alignment: Alignment.center,
                                  placeholder: (context, url) {
                                    // String name = "${(subGoalData?.employee?.firstName?.isNotEmpty ?? false) ? subGoalData?.employee?.firstName?.trim().substring(0, 1).toUpperCase() ?? '' : (goalData?.employee?.firstName?.isNotEmpty ?? false) ? goalData?.employee?.firstName?.trim().substring(0, 1).toUpperCase() ?? '' : ''}"
                                    //     "${(subGoalData?.employee?.middleName?.isNotEmpty ?? false) ? subGoalData?.employee?.middleName?.trim().substring(0, 1).toUpperCase() ?? '' : (goalData?.employee?.middleName?.isNotEmpty ?? false) ? goalData?.employee?.middleName?.trim().substring(0, 1).toUpperCase() ?? '' : ''}";
                                    return Container(
                                      width: 29.h,
                                      height: 29.h,
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
                                          employeeNameShortForm(isGoal ? controller.goalDetails.value?.assignedEmployee?.toString() ?? '' : controller.subGoalDetails.value?.assignedEmployee?.toString() ?? ''),
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 11.h,
                                            color: ColorUtils.textWhite,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  errorWidget: (context, url, error) {
                                    // String name = "${(subGoalData?.employee?.firstName?.isNotEmpty ?? false) ? subGoalData?.employee?.firstName?.trim().substring(0, 1).toUpperCase() ?? '' : (goalData?.employee?.firstName?.isNotEmpty ?? false) ? goalData?.employee?.firstName?.trim().substring(0, 1).toUpperCase() ?? '' : ''}"
                                    //     "${(subGoalData?.employee?.middleName?.isNotEmpty ?? false) ? subGoalData?.employee?.middleName?.trim().substring(0, 1).toUpperCase() ?? '' : (goalData?.employee?.middleName?.isNotEmpty ?? false) ? goalData?.employee?.middleName?.trim().substring(0, 1).toUpperCase() ?? '' : ''}";
                                    return Container(
                                      width: 29.h,
                                      height: 29.h,
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
                                          employeeNameShortForm(isGoal ? controller.goalDetails.value?.assignedEmployee?.toString() ?? '' : controller.subGoalDetails.value?.assignedEmployee?.toString() ?? ''),
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 11.h,
                                            color: ColorUtils.textWhite,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  fit: BoxFit.cover,
                                );
                              }
                            ),
                          ),
                          SizedBox(width: 10.h),
                          Flexible(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Assigned to',
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
                                      isGoal ? controller.goalDetails.value?.assignedEmployee?.toString() ?? '--' : controller.subGoalDetails.value?.assignedEmployee?.toString() ?? '--',
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13.h,
                                        color: ColorUtils.textWhite.withValues(
                                          alpha: 0.8,
                                        ),
                                      ),
                                    );
                                  }
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: ColorUtils.textWhite.withValues(alpha: 0.05),
                      thickness: 0.6.h,
                      height: 0,
                    ),
                    Padding(
                      padding: EdgeInsets.all(15.h),
                      child: Row(
                        children: [
                          Container(
                            width: 32.h,
                            height: 32.h,
                            decoration: BoxDecoration(
                              color: ColorUtils.textWhite.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Center(
                              child: Image.asset(
                                'assets/images/air_ticket/air_ticket_calendar.png',
                                height: 16.h,
                              ),
                            ),
                          ),
                          SizedBox(width: 12.h),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Due Date',
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
                                    '${isGoal ? controller.goalDetails.value?.goalDueDate ?? '--' : controller.subGoalDetails.value?.goalDueDate ?? '--'} • ${isGoal ? controller.goalDetails.value?.goalStatus ?? '--' : controller.subGoalDetails.value?.goalStatus ?? '--'}',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13.h,
                                      color: ColorUtils.textWhite.withValues(
                                        alpha: 0.8,
                                      ),
                                    ),
                                  );
                                }
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: ColorUtils.textWhite.withValues(alpha: 0.05),
                      thickness: 0.6.h,
                      height: 0,
                    ),
                    Padding(
                      padding: EdgeInsets.all(15.h),
                      child: Row(
                        children: [
                          Container(
                            width: 32.h,
                            height: 32.h,
                            decoration: BoxDecoration(
                              color: ColorUtils.textWhite.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Center(
                              child: Image.asset(
                                (!isGoal)
                                    ? 'assets/images/growth/parental_goal_icon.png'
                                    : 'assets/images/growth/company_paceholder.png',
                                height: 16.h,
                              ),
                            ),
                          ),
                          SizedBox(width: 12.h),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (!isGoal)
                                    ? 'Parent Goal'
                                    : 'Department',
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
                                    isGoal ? controller.goalDetails.value?.goalDepartment?.toString() ?? '--' : controller.goalDetails.value?.goalTitile?.toString() ?? '--',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13.h,
                                      color: (!isGoal)
                                          ? ColorUtils.skyBlue
                                          : ColorUtils.textWhite.withValues(
                                              alpha: 0.8,
                                            ),
                                    ),
                                  );
                                }
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    GetX<GrowthController>(
                        builder: (GrowthController controller) {
                          if(controller.goalDetails.value?.goalPriority == null) {
                            return SizedBox.shrink();
                          }
                        return Divider(
                          color: ColorUtils.textWhite.withValues(alpha: 0.05),
                          thickness: 0.6.h,
                          height: 0,
                        );
                      }
                    ),
                    GetX<GrowthController>(
                        builder: (GrowthController controller) {
                          if(controller.goalDetails.value?.goalPriority == null) {
                            return SizedBox.shrink();
                          }
                        return Padding(
                          padding: EdgeInsets.all(15.h),
                          child: Row(
                            children: [
                              Container(
                                width: 32.h,
                                height: 32.h,
                                decoration: BoxDecoration(
                                  color: ColorUtils.textWhite.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Center(
                                  child: Image.asset(
                                    'assets/images/growth/exclamation_rounded.png',
                                    height: 16.h,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.h),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Priority',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 11.h,
                                      color: ColorUtils.textWhite.withValues(
                                        alpha: 0.4,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 2.h,
                                      horizontal: 7.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: requestStatusColor(isGoal ? controller.goalDetails.value?.goalPriority?.toLowerCase() ?? '' : controller.subGoalDetails.value?.goalPriority?.toLowerCase() ?? '').withValues(
                                        alpha: 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(4.r),
                                      border: Border.all(
                                        color: requestStatusColor(isGoal ? controller.goalDetails.value?.goalPriority?.toLowerCase() ?? '' : controller.subGoalDetails.value?.goalPriority?.toLowerCase() ?? '').withValues(
                                          alpha: 0.2,
                                        ),
                                        width: 0.6.h,
                                      ),
                                    ),
                                    child: Text(
                                      isGoal ? controller.goalDetails.value?.goalPriority ?? '' : controller.subGoalDetails.value?.goalPriority ?? '',
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 11.h,
                                        color: requestStatusColor(isGoal ? controller.goalDetails.value?.goalPriority?.toLowerCase() ?? '' : controller.subGoalDetails.value?.goalPriority?.toLowerCase() ?? ''),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }
                    ),
                  ],
                ),
              ),
              GetX<GrowthController>(
                    builder: (GrowthController controller) {
                      bool showHeight = false;
                      if(isGoal && (controller.goalDetails.value?.goalDescription?.isNotEmpty ?? false)) {
                        showHeight = true;
                      } else if(!isGoal && (controller.subGoalDetails.value?.goalDescription?.isNotEmpty ?? false)) {
                        showHeight = true;
                      }
                    return SizedBox(height: showHeight ? 10.h : 0);
                  }
                ),
                GetX<GrowthController>(
                    builder: (GrowthController controller) {
                      bool showContainer = false;
                      if(isGoal && (controller.goalDetails.value?.goalDescription?.isNotEmpty ?? false)) {
                        showContainer = true;
                      } else if(!isGoal && (controller.subGoalDetails.value?.goalDescription?.isNotEmpty ?? false)) {
                        showContainer = true;
                      }
                      if(showContainer) {
                        return Container(
                          padding: EdgeInsets.all(15.h),
                          decoration: BoxDecoration(
                            color: ColorUtils.deepBackground,
                            borderRadius: BorderRadius.circular(14.r),
                            border: Border.all(
                              color: ColorUtils.textWhite.withValues(alpha: 0.05),
                              width: 0.6.h,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Description',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13.h,
                                      color: ColorUtils.textWhite.withValues(alpha: 0.9),
                                    ),
                                  ),
                                  // Container(
                                  //   width: 24.h,
                                  //   height: 24.h,
                                  //   decoration: BoxDecoration(
                                  //     color: ColorUtils.textWhite.withValues(alpha: 0.05),
                                  //     borderRadius: BorderRadius.circular(8.r),
                                  //   ),
                                  //   child: Center(
                                  //     child: Image.asset(
                                  //       'assets/images/growth/edit_icon.png',
                                  //       height: 12.h,
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                isGoal ? controller.goalDetails.value?.goalDescription?.toString() ?? '--' : controller.subGoalDetails.value?.goalDescription?.toString() ?? '--',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13.h,
                                  color: ColorUtils.textWhite.withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                  }
                ),
              SizedBox(height: 10.h),
              if(!isGoal)
                Container(
                  padding: EdgeInsets.all(15.h),
                  decoration: BoxDecoration(
                    color: ColorUtils.deepBackground,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: ColorUtils.textWhite.withValues(alpha: 0.05),
                      width: 0.6.h,
                    ),
                  ),
                  child: GetX<GrowthController>(
                      builder: (GrowthController controller) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Linked Tasks',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 11.h,
                                  color: ColorUtils.textWhite.withValues(alpha: 0.4),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 3.h),
                          Row(
                            children: [
                              Text(
                                controller.subGoalDetails.value?.taskCount?.totalTasks?.toString() ?? '0',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 23.h,
                                  color: ColorUtils.textWhite.withValues(alpha: 0.9),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 3.h),
                          Row(
                            children: [
                              Text(
                                '${controller.subGoalDetails.value?.taskCount?.activeTasks?.toString() ?? '0'} active',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 11.h,
                                  color: ColorUtils.skyBlue,
                                ),
                              ),
                              SizedBox(width: 10.h),
                              Text(
                                '${controller.subGoalDetails.value?.taskCount?.overdueTasks?.toString() ?? '0'} Overdue',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 11.h,
                                  color: ColorUtils.coralRed,
                                ),
                              ),
                              SizedBox(width: 10.h),
                              Text(
                                '${controller.subGoalDetails.value?.taskCount?.completedTasks?.toString() ?? '0'} completed',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 11.h,
                                  color: ColorUtils.neonGreen,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                  ),
                ),
              // if(!(isSubGoal ?? false))
              //   Container(
              //   padding: EdgeInsets.all(15.h),
              //   decoration: BoxDecoration(
              //     color: ColorUtils.deepBackground,
              //     borderRadius: BorderRadius.circular(14.r),
              //     border: Border.all(
              //       color: ColorUtils.textWhite.withValues(alpha: 0.05),
              //       width: 0.6.h,
              //     ),
              //   ),
              //   child: Column(
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       Row(
              //         children: [
              //           Text(
              //             'Attachments',
              //             style: GoogleFonts.inter(
              //               fontWeight: FontWeight.w700,
              //               fontSize: 13.h,
              //               color: ColorUtils.textWhite.withValues(alpha: 0.9),
              //             ),
              //           ),
              //         ],
              //       ),
              //       SizedBox(height: 15.h),
              //       SingleChildScrollView(
              //         scrollDirection: Axis.horizontal,
              //         child: Row(
              //           children: [
              //             for (int i = 0; i < 4; i++)
              //               Padding(
              //                 padding: EdgeInsets.only(right: 8.h),
              //                 child: Container(
              //                   padding: EdgeInsets.all(10.h),
              //                   decoration: BoxDecoration(
              //                     color: ColorUtils.textWhite.withValues(
              //                       alpha: 0.05,
              //                     ),
              //                     borderRadius: BorderRadius.circular(9.r),
              //                     border: Border.all(
              //                       color: ColorUtils.textWhite.withValues(
              //                         alpha: 0.1,
              //                       ),
              //                     ),
              //                   ),
              //                   child: Column(
              //                     mainAxisSize: MainAxisSize.min,
              //                     children: [
              //                       Image.asset(
              //                         'assets/images/growth/files_icon.png',
              //                         height: 22.h,
              //                       ),
              //                       SizedBox(height: 5.h),
              //                       Text(
              //                         'Python Script..',
              //                         style: GoogleFonts.inter(
              //                           fontWeight: FontWeight.w400,
              //                           fontSize: 7.h,
              //                           color: ColorUtils.textWhite.withValues(
              //                             alpha: 0.4,
              //                           ),
              //                         ),
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //               ),
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // if(!(isSubGoal ?? false))
              //   SizedBox(height: 10.h),
              if(isGoal)
                Container(
                padding: EdgeInsets.all(15.h),
                decoration: BoxDecoration(
                  color: ColorUtils.deepBackground,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: ColorUtils.textWhite.withValues(alpha: 0.05),
                    width: 0.6.h,
                  ),
                ),
                child: GetX<GrowthController>(
                    builder: (GrowthController controller) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Sub-goals (${controller.selectedGoal.value?.children?.length ?? 0})',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w700,
                                fontSize: 13.h,
                                color: ColorUtils.textWhite.withValues(alpha: 0.9),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.h),
                        for (int i = 0; i < (controller.selectedGoal.value?.children?.length ?? 0); i++)
                          Padding(
                            padding: EdgeInsets.only(bottom: 8.h),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(newSlideNavigation(SubGoalDetailedView(subGoalId: controller.selectedGoal.value?.children?[i].goalId)));
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10.h,
                                  horizontal: 13.h,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.r),
                                  color: ColorUtils.textWhite.withValues(alpha: 0.05),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: [
                                                Text(
                                                  controller.selectedGoal.value?.children?[i].goalTitile ?? '--',
                                                  style: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 13.h,
                                                    color: ColorUtils.textWhite
                                                        .withValues(alpha: 0.9),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 6.h),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: SubGoalProgressBar(value: (controller.selectedGoal.value?.children?[i].goalProgress ?? 0) / 100),
                                              ),
                                              SizedBox(width: 8.h),
                                              Text(
                                                '${controller.selectedGoal.value?.children?[i].goalProgress?.toStringAsFixed(0) ?? '0'}%',
                                                style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 11.h,
                                                  color: ColorUtils.textWhite
                                                      .withValues(alpha: 0.4),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 2.h),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 6.h),
                                    Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      color: ColorUtils.textWhite.withValues(
                                        alpha: 0.3,
                                      ),
                                      size: 13.h,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        SizedBox(height: 6.h),
                        InkWell(
                          onTap: () {
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
                          },
                          child: Container(
                            padding: EdgeInsets.all(15.h),
                            decoration: BoxDecoration(
                              color: ColorUtils.secondaryBlue.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                color: ColorUtils.secondaryBlue.withValues(alpha: 0.2),
                                width: 0.6.h,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add,
                                  color: ColorUtils.textWhite,
                                  size: 17.h,
                                ),
                                SizedBox(width: 8.h),
                                Text(
                                  'Add Sub-goal',
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
                      ],
                    );
                  }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SubGoalProgressBar extends StatelessWidget {
  final double value; // 0.0 → 1.0

  const SubGoalProgressBar({super.key, required this.value});

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
                color: ColorUtils.textWhite.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(500.r),
              ),
            ),

            Container(
              height: 4.h,
              width: progressWidth,
              decoration: BoxDecoration(
                color: ColorUtils.secondaryBlue,
                borderRadius: BorderRadius.circular(500.r),
              ),
            ),
          ],
        );
      },
    );
  }
}
