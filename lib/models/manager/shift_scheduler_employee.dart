class ShiftSchedulerEmployeeResponse {
  int? status;
  String? message;
  List<dynamic>? errors;
  List<ShiftSchedulerEmployee>? result;

  ShiftSchedulerEmployeeResponse({
    this.status,
    this.message,
    this.errors,
    this.result,
  });

  factory ShiftSchedulerEmployeeResponse.fromJson(Map<String, dynamic> json) =>
      ShiftSchedulerEmployeeResponse(
        status: json["status"],
        message: json["message"],
        errors: json["errors"] == null
            ? []
            : List<dynamic>.from(json["errors"]!.map((x) => x)),
        result: json["result"] == null
            ? []
            : List<ShiftSchedulerEmployee>.from(json["result"]!
                .map((x) => ShiftSchedulerEmployee.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "errors":
            errors == null ? [] : List<dynamic>.from(errors!.map((x) => x)),
        "result": result == null
            ? []
            : List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class ShiftSchedulerEmployee {
  String? employeeId;
  String? companyId;
  String? firstName;
  String? middleName;
  String? lastName;
  String? nickName;
  String? dateOfBirth;
  String? gender;
  String? religionId;
  String? bloodGroup;
  String? isActive;
  String? createdBy;
  String? createdOn;
  String? modifiedBy;
  String? modifiedOn;
  String? phone;
  String? email;
  String? profilePicture;
  String? adminLevel;
  String? fatherOrHusbandName;
  String? isNewJoiner;
  String? isEmailVerified;
  String? passportNo;
  String? isSendInvitation;
  String? customData;
  String? shiftSchemeId;
  String? code;
  String? employeeName;
  String? department;
  String? profilePicName;
  List<ShiftSheduledData>? shiftSheduledData;

  ShiftSchedulerEmployee({
    this.employeeId,
    this.companyId,
    this.firstName,
    this.middleName,
    this.lastName,
    this.nickName,
    this.dateOfBirth,
    this.gender,
    this.religionId,
    this.bloodGroup,
    this.isActive,
    this.createdBy,
    this.createdOn,
    this.modifiedBy,
    this.modifiedOn,
    this.phone,
    this.email,
    this.profilePicture,
    this.adminLevel,
    this.fatherOrHusbandName,
    this.isNewJoiner,
    this.isEmailVerified,
    this.passportNo,
    this.isSendInvitation,
    this.customData,
    this.shiftSchemeId,
    this.code,
    this.employeeName,
    this.department,
    this.profilePicName,
    this.shiftSheduledData,
  });

  factory ShiftSchedulerEmployee.fromJson(Map<String, dynamic> json) =>
      ShiftSchedulerEmployee(
        employeeId: json["employeeId"]?.toString(),
        companyId: json["companyId"]?.toString(),
        firstName: json["firstName"],
        middleName: json["middleName"],
        lastName: json["lastName"],
        nickName: json["nickName"],
        dateOfBirth: json["dateOfBirth"],
        gender: json["gender"],
        religionId: json["religionId"]?.toString(),
        bloodGroup: json["bloodGroup"],
        isActive: json["isActive"]?.toString(),
        createdBy: json["createdBy"]?.toString(),
        createdOn: json["createdOn"],
        modifiedBy: json["modifiedBy"]?.toString(),
        modifiedOn: json["modifiedOn"],
        phone: json["phone"],
        email: json["email"],
        profilePicture: json["profilePicture"],
        adminLevel: json["adminLevel"]?.toString(),
        fatherOrHusbandName: json["fatherOrHusbandName"],
        isNewJoiner: json["isNewJoiner"]?.toString(),
        isEmailVerified: json["isEmailVerified"]?.toString(),
        passportNo: json["passportNo"],
        isSendInvitation: json["isSendInvitation"]?.toString(),
        customData: json["customData"],
        shiftSchemeId: json["shiftSchemeId"]?.toString(),
        code: json["code"]?.toString(),
        employeeName: json["employeeName"],
        department: json["department"],
        profilePicName: json["profilePicName"],
        shiftSheduledData: json["shiftSheduledData"] == null
            ? []
            : List<ShiftSheduledData>.from(json["shiftSheduledData"]!
                .map((x) => ShiftSheduledData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "employeeId": employeeId,
        "companyId": companyId,
        "firstName": firstName,
        "middleName": middleName,
        "lastName": lastName,
        "nickName": nickName,
        "dateOfBirth": dateOfBirth,
        "gender": gender,
        "religionId": religionId,
        "bloodGroup": bloodGroup,
        "isActive": isActive,
        "createdBy": createdBy,
        "createdOn": createdOn,
        "modifiedBy": modifiedBy,
        "modifiedOn": modifiedOn,
        "phone": phone,
        "email": email,
        "profilePicture": profilePicture,
        "adminLevel": adminLevel,
        "fatherOrHusbandName": fatherOrHusbandName,
        "isNewJoiner": isNewJoiner,
        "isEmailVerified": isEmailVerified,
        "passportNo": passportNo,
        "isSendInvitation": isSendInvitation,
        "customData": customData,
        "shiftSchemeId": shiftSchemeId,
        "code": code,
        "employeeName": employeeName,
        "department": department,
        "profilePicName": profilePicName,
        "shiftSheduledData": shiftSheduledData == null
            ? []
            : List<dynamic>.from(shiftSheduledData!.map((x) => x.toJson())),
      };
}

class ShiftSheduledData {
  String? shiftSheduledDataId;
  String? shiftId;
  String? date;
  String? shift;
  String? startTime;
  String? endTime;
  String? workHours;
  String? shiftType;

  ShiftSheduledData({
    this.shiftSheduledDataId,
    this.shiftId,
    this.date,
    this.shift,
    this.startTime,
    this.endTime,
    this.workHours,
    this.shiftType,
  });

  factory ShiftSheduledData.fromJson(Map<String, dynamic> json) =>
      ShiftSheduledData(
        shiftSheduledDataId: json["shiftSheduledDataId"]?.toString(),
        shiftId: json["shiftId"]?.toString(),
        date: json["date"],
        shift: json["shift"],
        startTime: json["startTime"],
        endTime: json["endTime"],
        workHours: json["workHours"],
        shiftType: json["shiftType"],
      );

  Map<String, dynamic> toJson() => {
        "shiftSheduledDataId": shiftSheduledDataId,
        "shiftId": shiftId,
        "date": date,
        "shift": shift,
        "startTime": startTime,
        "endTime": endTime,
        "workHours": workHours,
        "shiftType": shiftType,
      };
}
