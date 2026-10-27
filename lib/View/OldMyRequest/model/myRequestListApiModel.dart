
class MyRequestListApiModel {
  int? status;
  String? message;
  List<dynamic>? errors;
  List<RequestData>? result;

  MyRequestListApiModel({this.status, this.message, this.errors, this.result});

  MyRequestListApiModel.fromJson(Map<String, dynamic> json) {
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
  // String? specialRequestId;
  // String? employeeId;
  String? requestType;
  String? requestDescription;
  String? fromDate;
  String? toDate;
  String? requestStatus;
  // String? isActive;
  // String? createdOn;
  // String? createdBy;
  // String? modifiedOn;
  // String? modifiedBy;
  String? requestLetterType;
  String? approvedDocument;
  String? documentName;
  String? requestStatusName;
  String? requestStatusColour;

  RequestData(
      {
        // this.specialRequestId,
        // this.employeeId,
        this.requestType,
        this.requestDescription,
        this.fromDate,
        this.toDate,
        this.requestStatus,
        // this.isActive,
        // this.createdOn,
        // this.createdBy,
        // this.modifiedOn,
        // this.modifiedBy,
        this.requestLetterType,
        this.approvedDocument,
        this.documentName,
        this.requestStatusName,
        this.requestStatusColour});

  RequestData.fromJson(Map<String, dynamic> json) {
    // specialRequestId = json['specialRequestId'];
    // employeeId = json['employeeId'];
    requestType = json['requestType'];
    requestDescription = json['requestDescription'];
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    requestStatus = json['requestStatus'];
    // isActive = json['isActive'];
    // createdOn = json['createdOn'];
    // createdBy = json['createdBy'];
    // modifiedOn = json['modifiedOn'];
    // modifiedBy = json['modifiedBy'];
    requestLetterType = json['requestLetterType'];
    approvedDocument = json['approvedDocument'];
    documentName = json['documentName'];
    requestStatusName = json['requestStatusName'];
    requestStatusColour = json['requestStatusColour'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // data['specialRequestId'] = specialRequestId;
    // data['employeeId'] = employeeId;
    data['requestType'] = requestType;
    data['requestDescription'] = requestDescription;
    data['fromDate'] = fromDate;
    data['toDate'] = toDate;
    data['requestStatus'] = requestStatus;
    // data['isActive'] = isActive;
    // data['createdOn'] = createdOn;
    // data['createdBy'] = createdBy;
    // data['modifiedOn'] = modifiedOn;
    // data['modifiedBy'] = modifiedBy;
    data['requestLetterType'] = requestLetterType;
    data['approvedDocument'] = approvedDocument;
    data['documentName'] = documentName;
    data['requestStatusName'] = requestStatusName;
    data['requestStatusColour'] = requestStatusColour;
    return data;
  }
}