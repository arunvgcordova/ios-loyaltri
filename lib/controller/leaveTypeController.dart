import 'package:get/get.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import '../models/leave_type_api_model.dart';
import '../services/api_services.dart';

class LeaveTypeController extends GetxController {
  Rx<bool> isLoading = false.obs;
  Rx<bool> dataLoaded = false.obs;
  Rx<bool> isError = false.obs;

  late Rx<LeaveTypeAPI> leaveType = LeaveTypeAPI().obs;
  RxList<LeaveType> leaveTypeList = <LeaveType>[].obs;
  RxList<LeaveType> regLeaveTypeList = <LeaveType>[].obs;

  void resetStatus() {
    isLoading.value = false;
    isError.value = false;
  }

  Future fetchLeaveType({required String compId, required String empId, String? monthYear}) async {
    isLoading.value = true;
    leaveTypeList.value = [];
    try {
      Map<String, dynamic> resp = await ApiServices.getLeaveType(
        compId: compId,
        empId: empId,
        monthYear: monthYear
      );
      leaveType.value = LeaveTypeAPI.fromJson(resp);
      if (leaveType.value.status == 200) {
        leaveTypeList.value = leaveType.value.result ?? [];
        dataLoaded.value = true;
      }
    } catch (e) {
      isError.value = true;
      AttendanceCommonWidgets().printF(
        "------leave type error-------${e.toString()}",
      );
    } finally {
      resetStatus();
    }
  }

  Future getLeaveTypeForRegularization({required String monthYr, required String empId, required String regType}) async {
    regLeaveTypeList.value = [];
    try {
      Map<String, dynamic> resp = await ApiServices.getLeaveSummary(
        empId: empId,
        monthYr: monthYr,
        regType: regType
      );
      LeaveTypeAPI leaveType = LeaveTypeAPI.fromJson(resp);
      if (leaveType.status == 200) {
        regLeaveTypeList.value = leaveType.result ?? [];
      }
    } catch (e) {
      AttendanceCommonWidgets().printF(
        "------reg leave type error-------${e.toString()}",
      );
    } finally {}
  }
}
