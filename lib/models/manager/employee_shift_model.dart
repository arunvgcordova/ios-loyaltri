class EmployeeShiftModel {
  int? status;
  String? message;
  // List<Null>? errors;
  List<EmployeeShiftData>? result;

  EmployeeShiftModel({this.status, this.message, this.result});

  EmployeeShiftModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    // if (json['errors'] != null) {
    //   errors = <Null>[];
    //   json['errors'].forEach((v) {
    //     errors!.add(new Null.fromJson(v));
    //   });
    // }
    if (json['result'] != null) {
      result = <EmployeeShiftData>[];
      json['result'].forEach((v) {
        result!.add(new EmployeeShiftData.fromJson(v));
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

class EmployeeShiftData {
  int? shiftId;
  String? companyId;
  String? shift;
  String? description;
  String? shiftCode;
  String? shiftColor;
  String? startTime;
  String? endTime;
  String? flexibleTiming;
  String? shiftHours;
  String? shiftMinutes;
  String? shiftBreakDuration;
  String? allowBreaks;
  String? halfTime;
  String? workHours;
  // Null? coolOffTime;
  int? isActive;
  int? createdBy;
  String? createdOn;
  // Null? modifiedBy;
  String? modifiedOn;
  String? isWorkHourBased;
  // Null? isShiftTimeBased;
  String? isNightShift;
  // Null? is24Hrs;
  String? breakFrom;
  String? breakTo;
  String? isFixedBreak;
  String? shiftType;

  EmployeeShiftData(
      {this.shiftId,
        this.companyId,
        this.shift,
        this.description,
        this.shiftCode,
        this.shiftColor,
        this.startTime,
        this.endTime,
        this.flexibleTiming,
        this.shiftHours,
        this.shiftMinutes,
        this.shiftBreakDuration,
        this.allowBreaks,
        this.halfTime,
        this.workHours,
        // this.coolOffTime,
        this.isActive,
        this.createdBy,
        this.createdOn,
        // this.modifiedBy,
        this.modifiedOn,
        this.isWorkHourBased,
        // this.isShiftTimeBased,
        this.isNightShift,
        // this.is24Hrs,
        this.breakFrom,
        this.breakTo,
        this.isFixedBreak,
        this.shiftType});

  EmployeeShiftData.fromJson(Map<String, dynamic> json) {
    shiftId = json['shiftId'];
    companyId = json['companyId'];
    shift = json['shift'];
    description = json['description'];
    shiftCode = json['shiftCode'];
    shiftColor = json['shiftColor'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    flexibleTiming = json['flexibleTiming'];
    shiftHours = json['shiftHours'];
    shiftMinutes = json['shiftMinutes'];
    shiftBreakDuration = json['shiftBreakDuration'];
    allowBreaks = json['allowBreaks'];
    halfTime = json['halfTime'];
    workHours = json['workHours'];
    // coolOffTime = json['coolOffTime'];
    isActive = json['isActive'];
    createdBy = json['createdBy'];
    createdOn = json['createdOn'];
    // modifiedBy = json['modifiedBy'];
    modifiedOn = json['modifiedOn'];
    isWorkHourBased = json['isWorkHourBased'];
    // isShiftTimeBased = json['isShiftTimeBased'];
    isNightShift = json['isNightShift'];
    // is24Hrs = json['is24Hrs'];
    breakFrom = json['breakFrom'];
    breakTo = json['breakTo'];
    isFixedBreak = json['isFixedBreak'];
    shiftType = json['shiftType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shiftId'] = this.shiftId;
    data['companyId'] = this.companyId;
    data['shift'] = this.shift;
    data['description'] = this.description;
    data['shiftCode'] = this.shiftCode;
    data['shiftColor'] = this.shiftColor;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['flexibleTiming'] = this.flexibleTiming;
    data['shiftHours'] = this.shiftHours;
    data['shiftMinutes'] = this.shiftMinutes;
    data['shiftBreakDuration'] = this.shiftBreakDuration;
    data['allowBreaks'] = this.allowBreaks;
    data['halfTime'] = this.halfTime;
    data['workHours'] = this.workHours;
    // data['coolOffTime'] = this.coolOffTime;
    data['isActive'] = this.isActive;
    data['createdBy'] = this.createdBy;
    data['createdOn'] = this.createdOn;
    // data['modifiedBy'] = this.modifiedBy;
    data['modifiedOn'] = this.modifiedOn;
    data['isWorkHourBased'] = this.isWorkHourBased;
    // data['isShiftTimeBased'] = this.isShiftTimeBased;
    data['isNightShift'] = this.isNightShift;
    // data['is24Hrs'] = this.is24Hrs;
    data['breakFrom'] = this.breakFrom;
    data['breakTo'] = this.breakTo;
    data['isFixedBreak'] = this.isFixedBreak;
    data['shiftType'] = this.shiftType;
    return data;
  }
}