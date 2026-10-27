import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/CWidgets/cwidgets.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/View/field/core/colour_utils.dart';
import 'package:loyaltri_minimal/View/field/core/utils.dart';
import 'package:loyaltri_minimal/View/field/features/customer/customer_screen.dart';
import 'package:loyaltri_minimal/View/field/features/time_line/timeline_screen.dart';
import 'package:loyaltri_minimal/View/field/features/add_work_log/add_work_screen.dart';
import 'package:loyaltri_minimal/View/field/features/tracking/tracker_controller.dart';
import 'package:loyaltri_minimal/View/field/features/work_log/work_log_screen.dart';
import 'package:loyaltri_minimal/controller/userAuthentication.dart';

class QuickActionRow extends StatelessWidget {
  const QuickActionRow({super.key});

  @override
  Widget build(BuildContext context) {
   final actions = [
      {'icon': 'menu', 'label': 'Work Log', 'index': 1},
      {'icon': 'users', 'label': 'Customers', 'index': 2},
      {'icon': 'time_line', 'label': 'Timeline', 'index': 3},
      {'icon': 'circle_plus', 'label': 'Add Work', 'index': 4},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: actions.map((act) {
        return InkWell(
          onTap: () {
            if (act['index'] == 1) {
              Navigator.push(context, newSlideNavigation(WorkLogScreen()));
            }
            if (act['index'] == 2) {
              Navigator.push(context, newSlideNavigation(CustomerScreen()));
            }
            if (act['index'] == 3) {
              final trackingCtrl = Get.isRegistered<TrackingController>()
                  ? Get.find<TrackingController>()
                  : null;
              final empId = Get.find<UserAuthController>().userData.value.userData?.employeeId;
              final hasTimeline = trackingCtrl?.companySettings.value?.hasTimelineAccess(empId) ?? true;
              if (!hasTimeline) {
                AttendanceCommonWidgets().showSnackBar(
                  context: context,
                  backgroundColor: Colors.orange,
                  message: "Timeline access is disabled for your account.",
                );
                return;
              }
              Navigator.push(context, newSlideNavigation(TimelineScreen()));
            }
            if (act['index'] == 4) {
              final trackingCtrl = Get.isRegistered<TrackingController>()
                  ? Get.find<TrackingController>()
                  : null;
              final empId = Get.find<UserAuthController>().userData.value.userData?.employeeId;
              final canWork = trackingCtrl?.companySettings.value?.canStaffCreateWork(empId) ?? true;
              if (!canWork) {
                AttendanceCommonWidgets().showSnackBar(
                  context: context,
                  backgroundColor: Colors.orange,
                  message: "You do not have permission to create work.",
                );
                return;
              }
              Navigator.push(context, newSlideNavigation(AddWorkScreen()));
            }
          },
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            width: 78.w,
            padding: EdgeInsets.symmetric(vertical: 12.h),
            decoration: BoxDecoration(
              // color: ColourUtils.cardBackground,
              gradient: LinearGradient(
                begin: AlignmentGeometry.topCenter,
                end: AlignmentGeometry.bottomCenter,
                colors: [ColourUtils.gdColourS, ColourUtils.gdColourE],
              ),
              borderRadius: BorderRadius.circular(12.h),
              border: Border.all(color: ColourUtils.borderColour, width: 1.h),
            ),
            child: Column(
              children: [
                svgWidget(
                  height: 24.h,
                  width: 24.h,
                  icon: act['icon'] as String,
                ),
                SizedBox(height: 8.h),
                Text(
                  act['label'] as String,
                  style: GoogleFonts.inter(
                    color: ColourUtils.textMain,
                    fontSize: 12.h,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}