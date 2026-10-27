import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/controller/userAuthentication.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';

import '../../../models/user_api_model.dart';
import '../../../models/user_profile_api_model.dart';
import '../../../utils/color_utils.dart';

class BasicInformation extends StatelessWidget {
  BasicInformation({super.key});
  final ValueNotifier<bool> expandBasicInfo = ValueNotifier(false);
  final user = Get.find<UserProfileController>().userData.value.result;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => expandBasicInfo.value = !expandBasicInfo.value,
      child: Container(
        padding: EdgeInsets.all(20.h),
        decoration: BoxDecoration(
          color: Color(0xff101012),
          borderRadius: BorderRadius.circular(14).r,
        ),
        child: ValueListenableBuilder(
          valueListenable: expandBasicInfo,
          builder: (context, value, child) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "First Name",
                        style: GoogleFonts.poppins(
                          color: ColorUtils.textWhite.withOpacity(0.4),
                          fontWeight: FontWeight.w400,
                          fontSize: 15.sp,
                        ),
                      ),
                      Text(
                        user.firstName ?? '--',
                        overflow: !value ? TextOverflow.ellipsis : null,
                        style: GoogleFonts.poppins(
                          color: ColorUtils.textWhite.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        "Date of Birth",
                        style: GoogleFonts.poppins(
                          color: ColorUtils.textWhite.withOpacity(0.4),
                          fontWeight: FontWeight.w400,
                          fontSize: 15.sp,
                        ),
                      ),
                      Text(
                        user.dateOfBirth ?? '--',
                        overflow: !value ? TextOverflow.ellipsis : null,
                        style: GoogleFonts.poppins(
                          color: ColorUtils.textWhite.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10.h),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Last Name",
                        style: GoogleFonts.poppins(
                          color: ColorUtils.textWhite.withOpacity(0.4),
                          fontWeight: FontWeight.w400,
                          fontSize: 15.sp,
                        ),
                      ),
                      Text(
                        user.lastName ?? '--',
                        overflow: !value ? TextOverflow.ellipsis : null,
                        style: GoogleFonts.poppins(
                          color: ColorUtils.textWhite.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        "Gender",
                        style: GoogleFonts.poppins(
                          color: ColorUtils.textWhite.withOpacity(0.4),
                          fontWeight: FontWeight.w400,
                          fontSize: 15.sp,
                        ),
                      ),
                      Text(
                        user.gender ?? '--',
                        overflow: !value ? TextOverflow.ellipsis : null,
                        style: GoogleFonts.poppins(
                          color: ColorUtils.textWhite.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
