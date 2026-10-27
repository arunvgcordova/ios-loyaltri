import '../leave_list_api_model.dart';
import 'leave_request_list_model.dart';

class WfhLrListModel {
  int? status;
  String? message;
  // List<Null>? errors;
  List<WfhLrData>? result;

  WfhLrListModel({this.status, this.message, this.result});

  WfhLrListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    // if (json['errors'] != null) {
    //   errors = <Null>[];
    //   json['errors'].forEach((v) {
    //     errors!.add(new Null.fromJson(v));
    //   });
    // }
    if (json['result'] != null) {
      result = <WfhLrData>[];
      json['result'].forEach((v) {
        result!.add(new WfhLrData.fromJson(v));
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

class WfhLrData {
  String? specialRequestId;
  String? employeeId;
  String? requestType;
  String? requestDescription;
  String? fromDate;
  String? toDate;
  String? requestStatus;
  String? isActive;
  String? createdOn;
  String? createdBy;
  String? modifiedOn;
  String? modifiedBy;
  String? requestLetterType;
  List<String>? approvedDocument;
  String? companyId;
  String? isByAdmin;
  String? documentName;
  String? documentUploadedBy;
  String? actionRemarks;
  String? employeeName;
  String? employeeDesignation;
  String? profilePicture;
  String? mainStatus;
  AdminData? adminData;
  List<ApprovalData>? approvalData;
  List<String>? approvedDocumentName;
  String? documentUploader;
  String? mainStatusColor;
  String? requestStatusName;
  bool? isSelected;
  String? requestStatusColour;
  SpecialRequestJson? specialRequestJson;

  WfhLrData({
    this.specialRequestId,
    this.employeeId,
    this.requestType,
    this.requestDescription,
    this.fromDate,
    this.toDate,
    this.requestStatus,
    this.isActive,
    this.createdOn,
    this.createdBy,
    this.modifiedOn,
    this.modifiedBy,
    this.requestLetterType,
    this.approvedDocument,
    this.companyId,
    this.isByAdmin,
    this.documentName,
    this.documentUploadedBy,
    this.actionRemarks,
    this.employeeName,
    this.employeeDesignation,
    this.profilePicture,
    this.mainStatus,
    this.adminData,
    this.approvalData,
    this.approvedDocumentName,
    this.documentUploader,
    this.mainStatusColor,
    this.requestStatusName,
    this.isSelected,
    this.requestStatusColour,
    this.specialRequestJson,
  });

  factory WfhLrData.fromJson(Map<String, dynamic> json) {
    return WfhLrData(
      specialRequestId: json['specialRequestId']?.toString(),
      employeeId: json['employeeId']?.toString(),
      requestType: json['requestType']?.toString(),
      requestDescription: json['requestDescription']?.toString(),
      fromDate: json['fromDate']?.toString(),
      toDate: json['toDate']?.toString(),
      requestStatus: json['requestStatus']?.toString(),
      isActive: json['isActive']?.toString(),
      createdOn: json['createdOn']?.toString(),
      createdBy: json['createdBy']?.toString(),
      modifiedOn: json['modifiedOn']?.toString(),
      modifiedBy: json['modifiedBy']?.toString(),
      requestLetterType: json['requestLetterType']?.toString(),

      approvedDocument: json['approvedDocument'] is List
          ? List<String>.from(
        (json['approvedDocument'] as List)
            .where((item) => item != null)
            .map((item) => item.toString()),
      )
          : null,

      companyId: json['companyId']?.toString(),
      isByAdmin: json['isByAdmin']?.toString(),
      documentName: json['documentName']?.toString(),
      documentUploadedBy: json['documentUploadedBy']?.toString(),
      actionRemarks: json['actionRemarks']?.toString(),
      employeeName: json['employeeName']?.toString(),
      employeeDesignation: json['employeeDesignation']?.toString(),
      profilePicture: json['profilePicture']?.toString(),
      mainStatus: json['mainStatus']?.toString(),

      adminData: json['adminData'] is Map<String, dynamic>
          ? AdminData.fromJson(json['adminData'])
          : null,

      approvalData: json['approvalData'] is List
          ? (json['approvalData'] as List)
          .whereType<Map<String, dynamic>>()
          .map(ApprovalData.fromJson)
          .toList()
          : null,

      approvedDocumentName: json['approvedDocumentName'] is List
          ? List<String>.from(
        (json['approvedDocumentName'] as List)
            .where((item) => item != null)
            .map((item) => item.toString()),
      )
          : null,

      documentUploader: json['documentUploader']?.toString(),
      mainStatusColor: json['mainStatusColor']?.toString(),
      requestStatusName: json['requestStatusName']?.toString(),
      isSelected:
      json['isSelected'] is bool ? json['isSelected'] as bool : false,
      requestStatusColour: json['requestStatusColour']?.toString(),
      specialRequestJson: json['specialRequestJson'] != null
          ? new SpecialRequestJson.fromJson(json['specialRequestJson'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'specialRequestId': specialRequestId,
      'employeeId': employeeId,
      'requestType': requestType,
      'requestDescription': requestDescription,
      'fromDate': fromDate,
      'toDate': toDate,
      'requestStatus': requestStatus,
      'isActive': isActive,
      'createdOn': createdOn,
      'createdBy': createdBy,
      'modifiedOn': modifiedOn,
      'modifiedBy': modifiedBy,
      'requestLetterType': requestLetterType,
      'approvedDocument': approvedDocument,
      'companyId': companyId,
      'isByAdmin': isByAdmin,
      'documentName': documentName,
      'documentUploadedBy': documentUploadedBy,
      'actionRemarks': actionRemarks,
      'employeeName': employeeName,
      'employeeDesignation': employeeDesignation,
      'profilePicture': profilePicture,
      'mainStatus': mainStatus,
      'adminData': adminData?.toJson(),
      'approvalData': approvalData?.map((item) => item.toJson()).toList(),
      'approvedDocumentName': approvedDocumentName,
      'documentUploader': documentUploader,
      'mainStatusColor': mainStatusColor,
      'requestStatusName': requestStatusName,
      'isSelected': isSelected,
      'requestStatusColour': requestStatusColour,
      'specialRequestJson': specialRequestJson!.toJson(),
    };
  }
}

class SpecialRequestJson {
  int? allowedPunchMethod;

  SpecialRequestJson({this.allowedPunchMethod});

  SpecialRequestJson.fromJson(Map<String, dynamic> json) {
    allowedPunchMethod = json['allowedPunchMethod'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['allowedPunchMethod'] = this.allowedPunchMethod;
    return data;
  }
}

// class ApprovalData {
//   String? employeeId;
//   String? firstName;
//   String? lastName;
//   String? profilePicture;
//   String? status;
//   String? modifiedOn;
//   String? remarks;
//   String? designation;
//   String? step;
//
//   ApprovalData(
//       {this.employeeId,
//         this.firstName,
//         this.lastName,
//         this.profilePicture,
//         this.status,
//         this.modifiedOn,
//         this.remarks,
//         this.designation,
//         this.step});
//
//   ApprovalData.fromJson(Map<String, dynamic> json) {
//     employeeId = json['employeeId'];
//     firstName = json['firstName'];
//     lastName = json['lastName'];
//     profilePicture = json['profilePicture'];
//     status = json['status'];
//     modifiedOn = json['modifiedOn'];
//     remarks = json['remarks'];
//     designation = json['designation'];
//     step = json['step'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['employeeId'] = this.employeeId;
//     data['firstName'] = this.firstName;
//     data['lastName'] = this.lastName;
//     data['profilePicture'] = this.profilePicture;
//     data['status'] = this.status;
//     data['modifiedOn'] = this.modifiedOn;
//     data['remarks'] = this.remarks;
//     data['designation'] = this.designation;
//     data['step'] = this.step;
//     return data;
//   }
// }