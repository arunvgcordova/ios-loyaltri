// class ManagerAttSummary {
//   int? status;
//   String? message;
//   // List<Null>? errors;
//   SummaryData? result;

//   ManagerAttSummary({this.status, this.message, this.result});

//   ManagerAttSummary.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     // if (json['errors'] != null) {
//     //   errors = <Null>[];
//     //   json['errors'].forEach((v) {
//     //     errors!.add(new Null.fromJson(v));
//     //   });
//     // }
//     result =
//     json['result'] != null ? SummaryData.fromJson(json['result']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['status'] = status;
//     data['message'] = message;
//     // if (this.errors != null) {
//     //   data['errors'] = this.errors!.map((v) => v.toJson()).toList();
//     // }
//     if (result != null) {
//       data['result'] = result!.toJson();
//     }
//     return data;
//   }
// }

// class SummaryData {
//   String? summaryDate;
//   double? totalEmployees;
//   double? present;
//   double? absent;
//   double? onLeave;
//   double? approvedLeaves;
//   double? halfDay;
//   double? others;
//   double? daysoff;
//   double? holidaycount;

//   SummaryData(
//       {this.summaryDate,
//         this.totalEmployees,
//         this.present,
//         this.absent,
//         this.onLeave,
//         this.approvedLeaves,
//         this.halfDay,
//         this.others,
//         this.daysoff,
//         this.holidaycount});

//   SummaryData.fromJson(Map<String, dynamic> json) {
//     summaryDate = json['summaryDate'];
//     if(json['totalEmployees'] != null) {
//       totalEmployees = double.parse(json['totalEmployees'].toString());
//     }
//     if(json['present'] != null) {
//       present = double.parse(json['present'].toString());
//     }
//     if(json['absent'] != null) {
//       absent = double.parse(json['absent'].toString());
//     }
//     if(json['onLeave'] != null) {
//       onLeave = double.parse(json['onLeave'].toString());
//     }
//     if(json['approvedLeaves'] != null) {
//       approvedLeaves = double.parse(json['approvedLeaves'].toString());
//     }
//     if(json['halfDay'] != null) {
//       halfDay = double.parse(json['halfDay'].toString());
//     }
//     if(json['others'] != null) {
//       others = double.parse(json['others'].toString());
//     }
//     if(json['daysoff'] != null) {
//       daysoff = double.parse(json['daysoff'].toString());
//     }
//     if(json['holidaycount'] != null) {
//       holidaycount = double.parse(json['holidaycount'].toString());
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['summaryDate'] = summaryDate;
//     data['totalEmployees'] = totalEmployees;
//     data['present'] = present;
//     data['absent'] = absent;
//     data['onLeave'] = onLeave;
//     data['approvedLeaves'] = approvedLeaves;
//     data['halfDay'] = halfDay;
//     data['others'] = others;
//     data['daysoff'] = daysoff;
//     data['holidaycount'] = holidaycount;
//     return data;
//   }
// }



  class ManagerAttSummary {
  int? status;
  String? message;
  List<Null>? errors;
  SummaryData? summaryData;

  ManagerAttSummary({this.status, this.message, this.summaryData});

  ManagerAttSummary.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    // if (json['errors'] != null) {
    //   errors = <Null>[];
    //   json['errors'].forEach((v) {
    //     errors!.add(Null.fromJson(v));
    //   });
    // }
    summaryData =
        json['result'] != null ? new SummaryData.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    // if (this.errors != null) {
    //   data['errors'] = this.errors!.map((v) => v.toJson()).toList();
    // }
    if (this.summaryData != null) {
      data['result'] = this.summaryData!.toJson();
    }
    return data;
  }
}

class SummaryData {
  String? summaryDate;
  int? totalEmployees;
  int? present;
  int? absent;
  int? onLeave;
  int? workingDays;
  int? halfDay;
  int? isHoliday;
  int? isleave;
  Fine? fine;
  OverTime? overTime;
  int? offDays;
  String? percentage;
  int? allCount;
  int? paidLeave;
  int? unpaidLeave;

  SummaryData(
      {this.summaryDate,
      this.totalEmployees,
      this.present,
      this.absent,
      this.onLeave,
      this.workingDays,
      this.halfDay,
      this.isHoliday,
      this.isleave,
      this.fine,
      this.overTime,
      this.offDays,
      this.percentage,
      this.allCount,
      this.paidLeave,
      this.unpaidLeave});

  SummaryData.fromJson(Map<String, dynamic> json) {
    summaryDate = json['summaryDate'];
    totalEmployees = json['totalEmployees'];
    present = json['present'];
    absent = json['absent'];
    onLeave = json['onLeave'];
    workingDays = json['workingDays'];
    halfDay = json['halfDay'];
    isHoliday = json['isHoliday'];
    isleave = json['isleave'];
    fine = json['fine'] != null ? new Fine.fromJson(json['fine']) : null;
    overTime = json['overTime'] != null
        ? new OverTime.fromJson(json['overTime'])
        : null;
    offDays = json['offDays'];
    percentage = json['percentage'];
    allCount = json['allCount'];
    paidLeave = json['paidLeave'];
    unpaidLeave = json['unpaidLeave'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['summaryDate'] = this.summaryDate;
    data['totalEmployees'] = this.totalEmployees;
    data['present'] = this.present;
    data['absent'] = this.absent;
    data['onLeave'] = this.onLeave;
    data['workingDays'] = this.workingDays;
    data['halfDay'] = this.halfDay;
    data['isHoliday'] = this.isHoliday;
    data['isleave'] = this.isleave;
    if (this.fine != null) {
      data['fine'] = this.fine!.toJson();
    }
    if (this.overTime != null) {
      data['overTime'] = this.overTime!.toJson();
    }
    data['offDays'] = this.offDays;
    data['percentage'] = this.percentage;
    data['allCount'] = this.allCount;
    data['paidLeave'] = this.paidLeave;
    data['unpaidLeave'] = this.unpaidLeave;
    return data;
  }
}

class Fine {
  int? pardonedFineCount;
  String? pardonedHours;
  int? finedCount;
  String? finedHours;
  int? fineCount;

  Fine(
      {this.pardonedFineCount,
      this.pardonedHours,
      this.finedCount,
      this.finedHours,
      this.fineCount});

  Fine.fromJson(Map<String, dynamic> json) {
    pardonedFineCount = json['pardonedFineCount'];
    pardonedHours = json['pardonedHours'];
    finedCount = json['finedCount'];
    finedHours = json['finedHours'];
    fineCount = json['fineCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pardonedFineCount'] = this.pardonedFineCount;
    data['pardonedHours'] = this.pardonedHours;
    data['finedCount'] = this.finedCount;
    data['finedHours'] = this.finedHours;
    data['fineCount'] = this.fineCount;
    return data;
  }
}

class OverTime {
  int? pendingOverTimeCount;
  String? pendingOverTimeHours;
  int? approvedOverTimeCount;
  String? approvedOverTimeHours;
  int? overTimeCount;

  OverTime(
      {this.pendingOverTimeCount,
      this.pendingOverTimeHours,
      this.approvedOverTimeCount,
      this.approvedOverTimeHours,
      this.overTimeCount});

  OverTime.fromJson(Map<String, dynamic> json) {
    pendingOverTimeCount = json['pendingOverTimeCount'];
    pendingOverTimeHours = json['pendingOverTimeHours'];
    approvedOverTimeCount = json['approvedOverTimeCount'];
    approvedOverTimeHours = json['approvedOverTimeHours'];
    overTimeCount = json['overTimeCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pendingOverTimeCount'] = this.pendingOverTimeCount;
    data['pendingOverTimeHours'] = this.pendingOverTimeHours;
    data['approvedOverTimeCount'] = this.approvedOverTimeCount;
    data['approvedOverTimeHours'] = this.approvedOverTimeHours;
    data['overTimeCount'] = this.overTimeCount;
    return data;
  }
}
