class OtpOverrideResponse {
  int? status;
  String? message;
  Data? data;

  OtpOverrideResponse({this.status, this.message, this.data});

  OtpOverrideResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  OtpOverride? otpOverride;
  GeofenceOverride? geofenceOverride;

  Data({this.otpOverride, this.geofenceOverride});

  Data.fromJson(Map<String, dynamic> json) {
    otpOverride = json['otp_override'] != null
        ? OtpOverride.fromJson(json['otp_override'])
        : null;
    geofenceOverride = json['geofence_override'] != null
        ? GeofenceOverride.fromJson(json['geofence_override'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (otpOverride != null) {
      data['otp_override'] = otpOverride!.toJson();
    }
    if (geofenceOverride != null) {
      data['geofence_override'] = geofenceOverride!.toJson();
    }
    return data;
  }
}

class OtpOverride {
  int? id;
  int? workId;
  int? workInstanceId;
  String? overrideFor;
  String? status;
  String? note;
  String? requestDatetime;
  int? requestBy;
  // Null? approvedBy;
  // Null? approvedDatetime;
  String? createdAt;
  String? updatedAt;
  Work? work;
  WorkInstance? workInstance;

  OtpOverride(
      {this.id,
      this.workId,
      this.workInstanceId,
      this.overrideFor,
      this.status,
      this.note,
      this.requestDatetime,
      this.requestBy,
      // this.approvedBy,
      // this.approvedDatetime,
      this.createdAt,
      this.updatedAt,
      this.work,
      this.workInstance});

  OtpOverride.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    workId = json['work_id'];
    workInstanceId = json['work_instance_id'];
    overrideFor = json['override_for'];
    status = json['status'];
    note = json['note'];
    requestDatetime = json['request_datetime'];
    requestBy = json['request_by'];
    // approvedBy = json['approved_by'];
    // approvedDatetime = json['approved_datetime'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    work = json['work'] != null ? Work.fromJson(json['work']) : null;
    workInstance = json['work_instance'] != null
        ? WorkInstance.fromJson(json['work_instance'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['work_id'] = workId;
    data['work_instance_id'] = workInstanceId;
    data['override_for'] = overrideFor;
    data['status'] = status;
    data['note'] = note;
    data['request_datetime'] = requestDatetime;
    data['request_by'] = requestBy;
    // data['approved_by'] = approvedBy;
    // data['approved_datetime'] = approvedDatetime;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (work != null) {
      data['work'] = work!.toJson();
    }
    if (workInstance != null) {
      data['work_instance'] = workInstance!.toJson();
    }
    return data;
  }
}

class Work {
  int? id;
  String? title;
  int? companyId;
  String? priority;
  String? locationName;
  String? status;
  WorkType? workType;
  Customer? customer;

  Work(
      {this.id,
      this.title,
      this.companyId,
      this.priority,
      this.locationName,
      this.status,
      this.workType,
      this.customer});

  Work.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    companyId = json['company_id'];
    priority = json['priority'];
    locationName = json['location_name'];
    status = json['status'];
    workType = json['work_type'] != null
        ? WorkType.fromJson(json['work_type'])
        : null;
    customer = json['customer'] != null
        ? Customer.fromJson(json['customer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['title'] = title;
    data['company_id'] = companyId;
    data['priority'] = priority;
    data['location_name'] = locationName;
    data['status'] = status;
    if (workType != null) {
      data['work_type'] = workType!.toJson();
    }
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    return data;
  }
}

class WorkType {
  int? id;
  String? name;

  WorkType({this.id, this.name});

  WorkType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class Customer {
  int? id;
  String? customerCode;
  String? name;
  String? phone;
  String? email;
  String? locationName;

  Customer(
      {this.id,
      this.customerCode,
      this.name,
      this.phone,
      this.email,
      this.locationName});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerCode = json['customer_code'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    locationName = json['location_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['customer_code'] = customerCode;
    data['name'] = name;
    data['phone'] = phone;
    data['email'] = email;
    data['location_name'] = locationName;
    return data;
  }
}

class WorkInstance {
  int? id;
  int? employeeId;
  String? scheduledDate;
  String? plannedStartTime;
  String? plannedEndTime;
  String? workStatus;
  String? otpStatus;
  Null? approvalStatus;

  WorkInstance(
      {this.id,
      this.employeeId,
      this.scheduledDate,
      this.plannedStartTime,
      this.plannedEndTime,
      this.workStatus,
      this.otpStatus,
      this.approvalStatus});

  WorkInstance.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employee_id'];
    scheduledDate = json['scheduled_date'];
    plannedStartTime = json['planned_start_time'];
    plannedEndTime = json['planned_end_time'];
    workStatus = json['work_status'];
    otpStatus = json['otp_status'];
    approvalStatus = json['approval_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['employee_id'] = employeeId;
    data['scheduled_date'] = scheduledDate;
    data['planned_start_time'] = plannedStartTime;
    data['planned_end_time'] = plannedEndTime;
    data['work_status'] = workStatus;
    data['otp_status'] = otpStatus;
    data['approval_status'] = approvalStatus;
    return data;
  }
}

class GeofenceOverride {
  int? id;
  int? workId;
  int? workInstanceId;
  String? overrideFor;
  String? status;
  String? note;
  String? requestDatetime;
  int? requestBy;
  int? approvedBy;
  String? approvedDatetime;
  String? createdAt;
  String? updatedAt;
  Work? work;
  WorkInstance? workInstance;

  GeofenceOverride(
      {this.id,
      this.workId,
      this.workInstanceId,
      this.overrideFor,
      this.status,
      this.note,
      this.requestDatetime,
      this.requestBy,
      this.approvedBy,
      this.approvedDatetime,
      this.createdAt,
      this.updatedAt,
      this.work,
      this.workInstance});

  GeofenceOverride.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    workId = json['work_id'];
    workInstanceId = json['work_instance_id'];
    overrideFor = json['override_for'];
    status = json['status'];
    note = json['note'];
    requestDatetime = json['request_datetime'];
    requestBy = json['request_by'];
    approvedBy = json['approved_by'];
    approvedDatetime = json['approved_datetime'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    work = json['work'] != null ? Work.fromJson(json['work']) : null;
    workInstance = json['work_instance'] != null
        ? WorkInstance.fromJson(json['work_instance'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['work_id'] = workId;
    data['work_instance_id'] = workInstanceId;
    data['override_for'] = overrideFor;
    data['status'] = status;
    data['note'] = note;
    data['request_datetime'] = requestDatetime;
    data['request_by'] = requestBy;
    data['approved_by'] = approvedBy;
    data['approved_datetime'] = approvedDatetime;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (work != null) {
      data['work'] = work!.toJson();
    }
    if (workInstance != null) {
      data['work_instance'] = workInstance!.toJson();
    }
    return data;
  }
}


// class OtpOverrideResponse {
//   int? status;
//   String? message;
//   OtpData? data;

//   OtpOverrideResponse({this.status, this.message, this.data});

//   OtpOverrideResponse.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     data = json['data'] != null ? OtpData.fromJson(json['data']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['status'] = status;
//     data['message'] = message;
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     return data;
//   }
// }

// class OtpData {
//   int? id;
//   int? workId;
//   int? workInstanceId;
//   String? overrideFor;
//   String? status;
//   String? note;
//   String? requestDatetime;
//   int? requestBy;
//   // Null? approvedBy;
//   // Null? approvedDatetime;
//   String? createdAt;
//   String? updatedAt;
//   Work? work;
//   WorkInstance? workInstance;

//   OtpData(
//       {this.id,
//       this.workId,
//       this.workInstanceId,
//       this.overrideFor,
//       this.status,
//       this.note,
//       this.requestDatetime,
//       this.requestBy,
//       // this.approvedBy,
//       // this.approvedDatetime,
//       this.createdAt,
//       this.updatedAt,
//       this.work,
//       this.workInstance});

//   OtpData.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     workId = json['work_id'];
//     workInstanceId = json['work_instance_id'];
//     overrideFor = json['override_for'];
//     status = json['status'];
//     note = json['note'];
//     requestDatetime = json['request_datetime'];
//     requestBy = json['request_by'];
//     // approvedBy = json['approved_by'];
//     // approvedDatetime = json['approved_datetime'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     work = json['work'] != null ? Work.fromJson(json['work']) : null;
//     workInstance = json['work_instance'] != null
//         ? WorkInstance.fromJson(json['work_instance'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['work_id'] = workId;
//     data['work_instance_id'] = workInstanceId;
//     data['override_for'] = overrideFor;
//     data['status'] = status;
//     data['note'] = note;
//     data['request_datetime'] = requestDatetime;
//     data['request_by'] = requestBy;
//     // data['approved_by'] = approvedBy;
//     // data['approved_datetime'] = approvedDatetime;
//     data['created_at'] = createdAt;
//     data['updated_at'] = updatedAt;
//     if (work != null) {
//       data['work'] = work!.toJson();
//     }
//     if (workInstance != null) {
//       data['work_instance'] = workInstance!.toJson();
//     }
//     return data;
//   }
// }

// class Work {
//   int? id;
//   String? title;
//   int? companyId;
//   String? priority;
//   String? locationName;
//   String? status;
//   WorkType? workType;
//   Customer? customer;

//   Work(
//       {this.id,
//       this.title,
//       this.companyId,
//       this.priority,
//       this.locationName,
//       this.status,
//       this.workType,
//       this.customer});

//   Work.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     title = json['title'];
//     companyId = json['company_id'];
//     priority = json['priority'];
//     locationName = json['location_name'];
//     status = json['status'];
//     workType = json['work_type'] != null
//         ? WorkType.fromJson(json['work_type'])
//         : null;
//     customer = json['customer'] != null
//         ? Customer.fromJson(json['customer'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['title'] = title;
//     data['company_id'] = companyId;
//     data['priority'] = priority;
//     data['location_name'] = locationName;
//     data['status'] = status;
//     if (workType != null) {
//       data['work_type'] = workType!.toJson();
//     }
//     if (customer != null) {
//       data['customer'] = customer!.toJson();
//     }
//     return data;
//   }
// }

// class WorkType {
//   int? id;
//   String? name;

//   WorkType({this.id, this.name});

//   WorkType.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['name'] = name;
//     return data;
//   }
// }

// class Customer {
//   int? id;
//   String? customerCode;
//   String? name;
//   String? phone;
//   String? email;
//   String? locationName;

//   Customer(
//       {this.id,
//       this.customerCode,
//       this.name,
//       this.phone,
//       this.email,
//       this.locationName});

//   Customer.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     customerCode = json['customer_code'];
//     name = json['name'];
//     phone = json['phone'];
//     email = json['email'];
//     locationName = json['location_name'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['customer_code'] = customerCode;
//     data['name'] = name;
//     data['phone'] = phone;
//     data['email'] = email;
//     data['location_name'] = locationName;
//     return data;
//   }
// }

// class WorkInstance {
//   int? id;
//   int? employeeId;
//   String? scheduledDate;
//   String? plannedStartTime;
//   String? plannedEndTime;
//   String? workStatus;
//   String? otpStatus;
//   // Null? approvalStatus;

//   WorkInstance(
//       {this.id,
//       this.employeeId,
//       this.scheduledDate,
//       this.plannedStartTime,
//       this.plannedEndTime,
//       this.workStatus,
//       this.otpStatus,
//       // this.approvalStatus
//       });

//   WorkInstance.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     employeeId = json['employee_id'];
//     scheduledDate = json['scheduled_date'];
//     plannedStartTime = json['planned_start_time'];
//     plannedEndTime = json['planned_end_time'];
//     workStatus = json['work_status'];
//     otpStatus = json['otp_status'];
//     // approvalStatus = json['approval_status'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['employee_id'] = employeeId;
//     data['scheduled_date'] = scheduledDate;
//     data['planned_start_time'] = plannedStartTime;
//     data['planned_end_time'] = plannedEndTime;
//     data['work_status'] = workStatus;
//     data['otp_status'] = otpStatus;
//     // data['approval_status'] = approvalStatus;
//     return data;
//   }
// }
