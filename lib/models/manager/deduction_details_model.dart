import 'leave_request_list_model.dart';

class DeductionDetailsApi {
  int? status;
  String? message;
  // List<Null>? errors;
  DeductionData? result;

  DeductionDetailsApi({this.status, this.message, this.result});

  DeductionDetailsApi.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    // if (json['errors'] != null) {
    //   errors = <Null>[];
    //   json['errors'].forEach((v) {
    //     errors!.add(new Null.fromJson(v));
    //   });
    // }
    result =
    json['result'] != null ? new DeductionData.fromJson(json['result']) : null;
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

class DeductionData {
  String? shiftName;
  String? shiftId;
  String? excuseReason;
  String? code;
  int? employeeAttendanceDeductionId;
  String? employeeId;
  String? deductionMonth;
  String? deductionDate;
  String? deductionType;
  String? deductionDetails;
  int? isActive;
  String? createdBy;
  String? createdOn;
  String? modifiedBy;
  String? modifiedOn;
  String? financialYear;
  String? deductionAmount;
  String? punctualityBreachCount;
  String? timeDifference;
  String? isPayrollNeeded;
  String? payrollReference;
  String? employeeDailyAttendanceId;
  String? regularizationApplied;
  String? deductionCalculationType;
  String? deletedOn;
  String? profilePicture;
  String? employeeName;
  String? profilePicName;
  String? designation;
  String? overTimeDate;
  String? overTimeDetails;
  String? timeExtra;
  List<Approvers>? approvers;
  AdminData? adminData;

  DeductionData(
      {this.shiftName,
        this.shiftId,
        this.excuseReason,
        this.code,
        this.employeeAttendanceDeductionId,
        this.employeeId,
        this.deductionMonth,
        this.deductionDate,
        this.deductionType,
        this.deductionDetails,
        this.isActive,
        this.createdBy,
        this.createdOn,
        this.modifiedBy,
        this.modifiedOn,
        this.financialYear,
        this.deductionAmount,
        this.timeDifference,
        this.isPayrollNeeded,
        this.payrollReference,
        this.employeeDailyAttendanceId,
        this.punctualityBreachCount,
        this.regularizationApplied,
        this.deductionCalculationType,
        this.deletedOn,
        this.profilePicture,
        this.employeeName,
        this.profilePicName,
        this.designation,
        this.overTimeDate,
        this.overTimeDetails,
        this.timeExtra,
        this.approvers,
        this.adminData,
      });

  DeductionData.fromJson(Map<String, dynamic> json) {
    shiftName = json['shiftName'];
    shiftId = json['shiftId'].toString();
    excuseReason = json['excuseReason'];
    code = json['code'];
    employeeAttendanceDeductionId = json['employeeAttendanceDeductionId'];
    employeeId = json['employeeId'];
    deductionMonth = json['deductionMonth'];
    deductionDate = json['deductionDate'];
    deductionType = json['deductionType'];
    deductionDetails = json['deductionDetails'];
    isActive = int.parse(json['isActive'] ?? '0');
    createdBy = json['createdBy'].toString();
    createdOn = json['createdOn'];
    modifiedBy = json['modifiedBy'].toString();
    modifiedOn = json['modifiedOn'];
    financialYear = json['financialYear'];
    deductionAmount = json['deductionAmount'];
    timeDifference = json['timeDifference'];
    isPayrollNeeded = json['isPayrollNeeded'];
    payrollReference = json['payrollReference'];
    employeeDailyAttendanceId = json['employeeDailyAttendanceId'];
    regularizationApplied = json['regularizationApplied'];
    deductionCalculationType = json['deductionCalculationType'];
    punctualityBreachCount = json['punctualityBreachCount'];
    deletedOn = json['deletedOn'];
    profilePicture = json['profilePicture'];
    employeeName = json['employeeName'];
    profilePicName = json['profilePicName'];
    designation = json['designation'];
    overTimeDate = json['overTimeDate'];
    overTimeDetails = json['overTimeDetails'];
    timeExtra = json['timeExtra'];
    if (json['approvers'] != null) {
      approvers = <Approvers>[];
      json['approvers'].forEach((v) {
        approvers!.add(new Approvers.fromJson(v));
      });
    }
    adminData = json['adminData'] != null
        ? new AdminData.fromJson(json['adminData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shiftName'] = this.shiftName;
    data['shiftId'] = this.shiftId;
    data['excuseReason'] = this.excuseReason;
    data['code'] = this.code;
    data['employeeAttendanceDeductionId'] = this.employeeAttendanceDeductionId;
    data['employeeId'] = this.employeeId;
    data['deductionMonth'] = this.deductionMonth;
    data['deductionDate'] = this.deductionDate;
    data['deductionType'] = this.deductionType;
    data['deductionDetails'] = this.deductionDetails;
    data['isActive'] = this.isActive;
    data['createdBy'] = this.createdBy;
    data['createdOn'] = this.createdOn;
    data['modifiedBy'] = this.modifiedBy;
    data['modifiedOn'] = this.modifiedOn;
    data['financialYear'] = this.financialYear;
    data['deductionAmount'] = this.deductionAmount;
    data['timeDifference'] = this.timeDifference;
    data['isPayrollNeeded'] = this.isPayrollNeeded;
    data['payrollReference'] = this.payrollReference;
    data['employeeDailyAttendanceId'] = this.employeeDailyAttendanceId;
    data['regularizationApplied'] = this.regularizationApplied;
    data['deductionCalculationType'] = this.deductionCalculationType;
    data['deletedOn'] = this.deletedOn;
    data['profilePicture'] = this.profilePicture;
    data['employeeName'] = this.employeeName;
    data['punctualityBreachCount'] = this.punctualityBreachCount;
    data['profilePicName'] = this.profilePicName;
    data['designation'] = this.designation;
    data['overTimeDate'] = this.overTimeDate;
    data['overTimeDetails'] = this.overTimeDetails;
    data['timeExtra'] = this.timeExtra;
    if (this.approvers != null) {
      data['approvers'] = this.approvers!.map((v) => v.toJson()).toList();
    }
    if (this.adminData != null) {
      data['adminData'] = this.adminData!.toJson();
    }
    return data;
  }
}

class Approvers {
  String? designationId;
  String? designation;
  String? employeeId;
  String? profilePicture;
  String? approverName;
  String? code;
  String? remarks;
  String? status;
  String? date;
  String? profilePicName;

  Approvers(
      {this.designationId,
        this.designation,
        this.employeeId,
        this.profilePicture,
        this.approverName,
        this.code,
        this.remarks,
        this.status,
        this.date,
        this.profilePicName});

  Approvers.fromJson(Map<String, dynamic> json) {
    designationId = json['designationId'];
    designation = json['designation'];
    employeeId = json['employeeId'];
    profilePicture = json['profilePicture'];
    approverName = json['approverName'];
    code = json['code'];
    remarks = json['remarks'];
    status = json['status'];
    date = json['date'];
    profilePicName = json['profilePicName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['designationId'] = this.designationId;
    data['designation'] = this.designation;
    data['employeeId'] = this.employeeId;
    data['profilePicture'] = this.profilePicture;
    data['approverName'] = this.approverName;
    data['code'] = this.code;
    data['remarks'] = this.remarks;
    data['status'] = this.status;
    data['date'] = this.date;
    data['profilePicName'] = this.profilePicName;
    return data;
  }
}