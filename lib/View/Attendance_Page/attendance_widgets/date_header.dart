import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../controller/attendanceListController.dart';
import '../../../utils/color_utils.dart';

class DateHeader extends StatefulWidget {
  final Function(String) onMonthChanged;
  const DateHeader({super.key, required this.onMonthChanged});

  @override
  State<DateHeader> createState() => _DateHeaderState();
}

class _DateHeaderState extends State<DateHeader> {
  late FixedExtentScrollController _scrollController;
  int currentValue = 0; // Initial value for the red widget
  Timer? _debounceTimer;

  // List<String> monthString = List.generate(11, (index) {
  //   DateTime currentDate = DateTime.now();
  //
  //   // Adjust the month for each iteration
  //   DateTime targetDate =
  //       DateTime(currentDate.year, currentDate.month - 10 + index, 1);
  //
  //   // Format the date using DateFormat
  //   String formattedDate = DateFormat.yMMM().format(targetDate);
  //
  //   return formattedDate;
  // });

  @override
  void initState() {
    super.initState();
    _scrollController = FixedExtentScrollController(initialItem: currentValue);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5).w,
      child: GetX<AttendanceList>(
        builder: (AttendanceList controller) {
          return Container(
            height: 38.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ColorUtils.datePickColor.withOpacity(0.4),
                  ColorUtils.datePickColor,
                  ColorUtils.datePickColor.withOpacity(0.4),
                ],
              ),
            ),
            child: RotatedBox(
              quarterTurns: 1,
              child: ListWheelScrollView.useDelegate(
                controller: _scrollController,
                physics: const FixedExtentScrollPhysics(),
                magnification: 2.0,
                itemExtent: 80,
                diameterRatio: 2.0,
                onSelectedItemChanged: (index) {
                  setState(() {
                    currentValue = index;
                  });
                  HapticFeedback.lightImpact();
                  _debounceTimer?.cancel();
                  _debounceTimer = Timer(const Duration(milliseconds: 400), () {
                    widget.onMonthChanged(controller.monthString.value[index]);
                  });
                },
                childDelegate: ListWheelChildBuilderDelegate(
                  builder: (BuildContext context, int index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      width: index == currentValue
                          ? 65.w
                          : 54.w, // Adjust red widget size
                      height: index == currentValue ? 21.h : 21.h,
                      child: Center(
                        child: RotatedBox(
                          quarterTurns: -1,
                          child: Text(
                            controller.monthString.value[index],
                            style: GoogleFonts.poppins(
                              color: index == currentValue
                                  ? ColorUtils.textWhite
                                  : ColorUtils.textWhite.withOpacity(0.4),
                              fontSize: index == currentValue ? 14.sp : 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: controller.monthString.value.length,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
