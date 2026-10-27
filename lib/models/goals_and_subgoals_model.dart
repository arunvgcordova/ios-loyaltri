class GoalsAndSubgoalsApi {
  String? message;
  List<GoalData>? data;

  GoalsAndSubgoalsApi({this.message, this.data});

  GoalsAndSubgoalsApi.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <GoalData>[];
      json['data'].forEach((v) {
        data!.add(new GoalData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GoalData {
  int? goalId;
  String? goalParentId;
  int? goalDepartmentId;
  String? goalDueDate;
  String? goalStatus;
  String? goalPriority;
  String? goalTimePeriod;
  String? goalTitile;
  Department? department;
  Employee? employee;
  List<Children>? children;
  String? employeeName;
  String? goalTimePeriodLabel;
  String? assignedEmployeeProfile;
  String? getEmployeeDesignation;
  String? goalDescription;
  int? goalProgress;

  GoalData({
    this.goalId,
    this.goalParentId,
    this.goalDepartmentId,
    this.goalDueDate,
    this.goalStatus,
    this.goalPriority,
    this.goalTimePeriod,
    this.goalTitile,
    this.department,
    this.employee,
    this.children,
    this.employeeName,
    this.goalTimePeriodLabel,
    this.assignedEmployeeProfile,
    this.getEmployeeDesignation,
    this.goalDescription,
    this.goalProgress,
  });

  GoalData.fromJson(Map<String, dynamic> json) {
    goalId = json['goalId'];
    goalParentId = json['goalParentId'];
    goalDepartmentId = json['goalDepartmentId'];
    goalDueDate = json['goalDueDate'];
    goalStatus = json['goalStatus'];
    goalPriority = json['goalPriority'];
    goalTimePeriod = json['goalTimePeriod'];
    goalTitile = json['goalTitile'];
    department = json['department'] != null
        ? new Department.fromJson(json['department'])
        : null;
    employee = json['employee'] != null
        ? new Employee.fromJson(json['employee'])
        : null;
    if (json['children'] != null) {
      children = <Children>[];
      json['children'].forEach((v) {
        children!.add(
          new Children.fromJson(v, parentGoalTitle: json['goalTitile']),
        );
      });
    }
    employeeName = json['employeeName'];
    goalTimePeriodLabel = json['goalTimePeriodLabel'];
    assignedEmployeeProfile = json['assignedEmployeeProfile'];
    getEmployeeDesignation = json['getEmployeeDesignation'];
    goalDescription = json['goalDescription'];
    goalProgress = json['goalProgress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['goalId'] = this.goalId;
    data['goalParentId'] = this.goalParentId;
    data['goalDepartmentId'] = this.goalDepartmentId;
    data['goalDueDate'] = this.goalDueDate;
    data['goalStatus'] = this.goalStatus;
    data['goalPriority'] = this.goalPriority;
    data['goalTimePeriod'] = this.goalTimePeriod;
    data['goalTitile'] = this.goalTitile;
    if (this.department != null) {
      data['department'] = this.department!.toJson();
    }
    if (this.employee != null) {
      data['employee'] = this.employee!.toJson();
    }
    if (this.children != null) {
      data['children'] = this.children!.map((v) => v.toJson()).toList();
    }
    data['employeeName'] = this.employeeName;
    data['goalTimePeriodLabel'] = this.goalTimePeriodLabel;
    data['assignedEmployeeProfile'] = this.assignedEmployeeProfile;
    data['getEmployeeDesignation'] = this.getEmployeeDesignation;
    data['goalDescription'] = this.goalDescription;
    data['goalProgress'] = this.goalProgress;
    return data;
  }
}

class Department {
  String? department;

  Department({this.department});

  Department.fromJson(Map<String, dynamic> json) {
    department = json['department'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['department'] = this.department;
    return data;
  }
}

class Employee {
  String? firstName;
  String? middleName;
  String? lastName;
  String? profilePicture;

  Employee({
    this.firstName,
    this.middleName,
    this.lastName,
    this.profilePicture,
  });

  Employee.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    middleName = json['middleName'];
    lastName = json['lastName'];
    profilePicture = json['profilePicture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['middleName'] = this.middleName;
    data['lastName'] = this.lastName;
    data['profilePicture'] = this.profilePicture;
    return data;
  }
}

class Children {
  int? goalId;
  int? goalParentId;
  int? goalDepartmentId;
  String? goalDueDate;
  String? goalStatus;
  String? goalPriority;
  String? goalTimePeriod;
  String? goalTitile;
  String? parentGoal;
  Department? department;
  Employee? employee;
  List<Children>? children;
  String? employeeName;
  String? goalTimePeriodLabel;
  String? assignedEmployeeProfile;
  String? goalDescription;
  double? goalProgress;
  TaskCountData? taskCount;

  Children({
    this.goalId,
    this.goalParentId,
    this.goalDepartmentId,
    this.goalDueDate,
    this.goalStatus,
    this.goalPriority,
    this.goalTimePeriod,
    this.goalTitile,
    this.parentGoal,
    this.department,
    this.employee,
    this.children,
    this.employeeName,
    this.goalTimePeriodLabel,
    this.assignedEmployeeProfile,
    this.goalDescription,
    this.taskCount,
    this.goalProgress,
  });

  Children.fromJson(Map<String, dynamic> json, {String? parentGoalTitle}) {
    goalId = json['goalId'];
    goalParentId = json['goalParentId'];
    goalDepartmentId = json['goalDepartmentId'];
    goalDueDate = json['goalDueDate'];
    goalStatus = json['goalStatus'];
    goalPriority = json['goalPriority'];
    goalTimePeriod = json['goalTimePeriod'];
    goalTitile = json['goalTitile'];
    parentGoal = parentGoalTitle;
    department = json['department'] != null
        ? new Department.fromJson(json['department'])
        : null;
    employee = json['employee'] != null
        ? new Employee.fromJson(json['employee'])
        : null;
    if (json['children'] != null) {
      children = <Children>[];
      json['children'].forEach((v) {
        children!.add(new Children.fromJson(v));
      });
    }
    employeeName = json['employeeName'];
    goalTimePeriodLabel = json['goalTimePeriodLabel'];
    assignedEmployeeProfile = json['assignedEmployeeProfile'];
    goalDescription = json['goalDescription'];
    goalProgress = double.tryParse(json['goalProgress']?.toString() ?? '0');
    taskCount = TaskCountData.fromJson(json['taskCount']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['goalId'] = this.goalId;
    data['goalParentId'] = this.goalParentId;
    data['goalDepartmentId'] = this.goalDepartmentId;
    data['goalDueDate'] = this.goalDueDate;
    data['goalStatus'] = this.goalStatus;
    data['goalPriority'] = this.goalPriority;
    data['goalTimePeriod'] = this.goalTimePeriod;
    data['goalTitile'] = this.goalTitile;
    data['parentGoal'] = this.parentGoal;
    if (this.department != null) {
      data['department'] = this.department!.toJson();
    }
    if (this.employee != null) {
      data['employee'] = this.employee!.toJson();
    }
    if (this.children != null) {
      data['children'] = this.children!.map((v) => v.toJson()).toList();
    }
    data['employeeName'] = this.employeeName;
    data['goalTimePeriodLabel'] = this.goalTimePeriodLabel;
    data['assignedEmployeeProfile'] = this.assignedEmployeeProfile;
    data['goalDescription'] = this.goalDescription;
    data['goalProgress'] = this.goalProgress;
    if (this.taskCount != null) {
      data['taskCount'] = this.taskCount!.toJson();
    }
    return data;
  }
}

class TaskCountData {
  int? totalTasks;
  int? activeTasks;
  int? overdueTasks;
  int? completedTasks;
  int? unassignedTasks;

  TaskCountData({
    this.totalTasks,
    this.activeTasks,
    this.overdueTasks,
    this.completedTasks,
    this.unassignedTasks,
  });

  TaskCountData.fromJson(Map<String, dynamic> json) {
    totalTasks = json['totalTasks'];
    activeTasks = json['activeTasks'];
    overdueTasks = json['overdueTasks'];
    completedTasks = json['completedTasks'];
    unassignedTasks = json['unassignedTasks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['totalTasks'] = totalTasks;
    data['activeTasks'] = activeTasks;
    data['overdueTasks'] = overdueTasks;
    data['completedTasks'] = completedTasks;
    data['unassignedTasks'] = unassignedTasks;
    return data;
  }
}

class CommentListApi {
  String? message;
  List<CommentData>? data;

  CommentListApi({this.message, this.data});

  CommentListApi.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <CommentData>[];
      json['data'].forEach((v) {
        data!.add(new CommentData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CommentData {
  int? commentId;
  // Null? commentParentId;
  int? commentGoalId;
  String? comment;
  int? isActive;
  int? createdBy;
  String? createdOn;
  // Null? modifiedBy;
  // Null? modifiedOn;
  // Null? deletedAt;
  String? employeeName;
  String? employeeProfile;
  List<CommentData>? children;

  CommentData({
    this.commentId,
    // this.commentParentId,
    this.commentGoalId,
    this.comment,
    this.isActive,
    this.createdBy,
    this.createdOn,
    // this.modifiedBy,
    // this.modifiedOn,
    // this.deletedAt,
    this.employeeName,
    this.employeeProfile,
    this.children,
  });

  CommentData.fromJson(Map<String, dynamic> json) {
    commentId = json['commentId'];
    // commentParentId = json['commentParentId'];
    commentGoalId = json['commentGoalId'];
    comment = json['comment'];
    isActive = json['isActive'];
    createdBy = json['createdBy'];
    createdOn = json['createdOn'];
    // modifiedBy = json['modifiedBy'];
    // modifiedOn = json['modifiedOn'];
    // deletedAt = json['deletedAt'];
    employeeName = json['employeeName'];
    employeeProfile = json['employeeProfile'];
    if (json['children'] != null) {
      children = <CommentData>[];
      json['children'].forEach((v) {
        children!.add(new CommentData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commentId'] = this.commentId;
    // data['commentParentId'] = this.commentParentId;
    data['commentGoalId'] = this.commentGoalId;
    data['comment'] = this.comment;
    data['isActive'] = this.isActive;
    data['createdBy'] = this.createdBy;
    data['createdOn'] = this.createdOn;
    // data['modifiedBy'] = this.modifiedBy;
    // data['modifiedOn'] = this.modifiedOn;
    // data['deletedAt'] = this.deletedAt;
    data['employeeName'] = this.employeeName;
    data['employeeProfile'] = this.employeeProfile;
    if (this.children != null) {
      data['children'] = this.children!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GoalDetailsApi {
  String? message;
  GoalDetails? data;

  GoalDetailsApi({this.message, this.data});

  GoalDetailsApi.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new GoalDetails.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class GoalDetails {
  int? goalId;
  String? goalDescription;
  int? goalProgress;
  int? goalParentId;
  String? goalTitile;
  String? goalDepartment;
  String? goalTimePeriodLabel;
  String? goalTimePeriod;
  String? goalDueDate;
  String? goalStatus;
  String? goalPriority;
  String? assignedEmployee;
  int? assignedEmployeeId;
  String? assignedEmployeeProfile;
  List<ActivityData>? goalActivity;
  TaskCount? taskCount;

  GoalDetails({
    this.goalId,
    this.goalDescription,
    this.goalProgress,
    this.goalParentId,
    this.goalTitile,
    this.goalDepartment,
    this.goalTimePeriodLabel,
    this.goalTimePeriod,
    this.goalDueDate,
    this.goalStatus,
    this.goalPriority,
    this.assignedEmployee,
    this.assignedEmployeeId,
    this.assignedEmployeeProfile,
    this.goalActivity,
    this.taskCount,
  });

  GoalDetails.fromJson(Map<String, dynamic> json) {
    List<ActivityData> activityList = [];
    List<String> keys = (json['goalActivity'] as Map<String, dynamic>).keys
        .toList();
    List<dynamic> values = (json['goalActivity'] as Map<String, dynamic>).values
        .toList();
    for (int i = 0; i < values.length; i++) {
      if (values[i] is List) {
        for (int j = 0; j < values[i].length; j++) {
          values[i][j]['date'] = keys[i];
        }
      }
    }
    for (var element in values) {
      if (element is List) {
        activityList.addAll(
          element.map((e) => ActivityData.fromJson(e)).toList(),
        );
      }
    }
    goalId = json['goalId'];
    goalDescription = json['goalDescription'];
    goalProgress = json['goalProgress'];
    goalParentId = json['goalParentId'];
    goalTitile = json['goalTitile'];
    goalDepartment = json['goalDepartment'];
    goalTimePeriodLabel = json['goalTimePeriodLabel'];
    goalTimePeriod = json['goalTimePeriod'];
    goalDueDate = json['goalDueDate'];
    goalStatus = json['goalStatus'];
    goalPriority = json['goalPriority'];
    assignedEmployee = json['assignedEmployee'];
    assignedEmployeeId = json['assignedEmployeeId'];
    assignedEmployeeProfile = json['assignedEmployeeProfile'];
    goalActivity = activityList;
    taskCount = json['taskCount'] != null
        ? new TaskCount.fromJson(json['taskCount'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['goalId'] = this.goalId;
    data['goalDescription'] = this.goalDescription;
    data['goalProgress'] = this.goalProgress;
    data['goalParentId'] = this.goalParentId;
    data['goalTitile'] = this.goalTitile;
    data['goalDepartment'] = this.goalDepartment;
    data['goalTimePeriodLabel'] = this.goalTimePeriodLabel;
    data['goalTimePeriod'] = this.goalTimePeriod;
    data['goalDueDate'] = this.goalDueDate;
    data['goalStatus'] = this.goalStatus;
    data['goalPriority'] = this.goalPriority;
    data['assignedEmployee'] = this.assignedEmployee;
    data['assignedEmployeeId'] = this.assignedEmployeeId;
    data['assignedEmployeeProfile'] = this.assignedEmployeeProfile;
    if (this.taskCount != null) {
      data['taskCount'] = this.taskCount!.toJson();
    }
    return data;
  }
}

class ActivityData {
  int? id;
  String? action;
  String? message;
  String? date;
  String? time;
  int? createdBy;
  String? employeeName;
  String? image;

  ActivityData({
    this.id,
    this.action,
    this.message,
    this.date,
    this.time,
    this.createdBy,
    this.employeeName,
    this.image,
  });

  ActivityData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    action = json['action'];
    message = json['message'];
    date = json['date'];
    time = json['time'];
    createdBy = json['createdBy'];
    employeeName = json['employeeName'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['action'] = this.action;
    data['message'] = this.message;
    data['date'] = this.date;
    data['time'] = this.time;
    data['createdBy'] = this.createdBy;
    data['employeeName'] = this.employeeName;
    data['image'] = this.image;
    return data;
  }
}

class TaskCount {
  int? totalTasks;
  int? activeTasks;
  int? overdueTasks;
  int? completedTasks;
  int? unassignedTasks;

  TaskCount({
    this.totalTasks,
    this.activeTasks,
    this.overdueTasks,
    this.completedTasks,
    this.unassignedTasks,
  });

  TaskCount.fromJson(Map<String, dynamic> json) {
    totalTasks = json['totalTasks'];
    activeTasks = json['activeTasks'];
    overdueTasks = json['overdueTasks'];
    completedTasks = json['completedTasks'];
    unassignedTasks = json['unassignedTasks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalTasks'] = this.totalTasks;
    data['activeTasks'] = this.activeTasks;
    data['overdueTasks'] = this.overdueTasks;
    data['completedTasks'] = this.completedTasks;
    data['unassignedTasks'] = this.unassignedTasks;
    return data;
  }
}

class SaveGoalModel {
  int? superiorEmployeeId;
  int? organisationId;
  String? goalTitile;
  String? goalDescription;
  int? goalDepartmentId;
  int? goalLocationId;
  int? goalCategoryId;
  int? goalCompanyId;
  String? goalTimePeriod;
  String? goalDueDate;
  String? goalStartDate;
  int? goalParentId;
  int? subGoalId;
  List<int>? assignedEmployees;

  SaveGoalModel({
    this.superiorEmployeeId,
    this.organisationId,
    this.goalTitile,
    this.goalDescription,
    this.goalDepartmentId,
    this.goalLocationId,
    this.goalCategoryId,
    this.goalCompanyId,
    this.goalTimePeriod,
    this.goalDueDate,
    this.goalStartDate,
    this.goalParentId,
    this.subGoalId,
    this.assignedEmployees,
  });

  SaveGoalModel.fromJson(Map<String, dynamic> json) {
    superiorEmployeeId = json['superiorEmployeeId'];
    organisationId = json['organisationId'];
    goalTitile = json['goalTitile'];
    goalDescription = json['goalDescription'];
    goalDepartmentId = json['goalDepartmentId'];
    goalLocationId = json['goalLocationId'];
    goalCategoryId = json['goalCategoryId'];
    goalCompanyId = json['goalCompanyId'];
    goalTimePeriod = json['goalTimePeriod'];
    goalDueDate = json['goalDueDate'];
    goalStartDate = json['goalStartDate'];
    goalParentId = json['goalParentId'];
    subGoalId = json['subGoalId'];
    assignedEmployees = json['assignedEmployees'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['superiorEmployeeId'] = this.superiorEmployeeId;
    data['organisationId'] = this.organisationId;
    data['goalTitile'] = this.goalTitile;
    data['goalDescription'] = this.goalDescription;
    data['goalDepartmentId'] = this.goalDepartmentId;
    data['goalLocationId'] = this.goalLocationId;
    data['goalCategoryId'] = this.goalCategoryId;
    data['goalCompanyId'] = this.goalCompanyId;
    data['goalTimePeriod'] = this.goalTimePeriod;
    data['goalDueDate'] = this.goalDueDate;
    data['goalStartDate'] = this.goalStartDate;
    data['goalParentId'] = this.goalParentId;
    data['subGoalId'] = this.subGoalId;
    data['assignedEmployees'] = this.assignedEmployees;
    return data;
  }
}

class SubGoalsForTaskApi {
  int? status;
  String? message;
  List<SubGoalData>? result;

  SubGoalsForTaskApi({this.status, this.message, this.result});

  SubGoalsForTaskApi.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['result'] != null) {
      result = <SubGoalData>[];
      json['result'].forEach((v) {
        result!.add(new SubGoalData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubGoalData {
  String? subGoalId;
  String? subGoalTitle;

  SubGoalData({this.subGoalId, this.subGoalTitle});

  SubGoalData.fromJson(Map<String, dynamic> json) {
    subGoalId = json['subGoalId'];
    subGoalTitle = json['subGoalTitile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subGoalId'] = this.subGoalId;
    data['subGoalTitile'] = this.subGoalTitle;
    return data;
  }
}
