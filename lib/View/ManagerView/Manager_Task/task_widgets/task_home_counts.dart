import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Task/task_controller/task_controller.dart';

import '../../../../utils/color_utils.dart';

class TaskHomeCounts extends StatelessWidget {
  final bool isDarkMode;
  const TaskHomeCounts({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.only(
                  top: 6.h,
                  left: 6.h,
                  bottom: 8.h,
                  right: 12.h,
                ),
                decoration: BoxDecoration(
                  color: isDarkMode ? Color(0xFF5A4130) : ColorUtils.warmIvory,
                  borderRadius: BorderRadius.circular(10).r,
                  border: Border.all(
                    color:
                        isDarkMode ? Color(0xFF5A4130) : ColorUtils.peachBeige,
                    width: 1.h,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8.h,
                          height: 8.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                isDarkMode
                                    ? Color(0xFFFAD487)
                                    : ColorUtils.goldenAmber,
                          ),
                        ),
                        SizedBox(width: 3.h),
                        Text(
                          'Due Today',
                          // overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            color:
                                isDarkMode
                                    ? ColorUtils.textWhite
                                    : ColorUtils.dimGrey,
                            fontSize: 11.h,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GetX<ManagerTaskController>(
                          builder: (ManagerTaskController controller) {
                            return Text(
                              controller.taskDashBoardCounts.value?.dueTodayCount
                                      ?.toString() ??
                                  '0',
                              // overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                color:
                                    isDarkMode
                                        ? ColorUtils.textWhite
                                        : ColorUtils.workEntryHead,
                                fontSize: 21.h,
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          },
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                for (int i = 0; i < 5; i++)
                                  if (i == 2 || i == 4)
                                    Container(
                                      width: 4.h,
                                      height: 4.h,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            isDarkMode
                                                ? ColorUtils.textWhite
                                                : Color(0xFFCB8D12),
                                      ),
                                    )
                                  else
                                    Container(
                                      width: 4.h,
                                      height: 4.h,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.transparent,
                                      ),
                                    ),
                              ],
                            ),
                            Container(
                              width: 4.h,
                              height: 4.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                for (int i = 0; i < 5; i++)
                                  if (i == 0 || i == 2 || i == 4)
                                    Container(
                                      width: 4.h,
                                      height: 4.h,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            isDarkMode
                                                ? ColorUtils.textWhite
                                                    .withValues(alpha: 0.6)
                                                : Color(
                                                  0xFFCB8D12,
                                                ).withValues(alpha: 0.6),
                                      ),
                                    )
                                  else
                                    Container(
                                      width: 4.h,
                                      height: 4.h,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.transparent,
                                      ),
                                    ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 10.h),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(
                  top: 6.h,
                  left: 6.h,
                  bottom: 8.h,
                  right: 12.h,
                ),
                decoration: BoxDecoration(
                  color: isDarkMode ? Color(0xFF571C1C) : ColorUtils.blushPink,
                  borderRadius: BorderRadius.circular(10).r,
                  border: Border.all(
                    color:
                        isDarkMode ? Color(0xFF571C1C) : ColorUtils.peachBlush,
                    width: 1.h,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8.h,
                          height: 8.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                isDarkMode
                                    ? Color(0xFFFB9089)
                                    : ColorUtils.absentColor,
                          ),
                        ),
                        SizedBox(width: 3.h),
                        Text(
                          'Overdue',
                          // overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            color:
                                isDarkMode
                                    ? ColorUtils.textWhite
                                    : ColorUtils.dimGrey,
                            fontSize: 11.h,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GetX<ManagerTaskController>(
                          builder: (ManagerTaskController controller) {
                            return Text(
                              controller.taskDashBoardCounts.value?.overdueCount
                                      ?.toString() ??
                                  '0',
                              // overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                color:
                                    isDarkMode
                                        ? ColorUtils.textWhite
                                        : ColorUtils.workEntryHead,
                                fontSize: 21.h,
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          },
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                for (int i = 0; i < 5; i++)
                                  if (i == 2 || i == 4)
                                    Container(
                                      width: 4.h,
                                      height: 4.h,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            isDarkMode
                                                ? ColorUtils.textWhite
                                                : ColorUtils.absentColor,
                                      ),
                                    )
                                  else
                                    Container(
                                      width: 4.h,
                                      height: 4.h,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.transparent,
                                      ),
                                    ),
                              ],
                            ),
                            Container(
                              width: 4.h,
                              height: 4.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                for (int i = 0; i < 5; i++)
                                  if (i == 0 || i == 2 || i == 4)
                                    Container(
                                      width: 4.h,
                                      height: 4.h,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            isDarkMode
                                                ? ColorUtils.textWhite
                                                    .withValues(alpha: 0.6)
                                                : ColorUtils.absentColor
                                                    .withValues(alpha: 0.6),
                                      ),
                                    )
                                  else
                                    Container(
                                      width: 4.h,
                                      height: 4.h,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.transparent,
                                      ),
                                    ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.only(
                  top: 6.h,
                  left: 6.h,
                  bottom: 8.h,
                  right: 12.h,
                ),
                decoration: BoxDecoration(
                  color: isDarkMode ? Color(0xFF1D3257) : ColorUtils.iceBlue,
                  borderRadius: BorderRadius.circular(10).r,
                  border: Border.all(
                    color: isDarkMode ? Color(0xFF1D3257) : ColorUtils.babyBlue,
                    width: 1.h,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8.h,
                          height: 8.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                isDarkMode
                                    ? Color(0xFF94BAFB)
                                    : ColorUtils.royalBlue,
                          ),
                        ),
                        SizedBox(width: 3.h),
                        Text(
                          'Assigned',
                          // overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            color:
                                isDarkMode
                                    ? ColorUtils.textWhite
                                    : ColorUtils.dimGrey,
                            fontSize: 11.h,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GetX<ManagerTaskController>(
                          builder: (ManagerTaskController controller) {
                            return Text(
                              controller.taskDashBoardCounts.value?.assignedCount
                                      ?.toString() ??
                                  '0',
                              // overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                color:
                                    isDarkMode
                                        ? ColorUtils.textWhite
                                        : ColorUtils.workEntryHead,
                                fontSize: 21.h,
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          },
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                for (int i = 0; i < 5; i++)
                                  if (i == 2 || i == 4)
                                    Container(
                                      width: 4.h,
                                      height: 4.h,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            isDarkMode
                                                ? ColorUtils.textWhite
                                                : ColorUtils.royalBlue,
                                      ),
                                    )
                                  else
                                    Container(
                                      width: 4.h,
                                      height: 4.h,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.transparent,
                                      ),
                                    ),
                              ],
                            ),
                            Container(
                              width: 4.h,
                              height: 4.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                for (int i = 0; i < 5; i++)
                                  if (i == 0 || i == 2 || i == 4)
                                    Container(
                                      width: 4.h,
                                      height: 4.h,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            isDarkMode
                                                ? ColorUtils.textWhite
                                                    .withValues(alpha: 0.6)
                                                : ColorUtils.royalBlue
                                                    .withValues(alpha: 0.6),
                                      ),
                                    )
                                  else
                                    Container(
                                      width: 4.h,
                                      height: 4.h,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.transparent,
                                      ),
                                    ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 10.h),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(
                  top: 6.h,
                  left: 6.h,
                  bottom: 8.h,
                  right: 12.h,
                ),
                decoration: BoxDecoration(
                  color:
                      isDarkMode ? Color(0xFF23402C) : ColorUtils.mindWhisper,
                  borderRadius: BorderRadius.circular(10).r,
                  border: Border.all(
                    color: isDarkMode ? Color(0xFF23402C) : ColorUtils.paleSage,
                    width: 1.h,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8.h,
                          height: 8.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                isDarkMode
                                    ? Color(0xFF57D67F)
                                    : ColorUtils.forestGreen,
                          ),
                        ),
                        SizedBox(width: 3.h),
                        Text(
                          'Unassigned',
                          // overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            color:
                                isDarkMode
                                    ? ColorUtils.textWhite
                                    : ColorUtils.dimGrey,
                            fontSize: 11.h,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GetX<ManagerTaskController>(
                          builder: (ManagerTaskController controller) {
                            return Text(
                              controller.taskDashBoardCounts.value?.unAssignedCount
                                      ?.toString() ??
                                  '0',
                              // overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                color:
                                    isDarkMode
                                        ? ColorUtils.textWhite
                                        : ColorUtils.workEntryHead,
                                fontSize: 21.h,
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          },
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                for (int i = 0; i < 5; i++)
                                  if (i == 2 || i == 4)
                                    Container(
                                      width: 4.h,
                                      height: 4.h,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            isDarkMode
                                                ? ColorUtils.textWhite
                                                : ColorUtils.charcoalGrey,
                                      ),
                                    )
                                  else
                                    Container(
                                      width: 4.h,
                                      height: 4.h,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.transparent,
                                      ),
                                    ),
                              ],
                            ),
                            Container(
                              width: 4.h,
                              height: 4.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                for (int i = 0; i < 5; i++)
                                  if (i == 0 || i == 2 || i == 4)
                                    Container(
                                      width: 4.h,
                                      height: 4.h,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            isDarkMode
                                                ? ColorUtils.textWhite
                                                    .withValues(alpha: 0.6)
                                                : ColorUtils.charcoalGrey
                                                    .withValues(alpha: 0.6),
                                      ),
                                    )
                                  else
                                    Container(
                                      width: 4.h,
                                      height: 4.h,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.transparent,
                                      ),
                                    ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
