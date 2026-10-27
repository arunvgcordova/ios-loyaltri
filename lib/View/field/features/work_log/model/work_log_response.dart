class WorkLogResponse {
  int? status;
  String? message;
  List<Data>? data;

  WorkLogResponse({this.status, this.message, this.data});

  WorkLogResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? employeeId;
  List<CompletedWorks>? completedWorks;
  List<PendingWorks>? pendingWorks;
  List<OverdueWorks>? overdueWorks;

  Data({this.employeeId, this.completedWorks, this.pendingWorks,this.overdueWorks});

  Data.fromJson(Map<String, dynamic> json) {
    employeeId = json['employee_id'];
    if (json['completed_works'] != null) {
      completedWorks = <CompletedWorks>[];
      json['completed_works'].forEach((v) {
        completedWorks!.add(new CompletedWorks.fromJson(v));
      });
    }
    if (json['pending_works'] != null) {
      pendingWorks = <PendingWorks>[];
      json['pending_works'].forEach((v) {
        pendingWorks!.add(new PendingWorks.fromJson(v));
      });
    }
    if (json['overdue_works'] != null) {
      overdueWorks = <OverdueWorks>[];
      json['overdue_works'].forEach((v) {
        overdueWorks!.add(new OverdueWorks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employee_id'] = employeeId;
    if (completedWorks != null) {
      data['completed_works'] =
          completedWorks!.map((v) => v.toJson()).toList();
    }
    if (pendingWorks != null) {
      data['pending_works'] =
          pendingWorks!.map((v) => v.toJson()).toList();
    }
    if (overdueWorks != null) {
      data['overdue_works'] =
          overdueWorks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CompletedWorks {
  int? id;
  int? companyId;
  String? title;
  int? workType;
  int? customer;
  String? email;
  int? assignedEmployee;
  String? priority;
  String? date;
  String? startTime;
  String? endTime;
  String? location;
  LatLng? latLng;
  bool? otpEnable;
  bool? geofenceRequired;
  String? description;
  // List<String>? attachments;
  bool? repeat;
  // String? frequency;
  // String? repeatStart;
  // String? repeatEnd;
  // bool? noEndDate;
  // List<Null>? days;
  // List<Null>? customDates;
  String? status;
  List<Instances>? instances;
  WorkTypeDetail? workTypeDetail;
  CustomerDetail? customerDetail;
  // String? createdAt;
  // String? updatedAt;

  CompletedWorks(
      {this.id,
        this.companyId,
        this.title,
        this.workType,
        this.customer,
        this.email,
        this.assignedEmployee,
        this.priority,
        this.date,
        this.startTime,
        this.endTime,
        this.location,
        this.latLng,
        this.otpEnable,
        this.geofenceRequired,
        this.description,
        // this.attachments,
        this.repeat,
        // this.frequency,
        // this.repeatStart,
        // this.repeatEnd,
        // this.noEndDate,
        // this.days,
        // this.customDates,
        this.status,
        this.instances,
        this.workTypeDetail,
        this.customerDetail,
        // this.createdAt,
        // this.updatedAt
      });

  CompletedWorks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['companyId'];
    title = json['title'];
    workType = json['workType'];
    customer = json['customer'];
    email = json['email'];
    assignedEmployee = json['assignedEmployee'];
    priority = json['priority'];
    date = json['date'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    location = json['location'];
    latLng =
    json['latLng'] != null ? new LatLng.fromJson(json['latLng']) : null;
    otpEnable = json['otpEnable'];
    geofenceRequired = json['geofenceRequired'];
    description = json['description'];
    // attachments = json['attachments'].cast<String>();
    repeat = json['repeat'];
    // frequency = json['frequency'];
    // repeatStart = json['repeatStart'];
    // repeatEnd = json['repeatEnd'];
    // noEndDate = json['noEndDate'];
    // if (json['days'] != null) {
    //   days = <Null>[];
    //   json['days'].forEach((v) {
    //     days!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['customDates'] != null) {
    //   customDates = <Null>[];
    //   json['customDates'].forEach((v) {
    //     customDates!.add(new Null.fromJson(v));
    //   });
    // }
    status = json['status'];
    if (json['instances'] != null) {
      instances = <Instances>[];
      json['instances'].forEach((v) {
        instances!.add(new Instances.fromJson(v));
      });
    }
    workTypeDetail = json['workTypeDetail'] != null
        ? new WorkTypeDetail.fromJson(json['workTypeDetail'])
        : null;
    customerDetail = json['customerDetail'] != null
        ? new CustomerDetail.fromJson(json['customerDetail'])
        : null;
    // createdAt = json['created_at'];
    // updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['companyId'] = companyId;
    data['title'] = title;
    data['workType'] = workType;
    data['customer'] = customer;
    data['email'] = email;
    data['assignedEmployee'] = assignedEmployee;
    data['priority'] = priority;
    data['date'] = date;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['location'] = location;
    if (latLng != null) {
      data['latLng'] = latLng!.toJson();
    }
    data['otpEnable'] = otpEnable;
    data['geofenceRequired'] = geofenceRequired;
    data['description'] = description;
    // data['attachments'] = attachments;
    data['repeat'] = repeat;
    // data['frequency'] = frequency;
    // data['repeatStart'] = repeatStart;
    // data['repeatEnd'] = repeatEnd;
    // data['noEndDate'] = noEndDate;
    // if (days != null) {
    //   data['days'] = days!.map((v) => v.toJson()).toList();
    // }
    // if (customDates != null) {
    //   data['customDates'] = customDates!.map((v) => v.toJson()).toList();
    // }
    data['status'] = status;
    if (instances != null) {
      data['instances'] = instances!.map((v) => v.toJson()).toList();
    }
    if (workTypeDetail != null) {
      data['workTypeDetail'] = workTypeDetail!.toJson();
    }
    if (customerDetail != null) {
      data['customerDetail'] = customerDetail!.toJson();
    }
    // data['created_at'] = createdAt;
    // data['updated_at'] = updatedAt;
    return data;
  }
}

class LatLng {
  double? lat;
  double? lng;

  LatLng({this.lat, this.lng});

  LatLng.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}

class Instances {
  int? id;
  int? employeeId;
  String? scheduledDate;
  String? plannedStartTime;
  String? plannedEndTime;
  String? workStatus;
  String? otpStatus;
  // Null? approvalStatus;

  Instances(
      {this.id,
        this.employeeId,
        this.scheduledDate,
        this.plannedStartTime,
        this.plannedEndTime,
        this.workStatus,
        this.otpStatus,
        // this.approvalStatus
      });

  Instances.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employee_id'];
    scheduledDate = json['scheduled_date'];
    plannedStartTime = json['planned_start_time'];
    plannedEndTime = json['planned_end_time'];
    workStatus = json['work_status'];
    otpStatus = json['otp_status'];
    // approvalStatus = json['approval_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['employee_id'] = employeeId;
    data['scheduled_date'] = scheduledDate;
    data['planned_start_time'] = plannedStartTime;
    data['planned_end_time'] = plannedEndTime;
    data['work_status'] = workStatus;
    data['otp_status'] = otpStatus;
    // data['approval_status'] = approvalStatus;
    return data;
  }
}

class WorkTypeDetail {
  int? id;
  String? name;
  int? companyId;

  WorkTypeDetail({this.id, this.name, this.companyId});

  WorkTypeDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    companyId = json['company_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['company_id'] = companyId;
    return data;
  }
}

class CustomerDetail {
  int? id;
  int? companyId;
  String? customerCode;
  String? name;
  String? phone;
  String? email;
  LatLng? location;
  String? locationName;
  int? createdBy;
  String? employeeAssignType;
  // List<int>? assignedEmployeeIds;
  String? status;
  String? profilePhoto;
  String? createdAt;
  String? updatedAt;
  DynamicFields? dynamicFields;

  CustomerDetail(
      {this.id,
        this.companyId,
        this.customerCode,
        this.name,
        this.phone,
        this.email,
        this.location,
        this.locationName,
        this.createdBy,
        this.employeeAssignType,
        // this.assignedEmployeeIds,
        this.status,
        this.profilePhoto,
        this.createdAt,
        this.updatedAt,
        this.dynamicFields});

  CustomerDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    customerCode = json['customer_code'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    location =
    json['location'] != null ? new LatLng.fromJson(json['location']) : null;
    locationName = json['location_name'];
    createdBy = json['created_by'];
    employeeAssignType = json['employee_assign_type'];
    // assignedEmployeeIds = json['assigned_employee_ids'].cast<int>();
    status = json['status'];
    profilePhoto = json['profile_photo'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    dynamicFields = json['dynamic_fields'] != null
        ? new DynamicFields.fromJson(json['dynamic_fields'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['company_id'] = companyId;
    data['customer_code'] = customerCode;
    data['name'] = name;
    data['phone'] = phone;
    data['email'] = email;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['location_name'] = locationName;
    data['created_by'] = createdBy;
    data['employee_assign_type'] = employeeAssignType;
    // data['assigned_employee_ids'] = assignedEmployeeIds;
    data['status'] = status;
    data['profile_photo'] = profilePhoto;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (dynamicFields != null) {
      data['dynamic_fields'] = dynamicFields!.toJson();
    }
    return data;
  }
}

class DynamicFields {
  String? locationName;
  String? pointOfContactName;
  String? pocContactNumber;
  String? emailId;
  // List<String>? otpEnabled;
  String? notes;

  DynamicFields(
      {this.locationName,
        this.pointOfContactName,
        this.pocContactNumber,
        this.emailId,
        // this.otpEnabled,
        this.notes});

  DynamicFields.fromJson(Map<String, dynamic> json) {
    locationName = json['location_name'];
    pointOfContactName = json['point_of_contact_name'];
    pocContactNumber = json['poc_contact_number'];
    emailId = json['email_id'];
    // otpEnabled = json['otp_enabled'].cast<String>();
    notes = json['notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['location_name'] = locationName;
    data['point_of_contact_name'] = pointOfContactName;
    data['poc_contact_number'] = pocContactNumber;
    data['email_id'] = emailId;
    // data['otp_enabled'] = otpEnabled;
    data['notes'] = notes;
    return data;
  }
}

class PendingWorks {
  int? id;
  int? companyId;
  String? title;
  int? workType;
  int? customer;
  String? email;
  int? assignedEmployee;
  String? priority;
  String? date;
  String? startTime;
  String? endTime;
  String? location;
  LatLng? latLng;
  bool? otpEnable;
  bool? geofenceRequired;
  String? description;
  // List<String>? attachments;
  bool? repeat;
  // Null? frequency;
  // String? repeatStart;
  // String? repeatEnd;
  // bool? noEndDate;
  // List<Null>? days;
  // List<Null>? customDates;
  String? status;
  List<Instances>? instances;
  WorkTypeDetail? workTypeDetail;
  CustomerDetail? customerDetail;
  // String? createdAt;
  // String? updatedAt;

  PendingWorks(
      {this.id,
        this.companyId,
        this.title,
        this.workType,
        this.customer,
        this.email,
        this.assignedEmployee,
        this.priority,
        this.date,
        this.startTime,
        this.endTime,
        this.location,
        this.latLng,
        this.otpEnable,
        this.geofenceRequired,
        this.description,
        // this.attachments,
        this.repeat,
        // this.frequency,
        // this.repeatStart,
        // this.repeatEnd,
        // this.noEndDate,
        // this.days,
        // this.customDates,
        this.status,
        this.instances,
        this.workTypeDetail,
        this.customerDetail,
        // this.createdAt,
        // this.updatedAt
      });

  PendingWorks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['companyId'];
    title = json['title'];
    workType = json['workType'];
    customer = json['customer'];
    email = json['email'];
    assignedEmployee = json['assignedEmployee'];
    priority = json['priority'];
    date = json['date'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    location = json['location'];
    latLng =
    json['latLng'] != null ? new LatLng.fromJson(json['latLng']) : null;
    otpEnable = json['otpEnable'];
    geofenceRequired = json['geofenceRequired'];
    description = json['description'];
    // attachments = json['attachments'].cast<String>();
    repeat = json['repeat'];
    // frequency = json['frequency'];
    // repeatStart = json['repeatStart'];
    // repeatEnd = json['repeatEnd'];
    // noEndDate = json['noEndDate'];
    // if (json['days'] != null) {
    //   days = <Null>[];
    //   json['days'].forEach((v) {
    //     days!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['customDates'] != null) {
    //   customDates = <Null>[];
    //   json['customDates'].forEach((v) {
    //     customDates!.add(new Null.fromJson(v));
    //   });
    // }
    status = json['status'];
    if (json['instances'] != null) {
      instances = <Instances>[];
      json['instances'].forEach((v) {
        instances!.add(new Instances.fromJson(v));
      });
    }
    workTypeDetail = json['workTypeDetail'] != null
        ? new WorkTypeDetail.fromJson(json['workTypeDetail'])
        : null;
    customerDetail = json['customerDetail'] != null
        ? new CustomerDetail.fromJson(json['customerDetail'])
        : null;
    // createdAt = json['created_at'];
    // updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['companyId'] = companyId;
    data['title'] = title;
    data['workType'] = workType;
    data['customer'] = customer;
    data['email'] = email;
    data['assignedEmployee'] = assignedEmployee;
    data['priority'] = priority;
    data['date'] = date;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['location'] = location;
    if (latLng != null) {
      data['latLng'] = latLng!.toJson();
    }
    data['otpEnable'] = otpEnable;
    data['geofenceRequired'] = geofenceRequired;
    data['description'] = description;
    // data['attachments'] = attachments;
    data['repeat'] = repeat;
    // data['frequency'] = this.frequency;
    // data['repeatStart'] = this.repeatStart;
    // data['repeatEnd'] = this.repeatEnd;
    // data['noEndDate'] = this.noEndDate;
    // if (this.days != null) {
    //   data['days'] = this.days!.map((v) => v.toJson()).toList();
    // }
    // if (this.customDates != null) {
    //   data['customDates'] = this.customDates!.map((v) => v.toJson()).toList();
    // }
    data['status'] = status;
    if (instances != null) {
      data['instances'] = instances!.map((v) => v.toJson()).toList();
    }
    if (workTypeDetail != null) {
      data['workTypeDetail'] = workTypeDetail!.toJson();
    }
    if (customerDetail != null) {
      data['customerDetail'] = customerDetail!.toJson();
    }
    // data['created_at'] = this.createdAt;
    // data['updated_at'] = this.updatedAt;
    return data;
  }
}

class OverdueWorks {
  int? id;
  int? companyId;
  String? title;
  int? workType;
  int? customer;
  String? email;
  int? assignedEmployee;
  int? createdBy;
  String? priority;
  String? date;
  String? startTime;
  String? endTime;
  String? location;
  LatLng? latLng;
  bool? otpEnable;
  bool? geofenceRequired;
  String? description;
  // List<Null>? attachments;
  bool? repeat;
  // String? frequency;
  // String? repeatStart;
  // String? repeatEnd;
  // bool? noEndDate;
  // List<Null>? days;
  // List<Null>? customDates;
  String? status;
  List<Instances>? instances;
  WorkTypeDetail? workTypeDetail;
  CustomerDetail? customerDetail;
  // String? createdAt;
  // String? updatedAt;

  OverdueWorks(
      {this.id,
        this.companyId,
        this.title,
        this.workType,
        this.customer,
        this.email,
        this.assignedEmployee,
        this.createdBy,
        this.priority,
        this.date,
        this.startTime,
        this.endTime,
        this.location,
        // this.latLng,
        this.otpEnable,
        this.geofenceRequired,
        this.description,
        // this.attachments,
        this.repeat,
        // this.frequency,
        // this.repeatStart,
        // this.repeatEnd,
        // this.noEndDate,
        // this.days,
        // this.customDates,
        this.status,
        this.instances,
        this.workTypeDetail,
        this.customerDetail,
        // this.createdAt,
        // this.updatedAt
      });

  OverdueWorks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['companyId'];
    title = json['title'];
    workType = json['workType'];
    customer = json['customer'];
    email = json['email'];
    assignedEmployee = json['assignedEmployee'];
    createdBy = json['createdBy'];
    priority = json['priority'];
    date = json['date'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    location = json['location'];
    // latLng =
    //     json['latLng'] != null ? new Location.fromJson(json['latLng']) : null;
    otpEnable = json['otpEnable'];
    geofenceRequired = json['geofenceRequired'];
    description = json['description'];
    // if (json['attachments'] != null) {
    //   attachments = <Null>[];
    //   json['attachments'].forEach((v) {
    //     attachments!.add(new Null.fromJson(v));
    //   });
    // }
    repeat = json['repeat'];
    // frequency = json['frequency'];
    // repeatStart = json['repeatStart'];
    // repeatEnd = json['repeatEnd'];
    // noEndDate = json['noEndDate'];
    // if (json['days'] != null) {
    //   days = <Null>[];
    //   json['days'].forEach((v) {
    //     days!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['customDates'] != null) {
    //   customDates = <Null>[];
    //   json['customDates'].forEach((v) {
    //     customDates!.add(new Null.fromJson(v));
    //   });
    // }
    status = json['status'];
    if (json['instances'] != null) {
      instances = <Instances>[];
      json['instances'].forEach((v) {
        instances!.add(new Instances.fromJson(v));
      });
    }
    workTypeDetail = json['workTypeDetail'] != null
        ? new WorkTypeDetail.fromJson(json['workTypeDetail'])
        : null;
    customerDetail = json['customerDetail'] != null
        ? new CustomerDetail.fromJson(json['customerDetail'])
        : null;
    // createdAt = json['created_at'];
    // updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['companyId'] = companyId;
    data['title'] = title;
    data['workType'] = workType;
    data['customer'] = customer;
    data['email'] = email;
    data['assignedEmployee'] = assignedEmployee;
    data['createdBy'] = createdBy;
    data['priority'] = priority;
    data['date'] = date;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    // data['location'] = this.location;
    // if (this.latLng != null) {
    //   data['latLng'] = this.latLng!.toJson();
    // }
    data['otpEnable'] = otpEnable;
    data['geofenceRequired'] = geofenceRequired;
    data['description'] = description;
    // if (this.attachments != null) {
    //   data['attachments'] = this.attachments!.map((v) => v.toJson()).toList();
    // }
    data['repeat'] = repeat;
    // data['frequency'] = frequency;
    // data['repeatStart'] = repeatStart;
    // data['repeatEnd'] = repeatEnd;
    // data['noEndDate'] = noEndDate;
    // if (days != null) {
    //   data['days'] = days!.map((v) => v.toJson()).toList();
    // }
    // if (customDates != null) {
    //   data['customDates'] = customDates!.map((v) => v.toJson()).toList();
    // }
    data['status'] = status;
    if (instances != null) {
      data['instances'] = instances!.map((v) => v.toJson()).toList();
    }
    if (workTypeDetail != null) {
      data['workTypeDetail'] = workTypeDetail!.toJson();
    }
    if (customerDetail != null) {
      data['customerDetail'] = customerDetail!.toJson();
    }
    // data['created_at'] = createdAt;
    // data['updated_at'] = updatedAt;
    return data;
  }
}