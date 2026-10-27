class LocationFilterApi {
  int? status;
  String? message;
  // List<Null>? errors;
  List<LocationData>? result;

  LocationFilterApi({this.status, this.message, this.result});

  LocationFilterApi.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    // if (json['errors'] != null) {
    //   errors = <Null>[];
    //   json['errors'].forEach((v) {
    //     errors!.add(new Null.fromJson(v));
    //   });
    // }
    if (json['result'] != null) {
      result = <LocationData>[];
      json['result'].forEach((v) {
        result!.add(new LocationData.fromJson(v));
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

class LocationData {
  int? locationId;
  String? companyId;
  String? location;
  String? description;
  int? isActive;
  int? createdBy;
  String? createdOn;
  // Null? modifiedBy;
  String? modifiedOn;
  // Null? locationGeoFencing;

  LocationData(
      {this.locationId,
        this.companyId,
        this.location,
        this.description,
        this.isActive,
        this.createdBy,
        this.createdOn,
        // this.modifiedBy,
        this.modifiedOn,
        // this.locationGeoFencing,
      });

  LocationData.fromJson(Map<String, dynamic> json) {
    locationId = json['locationId'];
    companyId = json['companyId'];
    location = json['location'];
    description = json['description'];
    isActive = json['isActive'];
    createdBy = json['createdBy'];
    createdOn = json['createdOn'];
    // modifiedBy = json['modifiedBy'];
    modifiedOn = json['modifiedOn'];
    // locationGeoFencing = json['locationGeoFencing'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['locationId'] = this.locationId;
    data['companyId'] = this.companyId;
    data['location'] = this.location;
    data['description'] = this.description;
    data['isActive'] = this.isActive;
    data['createdBy'] = this.createdBy;
    data['createdOn'] = this.createdOn;
    // data['modifiedBy'] = this.modifiedBy;
    data['modifiedOn'] = this.modifiedOn;
    // data['locationGeoFencing'] = this.locationGeoFencing;
    return data;
  }
}

class DepartmentFilterApi {
  int? status;
  String? message;
  // List<Null>? errors;
  List<DepartmentData>? result;

  DepartmentFilterApi({this.status, this.message, this.result});

  DepartmentFilterApi.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    // if (json['errors'] != null) {
    //   errors = <Null>[];
    //   json['errors'].forEach((v) {
    //     errors!.add(new Null.fromJson(v));
    //   });
    // }
    if (json['result'] != null) {
      result = <DepartmentData>[];
      json['result'].forEach((v) {
        result!.add(new DepartmentData.fromJson(v));
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

class DepartmentData {
  int? departmentId;
  String? companyId;
  String? department;
  String? description;
  // int? isActive;
  String? createdOn;
  // Null? modifiedBy;
  String? modifiedOn;
  int? createdBy;

  DepartmentData(
      {this.departmentId,
        this.companyId,
        this.department,
        this.description,
        // this.isActive,
        this.createdOn,
        // this.modifiedBy,
        this.modifiedOn,
        this.createdBy});

  DepartmentData.fromJson(Map<String, dynamic> json) {
    departmentId = json['departmentId'];
    companyId = json['companyId'];
    department = json['department'];
    description = json['description'];
    // isActive = json['isActive'];
    createdOn = json['createdOn'];
    // modifiedBy = json['modifiedBy'];
    modifiedOn = json['modifiedOn'];
    createdBy = json['createdBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['departmentId'] = this.departmentId;
    data['companyId'] = this.companyId;
    data['department'] = this.department;
    data['description'] = this.description;
    // data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    // data['modifiedBy'] = this.modifiedBy;
    data['modifiedOn'] = this.modifiedOn;
    data['createdBy'] = this.createdBy;
    return data;
  }
}

class ShiftSchemeFilterApi {
  int? status;
  String? message;
  // List<Null>? errors;
  List<ShiftSchemeResult>? result;

  ShiftSchemeFilterApi({this.status, this.message, this.result});

  ShiftSchemeFilterApi.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    // if (json['errors'] != null) {
    //   errors = <Null>[];
    //   json['errors'].forEach((v) {
    //     errors!.add(new Null.fromJson(v));
    //   });
    // }
    if (json['result'] != null) {
      result = <ShiftSchemeResult>[];
      json['result'].forEach((v) {
        result!.add(new ShiftSchemeResult.fromJson(v));
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

class ShiftSchemeResult {
  int? shiftSchemeId;
  String? companyId;
  List<int>? shiftId;
  String? shiftScheme;
  String? description;
  String? startTime;
  String? endTime;
  String? allowBreaks;
  String? breakDuration;
  String? isOverTimeEnabled;
  String? shiftSchemeType;
  int? isActive;
  int? createdBy;
  String? createdOn;
  // Null? modifiedBy;
  String? modifiedOn;
  // Null? cwl;
  // List<ShiftDatas>? shiftDatas;
  // List<Employee>? employee;

  ShiftSchemeResult(
      {this.shiftSchemeId,
        this.companyId,
        this.shiftId,
        this.shiftScheme,
        this.description,
        this.startTime,
        this.endTime,
        this.allowBreaks,
        this.breakDuration,
        this.isOverTimeEnabled,
        this.shiftSchemeType,
        this.isActive,
        this.createdBy,
        this.createdOn,
        // this.modifiedBy,
        this.modifiedOn,
        // this.cwl,
        // this.shiftDatas,
        // this.employee,
      });

  ShiftSchemeResult.fromJson(Map<String, dynamic> json) {
    shiftSchemeId = json['shiftSchemeId'];
    companyId = json['companyId'];
    shiftId = json['shiftId'].cast<int>();
    shiftScheme = json['shiftScheme'];
    description = json['description'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    allowBreaks = json['allowBreaks'];
    breakDuration = json['breakDuration'];
    isOverTimeEnabled = json['isOverTimeEnabled'];
    shiftSchemeType = json['shiftSchemeType'];
    isActive = json['isActive'];
    createdBy = json['createdBy'];
    createdOn = json['createdOn'];
    // modifiedBy = json['modifiedBy'];
    modifiedOn = json['modifiedOn'];
    // cwl = json['cwl'];
    // if (json['shiftDatas'] != null) {
    //   shiftDatas = <ShiftDatas>[];
    //   json['shiftDatas'].forEach((v) {
    //     shiftDatas!.add(new ShiftDatas.fromJson(v));
    //   });
    // }
    // if (json['employee'] != null) {
    //   employee = <Employee>[];
    //   json['employee'].forEach((v) {
    //     employee!.add(new Employee.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shiftSchemeId'] = this.shiftSchemeId;
    data['companyId'] = this.companyId;
    data['shiftId'] = this.shiftId;
    data['shiftScheme'] = this.shiftScheme;
    data['description'] = this.description;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['allowBreaks'] = this.allowBreaks;
    data['breakDuration'] = this.breakDuration;
    data['isOverTimeEnabled'] = this.isOverTimeEnabled;
    data['shiftSchemeType'] = this.shiftSchemeType;
    data['isActive'] = this.isActive;
    data['createdBy'] = this.createdBy;
    data['createdOn'] = this.createdOn;
    // data['modifiedBy'] = this.modifiedBy;
    data['modifiedOn'] = this.modifiedOn;
    // data['cwl'] = this.cwl;
    // if (this.shiftDatas != null) {
    //   data['shiftDatas'] = this.shiftDatas!.map((v) => v.toJson()).toList();
    // }
    // if (this.employee != null) {
    //   data['employee'] = this.employee!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class ShiftDatas {
  String? shiftId;
  String? shift;

  ShiftDatas({this.shiftId, this.shift});

  ShiftDatas.fromJson(Map<String, dynamic> json) {
    shiftId = json['shiftId'];
    shift = json['shift'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shiftId'] = this.shiftId;
    data['shift'] = this.shift;
    return data;
  }
}

class Employee {
  String? employeeId;
  String? profilePicture;
  String? employeeName;
  String? profilePicName;

  Employee(
      {this.employeeId,
        this.profilePicture,
        this.employeeName,
        this.profilePicName});

  Employee.fromJson(Map<String, dynamic> json) {
    employeeId = json['employeeId'];
    profilePicture = json['profilePicture'];
    employeeName = json['employeeName'];
    profilePicName = json['profilePicName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employeeId'] = this.employeeId;
    data['profilePicture'] = this.profilePicture;
    data['employeeName'] = this.employeeName;
    data['profilePicName'] = this.profilePicName;
    return data;
  }
}

class PunchTypeFilterApi {
  int? status;
  String? message;
  // List<Null>? errors;
  List<PunchTypeResult>? result;

  PunchTypeFilterApi({this.status, this.message, this.result});

  PunchTypeFilterApi.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    // if (json['errors'] != null) {
    //   errors = <Null>[];
    //   json['errors'].forEach((v) {
    //     errors!.add(new Null.fromJson(v));
    //   });
    // }
    if (json['result'] != null) {
      result = <PunchTypeResult>[];
      json['result'].forEach((v) {
        result!.add(new PunchTypeResult.fromJson(v));
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

class PunchTypeResult {
  String? punchType;

  PunchTypeResult({this.punchType});

  PunchTypeResult.fromJson(Map<String, dynamic> json) {
    punchType = json['punchType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['punchType'] = this.punchType;
    return data;
  }
}