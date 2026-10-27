class EmployeeLeaveReqApi {
  int? status;
  String? message;
  // List<Null>? errors;
  List<EmployeeLeaveData>? result;

  EmployeeLeaveReqApi({this.status, this.message, this.result});

  EmployeeLeaveReqApi.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    // if (json['errors'] != null) {
    //   errors = <Null>[];
    //   json['errors'].forEach((v) {
    //     errors!.add(new Null.fromJson(v));
    //   });
    // }
    if (json['result'] != null) {
      result = <EmployeeLeaveData>[];
      json['result'].forEach((v) {
        result!.add(new EmployeeLeaveData.fromJson(v));
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

class EmployeeLeaveData {
  String? employeeLeaveApplicationId;
  String? requestedDate;
  String? requestedDateTime;
  String? modifiedOn;
  String? leaveAttachments;
  String? attachmentName;
  String? remarks;
  String? leaveSession;
  String? employeeId;
  CreatedBy? createdBy;
  String? myRemarks;
  String? employeeName;
  String? code;
  String? profilePicture;
  String? leaveTypeName;
  String? leaveDateFrom;
  String? isFinalHeirarchy;
  String? approvedBy;
  String? leaveType;
  String? leaveDateTo;
  String? status;
  String? mainStatus;
  String? designation;
  String? totalLeaveDays;
  String? leaveReason;
  int? isByAdmin;
  String? extension;
  List<ApprovalData>? approvalData;
  String? requestStatusName;
  String? requestStatusColour;
  String? mainStatusColor;
  String? isHourBased;
  String? totalLeaveTime;
  bool? isSelected;
  AdminData? adminData;

  EmployeeLeaveData(
      {this.employeeLeaveApplicationId,
        this.requestedDate,
        this.requestedDateTime,
        this.modifiedOn,
        this.leaveAttachments,
        this.attachmentName,
        this.remarks,
        this.leaveSession,
        this.employeeId,
        this.createdBy,
        this.myRemarks,
        this.employeeName,
        this.code,
        this.profilePicture,
        this.leaveTypeName,
        this.leaveDateFrom,
        this.isFinalHeirarchy,
        this.approvedBy,
        this.leaveType,
        this.leaveDateTo,
        this.status,
        this.mainStatus,
        this.designation,
        this.totalLeaveDays,
        this.leaveReason,
        this.isByAdmin,
        this.extension,
        this.approvalData,
        this.requestStatusName,
        this.requestStatusColour,
        this.mainStatusColor,
        this.isHourBased,
        this.totalLeaveTime,
        this.isSelected,
        this.adminData});

  EmployeeLeaveData.fromJson(Map<String, dynamic> json) {
    employeeLeaveApplicationId = json['employeeLeaveApplicationId'];
    requestedDate = json['requestedDate'];
    requestedDateTime = json['requestedDateTime'];
    modifiedOn = json['modifiedOn'];
    leaveAttachments = json['leaveAttachments'];
    attachmentName = json['attachmentName'];
    remarks = json['remarks'];
    leaveSession = json['leaveSession'];
    employeeId = json['employeeId'];
    createdBy = json['createdBy'] != null
        ? new CreatedBy.fromJson(json['createdBy'])
        : null;
    myRemarks = json['myRemarks'];
    employeeName = json['employeeName'];
    code = json['code'];
    profilePicture = json['profilePicture'];
    leaveTypeName = json['LeaveTypeName'];
    leaveDateFrom = json['leaveDateFrom'];
    isFinalHeirarchy = json['isFinalHeirarchy'];
    approvedBy = json['approvedBy'];
    leaveType = json['leaveType'];
    leaveDateTo = json['leaveDateTo'];
    status = json['status'];
    mainStatus = json['mainStatus'];
    designation = json['designation'];
    totalLeaveDays = json['totalLeaveDays'];
    leaveReason = json['leaveReason'];
    isByAdmin = json['isByAdmin'];
    extension = json['extension'].toString();
    if (json['approvalData'] != null) {
      approvalData = <ApprovalData>[];
      json['approvalData'].forEach((v) {
        approvalData!.add(new ApprovalData.fromJson(v));
      });
    }
    requestStatusName = json['requestStatusName'];
    requestStatusColour = json['requestStatusColour'];
    mainStatusColor = json['mainStatusColor'];
    isHourBased = json['isHourBased']?.toString();
    totalLeaveTime = json['totalLeaveTime']?.toString();
    isSelected = json['isSelected'] ?? false;
    adminData = json['adminData'] != null
        ? new AdminData.fromJson(json['adminData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employeeLeaveApplicationId'] = this.employeeLeaveApplicationId;
    data['requestedDate'] = this.requestedDate;
    data['requestedDateTime'] = this.requestedDateTime;
    data['modifiedOn'] = this.modifiedOn;
    data['leaveAttachments'] = this.leaveAttachments;
    data['attachmentName'] = this.attachmentName;
    data['remarks'] = this.remarks;
    data['leaveSession'] = this.leaveSession;
    data['employeeId'] = this.employeeId;
    if (this.createdBy != null) {
      data['createdBy'] = this.createdBy!.toJson();
    }
    data['myRemarks'] = this.myRemarks;
    data['employeeName'] = this.employeeName;
    data['code'] = this.code;
    data['profilePicture'] = this.profilePicture;
    data['LeaveTypeName'] = this.leaveTypeName;
    data['leaveDateFrom'] = this.leaveDateFrom;
    data['isFinalHeirarchy'] = this.isFinalHeirarchy;
    data['approvedBy'] = this.approvedBy;
    data['leaveType'] = this.leaveType;
    data['leaveDateTo'] = this.leaveDateTo;
    data['status'] = this.status;
    data['mainStatus'] = this.mainStatus;
    data['designation'] = this.designation;
    data['totalLeaveDays'] = this.totalLeaveDays;
    data['leaveReason'] = this.leaveReason;
    data['isByAdmin'] = this.isByAdmin;
    data['extension'] = this.extension;
    if (this.approvalData != null) {
      data['approvalData'] = this.approvalData!.map((v) => v.toJson()).toList();
    }
    data['requestStatusName'] = this.requestStatusName;
    data['requestStatusColour'] = this.requestStatusColour;
    data['mainStatusColor'] = this.mainStatusColor;
    data['isHourBased'] = this.isHourBased;
    data['totalLeaveTime'] = this.totalLeaveTime;
    data['isSelected'] = this.isSelected;
    if (this.adminData != null) {
      data['adminData'] = this.adminData!.toJson();
    }
    return data;
  }
}

class CreatedBy {
  String? employeeName;
  String? designation;
  String? profilePicture;
  String? email;

  CreatedBy(
      {this.employeeName, this.designation, this.profilePicture, this.email});

  CreatedBy.fromJson(Map<String, dynamic> json) {
    employeeName = json['employeeName'];
    designation = json['designation'];
    profilePicture = json['profilePicture'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employeeName'] = this.employeeName;
    data['designation'] = this.designation;
    data['profilePicture'] = this.profilePicture;
    data['email'] = this.email;
    return data;
  }
}

class ApprovalData {
  String? employeeId;
  String? firstName;
  String? lastName;
  String? profilePicture;
  String? status;
  String? modifiedOn;
  String? remarks;
  String? designation;
  String? step;

  ApprovalData(
      {this.employeeId,
        this.firstName,
        this.lastName,
        this.profilePicture,
        this.status,
        this.modifiedOn,
        this.remarks,
        this.designation,
        this.step});

  ApprovalData.fromJson(Map<String, dynamic> json) {
    employeeId = json['employeeId'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    profilePicture = json['profilePicture'];
    status = json['status'];
    modifiedOn = json['modifiedOn'];
    remarks = json['remarks'];
    designation = json['designation'];
    step = json['step'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employeeId'] = this.employeeId;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['profilePicture'] = this.profilePicture;
    data['status'] = this.status;
    data['modifiedOn'] = this.modifiedOn;
    data['remarks'] = this.remarks;
    data['designation'] = this.designation;
    data['step'] = this.step;
    return data;
  }
}

class AdminData {
  String? fullName;
  String? profilePicture;
  String? designation;
  String? modifiedOn;
  String? remarks;
  String? status;

  AdminData(
      {this.fullName, this.profilePicture, this.designation, this.modifiedOn, this.remarks, this.status});

  AdminData.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    profilePicture = json['profilePicture'];
    designation = json['designation'];
    modifiedOn = json['modifiedOn'];
    remarks = json['remarks'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullName'] = this.fullName;
    data['profilePicture'] = this.profilePicture;
    data['designation'] = this.designation;
    data['modifiedOn'] = this.modifiedOn;
    data['remarks'] = this.remarks;
    data['status'] = this.status;
    return data;
  }
}