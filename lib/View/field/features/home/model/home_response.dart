import 'package:loyaltri_minimal/View/field/features/work_details/model/work_details_response.dart';

class HomeResponse {
  int? status;
  String? message;
  HomeData? data;

  HomeResponse({this.status, this.message, this.data});

  HomeResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? HomeData.fromJson(json['data']) : null;
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

class HomeData {
  int? employeeId;
  String? frequency;
  Range? range;
  WorkOverview? workOverview;
  Highlights? highlights;

  HomeData({
    this.employeeId,
    this.frequency,
    this.range,
    this.workOverview,
    this.highlights,
  });

  HomeData.fromJson(Map<String, dynamic> json) {
    employeeId = json['employee_id'];
    frequency = json['frequency'];
    range = json['range'] != null ? Range.fromJson(json['range']) : null;
    workOverview = json['work_overview'] != null
        ? WorkOverview.fromJson(json['work_overview'])
        : null;
    highlights = json['highlights'] != null
        ? Highlights.fromJson(json['highlights'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['employee_id'] = employeeId;
    data['frequency'] = frequency;
    if (range != null) {
      data['range'] = range!.toJson();
    }
    if (workOverview != null) {
      data['work_overview'] = workOverview!.toJson();
    }
    if (highlights != null) {
      data['highlights'] = highlights!.toJson();
    }
    return data;
  }
}

class Range {
  String? startDate;
  String? endDate;

  Range({this.startDate, this.endDate});

  Range.fromJson(Map<String, dynamic> json) {
    startDate = json['start_date'];
    endDate = json['end_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    return data;
  }
}

class WorkOverview {
  int? total;
  int? pending;
  int? done;
  int? overdue;

  WorkOverview({this.total, this.pending, this.done, this.overdue});

  WorkOverview.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    pending = json['pending'];
    done = json['done'];
    overdue = json['overdue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['pending'] = pending;
    data['done'] = done;
    data['overdue'] = overdue;
    return data;
  }
}

class Highlights {
  InProgressWork? inProgressWork;
  InProgressWork? nextUpcomingWork;
  bool? hasNoWork;

  Highlights({this.inProgressWork, this.nextUpcomingWork, this.hasNoWork});

  Highlights.fromJson(Map<String, dynamic> json) {
    inProgressWork = json['in_progress_work'] != null
        ? InProgressWork.fromJson(json['in_progress_work'])
        : null;
    nextUpcomingWork = json['next_upcoming_work'] != null
        ? InProgressWork.fromJson(json['next_upcoming_work'])
        : null;
    hasNoWork = json['has_no_work'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (inProgressWork != null) {
      data['in_progress_work'] = inProgressWork!.toJson();
    }
    if (nextUpcomingWork != null) {
      data['next_upcoming_work'] = nextUpcomingWork!.toJson();
    }
    data['has_no_work'] = hasNoWork;
    return data;
  }
}

class InProgressWork {
  int? instanceId;
  int? workId;
  String? workStatus;
  String? scheduledDate;
  String? plannedStartTime;
  String? plannedEndTime;
  String? actualStartTime;
  String? actualEndTime;
  Work? work;
  // List<OverrideRequests>? overrideRequests;
  String? otpOverrideRequestStatus;
  String? geofenceStatusOverrideRequestStatus;

  InProgressWork({
    this.instanceId,
    this.workId,
    this.workStatus,
    this.scheduledDate,
    this.plannedStartTime,
    this.plannedEndTime,
    this.actualStartTime,
    this.actualEndTime,
    this.work,
    this.otpOverrideRequestStatus,
    this.geofenceStatusOverrideRequestStatus,
    // this.overrideRequests,
  });

  InProgressWork.fromJson(Map<String, dynamic> json) {
    instanceId = json['instance_id'];
    workId = json['work_id'];
    workStatus = json['work_status'];
    scheduledDate = json['scheduled_date'];
    plannedStartTime = json['planned_start_time'];
    plannedEndTime = json['planned_end_time'];
    actualStartTime = json['actual_start_time'];
    actualEndTime = json['actual_end_time'];
    work = json['work'] != null ? Work.fromJson(json['work']) : null;
    otpOverrideRequestStatus = json['otp_override_request_status'];
    geofenceStatusOverrideRequestStatus =
        json['geofence_status_override_request_status'];
    //  if (json['override_requests'] != null) {
    //   overrideRequests = <OverrideRequests>[];
    //   json['override_requests'].forEach((v) {
    //     overrideRequests!.add(new OverrideRequests.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['instance_id'] = instanceId;
    data['work_id'] = workId;
    data['work_status'] = workStatus;
    data['scheduled_date'] = scheduledDate;
    data['planned_start_time'] = plannedStartTime;
    data['planned_end_time'] = plannedEndTime;
    data['actual_end_time'] = actualEndTime;
    data['planned_end_time'] = plannedEndTime;
    if (work != null) {
      data['work'] = work!.toJson();
    }
    data['otp_override_request_status'] = otpOverrideRequestStatus;
    data['geofence_status_override_request_status'] =
        geofenceStatusOverrideRequestStatus;
    // if (this.overrideRequests != null) {
    //   data['override_requests'] =
    //       this.overrideRequests!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class Work {
  int? id;
  String? title;
  String? location;
  LatLng? latLng;
  WorkType? workType;
  Customer? customer;
  bool? otpEnable;
  bool? geofenceRequired;

  Work({
    this.id,
    this.title,
    this.location,
    this.latLng,
    this.workType,
    this.customer,
    this.otpEnable,
    this.geofenceRequired,
  });

  Work.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    location = json['location'];
    latLng = json['latLng'] != null
        ? LatLng.fromJson(json['latLng'])
        : null;
    workType = json['work_type'] != null
        ? WorkType.fromJson(json['work_type'])
        : null;
    customer = json['customer'] != null
        ? Customer.fromJson(json['customer'])
        : null;
    otpEnable = json['otp_enable'];
    geofenceRequired = json['geofence_required'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['location'] = location;
    if (latLng != null) {
      data['latLng'] = latLng!.toJson();
    }
    if (workType != null) {
      data['work_type'] = workType!.toJson();
    }
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    data['otp_enable'] = otpEnable;
    data['geofence_required'] = geofenceRequired;
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
    final Map<String, dynamic> data = <String, dynamic>{};
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
  Location? location;
  String? locationName;

  Customer({
    this.id,
    this.customerCode,
    this.name,
    this.phone,
    this.location,
    this.locationName,
  });

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerCode = json['customer_code'];
    name = json['name'];
    phone = json['phone'];
    location = json['location'] != null
        ? Location.fromJson(json['location'])
        : null;
    locationName = json['location_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['customer_code'] = customerCode;
    data['name'] = name;
    data['phone'] = phone;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['location_name'] = locationName;
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
