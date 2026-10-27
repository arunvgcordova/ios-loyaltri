class CalendarApiModel {
  int? status;
  String? message;
  // List<Null>? errors;
  Result? result;

  CalendarApiModel({this.status, this.message, this.result});

  CalendarApiModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    // if (json['errors'] != null) {
    //   errors = <Null>[];
    //   json['errors'].forEach((v) {
    //     errors!.add(new Null.fromJson(v));
    //   });
    // }
    result = json['result'] != null
        ? new Result.fromJson(json['result'])
        : null;
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

class Result {
  List<Leaves>? leaves;
  List<Leaves>? absent;
  List<Leaves>? duty;
  List<Leaves>? offday;
  List<Leaves>? holiday;
  List<Leaves>? unpaidLeave;
  List<Leaves>? paidLeave;

  Result({
    this.leaves,
    this.absent,
    this.duty,
    this.offday,
    this.holiday,
    this.unpaidLeave,
    this.paidLeave,
  });

  Result.fromJson(Map<String, dynamic> json) {
    if (json['Leaves'] != null) {
      leaves = <Leaves>[];
      json['Leaves'].forEach((v) {
        leaves!.add(new Leaves.fromJson(v));
      });
    }
    if (json['absent'] != null) {
      absent = <Leaves>[];
      json['absent'].forEach((v) {
        absent!.add(new Leaves.fromJson(v));
      });
    }
    if (json['duty'] != null) {
      duty = <Leaves>[];
      json['duty'].forEach((v) {
        duty!.add(new Leaves.fromJson(v));
      });
    }
    if (json['offday'] != null) {
      offday = <Leaves>[];
      json['offday'].forEach((v) {
        offday!.add(new Leaves.fromJson(v));
      });
    }
    if (json['holiday'] != null) {
      holiday = <Leaves>[];
      json['holiday'].forEach((v) {
        holiday!.add(new Leaves.fromJson(v));
      });
    }
    if (json['unpaidLeave'] != null) {
      unpaidLeave = <Leaves>[];
      json['unpaidLeave'].forEach((v) {
        unpaidLeave!.add(new Leaves.fromJson(v));
      });
    }
    if (json['paidLeave'] != null) {
      paidLeave = <Leaves>[];
      json['paidLeave'].forEach((v) {
        paidLeave!.add(new Leaves.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.leaves != null) {
      data['Leaves'] = this.leaves!.map((v) => v.toJson()).toList();
    }
    if (this.absent != null) {
      data['absent'] = this.absent!.map((v) => v.toJson()).toList();
    }
    if (this.duty != null) {
      data['duty'] = this.duty!.map((v) => v.toJson()).toList();
    }
    if (this.offday != null) {
      data['offday'] = this.offday!.map((v) => v.toJson()).toList();
    }
    if (this.holiday != null) {
      data['holiday'] = this.holiday!.map((v) => v.toJson()).toList();
    }
    if (this.unpaidLeave != null) {
      data['unpaidLeave'] = this.unpaidLeave!.map((v) => v.toJson()).toList();
    }
    if (this.paidLeave != null) {
      data['paidLeave'] = this.paidLeave!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Leaves {
  String? date;
  String? status;
  String? isOffDay;
  String? isHoliday;
  String? isLeave;
  String? isPaidLeave;
  bool isHalfDay = false;
  bool isIrregular = false;
  bool isOvertime = false;

  Leaves({
    this.date,
    this.status,
    this.isOffDay,
    this.isHoliday,
    this.isLeave,
    this.isPaidLeave,
    required this.isHalfDay,
    required this.isIrregular,
    required this.isOvertime,
  });

  Leaves.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    status = json['status'];
    isOffDay = json['isOffDay']?.toString();
    isHoliday = json['isHoliday']?.toString();
    isLeave = json['isLeave'].toString();
    isPaidLeave = json['isPaidLeave'].toString();
    isHalfDay = json['isHalfDay'] is bool ? json['isHalfDay'] ?? false : false;
    isIrregular = json['isIrregular'] is bool ? json['isIrregular'] ?? false : false;
    isOvertime = json['isOvertime'] is bool ? json['isOvertime'] ?? false : false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['status'] = this.status;
    data['isOffDay'] = this.isOffDay;
    data['isHoliday'] = this.isHoliday;
    data['isLeave'] = this.isLeave;
    data['isPaidLeave'] = this.isPaidLeave;
    data['isHalfDay'] = this.isHalfDay;
    data['isIrregular'] = this.isIrregular;
    data['isOvertime'] = this.isOvertime;
    return data;
  }
}
