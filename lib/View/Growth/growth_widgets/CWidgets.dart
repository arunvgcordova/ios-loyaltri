
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/Growth/growth_controller/growth_controller.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';
import 'dart:math' as math;

class GrowthBack1 extends StatelessWidget {
  final Function? callBack;
  const GrowthBack1({super.key, this.callBack});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14).r,
      onTap: () {
        if(callBack == null) return;
        callBack?.call();
      },
      child: Container(
        width: 46.h,
        height: 46.h,
        decoration: BoxDecoration(
          color: ColorUtils.textWhite.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(14).r,
        ),
        child: Center(
          child: Image.asset(
            'assets/images/growth/growth-back-white.png',
            height: 14.h,
          ),
        ),
      ),
    );
  }
}

class GrowthBack2 extends StatelessWidget {
  final Function? callBack;
  final Widget? icon;
  final bool? isRotate;
  const GrowthBack2({super.key, this.callBack, this.icon, this.isRotate});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14).r,
      onTap: () {
        if(callBack == null) return;
        callBack?.call();
      },
      child: Transform.rotate(
        angle: (isRotate ?? false) ? math.pi / 2 : 0,
        child: Container(
          width: 41.h,
          height: 41.h,
          decoration: BoxDecoration(
            color: ColorUtils.darkSlatePurple,
            borderRadius: BorderRadius.circular(14).r,
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(left: (isRotate ?? false) ? 2.h : 0),
              child: icon ?? Image.asset(
                'assets/images/growth/growth-back-coolGrey.png',
                height: 14.h,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GrowthClose1 extends StatelessWidget {
  final Function? callBack;
  const GrowthClose1({super.key, this.callBack});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14).r,
      onTap: () {
        if(callBack == null) return;
        callBack?.call();
      },
      child: Container(
        width: 43.h,
        height: 43.h,
        decoration: BoxDecoration(
          color: ColorUtils.royalIndigo,
          borderRadius: BorderRadius.circular(14).r,
        ),
        child: Center(
          child: Icon(Icons.close, color: ColorUtils.textWhite, size: 22.h),
        ),
      ),
    );
  }
}

class EvaluationDateHead extends GetView<GrowthController> {
  final bool isHome;
  final String? templateName;
  final double? avgScore;
  const EvaluationDateHead({super.key, required this.isHome, this.templateName, this.avgScore});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
        return Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isHome ? controller.homeYear.value ?? '' : controller.yearString[controller.currentYearIndex],
                      style: GoogleFonts.urbanist(
                        fontSize: 17.h,
                        fontWeight: FontWeight.w600,
                        color: ColorUtils.textWhite,
                      ),
                    ),
                    Text(
                      templateName ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 13.h,
                        fontWeight: FontWeight.w500,
                        color: ColorUtils.textWhite,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
              ),
              if(!isHome)
                Padding(
                padding: EdgeInsets.only(right: 8.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Avg Score ',
                      style: GoogleFonts.inter(
                        fontSize: 11.h,
                        fontWeight: FontWeight.w500,
                        color: ColorUtils.textWhite.withValues(alpha: 0.5),
                      ),
                    ),
                    Text(
                      '${avgScore?.toStringAsFixed(0) ?? ''}${avgScore != null ? '%' : ''}',
                      style: GoogleFonts.inter(
                        fontSize: 17.h,
                        fontWeight: FontWeight.w500,
                        color: ColorUtils.textWhite,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}
