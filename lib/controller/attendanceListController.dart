
import 'dart:async';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/controller/leaveTypeController.dart';
import 'package:loyaltri_minimal/controller/userAuthentication.dart';
import 'package:loyaltri_minimal/models/detailed_attendance_api_model.dart';
import 'package:loyaltri_minimal/models/leave_type_api_model.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/manager_attendance_controller/manager_attendance_controller.dart';
import '../models/attendance_details_api_model.dart';
import '../models/checkIn_model.dart';
import '../services/api_services.dart';
import '../sqflite_db/punch_db.dart';

class AttendanceList extends GetxController {
  Rx<bool> isLoading = false.obs;
  Rx<bool> detailsLoading = false.obs;
  Rx<bool> dataLoaded = false.obs;
  Rx<bool> isError = false.obs;
  late Rx<AttendanceApiModel> attendanceList = AttendanceApiModel().obs;
  late RxList<Attendance> attendancePerMonth = <Attendance>[].obs;
  late RxList<Attendance> filteredAttendancePerMonth = <Attendance>[].obs;
  RxList<AttendanceFilterTypes> selectedFilters = <AttendanceFilterTypes>[].obs;
  Rx<String> changedMonth = "".obs;
  Rx<DetailedAttendanceApiModel> attendanceDetail = DetailedAttendanceApiModel().obs;

  void resetStatus() {
    isLoading.value = false;
    isError.value = false;
  }

  void filterAttendanceDetails({required AttendanceFilterTypes type}) {
    if (selectedFilters.contains(type)) {
      selectedFilters.remove(type);
    } else {
      selectedFilters.add(type);
    }
    applyFilters();
  }

  void applyFilters() {
    if (selectedFilters.isEmpty) {
      filteredAttendancePerMonth.value = List.from(attendancePerMonth);
    } else {
      filteredAttendancePerMonth.value = attendancePerMonth.where((item) {
        return selectedFilters.any((filter) => _matchesAttendanceFilter(item, filter));
      }).toList();
    }
    filteredAttendancePerMonth.refresh();
  }

  bool _matchesAttendanceFilter(Attendance item, AttendanceFilterTypes filter) {
    String status = item.status?.toLowerCase().trim() ?? '';
    switch (filter) {
      case AttendanceFilterTypes.present:
        return status == 'present';
      case AttendanceFilterTypes.absent:
      case AttendanceFilterTypes.unpaidLeave:
        return status == 'absent' || (item.isPaidLeave?.toString() != '1' && item.isLeave == '1');
      case AttendanceFilterTypes.halfDay:
        return item.isHalfDay?.toString() == '1';
      case AttendanceFilterTypes.offDay:
        return item.isOffDay?.toString() == '1' || status == 'offday';
      case AttendanceFilterTypes.holiday:
        return item.isHoliday?.toString() == '1' || status == 'holiday';
      case AttendanceFilterTypes.paidLeave:
        return item.isPaidLeave?.toString() == '1' || status == 'paid leave';
      case AttendanceFilterTypes.overtime:
        return item.isOverTime?.toString() == '1' || (item.overTimeData != null);
      case AttendanceFilterTypes.fine:
        return item.isFineToRegularize?.toString() == '1';
      default:
        return true;
    }
  }

  Future fetchAttendanceList({required String empId, required String compId}) async {
    isLoading.value = true;
    dataLoaded.value = false;
    attendancePerMonth.value = [];
    filteredAttendancePerMonth.value = [];
    try {
      if(changedMonth.value == "") {
        if(monthString.isNotEmpty) {
          DateTime date = DateFormat.yMMM().parse(monthString[0]);
          changedMonth.value = DateFormat('yyyy-MM').format(date);
        }
      }
      Map<String, dynamic> resp = await ApiServices.getAttendanceList(empId: empId, compId: compId, yrMonth: changedMonth.value);
      attendanceList.value = AttendanceApiModel.fromJson(resp);
      if (attendanceList.value.status == 200) {
        // await fetchDataPerMonth(selectedData: DateTime.now());
        attendancePerMonth.value = attendanceList.value.result ?? [];
        applyFilters();
        dataLoaded.value = true;
      }
    } catch(e) {
      isError.value = true;
      AttendanceCommonWidgets().printF("------attendance list error-------${e.toString()}");
    } finally {
      await getDebData(month: changedMonth.value.split("-")[1], year: changedMonth.value.split("-")[0]);
      resetStatus();
    }
  }

  RxList<String> monthString = List.generate(11, (index) {
    DateTime currentDate = DateTime.now();
    DateTime targetDate = DateTime(currentDate.year, currentDate.month - 10 + index, 1);
    String formattedDate = DateFormat.yMMM().format(targetDate);
    return formattedDate;
  }).reversed.toList().obs;

  Future fetchMonthCycleData({required String compId}) async {
    try {
      Map<String, dynamic> resp = await ApiServices.getCycleMonth(compId: compId, currentData: DateFormat('yyyy-MM-dd').format(DateTime.now()));
      String? month = resp['result']?['cycleMonthYear']?.toString();
      if (month != null && month.isNotEmpty) {
        DateTime date = DateTime.parse("$month-01");
        monthString.value = List.generate(11, (index) {
          DateTime targetDate = DateTime(date.year, date.month - 10 + index, 1);
          String formattedDate = DateFormat.yMMM().format(targetDate);
          return formattedDate;
        }).reversed.toList();
      }
    } catch(e) {
      AttendanceCommonWidgets().printF("------cycle month error-------${e.toString()}");
    } finally {

    }
  }

  Future<void> getDebData({required String month, required String year}) async {
    try {
      List<AttendanceCheckModel> punchData = await PunchDatabase.instance.readAllPunchData();
      List<AttendanceCheckModel> punchInAndOut = [];

      if(dataLoaded.value) {
        punchInAndOut = punchData.where((element) {
          if(element.isSynced == 0 && (element.punchState == "punchIn" || element.punchState == "punchOut") && month == element.punchDate.split("-")[1] && year == element.punchDate.split("-")[0]) {
            return true;
          }
          return false;
        }).toList();
      } else {
        punchInAndOut = punchData.where((element) {
          if((element.punchState == "punchIn" || element.punchState == "punchOut") && month == element.punchDate.split("-")[1] && year == element.punchDate.split("-")[0]) {
            return true;
          }
          return false;
        }).toList();
      }

      for (int i = 0; i < punchInAndOut.length; i++) {
        DateTime dateTime = DateTime.parse("${punchInAndOut[i].punchDate} ${punchInAndOut[i].punchTime}");
        bool isNotSync = punchInAndOut[i].isSynced == 0;

        if(attendancePerMonth.isNotEmpty && attendancePerMonth.first.date == punchInAndOut[i].punchDate && attendancePerMonth.first.dbId1 != null) {
          isNotSync = attendancePerMonth.first.isNotSync ?? false;
          isNotSync = isNotSync ? true : punchInAndOut[i].isSynced == 0;

          if(attendancePerMonth.first.punchState == "punchIn" && punchInAndOut[i].punchState == "punchOut") {

            attendancePerMonth.value[0] = Attendance(
              date: punchInAndOut[i].punchDate,
              firstCheckInTime: attendancePerMonth.first.firstCheckInTime,
              lastCheckOutTime: DateFormat("hh:mm a").format(dateTime),
              status: isNotSync ? "Pending" : "Present",
              isNotSync: isNotSync,
              punchState: punchInAndOut[i].punchState,
              dbId1: attendancePerMonth.first.dbId1,
              dbId2: punchInAndOut[i].id,
            );

            String? startTime = attendancePerMonth.first.date != null && attendancePerMonth.first.date != "" && attendancePerMonth.first.firstCheckInTime != null && attendancePerMonth.first.firstCheckInTime != ""
                ? '${attendancePerMonth.first.date} ${attendancePerMonth.first.firstCheckInTime}'
                : null;

            String? endTime = attendancePerMonth.first.date != null && attendancePerMonth.first.date != "" && attendancePerMonth.first.lastCheckOutTime != null && attendancePerMonth.first.lastCheckOutTime != ""
                ? '${attendancePerMonth.first.date} ${attendancePerMonth.first.lastCheckOutTime}'
                : null;

            String? totalDuration;

            if (startTime != null && endTime != null) {
              Duration? duration = calculateDuration(startTime, endTime);
              if (duration != null) {
                totalDuration = formatDuration(duration);
                AttendanceCommonWidgets().printF(formatDuration(duration));
              } else {
                AttendanceCommonWidgets().printF("Invalid time format");
              }
            }

            attendancePerMonth.value[0].totalWorkHours = totalDuration;

          } else if(attendancePerMonth.first.punchState == "punchOut" && punchInAndOut[i].punchState == "punchIn") {
            isNotSync = attendancePerMonth.first.isNotSync ?? false;
            isNotSync = isNotSync ? true : punchInAndOut[i].isSynced == 0;

            attendancePerMonth.value[0] = Attendance(
              date: attendancePerMonth.first.date,
              firstCheckInTime: attendancePerMonth.first.firstCheckInTime,
              lastCheckOutTime: attendancePerMonth.first.lastCheckOutTime,
              totalWorkHours: attendancePerMonth.first.totalWorkHours,
              status: isNotSync ? "Pending" : "Present",
              isNotSync: isNotSync,
              punchState: punchInAndOut[i].punchState,
              dbId1: attendancePerMonth.first.dbId1,
              dbId2: punchInAndOut[i].id,
            );
          }
        } else {
          attendancePerMonth.value.insert(0,
            Attendance(
              date: punchInAndOut[i].punchDate,
              firstCheckInTime: punchInAndOut[i].punchState == "punchIn" ? DateFormat("hh:mm a").format(dateTime) : "",
              lastCheckOutTime: punchInAndOut[i].punchState == "punchOut" ? DateFormat("hh:mm a").format(dateTime) : "",
              status: punchInAndOut[i].isSynced == 0 ? "Pending" : "Present",
              punchState: punchInAndOut[i].punchState,
              isNotSync: punchInAndOut[i].isSynced == 0,
              dbId1: punchInAndOut[i].id,
            ),
          );
        }
      }

      attendancePerMonth.removeWhere((element) => (element.isNotSync ?? true) == false);
      attendancePerMonth.refresh();
      applyFilters();
    } catch(e) {
      AttendanceCommonWidgets().printF("-----attendance list db error-------");
      throw Exception(e.toString());
    }
  }

  Duration? calculateDuration(String startTime, String endTime) {
    try {
      DateFormat format = DateFormat("yyyy-MM-dd hh:mm a");
      DateTime start = format.parse(startTime);
      DateTime end = format.parse(endTime);

      return end.difference(start);
    } catch (e) {
      AttendanceCommonWidgets().printF("Error parsing date: $e");
      return null;
    }
  }

  String formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    return "${hours.toString().padLeft(2, '0')}h ${minutes.toString().padLeft(2, '0')}m";
  }

  Future fetchDataPerMonth({required DateTime selectedData}) async {
    isLoading.value = true;
    List<Attendance> selectedMonthAttendance = [];
    try {
      String date = DateFormat('yyyy-MM-dd').format(selectedData);
      List<String> dateParts = date.split('-');

      int year = int.parse(dateParts[0]);
      int month = int.parse(dateParts[1]);

      for(int i = 0; i < (attendanceList.value.result?.length ?? 0); i++) {
        if (year == int.parse(attendanceList.value.result![i].date!.split('-')[0]) &&
            month == int.parse(attendanceList.value.result![i].date!.split('-')[1])) {
          selectedMonthAttendance.add(attendanceList.value.result![i]);
        }
      }
      attendancePerMonth.value = selectedMonthAttendance;
      isLoading.value = false;
    } catch(e) {
      isError.value = true;
      AttendanceCommonWidgets().printF("------attendance per month error-------${e.toString()}");
    } finally {
      resetStatus();
    }
  }

  Future<void> fetchAttendanceDetails({required String attId, required String empId}) async {
    detailsLoading.value = true;
    attendanceDetail.value = DetailedAttendanceApiModel();
    try {
      Map<String, dynamic> resp = await ApiServices.getAttendanceDetails(empId: empId, attId: attId);
      if (resp['status'] == 200) {
        attendanceDetail.value = DetailedAttendanceApiModel.fromJson(resp);
      }
    } catch(e) {
      AttendanceCommonWidgets().printF("------attendance detail error-------${e.toString()}");
    } finally {
      detailsLoading.value = false;
      // resetStatus();
    }
  }

  Rxn<Deduction> attendanceDeductionDetails = Rxn(null);
  RxBool deductionLoading = false.obs;
  RxBool deductionToggle = false.obs;
  Rxn<LeaveType> selectedLeave = Rxn(null);

  Future<void> fetchDeductionDetails({String? attendanceId, String? shiftId, String? type}) async {
    try {
      attendanceDeductionDetails.value = null;
      selectedLeave.value = null;
      deductionLoading.value = true;
      final resp = await ApiServices.getRegularizingEmployeeDetail(attId: attendanceId, shiftId: shiftId);
      log('--------resp-------${resp.toString()}');
      if(resp?['status']?.toString() == '200') {
        RegularizationResponse regularizationResponse = RegularizationResponse.fromJson(resp);
        List<Deduction> deductions = regularizationResponse.result?.deductions?.where((dds) => dds.deductionDetails == type).toList() ?? [];
        if(deductions.isNotEmpty) {
          attendanceDeductionDetails.value = deductions.first;
          DateTime parsedDateTime = DateFormat('yyyy-MM-dd').parse(attendanceDeductionDetails.value?.deductionDate ?? '');
          String formatted = DateFormat('yyyy-MM').format(parsedDateTime);
          await Get.find<LeaveTypeController>().getLeaveTypeForRegularization(
              monthYr: formatted,
              empId: regularizationResponse.result?.employeeId?.toString() ?? '',
              regType: attendanceDeductionDetails.value?.deductionDetails ?? '',
          );
        }
      }
    } catch(e) {} finally {
      deductionLoading.value = false;
    }
  }
}