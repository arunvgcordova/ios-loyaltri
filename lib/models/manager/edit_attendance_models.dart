import 'employee_attendance_detail.dart';

class MarkPresentModel {
  String? status;
  String? employeeAttendanceId;
  String? createdBy;
  String? employeeAttendanceDate;
  String? employeeId;
  PresentShiftAssign? shiftAssign;

  MarkPresentModel(
      {this.status,
        this.employeeAttendanceId,
        this.createdBy,
        this.employeeAttendanceDate,
        this.employeeId,
        this.shiftAssign});

  MarkPresentModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    employeeAttendanceId = json['employeeAttendanceId'];
    createdBy = json['createdBy'];
    employeeAttendanceDate = json['employeeAttendanceDate'];
    employeeId = json['employeeId'];
    shiftAssign = json['shiftAssign'] != null
        ? new PresentShiftAssign.fromJson(json['shiftAssign'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['employeeAttendanceId'] = this.employeeAttendanceId;
    data['createdBy'] = this.createdBy;
    data['employeeAttendanceDate'] = this.employeeAttendanceDate;
    data['employeeId'] = this.employeeId;
    if (this.shiftAssign != null) {
      data['shiftAssign'] = this.shiftAssign!.toJson();
    }
    return data;
  }
}

class PresentShiftAssign {
  String? employeeAttendanceId;
  String? shiftId;
  List<TimeData>? time;

  PresentShiftAssign({this.employeeAttendanceId, this.shiftId, this.time});

  PresentShiftAssign.fromJson(Map<String, dynamic> json) {
    employeeAttendanceId = json['employeeAttendanceId'];
    shiftId = json['shiftId'];
    if (json['time'] != null) {
      time = <TimeData>[];
      json['time'].forEach((v) {
        time!.add(new TimeData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employeeAttendanceId'] = this.employeeAttendanceId;
    data['shiftId'] = this.shiftId;
    if (this.time != null) {
      data['time'] = this.time!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// class Time {
//   String? punchTime;
//   String? startBreak;
//   String? endBreak;
//
//   Time({this.punchTime, this.startBreak, this.endBreak});
//
//   Time.fromJson(Map<String, dynamic> json) {
//     punchTime = json['punchTime'];
//     startBreak = json['startBreak'];
//     endBreak = json['endBreak'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['punchTime'] = this.punchTime;
//     data['startBreak'] = this.startBreak;
//     data['endBreak'] = this.endBreak;
//     return data;
//   }
// }

class MarkHalfDayModel {
  String? status;
  String? createdBy;
  String? employeeAttendanceDate;
  String? employeeId;
  String? employeeAttendanceId;
  HalfDayShiftAssign? shiftAssign;
  LeaveParams? leaveParams;

  MarkHalfDayModel(
      {this.status,
        this.createdBy,
        this.employeeAttendanceDate,
        this.employeeId,
        this.employeeAttendanceId,
        this.shiftAssign,
        this.leaveParams});

  MarkHalfDayModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    createdBy = json['createdBy'];
    employeeAttendanceDate = json['employeeAttendanceDate'];
    employeeId = json['employeeId'];
    employeeAttendanceId = json['employeeAttendanceId'];
    shiftAssign = json['shiftAssign'] != null
        ? new HalfDayShiftAssign.fromJson(json['shiftAssign'])
        : null;
    leaveParams = json['leaveParams'] != null
        ? new LeaveParams.fromJson(json['leaveParams'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['createdBy'] = this.createdBy;
    data['employeeAttendanceDate'] = this.employeeAttendanceDate;
    data['employeeId'] = this.employeeId;
    data['employeeAttendanceId'] = this.employeeAttendanceId;
    if (this.shiftAssign != null) {
      data['shiftAssign'] = this.shiftAssign!.toJson();
    }
    if (this.leaveParams != null) {
      data['leaveParams'] = this.leaveParams!.toJson();
    }
    return data;
  }
}

class HalfDayShiftAssign {
  String? shiftId;
  List<TimeData>? time;

  HalfDayShiftAssign({this.shiftId, this.time});

  HalfDayShiftAssign.fromJson(Map<String, dynamic> json) {
    shiftId = json['shiftId'];
    if (json['time'] != null) {
      time = <TimeData>[];
      json['time'].forEach((v) {
        time!.add(new TimeData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shiftId'] = this.shiftId;
    if (this.time != null) {
      data['time'] = this.time!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// class Time {
//   String? punchTime;
//   Null? startBreak;
//   Null? endBreak;
//
//   Time({this.punchTime, this.startBreak, this.endBreak});
//
//   Time.fromJson(Map<String, dynamic> json) {
//     punchTime = json['punchTime'];
//     startBreak = json['startBreak'];
//     endBreak = json['endBreak'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['punchTime'] = this.punchTime;
//     data['startBreak'] = this.startBreak;
//     data['endBreak'] = this.endBreak;
//     return data;
//   }
// }

class LeaveParams {
  String? employeeId;
  String? createdBy;
  String? companyId;
  String? leaveDateFrom;
  String? leaveDateTo;
  String? totalLeaveDays;
  String? leaveTypeId;
  String? leaveReason;
  String? appliedCount;
  String? count;
  String? isActive;
  String? isLeave;
  String? halfDay;
  String? isRegularization;
  String? isExtraDuty;
  String? maximumLeaveLimit;
  String? leaveApplied;
  String? leaveSection;
  String? superiorEmployeeId;
  String? remarks;

  LeaveParams(
      {this.employeeId,
        this.createdBy,
        this.companyId,
        this.leaveDateFrom,
        this.leaveDateTo,
        this.totalLeaveDays,
        this.leaveTypeId,
        this.leaveReason,
        this.appliedCount,
        this.count,
        this.isActive,
        this.isLeave,
        this.halfDay,
        this.isRegularization,
        this.isExtraDuty,
        this.maximumLeaveLimit,
        this.leaveApplied,
        this.leaveSection,
        this.superiorEmployeeId,
        this.remarks});

  LeaveParams.fromJson(Map<String, dynamic> json) {
    employeeId = json['employeeId'];
    createdBy = json['createdBy'];
    companyId = json['companyId'];
    leaveDateFrom = json['leaveDateFrom'];
    leaveDateTo = json['leaveDateTo'];
    totalLeaveDays = json['totalLeaveDays'];
    leaveTypeId = json['leaveTypeId'];
    leaveReason = json['leaveReason'];
    appliedCount = json['appliedCount'];
    count = json['count'];
    isActive = json['isActive'];
    isLeave = json['isLeave'];
    halfDay = json['halfDay'];
    isRegularization = json['isRegularization'];
    isExtraDuty = json['isExtraDuty'];
    maximumLeaveLimit = json['maximumLeaveLimit'];
    leaveApplied = json['leaveApplied'];
    leaveSection = json['leaveSection'];
    superiorEmployeeId = json['superiorEmployeeId'];
    remarks = json['remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employeeId'] = this.employeeId;
    data['createdBy'] = this.createdBy;
    data['companyId'] = this.companyId;
    data['leaveDateFrom'] = this.leaveDateFrom;
    data['leaveDateTo'] = this.leaveDateTo;
    data['totalLeaveDays'] = this.totalLeaveDays;
    data['leaveTypeId'] = this.leaveTypeId;
    data['leaveReason'] = this.leaveReason;
    data['appliedCount'] = this.appliedCount;
    data['count'] = this.count;
    data['isActive'] = this.isActive;
    data['isLeave'] = this.isLeave;
    data['halfDay'] = this.halfDay;
    data['isRegularization'] = this.isRegularization;
    data['isExtraDuty'] = this.isExtraDuty;
    data['maximumLeaveLimit'] = this.maximumLeaveLimit;
    data['leaveApplied'] = this.leaveApplied;
    data['leaveSection'] = this.leaveSection;
    data['superiorEmployeeId'] = this.superiorEmployeeId;
    data['remarks'] = this.remarks;
    return data;
  }
}

class MarkFineModel {
  String? status;
  int? employeeAttendanceId;
  String? createdBy;
  String? employeeAttendanceDate;
  int? employeeId;
  String? companyId;
  List<FineData>? fine;

  MarkFineModel(
      {this.status,
        this.employeeAttendanceId,
        this.createdBy,
        this.employeeAttendanceDate,
        this.employeeId,
        this.companyId,
        this.fine});

  MarkFineModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    employeeAttendanceId = json['employeeAttendanceId'];
    createdBy = json['createdBy'];
    employeeAttendanceDate = json['employeeAttendanceDate'];
    employeeId = json['employeeId'];
    companyId = json['companyId'];
    if (json['fine'] != null) {
      fine = <FineData>[];
      json['fine'].forEach((v) {
        fine!.add(new FineData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['employeeAttendanceId'] = this.employeeAttendanceId;
    data['createdBy'] = this.createdBy;
    data['employeeAttendanceDate'] = this.employeeAttendanceDate;
    data['employeeId'] = this.employeeId;
    data['companyId'] = this.companyId;
    if (this.fine != null) {
      data['fine'] = this.fine!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FineData {
  String? deductionDetails;
  String? deductionType;
  String? deductionHours;
  String? deductionAmount;
  bool? isFineApplied;

  FineData(
      {this.deductionDetails,
        this.deductionType,
        this.deductionHours,
        this.isFineApplied,
        this.deductionAmount});

  FineData.fromJson(Map<String, dynamic> json) {
    deductionDetails = json['deductionDetails'];
    deductionType = json['deductionType'];
    deductionHours = json['deductionHours'];
    isFineApplied = json['isFineApplied'];
    deductionAmount = json['deductionAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deductionDetails'] = this.deductionDetails;
    data['deductionType'] = this.deductionType;
    data['deductionHours'] = this.deductionHours;
    data['isFineApplied'] = this.isFineApplied;
    data['deductionAmount'] = this.deductionAmount;
    return data;
  }
}