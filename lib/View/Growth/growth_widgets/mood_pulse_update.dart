import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';
import '../../../../controller/userProfileController.dart';
import '../growth_controller/growth_controller.dart';
import '../growth_controller/mappers.dart';

class MoodPulseUpdate extends StatelessWidget {
  MoodPulseUpdate({super.key});
  final employeeId = Get.find<UserProfileController>().userData.value.result.employeeId?.toString() ?? '';
  final companyId = Get.find<UserProfileController>().userData.value.result.companyId?.toString() ?? '';

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 14.h),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.r),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [ColorUtils.brightBlueViolet, ColorUtils.brightIndigo],
              ),
              image: DecorationImage(
                image: AssetImage('assets/images/growth/mood-pattern.png'),
                alignment: AlignmentGeometry.xy(0, 1.0),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(20).h,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: Text(
                          'MOOD PULSE',
                          style: GoogleFonts.jetBrainsMono(
                            fontWeight: FontWeight.w700,
                            fontSize: 11.h,
                            color: ColorUtils.textWhite,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: 30.h,
                          height: 30.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ColorUtils.textWhite.withValues(alpha: 0.2),
                          ),
                          child: Icon(
                            Icons.close,
                            color: ColorUtils.textWhite,
                            size: 18.h,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          'How’s your overall vibe with the company so far?',
                          style: GoogleFonts.urbanist(
                            fontSize: 25.h,
                            fontWeight: FontWeight.w500,
                            color: ColorUtils.textWhite,
                            letterSpacing: -0.5,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.h),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          'Choose any mood below',
                          style: GoogleFonts.inter(
                            fontSize: 13.h,
                            fontWeight: FontWeight.w400,
                            color: ColorUtils.textWhite,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _moodIcon(
                        1,
                        'Need Help',
                        'assets/images/growth/mood-very-bad.png',
                        context,
                      ),
                      _moodIcon(
                        2,
                        'Could Be Better',
                        'assets/images/growth/mood-bad.png',
                        context,
                      ),
                      _moodIcon(
                        3,
                        "It's Fine",
                        'assets/images/growth/mood-okay.png',
                        context,
                      ),
                      _moodIcon(
                        4,
                        'Feeling Good',
                        'assets/images/growth/mood-good.png',
                        context,
                      ),
                      _moodIcon(
                        5,
                        'Loving It!',
                        'assets/images/growth/mood-very-good.png',
                        context,
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _moodIcon(int id, String mood, String icon, BuildContext context) {
    GrowthController growthController = Get.find<GrowthController>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () async {
            String? resp = await growthController.submitMoodPulse(score: id);
            AttendanceCommonWidgets().showSnackBar(
                context: context,
                backgroundColor: Colors.black,
                message: resp ?? 'Something went wrong',
            );
            Navigator.of(context).pop();
          },
          child: Obx(() {
            int? moodId = growthController.currentMoodPulse.value;
              return Container(
                width: 48.h,
                height: 48.h,
                padding: EdgeInsets.only(
                  bottom: id.mood.label == 'Need Help'
                      ? 3.h
                      : id.mood.label == 'Could Be Better'
                      ? 2.h
                      : 0.h,
                  top: id.mood.label == 'Loving It!'
                      ? 3.h
                      : id.mood.label == 'Feeling Good'
                      ? 2.h
                      : 0.h,
                  left: 16.h,
                  right: 16.h,
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorUtils.textWhite.withValues(
                    alpha: moodId == id ? 1.0 : 0.2,
                  ),
                  border: Border.all(
                    color: ColorUtils.textWhite.withValues(alpha: 0.1),
                    width: 1.h,
                  ),
                ),
                child: Center(
                  child: Image.asset(
                    icon,
                    // height: 16.h,
                    // fit: BoxFit.fitHeight,
                    color: moodId == id
                        ? ColorUtils.workEntryHead
                        : ColorUtils.textWhite,
                  ),
                ),
              );
            }
          ),
        ),
        SizedBox(height: 9.h),
        Text(
          id.mood.label,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 11.h,
            color: ColorUtils.textWhite,
          ),
        ),
      ],
    );
  }
}
