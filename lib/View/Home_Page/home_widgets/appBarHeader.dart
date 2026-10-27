import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/controller/ui_controller/page_controller.dart';
import 'package:loyaltri_minimal/controller/userAuthentication.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';
import '../../../controller/ui_controller/home_controller.dart';
import '../../../models/user_profile_api_model.dart';
import '../../../utils/color_utils.dart';
import '../../ManagerView/Manager_Home/manager_switch_dialogue.dart';

class AppBarHeader extends StatelessWidget {
  const AppBarHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<UserProfileController>(
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
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(500).w,
                // color: ColorUtils.textWhite.withOpacity(0.8),
                border: Border.all(
                  color: ColorUtils.textWhite.withOpacity(0.8),
                  width: 2.w,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(500).w,
                child: controller.profileImageLocation.value.path != "" ? Image.file(
                  controller.profileImageLocation.value,
                  width: 45.w,
                  height: 45.w,
                  fit: BoxFit.fitWidth,
                ) : CachedNetworkImage(
                  imageUrl: user.profilePicture.toString(),
                  width: 45.w,
                  height: 45.w,
                  fit: BoxFit.fitWidth,
                  placeholder:
                      (context, url) => Image.asset(
                        user.gender?.trim().toLowerCase() == "female"
                            ? "assets/images/profile_pic_girl.jpg"
                            : "assets/images/profile_pic.png",
                  ),
                  errorWidget: (context,
                      url, error) => Image.asset(
                    user.gender?.trim().toLowerCase() == "female"
                        ? "assets/images/profile_pic_girl.jpg"
                        : "assets/images/profile_pic.png",
                  ),
                ),
              ),
            ),
            // CircleAvatar(
            //   radius: 26.w,
            //   backgroundColor: ColorUtils.textWhite.withOpacity(0.8),
            //   child: CircleAvatar(
            //     radius: 24.w,
            //     backgroundColor: Colors.transparent,
            //     backgroundImage: const AssetImage("assets/images/userImage.png"),
            //     // child: Image.asset("assets/images/userImage.png"),
            //   ),
            // ),
            SizedBox(width: 8.w),
            Stack(
              children: [
                Obx(() {
                  return InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {
                      if(Get.find<UserAuthController>().userData.value.userData?.loginType == 3) {
                        AppViewSwitch().showAppViewSwitcher(context);
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: 190.w,
                              ),
                              child: Text(
                                name,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18.sp,
                                  color: ColorUtils.textWhite,
                                ),
                              ),
                            ),
                            if(Get.find<UserAuthController>().userData.value.userData?.loginType == 3)
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: ColorUtils.textWhite,
                                size: 20.h,
                              )
                            else
                              SizedBox.shrink(),
                          ],
                        ),
                        if(Get.find<UserAuthController>().userData.value.userData?.loginType == 3)
                          Padding(
                            padding: EdgeInsets.only(
                              top: 1.h,
                            ),
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
                                    "assets/images/manager_view/employee_mode.png",
                                    height: 12.h,
                                    fit: BoxFit.fitHeight,
                                  ),
                                  Text(
                                    "Mode | ",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 11.h,
                                      color: ColorUtils.textWhite,
                                    ),
                                  ),
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth: ScreenUtil().screenWidth * 0.3,
                                    ),
                                    child: Text(
                                      Get.find<UserProfileController>().currentCompany.value?.company ?? '--',
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 11.h,
                                        color: ColorUtils.textWhite,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          Text(
                            user.designation ?? "_____",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 12.sp,
                              color: ColorUtils.textWhite.withOpacity(0.5),
                            ),
                          ),
                      ],
                    ),
                  );
                }
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}


