class LeaveTypeAPI {
  int? status;
  String? message;
  // List<dynamic>? errors;
  List<LeaveType>? result;

  LeaveTypeAPI({this.status, this.message, this.result});

  LeaveTypeAPI.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    // errors = json['errors'];
    if (json['result'] != null) {
      result = <LeaveType>[];
      json['result'].forEach((v) {
        result!.add(LeaveType.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    // data['errors'] = errors;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LeaveType {
  String? leaveTypeId;
  String? basicLeaveType;
  String? leaveType;
  String? isHourBased;
  String? totalLeave;
  // String? employeeId;
  // String? companyId;
  int? leaveApplied;
  String? maximumLeaveLimit;
  String? leaveBalance;
  String? currBalance;
  String? afterDeduction; // added for attendance regularize bottom sheet ui
  bool? hideLeaveBalance;
  // dynamic isRestrictedHoliday;
  // String? leaveLimitPer;
  // int? isAnnualy;
  // int? isHalfYearly;
  // int? isQuarterly;
  // int? isMonthly;
  // List<LeavePerMonth>? leavePerMonth;
  // int? leaveApproved;

  LeaveType(
      {this.leaveTypeId,
        this.basicLeaveType,
        this.leaveType,
        this.isHourBased,
        this.totalLeave,
        // this.employeeId,
        // this.companyId,
        this.leaveApplied,
        this.maximumLeaveLimit,
        this.leaveBalance,
        this.currBalance,
        this.afterDeduction,
        this.hideLeaveBalance,
        // this.isRestrictedHoliday,
        // this.leaveLimitPer,
        // this.isAnnualy,
        // this.isHalfYearly,
        // this.isQuarterly,
        // this.isMonthly,
        // this.leavePerMonth,
        // this.leaveApproved,
      });

  LeaveType.fromJson(Map<String, dynamic> json) {
    leaveTypeId = json['leaveTypeId'];
    basicLeaveType = json['basicLeaveType'].toString();
    leaveType = json['leaveType'];
    isHourBased = json['isHourBased'];
    totalLeave = json['totalLeave']?.toString();
    // employeeId = json['employeeId'];
    // companyId = json['companyId'];
    leaveApplied = json['leaveApplied'];
    maximumLeaveLimit = json['maximumLeaveLimit'];
    leaveBalance = json['leaveBalance']?.toString();
    currBalance = json['currBalance']?.toString();
    hideLeaveBalance = json['hideLeaveBalance'];
    // isRestrictedHoliday = json['isRestrictedHoliday'];
    // leaveLimitPer = json['leaveLimitPer'];
    // isAnnualy = json['isAnnualy'];
    // isHalfYearly = json['isHalfYearly'];
    // isQuarterly = json['isQuarterly'];
    // isMonthly = json['isMonthly'];
    // if (json['leavePerMonth'] != null) {
    //   leavePerMonth = <LeavePerMonth>[];
    //   json['leavePerMonth'].forEach((v) {
    //     leavePerMonth!.add(LeavePerMonth.fromJson(v));
    //   });
    // }
    // leaveApproved = json['leaveApproved'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['leaveTypeId'] = leaveTypeId;
    data['basicLeaveType'] = basicLeaveType;
    data['leaveType'] = leaveType;
    data['isHourBased'] = isHourBased;
    data['totalLeave'] = totalLeave;
    // data['employeeId'] = employeeId;
    // data['companyId'] = companyId;
    data['leaveApplied'] = leaveApplied;
    data['maximumLeaveLimit'] = maximumLeaveLimit;
    data['leaveBalance'] = leaveBalance;
    data['currBalance'] = currBalance;
    data['hideLeaveBalance'] = hideLeaveBalance;
    // data['isRestrictedHoliday'] = isRestrictedHoliday;
    // data['leaveLimitPer'] = leaveLimitPer;
    // data['isAnnualy'] = isAnnualy;
    // data['isHalfYearly'] = isHalfYearly;
    // data['isQuarterly'] = isQuarterly;
    // data['isMonthly'] = isMonthly;
    // if (leavePerMonth != null) {
    //   data['leavePerMonth'] =
    //       leavePerMonth!.map((v) => v.toJson()).toList();
    // }
    // data['leaveApproved'] = leaveApproved;
    return data;
  }
}

class LeavePerMonth {
  String? leaveMonth;
  String? leavecount;
  int? leaveApplied;
  String? leaveTaken;
  String? leaveBalance;

  LeavePerMonth(
      {this.leaveMonth,
        this.leavecount,
        this.leaveApplied,
        this.leaveTaken,
        this.leaveBalance});

  LeavePerMonth.fromJson(Map<String, dynamic> json) {
    leaveMonth = json['leaveMonth'];
    leavecount = json['leavecount'];
    leaveApplied = json['leaveApplied'];
    leaveTaken = json['leaveTaken'];
    leaveBalance = json['leaveBalance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['leaveMonth'] = leaveMonth;
    data['leavecount'] = leavecount;
    data['leaveApplied'] = leaveApplied;
    data['leaveTaken'] = leaveTaken;
    data['leaveBalance'] = leaveBalance;
    return data;
  }
}

class EmpLeaveDataApi {
  int? status;
  String? message;
  // List<Null>? errors;
  EmpLeaveData? result;

  EmpLeaveDataApi({this.status, this.message, this.result});

  EmpLeaveDataApi.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    // if (json['errors'] != null) {
    //   errors = <Null>[];
    //   json['errors'].forEach((v) {
    //     errors!.add(new Null.fromJson(v));
    //   });
    // }
    result =
    json['result'] != null ? new EmpLeaveData.fromJson(json['result']) : null;
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

class EmpLeaveData {
  String? leaveApplied;
  String? leaveBalance;
  String? leaveApproved;
  String? totalLeave;

  EmpLeaveData(
      {this.leaveApplied,
        this.leaveBalance,
        this.leaveApproved,
        this.totalLeave});

  EmpLeaveData.fromJson(Map<String, dynamic> json) {
    leaveApplied = json['leaveApplied']?.toString();
    leaveBalance = json['leaveBalance']?.toString();
    leaveApproved = json['leaveApproved']?.toString();
    totalLeave = json['totalLeave']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['leaveApplied'] = this.leaveApplied;
    data['leaveBalance'] = this.leaveBalance;
    data['leaveApproved'] = this.leaveApproved;
    data['totalLeave'] = this.totalLeave;
    return data;
  }
}

