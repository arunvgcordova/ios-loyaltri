import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/Growth/growth_controller/growth_controller.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';

class SubGoalActionsSheet extends StatelessWidget {
  final bool isTaskAction;
  const SubGoalActionsSheet({super.key, required this.isTaskAction});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 18.h),
        child: IntrinsicHeight(
          child: Column(
            children: [
              Container(
                width: 121.h,
                height: 4.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(500.r),
                  color: ColorUtils.textWhite.withValues(alpha: 0.1),
                ),
              ),
              SizedBox(height: 18.h),
              Row(
                children: [
                  Text(
                    isTaskAction ? 'Task Actions' : 'Sub-goal Actions',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 15.h,
                      color: ColorUtils.textWhite.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18.h),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop(1);
                },
                borderRadius: BorderRadius.circular(14.r),
                child: actionWidget(
                  title: 'Edit',
                  subTitle: 'Edit ${isTaskAction ? 'Task' : 'sub-goal'} details',
                  icon: 'assets/images/growth/sub-goal-edit.png',
                ),
              ),
              // if (!isTaskAction) SizedBox(height: 10.h),
              // if (!isTaskAction)
              //   actionWidget(
              //     title: 'Share',
              //     subTitle: 'Share sub-goal link',
              //     icon: 'assets/images/growth/sub-goal-share.png',
              //   ),
              if (isTaskAction) SizedBox(height: 10.h),
              if (isTaskAction)
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop(4);
                  },
                  child: actionWidget(
                    title: 'Unlink from this sub-goal',
                    subTitle: 'Remove from this sub-goal only',
                    icon: 'assets/images/growth/unlink-icon.png',
                    color: 'yellow',
                  ),
                ),
              if (!isTaskAction) SizedBox(height: 10.h),
              if (!isTaskAction)
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop(2);
                  },
                  borderRadius: BorderRadius.circular(14.r),
                  child: actionWidget(
                    title: 'Add Task',
                    subTitle: 'Create Task for this sub-goal',
                    icon: 'assets/images/growth/sub-goal-add.png',
                  ),
                ),
              SizedBox(height: 10.h),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop(3);
                },
                child: actionWidget(
                  title: 'Delete ${isTaskAction ? 'Task' : 'sub-goal'}',
                  subTitle: 'Permanently delete this ${isTaskAction ? 'Task' : 'sub-goal'}',
                  icon: 'assets/images/air_ticket/delete_passenger.png',
                  color: 'red',
                ),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget actionWidget({
    required String title,
    required String subTitle,
    required String icon,
    String? color,
  }) {
    return Container(
      padding: EdgeInsets.all(13.h),
      decoration: BoxDecoration(
        color: color == 'red'
            ? ColorUtils.alertRed.withValues(alpha: 0.05)
            : ColorUtils.textWhite.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: color == 'red'
              ? ColorUtils.alertRed.withValues(alpha: 0.2)
              : ColorUtils.textWhite.withValues(alpha: 0.1),
          width: 0.6.h,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40.h,
            height: 40.h,
            decoration: BoxDecoration(
              color: color == 'red'
                  ? ColorUtils.alertRed.withValues(alpha: 0.1)
                  : color == 'yellow'
                  ? ColorUtils.vermilionOrange.withValues(alpha: 0.1)
                  : ColorUtils.secondaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Center(
              child: GetX<GrowthController>(
                builder: (GrowthController controller) {
                  if (controller.deleteLoading.value || controller.unlinkLoading.value) {
                    return SizedBox(
                      width: 20.h,
                      height: 20.h,
                      child: CircularProgressIndicator(
                        color: ColorUtils.coralRed,
                      ),
                    );
                  }
                  return Image.asset(icon, height: 20.h);
                },
              ),
            ),
          ),
          SizedBox(width: 12.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: 13.h,
                  color: color == 'red'
                      ? ColorUtils.coralRed
                      : ColorUtils.textWhite.withValues(alpha: 0.9),
                ),
              ),
              Text(
                subTitle,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: 11.h,
                  color: color == 'red'
                      ? ColorUtils.coralRed.withValues(alpha: 0.6)
                      : ColorUtils.textWhite.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class GoalActionsSheet extends StatelessWidget {
  const GoalActionsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 18.h),
        child: IntrinsicHeight(
          child: Column(
            children: [
              Container(
                width: 121.h,
                height: 4.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(500.r),
                  color: ColorUtils.textWhite.withValues(alpha: 0.1),
                ),
              ),
              SizedBox(height: 18.h),
              Row(
                children: [
                  Text(
                    'Goal Actions',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 15.h,
                      color: ColorUtils.textWhite.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18.h),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop(3);
                },
                borderRadius: BorderRadius.circular(14.r),
                child: actionWidget(
                  title: 'Add Subgoal',
                  subTitle: 'Create Subgoal for this Goal',
                  icon: 'assets/images/growth/sub-goal-add.png',
                ),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget actionWidget({
    required String title,
    required String subTitle,
    required String icon,
    String? color,
  }) {
    return Container(
      padding: EdgeInsets.all(13.h),
      decoration: BoxDecoration(
        color: color == 'red'
            ? ColorUtils.alertRed.withValues(alpha: 0.05)
            : ColorUtils.textWhite.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: color == 'red'
              ? ColorUtils.alertRed.withValues(alpha: 0.2)
              : ColorUtils.textWhite.withValues(alpha: 0.1),
          width: 0.6.h,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40.h,
            height: 40.h,
            decoration: BoxDecoration(
              color: color == 'red'
                  ? ColorUtils.alertRed.withValues(alpha: 0.1)
                  : color == 'yellow'
                  ? ColorUtils.vermilionOrange.withValues(alpha: 0.1)
                  : ColorUtils.secondaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Center(child: Image.asset(icon, height: 20.h)),
          ),
          SizedBox(width: 12.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: 13.h,
                  color: color == 'red'
                      ? ColorUtils.coralRed
                      : ColorUtils.textWhite.withValues(alpha: 0.9),
                ),
              ),
              Text(
                subTitle,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: 11.h,
                  color: color == 'red'
                      ? ColorUtils.coralRed.withValues(alpha: 0.6)
                      : ColorUtils.textWhite.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
