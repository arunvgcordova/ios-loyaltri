
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/Growth/growth_controller/growth_controller.dart';
import '../../../utils/color_utils.dart';
import '../../CWidgets/loyaltri_blue_text_button.dart';
import '../../Login/login_widgets/custom_check_box.dart';

class GoalsFilterBottomSheet extends StatelessWidget {
  const GoalsFilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: IntrinsicHeight(
        child: Container(
          width: ScreenUtil().screenWidth,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ).r),
          child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 10).h,
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 5.h,
                      width: 100.h,
                      decoration: BoxDecoration(
                          color: ColorUtils.textWhite.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(50).r
                      ),
                    ),
                    SizedBox(height: 15.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // const Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            height: 48.h,
                            width: 48.h,
                            decoration: BoxDecoration(
                              color: ColorUtils.foregroundBlack,
                              borderRadius: BorderRadius.circular(14).r,
                              border: Border.all(
                                width: 1.h,
                                color: const Color(0xFF3F4450),
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.close,
                                size: 18.h,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          "Filters",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 15.h,
                            color: ColorUtils.textWhite,
                          ),
                        ),
                        Container(
                          height: 48.h,
                          width: 48.h,
                          color: Colors.transparent,
                        ),
                      ],
                    ),
                    SizedBox(height: 30.h),
                    Row(
                      children: [
                        Text(
                          "Status",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 11.h,
                            color: ColorUtils.textWhite.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Pending",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 13.h,
                            color: ColorUtils.textWhite,
                          ),
                        ),
                        GetX<GrowthController>(
                          builder: (GrowthController controller) {
                            return CustomCheckbox(
                              size: 16.0,
                              iconSize: 10.0,
                              borderRadius: BorderRadius.circular(4).r,
                              borderColor: controller.filterPending.value ? ColorUtils.secondaryBlue : const Color(0xFF4B4B4B),
                              checkIcon: const Icon(Icons.done_rounded),
                              selectedColor: ColorUtils.secondaryBlue,
                              isChecked: controller.filterPending.value,
                              onChange: (bool? value) {
                                controller.filterPending.value = value ?? false;
                              },
                            );
                          }
                        ),
                      ],
                    ),
                    SizedBox(height: 10.w),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Completed",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 13.h,
                            color: ColorUtils.textWhite,
                          ),
                        ),
                        GetX<GrowthController>(
                            builder: (GrowthController controller) {
                            return CustomCheckbox(
                              size: 16.0,
                              iconSize: 10.0,
                              borderRadius: BorderRadius.circular(4).r,
                              borderColor: controller.filterCompleted.value ? ColorUtils.secondaryBlue : const Color(0xFF4B4B4B),
                              checkIcon: const Icon(Icons.done_rounded),
                              selectedColor: ColorUtils.secondaryBlue,
                              isChecked: controller.filterCompleted.value,
                              onChange: (bool? value) {
                                controller.filterCompleted.value = value ?? false;
                              },
                            );
                          }
                        ),
                      ],
                    ),
                    SizedBox(height: 25.h),
                    GestureDetector(
                      onTap: () {
                        Get.find<GrowthController>().filterGoals();
                        Navigator.of(context).pop();
                      },
                      child: const LoyaltriBlueTextButton(text: "Apply Filter"),
                    ),
                    SizedBox(height: 10.h),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}