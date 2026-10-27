import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/ManagerView/Feed_Page/feed_view_controller/feed_view_controller.dart';
import 'package:loyaltri_minimal/View/ManagerView/Feed_Page/feed_widgets/items_bottom_sheet.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';
import '../../../../controller/ui_controller/home_controller.dart';
import '../../../../controller/ui_controller/page_controller.dart';
import '../../../../models/manager/feed_data_list_model.dart';

final List<PostSetting> postSettingsData = [
  const PostSetting(
    type: PostSettings.organization,
    icon: 'assets/images/feed_icons/Users.svg',
    title: 'To entire organization',
    subtitle: 'Share with everyone in your organization',
  ),
  const PostSetting(
    type: PostSettings.entity,
    icon: 'assets/images/feed_icons/Building.svg',
    title: 'In your entity',
    subtitle: 'Share with people in your business entity',
  ),
  const PostSetting(
    type: PostSettings.location,
    icon: 'assets/images/feed_icons/MapPin.svg',
    title: 'In your location',
    subtitle: 'Share with people in your office location',
  ),
  const PostSetting(
    type: PostSettings.category,
    icon: 'assets/images/feed_icons/Tag.svg',
    title: 'In your category',
    subtitle: 'Share with people in your job category',
  ),
  const PostSetting(
    type: PostSettings.department,
    icon: 'assets/images/feed_icons/Suitcase.svg',
    title: 'In your department',
    subtitle: 'Share with people in your department',
  ),
];


class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    AppView appView = Get.find<UserPageController>().appView.value;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 18.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top handle bar
            Container(
              height: 5.h,
              width: 75.h,
              decoration: BoxDecoration(
                color: appView == AppView.manager ? ColorUtils.workEntryHead.withValues(alpha: 0.2) : ColorUtils.textWhite.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            SizedBox(height: 13.h),
      
            // Title
            Text(
              'Post Settings',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 15.h,
                color: appView == AppView.manager ? ColorUtils.workEntryHead : ColorUtils.textWhite,
              ),
            ),
            SizedBox(height: 20.h),
      
            // Settings list
            ...List.generate(
              postSettingsData.length,
                  (index) {
                final setting = postSettingsData[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: index == postSettingsData.length - 1 ? 0 : 10.h),
                  child: SettingsCard(
                    type: setting.type,
                    icon: setting.icon,
                    title: setting.title,
                    subTitle: setting.subtitle,
                  ),
                );
              },
            ),
            SizedBox(height: 15.h),
            InkWell(
              borderRadius: BorderRadius.circular(37).r,
              onTap: () {
                FeedViewController feedViewController = Get.find<FeedViewController>();
                if(feedViewController.selectedCompanies.value.isEmpty &&
                    feedViewController.selectedLocations.value.isEmpty &&
                    feedViewController.selectedCategories.value.isEmpty &&
                    feedViewController.selectedDepartments.value.isEmpty) {
                  Navigator.of(context).pop(false);
                } else {
                  Navigator.of(context).pop(true);
                }
              },
              child: Container(
                width: ScreenUtil().screenWidth,
                height: 50.h,
                decoration: BoxDecoration(
                  color: ColorUtils.secondaryBlue,
                  borderRadius: BorderRadius.circular(37).r,
                ),
                child: Center(
                  child: Text(
                    'Save',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 15.h,
                      color: ColorUtils.textWhite,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SettingsCard extends StatelessWidget {
  final PostSettings type;
  final String icon;
  final String title;
  final String subTitle;
  const SettingsCard({
    super.key,
    required this.type,
    required this.icon,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    AppView appView = Get.find<UserPageController>().appView.value;
    return InkWell(
      borderRadius: BorderRadius.circular(10.r),
      onTap: () async {
        if(type != PostSettings.organization) {
          Get.find<FeedViewController>().clearSelections(except: type);
          bool? save = await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            isDismissible: false,
            backgroundColor: appView == AppView.manager ? ColorUtils.textWhite : ColorUtils.backgroundBlack,
            barrierColor: ColorUtils.workEntryHead.withValues(alpha: 0.55),
            builder: (context) {
              return ItemsBottomSheet(postSettings: type);
            },
          );

          if (save != true) {
            Get.find<FeedViewController>().clearSelections(except: PostSettings.organization);
          }
        } else {
          Get.find<FeedViewController>().clearSelections(except: PostSettings.organization);
        }
      },
      child: GetX<FeedViewController>(
        builder: (FeedViewController controller) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 18.h),
            decoration: BoxDecoration(
              color: appView == AppView.manager ? ColorUtils.softPearl : ColorUtils.foregroundBlack,
              borderRadius: BorderRadius.circular(10.r),
              border: controller.selectedSettings.value == type
                  ? Border.all(color: Color(0xFFBFB2FF), width: 1.h)
                  : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                        icon, 
                        height: 20.h,
                      colorFilter: appView == AppView.manager ? ColorFilter.mode(ColorUtils.workEntryHead, BlendMode.srcIn) : null,
                    ),
                    SizedBox(width: 8.h),
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              title,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: 13.h,
                                fontWeight: FontWeight.w500,
                                color: appView == AppView.manager ? ColorUtils.workEntryHead.withValues(alpha: 0.7) : const Color(0xFFEDEDED),
                              ),
                            ),
                          ),
                          if(type != PostSettings.organization)
                            Padding(
                              padding: EdgeInsets.only(left: 6.h),
                              child: SvgPicture.asset(
                              'assets/images/feed_icons/CaretRight.svg',
                              height: 8.h,
                                colorFilter: appView == AppView.manager ? ColorFilter.mode(ColorUtils.workEntryHead, BlendMode.srcIn) : null,
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(width: 15.h),
                    Container(
                      width: 14.h,
                      height: 14.h,
                      decoration: BoxDecoration(
                        color: controller.selectedSettings.value == type ? Color(0xFFBFB2FF) : appView == AppView.manager ? ColorUtils.softPearl : ColorUtils.foregroundBlack,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: ColorUtils.secondaryBlue,
                          width: 0.75.h,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
                Text(
                  subTitle,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w400,
                    fontSize: 11.h,
                    color: appView == AppView.manager ? ColorUtils.workEntryHead.withValues(alpha: 0.5) : const Color(0xFFBDBDBD),
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}
