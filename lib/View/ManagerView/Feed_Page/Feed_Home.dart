import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/ManagerView/Feed_Page/feed_view_controller/feed_view_controller.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/controller/ui_controller/home_controller.dart';
import 'package:loyaltri_minimal/controller/ui_controller/page_controller.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';
import 'package:loyaltri_minimal/View/ManagerView/Feed_Page/feed_widgets/comments_bottom_sheet.dart';
import 'package:timeago/timeago.dart' as time_ago;
import 'package:url_launcher/url_launcher.dart';

class FeedViewHomeEmployee extends StatefulWidget {
  const FeedViewHomeEmployee({super.key});

  @override
  State<FeedViewHomeEmployee> createState() => _FeedViewHomeEmployeeState();
}

class _FeedViewHomeEmployeeState extends State<FeedViewHomeEmployee> {
  ScrollController _scrollController = ScrollController();
  FeedViewController feedViewController = Get.find<FeedViewController>();

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !feedViewController.feedLoading.value) {
      if(!feedViewController.stopLoading.value) {
        feedViewController.fetchFeedListUser(loadMore: true);
      }
    }
  }

  Future<void> preCacheImage(BuildContext context) async {
    for (var item in feedViewController.feedDataList.value) {
      for (var file in item.files ?? []) {
        AttendanceCommonWidgets().printF("-----file.file-----------${file.file}");
        await precacheImage(
          CachedNetworkImageProvider(file.file ?? ''),
          context,
        );
      }
    }
  }

  Widget _buildDescriptionWithLinks(
    String text, {
    required TextStyle defaultStyle,
    required Color linkColor,
  }) {
    if (text.isEmpty) return const SizedBox.shrink();

    final urlRegex = RegExp(
      r'(https?:\/\/)?([^\s]+\.[a-zA-Z]{2,})(\/[^\s]*)?',
      caseSensitive: false,
    );

    final List<InlineSpan> spans = [];
    int lastMatchEnd = 0;

    for (final match in urlRegex.allMatches(text)) {
      if (match.start > lastMatchEnd) {
        spans.add(
          TextSpan(
            text: text.substring(lastMatchEnd, match.start),
            style: defaultStyle,
          ),
        );
      }

      final rawUrl = match.group(0)!;
      spans.add(
        TextSpan(
          text: rawUrl,
          style: defaultStyle.copyWith(
            color: linkColor,
            decoration: TextDecoration.underline,
            decorationColor: linkColor,
            fontWeight: FontWeight.w500,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              final String urlToLaunch = rawUrl.startsWith("http")
                  ? rawUrl
                  : "http://$rawUrl";
              final uri = Uri.tryParse(urlToLaunch);
              if (uri != null) {
                try {
                  await launchUrl(
                    uri,
                    mode: LaunchMode.externalApplication,
                  );
                } catch (e) {
                  debugPrint('Could not launch url: $e');
                }
              }
            },
        ),
      );

      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(lastMatchEnd),
          style: defaultStyle,
        ),
      );
    }

    return SelectableText.rich(
      TextSpan(children: spans),
      style: defaultStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    AppView appView = Get.find<UserPageController>().appView.value;
    return Scaffold(
      backgroundColor: appView == AppView.manager ? Colors.transparent : Colors.black,
      body: Padding(
        padding: EdgeInsets.only(
          left: 8.w,
          right: 8.w,
          bottom: 8.h,
        ),
        child: GetX<FeedViewController>(
          builder: (FeedViewController controller) {
            return RefreshIndicator(
              onRefresh: () async {
                await Get.find<FeedViewController>().fetchFeedListUser();
                preCacheImage(context);
              },
              child: Column(
                children: [
                  if(controller.feedDataList.isNotEmpty)
                    Expanded(
                    child: ListView.separated(
                      cacheExtent: 1000,
                      controller: _scrollController,
                      padding: EdgeInsets.only(
                          bottom: Platform.isIOS ? 150.h : 90.h,
                        top: 5.h,
                      ),
                      itemCount: controller.feedDataList.length,
                      itemBuilder: (BuildContext context, int index) {
                        String timeAgo = '--';
                        try {
                          timeAgo = time_ago.format(DateTime.parse(controller.feedDataList[index].createdOn ?? ''));
                        } catch(e) {}
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10.h),
                            Padding(
                              padding: EdgeInsets.only(
                                left: 10.h,
                                right: 10.h,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(500).r,
                                        child: CachedNetworkImage(
                                          imageUrl: controller.feedDataList[index].profilePicture ?? '',
                                          width: 35.h,
                                          height: 35.h,
                                          fit: BoxFit.fitWidth,
                                          placeholder:
                                              (context, url) => Container(
                                                width: 35.h,
                                                height: 35.h,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.white,
                                                ),
                                                child: Center(
                                                  child: Icon(
                                                    Icons.person,
                                                    size: 20.h,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                          errorWidget:
                                              (context, url, error) => Container(
                                                width: 35.h,
                                                height: 35.h,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.white,
                                                ),
                                                child: Center(
                                                  child: Icon(
                                                    Icons.person,
                                                    size: 20.h,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                        ),
                                      ),
                                      SizedBox(width: 10.h),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            controller.feedDataList[index].title ?? '--',
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13.h,
                                              color: appView == AppView.manager ? ColorUtils.workEntryHead : ColorUtils.textWhite,
                                            ),
                                          ),
                                          Text(
                                            timeAgo,
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 11.h,
                                              color: appView == AppView.manager ? ColorUtils.workEntryHead.withValues(alpha: 0.5) : Color(0xFF7A7A7A),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  // Padding(
                                  //   padding: EdgeInsets.only(
                                  //     right: 8.h,
                                  //   ),
                                  //   child: SvgPicture.asset(
                                  //     "assets/images/menu_icon_dots.svg",
                                  //     height: 20.h,
                                  //     fit: BoxFit.fitHeight,
                                  //     colorFilter: ColorFilter.mode(ColorUtils.textWhite.withValues(alpha: 0.7), BlendMode.srcIn),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20.h),
                            Padding(
                              padding: EdgeInsets.only(
                                left: 10.h,
                                right: 10.h,
                              ),
                              child: _buildDescriptionWithLinks(
                                controller.feedDataList[index].description ?? '',
                                defaultStyle: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13.h,
                                  color: appView == AppView.manager ? ColorUtils.workEntryHead : ColorUtils.textWhite,
                                ),
                                linkColor: appView == AppView.manager ? const Color(0xFF037EE5) : const Color(0xFF53BDEB),
                              ),
                            ),
                            SizedBox(height: 15.h),
                            ListView.separated(
                              padding: EdgeInsets.only(
                                left: 10.h,
                                right: 10.h,
                              ),
                              cacheExtent: 1000,
                              itemCount: controller.feedDataList[index].files?.length ?? 0,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, i) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(15.r),
                                  child: CachedNetworkImage(
                                    key: ValueKey("$index-$i"),
                                    imageUrl: controller.feedDataList[index].files?[i].file ?? '',
                                    placeholder: (context, url) {
                                      return SizedBox.shrink();
                                    },
                                    errorWidget: (context, url, error) {
                                      return SizedBox.shrink();
                                    },
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) => SizedBox(height: 10.h),
                            ),
                            // Padding(
                            //   padding: EdgeInsets.only(
                            //     left: 10.h,
                            //     right: 10.h,
                            //   ),
                            //   child: Image.asset(
                            //     "assets/examples/feed_example.png",
                            //   ),
                            // ),
                            SizedBox(height: 15.h),
                            Padding(
                              padding: EdgeInsets.only(
                                left: 15.h,
                                right: 10.h,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        onTap: () async {
                                          await controller.likeAFeed(feedId: controller.feedDataList[index].feedsId ?? '');
                                        },
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              (controller.feedDataList[index].isSignedInEmployeeLiked == 1) ? "assets/images/like_icon_active.svg" : "assets/images/like_icon.svg",
                                              height: 17.h,
                                              colorFilter: (appView == AppView.manager && controller.feedDataList[index].isSignedInEmployeeLiked != 1) ? ColorFilter.mode(ColorUtils.workEntryHead.withValues(alpha: 0.2), BlendMode.srcIn) : null,
                                              fit: BoxFit.fitHeight,
                                            ),
                                            SizedBox(width: 5.h),
                                            Text(
                                              AttendanceCommonWidgets().formatCount(controller.feedDataList[index].likesCount),
                                              style: GoogleFonts.inter(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14.h,
                                                color: Color(0xFF7A7A7A),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 30.h),
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
                                            useSafeArea: true,
                                            isDismissible: false,
                                            builder: (context) => CommentsBottomSheet(
                                              feedData: controller.feedDataList[index],
                                            ),
                                          );
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SvgPicture.asset(
                                              "assets/images/comment_icon.svg",
                                              height: 19.h,
                                              fit: BoxFit.fitHeight,
                                            ),
                                            SizedBox(width: 5.h),
                                            Text(
                                              AttendanceCommonWidgets().formatCount(controller.feedDataList[index].commentsCount),
                                              style: GoogleFonts.inter(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14.h,
                                                color: Color(0xFF7A7A7A),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Text(
                                      //   "",
                                      //   style: GoogleFonts.inter(
                                      //     fontWeight: FontWeight.w500,
                                      //     fontSize: 14.h,
                                      //     color: Color(0xFF7A7A7A),
                                      //   ),
                                      // ),
                                      // SizedBox(width: 30.h),
                                      // SvgPicture.asset(
                                      //   "assets/images/flag_icon_active.svg",
                                      //   height: 19.h,
                                      //   fit: BoxFit.fitHeight,
                                      // ),
                                    ],
                                  ),
                                  // SvgPicture.asset(
                                  //   "assets/images/share_icon.svg",
                                  //   height: 16.h,
                                  //   fit: BoxFit.fitHeight,
                                  // ),
                                ],
                              ),
                            ),
                            SizedBox(height: 5.h),
                            if(controller.feedMoreLoading.value && index == controller.feedDataList.length - 1)
                              SizedBox(height: 15.h),
                            if(controller.feedMoreLoading.value && index == controller.feedDataList.length - 1)
                              SpinKitFadingCircle(
                                size: 20,
                                color: ColorUtils.royalPurple,
                              ),
                          ],
                        );
                      },
                      separatorBuilder:
                          (BuildContext context, int index) => Divider(
                            color: appView == AppView.manager ? ColorUtils.workEntryHead.withValues(alpha: 0.06) : ColorUtils.textWhite.withValues(alpha: 0.11),
                            thickness: 1.h,
                          ),
                    ),
                  )
                  else
                    Expanded(
                      child: LayoutBuilder(
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
                                      color: Colors.grey,
                                      fontSize: 12.h,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  SafeArea(top: false, child: SizedBox()),
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}
