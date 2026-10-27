import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loyaltri_minimal/View/Home_Page/home_widgets/calender_chevron.dart';
import 'package:loyaltri_minimal/View/Home_Page/home_widgets/calender_default.dart';
import 'package:loyaltri_minimal/View/Home_Page/home_widgets/calender_outside.dart';
import 'package:loyaltri_minimal/View/Home_Page/home_widgets/calender_weaks.dart';
import 'package:loyaltri_minimal/controller/leaveTypeController.dart';
import 'package:loyaltri_minimal/controller/ui_controller/home_controller.dart';
import 'package:loyaltri_minimal/controller/ui_controller/page_controller.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../controller/calendarEventsController.dart';
import '../../../controller/userProfileController.dart';
import '../../../models/leaveAndHoliday_data_api_model.dart';
import '../../../services/ui_model_services/leave_dates_model.dart';
import '../../../utils/color_utils.dart';
import '../../ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';

class LeaveCalender extends StatefulWidget {
  final Function(LeaveDates)? leaveDates;
  final Function(DateTime)? onMonthChange;
  final LeaveDates? selectedDates;
  final bool isRangeSelection;
  final bool fetchLeaveTypes;
  final bool showFutureDates;
  final String? date;
  final bool? highlightToday;
  const LeaveCalender({
    super.key,
    this.leaveDates,
    this.onMonthChange,
    this.selectedDates,
    this.isRangeSelection = true,
    this.fetchLeaveTypes = false,
    this.showFutureDates = true,
    this.date,
    this.highlightToday,
  });

  @override
  State<LeaveCalender> createState() => _LeaveCalenderState();
}

class _LeaveCalenderState extends State<LeaveCalender> {
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  DateTime _focusedDay = DateTime.now();
  bool isDark = Get.find<UserPageController>().appView.value == AppView.employee;

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusDay) {
    if (!widget.isRangeSelection) return;
    setState(() {
      _rangeStart = start;
      _rangeEnd = end;
      _focusedDay = end ?? start!;
    });
    widget.leaveDates?.call(LeaveDates(startDate: start, endDate: end));
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusDay) {
    if (widget.isRangeSelection) return;
    setState(() {
      _rangeStart = selectedDay;
      _rangeEnd = null;
      _focusedDay = selectedDay;
    });
    widget.leaveDates?.call(LeaveDates(startDate: _rangeStart, endDate: _rangeStart));
  }

  @override
  void initState() {
    if (widget.date != null) {
      _focusedDay = DateFormat('yyyy-MM').parse(widget.date!);
    }
    if(widget.selectedDates != null) {
      _rangeStart = widget.selectedDates?.startDate;
      _rangeEnd = widget.selectedDates?.endDate;
    }
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
        color: isDark ? ColorUtils.backgroundBlack : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(18).w,
      ),
      child: Column(
        children: [
          TableCalendar(
            calendarBuilders: CalendarBuilders(
              // headerTitleBuilder: (BuildContext context, DateTime date) {
              //   return LeaveCalenderHeaderTitle(date: date);
              // },
              holidayBuilder: (BuildContext context, DateTime date, _) {
                if (date.weekday == DateTime.sunday && date.month == date.month) {
                  return OutsideBuilder(date: date);
                } else {
                  return null;
                }
              },
              dowBuilder: (BuildContext context, DateTime date) {
                if (date.weekday == DateTime.sunday) {
                  return LeaveCalenderWeek(week: 'SUN', isDark: isDark);
                }

                if (date.weekday == DateTime.monday) {
                  return LeaveCalenderWeek(week: 'MON', isDark: isDark);
                }

                if (date.weekday == DateTime.tuesday) {
                  return LeaveCalenderWeek(week: 'TUE', isDark: isDark);
                }

                if (date.weekday == DateTime.wednesday) {
                  return LeaveCalenderWeek(week: 'WED', isDark: isDark);
                }

                if (date.weekday == DateTime.thursday) {
                  return LeaveCalenderWeek(week: 'THU', isDark: isDark);
                }

                if (date.weekday == DateTime.friday) {
                  return LeaveCalenderWeek(week: 'FRI', isDark: isDark);
                }

                if (date.weekday == DateTime.saturday) {
                  return LeaveCalenderWeek(week: 'SAT', isDark: isDark);
                }

                return null;
              },
              disabledBuilder: (context, date, focusedDay) {
                return InkWell(
                  onTap: () {
                    final today = DateTime.now();

                    final todayDate = DateTime(
                      today.year,
                      today.month,
                      today.day,
                    );

                    final selectedDate = DateTime(
                      date.year,
                      date.month,
                      date.day,
                    );

                    if (selectedDate.isAfter(todayDate)) {
                      AttendanceCommonWidgets().showSnackBar(
                        context: context,
                        backgroundColor: Colors.red,
                        message: 'Future dates cannot be selected.',
                      );
                    }
                  },
                    child: OutsideBuilder(date: date),
                );
              },
              defaultBuilder: (BuildContext context, DateTime date, _) {
                return OutsideBuilder(date: date);
              },
              todayBuilder: (BuildContext context, DateTime date, _) {
                if (widget.highlightToday ?? false) {
                  return Center(
                    child: Container(
                      width: 29.w,
                      height: 29.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50).r,
                        border: Border.all(color: ColorUtils.secondaryBlue)
                      ),
                      child: Center(
                        child: Text(
                          '${date.day}',
                          style: GoogleFonts.poppins(
                            color: ColorUtils.textWhite,
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return null;
              },
              outsideBuilder: (BuildContext context, DateTime date, _) {
                return OutsideBuilder(date: date);
              },
              singleMarkerBuilder: (context, date, event) {
                if (event is LeaveCalendarEvents?) {
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
                }
                return const SizedBox();
              },
              // markerBuilder: (BuildContext context, DateTime date, _) {
              //   if (date.day == 6 ||
              //       date.day == 14 ||
              //       date.day == 16 ||
              //       date.day == 18 ||
              //       date.day == 28) {
              //     return CalenderMarkerBuilder(date: date);
              //   }
              //   return null;
              // },
              rangeStartBuilder: (BuildContext context, DateTime date, _) {
                return DefaultBuilder(date: date);
              },
              rangeEndBuilder: (BuildContext context, DateTime date, _) {
                return DefaultBuilder(date: date);
              },
              withinRangeBuilder: (BuildContext context, DateTime date, _) {
                return Center(
                  child: Container(
                    width: 29.w,
                    height: 29.w,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(50).w,
                    ),
                    child: Center(
                      child: Text(
                        '${date.day}',
                        style: GoogleFonts.poppins(
                          color: ColorUtils.textWhite,
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ),
                );
              },
              // rangeHighlightBuilder: (BuildContext context, DateTime date, _) {
              //   return DefaultBuilder(date: date);
              // },
            ),
            eventLoader: (day) {
              return Get.find<CalendarEventController>().calEvents.value[day] ?? [];
            },
            holidayPredicate: (DateTime date) {
              return date.weekday == DateTime.sunday;
            },
            firstDay: DateTime(DateTime.now().year - 50, 1, 1),
            focusedDay: _focusedDay,
            lastDay: widget.showFutureDates ? DateTime(DateTime.now().year + 50, 12, 31) : DateTime.now(),
            onRangeSelected: widget.isRangeSelection ? _onRangeSelected : null,
            // onDaySelected: widget.isRangeSelection ? null : _onDaySelected,
            onDaySelected: widget.isRangeSelection ? null : (selectedDay, focusedDay) {
              if(!widget.showFutureDates) {
                final today = DateTime.now();

                final todayDate = DateTime(
                  today.year,
                  today.month,
                  today.day,
                );

                final selectedDate = DateTime(
                  selectedDay.year,
                  selectedDay.month,
                  selectedDay.day,
                );

                if (selectedDate.isAfter(todayDate)) {
                  return;
                }
              }

              _onDaySelected(selectedDay, focusedDay);
            },
            selectedDayPredicate: (day) => !widget.isRangeSelection && _rangeStart != null && isSameDay(_rangeStart, day),
            rangeStartDay: widget.isRangeSelection ? _rangeStart : null,
            rangeEndDay: widget.isRangeSelection ? _rangeEnd : null,
            rangeSelectionMode: widget.isRangeSelection
                ? RangeSelectionMode.toggledOn
                : RangeSelectionMode.disabled,
            calendarStyle: CalendarStyle(
              isTodayHighlighted: widget.highlightToday ?? false,
              tablePadding: const EdgeInsets.all(8.0).w,
              rangeHighlightColor: ColorUtils.calenderDatesCircle.withOpacity(0.2),
              // rangeHighlightScale: 5.0
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: isDark ? ColorUtils.textWhite : ColorUtils.workEntryHead,
              ),
              // headerMargin: EdgeInsets.only(right: 157.w),
              leftChevronIcon:
              const ChevronIconLeft(chevronIcon: Icons.arrow_back_ios),
              rightChevronIcon:
              const ChevronIconRight(chevronIcon: Icons.arrow_forward_ios),
            ),
            availableGestures: AvailableGestures.horizontalSwipe,
            rowHeight: 40.w,
            daysOfWeekHeight: 30.w,
            onPageChanged: (DateTime date) async {
              widget.onMonthChange!(date);
              if(widget.fetchLeaveTypes) {
                context.loaderOverlay.show();
                String formatted = DateFormat('yyyy-MM').format(date);
                await Get.find<LeaveTypeController>().fetchLeaveType(
                  compId:
                  Get.find<UserProfileController>().userData.value.result.companyId
                      ?.toString() ??
                      '',
                  empId:
                  Get.find<UserProfileController>().userData.value.result.employeeId.toString() ??
                      '--',
                  monthYear: formatted
                );
                context.loaderOverlay.hide();
              }
            },
          ),
          if(!isDark)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: SizedBox(
                        width: 80.h,
                        height: 20.h,
                        child: Center(
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              fontSize: 14.h,
                              color: ColorUtils.workEntryHead,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 0.5.h,
                      height: 15.h,
                      color: Color(0xFF565656).withValues(alpha: 0.2),
                    ),
                    InkWell(
                      onTap: () {
                        widget.leaveDates?.call(LeaveDates(startDate: _rangeStart, endDate: null));
                        Navigator.of(context).pop();
                      },
                      child: SizedBox(
                        width: 80.h,
                        height: 20.h,
                        child: Center(
                          child: Text(
                            "Ok",
                            style: TextStyle(
                              fontSize: 14.h,
                              color: ColorUtils.workEntryHead,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
              ],
            ),
        ],
      ),
    );
  }
}