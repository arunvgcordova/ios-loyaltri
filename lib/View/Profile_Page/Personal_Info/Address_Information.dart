import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';
import 'package:loyaltri_minimal/models/user_api_model.dart';

import '../../../controller/userAuthentication.dart';
import '../../../models/user_profile_api_model.dart';
import '../../../utils/color_utils.dart';

class AddressInformation extends StatelessWidget {
  AddressInformation({super.key});
  final ValueNotifier<bool> expandAddressInfo = ValueNotifier(false);
  final user = Get.find<UserProfileController>().userData.value.result;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => expandAddressInfo.value = !expandAddressInfo.value,
      child: Container(
        padding: EdgeInsets.all(20.h),
        decoration: BoxDecoration(
          color: Color(0xff101012),
          borderRadius: BorderRadius.circular(14).r,
        ),
        child: ValueListenableBuilder(
          valueListenable: expandAddressInfo,
          builder: (context, value, child) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "City",
                        style: GoogleFonts.poppins(
                          color: ColorUtils.textWhite.withOpacity(0.4),
                          fontWeight: FontWeight.w400,
                          fontSize: 15.sp,
                        ),
                      ),
                      Text(
                        user.city ?? '--',
                        overflow: !value ? TextOverflow.ellipsis : null,
                        style: GoogleFonts.poppins(
                          color: ColorUtils.textWhite.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        "Country",
                        style: GoogleFonts.poppins(
                          color: ColorUtils.textWhite.withOpacity(0.4),
                          fontWeight: FontWeight.w400,
                          fontSize: 15.sp,
                        ),
                      ),
                      Text(
                        user.countryName ?? '--',
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
                        "Province State",
                        style: GoogleFonts.poppins(
                          color: ColorUtils.textWhite.withOpacity(0.4),
                          fontWeight: FontWeight.w400,
                          fontSize: 15.sp,
                        ),
                      ),
                      Text(
                        user.stateName ?? '--',
                        overflow: !value ? TextOverflow.ellipsis : null,
                        style: GoogleFonts.poppins(
                          color: ColorUtils.textWhite.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        "Postal Code",
                        style: GoogleFonts.poppins(
                          color: ColorUtils.textWhite.withOpacity(0.4),
                          fontWeight: FontWeight.w400,
                          fontSize: 15.sp,
                        ),
                      ),
                      Text(
                        user.zipCode ?? '--',
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
