import 'dart:convert';

import 'package:flutter/material.dart';

class TaskDashCountModel {
  int? status;
  String? message;
  // List<Null>? errors;
  DashCounts? result;

  TaskDashCountModel({this.status, this.message, this.result});

  TaskDashCountModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    // if (json['errors'] != null) {
    //   errors = <Null>[];
    //   json['errors'].forEach((v) {
    //     errors!.add(new Null.fromJson(v));
    //   });
    // }
    result =
        json['result'] != null ? new DashCounts.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    // if (this.errors != null) {
    //   data['errors'] = this.errors!.map((v) => v.toJson()).toList();
    // }
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class DashCounts {
  Counts? counts;

  DashCounts({this.counts});

  DashCounts.fromJson(Map<String, dynamic> json) {
    counts =
        json['counts'] != null ? new Counts.fromJson(json['counts']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.counts != null) {
      data['counts'] = this.counts!.toJson();
    }
    return data;
  }
}

class Counts {
  int? dueTodayCount;
  int? overdueCount;
  int? overdueSevendayCount;
  int? assignedToMeCount;
  int? createdByMeCount;
  int? teamCount;
  int? assignedCount;
  int? unAssignedCount;

  Counts({
    this.dueTodayCount,
    this.overdueCount,
    this.overdueSevendayCount,
    this.assignedToMeCount,
    this.createdByMeCount,
    this.teamCount,
    this.assignedCount,
    this.unAssignedCount,
  });

  Counts.fromJson(Map<String, dynamic> json) {
    dueTodayCount = json['dueTodayCount'];
    overdueCount = json['overdueCount'];
    overdueSevendayCount = json['overdueSevendayCount'];
    assignedToMeCount = json['assignedToMeCount'];
    createdByMeCount = json['createdByMeCount'];
    teamCount = json['teamCount'];
    assignedCount = json['assignedCount'];
    unAssignedCount = json['unAssignedCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dueTodayCount'] = this.dueTodayCount;
    data['overdueCount'] = this.overdueCount;
    data['overdueSevendayCount'] = this.overdueSevendayCount;
    data['assignedToMeCount'] = this.assignedToMeCount;
    data['createdByMeCount'] = this.createdByMeCount;
    data['teamCount'] = this.teamCount;
    data['assignedCount'] = this.assignedCount;
    data['unAssignedCount'] = this.unAssignedCount;
    return data;
  }
}

class TaskListApiModel {
  int? status;
  String? message;
  // List<Null>? errors;
  TaskListData? result;

  TaskListApiModel({this.status, this.message, this.result});

  TaskListApiModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    // if (json['errors'] != null) {
    //   errors = <Null>[];
    //   json['errors'].forEach((v) {
    //     errors!.add(new Null.fromJson(v));
    //   });
    // }
    result =
        json['result'] != null && (json['result']?.isNotEmpty ?? false)
            ? new TaskListData.fromJson(json['result'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    // if (this.errors != null) {
    //   data['errors'] = this.errors!.map((v) => v.toJson()).toList();
    // }
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class TaskListData {
  TemplateData? templateData;
  List<TaskData>? data;
  int? totalCount;
  ListDashCounts? counts;

  TaskListData({this.templateData, this.data, this.totalCount, this.counts});

  TaskListData.fromJson(Map<String, dynamic> json) {
    templateData =
        json['templateData'] != null
            ? new TemplateData.fromJson(json['templateData'])
            : null;
    if (json['data'] != null) {
      data = <TaskData>[];
      json['data'].forEach((v) {
        data!.add(new TaskData.fromJson(v));
      });
    }
    totalCount = json['totalCount'];
    counts =
        json['counts'] != null
            ? new ListDashCounts.fromJson(json['counts'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.templateData != null) {
      data['templateData'] = this.templateData!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['totalCount'] = this.totalCount;
    if (this.counts != null) {
      data['counts'] = this.counts!.toJson();
    }
    return data;
  }
}

class TemplateData {
  int? templateId;
  String? templateName;
  int? createdBy;
  String? createdOn;
  String? modifiedOn;
  int? isActive;
  String? modifiedBy;
  String? companyId;

  TemplateData({
    this.templateId,
    this.templateName,
    this.createdBy,
    this.createdOn,
    this.modifiedOn,
    this.isActive,
    this.modifiedBy,
    this.companyId,
  });

  TemplateData.fromJson(Map<String, dynamic> json) {
    templateId = json['templateId'];
    templateName = json['templateName'];
    createdBy = json['createdBy'];
    createdOn = json['createdOn'];
    modifiedOn = json['modifiedOn'];
    isActive = json['isActive'];
    modifiedBy = json['modifiedBy'];
    companyId = json['companyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['templateId'] = this.templateId;
    data['templateName'] = this.templateName;
    data['createdBy'] = this.createdBy;
    data['createdOn'] = this.createdOn;
    data['modifiedOn'] = this.modifiedOn;
    data['isActive'] = this.isActive;
    data['modifiedBy'] = this.modifiedBy;
    data['companyId'] = this.companyId;
    return data;
  }
}

class TaskData {
  int? workEntryId;
  String? dueDate;
  String? workName;
  String? employeeName;
  String? employeeId;
  String? status;
  String? profilePicture;
  String? dueLabel;
  String? statusColor;
  List<FieldData>? fieldData;
  List<String>? attachments;

  TaskData({
    this.workEntryId,
    this.dueDate,
    this.workName,
    this.employeeName,
    this.employeeId,
    this.status,
    this.profilePicture,
    this.dueLabel,
    this.statusColor,
    this.attachments,
    this.fieldData,
  });

  TaskData.fromJson(Map<String, dynamic> json) {
    workEntryId = json['workEntryId'];
    dueDate = json['dueDate'];
    workName = json['workName'];
    employeeName = json['employeeName'];
    employeeId = json['employeeId'];
    status = json['status'];
    profilePicture = json['profilePicture'];
    dueLabel = json['dueLabel'];
    statusColor = json['statusColor'];
    if (json['fieldData'] != null) {
      fieldData = <FieldData>[];
      json['fieldData'].forEach((v) {
        fieldData!.add(new FieldData.fromJson(v));
      });
    }
    if (json['attachments'] != null) {
      attachments = json['attachments'].cast<String>();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['workEntryId'] = this.workEntryId;
    data['dueDate'] = this.dueDate;
    data['workName'] = this.workName;
    data['employeeName'] = this.employeeName;
    data['employeeId'] = this.employeeId;
    data['status'] = this.status;
    data['profilePicture'] = this.profilePicture;
    data['dueLabel'] = this.dueLabel;
    data['statusColor'] = this.statusColor;
    if (this.fieldData != null) {
      data['fieldData'] = this.fieldData!.map((v) => v.toJson()).toList();
    }
    data['attachments'] = this.attachments;
    return data;
  }
}

class FieldData {
  int? fieldId;
  String? fieldName;
  String? fieldType;
  List<Options>? options;
  String? isMultiple;
  TextEditingController? textEditingController;
  List<String>? value;

  FieldData({
    this.fieldId,
    this.fieldName,
    this.fieldType,
    this.options,
    this.isMultiple,
    this.textEditingController,
    this.value,
  });

  FieldData.fromJson(Map<String, dynamic> json) {
    fieldId = json['fieldId'];
    fieldName = json['fieldName'];
    fieldType = json['fieldType'];
    if (json['options'] != null && json['options'] is List) {
      options = [];
      for (var v in json['options']) {
        if (v is String) {
          options!.add(Options(key: v));
        } else if (v is Map<String, dynamic>) {
          options!.add(Options.fromJson(v));
        }
      }
    }
    isMultiple = json['isMultiple'];
    value = [];
    if (json['value'] != null) {
      if (json['value'] is List) {
        value = (json['value'] as List).map((v) => v.toString()).toList();
      } else if (json['value'] is String) {
        value = [json['value']];
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fieldId'] = this.fieldId;
    data['fieldName'] = this.fieldName;
    data['fieldType'] = this.fieldType;
    if (this.options != null) {
      data['options'] = this.options!.map((v) => v.toJson()).toList();
    }
    data['isMultiple'] = this.isMultiple;
    if (value != null) {
      if (value?.length == 1) {
        data['value'] = value?.first;
      } else {
        data['value'] = this.value;
      }
    }
    return data;
  }
}

class Options {
  String? key;
  String? value;

  Options({this.key, this.value});

  Options.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['value'] = this.value;
    return data;
  }
}

class ListDashCounts {
  int? dueTodayCount;
  int? overdueCount;
  int? assignedCount;
  int? unAssignedCount;
  int? completedCount;
  int? incompleteCount;
  int? overdueSevendayCount;
  int? completedSevendayCount;
  List<AssigneeItem>? assignee;

  ListDashCounts({
    this.dueTodayCount,
    this.overdueCount,
    this.assignedCount,
    this.unAssignedCount,
    this.completedCount,
    this.incompleteCount,
    this.overdueSevendayCount,
    this.completedSevendayCount,
    this.assignee,
  });

  ListDashCounts.fromJson(Map<String, dynamic> json) {
    dueTodayCount = json['dueTodayCount'];
    overdueCount = json['overdueCount'];
    assignedCount = json['assignedCount'];
    unAssignedCount = json['unAssignedCount'];
    completedCount = json['completedCount'];
    incompleteCount = json['incompleteCount'];
    overdueSevendayCount = json['overdueSevendayCount'];
    completedSevendayCount = json['completedSevendayCount'];
    if (json['assignee'] != null) {
      assignee = <AssigneeItem>[];
      json['assignee'].forEach((v) {
        assignee!.add(new AssigneeItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dueTodayCount'] = this.dueTodayCount;
    data['overdueCount'] = this.overdueCount;
    data['assignedCount'] = this.assignedCount;
    data['unAssignedCount'] = this.unAssignedCount;
    data['completedCount'] = this.completedCount;
    data['incompleteCount'] = this.incompleteCount;
    data['overdueSevendayCount'] = this.overdueSevendayCount;
    data['completedSevendayCount'] = this.completedSevendayCount;
    if (this.assignee != null) {
      data['assignee'] = this.assignee!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AssigneeItem {
  String? name;
  String? id;
  int? count;

  AssigneeItem({this.name, this.id, this.count});

  AssigneeItem.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    data['count'] = this.count;
    return data;
  }
}

class TemplateDataApi {
  int? status;
  String? message;
  // List<Null>? errors;
  List<TemplateData>? result;

  TemplateDataApi({this.status, this.message, this.result});

  TemplateDataApi.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    // if (json['errors'] != null) {
    //   errors = <Null>[];
    //   json['errors'].forEach((v) {
    //     errors!.add(new Null.fromJson(v));
    //   });
    // }
    if (json['result'] != null) {
      result = <TemplateData>[];
      json['result'].forEach((v) {
        result!.add(new TemplateData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    // if (this.errors != null) {
    //   data['errors'] = this.errors!.map((v) => v.toJson()).toList();
    // }
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TaskExtraFieldApiModel {
  int? status;
  String? message;
  // List<Null>? errors;
  List<FieldData>? result;

  TaskExtraFieldApiModel({this.status, this.message, this.result});

  TaskExtraFieldApiModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    // if (json['errors'] != null) {
    //   errors = <Null>[];
    //   json['errors'].forEach((v) {
    //     errors!.add(new Null.fromJson(v));
    //   });
    // }
    if (json['result'] != null && json['result'] is List) {
      result = <FieldData>[];
      json['result'].forEach((v) {
        result!.add(FieldData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    // if (this.errors != null) {
    //   data['errors'] = this.errors!.map((v) => v.toJson()).toList();
    // }
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CreateTaskModel {
  String? workName;
  String? description;
  String? dueDate;
  String? assignedToName;
  String? assignedToId;
  String? assignedToImage;
  List<String>? attachment;
  String? templateId;
  String? supervisorId;
  String? companyId;
  String? subGoalId;
  String? timePeriodValue;
  LocationData? locationData;
  List<FieldData>? fieldData;

  CreateTaskModel({
    this.workName,
    this.description,
    this.dueDate,
    this.assignedToId,
    this.assignedToImage,
    this.assignedToName,
    this.attachment,
    this.timePeriodValue,
    this.locationData,
    this.fieldData,
    this.subGoalId,
  });

  CreateTaskModel.fromJson(Map<String, dynamic> json) {
    workName = json['workName'];
    description = json['description'];
    dueDate = json['dueDate'];
    assignedToName = json['assignedToName'];
    assignedToId = json['assignedTo'];
    assignedToImage = json['assignedToImage'];
    subGoalId = json['subGoalId'];
    timePeriodValue = json['timePeriodValue'];
    attachment = json['attachment'] != null ? List<String>.from(json['attachment']) : null;
    locationData =
        json['location'] != null
            ? LocationData.fromJson(json['location'])
            : null;
    if (json['fields'] != null) {
      fieldData = <FieldData>[];
      json['fields'].forEach((v) {
        fieldData!.add(FieldData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['workName'] = workName;
    data['description'] = description;
    data['dueDate'] = dueDate;
    data['assignedToName'] = assignedToName;
    data['assignedTo'] = assignedToId;
    data['assignedToImage'] = assignedToImage;
    data['subGoalId'] = subGoalId;
    data['timePeriodValue'] = timePeriodValue;
    data['attachment'] = attachment ?? [];
    if (locationData != null) {
      data['location'] = locationData!.toJson();
    }
    if (fieldData != null) {
      data['fields'] = fieldData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LocationData {
  String? latitude;
  String? longitude;
  String? locationName;

  LocationData({this.longitude, this.latitude, this.locationName});

  LocationData.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    locationName = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['location'] = locationName;
    return data;
  }

  static LocationData? fromRawApiString(String raw) {
    try {
      String inner = jsonDecode(raw);
      if (inner.trim().isEmpty) return null;
      return LocationData.fromJson(jsonDecode(inner));
    } catch (_) {
      return null;
    }
  }
}

class TaskDetailApi {
  int? status;
  String? message;
  // List<Null>? errors;
  ActivityList? result;

  TaskDetailApi({this.status, this.message, this.result});

  TaskDetailApi.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    // if (json['errors'] != null) {
    //   errors = <Null>[];
    //   json['errors'].forEach((v) {
    //     errors!.add(new Null.fromJson(v));
    //   });
    // }
    result =
    json['result'] != null ? new ActivityList.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    // if (this.errors != null) {
    //   data['errors'] = this.errors!.map((v) => v.toJson()).toList();
    // }
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class ActivityList {
  List<ActivityLog>? activityLog;
  TaskDetailedData? data;

  ActivityList({this.activityLog, this.data});

  ActivityList.fromJson(Map<String, dynamic> json) {
    if (json['activityLog'] != null) {
      activityLog = <ActivityLog>[];
      json['activityLog'].forEach((v) {
        activityLog!.add(new ActivityLog.fromJson(v));
      });
    }
    data = json['data'] != null ? new TaskDetailedData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.activityLog != null) {
      data['activityLog'] = this.activityLog!.map((v) => v.toJson()).toList();
    }
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ActivityLog {
  String? daysAgo;
  String? massage;
  String? assignedEmployeeName;
  String? profilePicture;
  String? action;

  ActivityLog(
      {this.daysAgo,
        this.massage,
        this.assignedEmployeeName,
        this.profilePicture,
        this.action});

  ActivityLog.fromJson(Map<String, dynamic> json) {
    daysAgo = json['daysAgo']?.toString();
    massage = json['massage'];
    assignedEmployeeName = json['assignedEmployeeName'];
    profilePicture = json['profilePicture'];
    action = json['action'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['daysAgo'] = this.daysAgo;
    data['massage'] = this.massage;
    data['assignedEmployeeName'] = this.assignedEmployeeName;
    data['profilePicture'] = this.profilePicture;
    data['action'] = this.action;
    return data;
  }
}

class TaskDetailedData {
  int? workEntryId;
  String? workName;
  String? unitCount;
  String? description;
  int? isActive;
  String? date;
  String? createdOn;
  String? modifiedOn;
  String? location;
  int? createdBy;
  String? modifiedBy;
  String? employeeId;
  String? companyId;
  List<String>? attachments;
  String? status;
  String? dueDate;
  String? assignedTo;
  String? templateId;
  List<FieldData>? fieldData;
  String? templateName;
  String? assignedEmployeeName;
  String? profilePicture;
  String? dueLabel;
  String? subGoalId;

  TaskDetailedData(
      {this.workEntryId,
        this.workName,
        this.unitCount,
        this.description,
        this.isActive,
        this.date,
        this.createdOn,
        this.modifiedOn,
        this.location,
        this.createdBy,
        this.modifiedBy,
        this.employeeId,
        this.companyId,
        this.attachments,
        this.status,
        this.dueDate,
        this.assignedTo,
        this.templateId,
        this.fieldData,
        this.templateName,
        this.assignedEmployeeName,
        this.profilePicture,
        this.subGoalId,
        this.dueLabel});

  TaskDetailedData.fromJson(Map<String, dynamic> json) {
    workEntryId = json['workEntryId'];
    workName = json['workName'];
    unitCount = json['unitCount'];
    description = json['description'];
    isActive = json['isActive'];
    date = json['date'];
    createdOn = json['createdOn'];
    modifiedOn = json['modifiedOn'];
    location = json['location'];
    createdBy = json['createdBy'];
    modifiedBy = json['modifiedBy']?.toString();
    employeeId = json['employeeId'];
    companyId = json['companyId'];
    attachments = json['Attachments'] != null ? List<String>.from(json['Attachments']) : null;
    status = json['status'];
    dueDate = json['dueDate'];
    assignedTo = json['assignedTo'];
    templateId = json['templateId'];
    if (json['fieldData'] != null) {
      fieldData = <FieldData>[];
      json['fieldData'].forEach((v) {
        fieldData!.add(new FieldData.fromJson(v));
      });
    }
    templateName = json['templateName'];
    assignedEmployeeName = json['assignedEmployeeName'];
    profilePicture = json['profilePicture'];
    dueLabel = json['dueLabel'];
    subGoalId = json['subGoalId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['workEntryId'] = this.workEntryId;
    data['workName'] = this.workName;
    data['unitCount'] = this.unitCount;
    data['description'] = this.description;
    data['isActive'] = this.isActive;
    data['date'] = this.date;
    data['createdOn'] = this.createdOn;
    data['modifiedOn'] = this.modifiedOn;
    data['location'] = this.location;
    data['createdBy'] = this.createdBy;
    data['modifiedBy'] = this.modifiedBy;
    data['employeeId'] = this.employeeId;
    data['companyId'] = this.companyId;
    data['Attachments'] = attachments ?? [];
    data['status'] = this.status;
    data['dueDate'] = this.dueDate;
    data['assignedTo'] = this.assignedTo;
    data['templateId'] = this.templateId;
    if (this.fieldData != null) {
      data['fieldData'] = this.fieldData!.map((v) => v.toJson()).toList();
    }
    data['templateName'] = this.templateName;
    data['assignedEmployeeName'] = this.assignedEmployeeName;
    data['profilePicture'] = this.profilePicture;
    data['dueLabel'] = this.dueLabel;
    data['subGoalId'] = this.subGoalId;
    return data;
  }
}