import 'dart:async';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/models/manager/action_centre_model.dart';
import 'package:loyaltri_minimal/services/api_services.dart';

import '../../../../controller/userProfileController.dart';

class ManagerHomeController extends GetxController {
  RxInt currentTaskTab = 0.obs;
  RxString progressTextContent = "".obs;
  late Timer _timer;
  int _index = 0;
  RxDouble opacity = 1.0.obs;
  RxInt currentDayIndex = 10.obs;
  RxString textController = ''.obs;

  List<String> dayList = List.generate(21, (index) {
    DateTime currentDate = DateTime.now();

    DateTime targetDate = currentDate.add(Duration(days: index - 10));

    String formattedDate = DateFormat('MMM dd, yyyy').format(targetDate);

    return formattedDate;
  });

  RxList<String> progressText = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      updateTextWithAnimation();
    });
  }

  void updateTextWithAnimation() {
    if(progressText.length > 1) {
      opacity.value = 0.0;
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      if (progressText.isEmpty) return;
      if (_index >= progressText.length) {
        _index = 0;
      }
      progressTextContent.value = progressText[_index];
      if (progressText.length == 1) return;
      _index = (_index + 1) % progressText.length;
      opacity.value = 1.0;
    });
  }

  RxBool actionCentreLoading = false.obs;
  RxBool actionCentreLoaded = false.obs;
  RxBool actionCentreError = false.obs;
  RxList<ActionData> actionDataList = <ActionData>[].obs;

  Future<void> fetchActionCentre() async {
    actionCentreLoading.value = true;
    actionCentreLoaded.value = false;
    actionCentreError.value = false;
    try {
      String empId = Get.find<UserProfileController>().userData.value.result.employeeId ?? '';
      String compId = Get.find<UserProfileController>().currentCompany.value?.companyId?.toString() ?? Get.find<UserProfileController>().userData.value.result.companyId ?? '';

      Map<String, dynamic> resp = await ApiServices.getActionCentre(
          empId: empId,
          compId: compId,
          yrMonth: DateFormat('yyyy-MM').format(DateTime.now()),
      );

      AttendanceCommonWidgets().printF("--------vbfbdbdftegb---------$resp");

      if(resp['status'].toString() == '200') {
        ActionCentreApi actionCentreApi = ActionCentreApi.fromJson(resp);
        actionDataList.value = actionCentreApi.result ?? [];
        progressText.value = actionDataList.value
            .map((e) => e.actionDescription)
            .where((desc) => desc != null && desc.trim().isNotEmpty)
            .cast<String>()
            .toList();
        if(progressText.value.isEmpty) {
          progressText.value.add("All actions completed—great job! ✅");
          progressText.refresh();
        }
        _index = 0;
      }

      actionCentreLoaded.value = true;

    } catch(e) {
      actionCentreError.value = true;
      AttendanceCommonWidgets().printF("-------action centre api error-----------");
    } finally {
      actionCentreLoading.value = false;
    }
  }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }
}
