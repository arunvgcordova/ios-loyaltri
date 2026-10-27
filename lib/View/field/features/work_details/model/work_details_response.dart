class WorkDetailsResponse {
  int? status;
  String? message;
  WorkData? data;

  WorkDetailsResponse({this.status, this.message, this.data});

  WorkDetailsResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? WorkData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class WorkData {
  int? id;
  int? companyId;
  String? title;
  int? workType;
  int? customer;
  // Null? email;
  // int? assignedEmployee;
  int? createdBy;
  String? priority;
  // Null? date;
  String? startTime;
  String? endTime;
  String? location;
  LatLng? latLng;
  bool? otpEnable;
  bool? geofenceRequired;
  String? description;
  List<Attachments>? attachments;
  // bool? repeat;
  // String? frequency;
  // String? repeatStart;
  // String? repeatEnd;
  // bool? noEndDate;
  // List<Null>? days;
  // List<Null>? customDates;
  // String? status;
  List<Instances>? instances;
  WorkTypeDetail? workTypeDetail;
  CustomerDetail? customerDetail;
  // String? createdAt;
  // String? updatedAt;

  WorkData({
    this.id,
    this.companyId,
    this.title,
    this.workType,
    this.customer,
    // this.email,
    // this.assignedEmployee,
    this.createdBy,
    this.priority,
    // this.date,
    this.startTime,
    this.endTime,
    this.location,
    this.latLng,
    this.otpEnable,
    this.geofenceRequired,
    this.description,
    this.attachments,
    // this.repeat,
    // this.frequency,
    // this.repeatStart,
    // this.repeatEnd,
    // this.noEndDate,
    // this.days,
    // this.customDates,
    // this.status,
    this.instances,
    this.workTypeDetail,
    this.customerDetail,
    // this.createdAt,
    // this.updatedAt,
  });

  WorkData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['companyId'];
    title = json['title'];
    workType = json['workType'];
    customer = json['customer'];
    // email = json['email'];
    // assignedEmployee = json['assignedEmployee'];
    createdBy = json['createdBy'];
    priority = json['priority'];
    // date = json['date'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    location = json['location'];
    latLng = json['latLng'] != null ? LatLng.fromJson(json['latLng']) : null;
    otpEnable = json['otpEnable'];
    geofenceRequired = json['geofenceRequired'];
    description = json['description'];
    if (json['attachments'] != null) {
      attachments = <Attachments>[];
      json['attachments'].forEach((v) {
        attachments!.add(new Attachments.fromJson(v));
      });
    }
    // repeat = json['repeat'];
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
    // status = json['status'];
    if (json['instances'] != null) {
      instances = <Instances>[];
      json['instances'].forEach((v) {
        instances!.add(Instances.fromJson(v));
      });
    }
    workTypeDetail = json['workTypeDetail'] != null
        ? WorkTypeDetail.fromJson(json['workTypeDetail'])
        : null;
    customerDetail = json['customerDetail'] != null
        ? CustomerDetail.fromJson(json['customerDetail'])
        : null;
    // createdAt = json['created_at'];
    // updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['companyId'] = companyId;
    data['title'] = title;
    data['workType'] = workType;
    data['customer'] = customer;
    // data['email'] = this.email;
    // data['assignedEmployee'] = assignedEmployee;
    data['createdBy'] = createdBy;
    data['priority'] = priority;
    // data['date'] = this.date;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['location'] = location;
    // data['latLng'] = latLng;
    if (latLng != null) {
      data['latLng'] = latLng!.toJson();
    }
    data['otpEnable'] = otpEnable;
    data['geofenceRequired'] = geofenceRequired;
    data['description'] = description;
    if (this.attachments != null) {
      data['attachments'] = this.attachments!.map((v) => v.toJson()).toList();
    }
    // data['repeat'] = repeat;
    // data['frequency'] = frequency;
    // data['repeatStart'] = repeatStart;
    // data['repeatEnd'] = repeatEnd;
    // data['noEndDate'] = noEndDate;
    // if (this.days != null) {
    //   data['days'] = this.days!.map((v) => v.toJson()).toList();
    // }
    // if (this.customDates != null) {
    //   data['customDates'] = this.customDates!.map((v) => v.toJson()).toList();
    // }
    // data['status'] = status;
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
    final Map<String, dynamic> data = <String, dynamic>{};
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
  List<OverrideRequests>? overrideRequests;
  // Null? approvalStatus;

  Instances({
    this.id,
    this.employeeId,
    this.scheduledDate,
    this.plannedStartTime,
    this.plannedEndTime,
    this.workStatus,
    this.otpStatus,
    this.overrideRequests
    // this.approvalStatus,
  });

  Instances.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employee_id'];
    scheduledDate = json['scheduled_date'];
    plannedStartTime = json['planned_start_time'];
    plannedEndTime = json['planned_end_time'];
    workStatus = json['work_status'];
    otpStatus = json['otp_status'];
    if (json['override_requests'] != null) {
      overrideRequests = <OverrideRequests>[];
      json['override_requests'].forEach((v) {
        overrideRequests!.add(new OverrideRequests.fromJson(v));
      });
    }
    // approvalStatus = json['approval_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['employee_id'] = employeeId;
    data['scheduled_date'] = scheduledDate;
    data['planned_start_time'] = plannedStartTime;
    data['planned_end_time'] = plannedEndTime;
    data['work_status'] = workStatus;
    data['otp_status'] = otpStatus;
    // data['approval_status'] = approvalStatus;
    if (this.overrideRequests != null) {
      data['override_requests'] =
          this.overrideRequests!.map((v) => v.toJson()).toList();
    }
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
    final Map<String, dynamic> data = <String, dynamic>{};
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
  int? createdBy;
  String? employeeAssignType;
  // List<int>? assignedEmployeeIds;
  String? status;
  String? profilePhoto;
  // String? createdAt;
  // String? updatedAt;
  DynamicFields? dynamicFields;
  String? name;
  String? phone;
  String? email;
  Location? location;
  String? locationName;

  CustomerDetail({
    this.id,
    this.companyId,
    this.customerCode,
    this.createdBy,
    this.employeeAssignType,
    // this.assignedEmployeeIds,
    this.status,
    this.profilePhoto,
    // this.createdAt,
    // this.updatedAt,
    this.dynamicFields,
    this.name,
    this.phone,
    this.email,
    this.location,
    this.locationName,
  });

  CustomerDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    customerCode = json['customer_code'];
    createdBy = json['created_by'];
    employeeAssignType = json['employee_assign_type'];
    // assignedEmployeeIds = json['assigned_employee_ids'].cast<int>();
    status = json['status'];
    profilePhoto = json['profile_photo'];
    // createdAt = json['created_at'];
    // updatedAt = json['updated_at'];
    dynamicFields = json['dynamic_fields'] != null
        ? DynamicFields.fromJson(json['dynamic_fields'])
        : null;
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    locationName = json['location_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['company_id'] = companyId;
    data['customer_code'] = customerCode;
    data['created_by'] = createdBy;
    data['employee_assign_type'] = employeeAssignType;
    // data['assigned_employee_ids'] = assignedEmployeeIds;
    data['status'] = status;
    data['profile_photo'] = profilePhoto;
    // data['created_at'] = createdAt;
    // data['updated_at'] = updatedAt;
    if (dynamicFields != null) {
      data['dynamic_fields'] = dynamicFields!.toJson();
    }
    data['name'] = name;
    data['phone'] = phone;
    data['email'] = email;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['location_name'] = locationName;
    return data;
  }
}

class DynamicFields {
  String? locationName;
  String? name;
  String? phoneNumber;
  // String? pointOfContactName;
  // String? pocContactNumber;
  String? emailId;
  Location? location;
  // List<String>? otpEnabled;
  // String? notes;
  // String? sdfe;

  DynamicFields({
    this.locationName,
    this.name,
    this.phoneNumber,
    // this.pointOfContactName,
    // this.pocContactNumber,
    this.emailId,
    this.location,
    // this.otpEnabled,
    // this.notes,
    // this.sdfe,
  });

  DynamicFields.fromJson(Map<String, dynamic> json) {
    locationName = json['location_name'];
    name = json['name'];
    phoneNumber = json['phone_number'];
    // pointOfContactName = json['point_of_contact_name'];
    // pocContactNumber = json['poc_contact_number'];
    emailId = json['email_id'];
    location = json['location'] != null
        ? Location.fromJson(json['location'])
        : null;
    // otpEnabled = json['otp_enabled'].cast<String>();
    // notes = json['notes'];
    // sdfe = json['sdfe'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['location_name'] = locationName;
    data['name'] = name;
    data['phone_number'] = phoneNumber;
    // data['point_of_contact_name'] = pointOfContactName;
    // data['poc_contact_number'] = pocContactNumber;
    data['email_id'] = emailId;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    // data['otp_enabled'] = otpEnabled;
    // data['notes'] = notes;
    // data['sdfe'] = sdfe;
    return data;
  }
}

class Location {
  double? lat;
  double? lng;

  Location({this.lat, this.lng});

  Location.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}

class Attachments {
  String? accessPath;
  String? name;
  int? size;

  Attachments({this.accessPath, this.name, this.size});

  Attachments.fromJson(Map<String, dynamic> json) {
    accessPath = json['access_path'];
    name = json['name'];
    size = json['size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_path'] = this.accessPath;
    data['name'] = this.name;
    data['size'] = this.size;
    return data;
  }
}

class OverrideRequests {
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

  OverrideRequests(
      {this.id,
      this.workId,
      this.workInstanceId,
      this.overrideFor,
      this.status,
      this.note,
      this.requestDatetime,
      this.requestBy,
      // this.approvedBy,
      // this.approvedDatetime
      });

  OverrideRequests.fromJson(Map<String, dynamic> json) {
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['work_id'] = this.workId;
    data['work_instance_id'] = this.workInstanceId;
    data['override_for'] = this.overrideFor;
    data['status'] = this.status;
    data['note'] = this.note;
    data['request_datetime'] = this.requestDatetime;
    data['request_by'] = this.requestBy;
    // data['approved_by'] = this.approvedBy;
    // data['approved_datetime'] = this.approvedDatetime;
    return data;
  }
}
