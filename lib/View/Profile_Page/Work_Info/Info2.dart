import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';

import '../../../models/user_profile_api_model.dart';
import '../../../utils/color_utils.dart';

class Info2 extends StatelessWidget {
  const Info2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 91.w,
      width: 362.w,
      decoration: BoxDecoration(
        color: Color(0xff101012),
        borderRadius: BorderRadius.circular(14),
      ),
      child: GetX<UserProfileController>(
        builder: (UserProfileController controller) {
          UserProfile user = controller.userData.value.result;
          String? probation;
          try {
            DateTime originalDate = DateTime.parse(
              user.joiningDate ?? "",
            ).add(Duration(days: int.parse(user.probationPeriod ?? "")));
            probation = DateFormat('yyyy-MM-dd').format(originalDate);
          } catch (e) {
            AttendanceCommonWidgets().printF(
              "Error occurred while parsing date or probation period: $e",
            );
          }
          return Padding(
            padding: const EdgeInsets.only(left: 15).w,
            child: Row(
              children: [
                // Spacer(),
                Container(
                  // width: 140,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Spacer(),
                      Text(
                        "Hiring Date",
                        style: GoogleFonts.poppins(
                          color: ColorUtils.textWhite.withOpacity(0.4),
                          fontWeight: FontWeight.w400,
                          fontSize: 15.sp,
                        ),
                      ),
                      Text(
                        user.joiningDate ?? "__",
                        style: GoogleFonts.poppins(
                          color: ColorUtils.textWhite.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                          textStyle: TextStyle(overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                Spacer(flex: 2),
                Container(
                  width: 160.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Spacer(),
                      Text(
                        "Probation End Date",
                        style: GoogleFonts.poppins(
                          color: ColorUtils.textWhite.withOpacity(0.4),
                          fontWeight: FontWeight.w400,
                          fontSize: 15.sp,
                          textStyle: TextStyle(overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      Text(
                        probation ?? "__",
                        style: GoogleFonts.poppins(
                          color: ColorUtils.textWhite.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                Spacer(),
              ],
            ),
          );
        },
      ),
    );
  }
}
