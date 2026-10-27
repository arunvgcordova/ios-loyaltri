class ShiftSchemeListResponse {
  int? status;
  String? message;
  List<dynamic>? errors;
  List<ShiftSchemeModel>? result;

  ShiftSchemeListResponse({
    this.status,
    this.message,
    this.errors,
    this.result,
  });

  ShiftSchemeListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['errors'] != null) {
      errors = json['errors'];
    }
    if (json['result'] != null) {
      result = <ShiftSchemeModel>[];
      json['result'].forEach((v) {
        result!.add(ShiftSchemeModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (errors != null) {
      data['errors'] = errors;
    }
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ShiftSchemeModel {
  int? shiftSchemeId;
  String? companyId;
  List<int>? shiftId;
  String? shiftScheme;
  String? description;
  String? startTime;
  String? endTime;
  String? allowBreaks;
  String? breakDuration;
  String? isOverTimeEnabled;
  String? shiftSchemeType;
  int? isActive;
  int? createdBy;
  String? createdOn;
  String? modifiedBy;
  String? modifiedOn;
  String? cwl;
  String? isMultipleShiftPerDay;
  List<ShiftData>? shiftData;

  ShiftSchemeModel({
    this.shiftSchemeId,
    this.companyId,
    this.shiftId,
    this.shiftScheme,
    this.description,
    this.startTime,
    this.endTime,
    this.allowBreaks,
    this.breakDuration,
    this.isOverTimeEnabled,
    this.shiftSchemeType,
    this.isActive,
    this.createdBy,
    this.createdOn,
    this.modifiedBy,
    this.modifiedOn,
    this.cwl,
    this.isMultipleShiftPerDay,
    this.shiftData,
  });

  ShiftSchemeModel.fromJson(Map<String, dynamic> json) {
    shiftSchemeId = json['shiftSchemeId'];
    companyId = json['companyId']?.toString();
    if (json['shiftId'] != null) {
      shiftId = List<int>.from(json['shiftId']);
    }
    shiftScheme = json['shiftScheme']?.toString();
    description = json['description']?.toString();
    startTime = json['startTime']?.toString();
    endTime = json['endTime']?.toString();
    allowBreaks = json['allowBreaks']?.toString();
    breakDuration = json['breakDuration']?.toString();
    isOverTimeEnabled = json['isOverTimeEnabled']?.toString();
    shiftSchemeType = json['shiftSchemeType']?.toString();
    isActive = json['isActive'];
    createdBy = json['createdBy'];
    createdOn = json['createdOn']?.toString();
    modifiedBy = json['modifiedBy']?.toString();
    modifiedOn = json['modifiedOn']?.toString();
    cwl = json['cwl']?.toString();
    isMultipleShiftPerDay = json['isMultipleShiftPerDay']?.toString();
    
    if (json['shiftData'] != null) {
      shiftData = <ShiftData>[];
      json['shiftData'].forEach((v) {
        shiftData!.add(ShiftData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['shiftSchemeId'] = shiftSchemeId;
    data['companyId'] = companyId;
    data['shiftId'] = shiftId;
    data['shiftScheme'] = shiftScheme;
    data['description'] = description;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['allowBreaks'] = allowBreaks;
    data['breakDuration'] = breakDuration;
    data['isOverTimeEnabled'] = isOverTimeEnabled;
    data['shiftSchemeType'] = shiftSchemeType;
    data['isActive'] = isActive;
    data['createdBy'] = createdBy;
    data['createdOn'] = createdOn;
    data['modifiedBy'] = modifiedBy;
    data['modifiedOn'] = modifiedOn;
    data['cwl'] = cwl;
    data['isMultipleShiftPerDay'] = isMultipleShiftPerDay;
    if (shiftData != null) {
      data['shiftData'] = shiftData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ShiftData {
  String? shiftId;
  String? shift;
  String? startTime;
  String? endTime;

  ShiftData({
    this.shiftId,
    this.shift,
    this.startTime,
    this.endTime,
  });

  ShiftData.fromJson(Map<String, dynamic> json) {
    shiftId = json['shiftId']?.toString();
    shift = json['shift']?.toString();
    startTime = json['startTime']?.toString();
    endTime = json['endTime']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['shiftId'] = shiftId;
    data['shift'] = shift;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    return data;
  }
}
