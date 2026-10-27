import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/CWidgets/date_picker.dart';
import 'package:loyaltri_minimal/View/field/core/colour_utils.dart';
import 'package:loyaltri_minimal/View/field/core/utils.dart';
import 'package:loyaltri_minimal/View/field/features/home/controller/home_controller.dart';
import 'package:loyaltri_minimal/View/field/features/home/home_screen.dart';

class WorkOverview extends GetView<FieldHomeController> {
  const WorkOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: ColourUtils.bgColour6,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: ColourUtils.borderColour, width: 1.h),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Work Overview',
                style: GoogleFonts.inter(
                  color: ColourUtils.textWhite,
                  fontSize: 14.h,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              WorkOverviewFilter(
                value: controller.frequency.value,
                onChanged: (value) {
                  controller.frequency.value = value;
                  controller.fetchHomeDetail();
                },
              ),
              // SizedBox(width: 10.w),
              // Text(
              //   'View All',
              //   style: GoogleFonts.inter(
              //     color: ColourUtils.fontColour1,
              //     fontSize: 12.h,
              //     fontWeight: FontWeight.w400,
              //   ),
              // ),
            ],
          ),
          SizedBox(height: 14.h),
          _buildStatusOverviewGrid(),
        ],
      ),
    );
  }
  Widget _buildStatusOverviewGrid() {
    final statusData = [
      {
        'label': 'Total',
        'value': controller.homeData.value?.data?.workOverview?.total
            .toString(),
        'color': ColourUtils.textMain,
        'bg': ColourUtils.bgColour10,
      },
      {
        'label': 'Pending',
        'value': controller.homeData.value?.data?.workOverview?.pending
            .toString(),
        'color': ColourUtils.pending,
        'bg': ColourUtils.pendingBg,
      },
      {
        'label': 'Done',
        'value': controller.homeData.value?.data?.workOverview?.done.toString(),
        'color': ColourUtils.fontColour5,
        'bg': ColourUtils.completedBg,
      },
      // {
      //   'label': 'Delayed',
      //   'value': '2',
      //   'color': ColourUtils.delayed,
      //   'bg': ColourUtils.delayedBg,
      // },
      {
        'label': 'Overdue',
        'value': controller.homeData.value?.data?.workOverview?.overdue
            .toString(),
        'color': ColourUtils.bgColour12,
        'bg': ColourUtils.overdueBg,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10.w,
        childAspectRatio: 0.9,
      ),
      itemCount: statusData.length,
      itemBuilder: (context, index) {
        final stat = statusData[index];
        return Container(
          decoration: BoxDecoration(
            color: stat['bg'] as Color,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: ColourUtils.borderColour),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                stat['value'] as String,
                style: GoogleFonts.inter(
                  color: stat['color'] as Color,
                  fontSize: 18.h,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                stat['label'] as String,
                style: GoogleFonts.inter(
                  color: stat['color'] as Color,
                  fontSize: 12.h,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

enum FilterType { today, thisWeek, thisMonth, custom }

class WorkOverviewFilter extends StatefulWidget {
  const WorkOverviewFilter({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final FilterType value;
  final ValueChanged<FilterType> onChanged;

  @override
  State<WorkOverviewFilter> createState() => _WorkOverviewFilterState();
}

class _WorkOverviewFilterState extends State<WorkOverviewFilter> {
  String getLabel(FilterType value) {
    switch (value) {
      case FilterType.today:
        return 'Today';
      case FilterType.thisWeek:
        return 'This Week';
      case FilterType.thisMonth:
        return 'This Month';
      case FilterType.custom:
        final homeController = Get.find<FieldHomeController>();
        if (homeController.startDate.isNotEmpty &&
            homeController.endDate.isNotEmpty) {
          try {
            final start = DateFormat(
              'yyyy-MM-dd',
            ).parse(homeController.startDate);
            final end = DateFormat('yyyy-MM-dd').parse(homeController.endDate);
            return '${DateFormat('dd MMM').format(start)} - ${DateFormat('dd MMM').format(end)}';
          } catch (_) {
            return 'Custom Range';
          }
        }
        return 'Custom Range';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      style: MenuStyle(
        backgroundColor: WidgetStateProperty.all(const Color(0xFF191C23)),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        ),
        padding: WidgetStateProperty.all(EdgeInsets.symmetric(vertical: 6.h)),
      ),
      menuChildren: FilterType.values.map((e) {
        final selected = e == widget.value;

        return MenuItemButton(
          onPressed: () async {
            if (e == FilterType.custom) {
              final DateTimeRange? picked = await pickDateRange(
                context,
                ThemeMode.dark,
                firstDate: DateTime(DateTime.now().year - 5),
                lastDate: DateTime(DateTime.now().year + 5),
              );

              if (picked != null) {
                final homeController = Get.find<FieldHomeController>();
                homeController.startDate = DateFormat(
                  'yyyy-MM-dd',
                ).format(picked.start);
                homeController.endDate = DateFormat(
                  'yyyy-MM-dd',
                ).format(picked.end);
                widget.onChanged(e);
              }
            } else {
              widget.onChanged(e);
            }
          },
          // style: ButtonStyle(
          //   padding: WidgetStateProperty.all(
          //     EdgeInsets.symmetric(
          //       horizontal: 16.w,
          //       vertical: 0.h,
          //     ),
          //   ),
          // ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  e == FilterType.custom ? 'Custom Range' : getLabel(e),
                  style: GoogleFonts.inter(
                    color: ColourUtils.textWhite,
                    fontSize: 12.h,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(width: 5.w),
              if (selected)
                Icon(Icons.check, color: const Color(0xFF8B7CFF), size: 15.h),
            ],
          ),
        );
      }).toList(),
      builder: (context, controller, child) {
        return InkWell(
          borderRadius: BorderRadius.circular(8.r),
          onTap: () {
            controller.isOpen ? controller.close() : controller.open();
          },
          child: Container(
            height: 30.h,
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            decoration: BoxDecoration(
              color: ColourUtils.bgColour11,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                svgWidget(height: 15.h, width: 15.h, icon: 'calendar'),
                SizedBox(width: 5.w),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Text(
                    getLabel(widget.value),
                    style: GoogleFonts.inter(
                      color: ColourUtils.textWhite,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(width: 5.w),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: ColourUtils.textWhite,
                  size: 15.h,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

