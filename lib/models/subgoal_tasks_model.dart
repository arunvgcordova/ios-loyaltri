class SubGoalTasksApi {
  String? message;
  List<SubGoalTasksData>? data;

  SubGoalTasksApi({this.message, this.data});

  SubGoalTasksApi.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <SubGoalTasksData>[];
      json['data'].forEach((v) {
        data!.add(new SubGoalTasksData.fromJson(v));
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

class SubGoalTasksData {
  int? workEntryId;
  String? workName;
  String? dueDate;
  List<FieldData>? fieldData;
  String? assignedEmployee;
  String? assignedEmployeeProfile;
  String? status;
  String? statusColor;
  String? dueLabel;

  SubGoalTasksData(
      {this.workEntryId,
        this.workName,
        this.dueDate,
        this.fieldData,
        this.assignedEmployee,
        this.assignedEmployeeProfile,
        this.status,
        this.statusColor,
        this.dueLabel});

  SubGoalTasksData.fromJson(Map<String, dynamic> json) {
    workEntryId = json['workEntryId'];
    workName = json['workName'];
    dueDate = json['dueDate'];
    if (json['fieldData'] != null) {
      fieldData = <FieldData>[];
      json['fieldData'].forEach((v) {
        fieldData!.add(new FieldData.fromJson(v));
      });
    }
    assignedEmployee = json['assignedEmployee'];
    assignedEmployeeProfile = json['assignedEmployeeProfile'];
    status = json['status'];
    statusColor = json['statusColor'];
    dueLabel = json['dueLabel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['workEntryId'] = this.workEntryId;
    data['workName'] = this.workName;
    data['dueDate'] = this.dueDate;
    if (this.fieldData != null) {
      data['fieldData'] = this.fieldData!.map((v) => v.toJson()).toList();
    }
    data['assignedEmployee'] = this.assignedEmployee;
    data['assignedEmployeeProfile'] = this.assignedEmployeeProfile;
    data['status'] = this.status;
    data['statusColor'] = this.statusColor;
    data['dueLabel'] = this.dueLabel;
    return data;
  }
}

class FieldData {
  int? fieldId;
  String? fieldName;
  String? fieldType;
  List<Options>? options;
  String? isMultiple;
  List<String>? value;

  FieldData({
    this.fieldId,
    this.fieldName,
    this.fieldType,
    this.options,
    this.isMultiple,
    this.value,
  });

  FieldData.fromJson(Map<String, dynamic> json) {
    fieldId = json['fieldId'];
    fieldName = json['fieldName'];
    fieldType = json['fieldType'];
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(new Options.fromJson(v));
      });
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