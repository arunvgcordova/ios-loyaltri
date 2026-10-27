
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/controller/userAuthentication.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';
import 'package:loyaltri_minimal/models/manager/attendance_filter_models.dart';
import 'package:loyaltri_minimal/models/manager/edit_attendance_models.dart';
import 'package:loyaltri_minimal/models/manager/payout_status_model.dart';
import 'package:loyaltri_minimal/services/api_services.dart';
import '../../../../models/leave_type_api_model.dart';
import '../../../../models/manager/employee_attendance_detail.dart';
import '../../../../models/manager/employee_shift_model.dart';
import '../../../../models/manager/leave_request_list_model.dart';
import '../../../../models/manager/manager_att_summary.dart';
import '../../../../models/manager/manager_attendance_list_model.dart';
import '../../Manager_Request/manager_request_controller/manager_request_controller.dart';
import '../attendance_widgets_manager/attendance_type_buttons.dart';

enum LeaveSessionType {firstHalf, secondHalf}
enum FilterPage {attendance, leave, empProfile, requests, task, pieceWork, growth, shiftScheduler}
enum AttendanceFilterTypes {search, present, absent, halfDay, offDay, fine, overtime, paidLeave, holiday, unpaidLeave, department, location, shiftScheme, punchType}

class ManagerAttendanceController extends GetxController {
  Rx<double?> empWidth = Rx(null);
  RxInt selectedDay = 1.obs;
  RxInt selectedMonth = 1.obs;
  RxInt selectedYear = DateTime.now().year.obs;
  RxBool summaryExpansionChanged = false.obs;
  RxList<DatePickModel> daysList = <DatePickModel>[].obs;
  Rx<EditLeaveTypes?> editType = Rx(null);
  Rx<EditLeaveTypes?> savedEditType = Rx(null);
  Rx<LeaveSessionType> selectedLeaveSession = LeaveSessionType.firstHalf.obs;
  List<String> fineTypes = [
    "Short Time",
    "Late Entry",
    "Excess Break",
    "Early Exit",
    "Miss Punch",
  ];
  List<String> deductionTypes = [
    'Choose Type',
    'Fixed',
    'Quarter Day',
    'Half Day',
    'Full Day',
    'Pardon',
    'Per Minute',
  ];

  List<String> overTimeRates = [
    'Select',
    'Fixed Amount',
    '1 x Salary',
    '1.5 x Salary',
    '2 x Salary',
  ];

  RxList<DateTime> dateList = List.generate(365, (index) => DateTime.now().subtract(Duration(days: index))).obs;
  RxInt currentDateIndex = 0.obs;
  RxBool isChangedFromMonth = false.obs;

  @override
  void onInit() {
    DateTime now = DateTime.now();
    selectedDay.value = now.day - 1;
    selectedMonth.value = now.month;
    selectedYear.value = now.year;
    getDaysInMonth(now.year, now.month);
    super.onInit();
  }

  void resetValues() {
    editType.value = null;
  }

  List<DatePickModel> getDaysInMonth(int year, int month) {
    int daysInMonth = DateTime(year, month + 1, 0).day;

    daysList.value = List.generate(daysInMonth, (index) {
      int day = index + 1;
      int weekDay = DateTime(year, month, day).weekday;
      String weekDayName = getWeekdayName(weekDay);

      return DatePickModel(day: day, weak: weekDayName);
    });

    return daysList.value;
  }

  String getWeekdayName(int weekday) {
    const List<String> weekDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    return weekDays[weekday - 1];
  }

  RxBool summaryLoading = false.obs;
  RxBool summaryLoaded = false.obs;
  RxBool summaryError = false.obs;
  Rx<SummaryData?> summaryData = Rx(null);

  Future<void> fetchManagerAttSummary({required String date}) async {
    summaryLoading.value = true;
    summaryLoaded.value = false;
    summaryError.value = false;
    try {
      String empId = Get.find<UserProfileController>().userData.value.result.employeeId ?? '';
      String compId = Get.find<UserProfileController>().currentCompany.value?.companyId?.toString() ?? Get.find<UserProfileController>().userData.value.result.companyId ?? '';
      bool isAll = Get.find<UserAuthController>().userData.value.userData?.unrestrictedList ?? false;
      var resp = await ApiServices.getManagerAttSummary(empId: empId, compId: compId, date: date, isListAll: isAll);
      AttendanceCommonWidgets().printF("------att summary resp--------$resp");
      if(resp['status'].toString() == "200") {
        ManagerAttSummary managerAttSummary = ManagerAttSummary.fromJson(resp);
        summaryData.value = managerAttSummary.summaryData;
        summaryLoaded.value = true;
      }
    } catch(e) {
      AttendanceCommonWidgets().printF("--------manager attendance summary error---------");
      summaryError.value = true;
    } finally {
      summaryLoading.value = false;
    }
  }

  RxBool attDetailsLoading = false.obs;
  RxBool attDetailsLoaded = false.obs;
  RxBool attDetailsShimmer = false.obs;
  RxBool attDetailsError = false.obs;
  RxList<ManagerEmployeeData> attDetailsData = <ManagerEmployeeData>[].obs;
  RxList<ManagerEmployeeData> fliterdDeatialsData = <ManagerEmployeeData>[].obs;
  Rx<ManagerEmployeeData?> selectedEmployeeData = Rx(null);
  TextEditingController employeeSerachcontroller = TextEditingController();
  int currentPagination = 1;

  Future<void> fetchManagerAttDetails({required String date}) async {
    attDetailsLoading.value = true;
    attDetailsLoaded.value = false;
    attDetailsError.value = false;
    stopLoading = false;
    attDetailsShimmer.value = false;
    currentPagination = 1;
    lastLength = 0;
    try {

      String empId = Get.find<UserProfileController>().userData.value.result.employeeId ?? '';
      String compId = Get.find<UserProfileController>().currentCompany.value?.companyId?.toString() ?? Get.find<UserProfileController>().userData.value.result.companyId ?? '';
      bool isAll = Get.find<UserAuthController>().userData.value.userData?.unrestrictedList ?? false;
      var resp = await ApiServices.getManagerAttDetails(empId: empId, compId: compId, date: date, pageNo: currentPagination, isListAll: isAll);
      AttendanceCommonWidgets().printF("------att list resp--------$resp");
       fliterdDeatialsData.clear();
      if(resp['status'].toString() == "200") {
        ManagerAttendanceListData managerAttendanceListData = ManagerAttendanceListData.fromJson(resp);

        attDetailsData.value = managerAttendanceListData.result ?? [];
         fliterdDeatialsData.value = attDetailsData.value;
        attDetailsLoading.value = false;
        attDetailsShimmer.value =true;
        lastLength = attDetailsData.length;
        await filterManagerAttDetails(type: AttendanceFilterTypes.search);
        AttendanceCommonWidgets().printF('the data----------------${attDetailsData.first.employeeName}');
        attDetailsLoaded.value = true;
        attDetailsShimmer.value =true;
      }
    } catch(e) {
      AttendanceCommonWidgets().printF("--------manager attendance list error---------");
      attDetailsError.value = true;
      attDetailsShimmer.value =true;
    } finally {
      attDetailsLoading.value = false;
      attDetailsShimmer.value =true;
    }
  }

  RxBool loadingNextPage = false.obs;
  int lastLength = 0;
  bool stopLoading = false;

  Future<void> fetchManagerAttDetailsNextPage() async {
    if(!stopLoading) {
      loadingNextPage.value = true;
      currentPagination += 1;

      try {
        String empId = Get.find<UserProfileController>().userData.value.result.employeeId ?? '';
        String compId = Get.find<UserProfileController>().currentCompany.value?.companyId?.toString() ?? Get.find<UserProfileController>().userData.value.result.companyId ?? '';
        String formated = DateFormat('yyyy-MM-dd').format(dateList[currentDateIndex.value]);
        bool isAll = Get.find<UserAuthController>().userData.value.userData?.unrestrictedList ?? false;
        var resp = await ApiServices.getManagerAttDetails(empId: empId, compId: compId, date: formated, pageNo: currentPagination, isListAll: isAll);
        AttendanceCommonWidgets().printF("------att next list resp--------$resp");

        if(resp['status'].toString() == "200") {
          ManagerAttendanceListData managerAttendanceListData = ManagerAttendanceListData.fromJson(resp);
          List<ManagerEmployeeData> newData = managerAttendanceListData.result ?? [];
          attDetailsData.addAll(newData);
          fliterdDeatialsData.addAll(newData);

          if(attDetailsData.length == lastLength) {
            stopLoading = true;
          }
          lastLength = attDetailsData.length;

          loadingNextPage.value = false;
          await filterManagerAttDetails(type: AttendanceFilterTypes.search);
          attDetailsLoaded.value = true;
        } else {
          if(attDetailsData.length == lastLength) {
            stopLoading = true;
          }
          lastLength = attDetailsData.length;
        }
      } catch(e) {
        AttendanceCommonWidgets().printF("--------manager attendance pagination error---------");
      } finally {
        loadingNextPage.value = false;
        AttendanceCommonWidgets().printF("------finally-------${loadingNextPage.value}");
      }
    }
  }

  RxBool next7DaysLeaveLoading = false.obs;
  RxBool next7DaysLeaveLoaded = false.obs;
  RxBool next7DaysLeaveError = false.obs;
  RxList<EmployeeLeaveData> next7DaysLeaveList = <EmployeeLeaveData>[].obs;

  Future<void> fetchNextSevenDaysLeave() async {
    next7DaysLeaveLoading.value = true;
    next7DaysLeaveLoaded.value = false;
    next7DaysLeaveError.value = false;
    try {

      String empId = Get.find<UserProfileController>().userData.value.result.employeeId ?? '';
      String compId = Get.find<UserProfileController>().currentCompany.value?.companyId?.toString() ?? Get.find<UserProfileController>().userData.value.result.companyId ?? '';
      var resp = await ApiServices.next7DaysLeaveList(empId: empId, compId: compId);
      AttendanceCommonWidgets().printF("------7 day leave list resp--------$resp");

      if(resp['status'].toString() == "200") {
        EmployeeLeaveReqApi employeeLeaveReqApi = EmployeeLeaveReqApi.fromJson(resp);

        next7DaysLeaveList.value = employeeLeaveReqApi.result ?? [];
        if(next7DaysLeaveList.value.isNotEmpty) {
          empWidth.value = 16.h;
        }
        for(int i = 0; i < next7DaysLeaveList.value.length; i++) {
          if (i < 3) {
            empWidth.value = (empWidth.value ?? 16.h) + 15.h;
          }
        }
        next7DaysLeaveLoaded.value = true;
      }
    } catch(e) {
      AttendanceCommonWidgets().printF("--------7 day leave list error---------");
      next7DaysLeaveError.value = true;
    } finally {
      next7DaysLeaveLoading.value = false;
    }
  }

  void updateExpansion(int index) {
    filters[index].isExpanded = !filters[index].isExpanded;
    filters.refresh();
  }

  RxBool filterLoading = false.obs;
  RxBool filterLoaded = false.obs;
  RxBool filterError = false.obs;
  RxList<FilterModel> filters = <FilterModel>[
    FilterModel(
      filterTitle: "Location",
      isExpanded: false,
      filters: [],
    ),
    FilterModel(
      filterTitle: "Department",
      isExpanded: false,
      filters: [],
    ),
    FilterModel(
      filterTitle: "Shift Schemes",
      isExpanded: false,
      filters: [],
    ),
    FilterModel(
      filterTitle: "Punch Type",
      isExpanded: false,
      filters: [],
    ),
  ].obs;

  Future<void> fetchAllFilters() async {
    filterLoading.value = true;
    filterLoaded.value = false;
    filterError.value = false;
    try {

      String empId = Get.find<UserProfileController>().userData.value.result.employeeId ?? '';
      String compId = Get.find<UserProfileController>().currentCompany.value?.companyId?.toString() ?? Get.find<UserProfileController>().userData.value.result.companyId ?? '';
      var departmentResp = await ApiServices.departmentFilters(compId: compId);
      var locationResp = await ApiServices.locationFilters(compId: compId);
      var shiftResp = await ApiServices.shiftWiseFilters(compId: compId);
      var punchTypeResp = await ApiServices.punchTypeWiseFilters(compId: compId, empId: empId);

      if(departmentResp['status'].toString() == "200") {
        DepartmentFilterApi departmentFilterApi = DepartmentFilterApi.fromJson(departmentResp);
        filters.value[1].filters = departmentFilterApi.result?.map((e) => Filters(id: e.departmentId?.toString() ?? '', name: e.department ?? '--', isSelected: false)).toList() ?? [];
        filterLoaded.value = true;
      }

      if(locationResp['status'].toString() == "200") {
        LocationFilterApi locationFilterApi = LocationFilterApi.fromJson(locationResp);
        filters.value[0].filters = locationFilterApi.result?.map((e) => Filters(id: e.locationId?.toString() ?? '', name: e.location ?? '--', isSelected: false)).toList() ?? [];
        filterLoaded.value = true;
      }

      if(shiftResp['status'].toString() == "200") {
        ShiftSchemeFilterApi shiftSchemeFilterApi = ShiftSchemeFilterApi.fromJson(shiftResp);
        filters.value[2].filters = shiftSchemeFilterApi.result?.map((e) => Filters(id: e.shiftSchemeId?.toString() ?? '', name: e.shiftScheme ?? '--', isSelected: false)).toList() ?? [];
        filterLoaded.value = true;
      }

      if(punchTypeResp['status'].toString() == "200") {
        PunchTypeFilterApi punchTypeFilterApi = PunchTypeFilterApi.fromJson(punchTypeResp);
        filters.value[3].filters = punchTypeFilterApi.result?.map((e) => Filters(id: e.punchType?.toString() ?? '', name: e.punchType ?? '--', isSelected: false)).toList() ?? [];
        filterLoaded.value = true;
      }
    } catch(e) {
      AttendanceCommonWidgets().printF("--------filter data error---------");
      filterError.value = true;
    } finally {
      filterLoading.value = false;
    }
  }

  RxList<AttendanceFilterTypes> selectedFilters = <AttendanceFilterTypes>[].obs;
  RxString searchText = ''.obs;

  Future<void> filterManagerAttDetails({required AttendanceFilterTypes type}) async {
    if(type != AttendanceFilterTypes.search) {
      if(selectedFilters.value.contains(type)) {
        selectedFilters.value.remove(type);
      } else {
        selectedFilters.value.add(type);
      }
    }

    final highPriorityFilters = selectedFilters.where((filter) =>
    filter == AttendanceFilterTypes.present ||
        filter == AttendanceFilterTypes.absent ||
        filter == AttendanceFilterTypes.halfDay ||
        filter == AttendanceFilterTypes.offDay ||
        filter == AttendanceFilterTypes.fine ||
        filter == AttendanceFilterTypes.overtime ||
        filter == AttendanceFilterTypes.paidLeave
    ).toList();

    final categoryFilters = selectedFilters.where((filter) =>
    filter == AttendanceFilterTypes.location ||
        filter == AttendanceFilterTypes.department ||
        filter == AttendanceFilterTypes.shiftScheme ||
        filter == AttendanceFilterTypes.punchType
    ).toList();

    fliterdDeatialsData.value = attDetailsData.value.where((managerDetails) {
      bool nameMatches = managerDetails.employeeName?.toLowerCase().trim().contains(searchText.value.toLowerCase().trim()) ?? false;

      if (searchText.value.toLowerCase().trim().isNotEmpty && selectedFilters.isEmpty) {
        return nameMatches;
      }

      if (selectedFilters.isEmpty) return true;

      if (searchText.value.toLowerCase().trim().isEmpty) {
        nameMatches = true;
      }

      // Apply high-priority filters
      bool passesHighPriority = highPriorityFilters.isEmpty || highPriorityFilters.any((filter) {
        switch (filter) {
          case AttendanceFilterTypes.present:
            return managerDetails.status?.toLowerCase().trim() == "present";
          case AttendanceFilterTypes.absent:
            return managerDetails.status?.toLowerCase().trim() == "absent";
          case AttendanceFilterTypes.halfDay:
            return managerDetails.isHalfDay?.toString() == "1";
          case AttendanceFilterTypes.offDay:
            return managerDetails.isOffDay?.toString() == "1";
          case AttendanceFilterTypes.fine:
            return managerDetails.isFineToRegularize?.toString() == "1";
          case AttendanceFilterTypes.overtime:
            return (managerDetails.isOverTime ?? false);
          case AttendanceFilterTypes.paidLeave:
            return managerDetails.isPaidLeave?.toString() == "1";
          default:
            return false;
        }
      });

      if (!passesHighPriority) return false;

      // Apply category filters only if they are selected
      bool passesCategory = categoryFilters.isEmpty || categoryFilters.every((filter) {
        switch (filter) {
          case AttendanceFilterTypes.location:
            return checkContains(id: managerDetails.locationId?.toString(), index: 0);
          case AttendanceFilterTypes.department:
            return checkContains(id: managerDetails.departmentId?.toString(), index: 1);
          case AttendanceFilterTypes.shiftScheme:
            return checkContains(id: managerDetails.shiftSchemeId?.toString(), index: 2);
          case AttendanceFilterTypes.punchType:
            return checkContains(id: json.encode(managerDetails.punchType), index: 3);
          default:
            return true;
        }
      });

      return passesCategory && nameMatches;

    }).toList();

    fliterdDeatialsData.refresh();
    // AttendanceCommonWidgets().printF("----------length----------${fliterdDeatialsData.value.length}");
    // AttendanceCommonWidgets().printF("-------attDetailsData---length----------${attDetailsData.value.length}");
    // selectedFilters.value.forEach((element) {
    //   AttendanceCommonWidgets().printF("-----gg----------$element");
    //   },
    // );
    Set<int> seen = {};
    Set<int> duplicates = {};

    for (var number in fliterdDeatialsData.value) {
      if (!seen.add(number.employeeDailyAttendanceId!.toInt())) {
        duplicates.add(number.employeeDailyAttendanceId!.toInt());
      }
    }

    // AttendanceCommonWidgets().printF(duplicates.toList());
    if(fliterdDeatialsData.value.length < 10 && !loadingNextPage.value) {
      await fetchManagerAttDetailsNextPage();
    }
  }

  bool checkContains({required String? id, required int index}) {
    if (id == null || id.isEmpty) return false;

    if (index == 3) {
      try {
        final List<dynamic> punchTypes = json.decode(id);
        for (var filter in filters.value[index].filters) {
          if (punchTypes.contains(filter.name) && filter.isSelected) {
            return true;
          }
        }
      } catch (e) {
        AttendanceCommonWidgets().printF("Error decoding punchType JSON: $e");
        return false;
      }
    } else {
      for (var filter in filters.value[index].filters) {
        if (filter.id == id && filter.isSelected) {
          return true;
        }
      }
    }

    return false;
  }

  void applyFilterButtonClick() {
    selectedFilters.removeWhere((type) =>
    type == AttendanceFilterTypes.location ||
        type == AttendanceFilterTypes.department ||
        type == AttendanceFilterTypes.shiftScheme ||
        type == AttendanceFilterTypes.punchType
    );
    bool anyFilterApplied = false;

    for (int i = 0; i < filters.value.length && i <= 3; i++) {
      bool selected = filters.value[i].filters.any((item) => item.isSelected);
      if (selected) {
        anyFilterApplied = true;
        final type = [
          AttendanceFilterTypes.location,
          AttendanceFilterTypes.department,
          AttendanceFilterTypes.shiftScheme,
          AttendanceFilterTypes.punchType,
        ][i];
        filterManagerAttDetails(type: type);
      }
    }

    if (!anyFilterApplied) {
      filterManagerAttDetails(type: AttendanceFilterTypes.search);
    }

    selectedFilters.refresh();
  }

  RxBool employeeShiftLoading = false.obs;
  RxBool employeeShiftLoaded = false.obs;
  RxBool employeeShiftError = false.obs;
  RxList<EmployeeShiftData> employeeShiftList = <EmployeeShiftData>[].obs;
  Rx<EmployeeShiftData?> selectedShift = Rx(null);

  Future<void> fetchEmployeeShift() async {
    employeeShiftLoading.value = true;
    employeeShiftLoaded.value = false;
    employeeShiftError.value = false;
    employeeShiftList.value = [];
    selectedShift.value = null;
    try {
      var resp = await ApiServices.getAllShiftEmployee(compId: selectedEmployeeData.value?.companyId.toString() ?? '');
      AttendanceCommonWidgets().printF("------employee shift resp--------$resp");
      if(resp['status'].toString() == "200") {
        EmployeeShiftModel employeeShiftModel = EmployeeShiftModel.fromJson(resp);
        employeeShiftList.value = employeeShiftModel.result ?? [];
        if(employeeShiftList.value.isNotEmpty) {
          selectedShift.value = employeeShiftList.value.first;
        }
        employeeShiftLoaded.value = true;
      }
    } catch(e) {
      AttendanceCommonWidgets().printF("--------employee shift error---------");
      employeeShiftError.value = true;
    } finally {
      employeeShiftLoading.value = false;
    }
  }

  RxBool employeeLeaveTypeLoading = false.obs;
  RxBool employeeLeaveTypeLoaded = false.obs;
  RxBool employeeLeaveTypeError = false.obs;
  RxList<LeaveType> employeeLeaveTypeList = <LeaveType>[].obs;
  Rx<LeaveType?> selectedLeaveType = Rx(null);

  Future<void> fetchEmployeeLeaveType() async {
    employeeLeaveTypeLoading.value = true;
    employeeShiftLoaded.value = false;
    employeeLeaveTypeError.value = false;
    employeeLeaveTypeList.value = [];
    selectedLeaveType.value = null;
    try {
      var resp = await ApiServices.getLeaveType(compId: selectedEmployeeData.value?.companyId.toString() ?? '', empId: selectedEmployeeData.value?.employeeId.toString() ?? '');
      AttendanceCommonWidgets().printF("------employee leave type resp--------$resp");
      if(resp['status'].toString() == "200") {
        LeaveTypeAPI leaveTypeAPI = LeaveTypeAPI.fromJson(resp);
        employeeLeaveTypeList.value = leaveTypeAPI.result ?? [];
        if(employeeLeaveTypeList.value.isNotEmpty) {
          if(employeeAttendance.value?.leaveTypeId != null) {
            selectedLeaveType.value = employeeLeaveTypeList.value.singleWhere((element) => element.leaveTypeId == employeeAttendance.value?.leaveTypeId!);
          } else {
            selectedLeaveType.value = employeeLeaveTypeList.value.first;
          }
        }
        employeeLeaveTypeLoaded.value = true;
      }
    } catch(e) {
      AttendanceCommonWidgets().printF("--------employee leave type error---------");
      employeeLeaveTypeError.value = true;
    } finally {
      employeeLeaveTypeLoading.value = false;
    }
  }

  RxBool employeeAttDetailLoading = false.obs;
  RxBool employeeAttDetailLoaded = false.obs;
  RxBool employeeAttDetailError = false.obs;
  Rx<AttendanceDetail?> employeeAttendance = Rx(null);

  Future<void> fetchEmployeeAttDetail({required String attId}) async {
    employeeAttDetailLoading.value = true;
    employeeAttDetailLoaded.value = false;
    employeeAttDetailError.value = false;
    employeeAttendance.value = null;
    try {
      String? shiftId = selectedShift.value?.shiftId?.toString();
      var resp = await ApiServices.getEmployeeAttendanceDetail(empId: attId, shiftId: editType.value?.type == EditAttType.present ? shiftId : null);
      AttendanceCommonWidgets().printF("------employee att detail resp--------$resp");
      if(resp['status']?.toString() == "200") {
        EmployeeAttendanceDetailModel employeeAttendanceDetailModel = EmployeeAttendanceDetailModel.fromJson(resp);
        employeeAttendance.value = employeeAttendanceDetailModel.result;

        halfDayTimes.value = [employeeAttendance.value?.firstCheckInTime?.substring(0, 5) ?? '', employeeAttendance.value?.lastCheckOutTime?.substring(0, 5) ?? ''];
        if(savedEditType.value?.type == EditAttType.present) {
          if(employeeAttendance.value?.isOffDay == 1 || selectedEmployeeData.value?.isOffDay == '1') {
            isOffDay.value = true;
          } else {
            isOffDay.value = false;
          }
          for (int i = 0; i < (employeeAttendance.value?.timeData?.length ?? 0); i++) {
            final time = employeeAttendance.value!.timeData![i];

            if(i == 0) {
              addedTimeList.value = [AddTimeModel(
                type: time.punchTime != null ? CheckInType.punchAdd : CheckInType.breakAdd,
                time1: time.punchTime ?? time.startBreak,
                time2: time.endBreak,
                isValidationSuccess: false,
                isValidationChecked: false,
              )];
            } else {
              addedTimeList.value.add(
                AddTimeModel(
                  type: time.punchTime != null ? CheckInType.punchAdd : CheckInType.breakAdd,
                  time1: time.punchTime ?? time.startBreak,
                  time2: time.endBreak,
                  isValidationSuccess: false,
                  isValidationChecked: false,
                ),
              );
            }
          }
          if(employeeAttendance.value?.shiftId != null) {
            List<EmployeeShiftData?> shift = employeeShiftList.value.where((element) => element.shiftId == employeeAttendance.value?.shiftId).toList();
            if(shift.isNotEmpty) {
              selectedShift.value = shift.first;
            }
          }
          addedTimeList.refresh();
        } else if(savedEditType.value?.type == EditAttType.halfDay) {
          halfDayTimes.value = [employeeAttendance.value?.firstCheckInTime ?? '', employeeAttendance.value?.lastCheckOutTime ?? ''];
          if(employeeAttendance.value?.leaveSession != null) {
            selectedLeaveSession.value = employeeAttendance.value?.leaveSession == 'secondHalf' ? LeaveSessionType.secondHalf : LeaveSessionType.firstHalf;
          }
          if(employeeAttendance.value?.shiftId != null) {
            List<EmployeeShiftData?> shift = employeeShiftList.value.where((element) => element.shiftId == employeeAttendance.value?.shiftId).toList();
            if(shift.isNotEmpty) {
              selectedShift.value = shift.first;
            }
          }
        } else if(savedEditType.value?.type == EditAttType.fine) {
          for(int i = 0; i < (employeeAttendance.value?.deductions?.length ?? 0); i++) {
            for(int j = 0; j < fineList.value.length; j++) {
              if(employeeAttendance.value?.deductions?[i].deductionDetails == fineList.value[j].deductionDetails) {
                String? formattedTime;
                try {
                  DateTime dateTime = DateFormat("HH:mm:ss").parse(employeeAttendance.value?.deductions?[i].timeDifference ?? '');
                  formattedTime = DateFormat("HH:mm").format(dateTime);
                } catch(e) {}
                fineList.value[j] = FineData(
                  deductionDetails: employeeAttendance.value?.deductions?[i].deductionDetails ?? fineList.value[j].deductionDetails,
                  deductionHours: formattedTime ?? fineList.value[j].deductionHours,
                  deductionType: fineTypeReverse(employeeAttendance.value?.deductions?[i].deductionCalculationType) ?? fineList.value[j].deductionType,
                  deductionAmount: employeeAttendance.value?.deductions?[i].deductionAmount ?? fineList.value[j].deductionAmount,
                  isFineApplied: true,
                );
                AttendanceCommonWidgets().printF("-----fineList-------${fineList.value[j].toJson()}");
              }
            }
          }
          fineList.refresh();
        } else if(savedEditType.value?.type == EditAttType.overTime) {
          List<String> times = employeeAttendance.value?.overtime?.timeExtra?.split(":") ?? [];
          if(times.isNotEmpty && times.length >= 2) {
            selectedOvertimeHour.value = "${times[0]}:${times[1]}";
          }

          selectedOvertimeRate.value = fineTypeReverse(employeeAttendance.value?.overtime?.overTimeRate) ?? '';
          selectedOvertimeAmount.value = employeeAttendance.value?.overtime?.amount ?? '';
          selectedOvertimeAmountController.text = employeeAttendance.value?.overtime?.amount ?? '';
        }
        employeeAttDetailLoaded.value = true;
      }
    } catch(e) {
      AttendanceCommonWidgets().printF("--------employee att detail error---------");
      employeeAttDetailError.value = true;
    } finally {
      employeeAttDetailLoading.value = false;
    }
  }

  Future<void> fetchSelectedFineAmount(FineData fineData) async {
    try {
      final resp = await ApiServices.calculateFineAmount(
        method: fineData.deductionDetails ?? '',
        time: fineData.deductionHours,
        type: fineType(fineData.deductionType) ?? '',
        attId: selectedEmployeeData.value?.employeeDailyAttendanceId?.toString() ?? '',
      );

      final amount = resp['result']?['amount'];
      if(editType.value?.type == EditAttType.fine) {
        if (amount != null) {
          for (var fine in fineList.value) {
            if (fine.deductionDetails == fineData.deductionDetails) {
              fine.deductionAmount = amount;
              amountControllers[fineData.deductionDetails ?? '']?.text = amount;
            }
          }
          fineList.refresh();
        }
      } else if(editType.value?.type == EditAttType.overTime) {
        selectedOvertimeAmount.value = amount;
        selectedOvertimeAmountController.text = amount;
      }
    } catch (e) {
      AttendanceCommonWidgets().printF("-----------fine amount error-------------");
    }
  }

  Rx<EmpLeaveData?> employeeLeaveData = Rx(null);

  Future<void> fetchEmployeeLeaveData() async {
    employeeLeaveData.value = null;
    try {
      Map<String, dynamic> resp = await ApiServices.getEmployeeLeaveData(
        attEmpId: selectedEmployeeData.value?.employeeId.toString() ?? '',
        attCompId: selectedEmployeeData.value?.companyId.toString() ?? '',
        leaveTypeId: selectedLeaveType.value?.leaveTypeId ?? '',
        attMonth: selectedEmployeeData.value?.date.toString() ?? '',
      );
      EmpLeaveDataApi empLeaveDataApi = EmpLeaveDataApi.fromJson(resp);
      employeeLeaveData.value = empLeaveDataApi.result;
    } catch (e) {
      AttendanceCommonWidgets().printF("-----------leave data error-------------");
    }
  }

  Future<void> submitEditedAttendance(BuildContext context) async {
    try {
      String empId = Get.find<UserProfileController>().userData.value.result.employeeId ?? '';
      Map<String, dynamic> presentData = {};

      if(editType.value?.type == EditAttType.present) {
        MarkPresentModel markPresentModel = MarkPresentModel(
          status: "Present",
          employeeAttendanceId: selectedEmployeeData.value?.employeeDailyAttendanceId.toString() ?? '',
          employeeAttendanceDate: selectedEmployeeData.value?.date.toString() ?? '',
          createdBy: empId,
          employeeId: selectedEmployeeData.value?.employeeId.toString() ?? '',
          shiftAssign: PresentShiftAssign(
            shiftId: isOffDay.value ? '0' : (selectedShift.value?.shiftId.toString() ?? ''),
            employeeAttendanceId: selectedEmployeeData.value?.employeeDailyAttendanceId.toString() ?? '',
            time: [
              for(int i = 0; i < addedTimeList.value.length; i++)
                if(addedTimeList.value[i].type == CheckInType.punchAdd)
                  TimeData(
                    punchTime: addedTimeList.value[i].time1,
                    startBreak: null,
                    endBreak: null,
                  )
                else
                  TimeData(
                    punchTime: null,
                    startBreak: addedTimeList.value[i].time1,
                    endBreak: addedTimeList.value[i].time2,
                  )
            ],
          ),
        );
        presentData = markPresentModel.toJson();
      } else if(editType.value?.type == EditAttType.halfDay) {
        await fetchEmployeeLeaveData();

        MarkHalfDayModel markHalfDayModel = MarkHalfDayModel(
          status: "Half Day",
          employeeAttendanceId: selectedEmployeeData.value?.employeeDailyAttendanceId.toString(),
          employeeAttendanceDate: selectedEmployeeData.value?.date.toString(),
          createdBy: empId,
          employeeId: selectedEmployeeData.value?.employeeId.toString(),
          shiftAssign: HalfDayShiftAssign(
            shiftId: selectedShift.value?.shiftId.toString(),
            time: [
              for(int i = 0; i < halfDayTimes.value.length; i++)
                TimeData(
                  punchTime: halfDayTimes.value[i],
                  startBreak: null,
                  endBreak: null,
                )
            ],
          ),
          leaveParams: LeaveParams(
            employeeId: selectedEmployeeData.value?.employeeId.toString(),
            createdBy: empId,
            companyId: selectedEmployeeData.value?.companyId.toString(),
            leaveReason: halfDayReasonText.value,
            appliedCount: "1",
            count: employeeLeaveData.value?.leaveBalance ?? '',
            remarks: '',
            halfDay: "1",
            isActive: "1",
            isExtraDuty: "0",
            isLeave: "1",
            isRegularization: '0',
            leaveApplied: employeeLeaveData.value?.leaveApplied ?? '',
            leaveDateFrom: selectedEmployeeData.value?.date,
            leaveDateTo: selectedEmployeeData.value?.date,
            leaveSection: selectedLeaveSession.value == LeaveSessionType.firstHalf ? "firstHalf" : "secondHalf",
            leaveTypeId: selectedLeaveType.value?.leaveTypeId,
            maximumLeaveLimit: selectedLeaveType.value?.maximumLeaveLimit,
            superiorEmployeeId: empId,
            totalLeaveDays: '0.5',
          ),
        );
        presentData = markHalfDayModel.toJson();
      } else if(editType.value?.type == EditAttType.absent) {
        presentData = {
          "status": "Absent",
          "employeeId": selectedEmployeeData.value?.employeeId.toString(),
          "employeeAttendanceId": selectedEmployeeData.value?.employeeDailyAttendanceId.toString(),
          "createdBy": empId,
        };
      } else if(editType.value?.type == EditAttType.fine) {
        presentData = {
          "status": "Fine",
          "employeeAttendanceId": selectedEmployeeData.value?.employeeDailyAttendanceId.toString(),
          "createdBy": empId,
          "employeeAttendanceDate": selectedEmployeeData.value?.date.toString() ?? '',
          "employeeId": selectedEmployeeData.value?.employeeId.toString(),
          "companyId": selectedEmployeeData.value?.companyId.toString(),
          "fine": [
            for (int i = 0; i < fineList.value.length; i++)
              {
                "deductionDetails": fineList[i].deductionDetails,
                "deductionType": fineType(fineList[i].deductionType),
                if(fineList[i].deductionDetails != "Miss Punch")
                  "deductionHours": fineList[i].deductionHours != null ? "${fineList[i].deductionHours}:00" : '',
                "deductionAmount": fineList[i].deductionAmount,
              },
          ]
        };
      } else if(editType.value?.type == EditAttType.overTime) {
        presentData = {
          "status": "Overtime",
          "employeeAttendanceId": selectedEmployeeData.value?.employeeDailyAttendanceId.toString(),
          "createdBy": empId,
          "employeeAttendanceDate": selectedEmployeeData.value?.date.toString() ?? '',
          "employeeId": selectedEmployeeData.value?.employeeId.toString(),
          "overtime": {
            "timeExtra": selectedOvertimeHour.value,
            "overtimeRate": fineType(selectedOvertimeRate.value),
            "overTimeAmount": selectedOvertimeAmount.value,
          }
        };
      } else if(editType.value?.type == EditAttType.paidLeave) {
        presentData = {
          "employeeId": selectedEmployeeData.value?.employeeId,
          "companyId": selectedEmployeeData.value?.companyId,
          "leaveDateFrom": selectedEmployeeData.value?.date,
          "leaveDateTo": selectedEmployeeData.value?.date,
          "totalLeaveDays": 1,
          "leaveTypeId": selectedLeaveType.value?.leaveTypeId,
          "leaveReason": halfDayReasonText.value,
          "appliedCount": 1,
          "count": employeeLeaveData.value?.leaveBalance,
          "isActive": 1,
          "isLeave": 1,
          "createdBy": empId,
          "halfDay": 0,
          "isRegularization": "0",
          "isExtraDuty": "0",
          "maximumLeaveLimit": selectedLeaveType.value?.maximumLeaveLimit,
          "leaveApplied": employeeLeaveData.value?.leaveApplied,
          "leaveSection": "",
          "superiorEmployeeId": empId,
          "remarks": ""
        };
      }

      var resp;

      if(editType.value?.type == EditAttType.paidLeave) {
        resp = await ApiServices.paidLeaveApply(data: presentData);
      } else {
        resp = await ApiServices.attendanceMarkPresent(data: presentData);
      }

      AttendanceCommonWidgets().printF("------mark present resp--------$resp");
      if(resp?['status']?.toString() == "200") {
        String formated = DateFormat('yyyy-MM-dd').format(dateList[currentDateIndex.value]);
        await fetchManagerAttSummary(date: formated);
        await fetchManagerAttDetails(date: formated);

        AttendanceCommonWidgets().showSnackBar(
          context: context,
          backgroundColor: Colors.green,
          message: resp['message'] ?? "Attendance status has been updated",
        );
        Navigator.of(context).pop();
      } else {
        AttendanceCommonWidgets().showSnackBar(
          context: context,
          backgroundColor: Colors.red,
          message: resp['message'] ?? "Something Went Wrong",
        );
      }

    } catch(e) {
      AttendanceCommonWidgets().printF("--------mark attendance error---------");
    } finally {

    }
  }

  void resetPunchValues() {
    addedTimeList.value = [
      AddTimeModel(
        type: CheckInType.punchAdd,
        isValidationSuccess: false,
        isValidationChecked: false,
      )
    ];
    fineList = <FineData>[
      for (int i = 0; i < fineTypes.length; i++)
        FineData(
          deductionDetails: fineTypes[i],
        ),
    ].obs;
    initFineDataControllers();
    isOffDay.value = false;
    showShiftValidation.value = false;
    showLeaveTypeValidation.value = false;
    showLeaveSessionValidation.value = false;
    showLeaveReasonValidation.value = false;
    showCheckInValidation.value = false;
    showCheckOutValidation.value = false;
    halfDayReasonText.value = '';
    showCheckInValidationMsg.value = '';
    showCheckOutValidationMsg.value = '';
    halfDayTimes.value = ['', ''];
    employeeShiftList.value = [];
    selectedShift.value = null;
    employeeAttendance.value = null;
    addedTimeList.refresh();
    showOverTimeHourValidation.value = false;
    showOverTimeRateValidation.value = false;
    showOverTimeAmountValidation.value = false;
    selectedOvertimeHour.value = '';
    selectedOvertimeRate.value = '';
    selectedOvertimeAmount.value = '';
    selectedOvertimeAmountController.clear();
    employeeLeaveData.value = null;
    selectedLeaveSession.value = LeaveSessionType.firstHalf;
  }

  RxBool isOffDay = false.obs;
  RxBool attSubmissionLoading = false.obs;
  RxBool attSubmissionLoaded = false.obs;
  RxBool attSubmissionError = false.obs;
  RxList<AddTimeModel> addedTimeList = [
    AddTimeModel(type: CheckInType.punchAdd, isValidationSuccess: false, isValidationChecked: false),
  ].obs;
  RxBool showShiftValidation = false.obs;
  RxBool showLeaveTypeValidation = false.obs;
  RxBool showLeaveSessionValidation = false.obs;
  RxBool showLeaveReasonValidation = false.obs;
  RxString halfDayReasonText = ''.obs;
  RxList<String> halfDayTimes = ['', ''].obs;
  RxBool showCheckInValidation = false.obs;
  RxString showCheckInValidationMsg = ''.obs;
  RxBool showCheckOutValidation = false.obs;
  RxString showCheckOutValidationMsg = ''.obs;
  RxList<FineData> fineList = <FineData>[].obs;
  RxBool showOverTimeHourValidation = false.obs;
  RxBool showOverTimeRateValidation = false.obs;
  RxBool showOverTimeAmountValidation = false.obs;
  RxString selectedOvertimeHour = ''.obs;
  RxString selectedOvertimeRate = ''.obs;
  RxString selectedOvertimeAmount = ''.obs;
  TextEditingController selectedOvertimeAmountController = TextEditingController();

  Future<void> validateAndSubmitAttendance(BuildContext context) async {
    attSubmissionLoading.value = true;
    attSubmissionLoaded.value = false;
    attSubmissionError.value = false;

    try {
      String compId = Get.find<UserProfileController>().currentCompany.value?.companyId?.toString() ?? Get.find<UserProfileController>().userData.value.result.companyId ?? '';
      String formattedDate = DateFormat('yyyy-MM').format(dateList.value[currentDateIndex.value]);
      final resp = await ApiServices.checkCompanyMonthPayoutList(
        compId: compId,
        monthYr: formattedDate,
      );
      PayoutStatusModel payoutStatusApi = PayoutStatusModel.fromJson(resp);
      for(final e in payoutStatusApi.result ?? []) {
        if(e.employeeId?.toString() == employeeAttendance.value?.employeeId?.toString()) {
          DateTime attendanceDate = DateTime.parse(employeeAttendance.value!.date!);
          DateTime lastPayout = DateTime.parse(e.payoutToDate!);
          if(attendanceDate.isBefore(lastPayout)) {
            AttendanceCommonWidgets().showSnackBar(
              context: context,
              backgroundColor: Colors.black,
              message: "Salary Already Processed",
            );
            return;
          }
        }
      }

      if(editType.value?.type == EditAttType.present) {
        if(isOffDay.value) {
          showShiftValidation.value = false;
        } else {
          if(selectedShift.value?.shiftId == null || (selectedShift.value?.shiftId.toString().isEmpty ?? true)) {
            showShiftValidation.value = true;
          } else {
            showShiftValidation.value = false;
          }
        }
        List<AddTimeModel> list = addedTimeList.value;
        for (int i = 0; i < list.length; i++) {
          if(list[i].type == CheckInType.punchAdd) {
            if(list[i].time1 == null) {
              if (isOffDay.value) {
                addedTimeList[i].isValidationSuccess = true;
                addedTimeList[i].isAbovePrev = false;
              } else {
                addedTimeList[i].isValidationSuccess = false;
              }
            } else {
              addedTimeList[i].isValidationSuccess = true;
              if(i != 0) {
                try {
                  DateFormat format = DateFormat("HH:mm");
                  DateTime dateTime1;
                  if(addedTimeList[i - 1].type == CheckInType.breakAdd) {
                    dateTime1 = format.parse(addedTimeList[i - 1].time2!);
                  } else {
                    dateTime1 = format.parse(addedTimeList[i - 1].time1!);
                  }
                  DateTime dateTime2 = format.parse(addedTimeList[i].time1!);

                  if (dateTime2.isAfter(dateTime1)) {
                    addedTimeList[i].isAbovePrev = false;
                  } else {
                    addedTimeList[i].isAbovePrev = true;
                  }
                } catch(e) {}
              }
            }
            addedTimeList[i].isValidationChecked = true;
          } else {
            if(list[i].time1 == null) {
              if (isOffDay.value) {
                addedTimeList[i].isValidationSuccess = true;
              } else {
                addedTimeList[i].isValidationSuccess = false;
              }
            } else {
              addedTimeList[i].isValidationSuccess = true;
              try {
                DateFormat format = DateFormat("HH:mm");
                DateTime dateTime1;
                if(addedTimeList[i - 1].type == CheckInType.breakAdd) {
                  dateTime1 = format.parse(addedTimeList[i - 1].time2!);
                } else {
                  dateTime1 = format.parse(addedTimeList[i - 1].time1!);
                }
                DateTime dateTime2 = format.parse(addedTimeList[i].time1!);

                if (dateTime2.isAfter(dateTime1)) {
                  addedTimeList[i].isAbovePrevBreak1 = false;
                } else {
                  addedTimeList[i].isAbovePrevBreak1 = true;
                }
              } catch(e) {}
            }
            if(list[i].time2 == null) {
              if (isOffDay.value && list[i].time1 == null) {
                addedTimeList[i].isValidationSuccessBreak2 = true;
              } else {
                addedTimeList[i].isValidationSuccessBreak2 = false;
              }
            } else {
              addedTimeList[i].isValidationSuccessBreak2 = true;
              try {
                DateFormat format = DateFormat("HH:mm");
                DateTime dateTime1 = format.parse(addedTimeList[i].time1!);
                DateTime dateTime2 = format.parse(addedTimeList[i].time2!);

                if (dateTime2.isAfter(dateTime1)) {
                  addedTimeList[i].isAbovePrevBreak2 = false;
                } else {
                  addedTimeList[i].isAbovePrevBreak2 = true;
                }
              } catch(e) {}
            }
            addedTimeList[i].isValidationChecked = true;
          }
        }
        addedTimeList.refresh();

        bool submit = addedTimeList.value.every((time) {
          if(time.type == CheckInType.punchAdd) {
            return (time.isValidationSuccess && time.isValidationChecked && !(time.isAbovePrev ?? false));
          } else {
            return (time.isValidationChecked && time.isValidationSuccess && (time.isValidationSuccessBreak2 ?? false) && !(time.isAbovePrevBreak1 ?? false) && !(time.isAbovePrevBreak2 ?? false));
          }
        });

        bool shiftValid = isOffDay.value ? true : !(selectedShift.value?.shiftId == null || (selectedShift.value?.shiftId.toString().isEmpty ?? true));

        if(submit && shiftValid) {
          await submitEditedAttendance(context);
        }
      } else if(editType.value?.type == EditAttType.halfDay) {
        if(selectedShift.value?.shiftId == null || (selectedShift.value?.shiftId.toString().isEmpty ?? true)) {
          showShiftValidation.value = true;
        } else {
          showShiftValidation.value = false;
        }
        if(halfDayTimes.value.first.trim().isEmpty) {
          showCheckInValidation.value = true;
          showCheckInValidationMsg.value = "Check In Time is required";
        } else {
          showCheckInValidation.value = false;
          showCheckInValidationMsg.value = '';
        }
        if(halfDayTimes.value.last.trim().isEmpty) {
          showCheckOutValidation.value = true;
          showCheckOutValidationMsg.value = "Check Out Time is required";
        } else {
          showCheckOutValidation.value = false;
          showCheckOutValidationMsg.value = '';
        }

        try {
          DateFormat format = DateFormat("HH:mm");
          DateTime dateTime1 = format.parse(halfDayTimes.first);
          DateTime dateTime2 = format.parse(halfDayTimes.last);

          if (dateTime2.isAfter(dateTime1)) {
            showCheckOutValidation.value = false;
            showCheckOutValidationMsg.value = "Check Out Time is required";
          } else {
            showCheckOutValidation.value = true;
            showCheckOutValidationMsg.value = "Check Out Time must be greater than check in time";
          }
        } catch(e) {}

        if(selectedLeaveType.value?.leaveTypeId == null || (selectedLeaveType.value?.leaveTypeId.toString().isEmpty ?? true)) {
          showLeaveTypeValidation.value = true;
        } else {
          showLeaveTypeValidation.value = false;
        }
        if(halfDayReasonText.value.trim().isEmpty) {
          showLeaveReasonValidation.value = true;
        } else {
          showLeaveReasonValidation.value = false;
        }

        bool submit = !showShiftValidation.value
            && !showCheckInValidation.value
            && !showCheckOutValidation.value
            && !showLeaveTypeValidation.value
            && !showLeaveReasonValidation.value;

        if(submit) {
          await submitEditedAttendance(context);
        }
      } else if(editType.value?.type == EditAttType.absent) {
        await submitEditedAttendance(context);
      } else if(editType.value?.type == EditAttType.fine) {
        final appliedFines = fineList.where((fine) => fine.isFineApplied ?? false).toList();

        bool submit = appliedFines.isNotEmpty &&
            appliedFines.every((fine) =>
            (fine.deductionHours != null || fine.deductionDetails == "Miss Punch") &&
                fine.deductionType != null &&
                fine.deductionAmount != null);
        if(submit) {
          await submitEditedAttendance(context);
        } else {
          AttendanceCommonWidgets().showSnackBar(
            context: context,
            backgroundColor: Colors.red,
            message: "Please add fine",
          );
        }
      } else if(editType.value?.type == EditAttType.overTime) {
        if(selectedOvertimeHour.value.isEmpty) {
          showOverTimeHourValidation.value = true;
        } else {
          showOverTimeHourValidation.value = false;
        }
        if(selectedOvertimeRate.value.isEmpty) {
          showOverTimeRateValidation.value = true;
        } else {
          showOverTimeRateValidation.value = false;
        }
        if(selectedOvertimeAmount.value.isEmpty) {
          showOverTimeAmountValidation.value = true;
        } else {
          showOverTimeAmountValidation.value = false;
        }

        bool submit = !showOverTimeHourValidation.value && !showOverTimeRateValidation.value && !showOverTimeAmountValidation.value;

        if(submit) {
          await submitEditedAttendance(context);
        }
      } else if(editType.value?.type == EditAttType.paidLeave) {
        if(selectedLeaveType.value?.leaveTypeId == null || (selectedLeaveType.value?.leaveTypeId.toString().isEmpty ?? true)) {
          showLeaveTypeValidation.value = true;
        } else {
          showLeaveTypeValidation.value = false;
        }
        if(halfDayReasonText.value.trim().isEmpty) {
          showLeaveReasonValidation.value = true;
        } else {
          showLeaveReasonValidation.value = false;
        }

        bool submit = !showLeaveTypeValidation.value && !showLeaveReasonValidation.value;

        if(submit) {
          await submitEditedAttendance(context);
        }
      }
      attSubmissionLoaded.value = true;
    } catch(e) {
      attSubmissionError.value = true;
    } finally {
      attSubmissionLoading.value = false;
    }
  }

  String? fineType(String? title) {
    switch(title) {
      case "Fixed": return "fixedAmount";
      case "Quarter Day": return "quarterDay";
      case "Half Day": return "halfDay";
      case "Full Day": return "fullDay";
      case "Pardon": return "pardon";
      case "Per Minute": return "perMinute";
      case "Fixed Amount": return "fixedAmount";
      case "1 x Salary": return "1xSalary";
      case "1.5 x Salary": return "1.5xSalary";
      case "2 x Salary": return "2xSalary";
      default: return null;
    }
  }

  String? fineTypeReverse(String? title) {
    switch(title) {
      // case "fixedAmount": return "Fixed";
      case "fixedAmount":
        if (savedEditType.value?.type == EditAttType.overTime) {
          return "Fixed Amount";
        } else {
          return "Fixed";
        }
      case "quarterDay": return "Quarter Day";
      case "halfDay": return "Half Day";
      case "fullDay": return "Full Day";
      case "pardon": return "Pardon";
      case "perMinute": return "Per Minute";
      case "1xSalary": return "1 x Salary";
      case "1.5xSalary": return "1.5 x Salary";
      case "2xSalary": return "2 x Salary";
      default: return null;
    }
  }

  RxBool showHoursValidation = false.obs;
  RxBool showDeductionTypeValidation = false.obs;
  RxBool showDeductionAmountValidation = false.obs;

  void resetDeductionValues() {
    showHoursValidation.value = false;
    showDeductionTypeValidation.value = false;
    showDeductionAmountValidation.value = false;
  }

  bool validateFine(String fineType) {
    for (var fine in fineList.value) {
      if (fine.deductionDetails == fineType) {
        if(fine.deductionHours == null) {
          showHoursValidation.value = true;
        } else {
          showHoursValidation.value = false;
        }
        if(fine.deductionType == null) {
          showDeductionTypeValidation.value = true;
        } else {
          showDeductionTypeValidation.value = false;
        }
        if(fine.deductionAmount == null && (fine.deductionType == "Fixed" || !Get.find<UserAuthController>().restrictRsInfo.value)) {
          showDeductionAmountValidation.value = true;
        } else {
          showDeductionAmountValidation.value = false;
        }
        if(fine.deductionDetails == "Miss Punch") {
          return !showDeductionTypeValidation.value && !showDeductionAmountValidation.value;
        } else {
          return !showHoursValidation.value && !showDeductionTypeValidation.value && !showDeductionAmountValidation.value;
        }
      }
    }
    return false;
  }

  final Map<String, TextEditingController> amountControllers = {};

  void initFineDataControllers() {
    for (var fine in fineList) {
      amountControllers[fine.deductionDetails ?? ''] = TextEditingController(text: fine.deductionAmount);
    }
  }

  @override
  void onClose() {
    for (var c in amountControllers.values) {
      c.dispose();
    }
    super.onClose();
  }
}

class FilterModel {
  final String filterTitle;
  bool isExpanded;
  List<Filters> filters;

  FilterModel({required this.filterTitle, required this.filters, required this.isExpanded});
}

class Filters {
  final String id;
  bool isSelected;
  final String name;

  Filters({required this.id, required this.name, required this.isSelected});
}

class DatePickModel {
  final int day;
  final String weak;

  const DatePickModel({required this.day, required this.weak});
}

enum CheckInType {punchAdd, breakAdd}

class AddTimeModel {
  String? time1;
  String? time2;
  final CheckInType type;
  bool isValidationSuccess;
  bool? isValidationSuccessBreak2;
  bool isValidationChecked;
  bool? isAbovePrev;
  bool? isAbovePrevBreak1;
  bool? isAbovePrevBreak2;

  AddTimeModel({
    this.time1,
    this.time2,
    required this.type,
    required this.isValidationSuccess,
    required this.isValidationChecked,
    this.isValidationSuccessBreak2,
    this.isAbovePrev,
    this.isAbovePrevBreak1,
    this.isAbovePrevBreak2,
  });
}