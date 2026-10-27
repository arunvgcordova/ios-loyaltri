enum LeaveClEventType { requestedLeave, holiday }

// leave data model

class LeaveDataApiModel {
  int? status;
  String? message;
  List<dynamic>? errors;
  List<LeaveDetails>? result;

  LeaveDataApiModel({this.status, this.message, this.errors, this.result});

  LeaveDataApiModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    errors = json['errors'];
    if (json['result'] != null) {
      result = <LeaveDetails>[];
      json['result'].forEach((v) {
        result!.add(LeaveDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['errors'] = errors;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LeaveDetails {
  // String? employeeLeaveApplicationId;
  // String? employeeId;
  // String? status;
  // String? leaveReason;
  // String? totalLeaveDays;
  String? leaveDateFrom;
  String? leaveDateTo;
  // String? leaveType;
  // String? superiorEmployeeId;
  // String? superpiorEmployeeName;

  LeaveDetails({
    // this.employeeLeaveApplicationId,
    // this.employeeId,
    // this.status,
    // this.leaveReason,
    // this.totalLeaveDays,
    this.leaveDateFrom,
    this.leaveDateTo,
    // this.leaveType,
    // this.superiorEmployeeId,
    // this.superpiorEmployeeName,
  });

  LeaveDetails.fromJson(Map<String, dynamic> json) {
    // employeeLeaveApplicationId = json['employeeLeaveApplicationId'];
    // employeeId = json['employeeId'];
    // status = json['status'];
    // leaveReason = json['leaveReason'];
    // totalLeaveDays = json['totalLeaveDays'];
    leaveDateFrom = json['leaveDateFrom'];
    leaveDateTo = json['leaveDateTo'];
    // leaveType = json['leaveType'];
    // superiorEmployeeId = json['superiorEmployeeId'];
    // superpiorEmployeeName = json['superpiorEmployeeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // data['employeeLeaveApplicationId'] = employeeLeaveApplicationId;
    // data['employeeId'] = employeeId;
    // data['status'] = status;
    // data['leaveReason'] = leaveReason;
    // data['totalLeaveDays'] = totalLeaveDays;
    data['leaveDateFrom'] = leaveDateFrom;
    data['leaveDateTo'] = leaveDateTo;
    // data['leaveType'] = leaveType;
    // data['superiorEmployeeId'] = superiorEmployeeId;
    // data['superpiorEmployeeName'] = superpiorEmployeeName;
    return data;
  }
}

// holiday data model

class HolidayDataApiModel {
  int? status;
  String? message;
  List<dynamic>? errors;
  List<HolidayData>? result;

  HolidayDataApiModel({this.status, this.message, this.errors, this.result});

  HolidayDataApiModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    errors = json['errors'];
    if (json['result'] != null) {
      result = <HolidayData>[];
      json['result'].forEach((v) {
        result!.add(HolidayData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['errors'] = errors;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HolidayData {
  // int? holidayId;
  // String? companyId;
  // String? holidayName;
  // String? holidayType;
  // String? description;
  String? fromDate;
  String? toDate;
  // String? holidayDate;
  // num? noOfdays;
  // String? notifyApplicable;
  // String? reprocessLeaveApplication;
  // String? assignedDetails;
  // int? isActive;
  // int? createdBy;
  // String? createdOn;
  // String? modifiedBy;
  // String? modifiedOn;
  // String? isHalfDay;
  // String? halfDaySession;

  HolidayData({
    // this.holidayId,
    // this.companyId,
    // this.holidayName,
    // this.holidayType,
    // this.description,
    this.fromDate,
    this.toDate,
    // this.holidayDate,
    // this.noOfdays,
    // this.notifyApplicable,
    // this.reprocessLeaveApplication,
    // this.assignedDetails,
    // this.isActive,
    // this.createdBy,
    // this.createdOn,
    // this.modifiedBy,
    // this.modifiedOn,
    // this.isHalfDay,
    // this.halfDaySession,
  });

  HolidayData.fromJson(Map<String, dynamic> json) {
    // holidayId = json['holidayId'];
    // companyId = json['companyId'];
    // holidayName = json['holidayName'];
    // holidayType = json['holidayType'];
    // description = json['description'];
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    // holidayDate = json['holidayDate'];
    // if(json['noOfdays'] != null) {
    //   noOfdays = num.parse(json['noOfdays']);
    // }
    // notifyApplicable = json['notifyApplicable'];
    // reprocessLeaveApplication = json['reprocessLeaveApplication'];
    // assignedDetails = json['assignedDetails'];
    // isActive = json['isActive'];
    // createdBy = json['createdBy'];
    // createdOn = json['createdOn'];
    // modifiedBy = json['modifiedBy'];
    // modifiedOn = json['modifiedOn'];
    // isHalfDay = json['isHalfDay'];
    // halfDaySession = json['halfDaySession'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // data['holidayId'] = holidayId;
    // data['companyId'] = companyId;
    // data['holidayName'] = holidayName;
    // data['holidayType'] = holidayType;
    // data['description'] = description;
    data['fromDate'] = fromDate;
    data['toDate'] = toDate;
    // data['holidayDate'] = holidayDate;
    // data['noOfdays'] = noOfdays;
    // data['notifyApplicable'] = notifyApplicable;
    // data['reprocessLeaveApplication'] = reprocessLeaveApplication;
    // data['assignedDetails'] = assignedDetails;
    // data['isActive'] = isActive;
    // data['createdBy'] = createdBy;
    // data['createdOn'] = createdOn;
    // data['modifiedBy'] = modifiedBy;
    // data['modifiedOn'] = modifiedOn;
    // data['isHalfDay'] = isHalfDay;
    // data['halfDaySession'] = halfDaySession;
    return data;
  }
}

class LeaveCalendarEvents {
  LeaveClEventType? clEventType;
  String? date;

  LeaveCalendarEvents({
    this.clEventType,
    this.date,
  });
}
