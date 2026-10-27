import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/CWidgets/cwidgets.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Home/manager_home_controller/manager_home_controller.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Task/Manager_Task_Screen.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Task/task_controller/task_controller.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Task/task_widgets/taskTabSwitch.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Task/task_widgets/task_home_counts.dart';

import '../../../../utils/color_utils.dart';

class TaskView extends StatelessWidget {
  final bool isDarkMode;
  const TaskView({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.h),
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode ? ColorUtils.backgroundBlack : ColorUtils.textWhite,
          borderRadius: BorderRadius.circular(22).r,
          border: Border.all(
            color: ColorUtils.workEntryHead.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 3.h),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/manager_view/task-logo.png",
                        height: 23.h,
                      ),
                      SizedBox(width: 8.h),
                      Text(
                        'Task',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 13.h,
                          fontWeight: FontWeight.w600,
                          color: isDarkMode ? ColorUtils.textWhite : ColorUtils.workEntryHead,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        newSlideNavigation(TaskScreen(fromEmployee: isDarkMode)),
                      );
                    },
                    child: Row(
                      children: [
                        Text(
                          isDarkMode ? 'See all' : 'View All',
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            color: isDarkMode ? ColorUtils.seeMore : ColorUtils.workEntryHead,
                            fontSize: 12.h,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if(!isDarkMode)
                          SizedBox(width: 3.h),
                        if(!isDarkMode)
                          Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: ColorUtils.workEntryHead,
                            size: 9.h,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: isDarkMode ? ColorUtils.textWhite.withValues(alpha: 0.1) : ColorUtils.workEntryHead.withValues(alpha: 0.1),
              height: 0.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 9.h),
              child: TaskTabSwitch(isDarkMode: isDarkMode),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 12.h,
                right: 12.h,
                bottom: 12.h,
                top: 6.h,
              ),
              child: TaskHomeCounts(isDarkMode: isDarkMode),
            ),
          ],
        ),
      ),
    );
  }
}
