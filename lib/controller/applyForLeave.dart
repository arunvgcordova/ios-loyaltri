
import 'package:get/get.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import '../models/leave_type_api_model.dart';
import '../services/api_services.dart';
import '../services/ui_model_services/leave_dates_model.dart';

class LeaveApplyController extends GetxController {
  Rx<bool> isLoading = false.obs;
  Rx<bool> dataLoaded = false.obs;
  Rx<bool> isError = false.obs;
  Rx<bool> success = false.obs;
  Rx<String> msg = "".obs;

  void resetStatus() {
    isLoading.value = false;
    isError.value = false;
  }

  Future requestLeave({required ApplyLeaveModel leaveData}) async {
    isLoading.value = true;
    msg.value = '';
    try {
      Map<String, dynamic> resp = await ApiServices.applyLeave(applyLeaveData: leaveData);
      AttendanceCommonWidgets().printF("-------resp--------$resp");
      if (resp['status'] == 200) {
        dataLoaded.value = true;
        success.value = true;
        msg.value = resp['message'];
      } else {
        dataLoaded.value = true;
        success.value = false;
        msg.value = resp['message'];
      }
    } catch(e) {
      isError.value = true;
      dataLoaded.value = false;
      success.value = false;
      if(e.toString().contains('Exception: ')) {
        msg.value = e.toString().replaceAll('Exception: ', '');
      }
      AttendanceCommonWidgets().printF("------leave apply error-------${e.toString()}");
    } finally {
      resetStatus();
    }
  }
}