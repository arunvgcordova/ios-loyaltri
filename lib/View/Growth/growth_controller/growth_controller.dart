
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Task/task_controller/task_controller.dart';
import 'package:loyaltri_minimal/controller/userAuthentication.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';
import 'package:loyaltri_minimal/models/goals_and_subgoals_model.dart';
import 'package:loyaltri_minimal/models/subgoal_tasks_model.dart';
import 'package:loyaltri_minimal/models/task_api_models.dart';
import 'package:loyaltri_minimal/services/api_services.dart';
import '../../../models/growth_home_model.dart';

class GrowthController extends GetxController {
  Rxn<MissionVisionData> missionVisionData = Rxn(null);
  RxBool filterPending = false.obs;
  RxBool filterCompleted = false.obs;
  RxString filterText = ''.obs;
  RxInt avgPercentage = 0.obs;
  int currentYearIndex = 0;
  int currentYearIndexCopy = 0;
  RxnInt currentMoodPulse = RxnInt(null);

  RxList<String> yearString = List.generate(5, (index) {
    final currentYear = DateTime.now().year;

    final year = (currentYear - 3) + index;

    return "$year-${(year + 1).toString().substring(2)}";
  }).obs;

  @override
  void onInit() {
    yearString.value = yearString.value.reversed.toList();
    final currentYear = DateTime.now();
    int targetYear;

    if (currentYear.month >= 4) {
      targetYear = currentYear.year;
    } else {
      targetYear = currentYear.year - 1;
    }

    currentYearIndex = yearString.indexWhere(
          (element) => element.startsWith(targetYear.toString()),
    );
    currentYearIndexCopy = currentYearIndex;
    super.onInit();
  }

  Future<void> fetchGrowthHomeData() async {
    await fetchMissionVision();
    await fetchProgressData();
    await fetchEvaluationList();
    // bool showGoals = (Get.find<UserAuthController>().userData.value.userData?.isGrowthModule ?? false) && (Get.find<UserAuthController>().userData.value.userData?.permissions?.contains(166) ?? false);
    // if(showGoals) {
    //   await fetchGoalsAndSubGoals();
    // }
    await fetchMoodPulse();
  }

  Future<void> fetchMissionVision() async {
    try {
      String? organizationId = Get.find<UserAuthController>().userData.value.userData?.organisationId;
      final resp = await ApiServices.getMissionVision(organizationId: organizationId ?? '');

      debugPrint('-------mission vision resp--------$resp');
      if(resp is Map<String, dynamic>) {
        MissionVisionModel missionVisionModel = MissionVisionModel.fromJson(resp);
        missionVisionData.value = missionVisionModel.data;
      }
    } catch(e) {
      debugPrint('-------mission vision error--------');
    }
  }

  Future<void> fetchProgressData() async {
    try {
      String? employeeId = Get.find<UserProfileController>().userData.value.result.employeeId;
      String? companyId = Get.find<UserProfileController>().userData.value.result.companyId;
      final resp = await ApiServices.getProgress(
        companyId: companyId ?? '',
        employeeId: employeeId ?? '',
      );

      debugPrint('-------progress data resp--------$resp');
      if(resp?['status']?.toString() == '200') {
        ProgressModel progressModel = ProgressModel.fromJson(resp);
        avgPercentage.value = progressModel.data?.overallPercentage?.toInt() ?? 0;
      }
    } catch(e) {
      debugPrint('-------progress data error--------');
    }
  }

  Future<void> fetchMoodPulse() async {
    try {
      String? employeeId = Get.find<UserProfileController>().userData.value.result.employeeId;
      String? companyId = Get.find<UserProfileController>().userData.value.result.companyId;
      final resp = await ApiServices.getMoodPulse(
        companyId: companyId ?? '',
        employeeId: employeeId ?? '',
      );

      debugPrint('-------mood pulse resp--------$resp');
      if(resp?['status']?.toString() == '200') {
        MoodPulseApi moodPulseApi = MoodPulseApi.fromJson(resp);
        currentMoodPulse.value = moodPulseApi.data?.score;
      }
    } catch(e) {
      debugPrint('-------mood pulse error--------');
    }
  }

  RxBool mooPulseSubmitting = false.obs;

  Future<String?> submitMoodPulse({required int score}) async {
    mooPulseSubmitting.value = true;

    String? respMessage;

    try {
      String? employeeId = Get.find<UserProfileController>().userData.value.result.employeeId;
      String? companyId = Get.find<UserProfileController>().userData.value.result.companyId;
      final resp = await ApiServices.submitMoodPulse(
        companyId: companyId ?? '',
        employeeId: employeeId ?? '',
        score: score,
      );

      debugPrint('-------mood pulse resp--------$resp');
      if(resp?['status']?.toString() == '200') {
        MoodPulseSubmitRep moodPulseSubmitRep = MoodPulseSubmitRep.fromJson(resp);
        currentMoodPulse.value = moodPulseSubmitRep.data?.score;
      }
      respMessage = resp?['message'];
    } catch(e) {
      debugPrint('-------mood pulse submit error--------');
    } finally {
      mooPulseSubmitting.value = false;
    }

    return respMessage;
  }

  RxBool evaluationListLoading = false.obs;
  RxList<EvaluationData> evaluationListForHome = <EvaluationData>[].obs;
  RxList<EvaluationData> evaluationList = <EvaluationData>[].obs;
  RxnString homeYear = RxnString();

  Future<void> fetchEvaluationList() async {
    evaluationListLoading.value = true;
    evaluationList.value = [];
    try {
      String? employeeId = Get.find<UserProfileController>().userData.value.result.employeeId;
      String? companyId = Get.find<UserProfileController>().userData.value.result.companyId;
      List<String> parts = yearString.value[currentYearIndex].split('-');
      final resp = await ApiServices.getEvaluationList(
        companyId: companyId ?? '',
        employeeId: employeeId ?? '',
        year: '${parts.first}-20${parts.last}',
      );

      debugPrint('-------evaluation list resp--------$resp');
      if(resp?['status']?.toString() == '200') {
        EvaluationListApi evaluationListApi = EvaluationListApi.fromJson(resp);
        evaluationList.value = evaluationListApi.data ?? [];
        if(currentYearIndexCopy == currentYearIndex) {
          evaluationListForHome.value = evaluationList.value;
          homeYear.value = yearString.value[currentYearIndex];
        }
      }
    } catch(e) {
      debugPrint('-------evaluation list error--------');
    } finally {
      evaluationListLoading.value = false;
    }
  }

  RxList<GoalData> goalsAndSubgoalsList = <GoalData>[].obs;
  RxList<GoalData> goalsAndSubgoalsListCopy = <GoalData>[].obs;
  Rxn<GoalData> selectedGoal = Rxn(null);
  List<ValueNotifier> expansionNotifier = [];
  RxInt totalSubGoals = 0.obs;
  RxBool goalsLoading = false.obs;
  RxBool isInitiallyExpanded = false.obs;

  Future<void> fetchGoalsAndSubGoals({bool? removeList}) async {
    try {
      if(removeList != false) {
        goalsLoading.value = true;
        goalsAndSubgoalsList.value = [];
        goalsAndSubgoalsListCopy.value = [];
        expansionNotifier = [];
      }
      String? employeeId = Get.find<UserProfileController>().userData.value.result.employeeId;
      String? companyId = Get.find<UserProfileController>().userData.value.result.companyId;
      final resp = await ApiServices.getGoalsAndSubGoals(
          companyId: companyId,
          employeeId: employeeId,
      );

      debugPrint('-------goal and subgoal list resp--------$resp');
      if(resp != null) {
        GoalsAndSubgoalsApi goalsAndSubgoalsApi = GoalsAndSubgoalsApi.fromJson(resp);
        if(removeList == false) {
          goalsAndSubgoalsList.value = [];
          goalsAndSubgoalsListCopy.value = [];
          expansionNotifier = [];
        }
        goalsAndSubgoalsList.value = goalsAndSubgoalsApi.data ?? [];
        goalsAndSubgoalsListCopy.value = goalsAndSubgoalsList.value;
        expansionNotifier = List.generate(goalsAndSubgoalsList.value.length, (index) => ValueNotifier(false));
        filterGoals();
        totalSubGoals.value = goalsAndSubgoalsList.value.fold(0, (previousValue, element) => previousValue + (element.children?.length ?? 0));
        if(selectedGoal.value != null) {
          int index = goalsAndSubgoalsListCopy.value.indexWhere((element) => element.goalId == selectedGoal.value?.goalId);
          selectedGoal.value = goalsAndSubgoalsListCopy.value[index];
        }
      }
    } catch(e) {
      debugPrint('-------goal and subgoal list error--------');
    } finally {
      goalsLoading.value = false;
    }
  }

  void filterGoals() async {
    List<GoalData> list = [];
    if(filterPending.value && filterCompleted.value) {
      list.addAll(goalsAndSubgoalsListCopy.value.where((element) => element.goalStatus?.toLowerCase() == 'pending' || element.goalStatus?.toLowerCase() == 'completed').toList());
    } else if(!filterPending.value && !filterCompleted.value) {
      list = goalsAndSubgoalsListCopy.value;
    } else {
      if(filterPending.value) {
        list.addAll(goalsAndSubgoalsListCopy.value.where((element) => element.goalStatus?.toLowerCase() == 'pending').toList());
      }
      if(filterCompleted.value) {
        list.addAll(goalsAndSubgoalsListCopy.value.where((element) => element.goalStatus?.toLowerCase() == 'completed').toList());
      }
    }

    final search = filterText.value.trim().toLowerCase();

    goalsAndSubgoalsList.value = list.where((goal) {
      final parentMatch =
          goal.goalTitile?.trim().toLowerCase().contains(search) ?? false;

      final childMatch =
          goal.children?.any(
                (child) =>
            child.goalTitile?.trim().toLowerCase().contains(search) ?? false,
          ) ??
              false;

      return parentMatch || childMatch;
    }).toList();

    expansionNotifier = List.generate(goalsAndSubgoalsList.value.length, (index) {
      final goal = goalsAndSubgoalsList.value[index];
      final parentMatch = search.isNotEmpty && (goal.goalTitile?.trim().toLowerCase().contains(search) ?? false);
      final childMatch = search.isNotEmpty && (goal.children?.any((child) => child.goalTitile?.trim().toLowerCase().contains(search) ?? false) ?? false);
      return ValueNotifier(childMatch && !parentMatch);
    });
  }

  RxBool commentsLoading = false.obs;
  RxList<CommentData> goalCommentList = <CommentData>[].obs;
  RxList<CommentData> subGoalCommentList = <CommentData>[].obs;

  Future<void> fetchGoalComments({int? goalId, required bool fetchForGoal}) async {
    try {
      commentsLoading.value = true;
      if(fetchForGoal) {
        goalCommentList.value = [];
      } else {
        subGoalCommentList.value = [];
      }
      String? employeeId = Get.find<UserProfileController>().userData.value.result.employeeId;
      String? companyId = Get.find<UserProfileController>().userData.value.result.companyId;
      final resp = await ApiServices.goalComments(
        goalId: goalId,
        employeeId: employeeId,
        companyId: companyId,
      );
      debugPrint('-------goal comments resp--------$resp');
      if(resp?['data'] != null && resp?['data']?.isNotEmpty) {
        CommentListApi commentListApi = CommentListApi.fromJson(resp);
        if(fetchForGoal) {
          goalCommentList.value = commentListApi.data ?? [];
        } else {
          subGoalCommentList.value = commentListApi.data ?? [];
        }
      }
    } catch(e) {
      debugPrint('-------goal comments error--------');
    } finally {
      commentsLoading.value = false;
    }
  }

  String commentText = '';
  RxBool sendingComment = false.obs;
  RxString commentSentError = ''.obs;

  Future<void> sendComment(int? goalId, {required bool isGoal}) async {
    try {
      commentSentError.value = '';
      sendingComment.value = true;
      if(commentText.trim().isNotEmpty) {
        String? employeeId = Get.find<UserProfileController>().userData.value.result.employeeId;
        String? companyId = Get.find<UserProfileController>().userData.value.result.companyId;
        final resp = await ApiServices.commentGoal(
          employeeId: employeeId,
            goalId: goalId,
          comment: commentText
        );

        debugPrint('------------resp---------$resp');
        if(resp?['data'] != null && resp?['data']?.isNotEmpty) {
          final resp = await ApiServices.goalComments(
            goalId: goalId,
            employeeId: employeeId,
            companyId: companyId,
          );

          if(resp?['data']?.isNotEmpty ?? false) {
            CommentListApi commentListApi = CommentListApi.fromJson(resp);
            for (CommentData cmt in (commentListApi.data ?? [])) {
              if(isGoal) {
                if(!goalCommentList.value.any((v) => v.commentId == cmt.commentId)) {
                  goalCommentList.value.insert(0, cmt);
                  goalCommentList.refresh();
                }
              } else {
                if(!subGoalCommentList.value.any((v) => v.commentId == cmt.commentId)) {
                  subGoalCommentList.value.insert(0, cmt);
                  subGoalCommentList.refresh();
                }
              }
            }
          }
        } else {
          commentSentError.value = resp?['message'];
        }
      }
    } catch(e) {
      debugPrint('------------comment sent error---------');
      commentSentError.value = 'Something went wrong';
    } finally {
      sendingComment.value = false;
      commentText = '';
    }
  }

  RxList<ActivityData> goalActivityList = <ActivityData>[].obs;
  RxList<ActivityData> subGoalActivityList = <ActivityData>[].obs;
  Rxn<GoalDetails> subGoalDetails = Rxn(null);
  Rxn<GoalDetails> goalDetails = Rxn(null);
  RxBool activityLoading = false.obs;
  RxBool goalDataLoaded = false.obs;
  RxBool subGoalDataLoaded = false.obs;

  Future<void> fetchGoalDetails(int? goalId, {required bool fetchForGoal}) async {
    try {
      activityLoading.value = true;
      if(fetchForGoal) {
        if(!goalDataLoaded.value) {
          goalActivityList.value = [];
          goalDetails.value = null;
        }
      } else {
        if(!subGoalDataLoaded.value) {
          subGoalActivityList.value = [];
          subGoalDetails.value = null;
        }
      }
      final resp = await ApiServices.goalDetails(goalId: goalId);

      debugPrint('------------activity list resp---------$resp');
      if(resp?['data'] != null) {
        GoalDetailsApi goalDetailsApi = GoalDetailsApi.fromJson(resp);
        if(fetchForGoal) {
          goalDetails.value = goalDetailsApi.data;
          goalActivityList.value = goalDetailsApi.data?.goalActivity ?? [];
          goalDataLoaded.value = true;
        } else {
          subGoalDetails.value = goalDetailsApi.data;
          subGoalActivityList.value = goalDetailsApi.data?.goalActivity ?? [];
          if(goalDetails.value == null) {
            List<GoalData> list = goalsAndSubgoalsList.value.where((element) => element.children?.any((e) => e.goalId == goalId) ?? false).toList();
            if(list.isNotEmpty) {
              await fetchGoalDetails(list.first.goalId, fetchForGoal: true);
            }
          }
          subGoalDataLoaded.value = true;
        }
      }
    } catch(e) {
      debugPrint('------------activity list error---------');
    } finally {
      activityLoading.value = false;
    }
  }

  Future<String?> createSubgoal({int? goalId, int? subGolId, required bool isCreate}) async {
    try {
      Get.find<ManagerTaskController>().submitLoading.value = true;

      String? employeeId = Get.find<UserProfileController>().userData.value.result.employeeId;
      String? organisationId = Get.find<UserAuthController>().userData.value.userData?.organisationId;
      String? companyId = Get.find<UserProfileController>().userData.value.result.companyId;
      CreateTaskModel createTaskModel = Get.find<ManagerTaskController>().draftTaskData.value;
      SaveGoalModel saveGoalModel = SaveGoalModel(
        superiorEmployeeId: int.parse(employeeId ?? '0'),
        organisationId: int.parse(organisationId ?? '0'),
        goalTitile: createTaskModel.workName,
        goalDescription: createTaskModel.description,
        goalTimePeriod: createTaskModel.timePeriodValue,
        goalParentId: !isCreate ? subGolId : goalId,
        subGoalId: goalId,
        assignedEmployees: createTaskModel.assignedToId != null ? [int.parse(createTaskModel.assignedToId!)] : [],
        goalDueDate: createTaskModel.dueDate,
        goalStartDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        goalCompanyId: int.parse(companyId ?? '0'),
        goalCategoryId: 0,
        goalDepartmentId: 0,
        goalLocationId: 0
      );
      var resp;
      if(isCreate) {
        resp = await ApiServices.saveGoal(goalData: saveGoalModel);
      } else {
        resp = await ApiServices.updateGoal(goalData: saveGoalModel);
        await fetchGoalDetails(subGoalDetails.value?.goalId, fetchForGoal: false);
      }
      await fetchGoalsAndSubGoals();
      debugPrint('-----------subgoal create resp------------$resp');
      return resp?['message'];
    } catch(e) {
      debugPrint('-----------subgoal create error------------${e.toString()}');
    } finally {
      Get.find<ManagerTaskController>().submitLoading.value = false;
    }
    return null;
  }

  RxBool deleteLoading = false.obs;

  Future<TaskDashCountModel?> deleteGoal({int? id}) async {
    try {
      deleteLoading.value = true;
      String? employeeId = Get.find<UserProfileController>().userData.value.result.employeeId;
      final resp = await ApiServices.deleteGoal(goalId: id?.toString(), employeeId: employeeId);
      await fetchGoalsAndSubGoals();
      if(resp['status']?.toString() == '200') {
        return TaskDashCountModel(status: 200, message: resp['message']);
      } else {
        return TaskDashCountModel(status: 0, message: resp['message'] ?? resp['error']);
      }
    } catch(e) {
      debugPrint('-----delete goal error------');
    } finally {
      deleteLoading.value = false;
    }
    return null;
  }

  RxList<SubGoalTasksData> subGoalTasks = <SubGoalTasksData>[].obs;
  RxList<SubGoalTasksData> subGoalTasksCopy = <SubGoalTasksData>[].obs;
  RxBool subGoalTasksLoading = false.obs;
  int page = 1;
  int offsetPerPage = 10;
  ScrollController taskScrollController = ScrollController();

  Future<void> fetchSubGoalTaskList({int? id}) async {
    try {
      subGoalTasksLoading.value = true;
      page = 1;
      subGoalTasksCopy.value = [];
      subGoalTasks.value = [];
      final resp = await ApiServices.subGoalTaskList(goalId: id);
      if(resp['data'] != null) {
        SubGoalTasksApi subGoalTasksApi = SubGoalTasksApi.fromJson(resp);
        subGoalTasksCopy.value = subGoalTasksApi.data ?? [];
        if((subGoalTasks.value.length) % 10 == 0 && (subGoalTasks.value.length + offsetPerPage) <= subGoalTasksCopy.value.length) {
          subGoalTasks.value = subGoalTasksCopy.value.sublist(subGoalTasks.value.isEmpty ? subGoalTasks.value.length : subGoalTasks.value.length - 1, page * offsetPerPage);
        } else {
          subGoalTasks.value = subGoalTasksCopy.value;
        }
      }
    } catch(e) {
      debugPrint('-----subGoal task list error------');
    } finally {
      subGoalTasksLoading.value = false;
      taskScrollController.addListener(() {
        if (!taskScrollController.hasClients) return;

        final pixels = taskScrollController.position.pixels;
        final maxScrollExtent = taskScrollController.position.maxScrollExtent;

        final scrollPercent = (pixels / maxScrollExtent) * 100;
        if (scrollPercent >= 100) {
          taskPagination();
        }
      });
    }
  }

  void taskPagination() {
    if((subGoalTasks.value.length) % 10 == 0 && (subGoalTasks.value.length + offsetPerPage) <= subGoalTasksCopy.value.length) {
      List<SubGoalTasksData> tasks = subGoalTasksCopy.value.sublist(subGoalTasks.value.length, page * offsetPerPage);
      subGoalTasks.value.addAll(tasks);
      subGoalTasks.refresh();
      page++;
    }
  }

  Future<TaskDashCountModel?> taskDelete({int? taskId}) async {
    try {
      deleteLoading.value = true;
      String? employeeId = Get.find<UserProfileController>().userData.value.result.employeeId;
      var resp = await ApiServices.taskDelete(taskId: taskId?.toString() ?? '', empId: employeeId);
      if(resp['status']?.toString() == '200') {
        subGoalTasks.value.removeWhere((element) => element.workEntryId == taskId);
        subGoalTasks.refresh();
        return TaskDashCountModel(status: 200, message: resp['message'] ?? 'Something went wrong');
      } else {
        return TaskDashCountModel(status: 0, message: resp['message'] ?? resp['error'] ?? 'Something went wrong');
      }
    } catch (e) {
      return TaskDashCountModel(status: 0, message: 'Something went wrong');
    } finally {
      deleteLoading.value = false;
    }
    return null;
  }

  RxBool unlinkLoading = false.obs;

  Future<TaskDashCountModel?> unlinkTask({int? taskId}) async {
    try {
      unlinkLoading.value = true;
      var resp = await ApiServices.unlinkTask(taskId: taskId);
      if(resp['status']?.toString() == '200') {
        subGoalTasks.value.removeWhere((element) => element.workEntryId == taskId);
        subGoalTasks.refresh();
        return TaskDashCountModel(status: 200, message: resp['message']);
      } else {
        return TaskDashCountModel(status: 0, message: resp['message'] ?? resp['error'] ?? 'Something went wrong');
      }
    } catch (e) {
      return TaskDashCountModel(status: 0, message: 'Something went wrong');
    } finally {
      unlinkLoading.value = false;
    }
    return null;
  }

  Rxn<SelfEvaluationSave> selfReviewData = Rxn(null);
  RxList<CyclePoints> selectedTemplate = <CyclePoints>[].obs;

  CyclePoints? addSelfReviewData(EvaluationData? evaluationData) {
    String? employeeId = Get.find<UserProfileController>().userData.value.result.employeeId;
    String? companyId = Get.find<UserProfileController>().userData.value.result.companyId;
    List<CycleReviews> revs = evaluationData?.cycleReviews?.where((e) => e.isSelfReview == 1).toList() ?? [];
    List<CyclePoints> templates = [];
    evaluationData?.kraTemplate?.forEach((template) {
      if(template.cyclePoints?.isNotEmpty ?? false) {
        templates.addAll(template.cyclePoints ?? []);
      }
    });
    selfReviewData.value = SelfEvaluationSave(
      employeeId: employeeId,
      companyId: companyId,
      superiorEmployeeId: employeeId,
      isSelfReview: 1,
      cycleId: evaluationData?.cycleId,
      reviewId: revs.isNotEmpty ? revs.first.reviewId : null,
      recommentedAction: 0,
      employeeFeedback: '',
      overallComment: '',
      recommentedSubAction: '',
      points: List.generate(templates.length, (index) {
        return Points(
          score: null,
          comments: [],
          cyclePointId: templates[index].cyclePointId,
        );
      }),
    );

    if(templates.isNotEmpty) {
      selectedTemplate.value = templates;
      return templates.first;
    }
    return null;
  }

  CyclePoints? findNextPoint(int index) {
    if(selectedTemplate.value.length > index) {
      return selectedTemplate.value.elementAt(index);
    } else {
      return null;
    }
  }

  RxBool performanceSubmitting = false.obs;

  Future<TaskDashCountModel?> submitSelfReview() async {
    try {
      performanceSubmitting.value = true;
      final resp = await ApiServices.savePerformance(data: selfReviewData.value);
      debugPrint('--------resp----------$resp');
      if(resp['status']?.toString() == '200') {
        return TaskDashCountModel(status: 200, message: resp['message']);
      } else {
        return TaskDashCountModel(status: 0, message: resp['message'] ?? resp['error']);
      }
    } catch(e) {
      return TaskDashCountModel(status: 0, message: 'Something went wrong');
    } finally {
      performanceSubmitting.value = false;
    }
  }
}