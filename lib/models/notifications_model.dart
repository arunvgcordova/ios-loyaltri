class NotificationsApi {
  int? status;
  String? message;
  // List<Null>? errors;
  List<Notifications>? result;

  NotificationsApi({this.status, this.message, this.result});

  NotificationsApi.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    // if (json['errors'] != null) {
    //   errors = <Null>[];
    //   json['errors'].forEach((v) {
    //     errors!.add(new Null.fromJson(v));
    //   });
    // }
    if (json['result'] != null) {
      result = <Notifications>[];
      json['result'].forEach((v) {
        result!.add(new Notifications.fromJson(v));
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

class Notifications {
  String? employeeAttendanceDeductionId;
  String? employeeDailyAttendanceId;
  String? timeDifference;
  String? status;
  String? employeeId;
  String? excuseType;
  String? attendanceDate;
  String? excuseDate;
  String? designation;
  String? profilePicture;
  String? employeeName;
  String? details;
  String? type;
  String? leavetype;
  String? leaveTypeId;
  String? employeeLeaveApplicationId;
  String? createdOn;
  String? createdDate;
  String? createdTime;
  String? leaveDateFrom;
  String? leaveDateTo;
  String? totalLeaveDays;
  String? typeSuffix;
  String? isFinalHeirarchy;
  String? specialRequestId;
  String? fromDate;
  String? toDate;
  String? requestStatus;
  String? isPunchApproved;
  String? code;
  String? date;
  String? totalWorkHours;
  String? firstCheckInTime;
  String? lastCheckOutTime;

  Notifications(
      {this.employeeAttendanceDeductionId,
        this.employeeDailyAttendanceId,
        this.timeDifference,
        this.status,
        this.employeeId,
        this.excuseType,
        this.attendanceDate,
        this.excuseDate,
        this.designation,
        this.profilePicture,
        this.employeeName,
        this.details,
        this.type,
        this.leavetype,
        this.leaveTypeId,
        this.employeeLeaveApplicationId,
        this.createdOn,
        this.createdDate,
        this.createdTime,
        this.leaveDateFrom,
        this.leaveDateTo,
        this.totalLeaveDays,
        this.typeSuffix,
        this.isFinalHeirarchy,
        this.specialRequestId,
        this.fromDate,
        this.toDate,
        this.requestStatus,
        this.isPunchApproved,
        this.code,
        this.date,
        this.totalWorkHours,
        this.firstCheckInTime,
        this.lastCheckOutTime});

  Notifications.fromJson(Map<String, dynamic> json) {
    employeeAttendanceDeductionId = json['employeeAttendanceDeductionId'];
    employeeDailyAttendanceId = json['employeeDailyAttendanceId'];
    timeDifference = json['timeDifference'];
    status = json['status'];
    employeeId = json['employeeId'];
    excuseType = json['excuseType'];
    attendanceDate = json['attendanceDate'];
    excuseDate = json['excuseDate'];
    designation = json['designation'];
    profilePicture = json['profilePicture'];
    employeeName = json['employeeName'];
    details = json['details'];
    type = json['type'];
    leavetype = json['Leavetype'];
    leaveTypeId = json['leaveTypeId'];
    employeeLeaveApplicationId = json['employeeLeaveApplicationId'];
    createdOn = json['createdOn'];
    createdDate = json['createdDate'];
    createdTime = json['createdTime'];
    leaveDateFrom = json['leaveDateFrom'];
    leaveDateTo = json['leaveDateTo'];
    totalLeaveDays = json['totalLeaveDays'];
    typeSuffix = json['typeSuffix'];
    isFinalHeirarchy = json['isFinalHeirarchy']?.toString();
    specialRequestId = json['specialRequestId'];
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    requestStatus = json['requestStatus'];
    isPunchApproved = json['isPunchApproved'];
    code = json['code'];
    date = json['date'];
    totalWorkHours = json['totalWorkHours'];
    firstCheckInTime = json['firstCheckInTime'];
    lastCheckOutTime = json['lastCheckOutTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employeeAttendanceDeductionId'] = this.employeeAttendanceDeductionId;
    data['employeeDailyAttendanceId'] = this.employeeDailyAttendanceId;
    data['timeDifference'] = this.timeDifference;
    data['status'] = this.status;
    data['employeeId'] = this.employeeId;
    data['excuseType'] = this.excuseType;
    data['attendanceDate'] = this.attendanceDate;
    data['excuseDate'] = this.excuseDate;
    data['designation'] = this.designation;
    data['profilePicture'] = this.profilePicture;
    data['employeeName'] = this.employeeName;
    data['details'] = this.details;
    data['type'] = this.type;
    data['Leavetype'] = this.leavetype;
    data['leaveTypeId'] = this.leaveTypeId;
    data['employeeLeaveApplicationId'] = this.employeeLeaveApplicationId;
    data['createdOn'] = this.createdOn;
    data['createdDate'] = this.createdDate;
    data['createdTime'] = this.createdTime;
    data['leaveDateFrom'] = this.leaveDateFrom;
    data['leaveDateTo'] = this.leaveDateTo;
    data['totalLeaveDays'] = this.totalLeaveDays;
    data['typeSuffix'] = this.typeSuffix;
    data['isFinalHeirarchy'] = this.isFinalHeirarchy;
    data['specialRequestId'] = this.specialRequestId;
    data['fromDate'] = this.fromDate;
    data['toDate'] = this.toDate;
    data['requestStatus'] = this.requestStatus;
    data['isPunchApproved'] = this.isPunchApproved;
    data['code'] = this.code;
    data['date'] = this.date;
    data['totalWorkHours'] = this.totalWorkHours;
    data['firstCheckInTime'] = this.firstCheckInTime;
    data['lastCheckOutTime'] = this.lastCheckOutTime;
    return data;
  }
}