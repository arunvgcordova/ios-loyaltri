
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../utils/color_utils.dart';
import '../../Piece_Work/piece_work_controller/piece_work_controller.dart';
import '../../Piece_Work/piece_work_widgets/calendar_sheet.dart';

class DaySwitchView extends StatefulWidget {
  final Function(int)? onMonthChanged;
  const DaySwitchView({super.key, this.onMonthChanged});

  @override
  State<DaySwitchView> createState() => _DaySwitchViewState();
}

class _DaySwitchViewState extends State<DaySwitchView> {
  late FixedExtentScrollController _scrollController;
  List<DateTime> dateList = Get.find<PieceWorkController>().dateList.value;
  int currentValue = Get.find<PieceWorkController>().currentDateIndex.value;
  Timer? timer;
  Timer? _deBouncer;

  @override
  void initState() {
    _scrollController = FixedExtentScrollController(initialItem: currentValue);
    bool notWorking = true;
    timer = Timer.periodic(Duration(milliseconds: 1), (timer) async {
      if(notWorking) {
        notWorking = false;
        int newValue = Get.find<PieceWorkController>().currentDateIndex.value;
        bool isChangedMonth = Get.find<PieceWorkController>().isChangedFromMonth.value;
        // print("--------newValue-----$currentValue---$newValue");

        if(currentValue != newValue) {
          if(isChangedMonth) {
            setState(() {
              currentValue = newValue;
            });
            await _scrollController.animateToItem(
              newValue,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
            widget.onMonthChanged!(newValue);
            Get.find<PieceWorkController>().isChangedFromMonth.value = false;
          }
        }
        notWorking = true;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    if(timer != null) {
      timer?.cancel();
    }
    super.dispose();
  }
  void deBouncerFunction(Function(int) callback, int index) {
    if(_deBouncer?.isActive ?? false) {
      _deBouncer?.cancel();
    }
    _deBouncer = Timer(Duration(milliseconds: 500), () {
      callback(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5).h,
      child: Container(
        height: 65.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ColorUtils.datePickColor.withValues(alpha: 0.0),
              Color(0xFF6F10AE).withValues(alpha: 0.1),
              ColorUtils.datePickColor.withValues(alpha: 0.0),
            ],
          ),
        ),
        child: RotatedBox(
          quarterTurns: 1,
          child: ListWheelScrollView.useDelegate(
            controller: _scrollController,
            physics: const FixedExtentScrollPhysics(),
            magnification: 2.0,
            itemExtent: 52.h,
            diameterRatio: 10.0,
            perspective: 0.001,
            onSelectedItemChanged: (index) async {
              if(!Get.find<PieceWorkController>().isChangedFromMonth.value) {
                Get.find<PieceWorkController>().currentDateIndex.value = index;
                setState(() {
                  currentValue = index;
                });

                deBouncerFunction((selectedIndex) {
                  widget.onMonthChanged!(selectedIndex);
                }, index);
              }
              // int newValue = Get.find<ManagerAttendanceController>().currentDateIndex.value;
              // print("-------newValue----------$newValue");
              // print("-------index----------$index");
              // if(currentValue + 15 > newValue || currentValue - 15 < newValue) {
              //   Get.find<ManagerAttendanceController>().currentDateIndex.value = index;
              // }
              // setState(() {
              //   currentValue = index;
              //   widget.onMonthChanged!(index);
              // });
              // controller.currentDateIndex.value = index;
              // await _scrollController.animateToItem(
              //   index,
              //   duration: const Duration(milliseconds: 300),
              //   curve: Curves.easeInOut,
              // );
              // setState(() {});
              // DateTime customDate = DateTime(controller.selectedYear.value, controller.selectedMonth.value, controller.selectedDay.value + 1);

              // String date = DateFormat('yyyy-MM-dd').format(controller.dateList.value[controller.currentDateIndex.value]);
              // print("------date-----$date");
              // await initialize(selectedDate: date);
            },
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () async {
                    final result = await showModalBottomSheet(
                      context: context,
                      barrierColor: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                      backgroundColor: ColorUtils.textWhite,
                      isDismissible: false,
                      isScrollControlled: true,
                      builder: (context) {
                        return PieceWorkCalendarSheet();
                      },
                    );
                    if(result != null && result is DateTime) {
                      String selectedDate = result.toString().split(' ').first;
                      HapticFeedback.lightImpact();
                      int index = Get.find<PieceWorkController>().dateList.value.indexWhere((date) => date.toString().split(' ').first == selectedDate);
                      Get.find<PieceWorkController>().currentDateIndex.value = index;
                      Get.find<PieceWorkController>().isChangedFromMonth.value = true;
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    width: index == currentValue
                        ? 65.h
                        : 54.h, // Adjust red widget size
                    height: index == currentValue ? 21.h : 21.h,
                    color: Colors.transparent,
                    child: Center(
                      child: RotatedBox(
                        quarterTurns: -1,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "${dateList[index].day}",
                              style: GoogleFonts.poppins(
                                color: index == currentValue
                                    ? ColorUtils.workEntryHead
                                    : ColorUtils.workEntryHead.withValues(alpha: (index + 1 == currentValue || index - 1 == currentValue) ? 0.6 : (index + 2 == currentValue || index - 2 == currentValue) ? 0.4 : 0.2),
                                fontSize: index == currentValue ? 18.h : 15.h,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              DateFormat('EEE').format(dateList[index]),
                              style: GoogleFonts.poppins(
                                color: index == currentValue
                                    ? ColorUtils.workEntryHead
                                    : ColorUtils.workEntryHead.withValues(alpha: (index + 1 == currentValue || index - 1 == currentValue) ? 0.6 : (index + 2 == currentValue || index - 2 == currentValue) ? 0.4 : 0.2),
                                fontSize: index == currentValue ? 13.h : 10.h,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              childCount: dateList.length,
            ),
          ),
        ),
      ),
    );
  }
}
