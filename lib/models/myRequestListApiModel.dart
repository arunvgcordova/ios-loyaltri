class SpecialRequestListApi {
  int? status;
  String? message;
  List<RequestData>? result;

  SpecialRequestListApi({this.status, this.message, this.result});

  SpecialRequestListApi.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['result'] != null) {
      result = <RequestData>[];
      json['result'].forEach((v) {
        result!.add(new RequestData.fromJson(v));
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

class RequestData {
  String? specialRequestType;
  String? requestLetterType;
  String? requestStatus;
  String? fromDate;
  String? toDate;
  String? requestDescription;
  String? specialRequestId;
  String? requestedShift;
  String? specialRequestTypeId;
  List<List<StepItem>>? track;
  List<String>? approvedDocument;

  RequestData({
    this.specialRequestType,
    this.requestLetterType,
    this.requestStatus,
    this.fromDate,
    this.toDate,
    this.requestDescription,
    this.specialRequestId,
    this.requestedShift,
    this.specialRequestTypeId,
    this.track,
    this.approvedDocument,
  });

  RequestData.fromJson(Map<String, dynamic> json) {
    specialRequestType = json['specialRequestType'];
    requestLetterType = json['requestLetterType'];
    requestStatus = json['requestStatus'];
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    requestDescription = json['requestDescription'];
    specialRequestId = json['specialRequestId'];
    requestedShift = json['requestedShift'];
    specialRequestTypeId = json['specialRequestTypeId']?.toString();
    track = [];
    List<String> stepList = [];
    if (json['track'] != null && (json['track'] is Map<String, dynamic>)) {
      stepList = (json['track'] as Map<String, dynamic>).keys.toList();
      for (String step in stepList) {
        var stepData = json['track'][step] as List;
        track?.add(stepData.map((e) => StepItem.fromJson(e)).toList());
      }
    }

    approvedDocument = json['approvedDocument'] is List
        ? (json['approvedDocument'] as List)
        .where((item) => item != null)
        .map((item) => item.toString())
        .toList()
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['specialRequestType'] = this.specialRequestType;
    data['requestLetterType'] = this.requestLetterType;
    data['requestStatus'] = this.requestStatus;
    data['fromDate'] = this.fromDate;
    data['toDate'] = this.toDate;
    data['requestDescription'] = this.requestDescription;
    data['specialRequestId'] = this.specialRequestId;
    data['requestedShift'] = this.requestedShift;
    data['specialRequestTypeId'] = this.specialRequestTypeId;
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
    data['approvedDocument'] = this.approvedDocument;
    return data;
  }
}

class ResignationReasonApi {
  int? status;
  String? message;
  List<String>? result;

  ResignationReasonApi({this.status, this.message, this.result});

  ResignationReasonApi.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    result = json['result'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['result'] = this.result;
    return data;
  }
}

class LeaveTypesApi {
  int? status;
  String? message;
  List<LeaveType>? result;

  LeaveTypesApi({this.status, this.message, this.result});

  LeaveTypesApi.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['result'] != null) {
      result = <LeaveType>[];
      json['result'].forEach((v) {
        result!.add(new LeaveType.fromJson(v));
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

class LeaveType {
  int? leaveTypeId;
  String? companyId;
  String? leaveType;
  // Null? categoryId;
  String? leaveName;
  String? description;
  String? leaveCount;
  String? maxLeaveLimit;
  String? leaveLimitPer;
  String? leaveDaysType;
  String? isAnnualleave;
  String? isProrata;
  String? isProrataProbationIncluded;
  // Null? leavePaytype;
  // Null? leaveDays;
  String? isProbationRestricted;
  // Null? leaveRules;
  int? isActive;
  String? createdOn;
  // Null? modifiedBy;
  String? modifiedOn;
  // Null? maxlimit;
  // Null? leavePaidRules;
  int? createdBy;
  String? colourCode;
  String? basicLeaveType;
  String? isRestrictedHoliday;
  String? carryOverPaidLeaveAllowanceEachCycle;
  String? isHourBased;
  // Null? leaveCalculationType;
  // Null? leaveLengthRestriction;
  // Null? maximumLeaveToCarryOver;
  String? quota;
  String? quotaLimit;
  // Null? timeOfAllowance;
  // Null? waitingPeriod;
  // Null? useCurrentBalanceFutureMonths;

  LeaveType({
    this.leaveTypeId,
    this.companyId,
    this.leaveType,
    // this.categoryId,
    this.leaveName,
    this.description,
    this.leaveCount,
    this.maxLeaveLimit,
    this.leaveLimitPer,
    this.leaveDaysType,
    this.isAnnualleave,
    this.isProrata,
    this.isProrataProbationIncluded,
    // this.leavePaytype,
    // this.leaveDays,
    this.isProbationRestricted,
    // this.leaveRules,
    this.isActive,
    this.createdOn,
    // this.modifiedBy,
    this.modifiedOn,
    // this.maxlimit,
    // this.leavePaidRules,
    this.createdBy,
    this.colourCode,
    this.basicLeaveType,
    this.isRestrictedHoliday,
    this.carryOverPaidLeaveAllowanceEachCycle,
    this.isHourBased,
    // this.leaveCalculationType,
    // this.leaveLengthRestriction,
    // this.maximumLeaveToCarryOver,
    this.quota,
    this.quotaLimit,
    // this.timeOfAllowance,
    // this.waitingPeriod,
    // this.useCurrentBalanceFutureMonths,
  });

  LeaveType.fromJson(Map<String, dynamic> json) {
    leaveTypeId = json['leaveTypeId'];
    companyId = json['companyId'];
    leaveType = json['leaveType'];
    // categoryId = json['categoryId'];
    leaveName = json['leaveName'];
    description = json['description'];
    leaveCount = json['leaveCount'];
    maxLeaveLimit = json['maxLeaveLimit'];
    leaveLimitPer = json['leaveLimitPer'];
    leaveDaysType = json['leaveDaysType'];
    isAnnualleave = json['isAnnualleave'];
    isProrata = json['isProrata'];
    isProrataProbationIncluded = json['isProrataProbationIncluded'];
    // leavePaytype = json['leavePaytype'];
    // leaveDays = json['leaveDays'];
    isProbationRestricted = json['isProbationRestricted'];
    // leaveRules = json['leaveRules'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    // modifiedBy = json['modifiedBy'];
    modifiedOn = json['modifiedOn'];
    // maxlimit = json['maxlimit'];
    // leavePaidRules = json['leavePaidRules'];
    createdBy = json['createdBy'];
    colourCode = json['colourCode'];
    basicLeaveType = json['basicLeaveType'];
    isRestrictedHoliday = json['isRestrictedHoliday'];
    carryOverPaidLeaveAllowanceEachCycle =
        json['carryOverPaidLeaveAllowanceEachCycle'];
    isHourBased = json['isHourBased'];
    // leaveCalculationType = json['leaveCalculationType'];
    // leaveLengthRestriction = json['leaveLengthRestriction'];
    // maximumLeaveToCarryOver = json['maximumLeaveToCarryOver'];
    quota = json['quota'];
    quotaLimit = json['quotaLimit'];
    // timeOfAllowance = json['timeOfAllowance'];
    // waitingPeriod = json['waitingPeriod'];
    // useCurrentBalanceFutureMonths = json['useCurrentBalanceFutureMonths'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['leaveTypeId'] = this.leaveTypeId;
    data['companyId'] = this.companyId;
    data['leaveType'] = this.leaveType;
    // data['categoryId'] = this.categoryId;
    data['leaveName'] = this.leaveName;
    data['description'] = this.description;
    data['leaveCount'] = this.leaveCount;
    data['maxLeaveLimit'] = this.maxLeaveLimit;
    data['leaveLimitPer'] = this.leaveLimitPer;
    data['leaveDaysType'] = this.leaveDaysType;
    data['isAnnualleave'] = this.isAnnualleave;
    data['isProrata'] = this.isProrata;
    data['isProrataProbationIncluded'] = this.isProrataProbationIncluded;
    // data['leavePaytype'] = this.leavePaytype;
    // data['leaveDays'] = this.leaveDays;
    data['isProbationRestricted'] = this.isProbationRestricted;
    // data['leaveRules'] = this.leaveRules;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    // data['modifiedBy'] = this.modifiedBy;
    data['modifiedOn'] = this.modifiedOn;
    // data['maxlimit'] = this.maxlimit;
    // data['leavePaidRules'] = this.leavePaidRules;
    data['createdBy'] = this.createdBy;
    data['colourCode'] = this.colourCode;
    data['basicLeaveType'] = this.basicLeaveType;
    data['isRestrictedHoliday'] = this.isRestrictedHoliday;
    data['carryOverPaidLeaveAllowanceEachCycle'] =
        this.carryOverPaidLeaveAllowanceEachCycle;
    data['isHourBased'] = this.isHourBased;
    // data['leaveCalculationType'] = this.leaveCalculationType;
    // data['leaveLengthRestriction'] = this.leaveLengthRestriction;
    // data['maximumLeaveToCarryOver'] = this.maximumLeaveToCarryOver;
    data['quota'] = this.quota;
    data['quotaLimit'] = this.quotaLimit;
    // data['timeOfAllowance'] = this.timeOfAllowance;
    // data['waitingPeriod'] = this.waitingPeriod;
    // data['useCurrentBalanceFutureMonths'] = this.useCurrentBalanceFutureMonths;
    return data;
  }
}

class LoanPoliciesApi {
  int? status;
  String? message;
  List<LoanPolicy>? result;

  LoanPoliciesApi({this.status, this.message, this.result});

  LoanPoliciesApi.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['result'] != null) {
      result = <LoanPolicy>[];
      json['result'].forEach((v) {
        result!.add(new LoanPolicy.fromJson(v));
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

class LoanPolicy {
  int? loanPolicyId;
  String? companyId;
  String? loanPolicyName;
  String? description;
  String? minimumJobTenure;
  String? amountType;
  String? maximumValue;
  String? minimumValue;
  String? repaymentType;
  String? repaymentTenure;
  String? loanAgreementFile;
  int? isActive;
  int? createdBy;
  String? createdOn;
  String? modifiedBy;
  String? modifiedOn;

  LoanPolicy(
      {this.loanPolicyId,
        this.companyId,
        this.loanPolicyName,
        this.description,
        this.minimumJobTenure,
        this.amountType,
        this.maximumValue,
        this.minimumValue,
        this.repaymentType,
        this.repaymentTenure,
        this.loanAgreementFile,
        this.isActive,
        this.createdBy,
        this.createdOn,
        this.modifiedBy,
        this.modifiedOn});

  LoanPolicy.fromJson(Map<String, dynamic> json) {
    loanPolicyId = json['loanPolicyId'];
    companyId = json['companyId'];
    loanPolicyName = json['loanPolicyName'];
    description = json['description'];
    minimumJobTenure = json['minimumJobTenure'];
    amountType = json['AmountType'];
    maximumValue = json['maximumValue'];
    minimumValue = json['minimumValue'];
    repaymentType = json['repaymentType'];
    repaymentTenure = json['repaymentTenure'];
    loanAgreementFile = json['loanAgreementFile'];
    isActive = json['isActive'];
    createdBy = json['createdBy'];
    createdOn = json['createdOn'];
    modifiedBy = json['modifiedBy'];
    modifiedOn = json['modifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['loanPolicyId'] = this.loanPolicyId;
    data['companyId'] = this.companyId;
    data['loanPolicyName'] = this.loanPolicyName;
    data['description'] = this.description;
    data['minimumJobTenure'] = this.minimumJobTenure;
    data['AmountType'] = this.amountType;
    data['maximumValue'] = this.maximumValue;
    data['minimumValue'] = this.minimumValue;
    data['repaymentType'] = this.repaymentType;
    data['repaymentTenure'] = this.repaymentTenure;
    data['loanAgreementFile'] = this.loanAgreementFile;
    data['isActive'] = this.isActive;
    data['createdBy'] = this.createdBy;
    data['createdOn'] = this.createdOn;
    data['modifiedBy'] = this.modifiedBy;
    data['modifiedOn'] = this.modifiedOn;
    return data;
  }
}

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