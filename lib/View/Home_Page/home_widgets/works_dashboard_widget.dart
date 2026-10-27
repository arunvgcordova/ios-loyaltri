import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/field/core/colour_utils.dart';
import 'package:loyaltri_minimal/controller/ui_controller/home_controller.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';

class WorksDashboardWidget extends StatelessWidget {
  final VoidCallback? onViewAllTap;

  const WorksDashboardWidget({
    super.key,
    this.onViewAllTap,
  });

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final isToday = date.year == now.year && date.month == now.month && date.day == now.day;
    final formatted = DateFormat('MMM d EEE').format(date);
    return isToday ? "$formatted - Today" : formatted;
  }

  String _formatOverdueTime(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty || rawDate == '--') return '--';
    try {
      final parsed = DateTime.parse(rawDate);
      return DateFormat('d MMM yyyy').format(parsed);
    } catch (_) {
      return rawDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 4.h),
      child: Container(
        decoration: BoxDecoration(
          color: ColorUtils.backgroundBlack,
          borderRadius: BorderRadius.circular(16).r,
        ),
        padding: EdgeInsets.all(14.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Navigation & Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        final newDate = homeController.worksSelectedDate.value.subtract(const Duration(days: 1));
                        homeController.fetchWorkLogByDate(date: newDate);
                      },
                      borderRadius: BorderRadius.circular(20).r,
                      child: Container(
                        width: 32.h,
                        height: 32.h,
                        decoration: const BoxDecoration(
                          color: ColorUtils.foregroundBlack,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.chevron_left_rounded,
                          color: ColorUtils.textWhite,
                          size: 18.h,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.h),
                    Obx(() {
                      return Text(
                        _formatDateHeader(homeController.worksSelectedDate.value),
                        style: GoogleFonts.poppins(
                          color: ColorUtils.textWhite,
                          fontSize: 12.h,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }),
                    SizedBox(width: 10.h),
                    InkWell(
                      onTap: () {
                        final newDate = homeController.worksSelectedDate.value.add(const Duration(days: 1));
                        homeController.fetchWorkLogByDate(date: newDate);
                      },
                      borderRadius: BorderRadius.circular(20).r,
                      child: Container(
                        width: 32.h,
                        height: 32.h,
                        decoration: const BoxDecoration(
                          color: ColorUtils.foregroundBlack,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.chevron_right_rounded,
                          color: ColorUtils.textWhite,
                          size: 18.h,
                        ),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: onViewAllTap,
                  child: Text(
                    'View All',
                    style: GoogleFonts.inter(
                      color: const Color(0xFFA896FF),
                      fontSize: 12.h,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 14.h),

            // Summary Metrics Box & Segmented Bar
            Obx(() {
              final completedList = homeController.dashboardCompletedWorks;
              final pendingList = homeController.dashboardPendingWorks;
              final overdueList = homeController.dashboardOverdueWorks;

              final completedCount = completedList.length;
              final pendingCount = pendingList.length;
              final overdueCount = overdueList.length;
              final totalCount = completedCount + pendingCount;

              final int flexTotal = totalCount > 0 ? totalCount : 0;
              final int flexCompleted = totalCount > 0 ? completedCount : 0;
              final int flexPending = totalCount > 0 ? pendingCount : 0;

              return Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF211F26),
                  borderRadius: BorderRadius.circular(10).r,
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 14.h),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildMetricColumn('$totalCount', 'Total Works', ColorUtils.skyBlue),
                        SizedBox(width: 5.h),
                        _buildMetricColumn('$completedCount', 'Completed', ColourUtils.bgColour15),
                        SizedBox(width: 5.h),
                        _buildMetricColumn('$pendingCount', 'Pending', ColorUtils.coralRed),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    // Segmented colored progress line bar
                    if(totalCount > 0)
                      ClipRRect(
                      borderRadius: BorderRadius.circular(8.8).r,
                      child: SizedBox(
                        height: 5.6.h,
                        child: Row(
                          children: [
                            Expanded(
                              flex: flexTotal,
                              child: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Color(0xFF554AFC),
                                      Color(0xFF61A9FE),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            if (flexCompleted > 0)
                              Expanded(
                                flex: flexCompleted,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Color(0xFF4EDC95),
                                        Color(0xFF75C24F),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            if (flexPending > 0)
                              Expanded(
                                flex: flexPending,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Color(0xFFAB3645),
                                        Color(0xFFC03544),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    )
                    else
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.8).r,
                        child: Container(
                          height: 5.6.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color(0xFFEDEDED).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8.8).r,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),


            Obx(() {
              final overdueList = homeController.dashboardOverdueWorks;
              final pendingList = homeController.dashboardPendingWorks;

              final bgColors = [
                const Color(0xFF3D242B),
                const Color(0xFF3D3521),
                const Color(0xFF1D2E47),
              ];
              final iconColors = [
                const Color(0xFFFB923C),
                const Color(0xFFFBBF24),
                const Color(0xFF38BDF8),
              ];

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if(overdueList.isNotEmpty)
                      SizedBox(height: 18.h),

                    // Overdue Works Section
                    if(overdueList.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/images/growth/exclemation-red.png',
                                    width: 16.h,
                                    height: 16.h,
                                  ),
                                  SizedBox(width: 8.h),
                                  Text(
                                    'Overdue Works',
                                    style: GoogleFonts.inter(
                                      color: ColorUtils.coralRed,
                                      fontSize: 12.h,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '${overdueList.length}',
                                style: GoogleFonts.inter(
                                  color: ColorUtils.coralRed.withValues(alpha: 0.6),
                                  fontSize: 12.h,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 12.h),

                          if (overdueList.isEmpty)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 6.h),
                              child: Text(
                                'No overdue works',
                                style: GoogleFonts.inter(
                                  color: ColorUtils.textWhite.withValues(alpha: 0.4),
                                  fontSize: 12.h,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            )
                          else
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: overdueList.length > 3 ? 3 : overdueList.length,
                              separatorBuilder: (context, index) => SizedBox(height: 8.h),
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                final item = overdueList[index];
                                final title = item.title ?? item.customerDetail?.name ?? '--';
                                final rawDate = (item.instances?.isNotEmpty ?? false)
                                    ? item.instances?.first.scheduledDate
                                    : null;
                                final time = _formatOverdueTime(rawDate);

                                return Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF211F26),
                                    borderRadius: BorderRadius.circular(8.8).r,
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 12.h),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 28.4.h,
                                        height: 28.4.h,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFB2C36).withValues(alpha: 0.3),
                                          borderRadius: BorderRadius.circular(8.8).r,
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.error_outline_rounded,
                                            color: const Color(0xFFFFA2A2),
                                            size: 16.h,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 12.h),
                                      Expanded(
                                        child: Text(
                                          title,
                                          style: GoogleFonts.inter(
                                            color: ColorUtils.textWhite,
                                            fontSize: 12.h,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        time,
                                        style: GoogleFonts.inter(
                                          color: const Color(0xFFFFA2A2),
                                          fontSize: 12.h,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          if (overdueList.length > 3) ...[
                            SizedBox(height: 10.h),
                            GestureDetector(
                              onTap: onViewAllTap,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'View More',
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFFA896FF),
                                      fontSize: 12.h,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(width: 2.h),
                                  Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: const Color(0xFFA896FF),
                                    size: 18.h,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),

                    if(pendingList.isNotEmpty)
                      SizedBox(height: 18.h),

                    // Pending Works Section
                    if(pendingList.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Pending Works',
                                style: GoogleFonts.inter(
                                  color: ColorUtils.textWhite.withValues(alpha: 0.6),
                                  fontSize: 10.6.h,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                '${pendingList.length}',
                                style: GoogleFonts.inter(
                                  color: ColorUtils.textWhite.withValues(alpha: 0.6),
                                  fontSize: 12.h,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 12.h),

                          if (pendingList.isEmpty)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 6.h),
                              child: Text(
                                'No pending works',
                                style: GoogleFonts.inter(
                                  color: ColorUtils.textWhite.withValues(alpha: 0.4),
                                  fontSize: 12.h,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            )
                          else
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: pendingList.length > 3 ? 3 : pendingList.length,
                              separatorBuilder: (context, index) => SizedBox(height: 8.h),
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                final item = pendingList[index];
                                final title = item.title ?? item.customerDetail?.name ?? 'Work Item';
                                final time = (item.startTime != null && item.startTime!.isNotEmpty)
                                    ? "${item.startTime}${item.endTime != null && item.endTime!.isNotEmpty ? ' - ${item.endTime}' : ''}"
                                    : 'No time';

                                final bgColor = bgColors[index % bgColors.length];
                                final iconColor = iconColors[index % iconColors.length];

                                return Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF211F26),
                                    borderRadius: BorderRadius.circular(8.8).r,
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 10.h),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 28.4.h,
                                        height: 28.4.h,
                                        decoration: BoxDecoration(
                                          color: bgColor,
                                          borderRadius: BorderRadius.circular(8).r,
                                        ),
                                        child: Center(
                                          child: SvgPicture.asset(
                                            'assets/images/field/svg/bag.svg',
                                            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                                            width: 14.h,
                                            height: 14.h,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 12.h),
                                      Expanded(
                                        child: Text(
                                          title,
                                          style: GoogleFonts.inter(
                                            color: ColorUtils.textWhite,
                                            fontSize: 12.h,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        time,
                                        style: GoogleFonts.inter(
                                          color: ColorUtils.textWhite.withValues(alpha: 0.6),
                                          fontSize: 12.h,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          if (pendingList.length > 3) ...[
                            SizedBox(height: 10.h),
                            GestureDetector(
                              onTap: onViewAllTap,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'View More',
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFFA896FF),
                                      fontSize: 12.h,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(width: 2.h),
                                  Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: const Color(0xFFA896FF),
                                    size: 18.h,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),

                    if(overdueList.isEmpty && pendingList.isEmpty)
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 18.h),
                          child: SvgPicture.asset(
                            'assets/images/field/svg/no_work_data.svg',
                          ),
                        ),
                      ),
                    if(overdueList.isEmpty && pendingList.isEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 18.h),
                        child: Text(
                          'You have no upcoming work or\nwork in progress',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 14.h,
                            fontWeight: FontWeight.w400,
                            color: ColorUtils.textWhite.withValues(alpha: 0.6)
                          ),
                        ),
                      ),
                  ],
                );
              }
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricColumn(String count, String label, Color countColor) {
    return Column(
      children: [
        Text(
          count,
          style: GoogleFonts.inter(
            color: countColor,
            fontSize: 20.h,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: GoogleFonts.inter(
            color: ColorUtils.textWhite.withValues(alpha: 0.6),
            fontSize: 11.h,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
