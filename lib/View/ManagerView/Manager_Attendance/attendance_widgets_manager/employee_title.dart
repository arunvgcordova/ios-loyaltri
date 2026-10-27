
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/manager_attendance_controller/manager_attendance_controller.dart';
import '../../../../utils/color_utils.dart';

class EmployeeTitle extends StatelessWidget {
  const EmployeeTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 15.h,
        vertical: 15.h,
      ),
      child: GetX<ManagerAttendanceController>(
        builder: (ManagerAttendanceController controller) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(1000).r,
                child: CachedNetworkImage(
                  imageUrl: controller.selectedEmployeeData.value?.profilePicture ?? '',
                  height: 33.h,
                  width: 33.h,
                  placeholder: (context, url) {
                    return Container(
                      width: 33.h,
                      height: 33.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.h,
                        ),
                      ),
                      child: Center(child: Icon(Icons.person, color: Colors.grey, size: 23.h)),
                    );
                  },
                  errorWidget: (context, url, error) {
                    return Container(
                      width: 33.h,
                      height: 33.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.h,
                        ),
                      ),
                      child: Center(child: Icon(Icons.person, color: Colors.grey, size: 23.h)),
                    );
                  },
                  fit: BoxFit.fitHeight,
                ),
              ),
              // Image.asset(
              //   "assets/examples/user_request.png",
              //   height: 33.h,
              // ),
              SizedBox(width: 8.h),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.selectedEmployeeData.value?.employeeName ?? '--',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.dmSans(
                        fontSize: 13.h,
                        fontWeight: FontWeight.w500,
                        color: ColorUtils.workEntryHead.withValues(
                          alpha: 0.9,
                        ),
                      ),
                    ),
                    Text(
                      controller.selectedEmployeeData.value?.designation ?? '--',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.dmSans(
                        fontSize: 11.h,
                        fontWeight: FontWeight.w400,
                        color: ColorUtils.workEntryHead.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                formatDate(controller.selectedEmployeeData.value?.date),
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.dmSans(
                  fontSize: 11.h,
                  fontWeight: FontWeight.w400,
                  color: ColorUtils.workEntryHead.withValues(
                    alpha: 0.5,
                  ),
                ),
              ),
            ],
          );
        }
      ),
    );
  }

  String formatDate(String? inputDate) {
    try {
      final parsedDate = DateTime.parse(inputDate!);
      final formatter = DateFormat('dd MMM | EEE');
      return formatter.format(parsedDate);
    } catch(e) {
      return '--';
    }
  }
}
