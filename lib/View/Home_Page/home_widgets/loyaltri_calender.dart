import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/Home_Page/home_widgets/calendar_leaveDay.dart';
import 'package:loyaltri_minimal/View/Home_Page/home_widgets/calender_default.dart';
import 'package:loyaltri_minimal/View/Home_Page/home_widgets/calender_header.dart';
import 'package:loyaltri_minimal/View/Home_Page/home_widgets/calender_hints.dart';
import 'package:loyaltri_minimal/View/Home_Page/home_widgets/calender_offDay.dart';
import 'package:loyaltri_minimal/View/Home_Page/home_widgets/calender_marker.dart';
import 'package:loyaltri_minimal/View/Home_Page/home_widgets/calender_outside.dart';
import 'package:loyaltri_minimal/View/Home_Page/home_widgets/calender_paidLeave.dart';
import 'package:loyaltri_minimal/View/Home_Page/home_widgets/calender_weaks.dart';
import 'package:loyaltri_minimal/View/Home_Page/home_widgets/clender_holiday.dart';
import 'package:loyaltri_minimal/controller/calendarEventsController.dart';
import 'package:loyaltri_minimal/controller/ui_controller/home_controller.dart';
import 'package:loyaltri_minimal/controller/ui_controller/page_controller.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';
import 'package:table_calendar/table_calendar.dart';

import 'calendar_presentDay.dart';

class LoyaltriCalender extends StatelessWidget {
  final Function(DateTime) loadMonthData;
  final DateTime focusedDate;
  const LoyaltriCalender({
    super.key,
    required this.loadMonthData,
    required this.focusedDate,
  });

  @override
  Widget build(BuildContext context) {
    bool isDark =
        Get.find<UserPageController>().appView.value == AppView.employee;
    return Column(
      children: [
        CalenderHeader(
          focusedDate: focusedDate,
          loadMonthData: loadMonthData,
          isDark: isDark,
        ),
        TableCalendar(
          headerVisible: false,
          calendarBuilders: CalendarBuilders(
            holidayBuilder: (BuildContext context, DateTime date, _) {
              if (date.weekday == DateTime.sunday && date.month == date.month) {
                return OffDayBuilder(date: date);
              } else {
                return null;
              }
            },
            dowBuilder: (BuildContext context, DateTime date) {
              if (date.weekday == DateTime.sunday) {
                return const CalenderWeek(week: 'S');
              }

              if (date.weekday == DateTime.monday) {
                return const CalenderWeek(week: 'M');
              }

              if (date.weekday == DateTime.tuesday) {
                return const CalenderWeek(week: 'T');
              }

              if (date.weekday == DateTime.wednesday) {
                return const CalenderWeek(week: 'W');
              }

              if (date.weekday == DateTime.thursday) {
                return const CalenderWeek(week: 'T');
              }

              if (date.weekday == DateTime.friday) {
                return const CalenderWeek(week: 'F');
              }

              if (date.weekday == DateTime.saturday) {
                return const CalenderWeek(week: 'S');
              }

              return null;
            },
            defaultBuilder: (BuildContext context, DateTime date, _) {
              return OutsideBuilder(date: date);
            },
            // todayBuilder: (BuildContext context, DateTime date, _) {
            //   return DefaultBuilder(date: date);
            // },
            outsideBuilder: (BuildContext context, DateTime date, _) {
              return OutsideBuilder(date: date);
            },
            markerBuilder: (BuildContext context, DateTime date, _) {
              return MarkerBuilderWidget(
                controller: Get.find<CalendarEventController>(),
                date: date,
              );
            },
          ),
          // holidayPredicate: (DateTime date) {
          //   return date.weekday == DateTime.sunday;
          // },
          firstDay: DateTime(DateTime.now().year - 1, 1, 1),
          focusedDay: focusedDate,
          lastDay: DateTime(DateTime.now().year + 1, 12, 31),
          calendarStyle: CalendarStyle(
            isTodayHighlighted: false,
            tablePadding: const EdgeInsets.all(8.0).w,
          ),
          availableGestures: AvailableGestures.horizontalSwipe,
          rowHeight: 35.w,
          daysOfWeekHeight: 30.w,
          onPageChanged: (date) {
            loadMonthData(date);
          },
        ),
      ],
    );
  }
}

class MarkerBuilderWidget extends StatelessWidget {
  final CalendarEventController controller;
  final DateTime date;
  const MarkerBuilderWidget({
    super.key,
    required this.controller,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.dataLoaded.value) {
        for (int i = 0; i < controller.presentDates.value.length; i++) {
          if (DateTime(date.year, date.month, date.day) ==
              DateTime.parse(controller.presentDates.value[i].date.toString())) {
            return PresentDayBuilder(date: date, data: controller.presentDates.value[i]);
          }
        }
        for (int i = 0; i < controller.paidLeaveDates.value.length; i++) {
          if (DateTime(date.year, date.month, date.day) ==
              DateTime.parse(
                controller.paidLeaveDates.value[i].date.toString(),
              )) {
            return PaidLeaveBuilder(date: date);
          }
        }
        for (int i = 0; i < controller.unPaidLeaveDates.value.length; i++) {
          if (DateTime(date.year, date.month, date.day) ==
              DateTime.parse(
                controller.unPaidLeaveDates.value[i].date.toString(),
              )) {
            return UnPaidLeaveBuilder(date: date);
          }
        }
        for (int i = 0; i < controller.holidayDates.value.length; i++) {
          if (DateTime(date.year, date.month, date.day) ==
              DateTime.parse(controller.holidayDates.value[i].date.toString())) {
            return HolidayBuilder(date: date);
          }
        }
        for (int i = 0; i < controller.offDayDates.value.length; i++) {
          if (DateTime(date.year, date.month, date.day) ==
              DateTime.parse(controller.offDayDates.value[i].date.toString())) {
            return OffDayBuilder(date: date);
          }
        }
      }
      return SizedBox.shrink();
    });
  }
}
