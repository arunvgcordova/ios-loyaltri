import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/color_utils.dart';
import '../growth_controller/growth_controller.dart';
import '../growth_controller/mappers.dart';
import 'mood_pulse_update.dart';

class MoodPulse extends StatelessWidget {
  const MoodPulse({super.key});

  @override
  Widget build(BuildContext context) {
    GrowthController growthController = Get.find<GrowthController>();
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20.h,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            ColorUtils.workEntryHead,
            ColorUtils.midnightViolet,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Mood Pulse',
                style: GoogleFonts.urbanist(
                  fontWeight: FontWeight.w500,
                  fontSize: 15.h,
                  color: ColorUtils.textWhite,
                  letterSpacing: -0.2,
                ),
              ),
              Builder(
                builder: (builderContext) {
                  return SizedBox(
                    height: 40.h,
                    width: 85.h,
                    child: Obx(() {
                        return OutlinedButton(
                          onPressed: () {
                            showDialog(
                              context: builderContext,
                              barrierColor: ColorUtils.workEntryHead
                                  .withValues(alpha: 0.9),
                              barrierDismissible: false,
                              builder: (BuildContext dialogContext) {
                                return MoodPulseUpdate();
                              },
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            backgroundColor: growthController.mooPulseSubmitting.value
                                ? ColorUtils.textWhite.withValues(alpha: 0.7)
                                : ColorUtils.textWhite,
                            side: BorderSide(
                              color: ColorUtils.workEntryHead
                                  .withValues(alpha: 0.1),
                              width: 1.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                          ),
                          child: Center(
                            child: growthController.mooPulseSubmitting.value
                                ? SizedBox(
                                    width: 16.h,
                                    height: 16.h,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        ColorUtils.workEntryHead,
                                      ),
                                    ),
                                  )
                                : Text(
                                    'Update',
                                    style: GoogleFonts.urbanist(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13.h,
                                      color: ColorUtils.workEntryHead,
                                    ),
                                  ),
                          ),
                        );
                      }
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 15.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() {
                  return Flexible(
                    child: Text(
                      growthController.currentMoodPulse.value?.mood.label ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.urbanist(
                        fontWeight: FontWeight.w600,
                        fontSize: 43.h,
                        color: ColorUtils.textWhite,
                      ),
                    ),
                  );
                }
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 3.h,
                  horizontal: 10.h,
                ),
                decoration: BoxDecoration(
                  color: ColorUtils.slateIndigo,
                  borderRadius: BorderRadius.circular(27.r),
                ),
                child: Text(
                  'HIGH IMPACT',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 13.h,
                    fontWeight: FontWeight.w500,
                    color: ColorUtils.textWhite,
                  ),
                ),
              ),
            ],
          ),
          Text(
            'You’re in a good headspace, enabling strong daily performance',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w400,
              fontSize: 15.h,
              color: ColorUtils.platinumGrey,
              letterSpacing: -0.2,
            ),
          ),
          SizedBox(height: 25.h),
          Image.asset(
            'assets/images/growth/3d-avatar.png',
            height: 86.h,
          ),
        ],
      ),
    );
  }
}