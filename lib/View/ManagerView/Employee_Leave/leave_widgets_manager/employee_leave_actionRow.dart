import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/ManagerView/Employee_Leave/employee_leave_controller/employee_leave_controller.dart';

import '../../../../utils/color_utils.dart';

List<String> actions = ["Pending", "Rejected", "Approved", "All"];

class EmployeeLeaveActionRow extends StatelessWidget {
  const EmployeeLeaveActionRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().screenWidth,
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.h),
      decoration: BoxDecoration(
        color: ColorUtils.textWhite,
        borderRadius: BorderRadius.circular(20).r,
        border: Border.all(
          color: ColorUtils.cloudySilver.withValues(alpha: 0.12),
          width: 1.h,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ...List.generate(actions.length, (index) {
            return _Action(
              title: actions[index],
              color: pickTextColor(index),
              index: index,
            );
          }),
        ],
      ),
    );
  }
}

class _Action extends StatelessWidget {
  final String title;
  final Color color;
  final int index;
  const _Action({
    required this.title,
    required this.color,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          Get.find<EmployeeLeaveController>().currentTabIndex.value = index;
          Get.find<EmployeeLeaveController>().filterByName(value: Get.find<EmployeeLeaveController>().searchText.value ?? '');
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 8.h,
            horizontal: index == 0 ? 16.h : 13.h,
          ),
          decoration:
              Get.find<EmployeeLeaveController>().currentTabIndex.value == index
                  ? BoxDecoration(
                    color: ColorUtils.lilacHaze,
                    borderRadius: BorderRadius.circular(22).r,
                  )
                  : null,
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              color: color,
              fontWeight: FontWeight.w500,
              fontSize: 13.h,
            ),
          ),
        ),
      ),
    );
  }
}

Color pickTextColor(int index) {
  switch (index) {
    case 0:
      return ColorUtils.burntOrange;
    case 1:
      return ColorUtils.crimsonRed;
    case 2:
      return ColorUtils.royalPurple;
    case 3:
      return ColorUtils.workEntryHead;
    default:
      return ColorUtils.workEntryHead;
  }
}
