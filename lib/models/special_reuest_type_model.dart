class SpecialRequestTypeApi {
  int? status;
  String? message;
  List<ModuleListData>? result;

  SpecialRequestTypeApi({this.status, this.message, this.result});

  SpecialRequestTypeApi.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['result'] != null) {
      result = <ModuleListData>[];
      json['result'].forEach((v) {
        result!.add(ModuleListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ModuleListData {
  String? requestModule;
  List<RequestList>? requestList;
  String? createdOn;
  String? modifiedOn;

  ModuleListData(
      {this.requestModule, this.requestList, this.createdOn, this.modifiedOn});

  ModuleListData.fromJson(Map<String, dynamic> json) {
    requestModule = json['requestModule'];
    if (json['requestList'] != null) {
      requestList = <RequestList>[];
      json['requestList'].forEach((v) {
        requestList!.add(RequestList.fromJson(v));
      });
    }
    createdOn = json['createdOn'];
    modifiedOn = json['modifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['requestModule'] = this.requestModule;
    if (this.requestList != null) {
      data['requestList'] = this.requestList!.map((v) => v.toJson()).toList();
    }
    data['createdOn'] = this.createdOn;
    data['modifiedOn'] = this.modifiedOn;
    return data;
  }
}

class RequestList {
  String? specialRequestTypeId;
  String? specialRequestType;
  String? approvalTypeId;
  String? isActive;
  String? reqIndex;
  String? createdOn;
  String? modifiedOn;

  RequestList(
      {this.specialRequestTypeId,
        this.specialRequestType,
        this.approvalTypeId,
        this.isActive,
        this.reqIndex,
        this.createdOn,
        this.modifiedOn});

  RequestList.fromJson(Map<String, dynamic> json) {
    specialRequestTypeId = json['specialRequestTypeId'];
    specialRequestType = json['specialRequestType'];
    approvalTypeId = json['approvalTypeId'];
    isActive = json['isActive'];
    reqIndex = json['reqIndex'];
    createdOn = json['createdOn'];
    modifiedOn = json['modifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['specialRequestTypeId'] = this.specialRequestTypeId;
    data['specialRequestType'] = this.specialRequestType;
    data['approvalTypeId'] = this.approvalTypeId;
    data['isActive'] = this.isActive;
    data['reqIndex'] = this.reqIndex;
    data['createdOn'] = this.createdOn;
    data['modifiedOn'] = this.modifiedOn;
    return data;
  }
}