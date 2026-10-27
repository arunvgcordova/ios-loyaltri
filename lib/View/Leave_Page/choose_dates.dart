
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
import '../../models/leaveAndHoliday_data_api_model.dart';
import '../../models/leave_type_api_model.dart';
import '../../services/ui_model_services/leave_dates_model.dart';
import '../../utils/color_utils.dart';
import '../../utils/event.dart';
import '../CWidgets/app_bar.dart';
import '../CWidgets/loyaltri_blue_text_button.dart';
import 'dart:collection';
import 'package:table_calendar/table_calendar.dart';

class ChooseDates extends StatefulWidget {
  final LeaveType? leaveType;
  final String? date;
  const ChooseDates({super.key, this.leaveType, this.date});

  @override
  State<ChooseDates> createState() => _ChooseDatesState();
}

class _ChooseDatesState extends State<ChooseDates> {
  ValueNotifier<List<DateTime>> availableDays = ValueNotifier([]);
  ValueNotifier<DateTime?> leaveStart = ValueNotifier(null);
  ValueNotifier<DateTime?> leaveEnd = ValueNotifier(null);
  ValueNotifier<TimeState?> selectedHour = ValueNotifier(null);
  ValueNotifier<String?> month = ValueNotifier(null);
  ValueNotifier<DateTime> currentDate = ValueNotifier(DateTime.now());
  final _toggleController = ValueNotifier<bool>(false);
  ValueNotifier<bool> _toggValue = ValueNotifier<bool>(false);
  ValueNotifier<bool> _halfDayTime = ValueNotifier<bool>(false);
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
      int balance = int.parse(widget.leaveType?.leaveBalance ?? '0') > 23 ? 23 : int.parse(widget.leaveType?.leaveBalance ?? '0');
      leaveHours = List.generate(balance, (index) => index + 1);
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
      child: Scaffold(
        backgroundColor: ColorUtils.workEntryHead,
        extendBody: true,
        body: Padding(
          padding: const EdgeInsets.only(top: 8).w,
          child: Container(
            width: ScreenUtil().screenWidth,
            height: ScreenUtil().screenHeight,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 80).w,
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  const CustomAppBar(
                    title: "Choose Date",
                    isActionVisible: true,
                    image: "assets/images/leave-calendar3d.webp",
                  ),
                  Container(
                    height: ScreenUtil().screenHeight,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 300).w,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10).w,
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
                                        color: ColorUtils.textWhite.withOpacity(0.5),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12.sp,
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
                                                  color: ColorUtils.textWhite,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16.sp,
                                                ),
                                              ),
                                              Text(
                                                " ${DateFormat('MMM | E').format(value)}",
                                                style: GoogleFonts.poppins(
                                                  color: ColorUtils.textWhite,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16.sp,
                                                ),
                                              ),
                                            ],
                                          );
                                        } else {
                                          return Text(
                                            "____",
                                            style: GoogleFonts.poppins(
                                              color: ColorUtils.textWhite,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16.sp,
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
                                        color: ColorUtils.textWhite.withOpacity(0.5),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16.sp,
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
                                        color: ColorUtils.textWhite.withOpacity(0.5),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12.sp,
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
                                                  color: ColorUtils.textWhite,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16.sp,
                                                ),
                                              ),
                                              Text(
                                                " ${DateFormat('MMM | E').format(value)}",
                                                style: GoogleFonts.poppins(
                                                  color: ColorUtils.textWhite,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16.sp,
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
                                                        color: ColorUtils.textWhite,
                                                        fontWeight: FontWeight.w700,
                                                        fontSize: 16.sp,
                                                      ),
                                                    ),
                                                    Text(
                                                      " ${DateFormat('MMM | E').format(value)}",
                                                      style: GoogleFonts.poppins(
                                                        color: ColorUtils.textWhite,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 16.sp,
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              } else {
                                                return Text(
                                                  "____",
                                                  style: GoogleFonts.poppins(
                                                    color: ColorUtils.textWhite,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16.sp,
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
                                color: ColorUtils.workEntryHead,
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
                                          color: ColorUtils.textWhite,
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
                                              color: (value?.isSelected ?? true) ? ColorUtils.textWhite.withValues(alpha: 0.5) : ColorUtils.alertRed.withValues(alpha: 0.5),
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
                                                  color: ColorUtils.textWhite,
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
                                              color: ColorUtils.workEntryHead,
                                            ),
                                          ),

                                          dropdownStyleData: DropdownStyleData(
                                            maxHeight: ScreenUtil().screenHeight * 0.6,
                                            useSafeArea: true,
                                            decoration: BoxDecoration(
                                              color: ColorUtils.datePickColor,
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
                            ValueListenableBuilder(
                              valueListenable: leaveEnd,
                              builder: (BuildContext context, value, Widget? child) {
                                if (value == null) {
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5).w,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            AdvancedSwitch(
                                              controller: _toggleController,
                                              height: 24.w,
                                              width: 39.w,
                                              activeColor: ColorUtils.secondaryBlue,
                                              inactiveColor: ColorUtils.toggleInactive,
                                              onChanged: (value) {
                                                _toggValue.value = value;
                                              },
                                            ),
                                            SizedBox(width: 5.w),
                                            Text(
                                              "Half Day",
                                              style: GoogleFonts.inter(
                                                color: ColorUtils.textWhite,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12.sp,
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
                                                          color: ColorUtils.textWhite,
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 12.sp,
                                                        ),
                                                      ),
                                                      SizedBox(width: 10.w),
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
                                                          color: ColorUtils.textWhite,
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 12.sp,
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
                          Padding(
                            padding: const EdgeInsets.all(10.0).w,
                            child: LeaveCalender(
                              isRangeSelection: widget.leaveType?.isHourBased != '1',
                              fetchLeaveTypes: true,
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
                              date: widget.date,
                            ),
                          ),
                          if(!(widget.leaveType?.hideLeaveBalance ?? false))
                            if(widget.leaveType?.leaveBalance != null && widget.leaveType?.leaveType?.trim().toLowerCase() != 'lop' && widget.leaveType?.leaveType?.trim().toLowerCase() != 'unlimited')
                              Padding(
                                padding: const EdgeInsets.all(10.0).w,
                                child: Container(
                                  width: ScreenUtil().screenWidth,
                                  // height: 70.w,
                                  decoration: BoxDecoration(
                                    color: ColorUtils.backgroundBlack,
                                    borderRadius: BorderRadius.circular(12).w,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0).w,
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
                                                ),
                                                SizedBox(width: 4.w),
                                                Text(
                                                  "${widget.leaveType?.leaveType} balance: ${widget.leaveType?.leaveBalance ?? '--'}",
                                                  style: GoogleFonts.inter(
                                                    color: ColorUtils.textWhite.withOpacity(0.8),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14.sp,
                                                  ),
                                                ),
                                                // Text(
                                                //   "${availableDays.value.length} working days",
                                                //   style: GoogleFonts.inter(
                                                //     color: ColorUtils.textWhite.withOpacity(0.8),
                                                //     fontWeight: FontWeight.w500,
                                                //     fontSize: 14.sp,
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                            // SizedBox(height: 4.w),
                                            // Text(
                                            //   "You have ${availableDays.value.length} working days available for leave period ending on ${value ?? ""}",
                                            //   style: GoogleFonts.poppins(
                                            //     color: ColorUtils.textWhite.withOpacity(0.5),
                                            //     fontWeight: FontWeight.w400,
                                            //     fontSize: 12.sp,
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
                            padding: const EdgeInsets.all(10.0).w,
                            child: Row(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 10.w,
                                      height: 10.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50).w,
                                        color: const Color(0xFF6A4BFC),
                                      ),
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      "Leave Requested",
                                      style: GoogleFonts.poppins(
                                        color: ColorUtils.frostedPearl,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 10.w,
                                      height: 10.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50).w,
                                        color: const Color(0xFFF8A24E),
                                      ),
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      "Holiday",
                                      style: GoogleFonts.poppins(
                                        color: ColorUtils.frostedPearl,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12.sp,
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
        bottomNavigationBar: Container(
          width: ScreenUtil().screenWidth,
          height: 70.w,
          decoration: blueTextButtonDecoration,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20).w,
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
