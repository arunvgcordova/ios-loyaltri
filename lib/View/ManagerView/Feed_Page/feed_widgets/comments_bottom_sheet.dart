import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loyaltri_minimal/View/ManagerView/Feed_Page/feed_view_controller/feed_view_controller.dart';
import 'package:loyaltri_minimal/controller/ui_controller/home_controller.dart';
import 'package:loyaltri_minimal/controller/ui_controller/page_controller.dart';
import 'package:loyaltri_minimal/controller/userAuthentication.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';
import 'package:loyaltri_minimal/models/manager/feed_data_list_model.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';
import 'package:timeago/timeago.dart' as time_ago;

import '../../Manager_Attendance/attendance_widgets_manager/common_widgets.dart';

class CommentsBottomSheet extends StatefulWidget {
  final FeedData? feedData;

  const CommentsBottomSheet({super.key, this.feedData});

  @override
  State<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _commentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _onSendComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    FocusScope.of(context).unfocus();

    String feedsId = widget.feedData?.feedsId ?? '';

    if (feedsId.isNotEmpty) {
      final feedViewController = Get.find<FeedViewController>();
      FeedListDataApi resp = await feedViewController.addCommentToFeed(
        feedsId: feedsId,
        commentText: text,
      );
      debugPrint('--------resp----------${resp.toJson()}');

      if(!mounted) return;
      if(resp.status == 200) {
        // Get.snackbar(
        //   'Success',
        //   resp.message ?? 'Comment Added Successfully.',
        //   snackPosition: SnackPosition.BOTTOM,
        //   backgroundColor: Colors.green,
        //   colorText: Colors.white,
        // margin: EdgeInsets.only(bottom: 10.h, left: 10.h, right: 10.h),
        // );
        _commentController.clear();
      } else {
        AttendanceCommonWidgets().showGetSnackBar(
          title: 'Failed',
          message: resp.message ?? 'Something went wrong',
          backgroundColor: Colors.red,
        );
      }
    }
  }

  String _getFormattedTimeAgo(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'Recently';
    try {
      return time_ago.format(DateTime.parse(dateStr));
    } catch (_) {
      return 'Recently';
    }
  }

  @override
  Widget build(BuildContext context) {
    AppView appView = Get.find<UserPageController>().appView.value;

    String currentUserAvatar = '';
    try {
      currentUserAvatar = Get.find<UserProfileController>().userData.value.result.profilePicture ?? '';
    } catch (_) {}

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        bottom: true,
        top: false,
        child: KeyboardAvoider(
          child: Container(
            decoration: BoxDecoration(
              color: appView == AppView.manager ? ColorUtils.textWhite : const Color(0xFF121211),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20.r),
              ),
              border: Border(
                top: BorderSide(
                  color: appView == AppView.manager ? ColorUtils.lightSilver : const Color(0xFF434343),
                  width: 1.h,
                ),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10.h),
                // Drag Handle Indicator
                Container(
                  width: 50.h,
                  height: 6.h,
                  decoration: BoxDecoration(
                    color: appView == AppView.manager ? ColorUtils.workEntryHead.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                SizedBox(height: 12.h),

                // Top Header: Comments + Count + Close Icon
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Comments',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w700,
                              fontSize: 17.h,
                              color: appView == AppView.manager ? ColorUtils.workEntryHead : ColorUtils.textWhite,
                            ),
                          ),
                          SizedBox(width: 8.h),
                          GetX<FeedViewController>(
                            builder: (controller) {
                              int idx = controller.feedDataList.indexWhere((f) => f.feedsId == widget.feedData?.feedsId);
                              String count = idx != -1
                                  ? (controller.feedDataList[idx].commentsCount ?? '0')
                                  : (widget.feedData?.commentsCount ?? '0');
                              return Text(
                                AttendanceCommonWidgets().formatCount(count),
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13.h,
                                  color: appView == AppView.manager ? ColorUtils.workEntryHead.withValues(alpha: 0.5) : const Color(0xFF8E8E93),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () => Navigator.of(context).pop(),
                        child: Padding(
                          padding: EdgeInsets.all(4.r),
                          child: Icon(
                            Icons.close,
                            color: appView == AppView.manager ? ColorUtils.workEntryHead : ColorUtils.textWhite,
                            size: 22.h,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.h),

                // Scrollable Comments List
                Flexible(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 16.h),
                    child: Column(
                      children: [
                        GetX<FeedViewController>(
                          builder: (controller) {
                            int idx = controller.feedDataList.indexWhere((f) => f.feedsId == widget.feedData?.feedsId);
                            List<Comments> list = idx != -1
                                ? (controller.feedDataList[idx].comments ?? [])
                                : (widget.feedData?.comments ?? []);

                            if (list.isEmpty) {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 30.h),
                                child: Center(
                                  child: Text(
                                    'No Comments Yet',
                                    style: GoogleFonts.inter(
                                      color: appView == AppView.manager ? ColorUtils.workEntryHead.withValues(alpha: 0.5) : const Color(0xFF8E8E93),
                                      fontSize: 13.h,
                                    ),
                                  ),
                                ),
                              );
                            }

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: list.length,
                              itemBuilder: (context, index) {
                                return _buildCommentTile(list[index], appView);
                              },
                            );
                          },
                        ),
                        SizedBox(height: 15.h),
                      ],
                    ),
                  ),
                ),

                // Sticky Bottom Input Area
                if(Get.find<UserAuthController>().postFeedComment.value)
                  Container(
                  decoration: BoxDecoration(
                    color: appView == AppView.manager ? ColorUtils.textWhite : const Color(0xFF020101),
                    border: Border(
                      top: BorderSide(
                        color: appView == AppView.manager ? ColorUtils.lightSilver : const Color(0xFF1b1b1b),
                        width: 1.h,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 10.h),
                    child: Row(
                      children: [
                        // User Avatar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50.r),
                          child: CachedNetworkImage(
                            imageUrl: currentUserAvatar,
                            width: 40.h,
                            height: 40.h,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => _buildAvatarPlaceholder(appView: appView),
                            errorWidget: (context, url, error) => _buildAvatarPlaceholder(appView: appView),
                          ),
                        ),
                        SizedBox(width: 10.h),

                        // Text Field Container
                        Expanded(
                          child: Container(
                            constraints: BoxConstraints(
                              minHeight: 42.h,
                              maxHeight: 100.h,
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 14.h),
                            decoration: BoxDecoration(
                              color: appView == AppView.manager ? ColorUtils.softPearl : const Color(0xFF212121),
                              borderRadius: BorderRadius.circular(22.r),
                              border: Border.all(
                                color: appView == AppView.manager ? ColorUtils.lightSilver : const Color(0xFF3c3c3c),
                                width: 1.h,
                              ),
                            ),
                            child: TextField(
                              onTap: () {
                                if(!Get.find<UserAuthController>().postFeedComment.value) {
                                  AttendanceCommonWidgets().showGetSnackBar(
                                    title: 'Message',
                                    message: 'You don\'t have permission to comment.',
                                    backgroundColor: appView == AppView.manager ? ColorUtils.offDayColor : ColorUtils.foregroundBlack,
                                    colorText: appView == AppView.manager ? ColorUtils.workEntryHead : Colors.white,
                                  );
                                }
                              },
                              readOnly: !Get.find<UserAuthController>().postFeedComment.value,
                              controller: _commentController,
                              focusNode: _focusNode,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              textInputAction: TextInputAction.newline,
                              style: GoogleFonts.inter(
                                color: appView == AppView.manager ? ColorUtils.workEntryHead : ColorUtils.textWhite,
                                fontSize: 12.h,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Add a comment...',
                                hintStyle: GoogleFonts.inter(
                                  color: appView == AppView.manager ? ColorUtils.workEntryHead.withValues(alpha: 0.4) : const Color(0xFF8E8E93),
                                  fontSize: 12.h,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 11.h,
                                  horizontal: 5.h,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.h),

                        // Send Button
                        GetX<FeedViewController>(
                          builder: (FeedViewController controller) {
                            return InkWell(
                              onTap: controller.feedCommenting.value ? null : _onSendComment,
                              borderRadius: BorderRadius.circular(50.r),
                              child: Container(
                                width: 40.h,
                                height: 40.h,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF5f42ef),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: controller.feedCommenting.value
                                      ? SpinKitFadingCircle(
                                          color: ColorUtils.textWhite,
                                          size: 18.h,
                                        )
                                      : Icon(
                                          Icons.arrow_upward_rounded,
                                          color: ColorUtils.textWhite,
                                          size: 20.h,
                                        ),
                                ),
                              ),
                            );
                          }
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCommentOptions(Comments comment, AppView appView) {
    showModalBottomSheet(
      context: context,
      backgroundColor: appView == AppView.manager ? ColorUtils.textWhite : const Color(0xFF1C1C1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (bottomContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40.h,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: appView == AppView.manager ? Colors.grey.shade300 : Colors.grey.shade700,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(height: 14.h),
                InkWell(
                  onTap: () async {
                    Navigator.of(bottomContext).pop();
                    await _onDeleteComment(comment);
                  },
                  borderRadius: BorderRadius.circular(10.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.h),
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline_rounded,
                          color: Colors.redAccent,
                          size: 22.h,
                        ),
                        SizedBox(width: 12.h),
                        Text(
                          'Delete Comment',
                          style: GoogleFonts.inter(
                            color: Colors.redAccent,
                            fontSize: 14.h,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _onDeleteComment(Comments comment) async {
    String feedsId = comment.feedsId ?? widget.feedData?.feedsId ?? '';
    String commentsId = comment.commentsId ?? '';

    if (feedsId.isEmpty || commentsId.isEmpty) return;

    final feedViewController = Get.find<FeedViewController>();
    FeedListDataApi resp = await feedViewController.deleteCommentFromFeed(
      feedsId: feedsId,
      commentsId: commentsId,
    );

    if (!mounted) return;
    if (resp.status == 200) {
      AttendanceCommonWidgets().showGetSnackBar(
        title: 'Success',
        message: resp.message ?? 'Comment has been deleted.',
        backgroundColor: Colors.green,
      );
    } else {
      AttendanceCommonWidgets().showGetSnackBar(
        title: 'Failed',
        message: resp.message ?? 'Failed to delete comment',
        backgroundColor: Colors.red,
      );
    }
  }

  Widget _buildCommentTile(Comments comment, AppView appView) {
    bool isYou = Get.find<UserProfileController>().userData.value.result.employeeId == comment.employeeId;

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: InkWell(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        onLongPress: isYou ? () => _showCommentOptions(comment, appView) : null,
        borderRadius: BorderRadius.circular(8.r),
        splashColor: Colors.red.withValues(alpha: 0.1),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            ClipRRect(
              borderRadius: BorderRadius.circular(50.r),
              child: CachedNetworkImage(
                imageUrl: comment.userImage ?? '',
                width: 40.h,
                height: 40.h,
                fit: BoxFit.cover,
                placeholder: (context, url) => _buildAvatarPlaceholder(name: comment.userName, appView: appView),
                errorWidget: (context, url, error) => _buildAvatarPlaceholder(name: comment.userName, appView: appView),
              ),
            ),
            SizedBox(width: 10.h),

            // Comment Body & Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Author Name + Author Badge
                  Row(
                    children: [
                      Text(
                        comment.userName ?? '--',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 13.h,
                          color: appView == AppView.manager ? ColorUtils.workEntryHead : ColorUtils.textWhite,
                        ),
                      ),
                      if (isYou) ...[
                        SizedBox(width: 6.h),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6B4EFF),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Text(
                            'You',
                            style: GoogleFonts.inter(
                              fontSize: 9.h,
                              fontWeight: FontWeight.w600,
                              color: ColorUtils.textWhite,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 4.h),

                  // Comment Text
                  Text(
                    comment.comment ?? '',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: 12.h,
                      color: appView == AppView.manager ? ColorUtils.workEntryHead.withValues(alpha: 0.85) : const Color(0xFFE4E4E6),
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 6.h),

                  // Time ago
                  Text(
                    _getFormattedTimeAgo(comment.createdOn),
                    style: GoogleFonts.inter(
                      fontSize: 11.h,
                      color: appView == AppView.manager ? ColorUtils.workEntryHead.withValues(alpha: 0.5) : const Color(0xFF8E8E93),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarPlaceholder({String? name, AppView appView = AppView.employee}) {
    String initial = '';
    if (name != null && name.trim().isNotEmpty) {
      initial = name.trim()[0].toUpperCase();
    }
    Color bgColor = appView == AppView.manager ? ColorUtils.softPearl : const Color(0xFF212121);
    Color borderColor = appView == AppView.manager ? ColorUtils.lightSilver : const Color(0xFF3c3c3c);
    Color fgColor = appView == AppView.manager ? ColorUtils.workEntryHead.withValues(alpha: 0.6) : Colors.white;

    if (initial.isEmpty) {
      return Container(
        width: 40.h,
        height: 40.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: bgColor,
          border: Border.all(
            color: borderColor,
            width: 1.h,
          ),
        ),
        child: Center(
          child: Icon(
            Icons.person,
            size: 20.h,
            color: fgColor,
          ),
        ),
      );
    }
    return Container(
      width: 40.h,
      height: 40.h,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 1.h,
        ),
      ),
      child: Center(
        child: Text(
          initial,
          style: GoogleFonts.inter(
            color: fgColor,
            fontWeight: FontWeight.w600,
            fontSize: 14.h,
          ),
        ),
      ),
    );
  }
}
