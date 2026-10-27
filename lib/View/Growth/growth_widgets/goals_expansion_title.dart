import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/CWidgets/cwidgets.dart';
import 'package:loyaltri_minimal/View/Growth/growth_controller/growth_controller.dart';
import 'package:loyaltri_minimal/View/Growth/growth_widgets/goal_detailed_view.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';
import '../../../models/goals_and_subgoals_model.dart';

class GoalsExpansionTitle extends StatelessWidget {
  final GoalData? goalData;
  final ValueNotifier isExpanded;
  const GoalsExpansionTitle({super.key, this.goalData, required this.isExpanded});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 6.h),
      decoration: BoxDecoration(
        color: Color(0xFF0D0D0D),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (goalData?.children?.isNotEmpty ?? false)
            Container(
              width: 24.h,
              height: 24.h,
              decoration: BoxDecoration(
                color: ColorUtils.textWhite.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Center(
                child: ValueListenableBuilder(
                  valueListenable: isExpanded,
                  builder: (context, value, child) {
                    return AnimatedRotation(
                      turns: value ? 0.25 : 0,
                      duration: const Duration(milliseconds: 100),
                      child: Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: ColorUtils.textWhite.withValues(alpha: 0.5),
                        size: 10.h,
                      ),
                    );
                  },
                ),
              ),
            ),
          if (goalData?.children?.isNotEmpty ?? false) SizedBox(width: 10.h),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Get.find<GrowthController>().selectedGoal.value = goalData;
                Navigator.of(context).push(
                  newSlideNavigation(GoalDetailedView(goalId: goalData?.goalId)),
                );
              },
              child: Container(
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goalData?.goalTitile ?? '--',
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 13.h,
                        fontWeight: FontWeight.w400,
                        color: ColorUtils.textWhite.withValues(alpha: 0.9),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(1000).r,
                                child: CachedNetworkImage(
                                  imageUrl:
                                      goalData?.employee?.profilePicture ??
                                      '--',
                                  height: 23.h,
                                  width: 23.h,
                                  alignment: Alignment.center,
                                  placeholder: (context, url) {
                                    String name =
                                        "${goalData?.employee?.firstName?.trim().substring(0, 1).toUpperCase() ?? ''}"
                                        "${(goalData?.employee?.middleName?.trim().isNotEmpty ?? false) ? goalData?.employee?.middleName?.trim().substring(0, 1).toUpperCase() ?? '' : goalData?.employee?.lastName?.trim().substring(0, 1).toUpperCase() ?? ''}";
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
                                        "${goalData?.employee?.firstName?.trim().substring(0, 1).toUpperCase() ?? ''}"
                                        "${(goalData?.employee?.middleName?.trim().isNotEmpty ?? false) ? goalData?.employee?.middleName?.trim().substring(0, 1).toUpperCase() ?? '' : goalData?.employee?.lastName?.trim().substring(0, 1).toUpperCase() ?? ''}";
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
                              Flexible(
                                child: Text(
                                  goalData?.employeeName ?? '--',
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
                              Text(
                                ' · ${goalData?.children?.length ?? '0'} sub-goals',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 11.h,
                                  color: ColorUtils.textWhite.withValues(
                                    alpha: 0.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 6.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.h,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: requestStatusColor(goalData?.goalStatus?.toLowerCase() ?? '').withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4.r),
                            border: Border.all(
                              color: requestStatusColor(goalData?.goalStatus?.toLowerCase() ?? '').withValues(alpha: 0.2),
                              width: 0.5.h,
                            ),
                          ),
                          child: Text(
                            goalData?.goalStatus ?? '--',
                            style: GoogleFonts.inter(
                              fontSize: 9.h,
                              fontWeight: FontWeight.w400,
                              color: ColorUtils.accentOrange,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    Row(
                      children: [
                        Expanded(child: EndCapProgressBar(value: (goalData?.goalProgress ?? 0) / 100)),
                        SizedBox(width: 8.h),
                        Text(
                          '${goalData?.goalProgress ?? '0'}%',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 9.26.h,
                            color: ColorUtils.textWhite.withValues(alpha: 0.4),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EndCapProgressBar extends StatelessWidget {
  final double value; // 0.0 → 1.0

  const EndCapProgressBar({super.key, required this.value});

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

            Positioned(
              left: progressWidth - 4.h,
              child: Container(
                width: 6.h,
                height: 8.h,
                decoration: BoxDecoration(
                  color: ColorUtils.coralRed,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(blurRadius: 7.r, color: ColorUtils.dangerRed),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
