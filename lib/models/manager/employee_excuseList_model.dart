class EmployeeExcuseListApi {
  int? status;
  String? message;
  // List<Null>? errors;
  List<ExcuseData>? result;

  EmployeeExcuseListApi({this.status, this.message, this.result});

  EmployeeExcuseListApi.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    // if (json['errors'] != null) {
    //   errors = <Null>[];
    //   json['errors'].forEach((v) {
    //     errors!.add(new Null.fromJson(v));
    //   });
    // }
    if (json['result'] != null) {
      result = <ExcuseData>[];
      json['result'].forEach((v) {
        result!.add(new ExcuseData.fromJson(v));
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

class ExcuseData {
  String? date;
  List<Employees>? employees;

  ExcuseData({this.date, this.employees});

  ExcuseData.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    if (json['employees'] != null) {
      employees = <Employees>[];
      json['employees'].forEach((v) {
        employees!.add(new Employees.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    if (this.employees != null) {
      data['employees'] = this.employees!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Employees {
  String? employeeId;
  String? code;
  String? date;
  String? shiftName;
  String? profilePicture;
  String? employeeName;
  String? designation;
  String? totalWorkHours;
  String? employeeDailyAttendanceId;
  String? firstCheckInTime;
  String? lastCheckOutTime;
  List<Status>? status;
  bool? isSelected;

  Employees(
      {this.employeeId,
        this.code,
        this.date,
        this.shiftName,
        this.profilePicture,
        this.employeeName,
        this.designation,
        this.totalWorkHours,
        this.employeeDailyAttendanceId,
        this.firstCheckInTime,
        this.lastCheckOutTime,
        this.status,
        this.isSelected});

  Employees.fromJson(Map<String, dynamic> json) {
    employeeId = json['employeeId'];
    code = json['code'];
    date = json['date'];
    shiftName = json['shiftName'];
    profilePicture = json['profilePicture'];
    employeeName = json['employeeName'];
    designation = json['designation'];
    totalWorkHours = json['totalWorkHours'];
    employeeDailyAttendanceId = json['employeeDailyAttendanceId'];
    firstCheckInTime = json['firstCheckInTime'];
    lastCheckOutTime = json['lastCheckOutTime'];
    isSelected = json['isSelected'] ?? false;
    if (json['status'] != null) {
      status = <Status>[];
      json['status'].forEach((v) {
        status!.add(new Status.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employeeId'] = this.employeeId;
    data['code'] = this.code;
    data['date'] = this.date;
    data['shiftName'] = this.shiftName;
    data['profilePicture'] = this.profilePicture;
    data['employeeName'] = this.employeeName;
    data['designation'] = this.designation;
    data['totalWorkHours'] = this.totalWorkHours;
    data['employeeDailyAttendanceId'] = this.employeeDailyAttendanceId;
    data['firstCheckInTime'] = this.firstCheckInTime;
    data['lastCheckOutTime'] = this.lastCheckOutTime;
    data['isSelected'] = this.isSelected;
    if (this.status != null) {
      data['status'] = this.status!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Status {
  String? employeeDailyAttendanceId;
  String? employeeAttendanceDeductionId;
  String? deductionDate;
  String? deductionDetails;
  String? deductionAmount;
  String? timeDifference;
  String? excuseType;
  String? color;

  Status(
      {this.employeeDailyAttendanceId,
        this.employeeAttendanceDeductionId,
        this.deductionDate,
        this.deductionDetails,
        this.deductionAmount,
        this.timeDifference,
        this.excuseType,
        this.color});

  Status.fromJson(Map<String, dynamic> json) {
    employeeDailyAttendanceId = json['employeeDailyAttendanceId'];
    employeeAttendanceDeductionId = json['employeeAttendanceDeductionId'];
    deductionDate = json['deductionDate'];
    deductionDetails = json['deductionDetails'];
    deductionAmount = json['deductionAmount'];
    timeDifference = json['timeDifference'];
    excuseType = json['excuseType'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employeeDailyAttendanceId'] = this.employeeDailyAttendanceId;
    data['employeeAttendanceDeductionId'] = this.employeeAttendanceDeductionId;
    data['deductionDate'] = this.deductionDate;
    data['deductionDetails'] = this.deductionDetails;
    data['deductionAmount'] = this.deductionAmount;
    data['timeDifference'] = this.timeDifference;
    data['excuseType'] = this.excuseType;
    data['color'] = this.color;
    return data;
  }
}

class OvertimeListApi {
  int? status;
  String? message;
  // List<Null>? errors;
  OvertimeList? result;

  OvertimeListApi({this.status, this.message, this.result});

  OvertimeListApi.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    // if (json['errors'] != null) {
    //   errors = <Null>[];
    //   json['errors'].forEach((v) {
    //     errors!.add(new Null.fromJson(v));
    //   });
    // }
    result =
    json['result'] != null ? new OvertimeList.fromJson(json['result']) : null;
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

class OvertimeList {
  List<OvertimeData>? result;
  int? count;

  OvertimeList({this.result, this.count});

  OvertimeList.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <OvertimeData>[];
      json['result'].forEach((v) {
        result!.add(new OvertimeData.fromJson(v));
      });
    }
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    data['count'] = this.count;
    return data;
  }
}

class OvertimeData {
  String? date;
  List<OvertimeEmployees>? employees;

  OvertimeData({this.date, this.employees});

  OvertimeData.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    if (json['employees'] != null) {
      employees = <OvertimeEmployees>[];
      json['employees'].forEach((v) {
        employees!.add(new OvertimeEmployees.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    if (this.employees != null) {
      data['employees'] = this.employees!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OvertimeEmployees {
  String? employeeId;
  String? code;
  String? date;
  String? shiftName;
  String? designation;
  String? profilePicture;
  String? employeeName;
  String? totalWorkHours;
  String? employeeDailyAttendanceId;
  String? firstCheckInTime;
  String? lastCheckOutTime;
  List<OvertimeStatus>? status;
  String? requestStatus;

  OvertimeEmployees(
      {this.employeeId,
        this.code,
        this.date,
        this.shiftName,
        this.profilePicture,
        this.employeeName,
        this.designation,
        this.totalWorkHours,
        this.employeeDailyAttendanceId,
        this.firstCheckInTime,
        this.lastCheckOutTime,
        this.status,
        this.requestStatus});

  OvertimeEmployees.fromJson(Map<String, dynamic> json) {
    employeeId = json['employeeId'];
    code = json['code'];
    date = json['date'];
    shiftName = json['shiftName'];
    profilePicture = json['profilePicture'];
    employeeName = json['employeeName'];
    designation = json['designation'];
    totalWorkHours = json['totalWorkHours'];
    employeeDailyAttendanceId = json['employeeDailyAttendanceId'];
    firstCheckInTime = json['firstCheckInTime'];
    lastCheckOutTime = json['lastCheckOutTime'];
    if (json['status'] != null) {
      status = <OvertimeStatus>[];
      json['status'].forEach((v) {
        status!.add(new OvertimeStatus.fromJson(v));
      });
    }
    requestStatus = json['requestStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employeeId'] = this.employeeId;
    data['code'] = this.code;
    data['date'] = this.date;
    data['shiftName'] = this.shiftName;
    data['profilePicture'] = this.profilePicture;
    data['employeeName'] = this.employeeName;
    data['designation'] = this.designation;
    data['totalWorkHours'] = this.totalWorkHours;
    data['employeeDailyAttendanceId'] = this.employeeDailyAttendanceId;
    data['firstCheckInTime'] = this.firstCheckInTime;
    data['lastCheckOutTime'] = this.lastCheckOutTime;
    if (this.status != null) {
      data['status'] = this.status!.map((v) => v.toJson()).toList();
    }
    data['requestStatus'] = this.requestStatus;
    return data;
  }
}

class OvertimeStatus {
  String? employeeOvertimeDataId;
  String? employeeId;
  String? overTimeMonth;
  String? overTimeDate;
  String? overTimeDetails;
  // Null? isActive;
  String? createdBy;
  String? createdOn;
  // Null? modifiedBy;
  String? modifiedOn;
  String? financialYear;
  String? amount;
  String? timeExtra;
  String? isPayrollNeeded;
  // Null? payrollReference;
  String? employeeDailyAttendanceId;
  String? overTimeApplied;
  String? status;
  // Null? deletedOn;
  String? overTimeRate;
  String? shiftId;
  // Null? isAccumulated;
  // Null? isTriggered;

  OvertimeStatus(
      {this.employeeOvertimeDataId,
        this.employeeId,
        this.overTimeMonth,
        this.overTimeDate,
        this.overTimeDetails,
        // this.isActive,
        this.createdBy,
        this.createdOn,
        // this.modifiedBy,
        this.modifiedOn,
        this.financialYear,
        this.amount,
        this.timeExtra,
        this.isPayrollNeeded,
        // this.payrollReference,
        this.employeeDailyAttendanceId,
        this.overTimeApplied,
        this.status,
        // this.deletedOn,
        this.overTimeRate,
        this.shiftId,
        // this.isAccumulated,
        // this.isTriggered,
      });

  OvertimeStatus.fromJson(Map<String, dynamic> json) {
    employeeOvertimeDataId = json['employeeOvertimeDataId'];
    employeeId = json['employeeId'];
    overTimeMonth = json['overTimeMonth'];
    overTimeDate = json['overTimeDate'];
    overTimeDetails = json['overTimeDetails'];
    // isActive = json['isActive'];
    createdBy = json['createdBy'];
    createdOn = json['createdOn'];
    // modifiedBy = json['modifiedBy'];
    modifiedOn = json['modifiedOn'];
    financialYear = json['financialYear'];
    amount = json['amount'];
    timeExtra = json['timeExtra'];
    isPayrollNeeded = json['isPayrollNeeded'];
    // payrollReference = json['payrollReference'];
    employeeDailyAttendanceId = json['employeeDailyAttendanceId'];
    overTimeApplied = json['overTimeApplied'];
    status = json['status'];
    // deletedOn = json['deletedOn'];
    overTimeRate = json['overTimeRate'];
    shiftId = json['shiftId'];
    // isAccumulated = json['isAccumulated'];
    // isTriggered = json['isTriggered'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employeeOvertimeDataId'] = this.employeeOvertimeDataId;
    data['employeeId'] = this.employeeId;
    data['overTimeMonth'] = this.overTimeMonth;
    data['overTimeDate'] = this.overTimeDate;
    data['overTimeDetails'] = this.overTimeDetails;
    // data['isActive'] = this.isActive;
    data['createdBy'] = this.createdBy;
    data['createdOn'] = this.createdOn;
    // data['modifiedBy'] = this.modifiedBy;
    data['modifiedOn'] = this.modifiedOn;
    data['financialYear'] = this.financialYear;
    data['amount'] = this.amount;
    data['timeExtra'] = this.timeExtra;
    data['isPayrollNeeded'] = this.isPayrollNeeded;
    // data['payrollReference'] = this.payrollReference;
    data['employeeDailyAttendanceId'] = this.employeeDailyAttendanceId;
    data['overTimeApplied'] = this.overTimeApplied;
    data['status'] = this.status;
    // data['deletedOn'] = this.deletedOn;
    data['overTimeRate'] = this.overTimeRate;
    data['shiftId'] = this.shiftId;
    // data['isAccumulated'] = this.isAccumulated;
    // data['isTriggered'] = this.isTriggered;
    return data;
  }
}