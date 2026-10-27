class EmployeeAttendanceDetailModel {
  int? status;
  String? message;
  // List<Null>? errors;
  AttendanceDetail? result;

  EmployeeAttendanceDetailModel(
      {this.status, this.message, this.result});

  EmployeeAttendanceDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    // if (json['errors'] != null) {
    //   errors = <Null>[];
    //   json['errors'].forEach((v) {
    //     errors!.add(new Null.fromJson(v));
    //   });
    // }
    result =
    json['result'] != null ? new AttendanceDetail.fromJson(json['result']) : null;
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

class AttendanceDetail {
  int? employeeDailyAttendanceId;
  int? employeeId;
  int? employeeCompanyId;
  String? date;
  int? shiftId;
  String? firstCheckInTime;
  String? lastCheckOutTime;
  String? totalWorkHours;
  // Null? dutyType;
  int? isRegularizationNeeded;
  int? excuseType;
  int? isActive;
  // Null? createdBy;
  String? createdOn;
  // Null? modifiedBy;
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
  String? employeeName;
  String? firstName;
  String? middleName;
  String? lastName;
  String? nickName;
  String? dateOfBirth;
  String? gender;
  String? religionId;
  String? bloodGroup;
  String? phone;
  String? email;
  String? profilePicture;
  String? adminLevel;
  String? fatherOrHusbandName;
  String? isNewJoiner;
  String? isEmailVerified;
  String? shiftName;
  bool? isFineToRegularize;
  List<Deductions>? deductions;
  OvertimeData? overtime;
  List<TimeData>? timeData;

  AttendanceDetail(
      {this.employeeDailyAttendanceId,
        this.employeeId,
        this.employeeCompanyId,
        this.date,
        this.shiftId,
        this.firstCheckInTime,
        this.lastCheckOutTime,
        this.totalWorkHours,
        // this.dutyType,
        this.isRegularizationNeeded,
        this.excuseType,
        this.isActive,
        // this.createdBy,
        this.createdOn,
        // this.modifiedBy,
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
        this.employeeName,
        this.firstName,
        this.middleName,
        this.lastName,
        this.nickName,
        this.dateOfBirth,
        this.gender,
        this.religionId,
        this.bloodGroup,
        this.phone,
        this.email,
        this.profilePicture,
        this.adminLevel,
        this.fatherOrHusbandName,
        this.isNewJoiner,
        this.isEmailVerified,
        this.shiftName,
        this.isFineToRegularize,
        this.deductions,
        this.overtime,
        this.timeData,
      });

  AttendanceDetail.fromJson(Map<String, dynamic> json) {
    employeeDailyAttendanceId = json['employeeDailyAttendanceId'];
    employeeId = json['employeeId'];
    employeeCompanyId = json['employeeCompanyId'];
    date = json['date'];
    shiftId = json['shiftId'];
    firstCheckInTime = json['firstCheckInTime'];
    lastCheckOutTime = json['lastCheckOutTime'];
    totalWorkHours = json['totalWorkHours'];
    // dutyType = json['dutyType'];
    isRegularizationNeeded = json['isRegularizationNeeded'];
    excuseType = json['excuseType'];
    isActive = json['isActive'];
    // createdBy = json['createdBy'];
    createdOn = json['createdOn'];
    // modifiedBy = json['modifiedBy'];
    modifiedOn = json['modifiedOn'];
    companyId = json['companyId'];
    isHoliday = json['isHoliday'];
    isOffDay = json['isOffDay'];
    isLeave = json['isLeave'];
    isExcused = json['isExcused'];
    status = json['status'];
    leaveTypeId = json['leaveTypeId']?.toString();
    description = json['description'];
    isFine = json['isFine']?.toString();
    isPunchApproved = json['isPunchApproved'];
    leaveSession = json['leaveSession'];
    isHalfDay = json['isHalfDay'];
    isPaidLeave = json['isPaidLeave'];
    hasOverTime = json['hasOverTime'];
    isShuffle = json['isShuffle'];
    leaveReason = json['leaveReason'];
    presentShiftCount = json['presentShiftCount'];
    isDeductionCompleted = json['isDeductionCompleted'];
    totalBreakHours = json['totalBreakHours'];
    employeeName = json['employeeName'];
    firstName = json['firstName'];
    middleName = json['middleName'];
    lastName = json['lastName'];
    nickName = json['nickName'];
    dateOfBirth = json['dateOfBirth'];
    gender = json['gender'];
    religionId = json['religionId'];
    bloodGroup = json['bloodGroup'];
    phone = json['phone'];
    email = json['email'];
    profilePicture = json['profilePicture'];
    adminLevel = json['adminLevel'];
    fatherOrHusbandName = json['fatherOrHusbandName'];
    isNewJoiner = json['isNewJoiner'];
    isEmailVerified = json['isEmailVerified'];
    shiftName = json['shiftName'];
    isFineToRegularize = json['isFineToRegularize'];
    if (json['deductions'] != null) {
      deductions = <Deductions>[];
      json['deductions'].forEach((v) {
        deductions!.add(new Deductions.fromJson(v));
      });
    }
    overtime = json['overtime'] != null
        ? new OvertimeData.fromJson(json['overtime'])
        : null;
    if (json['timeData'] != null) {
      timeData = <TimeData>[];
      json['timeData'].forEach((v) {
        timeData!.add(new TimeData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employeeDailyAttendanceId'] = this.employeeDailyAttendanceId;
    data['employeeId'] = this.employeeId;
    data['employeeCompanyId'] = this.employeeCompanyId;
    data['date'] = this.date;
    data['shiftId'] = this.shiftId;
    data['firstCheckInTime'] = this.firstCheckInTime;
    data['lastCheckOutTime'] = this.lastCheckOutTime;
    data['totalWorkHours'] = this.totalWorkHours;
    // data['dutyType'] = this.dutyType;
    data['isRegularizationNeeded'] = this.isRegularizationNeeded;
    data['excuseType'] = this.excuseType;
    data['isActive'] = this.isActive;
    // data['createdBy'] = this.createdBy;
    data['createdOn'] = this.createdOn;
    // data['modifiedBy'] = this.modifiedBy;
    data['modifiedOn'] = this.modifiedOn;
    data['companyId'] = this.companyId;
    data['isHoliday'] = this.isHoliday;
    data['isOffDay'] = this.isOffDay;
    data['isLeave'] = this.isLeave;
    data['isExcused'] = this.isExcused;
    data['status'] = this.status;
    data['leaveTypeId'] = this.leaveTypeId;
    data['description'] = this.description;
    data['isFine'] = this.isFine;
    data['isPunchApproved'] = this.isPunchApproved;
    data['leaveSession'] = this.leaveSession;
    data['isHalfDay'] = this.isHalfDay;
    data['isPaidLeave'] = this.isPaidLeave;
    data['hasOverTime'] = this.hasOverTime;
    data['isShuffle'] = this.isShuffle;
    data['leaveReason'] = this.leaveReason;
    data['presentShiftCount'] = this.presentShiftCount;
    data['isDeductionCompleted'] = this.isDeductionCompleted;
    data['totalBreakHours'] = this.totalBreakHours;
    data['employeeName'] = this.employeeName;
    data['firstName'] = this.firstName;
    data['middleName'] = this.middleName;
    data['lastName'] = this.lastName;
    data['nickName'] = this.nickName;
    data['dateOfBirth'] = this.dateOfBirth;
    data['gender'] = this.gender;
    data['religionId'] = this.religionId;
    data['bloodGroup'] = this.bloodGroup;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['profilePicture'] = this.profilePicture;
    data['adminLevel'] = this.adminLevel;
    data['fatherOrHusbandName'] = this.fatherOrHusbandName;
    data['isNewJoiner'] = this.isNewJoiner;
    data['isEmailVerified'] = this.isEmailVerified;
    data['shiftName'] = this.shiftName;
    data['isFineToRegularize'] = this.isFineToRegularize;
    if (this.deductions != null) {
      data['deductions'] = this.deductions!.map((v) => v.toJson()).toList();
    }
    if (this.overtime != null) {
      data['overtime'] = this.overtime!.toJson();
    }
    if (this.timeData != null) {
      data['timeData'] = this.timeData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Deductions {
  String? regularizationApplied;
  String? deductionDate;
  String? deductionAmount;
  String? deductionType;
  String? timeDifference;
  String? deductionDetails;
  String? deductionCalculationType;
  String? excuseReason;
  String? remarks;

  Deductions(
      {this.regularizationApplied,
        this.deductionDate,
        this.deductionAmount,
        this.deductionType,
        this.timeDifference,
        this.deductionDetails,
        this.deductionCalculationType,
        this.excuseReason,
        this.remarks});

  Deductions.fromJson(Map<String, dynamic> json) {
    regularizationApplied = json['regularizationApplied'];
    deductionDate = json['deductionDate'];
    deductionAmount = json['deductionAmount'];
    deductionType = json['deductionType'];
    timeDifference = json['timeDifference'];
    deductionDetails = json['deductionDetails'];
    deductionCalculationType = json['deductionCalculationType'];
    excuseReason = json['excuseReason'];
    remarks = json['remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['regularizationApplied'] = this.regularizationApplied;
    data['deductionDate'] = this.deductionDate;
    data['deductionAmount'] = this.deductionAmount;
    data['deductionType'] = this.deductionType;
    data['timeDifference'] = this.timeDifference;
    data['deductionDetails'] = this.deductionDetails;
    data['deductionCalculationType'] = this.deductionCalculationType;
    data['excuseReason'] = this.excuseReason;
    data['remarks'] = this.remarks;
    return data;
  }
}

class OvertimeData {
  String? overTimeDate;
  String? amount;
  String? timeExtra;
  // Null? overTimeApplied;
  String? status;
  String? overTimeRate;

  OvertimeData(
      {this.overTimeDate,
        this.amount,
        this.timeExtra,
        // this.overTimeApplied,
        this.status,
        this.overTimeRate});

  OvertimeData.fromJson(Map<String, dynamic> json) {
    overTimeDate = json['overTimeDate'];
    amount = json['amount'];
    timeExtra = json['timeExtra'];
    // overTimeApplied = json['overTimeApplied'];
    status = json['status'];
    overTimeRate = json['overTimeRate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['overTimeDate'] = this.overTimeDate;
    data['amount'] = this.amount;
    data['timeExtra'] = this.timeExtra;
    // data['overTimeApplied'] = this.overTimeApplied;
    data['status'] = this.status;
    data['overTimeRate'] = this.overTimeRate;
    return data;
  }
}

class TimeData {
  String? punchTime;
  String? startBreak;
  String? endBreak;

  TimeData({this.punchTime, this.startBreak, this.endBreak});

  TimeData.fromJson(Map<String, dynamic> json) {
    punchTime = json['punchTime'];
    startBreak = json['startBreak'];
    endBreak = json['endBreak'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['punchTime'] = this.punchTime;
    data['startBreak'] = this.startBreak;
    data['endBreak'] = this.endBreak;
    return data;
  }
}