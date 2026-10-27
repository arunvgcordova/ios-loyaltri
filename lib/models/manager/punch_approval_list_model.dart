class PunchApprovalListModel {
  int? status;
  String? message;
  List<dynamic>? errors;
  PunchApprovalResult? result;

  PunchApprovalListModel({
    this.status,
    this.message,
    this.errors,
    this.result,
  });

  PunchApprovalListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    errors = json['errors'];
    result = json['result'] != null
        ? PunchApprovalResult.fromJson(json['result'])
        : null;
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

class PunchApprovalResult {
  List<PunchApprovalData>? result;
  int? count;

  PunchApprovalResult({
    this.result,
    this.count,
  });

  PunchApprovalResult.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = (json['result'] as List)
          .map((e) => PunchApprovalData.fromJson(e))
          .toList();
    }
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    return {
      'result': result?.map((e) => e.toJson()).toList(),
      'count': count,
    };
  }
}

class PunchApprovalData {
  String? date;
  List<EmployeesApproval>? employees;

  PunchApprovalData({
    this.date,
    this.employees,
  });

  PunchApprovalData.fromJson(Map<String, dynamic> json) {
    date = json['date'];

    if (json['employees'] != null) {
      employees = (json['employees'] as List)
          .map((e) => EmployeesApproval.fromJson(e))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'employees': employees?.map((e) => e.toJson()).toList(),
    };
  }
}

class EmployeesApproval {
  String? isPunchApproved;
  String? isHoliday;
  String? isOffDay;
  String? hasOverTime;

  String? punchType;
  String? punchInImage;
  String? punchOutImage;

  String? employeeId;
  String? code;
  String? date;
  String? shiftName;
  String? profilePicture;
  String? employeeName;
  String? designation;
  String? totalWorkHours;
  String? employeeDailyAttendanceId;
  String? firstCheckInTime;
  String? lastCheckOutTime;
  String? employeedailyattendanceid;

  String? reason;
  String? afterApproval;

  List<ApprovalData>? approvalData;

  String? punchRemarks;
  String? punchInRemarks;
  String? punchOutRemarks;

  bool? isSelected;

  List<dynamic>? status;

  EmployeesApproval({
    this.isPunchApproved,
    this.isHoliday,
    this.isOffDay,
    this.hasOverTime,
    this.punchType,
    this.punchInImage,
    this.punchOutImage,
    this.employeeId,
    this.code,
    this.date,
    this.shiftName,
    this.profilePicture,
    this.employeeName,
    this.designation,
    this.totalWorkHours,
    this.employeeDailyAttendanceId,
    this.firstCheckInTime,
    this.lastCheckOutTime,
    this.employeedailyattendanceid,
    this.reason,
    this.afterApproval,
    this.approvalData,
    this.punchRemarks,
    this.punchInRemarks,
    this.punchOutRemarks,
    this.isSelected,
    this.status,
  });

  EmployeesApproval.fromJson(Map<String, dynamic> json) {
    isPunchApproved = json['isPunchApproved'];
    isHoliday = json['isHoliday'];
    isOffDay = json['isOffDay'];
    hasOverTime = json['hasOverTime'];

    punchType = json['punchType'];
    punchInImage = json['punchInImage'];
    punchOutImage = json['punchOutImage'];

    employeeId = json['employeeId'];
    code = json['code'];
    date = json['date'];
    shiftName = json['shiftName'];
    profilePicture = json['profilePicture'];
    employeeName = json['employeeName'];
    designation = json['designation'];
    totalWorkHours = json['totalWorkHours'];
    employeeDailyAttendanceId = json['employeeDailyAttendanceId'];
    firstCheckInTime = json['firstCheckInTime'];
    lastCheckOutTime = json['lastCheckOutTime'];
    employeedailyattendanceid = json['employeedailyattendanceid'];

    reason = json['reason'];
    afterApproval = json['afterApproval'];

    if (json['approvalData'] != null) {
      approvalData = (json['approvalData'] as List)
          .map((e) => ApprovalData.fromJson(e))
          .toList();
    }

    punchRemarks = json['punchRemarks'];
    punchInRemarks = json['punchInRemarks'];
    punchOutRemarks = json['punchOutRemarks'];

    isSelected = json['isSelected'] ?? false;

    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    return {
      'isPunchApproved': isPunchApproved,
      'isHoliday': isHoliday,
      'isOffDay': isOffDay,
      'hasOverTime': hasOverTime,
      'punchType': punchType,
      'punchInImage': punchInImage,
      'punchOutImage': punchOutImage,
      'employeeId': employeeId,
      'code': code,
      'date': date,
      'shiftName': shiftName,
      'profilePicture': profilePicture,
      'employeeName': employeeName,
      'designation': designation,
      'totalWorkHours': totalWorkHours,
      'employeeDailyAttendanceId': employeeDailyAttendanceId,
      'firstCheckInTime': firstCheckInTime,
      'lastCheckOutTime': lastCheckOutTime,
      'employeedailyattendanceid': employeedailyattendanceid,
      'reason': reason,
      'afterApproval': afterApproval,
      'approvalData': approvalData?.map((e) => e.toJson()).toList(),
      'punchRemarks': punchRemarks,
      'punchInRemarks': punchInRemarks,
      'punchOutRemarks': punchOutRemarks,
      'isSelected': isSelected,
      'status': status,
    };
  }
}

class ApprovalData {
  String? name;
  String? designation;
  String? profilePicture;
  String? remarks;
  String? status;
  String? date;

  ApprovalData({
    this.name,
    this.designation,
    this.profilePicture,
    this.remarks,
    this.status,
    this.date,
  });

  ApprovalData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    designation = json['designation'];
    profilePicture = json['profilePicture'];
    remarks = json['remarks'];
    status = json['status'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'designation': designation,
      'profilePicture': profilePicture,
      'remarks': remarks,
      'status': status,
      'date': date,
    };
  }
}