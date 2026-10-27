class DetailedAttendanceApiModel {
  int? status;
  String? message;
  List<dynamic>? errors;
  Result? result;

  DetailedAttendanceApiModel(
      {this.status, this.message, this.errors, this.result});

  DetailedAttendanceApiModel.fromJson(Map<String, dynamic> json) {
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
  EmployeeData? employeeData;
  List<Logs>? logs;

  Result({this.employeeData, this.logs});

  Result.fromJson(Map<String, dynamic> json) {
    employeeData = json['employeeData'] != null
        ? EmployeeData.fromJson(json['employeeData'])
        : null;
    if (json['logs'] != null) {
      logs = <Logs>[];
      json['logs'].forEach((v) {
        logs!.add(Logs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (employeeData != null) {
      data['employeeData'] = employeeData!.toJson();
    }
    if (logs != null) {
      data['logs'] = logs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EmployeeData {
  // String? employeeName;
  // String? profilePicture;
  // String? code;
  // String? joiningDate;
  // String? attendanceDate;
  String? shift;

  EmployeeData(
      {
      // this.employeeName,
      // this.profilePicture,
      // this.code,
      // this.joiningDate,
      // this.attendanceDate,
      this.shift});

  EmployeeData.fromJson(Map<String, dynamic> json) {
    // employeeName = json['employeeName'];
    // profilePicture = json['profilePicture'];
    // code = json['code'];
    // joiningDate = json['joiningDate'];
    // attendanceDate = json['attendanceDate'];
    shift = json['shift'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // data['employeeName'] = employeeName;
    // data['profilePicture'] = profilePicture;
    // data['code'] = code;
    // data['joiningDate'] = joiningDate;
    // data['attendanceDate'] = attendanceDate;
    data['shift'] = shift;
    return data;
  }
}

class Logs {
  String? remark;
  // String? reference;
  Datas? datas;

  Logs({
    this.remark,
    // this.reference,
    this.datas,
  });

  Logs.fromJson(Map<String, dynamic> json) {
    remark = json['remark'];
    // reference = json['reference'];
    datas = json['datas'] != null ? Datas.fromJson(json['datas']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['remark'] = remark;
    // data['reference'] = reference;
    if (datas != null) {
      data['datas'] = datas!.toJson();
    }
    return data;
  }
}

class Datas {
  String? time;
  String? eventDate;
  String? punchType;
  String? punchInImage;
  // String? punchRemarks;
  String? punchInLocation;
  String? latitude;
  String? longitude;
  String? punchOutType;
  String? punchOutImage;
  // String? punchOutRemarks;
  String? punchOutLocation;
  // int? minutesTaken;
  // String? timeTaken;

  Datas(
      {this.time,
      this.eventDate,
      this.punchType,
      this.punchInImage,
      // this.punchRemarks,
      this.punchInLocation,
      this.latitude,
      this.longitude,
      this.punchOutType,
      this.punchOutImage,
      // this.punchOutRemarks,
      this.punchOutLocation,
      // this.minutesTaken,
      // this.timeTaken,
      });

  Datas.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    eventDate = json['eventDate'];
    punchType = json['punchType'];
    punchInImage = json['punchInImage'];
    // punchRemarks = json['punchRemarks'];
    punchInLocation = json['punchInLocation'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    punchOutType = json['punchOutType'];
    punchOutImage = json['punchOutImage'];
    // punchOutRemarks = json['punchOutRemarks'];
    punchOutLocation = json['punchOutLocation'];
    // minutesTaken = json['minutesTaken'];
    // timeTaken = json['timeTaken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['time'] = time;
    data['eventDate'] = eventDate;
    data['punchType'] = punchType;
    data['punchInImage'] = punchInImage;
    // data['punchRemarks'] = punchRemarks;
    data['punchInLocation'] = punchInLocation;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['punchOutType'] = punchOutType;
    data['punchOutImage'] = punchOutImage;
    // data['punchOutRemarks'] = punchOutRemarks;
    data['punchOutLocation'] = punchOutLocation;
    // data['minutesTaken'] = minutesTaken;
    // data['timeTaken'] = timeTaken;
    return data;
  }
}
