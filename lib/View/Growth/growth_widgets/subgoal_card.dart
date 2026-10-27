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

class SubGoalCard extends StatelessWidget {
  final Children? subGoal;
  const SubGoalCard({super.key, this.subGoal});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.of(context).push(
          newSlideNavigation(SubGoalDetailedView(subGoalId: subGoal?.goalId)),
        );
        Get.find<GrowthController>().goalDetails.value = null;
        Get.find<GrowthController>().goalActivityList.value = [];
      },
      child: Container(
        color: Colors.transparent,
        child: IntrinsicHeight(
          child: Row(
            children: [
              SizedBox(width: 25.h),
              Container(width: 1.h, color: ColorUtils.darkSurface),
              Container(
                height: 1.h,
                width: 15.h,
                color: ColorUtils.darkSurface,
              ),
              Container(
                height: 7.h,
                width: 7.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorUtils.darkSurface,
                ),
              ),
              SizedBox(width: 6.h),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 15.h,
                    bottom: 15.h,
                    right: 10.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subGoal?.goalTitile ?? '--',
                        style: GoogleFonts.inter(
                          fontSize: 13.h,
                          fontWeight: FontWeight.w400,
                          color: ColorUtils.textWhite.withValues(alpha: 0.7),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          // SizedBox(width: 6.h),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(1000).r,
                            child: CachedNetworkImage(
                              imageUrl:
                                  subGoal?.employee?.profilePicture ?? '--',
                              height: 23.h,
                              width: 23.h,
                              alignment: Alignment.center,
                              placeholder: (context, url) {
                                String name =
                                    "${subGoal?.employee?.firstName?.trim().substring(0, 1).toUpperCase() ?? ''}"
                                    "${(subGoal?.employee?.middleName?.trim().isNotEmpty ?? false) ? subGoal?.employee?.middleName?.trim().substring(0, 1).toUpperCase() ?? '' : subGoal?.employee?.lastName?.trim().substring(0, 1).toUpperCase() ?? ''}";
                                return Container(
                                  width: 23.h,
                                  height: 23.h,
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
                                      name,
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 9.h,
                                        color: ColorUtils.textWhite,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              errorWidget: (context, url, error) {
                                String name =
                                    "${subGoal?.employee?.firstName?.trim().substring(0, 1).toUpperCase() ?? ''}"
                                    "${(subGoal?.employee?.middleName?.trim().isNotEmpty ?? false) ? subGoal?.employee?.middleName?.trim().substring(0, 1).toUpperCase() ?? '' : subGoal?.employee?.lastName?.trim().substring(0, 1).toUpperCase() ?? ''}";
                                return Container(
                                  width: 23.h,
                                  height: 23.h,
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
                                      name,
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 9.h,
                                        color: ColorUtils.textWhite,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 8.h),
                          Expanded(
                            child: Text(
                              subGoal?.employeeName ?? '--',
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w400,
                                fontSize: 11.h,
                                color: ColorUtils.textWhite.withValues(
                                  alpha: 0.4,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 4.h),
                          if (subGoal?.taskCount?.totalTasks != 0)
                            Transform.rotate(
                              angle: (3 * 3.14) / 4,
                              child: Icon(
                                Icons.link,
                                color: ColorUtils.textWhite.withValues(
                                  alpha: 0.4,
                                ),
                                size: 15.h,
                              ),
                            ),
                          if (subGoal?.taskCount?.totalTasks != 0)
                            SizedBox(width: 3.h),
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 150.h),
                            child: Text(
                              '${subGoal?.taskCount?.totalTasks != 0 ? "${subGoal?.taskCount?.totalTasks ?? '--'} tasks    " : ''}${subGoal?.goalTimePeriodLabel ?? '--'}',
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w400,
                                fontSize: 11.h,
                                color: ColorUtils.textWhite.withValues(
                                  alpha: 0.4,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
