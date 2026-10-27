
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/Growth/growth_controller/growth_controller.dart';
import 'package:loyaltri_minimal/View/Growth/growth_widgets/goals_filter_sheet.dart';

import '../../../utils/color_utils.dart';

class GoalsSearchAndFilter extends StatelessWidget {
  final Color color;
  final Function(String) result;
  final bool isDarkMode;
  const GoalsSearchAndFilter({
    super.key,
    required this.color,
    required this.result,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(54).r,
              // color: ColorUtils.textWhite.withValues(alpha: 0.4),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  ColorUtils.textWhite.withValues(alpha: 0.4),
                  Color(0xFF919191).withValues(alpha: 0),
                  ColorUtils.foregroundBlack2.withValues(alpha: 0.9),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 4),
                  blurRadius: 4.r,
                  spreadRadius: 0,
                  color: ColorUtils.workEntryHead.withValues(alpha: 0.25),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(0.5.h),
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(50).r,
                ),
                height: 46.h,
                child: TextField(
                  onChanged: (value) {
                    result(value);
                  },
                  style: GoogleFonts.poppins(
                    color: isDarkMode ? ColorUtils.textWhite : ColorUtils.workEntryHead,
                    fontSize: 13.h,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    isDense: true,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: "Search goals or subgoals..",
                    hintStyle: GoogleFonts.poppins(
                      color: isDarkMode ? ColorUtils.textWhite.withValues(alpha: 0.5) : ColorUtils.workEntryHead.withValues(alpha: 0.5),
                      fontSize: 12.h,
                      fontWeight: FontWeight.w400,
                    ),
                    contentPadding: EdgeInsets.only(left: 10.h),
                    prefixIconConstraints: BoxConstraints(minWidth: 38.h),
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(top: 14.h, left: 16.h, bottom: 14.h),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            "assets/images/manager_view/search_icon_req.svg",
                            fit: BoxFit.contain,
                            colorFilter: isDarkMode ? ColorFilter.mode(ColorUtils.textWhite.withValues(alpha: 0.7), BlendMode.srcIn) : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 12.h),
        InkWell(
            borderRadius: BorderRadius.circular(14).r,
            onTap: () {
              showModalBottomSheet(
                backgroundColor: ColorUtils.backgroundBlack,
                context: context,
                isScrollControlled: true,
                barrierColor: ColorUtils.workEntryHead,
                builder: (BuildContext context) {
                  return GoalsFilterBottomSheet();
                },
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15).r,
                // color: ColorUtils.textWhite.withValues(alpha: 0.4),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    ColorUtils.textWhite.withValues(alpha: 0.4),
                    Color(0xFF919191).withValues(alpha: 0),
                    ColorUtils.foregroundBlack2.withValues(alpha: 0.9),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 4),
                    blurRadius: 4.r,
                    spreadRadius: 0,
                    color: ColorUtils.workEntryHead.withValues(alpha: 0.25),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(0.5.h),
                child: Container(
                  width: 44.h,
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(14).r,
                    // border: isDarkMode ? Border.all(color: Color(0xFFDEDEDE).withValues(alpha: 0.12), width: 1.h) : null,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 13.h),
                        child: SvgPicture.asset(
                          "assets/images/manager_view/filter_icon_req.svg",
                          colorFilter: isDarkMode ? ColorFilter.mode(ColorUtils.textWhite, BlendMode.srcIn) : null,
                        ),
                      ),
                      GetX<GrowthController>(
                        builder: (GrowthController controller) {
                          if(controller.filterPending.value || controller.filterCompleted.value) {
                            return Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                width: 10.h,
                                height: 10.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ColorUtils.mediumPurple,
                                ),
                              ),
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        }
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}