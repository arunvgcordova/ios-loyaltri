
import 'dart:collection';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/controller/ui_controller/home_controller.dart';
import 'package:loyaltri_minimal/controller/ui_controller/page_controller.dart';
import 'package:loyaltri_minimal/controller/userAuthentication.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';
import 'package:loyaltri_minimal/models/calendar_api_model.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/leaveAndHoliday_data_api_model.dart';
import '../services/api_services.dart';
import '../utils/event.dart';

class CalendarEventController extends GetxController {
  Rx<bool> isLoading = false.obs;
  Rx<bool> leaveCalenderLoaded = false.obs;
  Rx<bool> dataLoaded = false.obs;
  Rx<bool> isError = false.obs;
  late RxList<Leaves> presentDates = <Leaves>[].obs;
  late RxList<Leaves> paidLeaveDates = <Leaves>[].obs;
  late RxList<Leaves> unPaidLeaveDates = <Leaves>[].obs;
  late RxList<Leaves> offDayDates = <Leaves>[].obs;
  late RxList<Leaves> holidayDates = <Leaves>[].obs;

  late RxList<Leaves> presentDatesPerMonth = <Leaves>[].obs;
  late RxList<Leaves> paidLeaveDatesPerMonth = <Leaves>[].obs;
  late RxList<Leaves> unPaidLeaveDatesPerMonth = <Leaves>[].obs;
  late RxList<Leaves> offDayDatesPerMonth = <Leaves>[].obs;
  late RxList<Leaves> holidayDatesPerMonth = <Leaves>[].obs;

  RxMap<DateTime, List<LeaveCalendarEvents>> evMap = <DateTime, List<LeaveCalendarEvents>>{}.obs;
  Rx<LinkedHashMap> calEvents = LinkedHashMap<DateTime, List<LeaveCalendarEvents>>(
    equals: isSameDay,
    hashCode: getHashCode,
  ).obs;

  void resetStatus() {
    isLoading.value = false;
    isError.value = false;
  }

  Future fetchCalendarData({required String empId, required String monthYear}) async {
    isLoading.value = true;
    try {
      Map<String, dynamic> resp = await ApiServices.getCalendarData(empId: empId, monthYear: monthYear);
      AttendanceCommonWidgets().printF("-----calender resp------$resp");
      CalendarApiModel calendarData = CalendarApiModel.fromJson(resp);
      if (calendarData.status == 200) {
        paidLeaveDates.value = calendarData.result?.paidLeave ?? [];
        unPaidLeaveDates.value = [...(calendarData.result?.unpaidLeave ?? []), ...(calendarData.result?.absent ?? [])];
        offDayDates.value = calendarData.result?.offday ?? [];
        holidayDates.value = calendarData.result?.holiday ?? [];
        presentDates.value = calendarData.result?.duty ?? [];
        // await fetchDataPerMonth(selectedData: DateTime.now());
        dataLoaded.value = true;
      }
    } catch(e) {
      isError.value = true;
      AttendanceCommonWidgets().printF("------calendar events error-------${e.toString()}");
    } finally {
      resetStatus();
    }
  }

  String normalizeStatus(String? status) => status?.trim().toLowerCase() ?? '';

  Future fetchDataPerMonth({required DateTime selectedData}) async {
    isLoading.value = true;
    List<Leaves> present = [];
    List<Leaves> paidLeave = [];
    List<Leaves> unPaidLeave = [];
    List<Leaves> offDay = [];
    List<Leaves> holiday = [];

    try {
      String date = DateFormat('yyyy-MM-dd').format(selectedData);
      List<String> dateParts = date.split('-');

      int year = int.parse(dateParts[0]);
      int month = int.parse(dateParts[1]);

      for(int i = 0; i < presentDates.value.length; i++) {
        if (year == int.parse(presentDates.value[i].date!.split('-')[0]) &&
            month == int.parse(presentDates.value[i].date!.split('-')[1])) {
          present.add(presentDates.value[i]);
        }
      }

      for(int i = 0; i < paidLeaveDates.value.length; i++) {
        if (year == int.parse(paidLeaveDates.value[i].date!.split('-')[0]) &&
            month == int.parse(paidLeaveDates.value[i].date!.split('-')[1])) {
          paidLeave.add(paidLeaveDates.value[i]);
        }
      }

      for(int i = 0; i < unPaidLeaveDates.value.length; i++) {
        if (year == int.parse(unPaidLeaveDates.value[i].date!.split('-')[0]) &&
            month == int.parse(unPaidLeaveDates.value[i].date!.split('-')[1])) {
          unPaidLeave.add(unPaidLeaveDates.value[i]);
        }
      }

      for(int i = 0; i < offDayDates.value.length; i++) {
        if (year == int.parse(offDayDates.value[i].date!.split('-')[0]) &&
            month == int.parse(offDayDates.value[i].date!.split('-')[1])) {
          offDay.add(offDayDates.value[i]);
        }
      }

      for(int i = 0; i < holidayDates.value.length; i++) {
        if (year == int.parse(holidayDates.value[i].date!.split('-')[0]) &&
            month == int.parse(holidayDates.value[i].date!.split('-')[1])) {
          holiday.add(holidayDates.value[i]);
        }
      }

      presentDatesPerMonth.value = present;
      paidLeaveDatesPerMonth.value = paidLeave;
      unPaidLeaveDatesPerMonth.value = unPaidLeave;
      offDayDatesPerMonth.value = offDay;
      holidayDatesPerMonth.value = holiday;
      isLoading.value = false;
    } catch(e) {
      isError.value = true;
      AttendanceCommonWidgets().printF("------calender event per month error-------${e.toString()}");
    } finally {
      resetStatus();
    }
  }

  Future<void> fetchCalendarEventsForLeave() async {
    evMap.value.clear();
    calEvents.value.clear();
    try {
      String employeeId = Get.find<UserAuthController>().userData.value.userData?.employeeId ?? '';
      String companyId = Get.find<UserPageController>().appView.value == AppView.manager
          ? Get.find<UserProfileController>().currentCompany.value?.companyId?.toString() ?? Get.find<UserProfileController>().userData.value.result.companyId?.toString() ?? ''
          : Get.find<UserProfileController>().userData.value.result.companyId?.toString() ?? '';
      Map<String, dynamic> leaveResp = await ApiServices.getCalendarLeaveData(empId: employeeId);
      Map<String, dynamic> holidayResp = await ApiServices.getCalendarHolidayData(empId: employeeId, compId: companyId);
      LeaveDataApiModel leaveDataApiModel = LeaveDataApiModel.fromJson(leaveResp);
      HolidayDataApiModel holidayDataApiModel = HolidayDataApiModel.fromJson(holidayResp);
      if (leaveDataApiModel.status == 200) {
        leaveDataApiModel.result?.forEach((element) {
          List<String> fromDateParts = element.leaveDateFrom?.split("-") ?? [];
          List<String> toDateParts = element.leaveDateTo?.split("-") ?? [];
          DateTime startDate = DateTime(int.parse(fromDateParts.first), int.parse(fromDateParts[1]), int.parse(fromDateParts.last));
          DateTime endDate = DateTime(int.parse(toDateParts.first), int.parse(toDateParts[1]), int.parse(toDateParts.last));
          if(startDate != endDate) {
            for (DateTime date = startDate; date.isBefore(endDate.add(const Duration(days: 1))); date = date.add(const Duration(days: 1))) {
              evMap.value.addAll({
                DateTime.utc(date.year, date.month, date.day): [
                  LeaveCalendarEvents(
                    clEventType: LeaveClEventType.requestedLeave,
                    date: date.toIso8601String().split('T')[0],
                  ),
                ]
              });
            }
          } else {
            evMap.value.addAll({
              DateTime.utc(startDate.year, startDate.month, startDate.day): [
                LeaveCalendarEvents(
                  clEventType: LeaveClEventType.requestedLeave,
                  date: startDate.toIso8601String().split('T')[0],
                ),
              ]
            });
          }
        });
      }

      if (holidayDataApiModel.status == 200) {
        holidayDataApiModel.result?.forEach((element) {
          List<String> fromDateParts = element.fromDate?.split("-") ?? [];
          List<String> toDateParts = element.toDate?.split("-") ?? [];
          DateTime startDate = DateTime(int.parse(fromDateParts.first), int.parse(fromDateParts[1]), int.parse(fromDateParts.last));
          DateTime endDate = DateTime(int.parse(toDateParts.first), int.parse(toDateParts[1]), int.parse(toDateParts.last));
          if(startDate != endDate) {
            for (DateTime date = startDate; date.isBefore(endDate.add(const Duration(days: 1))); date = date.add(const Duration(days: 1))) {
              evMap.value.addAll({
                DateTime.utc(startDate.year, startDate.month, startDate.day): [
                  LeaveCalendarEvents(
                    clEventType: LeaveClEventType.holiday,
                    date: date.toIso8601String().split('T')[0],
                  ),
                ]
              });
            }
          } else {
            evMap.value.addAll({
              DateTime.utc(startDate.year, startDate.month, startDate.day): [
                LeaveCalendarEvents(
                  clEventType: LeaveClEventType.holiday,
                  date: startDate.toIso8601String().split('T')[0],
                ),
              ]
            });
          }
        });
      }
      if (evMap.value.isNotEmpty) {
        calEvents.value.addAll(evMap);
      }
    } catch(e) {
      AttendanceCommonWidgets().printF("------leave calendar events error-------${e.toString()}");
    } finally {
      leaveCalenderLoaded.value = true;
    }
  }
}