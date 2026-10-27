import 'manager/leave_request_list_model.dart';

class LeaveListAPI {
  int? status;
  String? message;
  // List<Null>? errors;
  List<AppliedLeave>? result;

  LeaveListAPI({this.status, this.message, this.result});

  LeaveListAPI.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    // if (json['errors'] != null) {
    //   errors = <Null>[];
    //   json['errors'].forEach((v) {
    //     errors!.add(new Null.fromJson(v));
    //   });
    // }
    if (json['result'] != null) {
      result = <AppliedLeave>[];
      json['result'].forEach((v) {
        result!.add(new AppliedLeave.fromJson(v));
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

class AppliedLeave {
  String? employeeLeaveApplicationId;
  CreatedBy? createdBy;
  List<String>? leaveAttachments;
  String? attachmentName;
  String? leaveSession;
  String? employeeId;
  String? mainStatus;
  String? createdOn;
  String? modifiedOn;
  String? requestedDateTime;
  String? requestedDate;
  String? approvedBy;
  String? leaveReason;
  String? totalLeaveDays;
  String? leaveDate;
  String? totalLeaveTime;
  String? leaveDateFrom;
  String? leaveDateTo;
  String? leaveType;
  String? isHourBased;
  String? superiorEmployeeId;
  String? employeeName;
  String? profilePicture;
  int? isByAdmin;
  String? extension;
  String? superpiorEmployeeName;
  AdminData? adminData;
  List<List<StepItem>>? track;
  String? requestStatusName;
  String? requestStatusColour;

  AppliedLeave(
      {this.employeeLeaveApplicationId,
        this.createdBy,
        this.leaveAttachments,
        this.attachmentName,
        this.leaveSession,
        this.employeeId,
        this.mainStatus,
        this.createdOn,
        this.modifiedOn,
        this.requestedDateTime,
        this.requestedDate,
        this.approvedBy,
        this.leaveReason,
        this.totalLeaveDays,
        this.leaveDate,
        this.totalLeaveTime,
        this.leaveDateFrom,
        this.leaveDateTo,
        this.leaveType,
        this.isHourBased,
        this.superiorEmployeeId,
        this.employeeName,
        this.profilePicture,
        this.isByAdmin,
        this.extension,
        this.superpiorEmployeeName,
        this.adminData,
        this.track,
        this.requestStatusName,
        this.requestStatusColour});

  AppliedLeave.fromJson(Map<String, dynamic> json) {
    employeeLeaveApplicationId = json['employeeLeaveApplicationId'];
    createdBy = json['createdBy'] != null
        ? new CreatedBy.fromJson(json['createdBy'])
        : null;
    if (json['leaveAttachments'] != null) {
      if (json['leaveAttachments'] is List) {
        leaveAttachments = List<String>.from(json['leaveAttachments']);
      } else {
        leaveAttachments = [json['leaveAttachments'].toString()];
      }
    } else {
      leaveAttachments = [];
    }
    attachmentName = json['attachmentName'];
    leaveSession = json['leaveSession'];
    employeeId = json['employeeId'];
    mainStatus = json['mainStatus'];
    createdOn = json['createdOn'];
    modifiedOn = json['modifiedOn'];
    requestedDateTime = json['requestedDateTime'];
    requestedDate = json['requestedDate'];
    approvedBy = json['approvedBy'];
    leaveReason = json['leaveReason'];
    totalLeaveDays = json['totalLeaveDays'];
    leaveDate = json['leaveDate'];
    totalLeaveTime = json['totalLeaveTime']?.toString();
    leaveDateFrom = json['leaveDateFrom'];
    leaveDateTo = json['leaveDateTo'];
    leaveType = json['leaveType'];
    isHourBased = json['isHourBased'];
    superiorEmployeeId = json['superiorEmployeeId'];
    employeeName = json['employeeName'];
    profilePicture = json['profilePicture'];
    isByAdmin = json['isByAdmin'];
    extension = json['extension'];
    superpiorEmployeeName = json['superpiorEmployeeName'];
    adminData = json['adminData'] != null
        ? AdminData.fromJson(json['adminData'])
        : null;
    track = [];
    List<String> stepList = [];
    if (json['track'] != null && (json['track']?.isNotEmpty ?? false)) {
      stepList = (json['track'] as Map<String, dynamic>).keys.toList();
      for (String step in stepList) {
        var stepData = json['track'][step] as List;
        track?.add(stepData.map((e) => StepItem.fromJson(e)).toList());
      }
    }
    requestStatusName = json['requestStatusName'];
    requestStatusColour = json['requestStatusColour'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employeeLeaveApplicationId'] = this.employeeLeaveApplicationId;
    if (this.createdBy != null) {
      data['createdBy'] = this.createdBy!.toJson();
    }
    data['leaveAttachments'] = this.leaveAttachments;
    data['attachmentName'] = this.attachmentName;
    data['leaveSession'] = this.leaveSession;
    data['employeeId'] = this.employeeId;
    data['mainStatus'] = this.mainStatus;
    data['createdOn'] = this.createdOn;
    data['modifiedOn'] = this.modifiedOn;
    data['requestedDateTime'] = this.requestedDateTime;
    data['requestedDate'] = this.requestedDate;
    data['approvedBy'] = this.approvedBy;
    data['leaveReason'] = this.leaveReason;
    data['totalLeaveDays'] = this.totalLeaveDays;
    data['leaveDate'] = this.leaveDate;
    data['totalLeaveTime'] = this.totalLeaveTime;
    data['leaveDateFrom'] = this.leaveDateFrom;
    data['leaveDateTo'] = this.leaveDateTo;
    data['leaveType'] = this.leaveType;
    data['isHourBased'] = this.isHourBased;
    data['superiorEmployeeId'] = this.superiorEmployeeId;
    data['employeeName'] = this.employeeName;
    data['profilePicture'] = this.profilePicture;
    data['isByAdmin'] = this.isByAdmin;
    data['extension'] = this.extension;
    data['superpiorEmployeeName'] = this.superpiorEmployeeName;
    if (this.adminData != null) {
      data['adminData'] = this.adminData!.toJson();
    }
    Map<String, List<Map<String, dynamic>>> stepMap = {};
    if (track != null && (track?.isNotEmpty ?? false)) {
      for(int i = 0; i < (track?.length ?? 0); i++) {
        List<Map<String, dynamic>> step = track?[i].map((e) => e.toJson()).toList() ?? [];
        stepMap.addAll(
            {
              'step${i+1}': step,
            },
        );
      }
    }
    data['track'] = stepMap;
    data['requestStatusName'] = this.requestStatusName;
    data['requestStatusColour'] = this.requestStatusColour;
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

// class AdminData {
//   String? fullName;
//   String? profilePicture;
//   String? designation;
//   String? modifiedOn;
//   String? remarks;
//
//   AdminData(
//       {this.fullName,
//         this.profilePicture,
//         this.designation,
//         this.modifiedOn,
//         this.remarks});
//
//   AdminData.fromJson(Map<String, dynamic> json) {
//     fullName = json['fullName'];
//     profilePicture = json['profilePicture'];
//     designation = json['designation'];
//     modifiedOn = json['modifiedOn'];
//     remarks = json['remarks'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['fullName'] = this.fullName;
//     data['profilePicture'] = this.profilePicture;
//     data['designation'] = this.designation;
//     data['modifiedOn'] = this.modifiedOn;
//     data['remarks'] = this.remarks;
//     return data;
//   }
// }

// class Track {
//   Map<String, List<StepItem>>? steps;
//
//   Track({this.steps});
//
//   Track.fromJson(Map<String, dynamic> json) {
//     steps = {};
//     json.forEach((key, value) {
//       if (value is List) {
//         steps![key] = value.map((item) => StepItem.fromJson(item)).toList();
//       }
//     });
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     steps?.forEach((key, value) {
//       data[key] = value.map((v) => v.toJson()).toList();
//     });
//     return data;
//   }
// }

class StepItem {
  String? id;
  String? name;
  String? designation;
  String? profilePicture;
  String? status;
  String? remarks;
  String? modifiedOn;

  StepItem({
    this.id,
    this.name,
    this.designation,
    this.profilePicture,
    this.status,
    this.remarks,
    this.modifiedOn,
  });

  StepItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    designation = json['designation'];
    profilePicture = json['profilePicture'];
    status = json['status'];
    remarks = json['remarks'];
    modifiedOn = json['modifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['designation'] = designation;
    data['profilePicture'] = profilePicture;
    data['status'] = status;
    data['remarks'] = remarks;
    data['modifiedOn'] = modifiedOn;
    return data;
  }
}
