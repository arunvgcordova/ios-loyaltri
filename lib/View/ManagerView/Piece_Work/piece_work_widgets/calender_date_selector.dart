
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../controller/calendarEventsController.dart';
import '../../../../models/leaveAndHoliday_data_api_model.dart';
import '../../../../utils/color_utils.dart';
import '../../Employee_Leave/employee_leave_controller/employee_leave_controller.dart';
import '../piece_work_controller/piece_work_controller.dart';

class PieceWorkCalender extends StatefulWidget {
  final Function(DateTime)? selectedDate;
  const PieceWorkCalender({super.key, this.selectedDate});

  @override
  State<PieceWorkCalender> createState() => _PieceWorkCalenderState();
}

class _PieceWorkCalenderState extends State<PieceWorkCalender> {
  DateTime _focusedDay = DateTime.now();
  DateTime _startDate = DateTime(DateTime.now().year - 1, 1, 1);
  DateTime _endDate = DateTime(DateTime.now().year + 1, 12, 31);

  @override
  void initState() {
    final controller = Get.find<PieceWorkController>();
    _focusedDay = controller.dateList.value[controller.currentDateIndex.value];
    _startDate = controller.dateList.value.last;
    _endDate = controller.dateList.value.first;

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if(Get.find<CalendarEventController>().leaveCalenderLoaded.value) {
        setState(() {});
        timer.cancel();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorUtils.textWhite,
        borderRadius: BorderRadius.circular(18).r,
      ),
      child: TableCalendar(
        calendarBuilders: CalendarBuilders(
          // headerTitleBuilder: (BuildContext context, DateTime date) {
          //   return LeaveCalenderHeaderTitle(date: date);
          // },
          holidayBuilder: (BuildContext context, DateTime date, DateTime monthEnd) {
            if (date.weekday == DateTime.sunday && date.month == date.month && monthEnd.month == date.month) {
              return _CalendarDaysBuilder(date: date);
            } else {
              return _OutsideBuilder(date: date);
            }
          },
          dowBuilder: (BuildContext context, DateTime date) {
            if (date.weekday == DateTime.sunday) {
              return const _LeaveCalenderWeek(week: 'SUN');
            }

            if (date.weekday == DateTime.monday) {
              return const _LeaveCalenderWeek(week: 'MON');
            }

            if (date.weekday == DateTime.tuesday) {
              return const _LeaveCalenderWeek(week: 'TUE');
            }

            if (date.weekday == DateTime.wednesday) {
              return const _LeaveCalenderWeek(week: 'WED');
            }

            if (date.weekday == DateTime.thursday) {
              return const _LeaveCalenderWeek(week: 'THU');
            }

            if (date.weekday == DateTime.friday) {
              return const _LeaveCalenderWeek(week: 'FRI');
            }

            if (date.weekday == DateTime.saturday) {
              return const _LeaveCalenderWeek(week: 'SAT');
            }

            return null;
          },
          defaultBuilder: (BuildContext context, DateTime date, _) {
            return _CalendarDaysBuilder(date: date);
          },
          todayBuilder: (BuildContext context, DateTime date, _) {
            return _DefaultBuilder(date: date);
          },
          outsideBuilder: (BuildContext context, DateTime date, _) {
            return _OutsideBuilder(date: date);
          },
          singleMarkerBuilder: (context, date, event) {
            if (event is LeaveCalendarEvents?) {
              return GetX<EmployeeLeaveController>(
                builder: (EmployeeLeaveController controller) {
                  if(controller.calendarCurrentMonth.value.month == date.month) {
                    return Container(
                      width: 6.0,
                      height: 6.0,
                      margin: const EdgeInsets.symmetric(horizontal: 1.5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: event?.clEventType == LeaveClEventType.holiday
                            ? const Color(0xFFF8A24E)
                            : event?.clEventType == LeaveClEventType.requestedLeave
                            ? const Color(0xFF6A4BFC)
                            : Colors.grey,
                      ),
                    );
                  } else {
                    return SizedBox();
                  }
                },
              );
            }
            return const SizedBox();
          },
          selectedBuilder: (context, day, focusedDay) {
            return _DefaultBuilder(date: focusedDay);
          },
        ),
        eventLoader: (day) {
          return Get.find<CalendarEventController>().calEvents.value[day] ?? [];
        },
        holidayPredicate: (DateTime date) {
          return date.weekday == DateTime.sunday;
        },
        firstDay: _startDate,
        lastDay: _endDate,
        focusedDay: _focusedDay,
        onDaySelected: (selectedDay, focusedDay) {
          widget.selectedDate!(selectedDay);
        },
        calendarStyle: CalendarStyle(
          isTodayHighlighted: true,
          tablePadding: const EdgeInsets.all(8.0).h,
          rangeHighlightColor: ColorUtils.calenderDatesCircle.withValues(alpha: 0.2),
          // rangeHighlightScale: 5.0
        ),
        currentDay: _focusedDay,
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 15.h,
            fontWeight: FontWeight.w400,
            color: ColorUtils.workEntryHead,
          ),
          // headerMargin: EdgeInsets.only(right: 157.w),
          leftChevronIcon:
          const _ChevronIconLeft(chevronIcon: Icons.arrow_back_ios),
          rightChevronIcon:
          const _ChevronIconRight(chevronIcon: Icons.arrow_forward_ios),
        ),
        availableGestures: AvailableGestures.horizontalSwipe,
        rowHeight: 40.h,
        daysOfWeekHeight: 30.h,
        onPageChanged: (DateTime date) {},
      ),
    );
  }
}

class _OutsideBuilder extends StatelessWidget {
  final DateTime date;
  const _OutsideBuilder({required this.date});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 29.h,
        height: 29.h,
        decoration: BoxDecoration(
          color: ColorUtils.textWhite,
          borderRadius: BorderRadius.circular(50).r,
        ),
        child: Center(
          child: Text(
            '${date.day}',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 13.h,
                color: Colors.transparent
            ),
          ),
        ),
      ),
    );
  }
}

class _CalendarDaysBuilder extends StatelessWidget {
  final DateTime date;
  const _CalendarDaysBuilder({required this.date});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 29.h,
        height: 29.h,
        decoration: BoxDecoration(
          color: ColorUtils.textWhite,
          borderRadius: BorderRadius.circular(50).r,
        ),
        child: Center(
          child: Text(
            '${date.day}',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 13.h,
              color: ColorUtils.workEntryHead,
            ),
          ),
        ),
      ),
    );
  }
}

class _LeaveCalenderWeek extends StatelessWidget {
  final String week;
  const _LeaveCalenderWeek({required this.week});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          week,
          style: GoogleFonts.inter(
            color: const Color(0xFFB5BEC6),
            fontWeight: FontWeight.w500,
            fontSize: 11.h,
          ),
        ),
      ],
    );
  }
}

class _DefaultBuilder extends StatelessWidget {
  final DateTime date;
  const _DefaultBuilder({required this.date});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 29.h,
        height: 29.h,
        decoration: BoxDecoration(
          color: ColorUtils.calenderDatesCircle,
          borderRadius: BorderRadius.circular(50).r,
        ),
        child: Center(
          child: Text(
            '${date.day}',
            style: GoogleFonts.poppins(
              color: ColorUtils.textWhite,
              fontWeight: FontWeight.w500,
              fontSize: 13.h,
            ),
          ),
        ),
      ),
    );
  }
}

class _ChevronIconLeft extends StatelessWidget {
  final IconData chevronIcon;
  const _ChevronIconLeft({required this.chevronIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 33.h,
      width: 33.h,
      decoration: BoxDecoration(
          color: ColorUtils.paleLavenderMist,
          borderRadius: BorderRadius.circular(100).h),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 5).h,
          child: Icon(
            chevronIcon,
            size: 13.h,
            color: ColorUtils.workEntryHead,
          ),
        ),
      ),
    );
  }
}

class _ChevronIconRight extends StatelessWidget {
  final IconData chevronIcon;
  const _ChevronIconRight({required this.chevronIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 33.h,
      width: 33.h,
      decoration: BoxDecoration(
          color: ColorUtils.paleLavenderMist,
          borderRadius: BorderRadius.circular(100).h),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 2).h,
          child: Icon(
            chevronIcon,
            size: 13.h,
            color: ColorUtils.workEntryHead,
          ),
        ),
      ),
    );
  }
}