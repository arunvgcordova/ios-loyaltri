class TimelineResponse {
  int? status;
  String? message;
  Data? data;

  TimelineResponse({this.status, this.message, this.data});

  TimelineResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
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
  int? employeeId;
  List<RoutePoints>? routePoints;
  List<ActivitySessions>? activitySessions;
  // List<StatusSessions>? statusSessions;

  Data({
    this.employeeId,
    this.routePoints,
    this.activitySessions,
    // this.statusSessions
  });

  Data.fromJson(Map<String, dynamic> json) {
    employeeId = json['employee_id'];
    if (json['route_points'] != null) {
      routePoints = <RoutePoints>[];
      json['route_points'].forEach((v) {
        routePoints!.add(RoutePoints.fromJson(v));
      });
    }
    if (json['activity_sessions'] != null) {
      activitySessions = <ActivitySessions>[];
      json['activity_sessions'].forEach((v) {
        activitySessions!.add(ActivitySessions.fromJson(v));
      });
    }
    // if (json['status_sessions'] != null) {
    //   statusSessions = <StatusSessions>[];
    //   json['status_sessions'].forEach((v) {
    //     statusSessions!.add(StatusSessions.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['employee_id'] = employeeId;
    if (routePoints != null) {
      data['route_points'] = routePoints!.map((v) => v.toJson()).toList();
    }
    if (activitySessions != null) {
      data['activity_sessions'] = activitySessions!
          .map((v) => v.toJson())
          .toList();
    }
    // if (statusSessions != null) {
    //   data['status_sessions'] =
    //       statusSessions!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class RoutePoints {
  int? id;
  double? latitude;
  double? longitude;
  String? speed;
  String? heading;
  String? timestamp;
  String? identityKey;

  RoutePoints({
    this.id,
    this.latitude,
    this.longitude,
    this.speed,
    this.heading,
    this.timestamp,
    this.identityKey,
  });

  RoutePoints.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    speed = json['speed'];
    heading = json['heading'];
    timestamp = json['timestamp'];
    identityKey = json['identity_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['speed'] = speed;
    data['heading'] = heading;
    data['timestamp'] = timestamp;
    data['identity_key'] = identityKey;
    return data;
  }
}

class ActivitySessions {
  int? id;
  String? activity;
  String? startTime;
  String? endTime;
  int? duration;
  bool? isActive;
  String? identityKey;
  double? latitude;
  double? longitude;
  num? distance;
  

  ActivitySessions({
    this.id,
    this.activity,
    this.startTime,
    this.endTime,
    this.duration,
    this.isActive,
    this.identityKey,
    this.latitude,
    this.longitude,
    this.distance,
  });

  ActivitySessions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    activity = json['activity'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    duration = json['duration'];
    isActive = json['is_active'];
    identityKey = json['identity_key'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    distance = json['distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['activity'] = activity;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['duration'] = duration;
    data['is_active'] = isActive;
    data['identity_key'] = identityKey;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['distance'] = distance;
    return data;
  }
}
