class AirTicketListApi {
  int? status;
  String? message;
  // List<Null>? errors;
  AirTicketResult? result;

  AirTicketListApi({this.status, this.message, this.result});

  AirTicketListApi.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    // if (json['errors'] != null) {
    //   errors = <Null>[];
    //   json['errors'].forEach((v) {
    //     errors!.add(new Null.fromJson(v));
    //   });
    // }
    result =
    json['result'] != null ? new AirTicketResult.fromJson(json['result']) : null;
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

class AirTicketResult {
  List<AirTicketData>? data;

  AirTicketResult({this.data});

  AirTicketResult.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <AirTicketData>[];
      json['data'].forEach((v) {
        data!.add(new AirTicketData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AirTicketData {
  int? ticketReqId;
  String? reqType;
  String? reqEmployeeId;
  String? reqDate;
  String? reqAmount;
  String? reqVatAmount;
  String? reqDescription;
  String? reqAttachment;
  String? reqStatus;
  int? isActive;
  String? createdOn;
  int? createdBy;
  String? modifiedOn;
  String? modifiedBy;
  List<PassengerData>? passengerData;
  String? companyId;
  String? approvedAmount;
  String? fromLocation;
  String? toLocation;
  String? date;
  TicketData? ticketData;
  String? policyId;
  String? ticketType;
  String? firstName;
  String? lastName;
  String? profilePicture;
  String? empCode;
  String? employeeName;
  String? reqStatusLabel;

  AirTicketData(
      {this.ticketReqId,
        this.reqType,
        this.reqEmployeeId,
        this.reqDate,
        this.reqAmount,
        this.reqVatAmount,
        this.reqDescription,
        this.reqAttachment,
        this.reqStatus,
        this.isActive,
        this.createdOn,
        this.createdBy,
        this.modifiedOn,
        this.modifiedBy,
        this.passengerData,
        this.companyId,
        this.approvedAmount,
        this.fromLocation,
        this.toLocation,
        this.date,
        this.ticketData,
        this.policyId,
        this.ticketType,
        this.firstName,
        this.lastName,
        this.profilePicture,
        this.empCode,
        this.employeeName,
        this.reqStatusLabel});

  AirTicketData.fromJson(Map<String, dynamic> json) {
    ticketReqId = json['ticketReqId'];
    reqType = json['reqType'];
    reqEmployeeId = json['reqEmployeeId'];
    reqDate = json['reqDate'];
    reqAmount = json['reqAmount'];
    reqVatAmount = json['reqVatAmount'];
    reqDescription = json['reqDescription'];
    reqAttachment = json['reqAttachment'];
    reqStatus = json['reqStatus'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    createdBy = json['createdBy'];
    modifiedOn = json['modifiedOn'];
    modifiedBy = json['modifiedBy'];
    if (json['passengerData'] != null) {
      passengerData = <PassengerData>[];
      json['passengerData'].forEach((v) {
        passengerData!.add(new PassengerData.fromJson(v));
      });
    }
    companyId = json['companyId'];
    approvedAmount = json['approvedAmount'];
    fromLocation = json['fromLocation'];
    toLocation = json['toLocation'];
    date = json['date'];
    if (json['ticketData'] != null && json['ticketData'] is Map<String, dynamic>) {
      ticketData = TicketData.fromJson(json['ticketData']);
    } else {
      ticketData = null;
    }
    policyId = json['policyId'];
    ticketType = json['ticketType'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    profilePicture = json['profilePicture'];
    empCode = json['empCode'];
    employeeName = json['employeeName'];
    reqStatusLabel = json['reqStatusLabel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ticketReqId'] = this.ticketReqId;
    data['reqType'] = this.reqType;
    data['reqEmployeeId'] = this.reqEmployeeId;
    data['reqDate'] = this.reqDate;
    data['reqAmount'] = this.reqAmount;
    data['reqVatAmount'] = this.reqVatAmount;
    data['reqDescription'] = this.reqDescription;
    data['reqAttachment'] = this.reqAttachment;
    data['reqStatus'] = this.reqStatus;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['createdBy'] = this.createdBy;
    data['modifiedOn'] = this.modifiedOn;
    data['modifiedBy'] = this.modifiedBy;
    if (this.passengerData != null) {
      data['passengerData'] =
          this.passengerData!.map((v) => v.toJson()).toList();
    }
    data['companyId'] = this.companyId;
    data['approvedAmount'] = this.approvedAmount;
    data['fromLocation'] = this.fromLocation;
    data['toLocation'] = this.toLocation;
    data['date'] = this.date;
    if (this.ticketData != null) {
      data['ticketData'] = this.ticketData!.toJson();
    }
    data['policyId'] = this.policyId;
    data['ticketType'] = this.ticketType;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['profilePicture'] = this.profilePicture;
    data['empCode'] = this.empCode;
    data['employeeName'] = this.employeeName;
    data['reqStatusLabel'] = this.reqStatusLabel;
    return data;
  }
}

class TicketData {
  String? airLineName;
  String? arrivalTime;
  String? departureTime;
  String? duration;
  List<String>? ticketAttachment;

  TicketData(
      {this.airLineName,
        this.arrivalTime,
        this.departureTime,
        this.duration,
        this.ticketAttachment});

  TicketData.fromJson(Map<String, dynamic> json) {
    airLineName = json['airLineName'];
    arrivalTime = json['arrivalTime'];
    departureTime = json['departureTime'];
    duration = json['duration'];
    ticketAttachment = json['ticketAttachment'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['airLineName'] = this.airLineName;
    data['arrivalTime'] = this.arrivalTime;
    data['departureTime'] = this.departureTime;
    data['duration'] = this.duration;
    data['ticketAttachment'] = this.ticketAttachment;
    return data;
  }
}

class AirTicketDetailsApi {
  int? status;
  String? message;
  // List<Null>? errors;
  AirTicketDetails? result;

  AirTicketDetailsApi({this.status, this.message, this.result});

  AirTicketDetailsApi.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    // if (json['errors'] != null) {
    //   errors = <Null>[];
    //   json['errors'].forEach((v) {
    //     errors!.add(new Null.fromJson(v));
    //   });
    // }
    result =
    json['result'] != null ? new AirTicketDetails.fromJson(json['result']) : null;
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

class AirTicketDetails {
  List<String>? policyRequestType;
  String? policyIsAllowDependents;
  String? pocilyMaxDependents;
  String? policyIsOneWay;

  AirTicketDetails(
      {this.policyRequestType,
        this.policyIsAllowDependents,
        this.pocilyMaxDependents,
        this.policyIsOneWay});

  AirTicketDetails.fromJson(Map<String, dynamic> json) {
    policyRequestType = json['policyRequestType'].cast<String>();
    policyIsAllowDependents = json['policyIsAllowDependents'];
    pocilyMaxDependents = json['pocilyMaxDependents']?.toString();
    policyIsOneWay = json['policyIsOneWay'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['policyRequestType'] = this.policyRequestType;
    data['policyIsAllowDependents'] = this.policyIsAllowDependents;
    data['pocilyMaxDependents'] = this.pocilyMaxDependents;
    data['policyIsOneWay'] = this.policyIsOneWay;
    return data;
  }
}

class AirTicketCreatingModel {
  String? reqType;
  String? reqEmployeeId;
  String? reqDate;
  String? reqAmount;
  String? reqVatAmount;
  String? reqDescription;
  int? isActive;
  String? companyId;
  String? createdBy;
  List<PassengerData>? passengerData;
  int? ticketType;
  String? employeePassport;
  String? fromLocation;
  String? toLocation;

  AirTicketCreatingModel(
      {this.reqType,
        this.reqEmployeeId,
        this.reqDate,
        this.reqAmount,
        this.reqVatAmount,
        this.reqDescription,
        this.isActive,
        this.companyId,
        this.createdBy,
        this.passengerData,
        this.ticketType,
        this.employeePassport,
        this.fromLocation,
        this.toLocation});

  AirTicketCreatingModel.fromJson(Map<String, dynamic> json) {
    reqType = json['reqType'];
    reqEmployeeId = json['reqEmployeeId'];
    reqDate = json['reqDate'];
    reqAmount = json['reqAmount'];
    reqVatAmount = json['reqVatAmount'];
    reqDescription = json['reqDescription'];
    isActive = json['isActive'];
    companyId = json['companyId'];
    createdBy = json['createdBy'];
    if (json['passengerData'] != null) {
      passengerData = <PassengerData>[];
      json['passengerData'].forEach((v) {
        passengerData!.add(new PassengerData.fromJson(v));
      });
    }
    ticketType = json['ticketType'];
    employeePassport = json['employeePassport'];
    fromLocation = json['fromLocation'];
    toLocation = json['toLocation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reqType'] = this.reqType;
    data['reqEmployeeId'] = this.reqEmployeeId;
    data['reqDate'] = this.reqDate;
    data['reqAmount'] = this.reqAmount;
    data['reqVatAmount'] = this.reqVatAmount;
    data['reqDescription'] = this.reqDescription;
    data['isActive'] = this.isActive;
    data['companyId'] = this.companyId;
    data['createdBy'] = this.createdBy;
    if (this.passengerData != null) {
      data['passengerData'] =
          this.passengerData!.map((v) => v.toJson()).toList();
    }
    data['ticketType'] = this.ticketType;
    data['employeePassport'] = this.employeePassport;
    data['fromLocation'] = this.fromLocation;
    data['toLocation'] = this.toLocation;
    return data;
  }
}

class PassengerData {
  String? name;
  String? email;
  String? gender;
  String? dateOfBirth;
  String? passengerType;
  String? passportNo;
  bool isExpanded = false;

  PassengerData(
      {this.name,
        this.email,
        this.gender,
        this.dateOfBirth,
        this.passengerType,
        this.isExpanded = false,
        this.passportNo});

  PassengerData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    gender = json['gender'];
    dateOfBirth = json['dateOfBirth'];
    passengerType = json['passengerType'];
    passportNo = json['passportNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['gender'] = this.gender;
    data['dateOfBirth'] = this.dateOfBirth;
    data['passengerType'] = this.passengerType;
    data['passportNo'] = this.passportNo;
    return data;
  }
}