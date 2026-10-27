import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';
import '../../../utils/color_utils.dart';

class NotificationIcon extends StatelessWidget {
  const NotificationIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 24, top: 4).w,
          child: CircleAvatar(
            radius: 20.w,
            backgroundColor: ColorUtils.textWhite.withOpacity(0.21),
            child: Image.asset(
              "assets/images/notification-3d.webp",
              height: 27.w,
            ),
          ),
        ),
        Obx(() {
          int count =
              Get.find<UserProfileController>().notificationCount.value;
          if (count != 0) {
            return Positioned(
              top: 0,
              right: 18,
              child: Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  color: ColorUtils.notiColor,
                  borderRadius: BorderRadius.circular(50).w,
                ),
                child: Center(
                  child: Text(
                    "$count",
                    style: GoogleFonts.poppins(
                      fontSize: 10.h,
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
    );
  }
}
