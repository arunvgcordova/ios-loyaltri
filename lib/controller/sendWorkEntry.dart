
import 'package:get/get.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import '../models/work_apply_model.dart';
import '../services/api_services.dart';

class SendWorkEntryController extends GetxController {
  Rx<bool> isLoading = false.obs;
  Rx<bool> dataLoaded = false.obs;
  Rx<bool> isError = false.obs;
  RxList<String> selectedFiles = <String>[].obs;

  void resetStatus() {
    isLoading.value = false;
    isError.value = false;
  }

  Future applyWorkEntry({required WorkData workData}) async {
    isLoading.value = true;
    try {
      Map<String, dynamic> resp =
          await ApiServices.sendWorkDetails(workData: workData);
      AttendanceCommonWidgets().printF("--------resp--------$resp");
      if (resp['status'] == 200) {
        dataLoaded.value = true;
      }
    } catch (e) {
      isError.value = true;
      AttendanceCommonWidgets().printF("------work entry apply error-------${e.toString()}");
    } finally {
      resetStatus();
    }
  }

  void setFiles(List<String> files) {
    selectedFiles.value.addAll(files);
  }
}
