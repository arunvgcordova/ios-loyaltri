import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/CWidgets/cwidgets.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Profile/Manager_Profile.dart';
import 'package:loyaltri_minimal/View/NotificationScreen/NotificationScreen.dart';
import 'package:loyaltri_minimal/controller/userAuthentication.dart';
import '../../../../controller/ui_controller/home_controller.dart';
import '../../../../controller/ui_controller/page_controller.dart';
import '../../../../controller/userProfileController.dart';
import '../../../../models/user_profile_api_model.dart';
import '../../../../utils/color_utils.dart';
import '../manager_switch_dialogue.dart';

class ManagerAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<PopupMenuButtonState<AppView>> state =
      GlobalKey<PopupMenuButtonState<AppView>>();

  ManagerAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(
        110.h - MediaQuery.of(context).viewPadding.top,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30).r,
            bottomRight: Radius.circular(30).r,
          ),
          gradient: const LinearGradient(
            colors: [ColorUtils.lavenderPurple, ColorUtils.lavenderMist],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: AppBar(
            systemOverlayStyle: systemUiOverlayStyleLight,
            flexibleSpace: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 10.h),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: GetX<UserProfileController>(
                  builder: (UserProfileController controller) {
                    UserProfile user = controller.userData.value.result;
                    String name = '----';

                    if (user.nickName != null && user.nickName!.isNotEmpty) {
                      name = user.nickName!.trim();
                    } else if (user.firstName != null && user.firstName!.isNotEmpty) {
                      name = user.firstName!.trim();
                      if (user.lastName != null && user.lastName!.isNotEmpty) {
                        name += ' ${user.lastName!.trim()}';
                      }
                    } else if (user.lastName != null && user.lastName!.isNotEmpty) {
                      name = user.lastName!.trim();
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Image.asset(
                        //   "assets/examples/men_professional.png",
                        //   height: 50.h,
                        //   width: 50.h,
                        // ),
                        InkWell(
                          borderRadius: BorderRadius.circular(1000).r,
                          onTap: () {
                            Navigator.of(context).push(
                              newSlideFromLeftNavigation(ManagerProfile()),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: ColorUtils.textWhite.withValues(
                                  alpha: 0.8,
                                ),
                                width: 2.h,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(500).r,
                              child:
                                  controller.profileImageLocation.value.path != ""
                                      ? Image.file(
                                        controller.profileImageLocation.value,
                                        width: 46.h,
                                        height: 46.h,
                                        fit: BoxFit.fitWidth,
                                      )
                                      : CachedNetworkImage(
                                        imageUrl: user.profilePicture.toString(),
                                        width: 46.h,
                                        height: 46.h,
                                        fit: BoxFit.fitWidth,
                                        placeholder:
                                            (context, url) => Image.asset(
                                              user.gender?.trim().toLowerCase() == "female"
                                                  ? "assets/images/profile_pic_girl.jpg"
                                                  : "assets/images/profile_pic.png",
                                            ),
                                        errorWidget:
                                            (context, url, error) => Image.asset(
                                              user.gender?.trim().toLowerCase() == "female"
                                                  ? "assets/images/profile_pic_girl.jpg"
                                                  : "assets/images/profile_pic.png",
                                            ),
                                      ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.h),
                        Expanded(
                          child: Obx(() {
                            return InkWell(
                              splashColor: Colors.transparent,
                              onTap: () {
                                AppViewSwitch().showAppViewSwitcherManager(context);
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          name,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            fontSize: 15.h,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      if(Get.find<UserAuthController>().userData.value.userData?.loginType == 3)
                                        Icon(
                                          Icons.keyboard_arrow_down,
                                          color: ColorUtils.workEntryHead,
                                          size: 20.h,
                                        )
                                      else
                                        SizedBox.shrink(),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: 1.h,
                                    ),
                                    child: IntrinsicWidth(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 1.h,
                                          horizontal: 7.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: ColorUtils.textWhite.withValues(alpha: 0.3),
                                          borderRadius: BorderRadius.circular(20.r),
                                        ),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              "assets/images/manager_view/manager_mode_black.png",
                                              height: 12.h,
                                              fit: BoxFit.fitHeight,
                                            ),
                                            SizedBox(width: 5.h),
                                            Text(
                                              "Mode | ",
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 11.h,
                                                color: ColorUtils.workEntryHead.withValues(alpha: 0.7),
                                              ),
                                            ),
                                            Flexible(
                                              child: Obx(() => Text(
                                                Get.find<UserProfileController>().currentCompany.value?.company ?? '--',
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 11.h,
                                                  color: ColorUtils.workEntryHead.withValues(alpha: 0.7),
                                                ),
                                              ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5.h),
                                ],
                              ),
                            );
                          },
                          ),
                        ),
                        SizedBox(width: 12.h),
                        Stack(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 6.h, top: 3.h),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    newSlideNavigation(NotificationScreen()),
                                  );
                                },
                                child: CircleAvatar(
                                  radius: 23.h,
                                  backgroundColor: ColorUtils.textWhite
                                      .withValues(alpha: 0.4),
                                  child: Image.asset(
                                    "assets/images/notification-3d.webp",
                                    height: 30.h,
                                  ),
                                ),
                              ),
                            ),
                            // Positioned(
                            //   top: 0,
                            //   right: 0,
                            //   child: Container(
                            //     width: 20.h,
                            //     height: 20.h,
                            //     decoration: BoxDecoration(
                            //       color: ColorUtils.secondaryBlue,
                            //       shape: BoxShape.circle,
                            //     ),
                            //     child: Center(
                            //       child: Text(
                            //         "3",
                            //         style: GoogleFonts.poppins(
                            //           color: ColorUtils.textWhite,
                            //           fontSize: 12.h,
                            //           fontWeight: FontWeight.w500,
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            Obx(() {
                              int count =
                                  Get.find<UserProfileController>().notificationCount.value;
                              if (count != 0) {
                                return Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    width: 20.h,
                                    height: 20.h,
                                    decoration: BoxDecoration(
                                      color: ColorUtils.secondaryBlue,
                                      shape: BoxShape.circle
                                    ),
                                    child: Center(
                                      child: Text(
                                        "$count",
                                        style: GoogleFonts.poppins(
                                          fontSize: 12.h,
                                          fontWeight: FontWeight.w500,
                                          color: ColorUtils.textWhite,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return SizedBox.shrink();
                              }
                            }),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(75.h);
}
