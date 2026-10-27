import 'package:get/get.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/models/regularisation_request_model.dart';
import '../services/api_services.dart';

class MyExcuseController extends GetxController {
  Rx<bool> isLoading = false.obs;
  Rx<bool> dataLoaded = false.obs;
  Rx<bool> isError = false.obs;
  Rx<RegularisationReqModel> reqularisationRequestApi =
      RegularisationReqModel().obs;
  RxList<RequestData> regularisationReqList = <RequestData>[].obs;
  RxList<RequestData> approvedRegularizationList = <RequestData>[].obs;
  RxList<RequestData> pendingRegularizationList = <RequestData>[].obs;
  RxList<RequestData> rejectedRegularizationList = <RequestData>[].obs;

  void resetStatus() {
    isLoading.value = false;
    isError.value = false;
  }

  Future fetchMyExcuseList({required String empId}) async {
    isLoading.value = true;
    try {
      Map<String, dynamic> resp = await ApiServices.getMyExcuseList(
        empId: empId,
      );
      AttendanceCommonWidgets().printF("-------resp--------$resp");
      if (resp['status'] == 200) {
        RegularisationReqModel data = RegularisationReqModel.fromJson(resp);
        reqularisationRequestApi.value = data;
        regularisationReqList.value =
            reqularisationRequestApi.value.result ?? [];
        fetchDataPerType();
        dataLoaded.value = true;
      }
    } catch (e) {
      isError.value = true;
      dataLoaded.value = false;
      AttendanceCommonWidgets().printF(
        "------my excuse list error-------${e.toString()}",
      );
    } finally {
      resetStatus();
    }
  }

  void fetchDataPerType() async {
    isLoading.value = true;
    List<RequestData> approved = [];
    List<RequestData> pending = [];
    List<RequestData> rejected = [];
    try {
      for (int i = 0; i < regularisationReqList.length; i++) {
        if (regularisationReqList[i].status?.toLowerCase() == "pardon") {
          approved.add(regularisationReqList[i]);
        } else if (regularisationReqList[i].status?.toLowerCase() ==
            "pending") {
          pending.add(regularisationReqList[i]);
        } else if (regularisationReqList[i].status?.toLowerCase() == "fine") {
          rejected.add(regularisationReqList[i]);
        }
      }
      approvedRegularizationList.value = approved;
      pendingRegularizationList.value = pending;
      rejectedRegularizationList.value = rejected;
    } catch (e) {
      isError.value = true;
      AttendanceCommonWidgets().printF(
        "------excuse error-------${e.toString()}",
      );
    } finally {
      resetStatus();
    }
  }
}
