
import 'dart:async';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loyaltri_minimal/View/Leave_Page/leave_widgets/leave_calender.dart';
import 'package:loyaltri_minimal/controller/calendarEventsController.dart';
import '../../../../controller/leaveTypeController.dart';
import '../../../../models/leaveAndHoliday_data_api_model.dart';
import '../../../../models/leave_type_api_model.dart';
import '../../../../models/manager/all_employee_list.dart';
import '../../../../services/ui_model_services/leave_dates_model.dart';
import '../../../../utils/color_utils.dart';
import '../../../../utils/event.dart';
import 'dart:collection';
import 'package:table_calendar/table_calendar.dart';
import '../../../CWidgets/app_bar.dart';
import '../../../CWidgets/loyaltri_blue_text_button.dart';
import '../../Manager_Attendance/manager_attendance_controller/manager_attendance_controller.dart';
import '../../Manager_Employee/employee_page_controller/employee_page_controller.dart';
import '../employee_leave_controller/employee_leave_controller.dart';

class ChooseDatesManager extends StatefulWidget {
  final LeaveType? leaveType;
  const ChooseDatesManager({super.key, this.leaveType});

  @override
  State<ChooseDatesManager> createState() => _ChooseDatesManagerState();
}

class _ChooseDatesManagerState extends State<ChooseDatesManager> {
  ValueNotifier<List<DateTime>> availableDays = ValueNotifier([]);
  ValueNotifier<DateTime?> leaveStart = ValueNotifier(null);
  ValueNotifier<DateTime?> leaveEnd = ValueNotifier(null);
  ValueNotifier<String?> month = ValueNotifier(null);
  ValueNotifier<DateTime> currentDate = ValueNotifier(DateTime.now());
  final _toggleController = ValueNotifier<bool>(false);
  ValueNotifier<bool> _toggValue = ValueNotifier<bool>(false);
  ValueNotifier<bool> _halfDayTime = ValueNotifier<bool>(false);
  ValueNotifier<TimeState?> selectedHour = ValueNotifier(null);
  CalendarEventController calendarEventController = Get.find<CalendarEventController>();
  Map<DateTime, List<LeaveCalendarEvents>> evMap = {};
  List<int> leaveHours = [];

  var calEvents = LinkedHashMap<DateTime, List<LeaveCalendarEvents>>(
    equals: isSameDay,
    hashCode: getHashCode,
  );

  @override
  void initState() {
    super.initState();
    initialize();
    _calculateAvailableDays();
  }

  Future<void> initialize() async {
    context.loaderOverlay.show();
    try {
      leaveHours = List.generate(int.parse(widget.leaveType?.totalLeave ?? '0'), (index) => index + 1);
    } catch(e) {}
    await calendarEventController.fetchCalendarEventsForLeave();
    if(!mounted) return;
    context.loaderOverlay.hide();
  }

  void _calculateAvailableDays() {
    availableDays.value = [];
    DateTime now = currentDate.value;
    month.value = DateFormat('MMMM').format(now);
    DateTime endOfMonth = DateTime(now.year, now.month + 1, 0);
    for (int i = now.day; i <= endOfMonth.day; i++) {
      DateTime currentDate = DateTime(now.year, now.month, i);
      if (currentDate.weekday != DateTime.sunday) {
        availableDays.value.add(currentDate);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      left: false,
      right: false,
      child: Scaffold(
        backgroundColor: ColorUtils.textWhite,
        extendBody: true,
        body: Stack(
          children: [
            Container(
              height: ScreenUtil().screenHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    ColorUtils.lavenderPurple,
                    ColorUtils.lavenderMist,
                    Color(0xFFF2F2F2),
                    Color(0xFFF2F2F2),
                    Color(0xFFF2F2F2),
                    Color(0xFFF2F2F2),
                    Color(0xFFF2F2F2),
                    Color(0xFFF2F2F2),
                    ColorUtils.whiteSmoke,
                    ColorUtils.whiteSmoke,
                    ColorUtils.whiteSmoke,
                    ColorUtils.whiteSmoke,
                    ColorUtils.whiteSmoke,
                    ColorUtils.whiteSmoke,
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 8).h,
                child: Container(
                  width: ScreenUtil().screenWidth,
                  height: ScreenUtil().screenHeight,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 80).h,
                    physics: const NeverScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.h,
                          ),
                          child: const _CustomAppBar(
                            title: "Employee Leave",
                            image: "assets/images/manager_view/employee_leave_calendar.png",
                          ),
                        ),
                        Container(
                          height: ScreenUtil().screenHeight,
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.only(bottom: 300).h,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 10.h,
                                    horizontal: 18.h,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "From",
                                            style: GoogleFonts.poppins(
                                              color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 11.h,
                                            ),
                                          ),
                                          ValueListenableBuilder(
                                            valueListenable: leaveStart,
                                            builder: (BuildContext context, value, Widget? child) {
                                              if (value != null) {
                                                return Row(
                                                  children: [
                                                    Text(
                                                      DateFormat('dd').format(value),
                                                      style: GoogleFonts.poppins(
                                                        color: ColorUtils.workEntryHead,
                                                        fontWeight: FontWeight.w700,
                                                        fontSize: 15.h,
                                                      ),
                                                    ),
                                                    Text(
                                                      " ${DateFormat('MMM | E').format(value)}",
                                                      style: GoogleFonts.poppins(
                                                        color: ColorUtils.workEntryHead,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 15.h,
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              } else {
                                                return Text(
                                                  "____",
                                                  style: GoogleFonts.poppins(
                                                    color: ColorUtils.workEntryHead,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 15.h,
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "-",
                                            style: GoogleFonts.poppins(
                                              color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                                              fontWeight: FontWeight.w700,
                                              fontSize: 15.h,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "To",
                                            style: GoogleFonts.poppins(
                                              color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 11.h,
                                            ),
                                          ),
                                          ValueListenableBuilder(
                                            valueListenable: leaveEnd,
                                            builder: (BuildContext context, value, Widget? child) {
                                              if (value != null) {
                                                return Row(
                                                  children: [
                                                    Text(
                                                      DateFormat('dd').format(value),
                                                      style: GoogleFonts.poppins(
                                                        color: ColorUtils.workEntryHead,
                                                        fontWeight: FontWeight.w700,
                                                        fontSize: 15.h,
                                                      ),
                                                    ),
                                                    Text(
                                                      " ${DateFormat('MMM | E').format(value)}",
                                                      style: GoogleFonts.poppins(
                                                        color: ColorUtils.workEntryHead,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 15.h,
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              } else {
                                                return ValueListenableBuilder(
                                                  valueListenable: leaveStart,
                                                  builder: (BuildContext context, value, Widget? child) {
                                                    if (value != null) {
                                                      return Row(
                                                        children: [
                                                          Text(
                                                            DateFormat('dd').format(value),
                                                            style: GoogleFonts.poppins(
                                                              color: ColorUtils.workEntryHead,
                                                              fontWeight: FontWeight.w700,
                                                              fontSize: 15.h,
                                                            ),
                                                          ),
                                                          Text(
                                                            " ${DateFormat('MMM | E').format(value)}",
                                                            style: GoogleFonts.poppins(
                                                              color: ColorUtils.workEntryHead,
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: 15.h,
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    } else {
                                                      return Text(
                                                        "____",
                                                        style: GoogleFonts.poppins(
                                                          color: ColorUtils.workEntryHead,
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 15.h,
                                                        ),
                                                      );
                                                    }
                                                  },
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                if(widget.leaveType?.isHourBased == '1')
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 10.h),
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(width: 17.h),
                                            Text(
                                              'Hour*',
                                              style: GoogleFonts.poppins(
                                                color: ColorUtils.workEntryHead,
                                                fontSize: 12.h,
                                              ),
                                            ),
                                          ],
                                        ),
                                        ValueListenableBuilder(
                                            valueListenable: selectedHour,
                                            builder: (BuildContext context, value, Widget? child) {
                                              return DropdownButtonHideUnderline(
                                                child: DropdownButton2<int>(
                                                  isExpanded: true,
                                                  value: value?.hour,
                                                  hint: Text(
                                                    'Select Hour*',
                                                    style: GoogleFonts.poppins(
                                                      color: (value?.isSelected ?? true) ? ColorUtils.workEntryHead.withValues(alpha: 0.5) : ColorUtils.alertRed.withValues(alpha: 0.5),
                                                      fontSize: 12.h,
                                                    ),
                                                  ),

                                                  items: leaveHours.map((hour) {
                                                    return DropdownMenuItem<int>(
                                                      value: hour,
                                                      child: Text(
                                                        '$hour',
                                                        overflow: TextOverflow.ellipsis,
                                                        style: GoogleFonts.poppins(
                                                          fontSize: 13.h,
                                                          color: ColorUtils.workEntryHead,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),

                                                  onChanged: (value) async {
                                                    selectedHour.value = TimeState(
                                                      isSelected: true,
                                                      hour: value,
                                                    );
                                                  },

                                                  iconStyleData: IconStyleData(
                                                    icon: Image.asset(
                                                      'assets/images/growth/arrow-down.png',
                                                      height: 5.h,
                                                      fit: BoxFit.fitHeight,
                                                      color: (value?.isSelected ?? true) ? const Color(0xFF9A9A9A) : ColorUtils.alertRed,
                                                    ),
                                                  ),

                                                  buttonStyleData: ButtonStyleData(
                                                    padding: EdgeInsets.only(right: 16.h),
                                                    decoration: BoxDecoration(
                                                      color: Colors.transparent,
                                                    ),
                                                  ),

                                                  dropdownStyleData: DropdownStyleData(
                                                      maxHeight: ScreenUtil().screenHeight * 0.6,
                                                      useSafeArea: true,
                                                      decoration: BoxDecoration(
                                                        color: ColorUtils.textWhite,
                                                        borderRadius: BorderRadius.circular(15.r),
                                                      )
                                                  ),

                                                  menuItemStyleData: MenuItemStyleData(
                                                    height: 40.h,
                                                  ),
                                                  onMenuStateChange: (isOpen) {

                                                  },
                                                ),
                                              );
                                            }
                                        ),
                                      ],
                                    ),
                                  )
                                else
                                  Padding(
                                  padding: EdgeInsets.symmetric(
                                    // vertical: 10.h,
                                    horizontal: 10.h,
                                  ),
                                  child: ValueListenableBuilder(
                                    valueListenable: leaveEnd,
                                    builder: (BuildContext context, value, Widget? child) {
                                      if (value == null) {
                                        return Padding(
                                          padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5).h,
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  AdvancedSwitch(
                                                    controller: _toggleController,
                                                    height: 24.h,
                                                    width: 39.h,
                                                    activeColor: ColorUtils.secondaryBlue,
                                                    inactiveColor: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                                                    onChanged: (value) {
                                                      _toggValue.value = value;
                                                    },
                                                  ),
                                                  SizedBox(width: 5.h),
                                                  Text(
                                                    "Half Day",
                                                    style: GoogleFonts.inter(
                                                      color: ColorUtils.workEntryHead,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 12.h,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              ValueListenableBuilder(
                                                valueListenable: _toggValue,
                                                builder: (BuildContext context, value, Widget? child) {
                                                  if(value) {
                                                    return ValueListenableBuilder(
                                                      valueListenable: _halfDayTime,
                                                      builder: (BuildContext context, value2, Widget? child) {
                                                        return Row(
                                                          children: [
                                                            Radio(
                                                              value: value,
                                                              groupValue: !value2,
                                                              onChanged: (changedValue) {
                                                                _halfDayTime.value = !_halfDayTime.value;
                                                              },
                                                            ),
                                                            Text(
                                                              "First Half",
                                                              style: GoogleFonts.inter(
                                                                color: ColorUtils.workEntryHead,
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: 12.h,
                                                              ),
                                                            ),
                                                            SizedBox(width: 10.h),
                                                            Radio(
                                                              value: value,
                                                              groupValue: value2,
                                                              onChanged: (changedValue) {
                                                                _halfDayTime.value = !_halfDayTime.value;
                                                              },
                                                            ),
                                                            Text(
                                                              "Second Half",
                                                              style: GoogleFonts.inter(
                                                                color: ColorUtils.workEntryHead,
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: 12.h,
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  } else {
                                                    return Container();
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        return Container();
                                      }
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 10.h,
                                    horizontal: 15.h,
                                  ),
                                  child: LeaveCalender(
                                    isRangeSelection: widget.leaveType?.isHourBased != '1',
                                    leaveDates: (LeaveDates leaveDays) {
                                      leaveStart.value = leaveDays.startDate;
                                      leaveEnd.value = leaveDays.endDate;
                                      if(leaveEnd.value != null && _toggValue.value) {
                                        _toggValue.value = false;
                                      }
                                      if(widget.leaveType?.isHourBased == '1') {
                                        selectedHour.value = null;
                                      }
                                    },
                                    onMonthChange: (DateTime date) {
                                      currentDate.value = date;
                                      _calculateAvailableDays();
                                    },
                                  ),
                                ),
                                if(widget.leaveType?.leaveBalance != null && widget.leaveType?.leaveType?.trim().toLowerCase() != 'lop' && widget.leaveType?.leaveType?.trim().toLowerCase() != 'unlimited')
                                  Padding(
                                  padding: const EdgeInsets.all(10.0).h,
                                  child: Container(
                                    width: ScreenUtil().screenWidth,
                                    // height: 70.w,
                                    decoration: BoxDecoration(
                                      color: ColorUtils.textWhite,
                                      borderRadius: BorderRadius.circular(12).r,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0).h,
                                      child: ValueListenableBuilder(
                                        valueListenable: month,
                                        builder: (BuildContext context, value, Widget? child) {
                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/images/Info.svg",
                                                    colorFilter: ColorFilter.mode(ColorUtils.workEntryHead, BlendMode.srcIn),
                                                  ),
                                                  SizedBox(width: 4.h),
                                                  Text(
                                                    "${widget.leaveType?.leaveType} balance: ${widget.leaveType?.leaveBalance ?? '--'}",
                                                    style: GoogleFonts.inter(
                                                      color: ColorUtils.workEntryHead.withValues(alpha: 0.8),
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 13.h,
                                                    ),
                                                  ),
                                                  // Text(
                                                  //   "${availableDays.value.length} working days",
                                                  //   style: GoogleFonts.inter(
                                                  //     color: ColorUtils.workEntryHead.withValues(alpha: 0.8),
                                                  //     fontWeight: FontWeight.w500,
                                                  //     fontSize: 13.h,
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                              // SizedBox(height: 4.w),
                                              // Text(
                                              //   "You have ${availableDays.value.length} working days available for leave period ending on ${value ?? ""}",
                                              //   style: GoogleFonts.poppins(
                                              //     color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                                              //     fontWeight: FontWeight.w400,
                                              //     fontSize: 11.h,
                                              //   ),
                                              // ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0).h,
                                  child: Row(
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 10.h,
                                            height: 10.h,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(50).r,
                                              color: const Color(0xFF6A4BFC),
                                            ),
                                          ),
                                          SizedBox(width: 4.h),
                                          Text(
                                            "Leave Requested",
                                            style: GoogleFonts.poppins(
                                              color: ColorUtils.workEntryHead,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 11.h,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 10.h,
                                            height: 10.h,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(50).r,
                                              color: const Color(0xFFF8A24E),
                                            ),
                                          ),
                                          SizedBox(width: 4.w),
                                          Text(
                                            "Holiday",
                                            style: GoogleFonts.poppins(
                                              color: ColorUtils.workEntryHead,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 11.h,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(flex: 3),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          width: ScreenUtil().screenWidth,
          height: 70.h,
          // decoration: blueTextButtonDecoration,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20).h,
                child: GestureDetector(
                  onTap: () {
                    if(widget.leaveType?.isHourBased == '1' && leaveStart.value != null && selectedHour.value?.hour == null) {
                      selectedHour.value = TimeState(isSelected: false);
                      return;
                    }
                    if (leaveStart.value != null && leaveEnd.value != null) {
                      Navigator.pop(
                        context,
                        LeaveDates(
                          startDate: leaveStart.value,
                          endDate: leaveEnd.value,
                          isHalfDay: _toggValue.value ? 1 : 0,
                          leaveSection: _toggValue.value ? _halfDayTime.value ? "secondHalf" : "firstHalf" : "",
                            hour: selectedHour.value?.hour
                        ),
                      );
                    } else if (leaveStart.value != null && leaveEnd.value == null) {
                      Navigator.pop(
                        context,
                        LeaveDates(
                          startDate: leaveStart.value,
                          endDate: leaveStart.value,
                          isHalfDay: _toggValue.value ? 1 : 0,
                          leaveSection: _toggValue.value ? _halfDayTime.value ? "secondHalf" : "firstHalf" : "",
                            hour: selectedHour.value?.hour
                        ),
                      );
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: const LoyaltriBlueIconTextButton(
                    text: 'Save Date Range',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  final String? image;
  final String title;
  const _CustomAppBar({required this.title, this.image});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0).w,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14).w,
            child: Material(
              color: ColorUtils.foregroundBlack,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: 48.h,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: ColorUtils.textWhite,
                    borderRadius: BorderRadius.circular(14).r,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5).h,
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: ColorUtils.workEntryHead,
                        size: 15.h,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (image != null)
            const Spacer(flex: 5),
          if (image == null)
            const Spacer(flex: 6),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (image != null)
                Image.asset(
                  image!,
                  height: 25.h,
                ),
              if (image != null)
                SizedBox(width: 10.h),
              Text(
                title,
                style: GoogleFonts.dmSans(
                  color: ColorUtils.workEntryHead,
                  fontWeight: FontWeight.w500,
                  fontSize: 15.h,
                ),
              ),
            ],
          ),
          const Spacer(flex: 10),
        ],
      ),
    );
  }
}

class LeaveCalender extends StatefulWidget {
  final Function(LeaveDates)? leaveDates;
  final Function(DateTime)? onMonthChange;
  final bool isRangeSelection;
  const LeaveCalender({super.key, this.leaveDates, this.onMonthChange, this.isRangeSelection = true});

  @override
  State<LeaveCalender> createState() => _LeaveCalenderState();
}

class _LeaveCalenderState extends State<LeaveCalender> {
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  DateTime _focusedDay = DateTime.now();

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime  focusDay) {
    if (!widget.isRangeSelection) return;
    setState(() {
      _rangeStart = start;
      _rangeEnd = end;
      if (end == null) {
        _focusedDay = start!;
      } else {
        _focusedDay = end;
      }
    });
    widget.leaveDates!(LeaveDates(startDate: start, endDate: end));
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
          // todayBuilder: (BuildContext context, DateTime date, _) {
          //   return DefaultBuilder(date: date);
          // },
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
            return _DefaultBuilder(date: date);
          },
          rangeEndBuilder: (BuildContext context, DateTime date, _) {
            return _DefaultBuilder(date: date);
          },
          withinRangeBuilder: (BuildContext context, DateTime date, _) {
            return Center(
              child: Container(
                width: 29.h,
                height: 29.h,
                decoration: BoxDecoration(
                  color: Colors.transparent,
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
        firstDay: DateTime(DateTime.now().year - 1, 1, 1),
        focusedDay: _focusedDay,
        lastDay: DateTime(DateTime.now().year + 1, 12, 31),
        onRangeSelected: widget.isRangeSelection ? _onRangeSelected : null,
        onDaySelected: widget.isRangeSelection ? null : _onDaySelected,
        selectedDayPredicate: (day) => !widget.isRangeSelection && _rangeStart != null && isSameDay(_rangeStart, day),
        rangeStartDay: widget.isRangeSelection ? _rangeStart : null,
        rangeEndDay: widget.isRangeSelection ? _rangeEnd : null,
        rangeSelectionMode: widget.isRangeSelection
            ? RangeSelectionMode.toggledOn
            : RangeSelectionMode.disabled,
        calendarStyle: CalendarStyle(
          isTodayHighlighted: false,
          tablePadding: const EdgeInsets.all(8.0).h,
          rangeHighlightColor: ColorUtils.calenderDatesCircle.withValues(alpha: 0.2),
          // rangeHighlightScale: 5.0
        ),
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
        onPageChanged: (DateTime date) async {
          Get.find<EmployeeLeaveController>().calendarCurrentMonth.value = date;
          widget.onMonthChange!(date);
          String? empId = Get.find<EmployeeLeaveController>().selectedEmployeeId.value;
          CompanyEmployeeData? employee = Get.find<ManagerEmployeeController>().allEmployeesCopy.value.firstWhereOrNull((element) => element.employeeId == empId);
          if(employee != null) {
            context.loaderOverlay.show();
            String formatted = DateFormat('yyyy-MM').format(date);
            await Get.find<LeaveTypeController>().fetchLeaveType(
              empId: employee.employeeId ?? '',
              compId: employee.companyId ?? '',
              monthYear: formatted
            );
            context.loaderOverlay.hide();
          }
        },
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

