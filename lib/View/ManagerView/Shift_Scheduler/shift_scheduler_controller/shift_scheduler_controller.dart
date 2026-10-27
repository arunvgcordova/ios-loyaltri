import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/controller/userAuthentication.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';
import 'package:loyaltri_minimal/models/manager/shift_scheduler_department.dart';
import 'package:loyaltri_minimal/models/manager/shift_scheduler_employee.dart';
import 'package:loyaltri_minimal/models/manager/shift_scheduler_scheme.dart';
import 'package:loyaltri_minimal/services/api_services.dart';

class ShiftSchedulerController extends GetxController {
  // Observable track for the start date of the current visible range
  final Rx<DateTime> currentWeekStart = DateTime.now().obs;

  RxList<ShiftSchemeData> shiftSchemes = <ShiftSchemeData>[].obs;
  RxList<DepartmentData> departments = <DepartmentData>[].obs;
  RxList<ShiftData> allShifts = <ShiftData>[].obs;
  RxList<ShiftSchedulerEmployee> employees = <ShiftSchedulerEmployee>[].obs;

  RxList<ShiftSchemeData> selectedSchemes = <ShiftSchemeData>[].obs;
  RxList<DepartmentData> selectedDepartments = <DepartmentData>[].obs;

  RxBool isLoading = false.obs;
  RxBool isFilterLoading = false.obs;
  RxBool isFilterApplied = false.obs;

  @override
  void onInit() {
    super.onInit();
    _setToStartOfWeek();
  }

  void _setToStartOfWeek() {
    DateTime now = DateTime.now();
    currentWeekStart.value = DateTime(now.year, now.month, now.day);
  }

  Future<void> fetchInitialData() async {
    isFilterLoading.value = true;
    isLoading.value = true;
    selectedSchemes.value = [];
    departments.value = [];
    allShifts.value = [];
    try {
      String companyId = Get.find<UserProfileController>().currentCompany.value?.companyId?.toString() ?? Get.find<UserProfileController>().userData.value.result.companyId ?? '';
      
      try {
        var schemesResponse = await ApiServices.getShiftSchemes(companyId: companyId);
        var schemesResult = ShiftSchedulerSchemeResponse.fromJson(schemesResponse);
        if (schemesResult.result != null) {
          shiftSchemes.value = schemesResult.result!;
          if (shiftSchemes.isNotEmpty) {
            selectedSchemes.value = [shiftSchemes.first];
          }
        }
      } catch(e) {}

      try {
        var depResponse = await ApiServices.getDepartments(companyId: companyId);
        var depResult = ShiftSchedulerDepartmentResponse.fromJson(depResponse);
        if (depResult.result != null) {
          departments.value = depResult.result!;
        }
      } catch(e) {}

      // try {
      //   var shiftsResponse = await ApiServices.getAllShiftEmployee(compId: companyId);
      //   var shiftsResult = EmployeeShiftModel.fromJson(shiftsResponse);
      //   if (shiftsResult.result != null) {
      //     allShifts.value = shiftsResult.result!;
      //   }
      // } catch(e) {}

      await fetchEmployees();

    } catch (e) {
      debugPrint("Error fetching initial data: $e");
    } finally {
      isLoading.value = false;
      isFilterLoading.value = false;
    }
  }

  Future<void> fetchEmployees() async {
    if (selectedSchemes.isEmpty) return;
    isLoading.value = true;
    try {
      String companyId = Get.find<UserProfileController>().currentCompany.value?.companyId?.toString() ?? Get.find<UserProfileController>().userData.value.result.companyId ?? '';
      String empId = Get.find<UserAuthController>().userData.value.userData?.employeeId ?? '';

      DateTime endOfWeek = currentWeekStart.value.add(const Duration(days: 6));
      String startDate = DateFormat('yyyy-MM-dd').format(currentWeekStart.value);
      String endDate = DateFormat('yyyy-MM-dd').format(endOfWeek);

      List<int?>? depId;
      if (selectedDepartments.isNotEmpty) {
        depId = selectedDepartments
            .map((e) => e.departmentId)
            .where((element) => element != null)
            .toList();
      }

      List<int?> schemeIds = selectedSchemes
          .map((e) => e.shiftSchemeId)
          .where((element) => element != null)
          .toList();

      var response = await ApiServices.getShiftSchedulerEmployees(
        shiftSchemeId: schemeIds,
        startDate: startDate,
        endDate: endDate,
        companyId: companyId,
        superiorEmployeeId: empId,
        departmentId: depId,
      );

      var empResult = ShiftSchedulerEmployeeResponse.fromJson(response);
      if (empResult.result != null) {
        employees.value = empResult.result!;
      } else {
        employees.value = [];
      }

      try {
        allShifts.value = selectedSchemes.value
            .expand((element) => element.shiftData ?? <ShiftData>[])
            .toList();
      } catch(e) {}
    } catch (e) {
      debugPrint("Error fetching employees: $e");
      employees.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  ShiftSchedulerEmployee? selectedEmployee;
  RxBool showButtonLoading = false.obs;

  Future<ShiftSchedulerEmployeeResponse?> saveRosterShiftScheduler() async {
    try {
      showButtonLoading.value = true;
      String companyId = Get.find<UserProfileController>().currentCompany.value?.companyId?.toString() ?? Get.find<UserProfileController>().userData.value.result.companyId ?? '';
      String empId = Get.find<UserAuthController>().userData.value.userData?.employeeId ?? '';
      List<String?> shiftIds = allShifts.value.where((element) => element.isSelected && element.shiftId != null).toList().map((e) => e.shiftId).toList();
      var savedResponse = await ApiServices.saveRosterShiftScheduler(
          compId: companyId,
          empId: empId,
          assignedTo: selectedEmployee?.employeeId ?? '',
          schemeId: selectedSchemes.first.shiftSchemeId?.toString() ?? '',
          date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
          shiftId: shiftIds,
      );
      await fetchEmployees();
      showButtonLoading.value = false;
      return ShiftSchedulerEmployeeResponse(status: savedResponse['status'], message: savedResponse['message']);
    } catch(e) {
      debugPrint("Error saving shift: $e");
      showButtonLoading.value = false;
      return ShiftSchedulerEmployeeResponse(status: 0, message: 'Something went wrong.');
    }
  }

  void updateFiltersAndFetch(List<ShiftSchemeData> schemes, List<DepartmentData> deps) {
    bool hasChanged = false;

    // Check if schemes changed
    List<int> oldSchemeIds = selectedSchemes.map((s) => s.shiftSchemeId ?? 0).toList()..sort();
    List<int> newSchemeIds = schemes.map((s) => s.shiftSchemeId ?? 0).toList()..sort();

    if (oldSchemeIds.toString() != newSchemeIds.toString()) {
      selectedSchemes.value = schemes;
      hasChanged = true;
    }
    
    // Check if departments changed
    List<int> oldDepIds = selectedDepartments.map((d) => d.departmentId ?? 0).toList()..sort();
    List<int> newDepIds = deps.map((d) => d.departmentId ?? 0).toList()..sort();
    
    if (oldDepIds.toString() != newDepIds.toString()) {
      selectedDepartments.value = deps;
      hasChanged = true;
    }

    // Check if filter is applied (default is only first scheme selected and no departments)
    bool isDefaultScheme = selectedSchemes.length == 1 &&
        shiftSchemes.isNotEmpty &&
        selectedSchemes.first.shiftSchemeId == shiftSchemes.first.shiftSchemeId;
    
    if (!isDefaultScheme || selectedDepartments.isNotEmpty) {
      isFilterApplied.value = true;
    } else {
      isFilterApplied.value = false;
    }
    
    if (hasChanged) {
      fetchEmployees();
    }
  }

  void nextWeek() {
    currentWeekStart.value = currentWeekStart.value.add(const Duration(days: 7));
    fetchEmployees();
  }

  void previousWeek() {
    currentWeekStart.value = currentWeekStart.value.subtract(const Duration(days: 7));
    fetchEmployees();
  }

  // Generate the 7 days starting from currentWeekStart
  List<DateTime> get currentWorkingDays {
    return List.generate(7, (index) => currentWeekStart.value.add(Duration(days: index)));
  }

  // Formats the header label string, e.g., "Sep 1 - 7    2026"
  String get weekDateRangeLabel {
    DateTime start = currentWeekStart.value;
    DateTime end = start.add(const Duration(days: 6)); // End of full week (Sunday)
    
    String startMonth = DateFormat('MMM').format(start);
    String endMonth = DateFormat('MMM').format(end);
    String yearStr = DateFormat('yyyy').format(start);
    
    // Check if the week spans across different months
    if (start.month == end.month) {
      return '$startMonth ${start.day} - ${end.day}    $yearStr';
    } else {
      return '$startMonth ${start.day} - $endMonth ${end.day}    $yearStr';
    }
  }

  // Pre-formatted day names (Mon, Tue...) and dates (16, 17...) for the UI grid
  List<Map<String, dynamic>> get formattedGridDates {
    DateTime now = DateTime.now();
    return currentWorkingDays.map((date) {
      bool isToday = date.year == now.year && date.month == now.month && date.day == now.day;
      return {
        'day': DateFormat('EEE').format(date),
        'date': DateFormat('d').format(date),
        'dateRaw': date,
        'isToday': isToday,
      };
    }).toList();
  }
}
