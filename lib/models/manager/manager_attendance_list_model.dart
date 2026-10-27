class ManagerAttendanceListData {
  int? status;
  String? message;
  // List<Null>? errors;
  List<ManagerEmployeeData>? result;

  ManagerAttendanceListData(
      {this.status, this.message, this.result});

  ManagerAttendanceListData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    // if (json['errors'] != null) {
    //   errors = <Null>[];
    //   json['errors'].forEach((v) {
    //     errors!.add(new Null.fromJson(v));
    //   });
    // }
    if (json['result'] != null) {
      result = <ManagerEmployeeData>[];
      json['result'].forEach((v) {
        result!.add(new ManagerEmployeeData.fromJson(v));
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

class ManagerEmployeeData {
  String? code;
  String? designation;
  int? employeeDailyAttendanceId;
  int? employeeId;
  int? employeeCompanyId;
  String? date;
  int? shiftId;
  String? firstCheckInTime;
  String? lastCheckOutTime;
  String? totalWorkHours;
  // Null? dutyType;
  int? isRegularizationNeeded;
  int? excuseType;
  int? isActive;
  int? createdBy;
  String? createdOn;
  int? modifiedBy;
  String? modifiedOn;
  int? companyId;
  String? isHoliday;
  String? isOffDay;
  int? isLeave;
  int? isExcused;
  String? status;
  String? leaveTypeId;
  String? description;
  String? isFine;
  String? isPunchApproved;
  // Null? leaveSession;
  String? isHalfDay;
  String? isPaidLeave;
  String? hasOverTime;
  String? isShuffle;
  String? leaveReason;
  String? presentShiftCount;
  String? isDeductionCompleted;
  // Null? totalBreakHours;
  String? shifSchemeName;
  String? shiftSchemeType;
  String? shiftSchemeId;
  String? shiftName;
  String? shiftStartTime;
  String? allowBreaks;
  String? shiftBreakDuration;
  // Null? breakFrom;
  // Null? breakTo;
  String? shiftEndTime;
  String? shiftWorkHours;
  String? profilePicture;
  String? employeeName;
  // Null? employeeOvertimeDataId;
  String? extraHours;
  // Null? overtimeStatus;
  String? department;
  String? departmentId;
  String? category;
  String? categoryId;
  String? location;
  String? locationId;
  // Null? subCategory;
  // Null? subCategoryId;
  int? isLeaveAppliedHalfDay;
  int? isLeaveApplied;
  String? breakHours;
  String? hoursWorkedMessage;
  String? schedule;
  double? totalFineToRegularizeAmount;
  String? totalHoursToRegularize;
  int? isFineToRegularize;
  int? totalFinedAmount;
  String? totalFinedHours;
  int? finedCount;
  int? pardonedCount;
  int? requestsCount;
  bool? isOverTimeApproved;
  bool? isMissPunch;
  bool? isShortTime;
  bool? isEarlyExit;
  bool? isExcessBreak;
  bool? isOverTime;
  bool? isLateEntry;
  List<String>? punchType;
  // List<Null>? shiftData;

  ManagerEmployeeData(
      {this.code,
        this.designation,
        this.employeeDailyAttendanceId,
        this.employeeId,
        this.employeeCompanyId,
        this.date,
        this.shiftId,
        this.firstCheckInTime,
        this.lastCheckOutTime,
        this.totalWorkHours,
        // this.dutyType,
        this.isRegularizationNeeded,
        this.excuseType,
        this.isActive,
        this.createdBy,
        this.createdOn,
        this.modifiedBy,
        this.modifiedOn,
        this.companyId,
        this.isHoliday,
        this.isOffDay,
        this.isLeave,
        this.isExcused,
        this.status,
        this.leaveTypeId,
        this.description,
        this.isFine,
        this.isPunchApproved,
        // this.leaveSession,
        this.isHalfDay,
        this.isPaidLeave,
        this.hasOverTime,
        this.isShuffle,
        this.leaveReason,
        this.presentShiftCount,
        this.isDeductionCompleted,
        // this.totalBreakHours,
        this.shifSchemeName,
        this.shiftSchemeType,
        this.shiftSchemeId,
        this.shiftName,
        this.shiftStartTime,
        this.allowBreaks,
        this.shiftBreakDuration,
        // this.breakFrom,
        // this.breakTo,
        this.shiftEndTime,
        this.shiftWorkHours,
        this.profilePicture,
        this.employeeName,
        // this.employeeOvertimeDataId,
        this.extraHours,
        // this.overtimeStatus,
        this.department,
        this.departmentId,
        this.category,
        this.categoryId,
        this.location,
        this.locationId,
        // this.subCategory,
        // this.subCategoryId,
        this.isLeaveAppliedHalfDay,
        this.isLeaveApplied,
        this.breakHours,
        this.hoursWorkedMessage,
        this.schedule,
        this.totalFineToRegularizeAmount,
        this.totalHoursToRegularize,
        this.isFineToRegularize,
        this.totalFinedAmount,
        this.totalFinedHours,
        this.finedCount,
        this.pardonedCount,
        this.requestsCount,
        this.isOverTimeApproved,
        this.isMissPunch,
        this.isShortTime,
        this.isEarlyExit,
        this.isExcessBreak,
        this.isOverTime,
        this.isLateEntry,
        this.punchType,
        // this.shiftData,
      });

  ManagerEmployeeData.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    designation = json['designation'];
    employeeDailyAttendanceId = json['employeeDailyAttendanceId'];
    employeeId = json['employeeId'];
    employeeCompanyId = json['employeeCompanyId'];
    date = json['date'];
    shiftId = json['shiftId'];
    firstCheckInTime = json['firstCheckInTime'];
    lastCheckOutTime = json['lastCheckOutTime'];
    totalWorkHours = json['totalWorkHours'];
    // dutyType = json['dutyType'];
    isRegularizationNeeded = json['isRegularizationNeeded'];
    excuseType = json['excuseType'];
    isActive = json['isActive'];
    createdBy = json['createdBy'];
    createdOn = json['createdOn'];
    modifiedBy = json['modifiedBy'];
    modifiedOn = json['modifiedOn'];
    companyId = json['companyId'];
    isHoliday = json['isHoliday']?.toString();
    isOffDay = json['isOffDay']?.toString();
    isLeave = json['isLeave'];
    isExcused = json['isExcused'];
    status = json['status'];
    leaveTypeId = json['leaveTypeId'];
    description = json['description'];
    isFine = json['isFine']?.toString();
    isPunchApproved = json['isPunchApproved'];
    // leaveSession = json['leaveSession'];
    isHalfDay = json['isHalfDay']?.toString();
    isPaidLeave = json['isPaidLeave']?.toString();
    hasOverTime = json['hasOverTime'];
    isShuffle = json['isShuffle'];
    leaveReason = json['leaveReason'];
    presentShiftCount = json['presentShiftCount'];
    isDeductionCompleted = json['isDeductionCompleted'];
    // totalBreakHours = json['totalBreakHours'];
    shifSchemeName = json['shifSchemeName'];
    shiftSchemeType = json['shiftSchemeType'];
    shiftSchemeId = json['shiftSchemeId'];
    shiftName = json['shiftName'];
    shiftStartTime = json['shiftStartTime'];
    allowBreaks = json['allowBreaks'];
    shiftBreakDuration = json['shiftBreakDuration'];
    // breakFrom = json['breakFrom'];
    // breakTo = json['breakTo'];
    shiftEndTime = json['shiftEndTime'];
    shiftWorkHours = json['shiftWorkHours'];
    profilePicture = json['profilePicture'];
    employeeName = json['employeeName'];
    // employeeOvertimeDataId = json['employeeOvertimeDataId'];
    extraHours = json['extraHours'];
    // overtimeStatus = json['overtimeStatus'];
    department = json['department'];
    departmentId = json['departmentId'];
    category = json['category'];
    categoryId = json['categoryId'];
    location = json['location'];
    locationId = json['locationId'];
    // subCategory = json['subCategory'];
    // subCategoryId = json['subCategoryId'];
    isLeaveAppliedHalfDay = json['isLeaveAppliedHalfDay'];
    isLeaveApplied = json['isLeaveApplied'];
    breakHours = json['breakHours'];
    hoursWorkedMessage = json['hoursWorkedMessage'];
    schedule = json['schedule'];
    if(json['totalFineToRegularizeAmount'] != null) {
      totalFineToRegularizeAmount = double.parse(json['totalFineToRegularizeAmount'].toString());
    }
    totalHoursToRegularize = json['totalHoursToRegularize'];
    isFineToRegularize = json['isFineToRegularize'];
    totalFinedAmount = json['totalFinedAmount'];
    totalFinedHours = json['totalFinedHours'];
    finedCount = json['finedCount'];
    pardonedCount = json['pardonedCount'];
    requestsCount = json['requestsCount'];
    isOverTimeApproved = json['isOverTimeApproved'];
    isMissPunch = json['isMissPunch'];
    isShortTime = json['isShortTime'];
    isEarlyExit = json['isEarlyExit'];
    isExcessBreak = json['isExcessBreak'];
    isOverTime = json['isOverTime'];
    isLateEntry = json['isLateEntry'];
    if(json['punchType'] != null) {
      punchType = <String>[];
      json['punchType'].forEach((v) {
        punchType!.add(v);
      });
    }
    // if (json['shiftData'] != null) {
    //   shiftData = <Null>[];
    //   json['shiftData'].forEach((v) {
    //     shiftData!.add(new Null.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['designation'] = this.designation;
    data['employeeDailyAttendanceId'] = this.employeeDailyAttendanceId;
    data['employeeId'] = this.employeeId;
    data['employeeCompanyId'] = this.employeeCompanyId;
    data['date'] = this.date;
    data['shiftId'] = this.shiftId;
    data['firstCheckInTime'] = this.firstCheckInTime;
    data['lastCheckOutTime'] = this.lastCheckOutTime;
    data['totalWorkHours'] = this.totalWorkHours;
    // data['dutyType'] = this.dutyType;
    data['isRegularizationNeeded'] = this.isRegularizationNeeded;
    data['excuseType'] = this.excuseType;
    data['isActive'] = this.isActive;
    data['createdBy'] = this.createdBy;
    data['createdOn'] = this.createdOn;
    data['modifiedBy'] = this.modifiedBy;
    data['modifiedOn'] = this.modifiedOn;
    data['companyId'] = this.companyId;
    data['isHoliday'] = this.isHoliday;
    data['isOffDay'] = this.isOffDay;
    data['isLeave'] = this.isLeave;
    data['isExcused'] = this.isExcused;
    data['status'] = this.status;
    data['leaveTypeId'] = this.leaveTypeId;
    data['description'] = this.description;
    data['isFine'] = this.isFine;
    data['isPunchApproved'] = this.isPunchApproved;
    // data['leaveSession'] = this.leaveSession;
    data['isHalfDay'] = this.isHalfDay;
    data['isPaidLeave'] = this.isPaidLeave;
    data['hasOverTime'] = this.hasOverTime;
    data['isShuffle'] = this.isShuffle;
    data['leaveReason'] = this.leaveReason;
    data['presentShiftCount'] = this.presentShiftCount;
    data['isDeductionCompleted'] = this.isDeductionCompleted;
    // data['totalBreakHours'] = this.totalBreakHours;
    data['shifSchemeName'] = this.shifSchemeName;
    data['shiftSchemeType'] = this.shiftSchemeType;
    data['shiftSchemeId'] = this.shiftSchemeId;
    data['shiftName'] = this.shiftName;
    data['shiftStartTime'] = this.shiftStartTime;
    data['allowBreaks'] = this.allowBreaks;
    data['shiftBreakDuration'] = this.shiftBreakDuration;
    // data['breakFrom'] = this.breakFrom;
    // data['breakTo'] = this.breakTo;
    data['shiftEndTime'] = this.shiftEndTime;
    data['shiftWorkHours'] = this.shiftWorkHours;
    data['profilePicture'] = this.profilePicture;
    data['employeeName'] = this.employeeName;
    // data['employeeOvertimeDataId'] = this.employeeOvertimeDataId;
    data['extraHours'] = this.extraHours;
    // data['overtimeStatus'] = this.overtimeStatus;
    data['department'] = this.department;
    data['departmentId'] = this.departmentId;
    data['category'] = this.category;
    data['categoryId'] = this.categoryId;
    data['location'] = this.location;
    data['locationId'] = this.locationId;
    // data['subCategory'] = this.subCategory;
    // data['subCategoryId'] = this.subCategoryId;
    data['isLeaveAppliedHalfDay'] = this.isLeaveAppliedHalfDay;
    data['isLeaveApplied'] = this.isLeaveApplied;
    data['breakHours'] = this.breakHours;
    data['hoursWorkedMessage'] = this.hoursWorkedMessage;
    data['schedule'] = this.schedule;
    data['totalFineToRegularizeAmount'] = this.totalFineToRegularizeAmount;
    data['totalHoursToRegularize'] = this.totalHoursToRegularize;
    data['isFineToRegularize'] = this.isFineToRegularize;
    data['totalFinedAmount'] = this.totalFinedAmount;
    data['totalFinedHours'] = this.totalFinedHours;
    data['finedCount'] = this.finedCount;
    data['pardonedCount'] = this.pardonedCount;
    data['requestsCount'] = this.requestsCount;
    data['isOverTimeApproved'] = this.isOverTimeApproved;
    data['isMissPunch'] = this.isMissPunch;
    data['isShortTime'] = this.isShortTime;
    data['isEarlyExit'] = this.isEarlyExit;
    data['isExcessBreak'] = this.isExcessBreak;
    data['isOverTime'] = this.isOverTime;
    data['isLateEntry'] = this.isLateEntry;
    data['punchType'] = this.punchType;
    // if (this.shiftData != null) {
    //   data['shiftData'] = this.shiftData!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}