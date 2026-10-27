class InprogressWorkResponse {
  int? status;
  String? message;
  Data? data;

  InprogressWorkResponse({this.status, this.message, this.data});

  InprogressWorkResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  int? companyId;
  int? employeeId;
  bool? hasInProgress;
  List<Works>? works;

  Data({this.companyId, this.employeeId, this.hasInProgress, this.works});

  Data.fromJson(Map<String, dynamic> json) {
    companyId = json['company_id'];
    employeeId = json['employee_id'];
    hasInProgress = json['has_in_progress'];
    if (json['works'] != null) {
      works = <Works>[];
      json['works'].forEach((v) {
        works!.add(new Works.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['company_id'] = companyId;
    data['employee_id'] = employeeId;
    data['has_in_progress'] = hasInProgress;
    if (works != null) {
      data['works'] = works!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Works {
  int? instanceId;
  int? workId;
  int? employeeId;
  String? scheduledDate;
  String? plannedStartTime;
  // String? plannedEndTime;
  // String? actualStartTime;
  // Null? actualEndTime;
  // String? workStatus;
  // String? otpStatus;
  // Null? approvalStatus;
  Work? work;

  Works(
      {this.instanceId,
      this.workId,
      this.employeeId,
      this.scheduledDate,
      this.plannedStartTime,
      // this.plannedEndTime,
      // this.actualStartTime,
      // this.actualEndTime,
      // this.workStatus,
      // this.otpStatus,
      // this.approvalStatus,
      this.work});

  Works.fromJson(Map<String, dynamic> json) {
    instanceId = json['instance_id'];
    workId = json['work_id'];
    employeeId = json['employee_id'];
    scheduledDate = json['scheduled_date'];
    plannedStartTime = json['planned_start_time'];
    // plannedEndTime = json['planned_end_time'];
    // actualStartTime = json['actual_start_time'];
    // actualEndTime = json['actual_end_time'];
    // workStatus = json['work_status'];
    // otpStatus = json['otp_status'];
    // approvalStatus = json['approval_status'];
    work = json['work'] != null ? new Work.fromJson(json['work']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['instance_id'] = instanceId;
    data['work_id'] = workId;
    data['employee_id'] = employeeId;
    data['scheduled_date'] = scheduledDate;
    data['planned_start_time'] = plannedStartTime;
    // data['planned_end_time'] = plannedEndTime;
    // data['actual_start_time'] = actualStartTime;
    // data['actual_end_time'] = actualEndTime;
    // data['work_status'] = workStatus;
    // data['otp_status'] = otpStatus;
    // data['approval_status'] = approvalStatus;
    if (work != null) {
      data['work'] = work!.toJson();
    }
    return data;
  }
}

class Work {
  int? id;
  // int? companyId;
  String? title;
  // String? priority;
  // String? description;
  // String? location;
  // LatLng? latLng;
  // bool? otpEnable;
  // bool? geofenceRequired;
  // WorkType? workType;
  // Customer? customer;

  Work(
      {this.id,
      // this.companyId,
      this.title,
      // this.priority,
      // this.description,
      // this.location,
      // this.latLng,
      // this.otpEnable,
      // this.geofenceRequired,
      // this.workType,
      // this.customer
      });

  Work.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    // companyId = json['company_id'];
    title = json['title'];
    // priority = json['priority'];
    // description = json['description'];
    // location = json['location'];
    // latLng =
    //     json['latLng'] != null ? new LatLng.fromJson(json['latLng']) : null;
    // otpEnable = json['otp_enable'];
    // geofenceRequired = json['geofence_required'];
    // workType = json['work_type'] != null
    //     ? new WorkType.fromJson(json['work_type'])
    //     : null;
    // customer = json['customer'] != null
    //     ? new Customer.fromJson(json['customer'])
    //     : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    // data['company_id'] = companyId;
    data['title'] = title;
    // data['priority'] = priority;
    // data['description'] = description;
    // data['location'] = location;
    // if (latLng != null) {
    //   data['latLng'] = latLng!.toJson();
    // }
    // data['otp_enable'] = otpEnable;
    // data['geofence_required'] = geofenceRequired;
    // if (workType != null) {
    //   data['work_type'] = workType!.toJson();
    // }
    // if (customer != null) {
    //   data['customer'] = customer!.toJson();
    // }
    return data;
  }
}
