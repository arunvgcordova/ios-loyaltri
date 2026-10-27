class UpcomingShiftApiModel {
  int? status;
  String? message;
  List<dynamic>? errors;
  List<ShiftDetails>? result;

  UpcomingShiftApiModel({this.status, this.message, this.errors, this.result});

  UpcomingShiftApiModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    errors = json['errors'];
    if (json['result'] != null) {
      result = <ShiftDetails>[];
      json['result'].forEach((v) {
        result!.add(ShiftDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (errors != null) {
      data['errors'] = errors!.map((v) => v.toJson()).toList();
    }
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ShiftDetails {
  // String? shiftId;
  // String? companyId;
  String? shift;
  // String? description;
  // String? shiftCode;
  // String? shiftColor;
  String? startTime;
  String? endTime;
  // String? flexibleTiming;
  // String? shiftHours;
  // String? shiftMinutes;
  // String? shiftBreakDuration;
  // String? allowBreaks;
  // String? halfTime;
  // String? workHours;
  // String? coolOffTime;
  // String? isActive;
  // String? createdBy;
  // String? createdOn;
  // String? modifiedBy;
  // String? modifiedOn;
  // String? isWorkHourBased;
  // String? isShiftTimeBased;
  // String? isNightShift;
  // String? is24Hrs;
  // String? breakFrom;
  // String? breakTo;
  // String? isFixedBreak;
  String? date;
  String? shiftTime;

  ShiftDetails({
    // this.shiftId,
    // this.companyId,
    this.shift,
    // this.description,
    // this.shiftCode,
    // this.shiftColor,
    this.startTime,
    this.endTime,
    // this.flexibleTiming,
    // this.shiftHours,
    // this.shiftMinutes,
    // this.shiftBreakDuration,
    // this.allowBreaks,
    // this.halfTime,
    // this.workHours,
    // this.coolOffTime,
    // this.isActive,
    // this.createdBy,
    // this.createdOn,
    // this.modifiedBy,
    // this.modifiedOn,
    // this.isWorkHourBased,
    // this.isShiftTimeBased,
    // this.isNightShift,
    // this.is24Hrs,
    // this.breakFrom,
    // this.breakTo,
    // this.isFixedBreak,
    this.date,
    this.shiftTime,
  });

  ShiftDetails.fromJson(Map<String, dynamic> json) {
    // shiftId = json['shiftId'].toString();
    // companyId = json['companyId'];
    shift = json['shift'];
    // description = json['description'];
    // shiftCode = json['shiftCode'];
    // shiftColor = json['shiftColor'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    // flexibleTiming = json['flexibleTiming'];
    // shiftHours = json['shiftHours'];
    // shiftMinutes = json['shiftMinutes'];
    // shiftBreakDuration = json['shiftBreakDuration'];
    // allowBreaks = json['allowBreaks'];
    // halfTime = json['halfTime'];
    // workHours = json['workHours'];
    // coolOffTime = json['coolOffTime'];
    // isActive = json['isActive'].toString();
    // createdBy = json['createdBy'];
    // createdOn = json['createdOn'];
    // modifiedBy = json['modifiedBy'];
    // modifiedOn = json['modifiedOn'];
    // isWorkHourBased = json['isWorkHourBased'];
    // isShiftTimeBased = json['isShiftTimeBased'];
    // isNightShift = json['isNightShift'];
    // is24Hrs = json['is24Hrs'];
    // breakFrom = json['breakFrom'];
    // breakTo = json['breakTo'];
    // isFixedBreak = json['isFixedBreak'];
    date = json['date'];
    shiftTime = json['shiftTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // data['shiftId'] = shiftId;
    // data['companyId'] = companyId;
    data['shift'] = shift;
    // data['description'] = description;
    // data['shiftCode'] = shiftCode;
    // data['shiftColor'] = shiftColor;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    // data['flexibleTiming'] = flexibleTiming;
    // data['shiftHours'] = shiftHours;
    // data['shiftMinutes'] = shiftMinutes;
    // data['shiftBreakDuration'] = shiftBreakDuration;
    // data['allowBreaks'] = allowBreaks;
    // data['halfTime'] = halfTime;
    // data['workHours'] = workHours;
    // data['coolOffTime'] = coolOffTime;
    // data['isActive'] = isActive;
    // data['createdBy'] = createdBy;
    // data['createdOn'] = createdOn;
    // data['modifiedBy'] = modifiedBy;
    // data['modifiedOn'] = modifiedOn;
    // data['isWorkHourBased'] = isWorkHourBased;
    // data['isShiftTimeBased'] = isShiftTimeBased;
    // data['isNightShift'] = isNightShift;
    // data['is24Hrs'] = is24Hrs;
    // data['breakFrom'] = breakFrom;
    // data['breakTo'] = breakTo;
    // data['isFixedBreak'] = isFixedBreak;
    data['date'] = date;
    data['shiftTime'] = shiftTime;
    return data;
  }
}
