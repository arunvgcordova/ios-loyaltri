

import 'package:get/get.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/controller/userAuthentication.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';
import 'package:loyaltri_minimal/models/manager/all_employee_list.dart';
import 'package:loyaltri_minimal/services/api_services.dart';

import '../../../../controller/ui_controller/home_controller.dart';
import '../../../../controller/ui_controller/page_controller.dart';

class ManagerEmployeeController extends GetxController {

  RxList<CompanyEmployeeData> allEmployees = <CompanyEmployeeData>[].obs;
  RxList<CompanyEmployeeData> allEmployeesCopy = <CompanyEmployeeData>[].obs;
  RxBool allEmployeeLoading = false.obs;

  Future<void> fetchAllEmployee({required bool isAll}) async {
    allEmployeeLoading.value = true;
    allEmployees.value = [];
    allEmployeesCopy.value = [];
    try {
      String empId = Get.find<UserProfileController>().userData.value.result.employeeId ?? '';
      String compId = Get.find<UserProfileController>().userData.value.result.companyId ?? '';
      if(Get.find<UserPageController>().appView.value == AppView.manager) {
        compId = Get.find<UserProfileController>().currentCompany.value?.companyId?.toString() ?? Get.find<UserProfileController>().userData.value.result.companyId ?? '';
      }
      // bool isAll = Get.find<UserAuthController>().userData.value.userData?.unrestrictedList ?? false;
      // bool isAll = true;
      Map<String, dynamic> resp = await ApiServices.getAllEmployee(empId: empId, compId: compId, isListAll: isAll);
      AttendanceCommonWidgets().printF("------employee resp-------$resp");
      if(resp['status']?.toString() == '200') {
        AllEmployeeList allEmployeeList = AllEmployeeList.fromJson(resp);
        allEmployeesCopy.value = allEmployeeList.result ?? [];
        allEmployees.value = allEmployeeList.result ?? [];
      }
    } catch(e) {
      AttendanceCommonWidgets().printF("-----------employee list error---------");
    } finally {
      allEmployeeLoading.value = false;
    }
  }

  void filterEmployeeByName({required String name}) {
    allEmployees.value = allEmployeesCopy.value.where((emp) => (emp.firstName?.toString().toLowerCase().contains(name.toLowerCase()) ?? false)).toList();
  }
}