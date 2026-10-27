import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/CWidgets/cwidgets.dart';
import 'package:loyaltri_minimal/View/Growth/growth_controller/growth_controller.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../models/goals_and_subgoals_model.dart';
import '../../ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';

class GoalComments extends StatefulWidget {
  final bool isGoal;
  const GoalComments({super.key, required this.isGoal});

  @override
  State<GoalComments> createState() => _GoalCommentsState();
}

class _GoalCommentsState extends State<GoalComments> {
  GrowthController growthController = Get.find<GrowthController>();
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    Get.find<GrowthController>().commentText = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await growthController.fetchGoalComments(
            goalId: widget.isGoal
                ? growthController.goalDetails.value?.goalId
                : growthController.subGoalDetails.value?.goalId,
            fetchForGoal: widget.isGoal,
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
                  color: ColorUtils.textWhite.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(13.r),
                  border: Border.all(
                    color: ColorUtils.textWhite.withValues(alpha: 0.1),
                    width: 0.6.h,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: commentController,
                      onChanged: (value) {
                        Get.find<GrowthController>().commentText = value;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Write a comment...',
                        hintStyle: GoogleFonts.inter(
                          fontSize: 13.h,
                          fontWeight: FontWeight.w400,
                          color: ColorUtils.textWhite.withValues(alpha: 0.3),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 15.h,
                          vertical: 15.h,
                        ),
                      ),
                      style: GoogleFonts.inter(
                        fontSize: 13.h,
                        fontWeight: FontWeight.w400,
                        color: ColorUtils.textWhite.withValues(alpha: 0.9),
                      ),
                      maxLines: 3,
                    ),
                    Row(
                      children: [
                        SizedBox(width: 5.h),
                        // Padding(
                        //   padding: EdgeInsets.symmetric(
                        //     horizontal: 8.h,
                        //     vertical: 8.h,
                        //   ),
                        //   child: Icon(
                        //     Icons.camera_alt_outlined,
                        //     color: ColorUtils.textWhite.withValues(alpha: 0.3),
                        //     size: 20.h,
                        //   ),
                        // ),
                        // Padding(
                        //   padding: EdgeInsets.symmetric(
                        //     horizontal: 8.h,
                        //     vertical: 8.h,
                        //   ),
                        //   child: Transform.rotate(
                        //     angle: -3.14 / 4,
                        //     child: Icon(
                        //       Icons.attachment_outlined,
                        //       color: ColorUtils.textWhite.withValues(alpha: 0.3),
                        //       size: 20.h,
                        //     ),
                        //   ),
                        // ),
                        // Padding(
                        //   padding: EdgeInsets.symmetric(
                        //     horizontal: 8.h,
                        //     vertical: 8.h,
                        //   ),
                        //   child: Icon(
                        //     Icons.alternate_email,
                        //     color: ColorUtils.textWhite.withValues(alpha: 0.3),
                        //     size: 20.h,
                        //   ),
                        // ),
                        Spacer(),
                        GetX<GrowthController>(
                          builder: (GrowthController controller) {
                            return InkWell(
                              onTap: () async {
                                if(controller.commentText.trim().isNotEmpty) {
                                  await controller.sendComment(widget.isGoal
                                      ? growthController.goalDetails.value?.goalId
                                      : growthController.subGoalDetails.value?.goalId, isGoal: widget.isGoal);
                                  commentController.clear();
                                  if(controller.commentSentError.value.isNotEmpty) {
                                    AttendanceCommonWidgets().showSnackBar(
                                      context: context,
                                      backgroundColor: Colors.red,
                                      message: controller.commentSentError.value,
                                    );
                                  }
                                }
                              },
                              borderRadius: BorderRadius.circular(10.r),
                              child: Container(
                                padding: EdgeInsets.only(
                                  top: 8.h,
                                  bottom: 8.h,
                                  left: 10.h,
                                  right: controller.sendingComment.value ? 10.h : 15.h,
                                ),
                                decoration: BoxDecoration(
                                  color: ColorUtils.secondaryBlue,
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: controller.sendingComment.value
                                    ? Center(
                                      child: SizedBox(
                                          width: 15.h,
                                          height: 15.h,
                                          child: CircularProgressIndicator(
                                            color: ColorUtils.textWhite,
                                            strokeWidth: 2.h,
                                          ),
                                        ),
                                    )
                                    : Row(
                                        children: [
                                          Image.asset(
                                            'assets/images/growth/send_icon.png',
                                            height: 16.h,
                                          ),
                                          SizedBox(width: 8.h),
                                          Text(
                                            'Submit',
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 11.h,
                                              color: ColorUtils.textWhite,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            );
                          },
                        ),
                        SizedBox(width: 10.h),
                      ],
                    ),
                    SizedBox(height: 8.h),
                  ],
                ),
              ),
              SizedBox(height: 15.h),
              GetX<GrowthController>(
                builder: (GrowthController controller) {
                  if (controller.commentsLoading.value) {
                    return Center(
                      child: SpinKitThreeInOut(
                        color: ColorUtils.primaryBlue,
                        size: 28.h,
                      ),
                    );
                  }
                  return ListView.separated(
                    itemCount: widget.isGoal ? controller.goalCommentList.value.length : controller.subGoalCommentList.value.length,
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      CommentData comment = widget.isGoal ? controller.goalCommentList.value[index] : controller.subGoalCommentList.value[index];
                      String? dateTime;
                      try {
                        dateTime = timeago.format(
                          DateTime.parse(comment.createdOn!.toString()),
                        );
                      } catch (e) {}
                      return Container(
                        padding: EdgeInsets.all(15.h),
                        decoration: BoxDecoration(
                          color: ColorUtils.textWhite.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(
                            color: ColorUtils.textWhite.withValues(alpha: 0.1),
                            width: 0.6.h,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          1000,
                                        ).r,
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              comment.employeeProfile ?? '--',
                                          height: 30.h,
                                          width: 30.h,
                                          alignment: Alignment.center,
                                          placeholder: (context, url) {
                                            String name = employeeNameShortForm(
                                              comment.employeeName ?? '',
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
                                              comment.employeeName ?? '',
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
                                      SizedBox(width: 10.h),
                                      Flexible(
                                        child: Text(
                                          comment.employeeName ?? '--',
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.inter(
                                            fontSize: 13.h,
                                            fontWeight: FontWeight.w700,
                                            color: ColorUtils.textWhite
                                                .withValues(alpha: 0.9),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10.h),
                                      Text(
                                        dateTime ?? '--',
                                        style: GoogleFonts.inter(
                                          fontSize: 11.h,
                                          fontWeight: FontWeight.w400,
                                          color: ColorUtils.textWhite
                                              .withValues(alpha: 0.4),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10.h),
                                // Icon(
                                //   Icons.more_horiz_outlined,
                                //   color: ColorUtils.textWhite.withValues(alpha: 0.4),
                                //   size: 20.h,
                                // ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              comment.comment ?? '--',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w400,
                                fontSize: 13.h,
                                color: ColorUtils.textWhite.withValues(
                                  alpha: 0.7,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 10.h),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
