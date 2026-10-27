class ShiftEmployeeListResponse {
  int? status;
  String? message;
  List<dynamic>? errors;
  List<ShiftEmployeeModel>? result;

  ShiftEmployeeListResponse({
    this.status,
    this.message,
    this.errors,
    this.result,
  });

  ShiftEmployeeListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['errors'] != null) {
      errors = json['errors'];
    }
    if (json['result'] != null) {
      result = <ShiftEmployeeModel>[];
      json['result'].forEach((v) {
        result!.add(ShiftEmployeeModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (errors != null) {
      data['errors'] = errors;
    }
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ShiftEmployeeModel {
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

  ShiftEmployeeModel({
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

  ShiftEmployeeModel.fromJson(Map<String, dynamic> json) {
    employeeId = json['employeeId']?.toString();
    companyId = json['companyId']?.toString();
    firstName = json['firstName']?.toString();
    middleName = json['middleName']?.toString();
    lastName = json['lastName']?.toString();
    nickName = json['nickName']?.toString();
    dateOfBirth = json['dateOfBirth']?.toString();
    gender = json['gender']?.toString();
    religionId = json['religionId']?.toString();
    bloodGroup = json['bloodGroup']?.toString();
    isActive = json['isActive']?.toString();
    createdBy = json['createdBy']?.toString();
    createdOn = json['createdOn']?.toString();
    modifiedBy = json['modifiedBy']?.toString();
    modifiedOn = json['modifiedOn']?.toString();
    phone = json['phone']?.toString();
    email = json['email']?.toString();
    profilePicture = json['profilePicture']?.toString();
    adminLevel = json['adminLevel']?.toString();
    fatherOrHusbandName = json['fatherOrHusbandName']?.toString();
    isNewJoiner = json['isNewJoiner']?.toString();
    isEmailVerified = json['isEmailVerified']?.toString();
    passportNo = json['passportNo']?.toString();
    isSendInvitation = json['isSendInvitation']?.toString();
    customData = json['customData']?.toString();
    shiftSchemeId = json['shiftSchemeId']?.toString();
    code = json['code']?.toString();
    employeeName = json['employeeName']?.toString();
    department = json['department']?.toString();
    profilePicName = json['profilePicName']?.toString();
    
    if (json['shiftSheduledData'] != null) {
      shiftSheduledData = <ShiftSheduledData>[];
      json['shiftSheduledData'].forEach((v) {
        shiftSheduledData!.add(ShiftSheduledData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['employeeId'] = employeeId;
    data['companyId'] = companyId;
    data['firstName'] = firstName;
    data['middleName'] = middleName;
    data['lastName'] = lastName;
    data['nickName'] = nickName;
    data['dateOfBirth'] = dateOfBirth;
    data['gender'] = gender;
    data['religionId'] = religionId;
    data['bloodGroup'] = bloodGroup;
    data['isActive'] = isActive;
    data['createdBy'] = createdBy;
    data['createdOn'] = createdOn;
    data['modifiedBy'] = modifiedBy;
    data['modifiedOn'] = modifiedOn;
    data['phone'] = phone;
    data['email'] = email;
    data['profilePicture'] = profilePicture;
    data['adminLevel'] = adminLevel;
    data['fatherOrHusbandName'] = fatherOrHusbandName;
    data['isNewJoiner'] = isNewJoiner;
    data['isEmailVerified'] = isEmailVerified;
    data['passportNo'] = passportNo;
    data['isSendInvitation'] = isSendInvitation;
    data['customData'] = customData;
    data['shiftSchemeId'] = shiftSchemeId;
    data['code'] = code;
    data['employeeName'] = employeeName;
    data['department'] = department;
    data['profilePicName'] = profilePicName;
    if (shiftSheduledData != null) {
      data['shiftSheduledData'] =
          shiftSheduledData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
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

  ShiftSheduledData.fromJson(Map<String, dynamic> json) {
    shiftSheduledDataId = json['shiftSheduledDataId']?.toString();
    shiftId = json['shiftId']?.toString();
    date = json['date']?.toString();
    shift = json['shift']?.toString();
    startTime = json['startTime']?.toString();
    endTime = json['endTime']?.toString();
    workHours = json['workHours']?.toString();
    shiftType = json['shiftType']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['shiftSheduledDataId'] = shiftSheduledDataId;
    data['shiftId'] = shiftId;
    data['date'] = date;
    data['shift'] = shift;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['workHours'] = workHours;
    data['shiftType'] = shiftType;
    return data;
  }
}
