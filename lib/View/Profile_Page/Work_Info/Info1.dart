import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/models/user_profile_api_model.dart';

import '../../../controller/userProfileController.dart';
import '../../../utils/color_utils.dart';
class Info1 extends StatelessWidget {
  Info1({super.key});
  final ValueNotifier<bool> expandWorkInfo = ValueNotifier(false);
  final user = Get.find<UserProfileController>().userData.value.result;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => expandWorkInfo.value = !expandWorkInfo.value,
      child: Container(
        padding: const EdgeInsets.all(20).w,
        decoration: BoxDecoration(
            color: const Color(0xff101012),
            borderRadius: BorderRadius.circular(14).r),
        child: ValueListenableBuilder(
            valueListenable: expandWorkInfo,
            builder: (context, value, child) {
            return Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Employee Code",
                        style: GoogleFonts.poppins(
                          color: ColorUtils.textWhite.withOpacity(0.4),
                          fontWeight: FontWeight.w400,
                          fontSize: 15.sp,
                        ),
                      ),
                      Text(
                        user.code ?? '--',
                        overflow: !value ? TextOverflow.ellipsis : null,
                        style: GoogleFonts.poppins(
                          color: ColorUtils.textWhite.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(height: 10.w),
                      Text(
                        "Company",
                        style: GoogleFonts.poppins(
                          color: ColorUtils.textWhite.withOpacity(0.4),
                          fontWeight: FontWeight.w400,
                          fontSize: 15.sp,
                        ),
                      ),
                      Text(
                        user.company ?? '--',
                        overflow: !value ? TextOverflow.ellipsis : null,
                        style: GoogleFonts.poppins(
                          color: ColorUtils.textWhite.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(height: 10.w),
                      Text(
                        "Designation",
                        style: GoogleFonts.poppins(
                          color: ColorUtils.textWhite.withOpacity(0.4),
                          fontWeight: FontWeight.w400,
                          fontSize: 15.sp,
                        ),
                      ),
                      Text(
                        user.designation ?? '--',
                        overflow: !value ? TextOverflow.ellipsis : null,
                        style: GoogleFonts.poppins(
                          color: ColorUtils.textWhite.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(height: 10.w),
                      Text(
                        "Department",
                        style: GoogleFonts.poppins(
                          color: ColorUtils.textWhite.withOpacity(0.4),
                          fontWeight: FontWeight.w400,
                          fontSize: 15.sp,
                        ),
                      ),
                  
                      Text(
                        user.department ?? '--',
                        overflow: !value ? TextOverflow.ellipsis : null,
                        style: GoogleFonts.poppins(
                          color: ColorUtils.textWhite.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(height: 10.w),
                      Text(
                        "Hiring Date",
                        style: GoogleFonts.poppins(
                          color: ColorUtils.textWhite.withOpacity(0.4),
                          fontWeight: FontWeight.w400,
                          fontSize: 15.sp,
                        ),
                      ),
                      Text(
                        user.joiningDate ?? '--',
                        overflow: !value ? TextOverflow.ellipsis : null,
                        style: GoogleFonts.poppins(
                            color: ColorUtils.textWhite.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                            fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(height: 10.w),
                      Text(
                        "Probation End Date",
                        style: GoogleFonts.poppins(
                          color: ColorUtils.textWhite.withOpacity(0.4),
                          fontWeight: FontWeight.w400,
                          fontSize: 15.sp,
                        ),
                      ),
                      Text(
                        user.probationEndDate ?? '--',
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
          }
        ),
      ),
    );
  }
}
