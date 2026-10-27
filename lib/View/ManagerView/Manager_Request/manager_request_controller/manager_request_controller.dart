import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/ManagerView/Employee_Leave/employee_leave_controller/employee_leave_controller.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';
import 'package:loyaltri_minimal/models/manager/employee_excuseList_model.dart';
import 'package:loyaltri_minimal/models/manager/punch_approval_list_model.dart';
import 'package:loyaltri_minimal/models/manager/wfh_lr_list_model.dart';
import 'package:loyaltri_minimal/services/api_services.dart';
import 'package:loyaltri_minimal/utils/api_constants.dart';

import '../../../../models/manager/deduction_details_model.dart';
import '../../../../models/manager/leave_request_list_model.dart';
import '../../../../utils/color_utils.dart';

enum RequestType {excuse, punchApproval, overtime, wfh, letterRequest, leaveRequest, bulkApproval}

enum SubmissionType {pardon, fine, approve, reject, wfh, lr}

enum RequestFilterTypes {approved, rejected, pending}

class ManagerRequestController extends GetxController {
  RxInt currentTabIndex = 0.obs;
  RxInt currentMonthIndex = 10.obs;
  RxList<SelectedFileData> letterRequestFiles = <SelectedFileData>[].obs;
  RxString searchText = "".obs;
  TextEditingController reasonController = TextEditingController();
  TextEditingController remarksController = TextEditingController();
  RxList<FilterDetails> filters = List.generate(6, (index) => FilterDetails(filter: RequestFilterTypes.pending, tabIndex: index)).obs;
  List<RequestFilterTypes> availableFilters = [
    RequestFilterTypes.pending,
    RequestFilterTypes.approved,
    RequestFilterTypes.rejected
  ];

  void changeFilter(int index) {
    if(index == 0) {
      filters.value[currentTabIndex.value].filter = RequestFilterTypes.pending;
    } else if(index == 1) {
      filters.value[currentTabIndex.value].filter = RequestFilterTypes.approved;
    } else if(index == 2) {
      filters.value[currentTabIndex.value].filter = RequestFilterTypes.rejected;
    }
    filters.refresh();
  }

  List<String> monthString = List.generate(21, (index) {
    DateTime currentDate = DateTime.now();

    DateTime targetDate = DateTime(
      currentDate.year,
      currentDate.month - (index - 10),
      1,
    );

    String formattedDate = DateFormat('MMM, yyyy').format(targetDate);

    return formattedDate;
  });

  void resetValues() {
    currentTabIndex.value = 0;
    currentMonthIndex.value = 10;
    letterRequestFiles.clear();
  }

  RxBool excuseLoading = false.obs;
  RxBool excuseLoaded = false.obs;
  RxBool excuseError = false.obs;
  RxBool excuseShimmerloading = false.obs;
  RxList<ExcuseData> excuseList = <ExcuseData>[].obs;
  // RxList<ExcuseData> excuseListCopy = <ExcuseData>[].obs;
  RxList<Employees> excuseEmployeeList = <Employees>[].obs;
  // RxList<String> empAttIdList = <String>[].obs;
  // RxList<Employees> allExcuseEmployeeList = <Employees>[].obs;
  // RxList<Employees> selectedEmployeeList = <Employees>[].obs;

  Future<void> fetchExcuseList({required String monthYear}) async {
    excuseLoading.value = true;
    excuseLoaded.value = false;
    excuseError.value = false;
    excuseShimmerloading.value = false;
    excuseList.value = [];
    // excuseListCopy.value = [];
    excuseEmployeeList.value = [];
    // empAttIdList.value = [];
    // allExcuseEmployeeList.value = [];
    // selectedEmployeeList.value = [];
    String empId = Get.find<UserProfileController>().userData.value.result.employeeId ?? '';
    String compId = Get.find<UserProfileController>().currentCompany.value?.companyId?.toString() ?? Get.find<UserProfileController>().userData.value.result.companyId ?? '';
    DateTime date = DateFormat("MMM, yyyy").parse(monthYear);
    String formatted = DateFormat("yyyy-MM").format(date);

    try {
      Map<String, dynamic> resp = await ApiServices.getEmployeeExcuseList(supervisorId: empId, companyId: compId, yearMonth: formatted);

      AttendanceCommonWidgets().printF("-------resp-------$resp");

      if(resp['status'].toString() == "200") {
        EmployeeExcuseListApi employeeExcuseListApi = EmployeeExcuseListApi.fromJson(resp);
        excuseList.value = employeeExcuseListApi.result ?? [];
        // excuseListCopy.value = excuseList.value;
        if(searchText.value.isNotEmpty) {
          filterByName(type: RequestType.excuse, name: searchText.value);
        }
        // empAttIdList.value = excuseList
        //     .expand((excuse) => excuse.employees?.map((emp) => emp.employeeDailyAttendanceId ?? '') ?? <String>[])
        //     .toList()
        //     .where((id) => id.isNotEmpty)
        //     .toList();
        // excuseList.value.sort((a, b) {
        //   int aPriority = statusPriority[a.mainStatus?.toLowerCase()] ?? 99;
        //   int bPriority = statusPriority[b.mainStatus?.toLowerCase()] ?? 99;
        //   return aPriority.compareTo(bPriority);
        // });
        excuseLoaded.value = true;
        excuseShimmerloading.value = true;
      }
    } catch(e) {
      AttendanceCommonWidgets().printF("-------excuse list error-----------");
      excuseError.value = true;
       excuseShimmerloading.value = true;
    } finally {
      excuseLoading.value = false;
       excuseShimmerloading.value = true;
    }
  }

  Future<void> fetchOvertimeList({required String monthYear}) async {
    excuseLoading.value = true;
    excuseLoaded.value = false;
    excuseError.value = false;
    excuseShimmerloading.value = false;
    excuseList.value = [];
    // excuseListCopy.value = [];
    excuseEmployeeList.value = [];
    // empAttIdList.value = [];
    // allExcuseEmployeeList.value = [];
    // selectedEmployeeList.value = [];
    String empId = Get.find<UserProfileController>().userData.value.result.employeeId ?? '';
    String compId = Get.find<UserProfileController>().currentCompany.value?.companyId?.toString() ?? Get.find<UserProfileController>().userData.value.result.companyId ?? '';
    DateTime date = DateFormat("MMM, yyyy").parse(monthYear);
    String formatted = DateFormat("yyyy-MM").format(date);

    try {
      Map<String, dynamic> resp = await ApiServices.getEmployeeOvertimeList(
          supervisorId: empId,
          companyId: compId,
          yearMonth: formatted,
        filter: filters.value[currentTabIndex.value].filter == RequestFilterTypes.pending
            ? "Pending"
            : filters.value[currentTabIndex.value].filter == RequestFilterTypes.approved
            ? "Approved"
            : "Rejected",
      );

      AttendanceCommonWidgets().printF("-------resp-------$resp");

      if(resp['status'].toString() == "200") {
        // resp['result'] = resp['result']['result'];
        // EmployeeExcuseListApi employeeExcuseListApi = EmployeeExcuseListApi.fromJson(resp);
        OvertimeListApi overtimeListApi = OvertimeListApi.fromJson(resp);
        EmployeeExcuseListApi employeeExcuseListApi = EmployeeExcuseListApi(
          status: overtimeListApi.status,
          message: overtimeListApi.message,
          result: overtimeListApi.result?.result?.map((e) => ExcuseData(
            date: e.date,
            employees: e.employees?.map((v) => Employees(
              date: v.date,
              employeeId: v.employeeId,
              code: v.code,
              designation: v.designation,
              employeeDailyAttendanceId: v.employeeDailyAttendanceId,
              employeeName: v.employeeName,
              firstCheckInTime: v.firstCheckInTime,
              isSelected: false,
              lastCheckOutTime: v.lastCheckOutTime,
              profilePicture: v.profilePicture,
              shiftName: v.shiftName,
              totalWorkHours: v.totalWorkHours,
              status: v.status?.map((j) => Status(
                employeeDailyAttendanceId: j.employeeDailyAttendanceId,
                color: null,
                deductionAmount: j.amount,
                deductionDate: j.overTimeDate,
                deductionDetails: j.overTimeDetails,
                employeeAttendanceDeductionId: j.employeeOvertimeDataId,
                excuseType: j.overTimeDetails,
                timeDifference: j.timeExtra,
              )).toList()
            )).toList(),
          )).toList(),
        );
        excuseList.value = employeeExcuseListApi.result ?? [];
        // excuseListCopy.value = excuseList.value;
        if(searchText.value.isNotEmpty) {
          filterByName(type: RequestType.overtime, name: searchText.value);
        }
        // empAttIdList.value = excuseList
        //     .expand((excuse) => excuse.employees?.map((emp) => emp.employeeDailyAttendanceId ?? '') ?? <String>[])
        //     .toList()
        //     .where((id) => id.isNotEmpty)
        //     .toList();
        // excuseList.value.sort((a, b) {
        //   int aPriority = statusPriority[a.mainStatus?.toLowerCase()] ?? 99;
        //   int bPriority = statusPriority[b.mainStatus?.toLowerCase()] ?? 99;
        //   return aPriority.compareTo(bPriority);
        // });
        excuseLoaded.value = true;
        excuseShimmerloading.value = true;
      }
    } catch(e) {
      AttendanceCommonWidgets().printF("-------overtime list error-----------");
      excuseError.value = true;
       excuseShimmerloading.value = true;
    } finally {
      excuseLoading.value = false;
       excuseShimmerloading.value = true;
    }
  }

  Future<void> fetchExcuseListFilter({required String monthYear}) async {
    excuseLoading.value = true;
    excuseLoaded.value = false;
    excuseError.value = false;
    excuseShimmerloading.value = false;
    excuseList.value = [];
    excuseEmployeeList.value = [];
    String empId = Get.find<UserProfileController>().userData.value.result.employeeId ?? '';
    String compId = Get.find<UserProfileController>().currentCompany.value?.companyId?.toString() ?? Get.find<UserProfileController>().userData.value.result.companyId ?? '';
    DateTime date = DateFormat("MMM, yyyy").parse(monthYear);
    String formatted = DateFormat("yyyy-MM").format(date);

    try {
      Map<String, dynamic> resp = await ApiServices.getFilteredEmployeeExcuseList(
          supervisorId: empId,
          companyId: compId,
          yearMonth: formatted,
        filter: filters.value[currentTabIndex.value].filter == RequestFilterTypes.approved ? "pardon" : "fine",
      );

      AttendanceCommonWidgets().printF("-------resp-------$resp");

      if(resp['status'].toString() == "200") {
        EmployeeExcuseListApi regularizedExcuseListApi = EmployeeExcuseListApi.fromJson(resp);

        // Map<String, List<Employees>> groupedByDate = {};

        // for (var e in regularizedExcuseListApi.result ?? []) {
        //   final date = e.date ?? '';
        //   final employee = Employees(
        //     date: e.date,
        //     employeeDailyAttendanceId: e.employeeDailyAttendanceId,
        //     code: e.code,
        //     employeeId: e.employeeId,
        //     employeeName: e.employeeName,
        //     firstCheckInTime: e.firstCheckInTime,
        //     lastCheckOutTime: e.lastCheckOutTime,
        //     profilePicture: e.profilePicture,
        //     shiftName: e.shiftName,
        //     totalWorkHours: e.totalWorkHours,
        //   );
        //
        //   if (groupedByDate.containsKey(date)) {
        //     groupedByDate[date]!.add(employee);
        //   } else {
        //     groupedByDate[date] = [employee];
        //   }
        // }
        //
        // List<ExcuseData> excuseDataList = groupedByDate.entries.map((entry) {
        //   return ExcuseData(
        //     date: entry.key,
        //     employees: entry.value,
        //   );
        // }).toList();
        //
        // EmployeeExcuseListApi employeeExcuseListApi = EmployeeExcuseListApi(
        //   status: regularizedExcuseListApi.status,
        //   message: regularizedExcuseListApi.message,
        //   result: excuseDataList,
        // );
        excuseList.value = regularizedExcuseListApi.result ?? [];
        if(searchText.value.isNotEmpty) {
          filterByName(type: RequestType.excuse, name: searchText.value);
        }
        excuseLoaded.value = true;
        excuseShimmerloading.value = true;
      }
    } catch(e) {
      AttendanceCommonWidgets().printF("-------excuse list error-----------");
      excuseError.value = true;
       excuseShimmerloading.value = true;
    } finally {
      excuseLoading.value = false;
       excuseShimmerloading.value = true;
    }
  }
  
  void filterByName({required RequestType type, required String name}) {
    if(type == RequestType.excuse || type == RequestType.overtime) {
      List<Employees> empList = [];
      for (var excuse in excuseList.value) {
        empList.addAll((excuse.employees ?? []).where((emp) {
          String listName = emp.employeeName.toString().toLowerCase().replaceAll(RegExp(r"\s+"), '');
          String searchName = name.toLowerCase().replaceAll(RegExp(r"\s+"), '');
          return listName.contains(searchName);
        }));
      }
      excuseEmployeeList.value = empList;
    }
    if(type == RequestType.punchApproval) {
      List<EmployeesApproval> empList = [];
      for (var punch in punchApprovalList.value) {
        empList.addAll((punch.employees ?? []).where((emp) {
          String listName = emp.employeeName.toString().toLowerCase().replaceAll(RegExp(r"\s+"), '');
          String searchName = name.toLowerCase().replaceAll(RegExp(r"\s+"), '');
          return listName.contains(searchName);
        }));
      }
      punchApprovalEmployeeList.value = empList;
    }
    if(type == RequestType.wfh || type == RequestType.letterRequest) {
      List<WfhLrData> empList = [];
      empList = wfhLrListCopy.value.where((element) {
        String listName = element.employeeName.toString().toLowerCase().replaceAll(RegExp(r"\s+"), '');
        String searchName = name.toLowerCase().replaceAll(RegExp(r"\s+"), '');
        return listName.contains(searchName);
      }).toList();
      if(filters.value[currentTabIndex.value].filter == RequestFilterTypes.pending) {
        wfhLrListPending.value = empList.where((request) => request.requestStatusName?.toLowerCase() == 'pending').toList();
      }
      if(filters.value[currentTabIndex.value].filter == RequestFilterTypes.approved) {
        wfhLrListApproved.value = empList.where((request) => request.requestStatusName?.toLowerCase() == 'approved').toList();
      }
      if(filters.value[currentTabIndex.value].filter == RequestFilterTypes.rejected) {
        wfhLrListRejected.value = empList.where((request) => request.requestStatusName?.toLowerCase() == 'rejected').toList();
      }
    }
    if(type == RequestType.leaveRequest) {
      List<EmployeeLeaveData> empList = [];
      empList = employeeLeaveListCopy.value.where((element) {
        String listName = element.employeeName.toString().toLowerCase().replaceAll(RegExp(r"\s+"), '');
        String searchName = name.toLowerCase().replaceAll(RegExp(r"\s+"), '');
        return listName.contains(searchName);
      }).toList();
      employeeLeaveList.value = empList;
    }
  }

  Rx<DeductionData?> deductionData = Rx(null);
  RxBool bottomsheetloaded  =false.obs;

  Future<void> fetchEmployeeDeductionDetails({required String dedId, required String action}) async {
    deductionData.value = null;
    bottomsheetloaded.value = false;
    try {
      Map<String, dynamic> resp = await ApiServices.deductionDetailsGet(deductionId: dedId, action: action);

      if(resp['status'].toString() == "200") {
        DeductionDetailsApi deductionDetailsApi = DeductionDetailsApi.fromJson(resp);
        deductionData.value = deductionDetailsApi.result;
        DateTime dateTime = DateTime.parse(action == ApiConstants().getEmployeeAttendanceOverTimeById ? deductionData.value?.overTimeDate ?? '' : deductionData.value?.deductionDate ?? '');
        String formatted = DateFormat("dd MMM yyyy | E").format(dateTime);
        if(action == ApiConstants().getEmployeeAttendanceOverTimeById) {
          deductionData.value?.overTimeDate = formatted;
        } else {
          deductionData.value?.deductionDate = formatted;
        }
        bottomsheetloaded.value = true;
      }
      bottomsheetloaded.value = true;
    } catch(e) {
      AttendanceCommonWidgets().printF("---------deduction detail error------------");
      bottomsheetloaded.value = true;
    }
  }

  RxBool pardonLoading = false.obs;
  RxBool fineLoading = false.obs;

  Future<String?> submitForRegularization({required bool action, String? regularizeId}) async {
    try {
      String empId = Get.find<UserProfileController>().userData.value.result.employeeId ?? '';
      String compId = Get.find<UserProfileController>().currentCompany.value?.companyId?.toString() ?? Get.find<UserProfileController>().userData.value.result.companyId ?? '';
      String reason = Get.find<ManagerRequestController>().remarksController.text;
      List<String> selectedList = [];
      if(searchText.value.trim().isEmpty) {
        selectedList = excuseList.value
            .expand((element) => (element.employees ?? [])
            .where((e) => e.isSelected == true)
            .expand((e) => (e.status ?? [])
            .map((s) => s.employeeAttendanceDeductionId ?? '')))
            .where((id) => id.isNotEmpty)
            .toList();
      } else {
        selectedList = excuseEmployeeList.value
            .where((e) => e.isSelected == true)
            .expand((e) => (e.status ?? [])
            .map((s) => s.employeeAttendanceDeductionId ?? ''))
            .where((id) => id.isNotEmpty)
            .toList();
      }
      if(regularizeId != null) {
        List<String> singleId = selectedList.where((element) => element == regularizeId).toList();
        if(singleId.isNotEmpty) {
          selectedList = singleId;
        }
      }
      if(action) {
        pardonLoading.value = true;
        Map<String, dynamic> resp = await ApiServices.excuseReqSubmit(
          supervisorId: empId,
          companyId: compId,
          remarks: reason,
          employees: selectedList,
          type: SubmissionType.pardon,
        );

        AttendanceCommonWidgets().printF("------excuse resp---------$resp");

        String switchedDate = monthString[currentMonthIndex.value];
        // DateTime date = DateFormat("MMM, yyyy").parse(switchedDate);
        // String formatted = DateFormat('yyyy-MM').format(date);
        await fetchExcuseList(monthYear: switchedDate);

        pardonLoading.value = false;

        if(resp['status'].toString() == "200") {
          return resp['message'] ?? "Excuses has been approved.";
        }
      } else {
        fineLoading.value = true;
        Map<String, dynamic> resp = await ApiServices.excuseReqSubmit(
          supervisorId: empId,
          companyId: compId,
          remarks: reason,
          employees: selectedList,
          type: SubmissionType.fine,
        );

        AttendanceCommonWidgets().printF("------excuse resp---------$resp");

        String switchedDate = monthString[currentMonthIndex.value];
        // DateTime date = DateFormat("MMM, yyyy").parse(switchedDate);
        // String formatted = DateFormat('yyyy-MM').format(date);
        await fetchExcuseList(monthYear: switchedDate);

        fineLoading.value = false;

        if(resp['status'].toString() == "200") {
          return resp['message'] ?? "Excuses has been rejected.";
        }
      }
    } catch(e) {
      AttendanceCommonWidgets().printF("----------excuse submission error-------------");
    } finally {
      pardonLoading.value = false;
      fineLoading.value = false;
    }
    return null;
  }

  RxBool approveLoading = false.obs;
  RxBool rejectLoading = false.obs;

  Future<String?> submitPunchRequestUpdate({required bool action}) async {
    try {
      String empId = Get.find<UserProfileController>().userData.value.result.employeeId ?? '';
      String reason = Get.find<ManagerRequestController>().remarksController.text;
      List<String> selectedList = [];
      if(searchText.value.trim().isEmpty) {
        selectedList = punchApprovalList.value
            .expand((element) => (element.employees ?? [])
            .where((e) => e.isSelected == true)
            .map((s) => s.employeeDailyAttendanceId ?? ''))
            .where((id) => id.isNotEmpty)
            .toList();
      } else {
        selectedList = punchApprovalEmployeeList.value
            .where((e) => e.isSelected == true)
            .map((s) => s.employeeDailyAttendanceId ?? '')
            .where((id) => id.isNotEmpty)
            .toList();
      }
      if(action) {
        approveLoading.value = true;
        Map<String, dynamic> resp = await ApiServices.punchApprovalReject(
          empId: empId,
          remark: reason,
          punchList: selectedList,
          type: SubmissionType.approve,
        );

        AttendanceCommonWidgets().printF("------punch resp---------$resp");

        String switchedDate = monthString[currentMonthIndex.value];
        // DateTime date = DateFormat("MMM, yyyy").parse(switchedDate);
        // String formatted = DateFormat('yyyy-MM').format(date);
        await fetchPunchApprovalReqList(monthYr: switchedDate);

        approveLoading.value = false;

        if(resp['status'].toString() == "200") {
          return resp['message'] ?? "Request approved successfully.";
        }
      } else {
        rejectLoading.value = true;
        Map<String, dynamic> resp = await ApiServices.punchApprovalReject(
          empId: empId,
          remark: reason,
          punchList: selectedList,
          type: SubmissionType.reject,
        );

        AttendanceCommonWidgets().printF("------punch resp---------$resp");

        String switchedDate = monthString[currentMonthIndex.value];
        // DateTime date = DateFormat("MMM, yyyy").parse(switchedDate);
        // String formatted = DateFormat('yyyy-MM').format(date);
        await fetchPunchApprovalReqList(monthYr: switchedDate);

        rejectLoading.value = false;

        if(resp['status'].toString() == "200") {
          return resp['message'] ?? "Request rejected successfully.";
        }
      }
    } catch(e) {
      AttendanceCommonWidgets().printF("----------punch submission error-------------");
    } finally {
      approveLoading.value = false;
      rejectLoading.value = false;
    }
    return null;
  }

  Future<String?> submitOvertimeUpdate({required bool action}) async {
    try {
      String empId = Get.find<UserProfileController>().userData.value.result.employeeId ?? '';
      String reason = Get.find<ManagerRequestController>().remarksController.text;
      List<String> selectedList = [];
      if(searchText.value.trim().isEmpty) {
        selectedList = excuseList.value
            .expand((element) => (element.employees ?? [])
            .where((e) => e.isSelected == true)
            .map((s) => (s.status?.isNotEmpty ?? false) ? s.status?.first.employeeAttendanceDeductionId ?? '' : ''))
            .where((id) => id.isNotEmpty)
            .toList();
      } else {
        selectedList = excuseEmployeeList.value
            .where((e) => e.isSelected == true)
            .map((s) => (s.status?.isNotEmpty ?? false) ? s.status?.first.employeeAttendanceDeductionId ?? '' : '')
            .where((id) => id.isNotEmpty)
            .toList();
      }
      if(action) {
        approveLoading.value = true;
        Map<String, dynamic> resp = await ApiServices.approveOrRejectOvertime(
          empId: empId,
          remark: reason,
          overtimeIds: selectedList,
          type: SubmissionType.approve,
        );

        AttendanceCommonWidgets().printF("------punch resp---------$resp");

        String switchedDate = monthString[currentMonthIndex.value];
        // DateTime date = DateFormat("MMM, yyyy").parse(switchedDate);
        // String formatted = DateFormat('yyyy-MM').format(date);
        await fetchOvertimeList(monthYear: switchedDate);

        approveLoading.value = false;

        if(resp['status'].toString() == "200") {
          return resp['message'] ?? "Overtime updated successfully.";
        }
      } else {
        rejectLoading.value = true;
        Map<String, dynamic> resp = await ApiServices.approveOrRejectOvertime(
          empId: empId,
          remark: reason,
          overtimeIds: selectedList,
          type: SubmissionType.reject,
        );

        AttendanceCommonWidgets().printF("------punch resp---------$resp");

        String switchedDate = monthString[currentMonthIndex.value];
        // DateTime date = DateFormat("MMM, yyyy").parse(switchedDate);
        // String formatted = DateFormat('yyyy-MM').format(date);
        await fetchOvertimeList(monthYear: switchedDate);

        rejectLoading.value = false;

        if(resp['status'].toString() == "200") {
          return resp['message'] ?? "Overtime updated successfully.";
        }
      }
    } catch(e) {
      AttendanceCommonWidgets().printF("----------overtime submission error-------------");
    } finally {
      approveLoading.value = false;
      rejectLoading.value = false;
    }
    return null;
  }

  Future<String?> submitWfhLrRequestUpdate({required bool action, int? attOption}) async {
    try {
      String empId = Get.find<UserProfileController>().userData.value.result.employeeId ?? '';
      String compId = Get.find<UserProfileController>().currentCompany.value?.companyId?.toString() ?? Get.find<UserProfileController>().userData.value.result.companyId ?? '';
      List<String> selectedList = Get.find<ManagerRequestController>().wfhLrListPending.value
          .where((e) => e.isSelected == true)
          .map((s) => s.specialRequestId ?? '')
          .where((id) => id.isNotEmpty)
          .toList();
      if(action) {
        approveLoading.value = true;

        Map<String, dynamic> resp = {};

        for (var id in selectedList) {
          if (currentTabIndex.value != 3 && letterRequestFiles.isNotEmpty) {
            try {
              List<String> filePaths = letterRequestFiles.map((file) => file.filePath).toList();
              var uploadResp = await ApiServices.uploadLetterRequestFiles(
                specialRequestId: id,
                employeeId: empId,
                filePaths: filePaths,
              );
              AttendanceCommonWidgets().printF("Files upload response: $uploadResp");
            } catch (e) {
              AttendanceCommonWidgets().printF("Files upload failed: $e");
            }
          }
          resp = await ApiServices.submitSpcRequest(
            empId: empId,
            compId: compId,
            remark: remarksController.text,
            reqId: id,
            reqType: currentTabIndex.value == 3 ? RequestType.wfh : RequestType.letterRequest,
            type: SubmissionType.approve,
            punchMethodId: attOption
          );
        }

        AttendanceCommonWidgets().printF("------req resp---------$resp");

        String switchedDate = monthString[currentMonthIndex.value];
        // DateTime date = DateFormat("MMM, yyyy").parse(switchedDate);
        // String formatted = DateFormat('yyyy-MM').format(date);
        await fetchWfhOrLrList(monthYr: switchedDate);

        approveLoading.value = false;

        if(resp['status'].toString() == "200") {
          return resp['message'] ?? "Request has been Approved";
        }
      } else {
        rejectLoading.value = true;

        Map<String, dynamic> resp = {};

        for (var id in selectedList) {
          resp = await ApiServices.submitSpcRequest(
            empId: empId,
            compId: compId,
            remark: remarksController.text,
            reqId: id,
            reqType: currentTabIndex.value == 3 ? RequestType.wfh : RequestType.letterRequest,
            type: SubmissionType.reject,
            punchMethodId: attOption
          );
        }

        AttendanceCommonWidgets().printF("------req resp---------$resp");

        String switchedDate = monthString[currentMonthIndex.value];
        // DateTime date = DateFormat("MMM, yyyy").parse(switchedDate);
        // String formatted = DateFormat('yyyy-MM').format(date);
        await fetchWfhOrLrList(monthYr: switchedDate);

        rejectLoading.value = false;

        if(resp['status'].toString() == "200") {
          return resp['message'] ?? "Request has been Rejected";
        }
      }
    } catch(e) {
      AttendanceCommonWidgets().printF("----------req submission error-------------");
    } finally {
      approveLoading.value = false;
      rejectLoading.value = false;
    }
    return null;
  }

  Future<String?> leaveRequestUpdate({required bool action}) async {
    try {
      String empId = Get.find<UserProfileController>().userData.value.result.employeeId ?? '';
      String compId = Get.find<UserProfileController>().currentCompany.value?.companyId?.toString() ?? Get.find<UserProfileController>().userData.value.result.companyId ?? '';

      List<EmployeeLeaveData> hourBased = Get.find<ManagerRequestController>().employeeLeaveList.value.where((element) => element.isHourBased == '1').toList();
      List<EmployeeLeaveData> notHourBased = Get.find<ManagerRequestController>().employeeLeaveList.value.where((element) => element.isHourBased != '1').toList();

      List<String> hourBasedSelectedApplicationList = hourBased
          .where((e) => (e.isSelected == true && e.requestStatusName.toString().toLowerCase() == 'pending'))
          .map((s) => s.employeeLeaveApplicationId ?? '')
          .where((id) => id.isNotEmpty)
          .toList();
      List<String> hourBasedSelectedEmployeeList = hourBased
          .where((e) => (e.isSelected == true && e.requestStatusName.toString().toLowerCase() == 'pending'))
          .map((s) => s.employeeId ?? '')
          .where((id) => id.isNotEmpty)
          .toList();
      List<String> hourBasedIsFinalHierarchyList = hourBased
          .where((e) => (e.isSelected == true && e.requestStatusName.toString().toLowerCase() == 'pending'))
          .map((s) => s.isFinalHeirarchy ?? '')
          .where((id) => id.isNotEmpty)
          .toList();
      List<String> hourBasedLeaveTypeIdList = hourBased
          .where((e) => (e.isSelected == true && e.requestStatusName.toString().toLowerCase() == 'pending'))
          .map((s) => s.leaveType ?? '')
          .where((id) => id.isNotEmpty)
          .toList();

      List<String> selectedApplicationList = notHourBased
          .where((e) => (e.isSelected == true && e.requestStatusName.toString().toLowerCase() == 'pending'))
          .map((s) => s.employeeLeaveApplicationId ?? '')
          .where((id) => id.isNotEmpty)
          .toList();
      List<String> selectedEmployeeList = notHourBased
          .where((e) => (e.isSelected == true && e.requestStatusName.toString().toLowerCase() == 'pending'))
          .map((s) => s.employeeId ?? '')
          .where((id) => id.isNotEmpty)
          .toList();
      List<String> isFinalHierarchyList = notHourBased
          .where((e) => (e.isSelected == true && e.requestStatusName.toString().toLowerCase() == 'pending'))
          .map((s) => s.isFinalHeirarchy ?? '')
          .where((id) => id.isNotEmpty)
          .toList();
      List<String> leaveTypeIdList = notHourBased
          .where((e) => (e.isSelected == true && e.requestStatusName.toString().toLowerCase() == 'pending'))
          .map((s) => s.leaveType ?? '')
          .where((id) => id.isNotEmpty)
          .toList();

      if(action) {
        approveLoading.value = true;

        Map<String, dynamic> resp = {};

        if(selectedApplicationList.isNotEmpty) {
          resp = await ApiServices.approveOrRejectLeave(
              empId: empId,
              compId: compId,
              employeeIds: selectedEmployeeList,
              remarks: remarksController.text,
              leaveApplicationId: selectedApplicationList,
              leaveTypeId: leaveTypeIdList,
              hierarchyList: isFinalHierarchyList,
              type: SubmissionType.approve,
              isHourBased: false
          );
        }

        if(hourBasedSelectedApplicationList.isNotEmpty) {
          resp = await ApiServices.approveOrRejectLeave(
              empId: empId,
              compId: compId,
              employeeIds: hourBasedSelectedEmployeeList,
              remarks: remarksController.text,
              leaveApplicationId: hourBasedSelectedApplicationList,
              leaveTypeId: hourBasedLeaveTypeIdList,
              hierarchyList: hourBasedIsFinalHierarchyList,
              type: SubmissionType.approve,
              isHourBased: true
          );
        }

        AttendanceCommonWidgets().printF("------req resp---------$resp");

        String switchedDate = monthString[currentMonthIndex.value];
        // DateTime date = DateFormat("MMM, yyyy").parse(switchedDate);
        // String formatted = DateFormat('yyyy-MM').format(date);
        await fetchEmployeeLeaveList(monthYr: switchedDate);
        Get.find<EmployeeLeaveController>().fetchEmployeeLeaveList();

        approveLoading.value = false;

        if(resp['status'].toString() == "200") {
          return resp['message'] ?? "Leave Request has been approved";
        }
      } else {
        rejectLoading.value = true;

        Map<String, dynamic> resp = {};

        if(selectedApplicationList.isNotEmpty) {
          resp = await ApiServices.approveOrRejectLeave(
              empId: empId,
              compId: compId,
              employeeIds: selectedEmployeeList,
              remarks: remarksController.text,
              leaveApplicationId: selectedApplicationList,
              leaveTypeId: leaveTypeIdList,
              hierarchyList: isFinalHierarchyList,
              type: SubmissionType.reject,
              isHourBased: false
          );
        }

        if(hourBasedSelectedApplicationList.isNotEmpty) {
          resp = await ApiServices.approveOrRejectLeave(
              empId: empId,
              compId: compId,
              employeeIds: hourBasedSelectedEmployeeList,
              remarks: remarksController.text,
              leaveApplicationId: hourBasedSelectedApplicationList,
              leaveTypeId: hourBasedLeaveTypeIdList,
              hierarchyList: hourBasedIsFinalHierarchyList,
              type: SubmissionType.reject,
              isHourBased: true
          );
        }

        AttendanceCommonWidgets().printF("------req resp---------$resp");

        String switchedDate = monthString[currentMonthIndex.value];
        // DateTime date = DateFormat("MMM, yyyy").parse(switchedDate);
        // String formatted = DateFormat('yyyy-MM').format(date);
        await fetchEmployeeLeaveList(monthYr: switchedDate);
        Get.find<EmployeeLeaveController>().fetchEmployeeLeaveList();

        rejectLoading.value = false;

        if(resp['status'].toString() == "200") {
          return resp['message'] ?? "Leave Request has been rejected";
        }
      }
    } catch(e) {
      AttendanceCommonWidgets().printF("----------leave req submission error-------------");
    } finally {
      approveLoading.value = false;
      rejectLoading.value = false;
    }
    return null;
  }

  RxBool punchListLoading = false.obs;
  RxBool punchListLoaded = false.obs;
  RxBool punchListError = false.obs;
  RxBool punchShimmerLoded = false.obs;
  RxList<PunchApprovalData> punchApprovalList = <PunchApprovalData>[].obs;
  RxList<EmployeesApproval> punchApprovalEmployeeList = <EmployeesApproval>[].obs;

  Future<void> fetchPunchApprovalReqList({required String monthYr}) async {
    punchListLoading.value = true;
    punchListLoaded.value = false;
    punchListError.value = false;
    punchShimmerLoded.value = false;

    try {
      String empId = Get.find<UserProfileController>().userData.value.result.employeeId ?? '';
      String compId = Get.find<UserProfileController>().currentCompany.value?.companyId?.toString() ?? Get.find<UserProfileController>().userData.value.result.companyId ?? '';
      DateTime date = DateFormat("MMM, yyyy").parse(monthYr);
      String formatted = DateFormat("yyyy-MM").format(date);

      Map<String, dynamic> resp = await ApiServices.punchApprovalReqList(
          comId: compId,
          empId: empId,
          yearAndMonth: formatted,
        filter: filters.value[currentTabIndex.value].filter == RequestFilterTypes.pending
            ? "Pending"
            : filters.value[currentTabIndex.value].filter == RequestFilterTypes.approved
            ? "Approved"
            : "Rejected",
      );

      if(resp['status'].toString() == "200") {
        PunchApprovalListModel punchApprovalListModel = PunchApprovalListModel.fromJson(resp);
        punchApprovalList.value = punchApprovalListModel.result?.result ?? [];

        if(searchText.value.isNotEmpty) {
          filterByName(type: RequestType.punchApproval, name: searchText.value);
        }

        // punchApprovalList.value.sort((a, b) {
        //   int aPriority = statusPriority[a.mainStatus?.toLowerCase()] ?? 99;
        //   int bPriority = statusPriority[b.mainStatus?.toLowerCase()] ?? 99;
        //   return aPriority.compareTo(bPriority);
        // });

        punchListLoaded.value = true;
         punchShimmerLoded.value = true;
      }
    } catch(e) {
      punchListError.value = false;
      punchShimmerLoded.value = true;
      AttendanceCommonWidgets().printF("-----------approval list error--------------");
    } finally {
      punchListLoading.value = false;
      punchShimmerLoded.value = true;
    }
  }

  RxBool wfhLrLoading = false.obs;
  RxBool wfhLrLoaded = false.obs;
  RxBool wfhLrError = false.obs;
  RxBool wfhLrShimmerLoaded = false.obs;
  RxList<WfhLrData> wfhLrListPending = <WfhLrData>[].obs;
  RxList<WfhLrData> wfhLrListApproved = <WfhLrData>[].obs;
  RxList<WfhLrData> wfhLrListRejected = <WfhLrData>[].obs;
  RxList<WfhLrData> wfhLrListCopy = <WfhLrData>[].obs;

  Future<void> fetchWfhOrLrList({required String monthYr}) async {
    wfhLrLoading.value = true;
    wfhLrLoaded.value = false;
    wfhLrError.value = false;
    wfhLrShimmerLoaded.value = false;
    wfhLrListPending.value = [];
    wfhLrListApproved.value = [];
    wfhLrListRejected.value = [];
    wfhLrListCopy.value = [];
    try {
      String empId = Get.find<UserProfileController>().userData.value.result.employeeId ?? '';
      String compId = Get.find<UserProfileController>().currentCompany.value?.companyId?.toString() ?? Get.find<UserProfileController>().userData.value.result.companyId ?? '';
      DateTime date = DateFormat("MMM, yyyy").parse(monthYr);
      String formatted = DateFormat("yyyy-MM").format(date);

      Map<String, dynamic> resp = await ApiServices.getSpecialRequestsWfhLr(
        compId: compId,
        empId: empId,
        monthYr: formatted,
        type: currentTabIndex.value == 3 ? SubmissionType.wfh : SubmissionType.lr,
      );
      AttendanceCommonWidgets().printF("-----------wfh lr list resp--------------$resp");

      if(resp['status'].toString() == "200") {
        WfhLrListModel wfhLrListModel = WfhLrListModel.fromJson(resp);
        wfhLrListPending.value = wfhLrListModel.result?.where((request) => request.requestStatusName?.toLowerCase() == 'pending').toList() ?? [];
        wfhLrListApproved.value = wfhLrListModel.result?.where((request) => request.requestStatusName?.toLowerCase() == 'approved').toList() ?? [];
        wfhLrListRejected.value = wfhLrListModel.result?.where((request) => request.requestStatusName?.toLowerCase() == 'rejected').toList() ?? [];
        wfhLrListCopy.value = wfhLrListModel.result ?? [];

        if(searchText.value.isNotEmpty) {
          filterByName(type: currentTabIndex.value == 3 ? RequestType.wfh : RequestType.letterRequest, name: searchText.value);
        }

        // wfhLrList.value.sort((a, b) {
        //   int aPriority = statusPriority[a.requestStatus?.toLowerCase()] ?? 99;
        //   int bPriority = statusPriority[b.requestStatus?.toLowerCase()] ?? 99;
        //   return aPriority.compareTo(bPriority);
        // });

        wfhLrLoaded.value = true;
        wfhLrShimmerLoaded.value = true;
      }
    } catch(e) {
      wfhLrError.value = false;
      wfhLrShimmerLoaded.value = true;
      AttendanceCommonWidgets().printF("-----------wfh lr list error--------------");
    } finally {
      wfhLrLoading.value = false;
      wfhLrShimmerLoaded.value = true;
    }
  }

  RxBool leaveListLoading = false.obs;
  RxBool leaveListLoaded = false.obs;
  RxBool leaveListError = false.obs;
  RxBool leaveListShimmerLoading = false.obs;
  RxList<EmployeeLeaveData> employeeLeaveListCopy = <EmployeeLeaveData>[].obs;
  RxList<EmployeeLeaveData> employeeLeaveList = <EmployeeLeaveData>[].obs;
  Map<String, int> statusPriority = {
    'pending': 0,
    'approved': 1,
    'rejected': 2,
  };

  Future<void> fetchEmployeeLeaveList({required String monthYr}) async {
    leaveListLoading.value = true;
    leaveListLoaded.value = false;
    leaveListError.value = false;
    leaveListShimmerLoading.value = false;
    employeeLeaveListCopy.value = [];
    employeeLeaveList.value = [];
    try {
      String empId = Get.find<UserProfileController>().userData.value.result.employeeId ?? '';
      String compId = Get.find<UserProfileController>().currentCompany.value?.companyId?.toString() ?? Get.find<UserProfileController>().userData.value.result.companyId ?? '';
      DateTime date = DateFormat("MMM, yyyy").parse(monthYr);
      String formatted = DateFormat("yyyy-MM").format(date);

      Map<String, dynamic> resp = await ApiServices.getEmployeeLeaveList(
        compId: compId,
        empId: empId,
        yrMonth: formatted,
        status: filters.value[currentTabIndex.value].filter == RequestFilterTypes.pending
            ? "Pending"
            : filters.value[currentTabIndex.value].filter == RequestFilterTypes.approved
            ? "Approved"
            : "Rejected",
      );

      if(resp['status'].toString() == "200") {
        EmployeeLeaveReqApi employeeLeaveReqApi = EmployeeLeaveReqApi.fromJson(resp);
        employeeLeaveListCopy.value = employeeLeaveReqApi.result ?? [];
        employeeLeaveList.value = employeeLeaveListCopy.value;

        if(searchText.value.isNotEmpty) {
          filterByName(type: RequestType.leaveRequest, name: searchText.value);
        }

        employeeLeaveList.value.sort((a, b) {
          int aPriority = statusPriority[a.requestStatusName?.toLowerCase()] ?? 99;
          int bPriority = statusPriority[b.requestStatusName?.toLowerCase()] ?? 99;
          return aPriority.compareTo(bPriority);
        });

        leaveListLoaded.value = true;
      }
    } catch(e) {
      leaveListError.value = false;
      leaveListShimmerLoading.value = true;
      AttendanceCommonWidgets().printF("-----------leave req list error--------------");
    } finally {
      leaveListLoading.value = false;
      leaveListShimmerLoading.value = true;
    }
  }

  void markSelectEmployee(String empAttId, {bool? setBool}) {
    if(currentTabIndex.value == 0 || currentTabIndex.value == 2) {
      if(searchText.value.trim().isEmpty) {
        for (int i = 0; i < excuseList.value.length; i++) {
          int index = excuseList.value[i].employees?.indexWhere(
                (emp) => emp.employeeDailyAttendanceId == empAttId,
          ) ?? -1;

          if (index != -1) {
            var emp = excuseList.value[i].employees![index];
            emp.isSelected = setBool ?? !(emp.isSelected ?? false);
          }
        }
        excuseList.refresh();
      } else {
        for (int i = 0; i < excuseEmployeeList.value.length; i++) {
          if(excuseEmployeeList.value[i].employeeDailyAttendanceId == empAttId) {
            var emp = excuseEmployeeList.value[i];
            emp.isSelected = setBool ?? !(emp.isSelected ?? false);
          }
        }
        excuseEmployeeList.refresh();
      }
    }
    if(currentTabIndex.value == 1) {
      for (int i = 0; i < punchApprovalList.value.length; i++) {
        int index = punchApprovalList.value[i].employees?.indexWhere(
              (emp) => emp.employeeDailyAttendanceId == empAttId,
        ) ?? -1;

        if (index != -1) {
          var emp = punchApprovalList.value[i].employees![index];
          emp.isSelected = setBool ?? !(emp.isSelected ?? false);
        }
      }
      punchApprovalList.refresh();
    }
    if(currentTabIndex.value == 3) {
      int index = wfhLrListPending.value.indexWhere(
            (emp) => emp.specialRequestId == empAttId,
      ) ?? -1;

      if (index != -1) {
        var emp = wfhLrListPending.value[index];
        emp.isSelected = setBool ?? !(emp.isSelected ?? false);
      }
      wfhLrListPending.refresh();
    }
    if(currentTabIndex.value == 5) {
      int index = employeeLeaveList.value.indexWhere(
            (emp) => (emp.employeeLeaveApplicationId == empAttId && emp.requestStatusName.toString().toLowerCase() == 'pending'),
      ) ?? -1;

      if (index != -1) {
        var emp = employeeLeaveList.value[index];
        emp.isSelected = setBool ?? !(emp.isSelected ?? false);
      }
      employeeLeaveList.refresh();
    }
  }

  RxBool showReasonValidation = false.obs;

  void validateRemarksField() {
    if(remarksController.text.trim().isEmpty) {
      showReasonValidation.value = true;
    } else {
      showReasonValidation.value = false;
    }
  }

  String montNumberToString(int month) {
    switch(month) {
      case 1: return "Jan";
      case 2: return "Feb";
      case 3: return "Mar";
      case 4: return "Apr";
      case 5: return "May";
      case 6: return "Jun";
      case 7: return "Jul";
      case 8: return "Aug";
      case 9: return "Sep";
      case 10: return "Oct";
      case 11: return "Nov";
      case 12: return "Dec";
      default: return "jan";
    }
  }

  int montStringToNumber(String month) {
    switch(month) {
      case "Jan": return 1;
      case "Feb": return 2;
      case "Mar": return 3;
      case "Apr": return 4;
      case "May": return 5;
      case "Jun": return 6;
      case "Jul": return 7;
      case "Aug": return 8;
      case "Sep": return 9;
      case "Oct": return 10;
      case "Nov": return 11;
      case "Dec": return 12;
      default: return 1;
    }
  }

  Color statusColor() {
    switch(filters.value[currentTabIndex.value].filter) {
      case RequestFilterTypes.pending: return const Color(0xFFEBA900);
      case RequestFilterTypes.approved: return const Color(0xFF50BC61);
      case RequestFilterTypes.rejected: return const Color(0xFFEB1100);
    }
  }

  String statusTitle() {
    switch(filters.value[currentTabIndex.value].filter) {
      case RequestFilterTypes.pending: return "Pending";
      case RequestFilterTypes.approved: return currentTabIndex.value == 0 ? "Pardon" : "Approved";
      case RequestFilterTypes.rejected: return currentTabIndex.value == 0 ? "Fine Applied" : "Rejected";
    }
  }
}

class FilterDetails {
  final int tabIndex;
  RequestFilterTypes filter;

  FilterDetails({required this.filter, required this.tabIndex});
}

class SelectedFileData {
  final String fileName;
  final String filePath;
  final String fileSize;

  SelectedFileData({required this.fileName, required this.filePath, required this.fileSize});
}
