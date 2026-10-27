
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/CWidgets/cwidgets.dart';
import 'package:loyaltri_minimal/View/Growth/growth_controller/growth_controller.dart';
import '../../../../utils/color_utils.dart';
import '../goals_and_subGoals.dart';
import 'goal_detailed_view.dart';

class GoalsAndSubHomeCard extends StatelessWidget {
  const GoalsAndSubHomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<GrowthController>(
      builder: (GrowthController controller) {
        if(controller.goalsAndSubgoalsList.value.isNotEmpty) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: ColorUtils.workEntryHead,
                padding: EdgeInsets.symmetric(horizontal: 15.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Goals & Subgoals',
                      style: GoogleFonts.urbanist(
                        fontSize: 15.h,
                        fontWeight: FontWeight.w500,
                        color: ColorUtils.textWhite,
                        letterSpacing: -0.1,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        controller.filterText.value = '';
                        Navigator.of(context).push(
                          newSlideNavigation(GoalsAndSubGoals())
                        );
                      },
                      child: Text(
                        'View All',
                        style: GoogleFonts.urbanist(
                          fontSize: 13.h,
                          fontWeight: FontWeight.w500,
                          color: ColorUtils.textWhite,
                          decorationColor: ColorUtils.textWhite,
                          decoration: TextDecoration.underline,
                          letterSpacing: -0.1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: ColorUtils.workEntryHead,
                padding: EdgeInsets.only(
                  left: 15.h,
                  right: 15.h,
                  top: 20.h,
                  bottom: 40.h,
                ),
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width,
                ),
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      SizedBox(width: 8.h),
                      for (int i = 0; i < controller.goalsAndSubgoalsList.value.length; i++)
                        Padding(
                          padding: EdgeInsets.only(right: 10.h),
                          child: GestureDetector(
                            onTap: () {
                              Get.find<GrowthController>().selectedGoal.value = controller.goalsAndSubgoalsList.value[i];
                              Navigator.of(context).push(
                                newSlideNavigation(GoalDetailedView(goalId: controller.goalsAndSubgoalsList.value[i].goalId)),
                              );
                            },
                            child: Container(
                              width: 261.h,
                              padding: EdgeInsets.all(10.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.r),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    ColorUtils.mutedIndigo,
                                    ColorUtils.midnightBluePurple,
                                  ],
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 36.h,
                                        height: 35.h,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(10.r),
                                          color: ColorUtils.textWhite,
                                        ),
                                        child: Center(
                                          child: Image.asset(
                                            'assets/images/growth/goal-archery-white.png',
                                            color: ColorUtils.secondaryBlue,
                                            height: 19.h,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8.h),
                                      Text(
                                        'Goal',
                                        style: GoogleFonts.urbanist(
                                          fontSize: 13.h,
                                          fontWeight: FontWeight.w600,
                                          color: ColorUtils.textWhite
                                              .withValues(alpha: 0.8),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.h),
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          controller.goalsAndSubgoalsList.value[i].goalTitile ?? '--',
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.urbanist(
                                            fontSize: 16.h,
                                            fontWeight: FontWeight.w600,
                                            color: ColorUtils.textWhite,
                                            letterSpacing: -0.1,
                                          ),
                                          maxLines: 3,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15.h),
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(1.5.h),
                                        decoration: BoxDecoration(
                                          color: ColorUtils.textWhite,
                                          shape: BoxShape.circle,
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(1000).r,
                                          child: CachedNetworkImage(
                                            imageUrl: controller.goalsAndSubgoalsList.value[i].employee?.profilePicture ?? '--',
                                            height: 34.h,
                                            width: 34.h,
                                            alignment: Alignment.center,
                                            placeholder: (context, url) {
                                              return Container(
                                                width: 34.h,
                                                height: 34.h,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.grey.shade200,
                                                ),
                                                child: Center(
                                                  child: Icon(
                                                    Icons.person,
                                                    color: Colors.grey,
                                                    size: 18.h,
                                                  ),
                                                ),
                                              );
                                            },
                                            errorWidget: (context, url, error) {
                                              return Container(
                                                width: 34.h,
                                                height: 34.h,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.grey.shade200,
                                                ),
                                                child: Center(
                                                  child: Icon(
                                                    Icons.person,
                                                    color: Colors.grey,
                                                    size: 18.h,
                                                  ),
                                                ),
                                              );
                                            },
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      // CircleAvatar(
                                      //   radius: 18.r,
                                      //   backgroundColor: ColorUtils.textWhite,
                                      //   child: Center(
                                      //     child: Image.asset(
                                      //       'assets/examples/portrait_male.png',
                                      //       height: 32.h,
                                      //     ),
                                      //   ),
                                      // ),
                                      SizedBox(width: 8.h),
                                      Flexible(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              controller.goalsAndSubgoalsList.value[i].employeeName ?? '--',
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                fontSize: 11.h,
                                                fontWeight: FontWeight.w500,
                                                color: ColorUtils.textWhite
                                                    .withValues(alpha: 0.9),
                                              ),
                                            ),
                                            Text(
                                              controller.goalsAndSubgoalsList.value[i].getEmployeeDesignation ?? '--',
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                fontSize: 11.h,
                                                fontWeight: FontWeight.w400,
                                                color: ColorUtils.textWhite
                                                    .withValues(alpha: 0.5),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20.h),
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minWidth: MediaQuery.of(context).size.width,
                                    ),
                                    child: SingleChildScrollView(
                                      physics: AlwaysScrollableScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          // for(int i = 0; i < 5; i++)
                                          Padding(
                                            padding: EdgeInsets.only(right: 8.h),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 4.h,
                                                horizontal: 10.h,
                                              ),
                                              decoration: BoxDecoration(
                                                color: ColorUtils.textWhite.withValues(alpha: 0.1),
                                                borderRadius: BorderRadius.circular(30.r),
                                              ),
                                              child: Text(
                                                controller.goalsAndSubgoalsList.value[i].goalTimePeriodLabel ?? '--',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 11.h,
                                                  fontWeight: FontWeight.w500,
                                                  color: ColorUtils.textWhite,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(right: 8.h),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 4.h,
                                                horizontal: 10.h,
                                              ),
                                              decoration: BoxDecoration(
                                                color: ColorUtils.textWhite.withValues(alpha: 0.1),
                                                borderRadius: BorderRadius.circular(30.r),
                                              ),
                                              child: Text(
                                                controller.goalsAndSubgoalsList.value[i].department?.department ?? '--',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 11.h,
                                                  fontWeight: FontWeight.w500,
                                                  color: ColorUtils.textWhite,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        } else {
          return SizedBox.shrink();
        }
      }
    );
  }
}
