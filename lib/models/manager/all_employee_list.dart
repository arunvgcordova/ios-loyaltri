class AllEmployeeList {
  int? status;
  String? message;
  // List<Null>? errors;
  List<CompanyEmployeeData>? result;

  AllEmployeeList({this.status, this.message, this.result});

  AllEmployeeList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    // if (json['errors'] != null) {
    //   errors = <Null>[];
    //   json['errors'].forEach((v) {
    //     errors!.add(new Null.fromJson(v));
    //   });
    // }
    if (json['result'] != null) {
      result = <CompanyEmployeeData>[];
      json['result'].forEach((v) {
        result!.add(new CompanyEmployeeData.fromJson(v));
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

class CompanyEmployeeData {
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
  // Null? createdBy;
  String? createdOn;
  // Null? modifiedBy;
  String? modifiedOn;
  String? phone;
  String? email;
  String? profilePicture;
  String? adminLevel;
  String? fatherOrHusbandName;
  String? isNewJoiner;
  String? isEmailVerified;
  String? fullName;
  String? designation;
  String? departmentId;
  String? categoryId;
  String? locationId;
  String? joiningDate;
  String? noticePeriod;
  String? code;
  String? timeInOutPolicy;
  // Null? overtimePolicy;
  String? shortTimePolicy;
  String? missPunchPolicy;
  String? salaryPolicy;
  String? holidayPolicy;
  String? attendanceOnHolidayPolicy;
  String? shiftSchemeId;
  String? employeeStatus;
  String? statusColour;
  String? departmentName;
  String? categoryName;
  String? locationName;
  // Null? subCategoryId;
  // Null? subCategoryName;
  String? shiftSchemeName;
  String? attendanceOnHolidayPolicyName;
  String? missPunchPolicyName;
  // Null? overtimePolicyName;
  String? timeInOutPolicyName;
  String? workCount;
  int? profileCompletion;
  String? absProfilePicture;
  int? offBoarding;
  int? isFaceAdded;

  CompanyEmployeeData(
      {this.employeeId,
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
        // this.createdBy,
        this.createdOn,
        // this.modifiedBy,
        this.modifiedOn,
        this.phone,
        this.email,
        this.profilePicture,
        this.adminLevel,
        this.fatherOrHusbandName,
        this.isNewJoiner,
        this.isEmailVerified,
        this.fullName,
        this.designation,
        this.departmentId,
        this.categoryId,
        this.locationId,
        this.joiningDate,
        this.noticePeriod,
        this.code,
        this.timeInOutPolicy,
        // this.overtimePolicy,
        this.shortTimePolicy,
        this.missPunchPolicy,
        this.salaryPolicy,
        this.holidayPolicy,
        this.attendanceOnHolidayPolicy,
        this.shiftSchemeId,
        this.employeeStatus,
        this.statusColour,
        this.departmentName,
        this.categoryName,
        this.locationName,
        // this.subCategoryId,
        // this.subCategoryName,
        this.shiftSchemeName,
        this.attendanceOnHolidayPolicyName,
        this.missPunchPolicyName,
        // this.overtimePolicyName,
        this.timeInOutPolicyName,
        this.workCount,
        this.profileCompletion,
        this.absProfilePicture,
        this.offBoarding,
        this.isFaceAdded});

  CompanyEmployeeData.fromJson(Map<String, dynamic> json) {
    employeeId = json['employeeId'];
    companyId = json['companyId'];
    firstName = json['firstName'];
    middleName = json['middleName'];
    lastName = json['lastName'];
    nickName = json['nickName'];
    dateOfBirth = json['dateOfBirth'];
    gender = json['gender'];
    religionId = json['religionId'];
    bloodGroup = json['bloodGroup'];
    isActive = json['isActive'];
    // createdBy = json['createdBy'];
    createdOn = json['createdOn'];
    // modifiedBy = json['modifiedBy'];
    modifiedOn = json['modifiedOn'];
    phone = json['phone'];
    email = json['email'];
    profilePicture = json['profilePicture'];
    adminLevel = json['adminLevel'];
    fatherOrHusbandName = json['fatherOrHusbandName'];
    isNewJoiner = json['isNewJoiner'];
    isEmailVerified = json['isEmailVerified'];
    fullName = json['fullName'];
    designation = json['designation'];
    departmentId = json['departmentId'];
    categoryId = json['categoryId'];
    locationId = json['locationId'];
    joiningDate = json['joiningDate'];
    noticePeriod = json['noticePeriod'];
    code = json['code'];
    timeInOutPolicy = json['timeInOutPolicy'];
    // overtimePolicy = json['overtimePolicy'];
    shortTimePolicy = json['shortTimePolicy'];
    missPunchPolicy = json['missPunchPolicy'];
    salaryPolicy = json['salaryPolicy'];
    holidayPolicy = json['holidayPolicy'];
    attendanceOnHolidayPolicy = json['attendanceOnHolidayPolicy'];
    shiftSchemeId = json['shiftSchemeId'];
    employeeStatus = json['employeeStatus'];
    statusColour = json['statusColour'];
    departmentName = json['departmentName'];
    categoryName = json['categoryName'];
    locationName = json['locationName'];
    // subCategoryId = json['subCategoryId'];
    // subCategoryName = json['subCategoryName'];
    shiftSchemeName = json['shiftSchemeName'];
    attendanceOnHolidayPolicyName = json['attendanceOnHolidayPolicyName'];
    missPunchPolicyName = json['missPunchPolicyName'];
    // overtimePolicyName = json['overtimePolicyName'];
    timeInOutPolicyName = json['timeInOutPolicyName'];
    workCount = json['workCount']?.toString();
    profileCompletion = json['profileCompletion'];
    absProfilePicture = json['absProfilePicture'];
    offBoarding = json['offBoarding'];
    isFaceAdded = json['isFaceAdded'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employeeId'] = this.employeeId;
    data['companyId'] = this.companyId;
    data['firstName'] = this.firstName;
    data['middleName'] = this.middleName;
    data['lastName'] = this.lastName;
    data['nickName'] = this.nickName;
    data['dateOfBirth'] = this.dateOfBirth;
    data['gender'] = this.gender;
    data['religionId'] = this.religionId;
    data['bloodGroup'] = this.bloodGroup;
    data['isActive'] = this.isActive;
    // data['createdBy'] = this.createdBy;
    data['createdOn'] = this.createdOn;
    // data['modifiedBy'] = this.modifiedBy;
    data['modifiedOn'] = this.modifiedOn;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['profilePicture'] = this.profilePicture;
    data['adminLevel'] = this.adminLevel;
    data['fatherOrHusbandName'] = this.fatherOrHusbandName;
    data['isNewJoiner'] = this.isNewJoiner;
    data['isEmailVerified'] = this.isEmailVerified;
    data['fullName'] = this.fullName;
    data['designation'] = this.designation;
    data['departmentId'] = this.departmentId;
    data['categoryId'] = this.categoryId;
    data['locationId'] = this.locationId;
    data['joiningDate'] = this.joiningDate;
    data['noticePeriod'] = this.noticePeriod;
    data['code'] = this.code;
    data['timeInOutPolicy'] = this.timeInOutPolicy;
    // data['overtimePolicy'] = this.overtimePolicy;
    data['shortTimePolicy'] = this.shortTimePolicy;
    data['missPunchPolicy'] = this.missPunchPolicy;
    data['salaryPolicy'] = this.salaryPolicy;
    data['holidayPolicy'] = this.holidayPolicy;
    data['attendanceOnHolidayPolicy'] = this.attendanceOnHolidayPolicy;
    data['shiftSchemeId'] = this.shiftSchemeId;
    data['employeeStatus'] = this.employeeStatus;
    data['statusColour'] = this.statusColour;
    data['departmentName'] = this.departmentName;
    data['categoryName'] = this.categoryName;
    data['locationName'] = this.locationName;
    // data['subCategoryId'] = this.subCategoryId;
    // data['subCategoryName'] = this.subCategoryName;
    data['shiftSchemeName'] = this.shiftSchemeName;
    data['attendanceOnHolidayPolicyName'] = this.attendanceOnHolidayPolicyName;
    data['missPunchPolicyName'] = this.missPunchPolicyName;
    // data['overtimePolicyName'] = this.overtimePolicyName;
    data['timeInOutPolicyName'] = this.timeInOutPolicyName;
    data['workCount'] = this.workCount;
    data['profileCompletion'] = this.profileCompletion;
    data['absProfilePicture'] = this.absProfilePicture;
    data['offBoarding'] = this.offBoarding;
    data['isFaceAdded'] = this.isFaceAdded;
    return data;
  }
}