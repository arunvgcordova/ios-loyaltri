
class AttendanceSummaryModel {
  int? status;
  String? message;
  List<dynamic>? errors;
  AttSummary? result;

  AttendanceSummaryModel({this.status, this.message, this.errors, this.result});

  AttendanceSummaryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    errors = json['errors'];
    result = json['result'] != null ? AttSummary.fromJson(json['result']) : null;
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

class AttSummary {
  double? present;
  double? absent;
  double? unpaidLeave;
  double? absentLOP;
  double? workingDays;
  double? halfDay;
  Fine? fine;
  OverTime? overTime;
  double? offDays;
  double? holiDayCount;
  double? paidLeave;

  AttSummary(
      {
        this.present,
        this.absent,
        this.unpaidLeave,
        this.absentLOP,
        this.workingDays,
        this.halfDay,
        this.fine,
        this.overTime,
        this.offDays,
        this.holiDayCount,
        this.paidLeave,
      });

  AttSummary.fromJson(Map<String, dynamic> json) {
    if(json['present'] != null) {
      present = double.parse(json['present'].toString());
    }
    if(json['absent'] != null) {
      absent = double.parse(json['absent'].toString());
    }
    if(json['unpaid_Leave'] != null) {
      unpaidLeave = double.parse(json['unpaid_Leave'].toString());
    }
    if(json['absentLOP'] != null) {
      absentLOP = double.parse(json['absentLOP'].toString());
    }
    if(json['workingDays'] != null) {
      workingDays = double.parse(json['workingDays'].toString());
    }
    if(json['halfDay'] != null) {
      halfDay = double.parse(json['halfDay'].toString());
    }
    fine = json['fine'] != null ? Fine.fromJson(json['fine']) : null;
    overTime = json['overTime'] != null
        ? OverTime.fromJson(json['overTime'])
        : null;
    if(json['offDays'] != null) {
      offDays = double.parse(json['offDays'].toString());
    }
    if(json['holiDayCount'] != null) {
      holiDayCount = double.parse(json['holiDayCount'].toString());
    }
    if(json['paid_Leave'] != null) {
      paidLeave = double.parse(json['paid_Leave'].toString());
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['present'] = present;
    data['absent'] = absent;
    data['unpaid_Leave'] = unpaidLeave;
    data['absentLOP'] = absentLOP;
    data['workingDays'] = workingDays;
    data['halfDay'] = halfDay;
    if (fine != null) {
      data['fine'] = fine!.toJson();
    }
    if (overTime != null) {
      data['overTime'] = overTime!.toJson();
    }
    data['offDays'] = offDays;
    data['holiDayCount'] = holiDayCount;
    data['paid_Leave'] = paidLeave;
    return data;
  }
}

class Fine {
  double? pardonedFineCount;
  String? pardonedHours;
  double? finedCount;
  String? finedHours;

  Fine(
      {this.pardonedFineCount,
        this.pardonedHours,
        this.finedCount,
        this.finedHours});

  Fine.fromJson(Map<String, dynamic> json) {
    if(json['pardonedFineCount'] != null) {
      pardonedFineCount = double.parse(json['pardonedFineCount'].toString());
    }
    pardonedHours = json['pardonedHours']?.toString();
    if(json['finedCount'] != null) {
      finedCount = double.parse(json['finedCount'].toString());
    }
    finedHours = json['finedHours']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pardonedFineCount'] = pardonedFineCount;
    data['pardonedHours'] = pardonedHours;
    data['finedCount'] = finedCount;
    data['finedHours'] = finedHours;
    return data;
  }
}

class OverTime {
  double? pendingOverTimeCount;
  String? pendingOverTimeHours;
  double? approvedOverTimeCount;
  String? approvedOverTimeHours;

  OverTime(
      {
        this.pendingOverTimeCount,
        this.pendingOverTimeHours,
        this.approvedOverTimeCount,
        this.approvedOverTimeHours,
      });

  OverTime.fromJson(Map<String, dynamic> json) {
    if(json['pendingOverTimeCount'] != null) {
      pendingOverTimeCount = double.parse(json['pendingOverTimeCount'].toString());
    }
    pendingOverTimeHours = json['pendingOverTimeHours']?.toString();
    if(json['approvedOverTimeCount'] != null) {
      approvedOverTimeCount = double.parse(json['approvedOverTimeCount'].toString());
    }
    approvedOverTimeHours = json['approvedOverTimeHours']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pendingOverTimeCount'] = pendingOverTimeCount;
    data['pendingOverTimeHours'] = pendingOverTimeHours;
    data['approvedOverTimeCount'] = approvedOverTimeCount;
    data['approvedOverTimeHours'] = approvedOverTimeHours;
    return data;
  }
}