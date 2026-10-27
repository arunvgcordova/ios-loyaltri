
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/controller/userAuthentication.dart';
import 'package:loyaltri_minimal/models/leave_summary_model.dart';
import '../models/upcoming_shift_api_model.dart';
import '../services/api_services.dart';

class UpcomingShiftController extends GetxController {
  Rx<bool> isLoading = false.obs;
  Rx<bool> dataLoaded = false.obs;
  Rx<bool> isError = false.obs;

  RxList<ShiftDetails> upcomingShifts = <ShiftDetails>[].obs;

  void resetStatus() {
    isLoading.value = false;
    isError.value = false;
  }

  Future fetchUpcomingShiftDetails() async {
    isLoading.value = true;
    try {
      String empId = Get.find<UserAuthController>().userData.value.userData?.employeeId ?? '';
      String compId = Get.find<UserAuthController>().userData.value.userData?.companyId?.first.toString() ?? '';
      String dateTime = DateFormat("yyyy-MM-dd").format(DateTime.now());
      Map<String, dynamic> resp = await ApiServices.getUpcomingShiftsApi(employeeId: empId, companyId: compId, date: dateTime);
      UpcomingShiftApiModel upcomingShiftApiModel = UpcomingShiftApiModel.fromJson(resp);
      if (upcomingShiftApiModel.status == 200) {
        upcomingShifts.value = upcomingShiftApiModel.result ?? [];
        dataLoaded.value = true;
      }
    } catch(e) {
      isError.value = true;
      AttendanceCommonWidgets().printF("------upcoming shift error-------${e.toString()}");
    } finally {
      resetStatus();
    }
  }
}