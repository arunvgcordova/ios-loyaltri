import 'package:get/get.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import '../models/expense_category_model.dart';
import '../models/work_expense_list_model.dart';
import '../services/api_services.dart';
import '../services/ui_model_services/work_expense_model.dart';

class WorkExpenseController extends GetxController {
  Rx<bool> buttonLoading = false.obs;
  Rx<WorkExpenseCategoryModel> workExpenseCategoryApi =
      WorkExpenseCategoryModel().obs;
  RxList<Category> workExpenseCategoryList = <Category>[].obs;
  Rx<WorkExpenseListModel> workExpenseListApi = WorkExpenseListModel().obs;
  RxList<WorkExpenseData> pendingWorkExpenseList = <WorkExpenseData>[].obs;
  RxList<WorkExpenseData> approvedWorkExpenseList = <WorkExpenseData>[].obs;
  RxList<WorkExpenseData> rejectedWorkExpenseList = <WorkExpenseData>[].obs;

  RxBool expCatLoading = false.obs;

  Future fetchWorkExpenseCategory() async {
    expCatLoading.value = true;
    try {
      Map<String, dynamic> resp = await ApiServices.getWorkExpenseCategory();
      if (resp['status'] == 200) {
        workExpenseCategoryApi.value = WorkExpenseCategoryModel.fromJson(resp);
        workExpenseCategoryList.value =
            workExpenseCategoryApi.value.result ?? [];
      }
    } catch (e) {
      AttendanceCommonWidgets().printF(
        "------work expense category error-------${e.toString()}",
      );
    } finally {
      expCatLoading.value = false;
    }
  }

  RxBool expListLoading = false.obs;
  String? _latestMonthYear;

  Future fetchWorkExpenseList({
    required String compId,
    required String empId,
    required String monthYear,
  }) async {
    _latestMonthYear = monthYear;
    expListLoading.value = true;
    pendingWorkExpenseList.value = [];
    approvedWorkExpenseList.value = [];
    rejectedWorkExpenseList.value = [];
    try {
      Map<String, dynamic> resp = await ApiServices.getWorkExpenseList(
        compId: compId,
        empId: empId,
        monthYr: monthYear
      );
      if (_latestMonthYear != monthYear) return;
      if (resp['status'] == 200) {
        workExpenseListApi.value = WorkExpenseListModel.fromJson(resp);
        if (workExpenseListApi.value.result != null) {
          workExpenseListApi.value.result?.forEach((expense) {
            if (expense.workExpenseStatus == "0") {
              pendingWorkExpenseList.add(expense);
            } else if (expense.workExpenseStatus == "1") {
              approvedWorkExpenseList.add(expense);
            } else if (expense.workExpenseStatus == "2") {
              rejectedWorkExpenseList.add(expense);
            }
          });
        }
      }
    } catch (e) {
      AttendanceCommonWidgets().printF(
        "------work expense category error-------${e.toString()}",
      );
    } finally {
      if (_latestMonthYear == monthYear) {
        expListLoading.value = false;
      }
    }
  }

  Future<String?> submitWorkExpense({
    required WorkExpenseSubmitModel workExpense,
    required List<String> selectedFile,
    required String selectedMonth,
  }) async {
    buttonLoading.value = true;
    try {
      Map<String, dynamic> resp = await ApiServices.sendWorkExpense(
        workExpenseData: workExpense,
      );
      // workExpenseCategoryApi.value = WorkExpenseCategoryModel.fromJson(resp);
      if (resp['status']?.toString() == '200') {
        if (selectedFile.isNotEmpty && resp['result']['insertedId'] != null) {
          for(String file in selectedFile) {
            await ApiServices.sendExpenseAttachment(
              insertedId: resp['result']['insertedId'].toString(),
              selectedFile: file,
            );
          }
        }
        await fetchWorkExpenseList(
          compId: workExpense.companyId.toString(),
          empId: workExpense.employeId.toString(),
          monthYear: selectedMonth
        );
        return null;
      } else {
        return resp['message'];
      }
    } catch (e) {
      AttendanceCommonWidgets().printF(
        "------work expense submit error-------${e.toString()}",
      );
    } finally {
      buttonLoading.value = false;
    }
    return null;
  }
}
