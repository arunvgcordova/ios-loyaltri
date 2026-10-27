
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loyaltri_minimal/View/Growth/growth_controller/growth_controller.dart';
import 'package:loyaltri_minimal/controller/ui_controller/home_controller.dart';
import 'package:loyaltri_minimal/controller/ui_controller/page_controller.dart';
import 'package:loyaltri_minimal/models/goals_and_subgoals_model.dart';
import 'package:loyaltri_minimal/models/task_api_models.dart';
import 'package:loyaltri_minimal/services/api_services.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../controller/locationFetchController.dart';
import '../../../../controller/userAuthentication.dart';
import '../../../../controller/userProfileController.dart';
import '../../Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import '../../Manager_Attendance/manager_attendance_controller/manager_attendance_controller.dart';

class ManagerTaskController extends GetxController {
  RxInt currentTabIndex = 0.obs;
  String attachmentsFolder = 'TaskAttachments';
  bool isFromEmployee = false;
  RxList<TaskTabModel> allTabs = [
    TaskTabModel(title: 'My Tasks', count: '0'),
    TaskTabModel(title: 'Created by me', count: '0'),
    if(Get.find<UserPageController>().appView.value == AppView.manager)
      TaskTabModel(title: 'Team', count: '0'),
  ].obs;
  RxList<FilterModel> filters = <FilterModel>[
    FilterModel(
      filterTitle: "Due Status",
      isExpanded: false,
      filters: [
        Filters(
            id: "completed",
            name: "Completed",
            isSelected: false,
        ),
        Filters(
            id: "incomplete",
            name: "Incomplete Tasks",
            isSelected: false,
        ),
        Filters(
            id: "overdue",
            name: "Overdue",
            isSelected: false,
        ),
        Filters(
            id: "today",
            name: "Due Today",
            isSelected: false,
        ),
        Filters(
            id: "dueInSeven",
            name: "Due in 7 days",
            isSelected: false,
        ),
        Filters(
            id: "completedInSeven",
            name: "Completed in 7 days",
            isSelected: false,
        ),
      ],
    ),
    FilterModel(
      filterTitle: "Assignee",
      isExpanded: false,
      filters: [],
    ),
    FilterModel(
      filterTitle: "Created on",
      isExpanded: false,
      filters: [],
    ),
  ].obs;

  void updateTabs(AppView appView) {
    allTabs.value = [
      TaskTabModel(title: 'My Tasks', count: taskDashBoardCounts.value?.assignedToMeCount?.toString() ?? "0"),
      TaskTabModel(title: 'Created by me', count: taskDashBoardCounts.value?.createdByMeCount?.toString() ?? "0"),
      if (appView == AppView.manager)
        TaskTabModel(title: 'Team', count: taskDashBoardCounts.value?.teamCount?.toString() ?? "0"),
    ];
  }

  @override
  void onInit() {
    super.onInit();

    // Initial setup
    updateTabs(Get.find<UserPageController>().appView.value);

    // Listen to changes in appView
    ever<AppView>(
      Get.find<UserPageController>().appView,
          (newAppView) {
        updateTabs(newAppView);
      },
    );
  }

  bool get isFilterApplied =>
      filters.value.any((element) => element.filters.any((filter) => filter.isSelected));

  List<Filters> employees = [];

  void searchFilter(String text) {
    if(employees.isEmpty) {
      employees.addAll(filters.value[1].filters);
    }

    filters.value[1].filters = employees.where((emp) => emp.name.trim().toLowerCase().contains(text.trim().toLowerCase())).toList();
    filters.refresh();
  }

  void updateExpansion(int index) {
    filters[index].isExpanded = !filters[index].isExpanded;
    filters.refresh();
  }

  Rxn<Counts> taskDashBoardCounts = Rxn(null);
  RxBool taskLoading = false.obs;
  RxBool taskLoaded = false.obs;
  RxBool taskError = false.obs;

  Future<void> fetchTaskDashboardCount({required String empId, required String compId}) async {
    try {
      taskLoading.value = true;
      taskLoaded.value = false;
      taskError.value = false;
      allTabs.value[0].count = "0";
      allTabs.value[1].count = "0";
      if(allTabs.value.length == 3) {
        allTabs.value[2].count = "0";
      }
      allTabs.refresh();
      Map<String, dynamic> resp = await ApiServices.taskDashboardCount(
          compId: compId,
          empId: empId,
        filterName: currentTabIndex.value == 0
            ? "1"
            : currentTabIndex.value == 1
            ? "2"
            : currentTabIndex.value == 2
            ? "3"
            : "",
      );
      TaskDashCountModel taskDashCountModel = TaskDashCountModel.fromJson(resp);
      taskDashBoardCounts.value = taskDashCountModel.result?.counts;
      allTabs.value[0].count = taskDashBoardCounts.value?.assignedToMeCount?.toString() ?? "0";
      allTabs.value[1].count = taskDashBoardCounts.value?.createdByMeCount?.toString() ?? "0";
      if(allTabs.value.length == 3) {
        allTabs.value[2].count = taskDashBoardCounts.value?.teamCount?.toString() ?? "0";
      }
      allTabs.refresh();
      taskLoaded.value = true;
    } catch(e) {
      taskError.value = true;
      AttendanceCommonWidgets().printF("--------task dashboard count error-----------");
    } finally {
      taskLoading.value = false;
    }
  }

  RxBool taskNextPageLoading = false.obs;
  int currentPage = 1;
  int lastLength = 0;
  bool stopLoading = false;
  RxList<TaskData> taskList = <TaskData>[].obs;
  RxList<TaskData> taskListCopy = <TaskData>[].obs;
  Rxn<ListDashCounts> taskListCounts = Rxn(null);
  Rxn<TemplateData> templateData = Rxn(null);

  Future<void> fetchTaskListData({required String empId, required String compId, bool? nextPage}) async {
    if(!(nextPage ?? false)) {
      stopLoading = false;
    }
    if(!stopLoading) {
      if(nextPage ?? false) {
        taskNextPageLoading.value = true;
        currentPage += 1;
      } else {
        taskList.value = [];
        taskListCounts.value = null;
        taskLoading.value = true;
        currentPage = 1;
      }
      taskLoaded.value = false;
      taskError.value = false;
      try {
        List<Filters> status = filters.value[0].filters.where((element) => element.isSelected == true).toList();
        List<Filters> assignee = filters.value[1].filters.where((element) => element.isSelected == true).toList();
        List<Filters> dates = filters.value[2].filters.where((element) => element.isSelected == true).toList();
        Map<String, dynamic> resp = await ApiServices.getTaskListData(
            currentPage: currentPage,
            compId: compId,
            empId: empId,
            filterName: currentTabIndex.value == 0
                ? "assigned-me"
                : currentTabIndex.value == 1
                ? "created-me"
                : currentTabIndex.value == 2
                ? "my-team-task"
                : "all",
            filterArray: {
              if(status.isNotEmpty)
                "status": [
                  for(int  i = 0; i < status.length; i++)
                    status[i].id,
                ],
              if(assignee.isNotEmpty)
                "assignee": [
                  for(int  i = 0; i < assignee.length; i++)
                    assignee[i].id,
                ],
              if(dates.isNotEmpty)
                "createdOn": [
                  for(int  i = 0; i < dates.length; i++)
                    dates[i].id,
                ],
            }
        );
        AttendanceCommonWidgets().printF("-------ticket list resp------------$resp");
        if(resp['status'].toString() == "200") {
          TaskListApiModel taskListApiModel = TaskListApiModel.fromJson(resp);
          if(nextPage ?? false) {
            taskListCopy.value.addAll(taskListApiModel.result?.data ?? []);
            taskList.value.addAll(taskListApiModel.result?.data ?? []);
          } else {
            taskListCopy.value = taskListApiModel.result?.data ?? [];
            taskList.value = taskListApiModel.result?.data ?? [];
          }
          for (TaskData task in taskList.value) {
            for (FieldData field in (task.fieldData ?? [])) {
              for (Options item in (field.options ?? [])) {
                if (item.value == "#000") {
                  item.value = "";
                }
              }
            }
          }

          if(taskListCopy.length == lastLength && taskNextPageLoading.value) {
            currentPage -= 1;
            stopLoading = true;
          }
          lastLength = taskListCopy.length;

          templateData.value = taskListApiModel.result?.templateData;
          taskListCounts.value = taskListApiModel.result?.counts;
          filterTaskList(text: searchValue);
          taskLoaded.value = true;
        } else {
          if(taskListCopy.length == lastLength && taskNextPageLoading.value) {
            currentPage -= 1;
            stopLoading = true;
          }
          lastLength = taskListCopy.length;
        }
      } catch(e) {
        taskError.value = true;
        AttendanceCommonWidgets().printF("--------task list error-----------");
      } finally {
        taskLoading.value = false;
        taskNextPageLoading.value = false;
      }
    }
  }

  String searchValue = '';

  void filterTaskList({required String text}) {
    searchValue = text;
    taskList.value = taskListCopy.value.where((element) => (element.workName?.toString().toLowerCase().contains(text.toLowerCase()) ?? false) || (element.employeeName?.toLowerCase().toLowerCase().contains(text.toLowerCase()) ?? false)).toList();
  }

  Future<void> fetchTaskExtraFieldData({bool? callTimePeriod}) async {
    draftTaskData.value.fieldData = [];
    List<FieldData> extraFieldList = [];
    try {
      if(callTimePeriod ?? false) {
        final timePeriod = await ApiServices.getTimePeriod();

        debugPrint('---------time period resp---------$timePeriod');
        if(timePeriod?['data'] != null && timePeriod?['data']?.isNotEmpty) {
          extraFieldList.add(
              FieldData(
                fieldType: 'dropdown',
                options: [
                  for(var period in (timePeriod?['data'] ?? []))
                    Options(
                      key: "${period?['label']}<#>${period?['value']}",
                      value: period?['value'],
                    ),
                ],
                fieldName: 'Time Period',
                textEditingController: TextEditingController(),
              )
          );
        }
      } else {
        Map<String, dynamic> resp = await ApiServices.getTaskExtraFields(
          tempId: templateData.value?.templateId?.toString() ?? '',
        );
        TaskExtraFieldApiModel taskExtraFieldApiModel = TaskExtraFieldApiModel.fromJson(resp);
        extraFieldList = taskExtraFieldApiModel.result ?? [];
        for(int i = 0; i < extraFieldList.length; i++) {
          if(extraFieldList[i].fieldType == 'dropdown') {
            extraFieldList[i].options?.insert(0, Options(key: 'Select', value: 'Select'));
            extraFieldList[i].value = ['Select'];
          } else if(extraFieldList[i].fieldType == 'text') {
            extraFieldList[i].textEditingController = TextEditingController();
          }
          for (Options item in (extraFieldList[i].options ?? [])) {
            if (item.value == "#000") {
              item.value = "";
            }
          }
        }

        FieldData? subGoals = await fetchSubGoalList();

        if(subGoals != null) {
          extraFieldList.insert(0, subGoals);
          List<Options> options = subGoals.options?.where((e) => e.value == draftTaskData.value.subGoalId).toList() ?? [];
          if(options.isNotEmpty) {
            extraFieldList[0].value = [options.first.key ?? ''];
          }
        }
      }
      draftTaskData.value.fieldData?.addAll(extraFieldList);
      for (var element in extraFieldList) {
        print('--------extraFieldList-----${element.toJson()}');
      }
      draftTaskData.refresh();
    } catch(e) {
      AttendanceCommonWidgets().printF("--------task extra field error-----------");
    }
  }

  Future<FieldData?> fetchSubGoalList() async {
    FieldData? fieldData;
    try {
      String companyId = Get.find<UserProfileController>().currentCompany.value?.companyId?.toString() ?? Get.find<UserProfileController>().userData.value.result.companyId?.toString() ?? '';
      String employeeId = Get.find<UserAuthController>().userData.value.userData?.employeeId ?? '';
      final subGoals = await ApiServices.getSubGoals(
        compId: companyId,
        empId: employeeId,
        admin: Get.find<UserAuthController>().userData.value.userData?.loginType == 3,
      );

      if(subGoals['status']?.toString() == '200') {
        SubGoalsForTaskApi subGoalsForTaskApi = SubGoalsForTaskApi.fromJson(subGoals);
        for(SubGoalData subGoal in (subGoalsForTaskApi.result ?? [])) {
          print('-------subGoalTitle--------${subGoal.subGoalTitle}');
          print('-------subGoalId--------${subGoal.subGoalId}');
        }
        fieldData = FieldData(
          fieldType: 'dropdown',
          options: [
            for(SubGoalData subGoal in (subGoalsForTaskApi.result ?? []))
              Options(
                key: "${subGoal.subGoalTitle}<#>${subGoal.subGoalId}",
                value: subGoal.subGoalId,
              ),
          ],
          fieldName: 'Subgoal',
          textEditingController: TextEditingController(),
        );
      }
    } catch(e) {} finally {}
    return fieldData;
  }

  RxList<ActivityLog> activityLogList = <ActivityLog>[].obs;
  Rxn<TaskDetailedData> detailedTaskData = Rxn(null);

  Future<void> fetchTaskDetailedResp({required String taskId}) async {
    activityLogList.value = [];
    try {
      Map<String, dynamic> resp = await ApiServices.getTaskInDetail(
        taskId: taskId,
      );
      TaskDetailApi taskDetailApi = TaskDetailApi.fromJson(resp);
      detailedTaskData.value = taskDetailApi.result?.data;
      for(int i = 0; i < (taskDetailApi.result?.data?.fieldData?.length ?? 0); i++) {
        if(taskDetailApi.result?.data?.fieldData?[i].fieldType == 'dropdown') {
          if(!(taskDetailApi.result?.data?.fieldData?[i].options?.any((element) => element.key?.trim().toLowerCase() == 'select') ?? false)) {
            taskDetailApi.result?.data?.fieldData?[i].options?.insert(0, Options(key: 'Select', value: 'Select'));
          }
          taskDetailApi.result?.data?.fieldData?[i].value = [(taskDetailApi.result?.data?.fieldData?[i].value?.isNotEmpty ?? false) ? (taskDetailApi.result?.data?.fieldData?[i].value?.first ?? '') : 'Select'];
        } else if(taskDetailApi.result?.data?.fieldData?[i].fieldType == 'text') {
          taskDetailApi.result?.data?.fieldData?[i].textEditingController = TextEditingController(text: (taskDetailApi.result?.data?.fieldData?[i].value?.isNotEmpty ?? false) ? (taskDetailApi.result?.data?.fieldData?[i].value?.first ?? '') : '');
        }
        for (Options item in (taskDetailApi.result?.data?.fieldData?[i].options ?? [])) {
          if (item.value == "#000") {
            item.value = "";
          }
        }
      }
      FieldData? subGoals = await fetchSubGoalList();

      if(subGoals != null) {
        taskDetailApi.result?.data?.fieldData?.insert(0, subGoals);
        List<Options> options = subGoals.options?.where((e) => e.value == detailedTaskData.value?.subGoalId).toList() ?? [];
        if(options.isNotEmpty) {
          taskDetailApi.result?.data?.fieldData?[0].value = [options.first.key ?? ''];
          draftTaskData.value.subGoalId = options.first.value;
        }
      }
      draftTaskData.value = CreateTaskModel(
        workName: taskDetailApi.result?.data?.workName,
        description: taskDetailApi.result?.data?.description,
        assignedToId: taskDetailApi.result?.data?.assignedTo,
        assignedToName: taskDetailApi.result?.data?.assignedEmployeeName,
        attachment: taskDetailApi.result?.data?.attachments ?? [],
        dueDate: taskDetailApi.result?.data?.dueDate,
        locationData: LocationData.fromRawApiString(taskDetailApi.result?.data?.location ?? ''),
        fieldData: taskDetailApi.result?.data?.fieldData,
      );
      // const JsonEncoder encoder = JsonEncoder.withIndent('  ');
      // String prettyJson = encoder.convert(draftTaskData.value.toJson());
      // log("---------draftTaskData--------$prettyJson");
      draftTaskData.refresh();
      activityLogList.value = taskDetailApi.result?.activityLog ?? [];
    } catch(e) {
      AttendanceCommonWidgets().printF("--------activity log error-----------");
    }
  }

  RxBool locationLoading = false.obs;

  Future<void> addLocationData() async {
    locationLoading.value = true;
    try {
      LocationFetchController locationFetchController = Get.find<LocationFetchController>();
      await locationFetchController.fetchLocationData();
      draftTaskData.value.locationData ??= LocationData();
      draftTaskData.value.locationData?.latitude = locationFetchController.position.value?.latitude.toString() ?? '';
      draftTaskData.value.locationData?.longitude = locationFetchController.position.value?.longitude.toString() ?? '';
      draftTaskData.value.locationData?.locationName = locationFetchController.locName.value ?? '';
      draftTaskData.refresh();
    } catch(e) {} finally {
      locationLoading.value = false;
    }
  }

  Rx<CreateTaskModel> draftTaskData = CreateTaskModel().obs;
  RxBool submitLoading = false.obs;

  Future<void> createNewTask(BuildContext context, String? taskId) async {
    FieldData? subGoalFieldData;
    try {
      submitLoading.value = true;
      UserProfileController userProfileController = Get.find<UserProfileController>();
      LocationFetchController locationFetchController = Get.find<LocationFetchController>();
      String empId = userProfileController.userData.value.result.employeeId ?? '';
      String compId = userProfileController.currentCompany.value?.companyId?.toString() ?? userProfileController.userData.value.result.companyId ?? '';
      draftTaskData.value.templateId = templateData.value?.templateId?.toString() ?? '';
      draftTaskData.value.supervisorId = empId;
      draftTaskData.value.companyId = compId;
      if(taskId == null) {
        draftTaskData.value.locationData ??= LocationData();
        draftTaskData.value.locationData?.latitude = locationFetchController.position.value?.latitude.toString() ?? '';
        draftTaskData.value.locationData?.longitude = locationFetchController.position.value?.longitude.toString() ?? '';
        draftTaskData.value.locationData?.locationName = locationFetchController.locName.value;
      } else {
        draftTaskData.value.locationData = null;
      }
      for(int i = 0; i < (draftTaskData.value.fieldData?.length ?? 0); i++) {
        if(draftTaskData.value.fieldData?[i].fieldName == 'Subgoal') {
          subGoalFieldData = draftTaskData.value.fieldData?[i];
          draftTaskData.value.fieldData?.removeAt(i);
        }
      }
      for(int i = 0; i < (draftTaskData.value.fieldData?.length ?? 0); i++) {
        if(draftTaskData.value.fieldData?[i].fieldType == 'dropdown') {
          if(draftTaskData.value.fieldData?[i].value?.contains('Select') ?? false) {
            draftTaskData.value.fieldData?[i].value?.remove('Select');
          }
        }
      }
      for (int i = (draftTaskData.value.attachment?.length ?? 0) - 1; i >= 0; i--) {
        final attachment = draftTaskData.value.attachment?[i];
        if (attachment != null && attachment.contains('http')) {
          String path = await downloadFileToFolder(attachment);
          draftTaskData.value.attachment?[i] = path;
        }
      }

      var resp = await ApiServices.createNewTask(createTask: draftTaskData.value, taskId: taskId);
      AttendanceCommonWidgets().printF("-------task add resp-------$resp");

      if(resp['status']?.toString() == '200') {
        await fetchTaskListData(empId: empId, compId: compId);
        bool showGoals = (Get.find<UserAuthController>().userData.value.userData?.isGrowthModule ?? false) && (Get.find<UserAuthController>().userData.value.userData?.permissions?.contains(166) ?? false);
        if(showGoals) {
          if(Get.find<GrowthController>().subGoalDetails.value != null) {
            await Get.find<GrowthController>().fetchGoalsAndSubGoals();
            await Get.find<GrowthController>().fetchGoalDetails(Get.find<GrowthController>().subGoalDetails.value?.goalId, fetchForGoal: false);
            await Get.find<GrowthController>().fetchSubGoalTaskList(id: Get.find<GrowthController>().subGoalDetails.value?.goalId);
          }
        }
        AttendanceCommonWidgets().showSnackBar(
          context: context,
          backgroundColor: Colors.green,
          message: resp['message']?.toString() ?? (taskId != null ? 'Task updated' : 'Task created successfully'),
        );

        Navigator.of(context).pop();
      } else {
        if(subGoalFieldData != null) {
          draftTaskData.value.fieldData?.insert(0,
              subGoalFieldData
          );
        }
        AttendanceCommonWidgets().showSnackBar(
          context: context,
          backgroundColor: Colors.red,
          message: resp['message']?.toString() ?? 'Something went wrong',
        );
      }
    } catch(e) {
      AttendanceCommonWidgets().showSnackBar(
        context: context,
        backgroundColor: Colors.red,
        message: 'Something went wrong',
      );
    } finally {
      submitLoading.value = false;
    }
  }

  Future<String> downloadFileToFolder(String url) async {
    await requestPermission();
    final baseDir = await getApplicationDocumentsDirectory();
    final dir = Directory('${baseDir.path}/$attachmentsFolder');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    // Generate unique file name
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final fileName = 'file_$timestamp';

    final savePath = '${dir.path}/$fileName';

    final dioObj = dio.Dio();
    await dioObj.download(url, savePath);

    AttendanceCommonWidgets().printF('File downloaded to: $savePath');
    return savePath;
  }

  Future<void> requestPermission() async {
    if (await Permission.storage.request().isDenied) {
      // Handle denial (open settings, show warning, etc.)
    }
  }


  Future<void> deleteAllFilesInDirectory() async {
    await requestPermission();
    final baseDir = await getApplicationDocumentsDirectory();
    final dir = Directory('${baseDir.path}/$attachmentsFolder');
    if (await dir.exists()) {
      final List<FileSystemEntity> files = dir.listSync();

      for (FileSystemEntity file in files) {
        if (file is File) {
          await file.delete();
        } else if (file is Directory) {
          // If there are subdirectories, delete them recursively
          await file.delete(recursive: true);
        }
      }

      AttendanceCommonWidgets().printF('All files deleted from: ${dir.path}');
    } else {
      AttendanceCommonWidgets().printF('Directory does not exist: ${dir.path}');
    }
  }

  RxBool markingComplete = false.obs;
  RxnString? markingTaskId = RxnString();

  Future<void> updateTaskComplete({required String taskId}) async {
    try {
      markingComplete.value = true;
      UserProfileController userProfileController = Get.find<UserProfileController>();
      LocationFetchController locationFetchController = Get.find<LocationFetchController>();
      String empId = userProfileController.userData.value.result.employeeId ?? '';
      String compId = userProfileController.currentCompany.value?.companyId?.toString() ?? userProfileController.userData.value.result.companyId ?? '';
      List<String> completedTasks = taskListCopy.value.where((element) => element.status?.trim().toLowerCase() == 'completed').toList().map((e) => e.workEntryId.toString()).toList();
      String selectedStatus = taskListCopy.value.singleWhere((element) => taskId == element.workEntryId?.toString()).status?.trim().toLowerCase() ?? '';
      if(selectedStatus == 'completed') {
        completedTasks.remove(taskId);
      } else {
        completedTasks.add(taskId);
      }

      var resp = await ApiServices.updateTaskStatus(
          taskIds: completedTasks,
          empId: empId,
          compId: compId,
          location: locationFetchController.locName.value ?? '',
      );
      if(resp['status']?.toString() == '200') {
        if(selectedStatus == 'completed') {
          taskList.value.singleWhere((element) => element.workEntryId?.toString() == taskId).status = 'incomplete';
        } else {
          taskList.value.singleWhere((element) => element.workEntryId?.toString() == taskId).status = 'completed';
        }
        taskList.refresh();
        await fetchTaskDetailedResp(taskId: taskId);
        bool showGoals = (Get.find<UserAuthController>().userData.value.userData?.isGrowthModule ?? false) && (Get.find<UserAuthController>().userData.value.userData?.permissions?.contains(166) ?? false);
        if(showGoals) {
          await Get.find<GrowthController>().fetchGoalsAndSubGoals();
        }
      }
    } catch(_) {} finally {
      markingComplete.value = false;
      markingTaskId?.value = null;
    }
  }

  RxBool deletionWorking = false.obs;
  RxBool deleteSuccess = false.obs;

  Future<void> taskDelete({required BuildContext context, required String taskId}) async {
    try {
      deletionWorking.value = true;
      deleteSuccess.value = false;
      String? employeeId = Get.find<UserProfileController>().userData.value.result.employeeId;
      var resp = await ApiServices.taskDelete(taskId: taskId, empId: employeeId);
      if(resp['status']?.toString() == '200') {
        // UserProfileController userProfileController = Get.find<UserProfileController>();
        // String empId = userProfileController.userData.value.result.employeeId ?? '';
        // String compId = userProfileController.currentCompany.value?.companyId?.toString() ?? userProfileController.userData.value.result.companyId ?? '';
        // await fetchTaskListData(empId: empId, compId: compId);
        bool showGoals = (Get.find<UserAuthController>().userData.value.userData?.isGrowthModule ?? false) && (Get.find<UserAuthController>().userData.value.userData?.permissions?.contains(166) ?? false);
        if(showGoals) {
          await Get.find<GrowthController>().fetchGoalsAndSubGoals();
        }
        if(currentTabIndex.value == 0) {
          allTabs.value[0].count = (int.parse(allTabs.value[0].count) - 1).toString();
        } else if(currentTabIndex.value == 1) {
          allTabs.value[1].count = (int.parse(allTabs.value[1].count) - 1).toString();
        } else if(currentTabIndex.value == 2) {
          allTabs.value[2].count = (int.parse(allTabs.value[2].count) - 1).toString();
        }
        taskList.value.removeWhere((element) => element.workEntryId?.toString() == taskId);
        taskListCopy.value.removeWhere((element) => element.workEntryId?.toString() == taskId);
        allTabs.refresh();
        taskList.refresh();
        AttendanceCommonWidgets().showSnackBar(
          context: Get.context!,
          backgroundColor: Colors.green,
          message: resp['message']?.toString() ?? 'Task deleted successfully',
        );
        deleteSuccess.value = true;
      } else {
        AttendanceCommonWidgets().showSnackBar(
          context: Get.context!,
          backgroundColor: Colors.red,
          message: resp['message']?.toString() ?? 'Something went wrong',
        );
      }
    } catch(e) {} finally {
      deletionWorking.value = false;
    }
  }

  Color getFilterColors(String type) {
    switch (type) {
      case 'completed': return ColorUtils.paleLavenderMist;
      case 'incomplete': return ColorUtils.paleLavenderMist;
      case 'overdue': return ColorUtils.blushPink;
      case 'today': return ColorUtils.warmIvory;
      case 'dueInSeven': return Color(0xFFE9F3FC);
      case 'completedInSeven': return ColorUtils.mindWhisper;
      case 'assignee': return ColorUtils.paleLavenderMist;
      default: return _getRandomLightColor();
    }
  }

  Color _getRandomLightColor() {
    final Random random = Random();
    // Generate RGB values between 180–255 to ensure light colors
    int r = 180 + random.nextInt(75);
    int g = 180 + random.nextInt(75);
    int b = 180 + random.nextInt(75);
    return Color.fromARGB(255, r, g, b);
  }

  String getFilterCounts(String type) {
    switch (type) {
      case 'completed': return taskListCounts.value?.completedCount?.toString() ?? '0';
      case 'incomplete': return taskListCounts.value?.incompleteCount?.toString() ?? '0';
      case 'overdue': return taskListCounts.value?.overdueCount?.toString() ?? '0';
      case 'today': return taskListCounts.value?.dueTodayCount?.toString() ?? '0';
      case 'dueInSeven': return taskListCounts.value?.overdueSevendayCount?.toString() ?? '0';
      case 'completedInSeven': return taskListCounts.value?.completedSevendayCount?.toString() ?? '0';
      case 'assignee': return taskListCounts.value?.assignee?.length.toString() ?? '0';
      default: return '0';
    }
  }
}

class TaskTabModel {
  final String title;
  String count;

  TaskTabModel({required this.title, required this.count});
}