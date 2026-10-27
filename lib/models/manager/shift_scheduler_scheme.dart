class ShiftSchedulerSchemeResponse {
  int? status;
  String? message;
  List<dynamic>? errors;
  List<ShiftSchemeData>? result;

  ShiftSchedulerSchemeResponse({
    this.status,
    this.message,
    this.errors,
    this.result,
  });

  factory ShiftSchedulerSchemeResponse.fromJson(Map<String, dynamic> json) =>
      ShiftSchedulerSchemeResponse(
        status: json["status"],
        message: json["message"],
        errors: json["errors"] == null
            ? []
            : List<dynamic>.from(json["errors"]!.map((x) => x)),
        result: json["result"] == null
            ? []
            : List<ShiftSchemeData>.from(
                json["result"]!.map((x) => ShiftSchemeData.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "errors": errors == null ? [] : List<dynamic>.from(errors!.map((x) => x)),
    "result": result == null
        ? []
        : List<dynamic>.from(result!.map((x) => x.toJson())),
  };
}

class ShiftSchemeData {
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
  dynamic cwl;
  String? isMultipleShiftPerDay;
  List<ShiftData>? shiftData;

  ShiftSchemeData({
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

  factory ShiftSchemeData.fromJson(Map<String, dynamic> json) =>
      ShiftSchemeData(
        shiftSchemeId: json["shiftSchemeId"],
        companyId: json["companyId"]?.toString(),
        shiftId: json["shiftId"] == null
            ? []
            : List<int>.from(json["shiftId"]!.map((x) => x)),
        shiftScheme: json["shiftScheme"],
        description: json["description"],
        startTime: json["startTime"],
        endTime: json["endTime"],
        allowBreaks: json["allowBreaks"],
        breakDuration: json["breakDuration"],
        isOverTimeEnabled: json["isOverTimeEnabled"],
        shiftSchemeType: json["shiftSchemeType"],
        isActive: json["isActive"],
        createdBy: json["createdBy"],
        createdOn: json["createdOn"],
        modifiedBy: json["modifiedBy"],
        modifiedOn: json["modifiedOn"],
        cwl: json["cwl"],
        isMultipleShiftPerDay: json["isMultipleShiftPerDay"]?.toString(),
        shiftData: json["shiftData"] == null
            ? []
            : List<ShiftData>.from(
                json["shiftData"]!.map((x) => ShiftData.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "shiftSchemeId": shiftSchemeId,
    "companyId": companyId,
    "shiftId": shiftId == null
        ? []
        : List<dynamic>.from(shiftId!.map((x) => x)),
    "shiftScheme": shiftScheme,
    "description": description,
    "startTime": startTime,
    "endTime": endTime,
    "allowBreaks": allowBreaks,
    "breakDuration": breakDuration,
    "isOverTimeEnabled": isOverTimeEnabled,
    "shiftSchemeType": shiftSchemeType,
    "isActive": isActive,
    "createdBy": createdBy,
    "createdOn": createdOn,
    "modifiedBy": modifiedBy,
    "modifiedOn": modifiedOn,
    "cwl": cwl,
    "isMultipleShiftPerDay": isMultipleShiftPerDay,
    "shiftData": shiftData == null
        ? []
        : List<dynamic>.from(shiftData!.map((x) => x.toJson())),
  };
}

class ShiftData {
  String? shiftId;
  String? shift;
  String? startTime;
  String? endTime;
  bool isSelected = false;

  ShiftData({
    this.shiftId,
    this.shift,
    this.startTime,
    this.endTime,
    required this.isSelected,
  });

  factory ShiftData.fromJson(Map<String, dynamic> json) => ShiftData(
    shiftId: json["shiftId"]?.toString(),
    shift: json["shift"],
    startTime: json["startTime"],
    endTime: json["endTime"],
    isSelected: json['isSelected'] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "shiftId": shiftId,
    "shift": shift,
    "startTime": startTime,
    "endTime": endTime,
    "isSelected": isSelected,
  };
}
