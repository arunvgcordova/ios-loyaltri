import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/models/goals_and_subgoals_model.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../CWidgets/cwidgets.dart';
import '../growth_controller/growth_controller.dart';

class GoalActivities extends StatelessWidget {
  final bool isGoal;
  GoalActivities({super.key, required this.isGoal});
  final ValueNotifier<bool> expandText = ValueNotifier(false);
  final GrowthController growthController = Get.find<GrowthController>();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Get.find<GrowthController>().fetchGoalDetails(isGoal
            ? growthController.goalDetails.value?.goalId
            : growthController.subGoalDetails.value?.goalId, fetchForGoal: isGoal);
      },
      child: GetX<GrowthController>(
        builder: (GrowthController controller) {
          if (controller.activityLoading.value) {
            return Center(
              child: SpinKitThreeInOut(
                color: ColorUtils.primaryBlue,
                size: 28.h,
              ),
            );
          } else if(isGoal ? controller.goalActivityList.value.isEmpty : controller.subGoalActivityList.value.isEmpty) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: 200.h),
                Center(
                  child: Text(
                    "No Data Found",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 12.h,
                      color: ColorUtils.textWhite.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ],
            );
          }
          return ListView.separated(
            itemCount: isGoal ? controller.goalActivityList.value.length : controller.subGoalActivityList.value.length,
            padding: EdgeInsets.only(left: 15.h, right: 15.h, top: 15.h),
            itemBuilder: (context, index) {
              ActivityData activityData = isGoal ? controller.goalActivityList.value[index] : controller.subGoalActivityList.value[index];
              String? dateTime;
              try {
                final formatter = DateFormat('dd MMM yyyy hh:mm a', 'en_US');

                final input = "${activityData.date} ${activityData.time}"
                    .replaceAllMapped(
                      RegExp(r'\b(am|pm)\b', caseSensitive: false),
                      (m) => m.group(0)!.toUpperCase(),
                    );

                final parsed = formatter.parse(input);
                dateTime = timeago.format(parsed);
              } catch (e) {
                debugPrint('Parse error: $e');
              }
              return Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10.h),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(1000).r,
                      child: CachedNetworkImage(
                        imageUrl: activityData.image ?? '--',
                        height: 30.h,
                        width: 30.h,
                        alignment: Alignment.center,
                        placeholder: (context, url) {
                          String name = employeeNameShortForm(
                            activityData.employeeName ?? '',
                          );
                          return Container(
                            width: 30.h,
                            height: 30.h,
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
                                  fontSize: 11.h,
                                  color: ColorUtils.textWhite,
                                ),
                              ),
                            ),
                          );
                        },
                        errorWidget: (context, url, error) {
                          String name = employeeNameShortForm(
                            activityData.employeeName ?? '',
                          );
                          return Container(
                            width: 30.h,
                            height: 30.h,
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
                                  fontSize: 11.h,
                                  color: ColorUtils.textWhite,
                                ),
                              ),
                            ),
                          );
                        },
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.h),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        expandText.value = !expandText.value;
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ValueListenableBuilder(
                              valueListenable: expandText,
                              builder: (context, value, child) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (value)
                                      Container(
                                        color: Colors.transparent,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            top: 10.h,
                                            bottom: 5.h,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                activityData.employeeName ??
                                                    '--',
                                                softWrap: true,
                                                style: GoogleFonts.inter(
                                                  fontSize: 13.h,
                                                  fontWeight: FontWeight.w700,
                                                  color: ColorUtils.textWhite
                                                      .withValues(alpha: 0.9),
                                                ),
                                              ),
                                              SizedBox(width: 10.h),
                                              Text(
                                                activityData.message ?? '--',
                                                softWrap: true,
                                                style: GoogleFonts.inter(
                                                  fontSize: 13.h,
                                                  fontWeight: FontWeight.w400,
                                                  color: ColorUtils.textWhite
                                                      .withValues(alpha: 0.5),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    else
                                      Container(
                                        color: Colors.transparent,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            top: 10.h,
                                            bottom: 5.h,
                                          ),
                                          child: Row(
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  activityData.employeeName ??
                                                      '--',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.inter(
                                                    fontSize: 13.h,
                                                    fontWeight: FontWeight.w700,
                                                    color: ColorUtils.textWhite
                                                        .withValues(alpha: 0.9),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 10.h),
                                              ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  maxWidth: 200.h,
                                                ),
                                                child: Text(
                                                  activityData.message ?? '--',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.inter(
                                                    fontSize: 13.h,
                                                    fontWeight: FontWeight.w400,
                                                    color: ColorUtils.textWhite
                                                        .withValues(alpha: 0.5),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                            Text(
                              dateTime ?? '--',
                              style: GoogleFonts.inter(
                                fontSize: 11.h,
                                fontWeight: FontWeight.w400,
                                color: ColorUtils.textWhite.withValues(
                                  alpha: 0.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
            separatorBuilder: (context, index) {
              return Row(
                children: [
                  SizedBox(width: 15.h),
                  Container(
                    width: 1.h,
                    height: 15.h,
                    color: ColorUtils.textWhite.withValues(alpha: 0.1),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
