class UserProfileApiModel {
  final int status;
  final String message;
  final List errors;
  final UserProfile result;

  const UserProfileApiModel({
    required this.status,
    required this.message,
    required this.errors,
    required this.result,
  });

  factory UserProfileApiModel.fromJson(Map<String, dynamic> json) =>
      UserProfileApiModel(
        status: json['status'],
        message: json['message'],
        errors: json['errors'],
        result: UserProfile.fromJson(json['result']),
      );
}

class UserProfile {
  String? employeeId;
  String? companyId;
  String? firstName;
  String? employeeName;
  String? middleName;
  String? lastName;
  String? nickName;
  String? dateOfBirth;
  String? gender;
  String? passportNo;
  // String? religionId;
  // String? bloodGroup;
  // String? isActive;
  // String? createdBy;
  // String? createdOn;
  // String? modifiedBy;
  // String? modifiedOn;
  String? phone;
  String? email;
  String? profilePicture;
  // String? address;
  // String? permanentAddress;
  // String? timeInOutPolicyName;
  // String? overTimePolicyName;
  // String? shortTimePolicyName;
  // String? missPunchPolicyName;
  String? absProfilePicture;
  String? designation;
  String? department;
  // String? category;
  // String? subCategory;
  // String? shiftScheme;
  String? company;
  // String? religionName;
  // String? countryId;
  // String? poBox;
  // String? cityId;
  // String? stateId;
  String? zipCode;
  // String? permanentCityId;
  // String? permanentStateId;
  // String? permanentZipCode;
  // String? permanentCountryId;
  // String? employeeCompanyId;
  String? code;
  // String? departmentId;
  // String? locationId;
  // String? categoryId;
  // String? subCategoryId;
  // String? designationId;
  String? probationPeriod;
  String? probationEndDate;
  // String? noticePeriod;
  // String? shiftSchemeId;
  String? joiningDate;
  // String? timeInOutPolicy;
  // String? overtimePolicy;
  // String? shortTimePolicy;
  // String? missPunchPolicy;
  // String? salaryPolicy;
  // String? reportsTo;
  // String? holidayPolicy;
  // String? punchIdentifier;
  // String? location;
  String? countryName;
  String? stateName;
  String? city;
  // String? permanentCountry;
  // String? permanentState;
  // String? permanentCity;
  String? organisationId;
  // String? employeeAddressId;
  // String? workPolicyId;
  String? salaryAccess;
  String? workEntryAccess;
  String? airTicketAccess;
  String? taskAccess;
  String? breakAccess;
  String? expenseReimbursement;
  String? isAllowFields;
  // List<EmployeeLeaves>? employeeLeaves;
  List<ShiftData>? employeeShift;

  UserProfile(
      {this.employeeId,
      this.companyId,
      this.firstName,
      this.employeeName,
      this.middleName,
      this.lastName,
      this.nickName,
      this.dateOfBirth,
      this.gender,
      this.passportNo,
      // this.religionId,
      // this.bloodGroup,
      // this.isActive,
      // this.createdBy,
      // this.createdOn,
      // this.modifiedBy,
      // this.modifiedOn,
      this.phone,
      this.email,
      this.profilePicture,
      // this.address,
      // this.permanentAddress,
      // this.timeInOutPolicyName,
      // this.overTimePolicyName,
      // this.shortTimePolicyName,
      // this.missPunchPolicyName,
      this.absProfilePicture,
      this.designation,
      this.department,
      // this.category,
      // this.subCategory,
      // this.shiftScheme,
      this.company,
      // this.religionName,
      // this.countryId,
      // this.poBox,
      // this.cityId,
      // this.stateId,
      this.zipCode,
      // this.permanentCityId,
      // this.permanentStateId,
      // this.permanentZipCode,
      // this.permanentCountryId,
      // this.employeeCompanyId,
      this.code,
      // this.departmentId,
      // this.locationId,
      // this.categoryId,
      // this.subCategoryId,
      // this.designationId,
      this.probationPeriod,
      this.probationEndDate,
      // this.noticePeriod,
      // this.shiftSchemeId,
      this.joiningDate,
      // this.timeInOutPolicy,
      // this.overtimePolicy,
      // this.shortTimePolicy,
      // this.missPunchPolicy,
      // this.salaryPolicy,
      // this.reportsTo,
      // this.holidayPolicy,
      // this.punchIdentifier,
      // this.location,
      this.countryName,
      this.stateName,
      this.city,
      // this.permanentCountry,
      // this.permanentState,
      // this.permanentCity,
      this.organisationId,
      // this.employeeAddressId,
      // this.workPolicyId,
      this.salaryAccess,
      this.workEntryAccess,
      this.airTicketAccess,
      this.taskAccess,
      this.breakAccess,
      this.expenseReimbursement,
      this.isAllowFields,
      // this.employeeLeaves,
      this.employeeShift});

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        employeeId: json['employeeId'],
        companyId: json['companyId'],
        firstName: json['firstName'],
    employeeName: json['employeeName'],
        middleName: json['middleName'],
        lastName: json['lastName'],
        nickName: json['nickName'],
        dateOfBirth: json['dateOfBirth'],
        gender: json['gender'],
    passportNo: json['passportNo'],
        // religionId: json['religionId'],
        // bloodGroup: json['bloodGroup'],
        // isActive: json['isActive'],
        // createdBy: json['createdBy'],
        // createdOn: json['createdOn'],
        // modifiedBy: json['modifiedBy'],
        // modifiedOn: json['modifiedOn'],
        phone: json['phone'],
        email: json['email'],
        profilePicture: json['profilePicture'],
        // address: json['address'],
        // permanentAddress: json['PermanentAddress'],
        // timeInOutPolicyName: json['TimeInOutPolicyName'],
        // overTimePolicyName: json['OverTimePolicyName'],
        // shortTimePolicyName: json['ShortTimePolicyName'],
        // missPunchPolicyName: json['MissPunchPolicyName'],
        absProfilePicture: json['absProfilePicture'],
        designation: json['designation'],
        department: json['department'],
        // category: json['category'],
        // subCategory: json['subCategory'],
        // shiftScheme: json['shiftScheme'],
        company: json['company'],
        // religionName: json['religionName'],
        // countryId: json['countryId'],
        // poBox: json['poBox'],
        // cityId: json['cityId'],
        // stateId: json['stateId'],
        zipCode: json['zipCode'],
        // permanentCityId: json['PermanentCityId'],
        // permanentStateId: json['PermanentStateId'],
        // permanentZipCode: json['PermanentZipCode'],
        // permanentCountryId: json['PermanentCountryId'],
        // employeeCompanyId: json['employeeCompanyId'],
        code: json['code']?.toString(),
        // departmentId: json['departmentId'],
        // locationId: json['locationId'],
        // categoryId: json['categoryId'],
        // subCategoryId: json['subCategoryId'],
        // designationId: json['designationId'],
        probationPeriod: json['probationPeriod'],
        probationEndDate: json['probationEndDate'],
        // noticePeriod: json['noticePeriod'],
        // shiftSchemeId: json['shiftSchemeId'],
        joiningDate: json['joiningDate'],
        // timeInOutPolicy: json['timeInOutPolicy'],
        // overtimePolicy: json['overtimePolicy'],
        // shortTimePolicy: json['shortTimePolicy'],
        // missPunchPolicy: json['missPunchPolicy'],
        // salaryPolicy: json['salaryPolicy'],
        // reportsTo: json['reportsTo'],
        // holidayPolicy: json['holidayPolicy'],
        // punchIdentifier: json['punchIdentifier'],
        // location: json['location'],
        countryName: json['countryName'],
        stateName: json['stateName'],
        city: json['city'],
        // permanentCountry: json['permanentCountry'],
        // permanentState: json['permanentState'],
        // permanentCity: json['permanentCity'],
        organisationId: json['organisationId']?.toString(),
        // employeeAddressId: json['employeeAddressId'],
        // workPolicyId: json['workPolicyId'],
        salaryAccess: json['salaryAccess'],
        workEntryAccess: json['workEntryAccess'],
        airTicketAccess: json['airTicketAccess'],
        taskAccess: json['taskAccess'],
        breakAccess: json['breakAccess'],
        expenseReimbursement: json['expenseReimbursement'],
        isAllowFields: json['isAllowFields'],
        // employeeLeaves: List<EmployeeLeaves>.from(
        //     json['employeeLeaves'].map((x) => EmployeeLeaves.fromJson(x))),
        employeeShift: List<ShiftData>.from(
            json['employeeShift'].map((x) => ShiftData.fromJson(x))),
      );
}

class EmployeeLeaves {
  String? leaveTypeId;
  String? leaveType;

  EmployeeLeaves({this.leaveTypeId, this.leaveType});

  factory EmployeeLeaves.fromJson(Map<String, dynamic> json) => EmployeeLeaves(
        leaveTypeId: json['leaveTypeId'],
        leaveType: json['leaveType'],
      );
}

class ShiftData {
  // final String employeeId;
  // final String shiftId;
  final String shift;
  // final String startTime;
  // final String endTime;
  final String? shiftTimeRemarks;

  const ShiftData({
    // required this.employeeId,
    // required this.shiftId,
    required this.shift,
    // required this.startTime,
    // required this.endTime,
    this.shiftTimeRemarks,
  });

  factory ShiftData.fromJson(Map<String, dynamic> json) => ShiftData(
      // employeeId: json['employeeId'],
      // shiftId: json['shiftId'],
      shift: json['shift'],
      // startTime: json['startTime'],
      // endTime: json['endTime'],
      shiftTimeRemarks: json['shiftTimeRemarks']);
}

UserProfileApiModel userProfileAPI = UserProfileApiModel(
    status: 0, message: "Error", errors: [], result: userProfile);

UserProfile userProfile = UserProfile(
  employeeId: null,
  companyId: null,
  firstName: null,
  employeeName: null,
  middleName: null,
  lastName: null,
  nickName: null,
  dateOfBirth: null,
  gender: null,
  // religionId: null,
  // bloodGroup: null,
  // isActive: null,
  // createdBy: null,
  // createdOn: null,
  // modifiedBy: null,
  // modifiedOn: null,
  phone: null,
  email: null,
  profilePicture: null,
  // address: null,
  // permanentAddress: null,
  // timeInOutPolicyName: null,
  // overTimePolicyName: null,
  // shortTimePolicyName: null,
  // missPunchPolicyName: null,
  designation: null,
  department: null,
  // category: null,
  // subCategory: null,
  // shiftScheme: null,
  company: null,
  // religionName: null,
  // countryId: null,
  // poBox: null,
  // cityId: null,
  // stateId: null,
  zipCode: null,
  // permanentCityId: null,
  // permanentStateId: null,
  // permanentZipCode: null,
  // permanentCountryId: null,
  // employeeCompanyId: null,
  // code: null,
  // departmentId: null,
  // locationId: null,
  // categoryId: null,
  // subCategoryId: null,
  // designationId: null,
  probationPeriod: null,
  probationEndDate: null,
  // noticePeriod: null,
  // shiftSchemeId: null,
  joiningDate: null,
  // timeInOutPolicy: null,
  // overtimePolicy: null,
  // shortTimePolicy: null,
  // missPunchPolicy: null,
  // salaryPolicy: null,
  // reportsTo: null,
  // holidayPolicy: null,
  // punchIdentifier: null,
  // location: null,
  countryName: null,
  stateName: null,
  city: null,
  // permanentCountry: null,
  // permanentState: null,
  // permanentCity: null,
  // organisationId: null,
  // employeeAddressId: null,
  // workPolicyId: null,
  // employeeLeaves: [],
  employeeShift: [],
);

class UserCompanyDetailsApi {
  int? status;
  String? message;
  List? errors;
  Result? result;

  UserCompanyDetailsApi({this.status, this.message, this.errors, this.result});

  UserCompanyDetailsApi.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    errors = json['errors'];
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['errors'] = errors;
    if (result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}

class Result {
  // int? companyId;
  // String? organisationId;
  // String? countryId;
  // String? company;
  // String? description;
  // String? logo;
  // String? url;
  // String? address;
  // String? country;
  // String? zipCode;
  // String? cin;
  // String? phone;
  // String? email;
  // int? isActive;
  // int? createdBy;
  // String? createdOn;
  // String? modifiedBy;
  // String? modifiedOn;
  // String? fileType;
  // String? stateId;
  // String? cityId;
  // String? groupId;
  // String? countryName;
  String? currency;
  // String? isPFESIenabled;
  // String? stateName;
  // String? cityName;

  Result({
    // this.companyId,
    // this.organisationId,
    // this.countryId,
    // this.company,
    // this.description,
    // this.logo,
    // this.url,
    // this.address,
    // this.country,
    // this.zipCode,
    // this.cin,
    // this.phone,
    // this.email,
    // this.isActive,
    // this.createdBy,
    // this.createdOn,
    // this.modifiedBy,
    // this.modifiedOn,
    // this.fileType,
    // this.stateId,
    // this.cityId,
    // this.groupId,
    // this.countryName,
    this.currency,
    // this.isPFESIenabled,
    // this.stateName,
    // this.cityName,
  });

  Result.fromJson(Map<String, dynamic> json) {
    // companyId = json['companyId'];
    // organisationId = json['organisationId'];
    // countryId = json['countryId'];
    // company = json['company'];
    // description = json['description'];
    // logo = json['logo'];
    // url = json['url'];
    // address = json['address'];
    // country = json['country'];
    // zipCode = json['zipCode'];
    // cin = json['cin'];
    // phone = json['phone'];
    // email = json['email'];
    // isActive = json['isActive'];
    // createdBy = json['createdBy'];
    // createdOn = json['createdOn'];
    // modifiedBy = json['modifiedBy'];
    // modifiedOn = json['modifiedOn'];
    // fileType = json['fileType'];
    // stateId = json['stateId'];
    // cityId = json['cityId'];
    // groupId = json['groupId'];
    // countryName = json['countryName'];
    currency = json['currency'];
    // isPFESIenabled = json['isPFESIenabled'];
    // stateName = json['stateName'];
    // cityName = json['cityName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // data['companyId'] = companyId;
    // data['organisationId'] = organisationId;
    // data['countryId'] = countryId;
    // data['company'] = company;
    // data['description'] = description;
    // data['logo'] = logo;
    // data['url'] = url;
    // data['address'] = address;
    // data['country'] = country;
    // data['zipCode'] = zipCode;
    // data['cin'] = cin;
    // data['phone'] = phone;
    // data['email'] = email;
    // data['isActive'] = isActive;
    // data['createdBy'] = createdBy;
    // data['createdOn'] = createdOn;
    // data['modifiedBy'] = modifiedBy;
    // data['modifiedOn'] = modifiedOn;
    // data['fileType'] = fileType;
    // data['stateId'] = stateId;
    // data['cityId'] = cityId;
    // data['groupId'] = groupId;
    // data['countryName'] = countryName;
    data['currency'] = currency;
    // data['isPFESIenabled'] = isPFESIenabled;
    // data['stateName'] = stateName;
    // data['cityName'] = cityName;
    return data;
  }
}


class EmployeeDocumentsApi {
  int? status;
  String? message;
  List<EmployeeDocument>? result;

  EmployeeDocumentsApi({this.status, this.message, this.result});

  EmployeeDocumentsApi.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['result'] != null) {
      result = <EmployeeDocument>[];
      json['result'].forEach((v) {
        result!.add(new EmployeeDocument.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EmployeeDocument {
  String? employeeDocumentId;
  String? fileName;
  String? documentName;
  String? isActive;
  String? documentTypeId;
  String? documentType;
  String? isUnderWarranty;
  String? validTo;
  String? description;
  String? status;
  String? statusColor;

  EmployeeDocument(
      {this.employeeDocumentId,
        this.fileName,
        this.documentName,
        this.isActive,
        this.documentTypeId,
        this.documentType,
        this.isUnderWarranty,
        this.validTo,
        this.description,
        this.status,
        this.statusColor});

  EmployeeDocument.fromJson(Map<String, dynamic> json) {
    employeeDocumentId = json['employeeDocumentId'];
    fileName = json['fileName'];
    documentName = json['documentName'];
    isActive = json['isActive'];
    documentTypeId = json['documentTypeId'];
    documentType = json['documentType'];
    isUnderWarranty = json['isUnderWarranty'];
    validTo = json['validTo'];
    description = json['description'];
    status = json['status'];
    statusColor = json['statusColor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employeeDocumentId'] = this.employeeDocumentId;
    data['fileName'] = this.fileName;
    data['documentName'] = this.documentName;
    data['isActive'] = this.isActive;
    data['documentTypeId'] = this.documentTypeId;
    data['documentType'] = this.documentType;
    data['isUnderWarranty'] = this.isUnderWarranty;
    data['validTo'] = this.validTo;
    data['description'] = this.description;
    data['status'] = this.status;
    data['statusColor'] = this.statusColor;
    return data;
  }
}

class EmployeeAssetsApi {
  bool? status;
  String? message;
  List<EmployeeAsset>? data;

  EmployeeAssetsApi({this.status, this.message, this.data});

  EmployeeAssetsApi.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <EmployeeAsset>[];
      json['data'].forEach((v) {
        data!.add(new EmployeeAsset.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EmployeeAsset {
  String? assetAssignmentId;
  String? companyAssetId;
  String? assigningEmployeeId;
  String? actionType;
  String? assetCondition;
  String? image;
  String? agreementEnabled;
  // Null? isAgreementAgreed;
  String? agreedDate;
  // Null? agreementType;
  // Null? agreementFile;
  // Null? returnCondition;
  // Null? notAvailableReason;
  // Null? returnDate;
  // Null? note;
  String? isActive;
  String? createdBy;
  String? createdOn;
  // Null? modifiedBy;
  String? modifiedOn;
  String? returnStatus;
  String? assigningDate;
  // Null? returnnote;
  // Null? returnImage;
  String? model;
  String? serialNo;
  // Null? warranty;
  String? uniqId;
  String? description;
  String? assetNumber;
  String? assetTypeName;
  String? assignedEmployeeId;
  String? firstName;
  String? lastName;
  String? profilePicture;
  String? code;
  String? employeeName;

  EmployeeAsset(
      {this.assetAssignmentId,
        this.companyAssetId,
        this.assigningEmployeeId,
        this.actionType,
        this.assetCondition,
        this.image,
        this.agreementEnabled,
        // this.isAgreementAgreed,
        this.agreedDate,
        // this.agreementType,
        // this.agreementFile,
        // this.returnCondition,
        // this.notAvailableReason,
        // this.returnDate,
        // this.note,
        this.isActive,
        this.createdBy,
        this.createdOn,
        // this.modifiedBy,
        this.modifiedOn,
        this.returnStatus,
        this.assigningDate,
        // this.returnnote,
        // this.returnImage,
        this.model,
        this.serialNo,
        // this.warranty,
        this.uniqId,
        this.description,
        this.assetNumber,
        this.assetTypeName,
        this.assignedEmployeeId,
        this.firstName,
        this.lastName,
        this.profilePicture,
        this.code,
        this.employeeName});

  EmployeeAsset.fromJson(Map<String, dynamic> json) {
    assetAssignmentId = json['assetAssignmentId'];
    companyAssetId = json['companyAssetId'];
    assigningEmployeeId = json['assigningEmployeeId'];
    actionType = json['actionType'];
    assetCondition = json['assetCondition'];
    image = json['image'];
    agreementEnabled = json['agreementEnabled'];
    // isAgreementAgreed = json['isAgreementAgreed'];
    agreedDate = json['AgreedDate'];
    // agreementType = json['agreementType'];
    // agreementFile = json['agreementFile'];
    // returnCondition = json['returnCondition'];
    // notAvailableReason = json['notAvailableReason'];
    // returnDate = json['returnDate'];
    // note = json['note'];
    isActive = json['isActive'];
    createdBy = json['createdBy'];
    createdOn = json['createdOn'];
    // modifiedBy = json['modifiedBy'];
    modifiedOn = json['modifiedOn'];
    returnStatus = json['returnStatus'];
    assigningDate = json['assigningDate'];
    // returnnote = json['returnnote'];
    // returnImage = json['returnImage'];
    model = json['model'];
    serialNo = json['serialNo'];
    // warranty = json['warranty'];
    uniqId = json['uniqId'];
    description = json['Description'];
    assetNumber = json['assetNumber'];
    assetTypeName = json['assetTypeName'];
    assignedEmployeeId = json['assignedEmployeeId'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    profilePicture = json['profilePicture'];
    code = json['code'];
    employeeName = json['employeeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['assetAssignmentId'] = this.assetAssignmentId;
    data['companyAssetId'] = this.companyAssetId;
    data['assigningEmployeeId'] = this.assigningEmployeeId;
    data['actionType'] = this.actionType;
    data['assetCondition'] = this.assetCondition;
    data['image'] = this.image;
    data['agreementEnabled'] = this.agreementEnabled;
    // data['isAgreementAgreed'] = this.isAgreementAgreed;
    data['AgreedDate'] = this.agreedDate;
    // data['agreementType'] = this.agreementType;
    // data['agreementFile'] = this.agreementFile;
    // data['returnCondition'] = this.returnCondition;
    // data['notAvailableReason'] = this.notAvailableReason;
    // data['returnDate'] = this.returnDate;
    // data['note'] = this.note;
    data['isActive'] = this.isActive;
    data['createdBy'] = this.createdBy;
    data['createdOn'] = this.createdOn;
    // data['modifiedBy'] = this.modifiedBy;
    data['modifiedOn'] = this.modifiedOn;
    data['returnStatus'] = this.returnStatus;
    data['assigningDate'] = this.assigningDate;
    // data['returnnote'] = this.returnnote;
    // data['returnImage'] = this.returnImage;
    data['model'] = this.model;
    data['serialNo'] = this.serialNo;
    // data['warranty'] = this.warranty;
    data['uniqId'] = this.uniqId;
    data['Description'] = this.description;
    data['assetNumber'] = this.assetNumber;
    data['assetTypeName'] = this.assetTypeName;
    data['assignedEmployeeId'] = this.assignedEmployeeId;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['profilePicture'] = this.profilePicture;
    data['code'] = this.code;
    data['employeeName'] = this.employeeName;
    return data;
  }
}

class DocumentAdd {
  int? employeeId;
  int? companyId;
  int? documentTypeId;
  String? filename;
  String? file;
  String? description;
  int? isUnderWarranty;
  int? countryId;
  String? issuedOn;
  String? validFrom;
  String? validTo;
  String? expiresOn;
  int? isRenewal;

  DocumentAdd({
        this.employeeId,
        this.companyId,
        this.documentTypeId,
        this.filename,
        this.file,
        this.description,
        this.isUnderWarranty,
        this.countryId,
        this.issuedOn,
        this.validFrom,
        this.validTo,
        this.expiresOn,
        this.isRenewal});

  DocumentAdd.fromJson(Map<String, dynamic> json) {
    employeeId = json['employeeId'];
    companyId = json['companyId'];
    documentTypeId = json['documentTypeId'];
    filename = json['filename'];
    file = json['file'];
    description = json['description'];
    isUnderWarranty = json['isUnderWarranty'];
    countryId = json['countryId'];
    issuedOn = json['issuedOn'];
    validFrom = json['validFrom'];
    validTo = json['validTo'];
    expiresOn = json['expiresOn'];
    isRenewal = json['isRenewal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employeeId'] = this.employeeId;
    data['companyId'] = this.companyId;
    data['documentTypeId'] = this.documentTypeId;
    data['filename'] = this.filename;
    data['file'] = this.file;
    data['description'] = this.description;
    data['isUnderWarranty'] = this.isUnderWarranty;
    data['countryId'] = this.countryId;
    data['issuedOn'] = this.issuedOn;
    data['validFrom'] = this.validFrom;
    data['validTo'] = this.validTo;
    data['expiresOn'] = this.expiresOn;
    data['isRenewal'] = this.isRenewal;
    return data;
  }
}

class DocumentTypeApi {
  int? status;
  String? message;
  List<DocumentType>? result;

  DocumentTypeApi({this.status, this.message, this.result});

  DocumentTypeApi.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['result'] != null) {
      result = <DocumentType>[];
      json['result'].forEach((v) {
        result!.add(DocumentType.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DocumentType {
  int? documentTypeId;
  String? companyId;
  String? documentType;
  String? description;
  String? mandatoryType;
  String? expiryReminders;
  int? isActive;
  int? createdBy;
  String? createdOn;
  String? modifiedBy;
  String? modifiedOn;

  DocumentType(
      {this.documentTypeId,
        this.companyId,
        this.documentType,
        this.description,
        this.mandatoryType,
        this.expiryReminders,
        this.isActive,
        this.createdBy,
        this.createdOn,
        this.modifiedBy,
        this.modifiedOn});

  DocumentType.fromJson(Map<String, dynamic> json) {
    documentTypeId = json['documentTypeId'];
    companyId = json['companyId'];
    documentType = json['documentType'];
    if(json['documentType'] != null && json['documentTypeId']?.toString() != null) {
      documentType = "${json['documentType']}<#>${json['documentTypeId']}";
    }
    description = json['description'];
    mandatoryType = json['mandatoryType'];
    expiryReminders = json['expiryReminders'];
    isActive = json['isActive'];
    createdBy = json['createdBy'];
    createdOn = json['createdOn'];
    modifiedBy = json['modifiedBy'];
    modifiedOn = json['modifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['documentTypeId'] = this.documentTypeId;
    data['companyId'] = this.companyId;
    data['documentType'] = this.documentType;
    data['description'] = this.description;
    data['mandatoryType'] = this.mandatoryType;
    data['expiryReminders'] = this.expiryReminders;
    data['isActive'] = this.isActive;
    data['createdBy'] = this.createdBy;
    data['createdOn'] = this.createdOn;
    data['modifiedBy'] = this.modifiedBy;
    data['modifiedOn'] = this.modifiedOn;
    return data;
  }
}

class CountryStateCityApi {
  int? status;
  String? message;
  List<CountryData>? result;

  CountryStateCityApi({this.status, this.message, this.result});

  CountryStateCityApi.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['result'] != null) {
      result = <CountryData>[];
      json['result'].forEach((v) {
        result!.add(CountryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CountryData {
  String? countryId;
  String? countryName;
  String? countryCode;
  List<StateData>? stateData;

  CountryData({this.countryId, this.countryName, this.countryCode, this.stateData});

  CountryData.fromJson(Map<String, dynamic> json) {
    countryId = json['countryId'];
    countryName = json['countryName'];
    if(json['countryName'] != null && json['countryId']?.toString() !=null) {
      countryName = "${json['countryName']}<#>${json['countryId']?.toString()}";
    }
    countryCode = json['countryCode'];
    if (json['stateData'] != null) {
      stateData = <StateData>[];
      json['stateData'].forEach((v) {
        stateData!.add(new StateData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['countryId'] = this.countryId;
    data['countryName'] = this.countryName;
    data['countryCode'] = this.countryCode;
    if (this.stateData != null) {
      data['stateData'] = this.stateData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StateData {
  String? stateId;
  String? stateName;
  List<CityData>? cityData;

  StateData({this.stateId, this.stateName, this.cityData});

  StateData.fromJson(Map<String, dynamic> json) {
    stateId = json['stateId'];
    stateName = json['stateName'];
    if (json['cityData'] != null) {
      cityData = <CityData>[];
      json['cityData'].forEach((v) {
        cityData!.add(new CityData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stateId'] = this.stateId;
    data['stateName'] = this.stateName;
    if (this.cityData != null) {
      data['cityData'] = this.cityData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CityData {
  String? cityId;
  String? city;

  CityData({this.cityId, this.city});

  CityData.fromJson(Map<String, dynamic> json) {
    cityId = json['cityId'];
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cityId'] = this.cityId;
    data['city'] = this.city;
    return data;
  }
}