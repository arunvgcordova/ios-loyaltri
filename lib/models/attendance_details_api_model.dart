import 'dart:ui';

class AttendanceApiModel {
  int? status;
  String? message;
  // List<dynamic>? errors;
  List<Attendance>? result;

  AttendanceApiModel({this.status, this.message, this.result});

  AttendanceApiModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    // errors = json['errors'] != null ? List<dynamic>.from(json['errors']) : [];
    if (json['result'] != null) {
      result = <Attendance>[];
      json['result'].forEach((v) {
        result!.add(Attendance.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    // if (errors != null) {
    //   data['errors'] = errors;
    // }
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Attendance {
  String? employeeDailyAttendanceId;
  String? employeeId;
  String? employeeCompanyId;
  String? date;
  String? shiftId;
  String? firstCheckInTime;
  String? lastCheckOutTime;
  String? totalWorkHours;
  String? dutyType;
  String? isRegularizationNeeded;
  String? excuseType;
  String? isActive;
  String? createdBy;
  String? createdOn;
  String? modifiedBy;
  String? modifiedOn;
  String? companyId;
  String? isHoliday;
  String? isOffDay;
  String? isLeave;
  String? isExcused;
  String? status;
  String? leaveTypeId;
  String? description;
  String? isFine;
  String? isPunchApproved;
  String? leaveSession;
  String? isHalfDay;
  String? isPaidLeave;
  String? hasOverTime;
  String? isShuffle;
  String? leaveReason;
  String? presentShiftCount;
  String? isDeductionCompleted;
  String? totalBreakHours;
  String? awolDeductionId;
  String? workHours;
  String? allowBreaks;
  String? isFixedBreak;
  String? shiftBreakDuration;
  String? breakFrom;
  String? breakTo;
  String? shiftName;
  String? leaveType;
  String? employeeName;
  LeaveData? leaveData;
  String? breakHours;
  String? extraHours;
  String? hoursWorkedMessage;
  String? isLateEntry;
  LateEntryData? lateEntryData;
  String? isExcessBreak;
  LateEntryData? excessBreakData;
  String? isEarlyExit;
  LateEntryData? earlyExitData;
  String? isShortTime;
  LateEntryData? shortTimeData;
  String? isMissPunch;
  LateEntryData? missPunchData;
  String? isOverTime;
  OverTimeData? overTimeData;
  String? totalFineTime;
  String? fineStatus;
  String? finedCount;
  String? pardonedCount;
  String? requestsCount;
  String? isFineToRegularize;
  String? totalHoursToRegularize;
  List<ShiftData>? shiftData;
  String? shiftSchemeType;
  bool? isNotSync;
  int? dbId1;
  int? dbId2;
  String? punchState;

  Attendance({
    this.employeeDailyAttendanceId,
    this.employeeId,
    this.employeeCompanyId,
    this.date,
    this.shiftId,
    this.firstCheckInTime,
    this.lastCheckOutTime,
    this.totalWorkHours,
    this.dutyType,
    this.isRegularizationNeeded,
    this.excuseType,
    this.isActive,
    this.createdBy,
    this.createdOn,
    this.modifiedBy,
    this.modifiedOn,
    this.companyId,
    this.isHoliday,
    this.isOffDay,
    this.isLeave,
    this.isExcused,
    this.status,
    this.leaveTypeId,
    this.description,
    this.isFine,
    this.isPunchApproved,
    this.leaveSession,
    this.isHalfDay,
    this.isPaidLeave,
    this.hasOverTime,
    this.isShuffle,
    this.leaveReason,
    this.presentShiftCount,
    this.isDeductionCompleted,
    this.totalBreakHours,
    this.awolDeductionId,
    this.workHours,
    this.allowBreaks,
    this.isFixedBreak,
    this.shiftBreakDuration,
    this.breakFrom,
    this.breakTo,
    this.shiftName,
    this.leaveType,
    this.employeeName,
    this.leaveData,
    this.breakHours,
    this.extraHours,
    this.hoursWorkedMessage,
    this.isLateEntry,
    this.lateEntryData,
    this.isExcessBreak,
    this.excessBreakData,
    this.isEarlyExit,
    this.earlyExitData,
    this.isShortTime,
    this.shortTimeData,
    this.isMissPunch,
    this.missPunchData,
    this.isOverTime,
    this.overTimeData,
    this.totalFineTime,
    this.fineStatus,
    this.finedCount,
    this.pardonedCount,
    this.requestsCount,
    this.isFineToRegularize,
    this.totalHoursToRegularize,
    this.shiftData,
    this.shiftSchemeType,
    this.isNotSync,
    this.dbId1,
    this.dbId2,
    this.punchState,
  });

  Attendance.fromJson(Map<String, dynamic> json) {
    employeeDailyAttendanceId = json['employeeDailyAttendanceId']?.toString();
    employeeId = json['employeeId']?.toString();
    employeeCompanyId = json['employeeCompanyId']?.toString();
    date = json['date']?.toString();
    shiftId = json['shiftId']?.toString();
    firstCheckInTime = json['firstCheckInTime']?.toString();
    lastCheckOutTime = json['lastCheckOutTime']?.toString();
    totalWorkHours = json['totalWorkHours']?.toString();
    dutyType = json['dutyType']?.toString();
    isRegularizationNeeded = json['isRegularizationNeeded']?.toString();
    excuseType = json['excuseType']?.toString();
    isActive = json['isActive']?.toString();
    createdBy = json['createdBy']?.toString();
    createdOn = json['createdOn']?.toString();
    modifiedBy = json['modifiedBy']?.toString();
    modifiedOn = json['modifiedOn']?.toString();
    companyId = json['companyId']?.toString();
    isHoliday = json['isHoliday']?.toString();
    isOffDay = json['isOffDay']?.toString();
    isLeave = json['isLeave']?.toString();
    isExcused = json['isExcused']?.toString();
    status = json['status']?.toString();
    leaveTypeId = json['leaveTypeId']?.toString();
    description = json['description']?.toString();
    isFine = json['isFine']?.toString();
    isPunchApproved = json['isPunchApproved']?.toString();
    leaveSession = json['leaveSession']?.toString();
    isHalfDay = json['isHalfDay']?.toString();
    isPaidLeave = json['isPaidLeave']?.toString();
    hasOverTime = json['hasOverTime']?.toString();
    isShuffle = json['isShuffle']?.toString();
    leaveReason = json['leaveReason']?.toString();
    presentShiftCount = json['presentShiftCount']?.toString();
    isDeductionCompleted = json['isDeductionCompleted']?.toString();
    totalBreakHours = json['totalBreakHours']?.toString();
    awolDeductionId = json['awolDeductionId']?.toString();
    workHours = json['workHours']?.toString();
    allowBreaks = json['allowBreaks']?.toString();
    isFixedBreak = json['isFixedBreak']?.toString();
    shiftBreakDuration = json['shiftBreakDuration']?.toString();
    breakFrom = json['breakFrom']?.toString();
    breakTo = json['breakTo']?.toString();
    shiftName = json['shiftName']?.toString();
    leaveType = json['leaveType']?.toString();
    employeeName = json['employeeName']?.toString();
    leaveData = json['leaveData'] != null ? LeaveData.fromJson(json['leaveData']) : null;
    breakHours = json['breakHours']?.toString();
    extraHours = json['extraHours']?.toString();
    hoursWorkedMessage = json['hoursWorkedMessage']?.toString();
    isLateEntry = json['isLateEntry']?.toString();
    lateEntryData = json['lateEntryData'] != null ? LateEntryData.fromJson(json['lateEntryData']) : null;
    isExcessBreak = json['isExcessBreak']?.toString();
    excessBreakData = json['excessBreakData'] != null ? LateEntryData.fromJson(json['excessBreakData']) : null;
    isEarlyExit = json['isEarlyExit']?.toString();
    earlyExitData = json['earlyExitData'] != null ? LateEntryData.fromJson(json['earlyExitData']) : null;
    isShortTime = json['isShortTime']?.toString();
    shortTimeData = json['shortTimeData'] != null ? LateEntryData.fromJson(json['shortTimeData']) : null;
    isMissPunch = json['isMissPunch']?.toString();
    missPunchData = json['missPunchData'] != null ? LateEntryData.fromJson(json['missPunchData']) : null;
    isOverTime = json['isOverTime']?.toString();
    overTimeData = json['overTimeData'] != null ? OverTimeData.fromJson(json['overTimeData']) : null;
    totalFineTime = json['totalFineTime']?.toString();
    fineStatus = json['fineStatus']?.toString();
    finedCount = json['finedCount']?.toString();
    pardonedCount = json['pardonedCount']?.toString();
    requestsCount = json['requestsCount']?.toString();
    isFineToRegularize = json['isFineToRegularize']?.toString();
    totalHoursToRegularize = json['totalHoursToRegularize']?.toString();
    if (json['shiftData'] != null) {
      shiftData = <ShiftData>[];
      json['shiftData'].forEach((v) {
        shiftData!.add(ShiftData.fromJson(v));
      });
    }
    shiftSchemeType = json['shiftSchemeType']?.toString();
    isNotSync = json['isNotSync'];
    dbId1 = json['dbId1'];
    dbId2 = json['dbId2'];
    punchState = json['punchState'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['employeeDailyAttendanceId'] = employeeDailyAttendanceId;
    data['employeeId'] = employeeId;
    data['employeeCompanyId'] = employeeCompanyId;
    data['date'] = date;
    data['shiftId'] = shiftId;
    data['firstCheckInTime'] = firstCheckInTime;
    data['lastCheckOutTime'] = lastCheckOutTime;
    data['totalWorkHours'] = totalWorkHours;
    data['dutyType'] = dutyType;
    data['isRegularizationNeeded'] = isRegularizationNeeded;
    data['excuseType'] = excuseType;
    data['isActive'] = isActive;
    data['createdBy'] = createdBy;
    data['createdOn'] = createdOn;
    data['modifiedBy'] = modifiedBy;
    data['modifiedOn'] = modifiedOn;
    data['companyId'] = companyId;
    data['isHoliday'] = isHoliday;
    data['isOffDay'] = isOffDay;
    data['isLeave'] = isLeave;
    data['isExcused'] = isExcused;
    data['status'] = status;
    data['leaveTypeId'] = leaveTypeId;
    data['description'] = description;
    data['isFine'] = isFine;
    data['isPunchApproved'] = isPunchApproved;
    data['leaveSession'] = leaveSession;
    data['isHalfDay'] = isHalfDay;
    data['isPaidLeave'] = isPaidLeave;
    data['hasOverTime'] = hasOverTime;
    data['isShuffle'] = isShuffle;
    data['leaveReason'] = leaveReason;
    data['presentShiftCount'] = presentShiftCount;
    data['isDeductionCompleted'] = isDeductionCompleted;
    data['totalBreakHours'] = totalBreakHours;
    data['awolDeductionId'] = awolDeductionId;
    data['workHours'] = workHours;
    data['allowBreaks'] = allowBreaks;
    data['isFixedBreak'] = isFixedBreak;
    data['shiftBreakDuration'] = shiftBreakDuration;
    data['breakFrom'] = breakFrom;
    data['breakTo'] = breakTo;
    data['shiftName'] = shiftName;
    data['leaveType'] = leaveType;
    data['employeeName'] = employeeName;
    if (leaveData != null) {
      data['leaveData'] = leaveData!.toJson();
    }
    data['breakHours'] = breakHours;
    data['extraHours'] = extraHours;
    data['hoursWorkedMessage'] = hoursWorkedMessage;
    data['isLateEntry'] = isLateEntry;
    if (lateEntryData != null) {
      data['lateEntryData'] = lateEntryData!.toJson();
    }
    data['isExcessBreak'] = isExcessBreak;
    if (excessBreakData != null) {
      data['excessBreakData'] = excessBreakData!.toJson();
    }
    data['isEarlyExit'] = isEarlyExit;
    if (earlyExitData != null) {
      data['earlyExitData'] = earlyExitData!.toJson();
    }
    data['isShortTime'] = isShortTime;
    if (shortTimeData != null) {
      data['shortTimeData'] = shortTimeData!.toJson();
    }
    data['isMissPunch'] = isMissPunch;
    if (missPunchData != null) {
      data['missPunchData'] = missPunchData!.toJson();
    }
    data['isOverTime'] = isOverTime;
    if (overTimeData != null) {
      data['overTimeData'] = overTimeData!.toJson();
    }
    data['totalFineTime'] = totalFineTime;
    data['fineStatus'] = fineStatus;
    data['finedCount'] = finedCount;
    data['pardonedCount'] = pardonedCount;
    data['requestsCount'] = requestsCount;
    data['isFineToRegularize'] = isFineToRegularize;
    data['totalHoursToRegularize'] = totalHoursToRegularize;
    if (shiftData != null) {
      data['shiftData'] = shiftData!.map((v) => v.toJson()).toList();
    }
    data['shiftSchemeType'] = shiftSchemeType;
    data['isNotSync'] = isNotSync;
    data['dbId1'] = dbId1;
    data['dbId2'] = dbId2;
    data['punchState'] = punchState;
    return data;
  }
}

class LeaveData {
  String? leaveTypeId;
  String? leaveType;
  String? leaveStatus;

  LeaveData({this.leaveTypeId, this.leaveType, this.leaveStatus});

  LeaveData.fromJson(Map<String, dynamic> json) {
    leaveTypeId = json['leaveTypeId']?.toString();
    leaveType = json['leaveType']?.toString();
    leaveStatus = json['leave_status']?.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'leaveTypeId': leaveTypeId,
      'leaveType': leaveType,
      'leave_status': leaveStatus,
    };
  }
}

class LateEntryData {
  String? deductionDate;
  String? deductionDetails;
  String? deductionAmount;
  String? timeDifference;
  String? excuseType;
  String? remarks;
  String? excuseReason;
  String? status;
  late Color color;

  LateEntryData({
    this.deductionDate,
    this.deductionDetails,
    this.deductionAmount,
    this.timeDifference,
    this.excuseType,
    this.remarks,
    this.status,
    this.excuseReason,
  }) {
    color = getFineColor(status: status ?? '');
  }

  LateEntryData.fromJson(Map<String, dynamic> json) {
    deductionDate = json['deductionDate']?.toString();
    deductionDetails = json['deductionDetails']?.toString();
    deductionAmount = json['deductionAmount']?.toString();
    timeDifference = json['timeDifference']?.toString();
    excuseType = json['excuseType']?.toString();
    remarks = json['remarks']?.toString();
    status = json['status']?.toString();
    excuseReason = json['excuseReason']?.toString();
    color = getFineColor(status: json['status'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'deductionDate': deductionDate,
      'deductionDetails': deductionDetails,
      'deductionAmount': deductionAmount,
      'timeDifference': timeDifference,
      'excuseType': excuseType,
      'remarks': remarks,
      'status': status,
      'excuseReason': excuseReason,
    };
  }
}

class OverTimeData {
  String? overTimeDate;
  String? overTimeDetails;
  String? amount;
  String? timeExtra;
  String? overTimeApplied;
  String? status;
  late Color color;

  OverTimeData({
    this.overTimeDate,
    this.overTimeDetails,
    this.amount,
    this.timeExtra,
    this.overTimeApplied,
    this.status,
  }) {
    color = getFineColor(status: status ?? '');
  }

  OverTimeData.fromJson(Map<String, dynamic> json) {
    overTimeDate = json['overTimeDate']?.toString();
    overTimeDetails = json['overTimeDetails']?.toString();
    amount = json['amount']?.toString();
    timeExtra = json['timeExtra']?.toString();
    overTimeApplied = json['overTimeApplied']?.toString();
    status = json['status']?.toString();
    color = getFineColor(status: json['status'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'overTimeDate': overTimeDate,
      'overTimeDetails': overTimeDetails,
      'amount': amount,
      'timeExtra': timeExtra,
      'overTimeApplied': overTimeApplied,
      'status': status,
    };
  }
}

class ShiftData {
  String? employeeRosterAttendanceDatasId;
  String? employeeDailyAttendanceId;
  String? firstCheckInTime;
  String? lastCheckOutTime;
  String? date;
  String? totalWorkHours;
  String? isRegularizationNeeded;
  String? excuseType;
  String? isExcused;
  String? status;
  String? isLeave;
  String? isFine;
  String? isPunchApproved;
  String? hasOverTime;
  String? isShuffle;
  String? shiftId;
  String? startTime;
  String? endTime;
  String? shiftName;
  String? workHours;
  String? isHalfDay;
  String? hoursWorkedMessage;
  String? totalBreakHours;
  String? extraHours;
  String? isLateEntry;
  LateEntryData? lateEntryData;
  String? isExcessBreak;
  LateEntryData? excessBreakData;
  String? isEarlyExit;
  LateEntryData? earlyExitData;
  String? isShortTime;
  LateEntryData? shortTimeData;
  String? isMissPunch;
  LateEntryData? missPunchData;
  String? isOverTime;
  OverTimeData? overTimeData;
  String? totalFineTime;

  ShiftData({
    this.employeeRosterAttendanceDatasId,
    this.employeeDailyAttendanceId,
    this.firstCheckInTime,
    this.lastCheckOutTime,
    this.date,
    this.totalWorkHours,
    this.isRegularizationNeeded,
    this.excuseType,
    this.isExcused,
    this.status,
    this.isLeave,
    this.isFine,
    this.isPunchApproved,
    this.hasOverTime,
    this.isShuffle,
    this.shiftId,
    this.startTime,
    this.endTime,
    this.shiftName,
    this.workHours,
    this.isHalfDay,
    this.hoursWorkedMessage,
    this.totalBreakHours,
    this.extraHours,
    this.isLateEntry,
    this.lateEntryData,
    this.isExcessBreak,
    this.excessBreakData,
    this.isEarlyExit,
    this.earlyExitData,
    this.isShortTime,
    this.shortTimeData,
    this.isMissPunch,
    this.missPunchData,
    this.isOverTime,
    this.overTimeData,
    this.totalFineTime,
  });

  ShiftData.fromJson(Map<String, dynamic> json) {
    employeeRosterAttendanceDatasId = json['employeeRosterAttendanceDatasId']?.toString();
    employeeDailyAttendanceId = json['employeeDailyAttendanceId']?.toString();
    firstCheckInTime = json['firstCheckInTime']?.toString();
    lastCheckOutTime = json['lastCheckOutTime']?.toString();
    date = json['date']?.toString();
    totalWorkHours = json['totalWorkHours']?.toString();
    isRegularizationNeeded = json['isRegularizationNeeded']?.toString();
    excuseType = json['excuseType']?.toString();
    isExcused = json['isExcused']?.toString();
    status = json['status']?.toString();
    isLeave = json['isLeave']?.toString();
    isFine = json['isFine']?.toString();
    isPunchApproved = json['isPunchApproved']?.toString();
    hasOverTime = json['hasOverTime']?.toString();
    isShuffle = json['isShuffle']?.toString();
    shiftId = json['shiftId']?.toString();
    startTime = json['startTime']?.toString();
    endTime = json['endTime']?.toString();
    shiftName = json['shiftName']?.toString();
    workHours = json['workHours']?.toString();
    isHalfDay = json['isHalfDay']?.toString();
    hoursWorkedMessage = json['hoursWorkedMessage']?.toString();
    totalBreakHours = json['totalBreakHours']?.toString();
    extraHours = json['extraHours']?.toString();
    isLateEntry = json['isLateEntry']?.toString();
    lateEntryData = json['lateEntryData'] != null ? LateEntryData.fromJson(json['lateEntryData']) : null;
    isExcessBreak = json['isExcessBreak']?.toString();
    excessBreakData = json['excessBreakData'] != null ? LateEntryData.fromJson(json['excessBreakData']) : null;
    isEarlyExit = json['isEarlyExit']?.toString();
    earlyExitData = json['earlyExitData'] != null ? LateEntryData.fromJson(json['earlyExitData']) : null;
    isShortTime = json['isShortTime']?.toString();
    shortTimeData = json['shortTimeData'] != null ? LateEntryData.fromJson(json['shortTimeData']) : null;
    isMissPunch = json['isMissPunch']?.toString();
    missPunchData = json['missPunchData'] != null ? LateEntryData.fromJson(json['missPunchData']) : null;
    isOverTime = json['isOverTime']?.toString();
    overTimeData = json['overTimeData'] != null ? OverTimeData.fromJson(json['overTimeData']) : null;
    totalFineTime = json['totalFineTime']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['employeeRosterAttendanceDatasId'] = employeeRosterAttendanceDatasId;
    data['employeeDailyAttendanceId'] = employeeDailyAttendanceId;
    data['firstCheckInTime'] = firstCheckInTime;
    data['lastCheckOutTime'] = lastCheckOutTime;
    data['date'] = date;
    data['totalWorkHours'] = totalWorkHours;
    data['isRegularizationNeeded'] = isRegularizationNeeded;
    data['excuseType'] = excuseType;
    data['isExcused'] = isExcused;
    data['status'] = status;
    data['isLeave'] = isLeave;
    data['isFine'] = isFine;
    data['isPunchApproved'] = isPunchApproved;
    data['hasOverTime'] = hasOverTime;
    data['isShuffle'] = isShuffle;
    data['shiftId'] = shiftId;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['shiftName'] = shiftName;
    data['workHours'] = workHours;
    data['isHalfDay'] = isHalfDay;
    data['hoursWorkedMessage'] = hoursWorkedMessage;
    data['totalBreakHours'] = totalBreakHours;
    data['extraHours'] = extraHours;
    data['isLateEntry'] = isLateEntry;
    if (lateEntryData != null) {
      data['lateEntryData'] = lateEntryData!.toJson();
    }
    data['isExcessBreak'] = isExcessBreak;
    if (excessBreakData != null) {
      data['excessBreakData'] = excessBreakData!.toJson();
    }
    data['isEarlyExit'] = isEarlyExit;
    if (earlyExitData != null) {
      data['earlyExitData'] = earlyExitData!.toJson();
    }
    data['isShortTime'] = isShortTime;
    if (shortTimeData != null) {
      data['shortTimeData'] = shortTimeData!.toJson();
    }
    data['isMissPunch'] = isMissPunch;
    if (missPunchData != null) {
      data['missPunchData'] = missPunchData!.toJson();
    }
    data['isOverTime'] = isOverTime;
    if (overTimeData != null) {
      data['overTimeData'] = overTimeData!.toJson();
    }
    data['totalFineTime'] = totalFineTime;
    return data;
  }
}

class RegularizationResponse {
  int? status;
  String? message;
  List<dynamic>? errors;
  AttendanceDeductionResp? result;

  RegularizationResponse({this.status, this.message, this.errors, this.result});

  factory RegularizationResponse.fromJson(Map<String, dynamic> json) {
    return RegularizationResponse(
      status: json['status'],
      message: json['message'],
      errors: json['errors'] ?? [],
      result: json['result'] != null ? AttendanceDeductionResp.fromJson(json['result']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'errors': errors,
      'result': result?.toJson(),
    };
  }
}

class AttendanceDeductionResp {
  String? shiftName;
  String? startTime;
  String? endTime;
  int? employeeDailyAttendanceId;
  int? employeeId;
  int? employeeCompanyId;
  String? date;
  int? shiftId;
  String? firstCheckInTime;
  String? lastCheckOutTime;
  String? totalWorkHours;
  String? dutyType;
  int? isRegularizationNeeded;
  int? excuseType;
  int? isActive;
  int? createdBy;
  String? createdOn;
  int? modifiedBy;
  String? modifiedOn;
  int? companyId;
  String? isHoliday;
  int? isOffDay;
  int? isLeave;
  int? isExcused;
  String? status;
  String? leaveTypeId;
  String? description;
  String? isFine;
  String? isPunchApproved;
  String? leaveSession;
  String? isHalfDay;
  String? isPaidLeave;
  String? hasOverTime;
  String? isShuffle;
  String? leaveReason;
  String? presentShiftCount;
  String? isDeductionCompleted;
  String? totalBreakHours;
  String? awolDeductionId;
  String? employeeName;
  String? employeeEmailId;
  List<Deduction>? deductions;
  String? regularizeFor;
  String? message;
  String? schedule;

  AttendanceDeductionResp({
    this.shiftName,
    this.startTime,
    this.endTime,
    this.employeeDailyAttendanceId,
    this.employeeId,
    this.employeeCompanyId,
    this.date,
    this.shiftId,
    this.firstCheckInTime,
    this.lastCheckOutTime,
    this.totalWorkHours,
    this.dutyType,
    this.isRegularizationNeeded,
    this.excuseType,
    this.isActive,
    this.createdBy,
    this.createdOn,
    this.modifiedBy,
    this.modifiedOn,
    this.companyId,
    this.isHoliday,
    this.isOffDay,
    this.isLeave,
    this.isExcused,
    this.status,
    this.leaveTypeId,
    this.description,
    this.isFine,
    this.isPunchApproved,
    this.leaveSession,
    this.isHalfDay,
    this.isPaidLeave,
    this.hasOverTime,
    this.isShuffle,
    this.leaveReason,
    this.presentShiftCount,
    this.isDeductionCompleted,
    this.totalBreakHours,
    this.awolDeductionId,
    this.employeeName,
    this.employeeEmailId,
    this.deductions,
    this.regularizeFor,
    this.message,
    this.schedule,
  });

  factory AttendanceDeductionResp.fromJson(Map<String, dynamic> json) {
    return AttendanceDeductionResp(
      shiftName: json['shiftName'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      employeeDailyAttendanceId: json['employeeDailyAttendanceId'],
      employeeId: json['employeeId'],
      employeeCompanyId: json['employeeCompanyId'],
      date: json['date'],
      shiftId: json['shiftId'],
      firstCheckInTime: json['firstCheckInTime'],
      lastCheckOutTime: json['lastCheckOutTime'],
      totalWorkHours: json['totalWorkHours'],
      dutyType: json['dutyType'],
      isRegularizationNeeded: json['isRegularizationNeeded'],
      excuseType: json['excuseType'],
      isActive: json['isActive'],
      createdBy: json['createdBy'],
      createdOn: json['createdOn'],
      modifiedBy: json['modifiedBy'],
      modifiedOn: json['modifiedOn'],
      companyId: json['companyId'],
      isHoliday: json['isHoliday'],
      isOffDay: json['isOffDay'],
      isLeave: json['isLeave'],
      isExcused: json['isExcused'],
      status: json['status'],
      leaveTypeId: json['leaveTypeId'],
      description: json['description'],
      isFine: json['isFine'],
      isPunchApproved: json['isPunchApproved'],
      leaveSession: json['leaveSession'],
      isHalfDay: json['isHalfDay'],
      isPaidLeave: json['isPaidLeave'],
      hasOverTime: json['hasOverTime'],
      isShuffle: json['isShuffle'],
      leaveReason: json['leaveReason'],
      presentShiftCount: json['presentShiftCount'],
      isDeductionCompleted: json['isDeductionCompleted'],
      totalBreakHours: json['totalBreakHours'],
      awolDeductionId: json['awolDeductionId'],
      employeeName: json['employeeName'],
      employeeEmailId: json['employeeEmailId'],
      deductions: json['deductions'] != null
          ? (json['deductions'] as List).map((e) => Deduction.fromJson(e)).toList()
          : null,
      regularizeFor: json['regularizeFor'],
      message: json['message'],
      schedule: json['schedule'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shiftName': shiftName,
      'startTime': startTime,
      'endTime': endTime,
      'employeeDailyAttendanceId': employeeDailyAttendanceId,
      'employeeId': employeeId,
      'employeeCompanyId': employeeCompanyId,
      'date': date,
      'shiftId': shiftId,
      'firstCheckInTime': firstCheckInTime,
      'lastCheckOutTime': lastCheckOutTime,
      'totalWorkHours': totalWorkHours,
      'dutyType': dutyType,
      'isRegularizationNeeded': isRegularizationNeeded,
      'excuseType': excuseType,
      'isActive': isActive,
      'createdBy': createdBy,
      'createdOn': createdOn,
      'modifiedBy': modifiedBy,
      'modifiedOn': modifiedOn,
      'companyId': companyId,
      'isHoliday': isHoliday,
      'isOffDay': isOffDay,
      'isLeave': isLeave,
      'isExcused': isExcused,
      'status': status,
      'leaveTypeId': leaveTypeId,
      'description': description,
      'isFine': isFine,
      'isPunchApproved': isPunchApproved,
      'leaveSession': leaveSession,
      'isHalfDay': isHalfDay,
      'isPaidLeave': isPaidLeave,
      'hasOverTime': hasOverTime,
      'isShuffle': isShuffle,
      'leaveReason': leaveReason,
      'presentShiftCount': presentShiftCount,
      'isDeductionCompleted': isDeductionCompleted,
      'totalBreakHours': totalBreakHours,
      'awolDeductionId': awolDeductionId,
      'employeeName': employeeName,
      'employeeEmailId': employeeEmailId,
      'deductions': deductions?.map((e) => e.toJson()).toList(),
      'regularizeFor': regularizeFor,
      'message': message,
      'schedule': schedule,
    };
  }
}

class Deduction {
  String? employeeAttendanceDeductionId;
  String? excuseReason;
  String? deductionDetails;
  String? deductionDate;
  String? deductionAmount;
  String? deductionType;
  String? timeDifference;
  String? regularizationStatus;
  String? deductionCalculationType;
  int? showLeaveType;

  Deduction({
    this.employeeAttendanceDeductionId,
    this.excuseReason,
    this.deductionDetails,
    this.deductionDate,
    this.deductionAmount,
    this.deductionType,
    this.timeDifference,
    this.regularizationStatus,
    this.deductionCalculationType,
    this.showLeaveType,
  });

  factory Deduction.fromJson(Map<String, dynamic> json) {
    return Deduction(
      employeeAttendanceDeductionId: json['employeeAttendanceDeductionId'],
      excuseReason: json['excuseReason'],
      deductionDetails: json['deductionDetails'],
      deductionDate: json['deductionDate'],
      deductionAmount: json['deductionAmount'],
      deductionType: json['deductionType'],
      timeDifference: json['timeDifference'],
      regularizationStatus: json['regularizationStatus'],
      deductionCalculationType: json['deductionCalculationType'],
      showLeaveType: json['showLeaveType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employeeAttendanceDeductionId': employeeAttendanceDeductionId,
      'excuseReason': excuseReason,
      'deductionDetails': deductionDetails,
      'deductionDate': deductionDate,
      'deductionAmount': deductionAmount,
      'deductionType': deductionType,
      'timeDifference': timeDifference,
      'regularizationStatus': regularizationStatus,
      'deductionCalculationType': deductionCalculationType,
      'showLeaveType': showLeaveType,
    };
  }
}

Color getFineColor({required String status}) {
  status = status.toLowerCase();
  if(status == "fine") {
    return Color(0xFFD52A2A);
  } else if(status == "pardon") {
    return Color(0xFF349C5E);
  } else if(status == "pending") {
    return Color(0xFFF0B208);
  } else {
    return Color(0xFFFFE0E0);
  }
}