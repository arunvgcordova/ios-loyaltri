import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controller/ui_controller/home_controller.dart';
import '../../../controller/ui_controller/page_controller.dart';
import '../../../utils/color_utils.dart';

class ChevronIconLeft extends StatelessWidget {
  final IconData chevronIcon;
  const ChevronIconLeft({super.key, required this.chevronIcon});

  @override
  Widget build(BuildContext context) {
    bool isDark = Get.find<UserPageController>().appView.value == AppView.employee;
    return Container(
      height: 33.h,
      width: 33.h,
      decoration: BoxDecoration(
          color: isDark ? ColorUtils.foregroundBlack : ColorUtils.workEntryHead.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(100).w),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 5).h,
          child: Icon(
            chevronIcon,
            size: 13.h,
            color: isDark ? ColorUtils.textWhite : ColorUtils.workEntryHead,
          ),
        ),
      ),
    );
  }
}

class ChevronIconRight extends StatelessWidget {
  final IconData chevronIcon;
  const ChevronIconRight({super.key, required this.chevronIcon});

  @override
  Widget build(BuildContext context) {
    bool isDark = Get.find<UserPageController>().appView.value == AppView.employee;
    return Container(
      height: 33.h,
      width: 33.h,
      decoration: BoxDecoration(
          color: isDark ? ColorUtils.foregroundBlack : ColorUtils.workEntryHead.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(100).w),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 2).h,
          child: Icon(
            chevronIcon,
            size: 13.h,
            color: isDark ? ColorUtils.textWhite : ColorUtils.workEntryHead,
          ),
        ),
      ),
    );
  }
}
