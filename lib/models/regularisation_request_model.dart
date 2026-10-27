import 'dart:ui';

import 'attendance_details_api_model.dart';

class RegularisationReqModel {
  int? status;
  String? message;
  List<dynamic>? errors;
  List<RequestData>? result;

  RegularisationReqModel({this.status, this.message, this.errors, this.result});

  RegularisationReqModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    errors = json['errors'];
    if (json['result'] != null) {
      result = <RequestData>[];
      json['result'].forEach((v) {
        result!.add(RequestData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['errors'] = errors;
    if (errors != null) {
      data['errors'] = errors!.map((v) => v.toJson()).toList();
    }
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RequestData {
  // String? employeeRegularizationId;
  // String? employeeId;
  // String? employeeCompanyId;
  String? excuseReason;
  String? excuseDate;
  String? attendanceDate;
  String? status;
  // String? isActive;
  // String? createdBy;
  // String? createdOn;
  // String? modifiedBy;
  // String? modifiedOn;
  // String? employeeDailyAttendanceId;
  String? excuseType;
  // String? responseBy;
  // String? message;
  String? timeDifference;
  late Color color;
  // String? remarks;

  RequestData({
    // this.employeeRegularizationId,
    // this.employeeId,
    // this.employeeCompanyId,
    this.excuseReason,
    this.excuseDate,
    this.attendanceDate,
    this.status,
    // this.isActive,
    // this.createdBy,
    // this.createdOn,
    // this.modifiedBy,
    // this.modifiedOn,
    // this.employeeDailyAttendanceId,
    this.excuseType,
    // this.responseBy,
    // this.message,
    this.timeDifference,
    // this.remarks,
  }) {
    color = getFineColor(status: status ?? '');
  }

  RequestData.fromJson(Map<String, dynamic> json) {
    // employeeRegularizationId = json['employeeRegularizationId'];
    // employeeId = json['employeeId'];
    // employeeCompanyId = json['employeeCompanyId'];
    excuseReason = json['excuseReason'];
    excuseDate = json['excuseDate'];
    attendanceDate = json['attendanceDate'];
    status = json['status'];
    // isActive = json['isActive'];
    // createdBy = json['createdBy'];
    // createdOn = json['createdOn'];
    // modifiedBy = json['modifiedBy'];
    // modifiedOn = json['modifiedOn'];
    // employeeDailyAttendanceId = json['employeeDailyAttendanceId'];
    excuseType = json['excuseType'];
    // responseBy = json['responseBy'];
    // message = json['message'];
    timeDifference = json['timeDifference'];
    color = getFineColor(status: json['status'] ?? '');
    // remarks = json['remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // data['employeeRegularizationId'] = employeeRegularizationId;
    // data['employeeId'] = employeeId;
    // data['employeeCompanyId'] = employeeCompanyId;
    data['excuseReason'] = excuseReason;
    data['excuseDate'] = excuseDate;
    data['attendanceDate'] = attendanceDate;
    data['status'] = status;
    // data['isActive'] = isActive;
    // data['createdBy'] = createdBy;
    // data['createdOn'] = createdOn;
    // data['modifiedBy'] = modifiedBy;
    // data['modifiedOn'] = modifiedOn;
    // data['employeeDailyAttendanceId'] = employeeDailyAttendanceId;
    data['excuseType'] = excuseType;
    // data['responseBy'] = responseBy;
    // data['message'] = message;
    data['timeDifference'] = timeDifference;
    // data['remarks'] = remarks;
    return data;
  }
}
