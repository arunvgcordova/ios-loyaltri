import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/Growth/growth_controller/growth_controller.dart';
import '../../../../utils/color_utils.dart';
import 'CWidgets.dart';

class GrowthAppBar extends StatelessWidget {
  final String title;
  const GrowthAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      right: false,
      left: false,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GrowthBack1(callBack: () => Navigator.of(context).pop()),
          Row(
            children: [
              Text(
                title,
                style: GoogleFonts.urbanist(
                  color: ColorUtils.textWhite,
                  fontSize: 17.h,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          Container(
            width: 48.h,
            height: 48.h,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(14).r,
            ),
          ),
        ],
      ),
    );
  }
}

class GrowthAppBar2 extends StatelessWidget {
  final String title;
  const GrowthAppBar2({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      right: false,
      left: false,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(14).r,
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              width: 46.h,
              height: 46.h,
              decoration: BoxDecoration(
                color: ColorUtils.veryDarkGrey,
                borderRadius: BorderRadius.circular(14).r,
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/growth/growth-back-white.png',
                  height: 14.h,
                ),
              ),
            ),
          ),
          Column(
            children: [
              Text(
                title,
                style: GoogleFonts.urbanist(
                  color: ColorUtils.textWhite,
                  fontSize: 17.h,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GetBuilder<GrowthController>(
                builder: (GrowthController controller) {
                  int goals = controller.goalsAndSubgoalsList.value.length;
                  int subGoals = controller.totalSubGoals.value;
                  return Text(
                    '$goals ${goals < 2 ? 'Goal' : 'Goals'} · $subGoals ${subGoals < 2 ? 'Sub-goal' : 'Sub-goals'}',
                    style: GoogleFonts.inter(
                      color: ColorUtils.textWhite.withValues(alpha: 0.4),
                      fontSize: 11.h,
                      fontWeight: FontWeight.w400,
                    ),
                  );
                },
              ),
            ],
          ),

          Container(
            width: 48.h,
            height: 48.h,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(14).r,
            ),
          ),
        ],
      ),
    );
  }
}

class GrowthAppBar3 extends StatelessWidget {
  final String title;
  final VoidCallback callback;
  const GrowthAppBar3({super.key, required this.title, required this.callback});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      right: false,
      left: false,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(14).r,
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              width: 46.h,
              height: 46.h,
              decoration: BoxDecoration(
                color: ColorUtils.veryDarkGrey,
                borderRadius: BorderRadius.circular(14).r,
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/growth/growth-back-white.png',
                  height: 14.h,
                ),
              ),
            ),
          ),
          Text(
            title,
            style: GoogleFonts.urbanist(
              color: ColorUtils.textWhite,
              fontSize: 17.h,
              fontWeight: FontWeight.w600,
            ),
          ),

          InkWell(
            borderRadius: BorderRadius.circular(14).r,
            onTap: () {
              callback.call();
            },
            child: Container(
              width: 46.h,
              height: 46.h,
              decoration: BoxDecoration(
                color: ColorUtils.veryDarkGrey,
                borderRadius: BorderRadius.circular(14).r,
              ),
              child: Center(
                child: Icon(
                  Icons.more_vert,
                  color: ColorUtils.textWhite.withValues(alpha: 0.4),
                  size: 20.h,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
