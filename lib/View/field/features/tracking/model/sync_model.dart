class SynModel {
  int? employeeId;
  List<RoutePoints>? routePoints;
  List<ActivitySessions>? activitySessions;

  SynModel({this.employeeId, this.routePoints, this.activitySessions});

  SynModel.fromJson(Map<String, dynamic> json) {
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['employee_id'] = employeeId;
    if (routePoints != null) {
      data['route_points'] = routePoints!.map((v) => v.toJson()).toList();
    }
    if (activitySessions != null) {
      data['activity_sessions'] = activitySessions!
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}

class RoutePoints {
  int? id;
  double? latitude;
  double? longitude;
  double? speed;
  double? heading;
  String? timestamp;
  bool? isCharging;
  double? batteryLevel;
  String? identityKey;
  int? companyId;
  double? odometer;

  RoutePoints({
    this.id,
    this.latitude,
    this.longitude,
    this.speed,
    this.heading,
    this.timestamp,
    this.isCharging,
    this.batteryLevel,
    this.identityKey,
    this.companyId,
    this.odometer
  });

  RoutePoints.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    speed = json['speed'];
    heading = json['heading'];
    timestamp = json['timestamp'];
    isCharging = json['is_charging'];
    batteryLevel = json['battery_level'];
    identityKey = json['identity_key'];
    companyId = json['company_id'];
    odometer = json['odometer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['speed'] = speed;
    data['heading'] = heading;
    data['timestamp'] = timestamp;
    data['is_charging'] = isCharging;
    data['battery_level'] = batteryLevel;
    data['identity_key'] = identityKey;
    data['company_id'] = companyId;
    data['odometer'] = odometer;
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
  int? companyId;
  double? latitude;
  double? longitude;
  double? distance;
  int? workId;
  double? endlatitude;
  double? endlongitude;

  ActivitySessions({
    this.id,
    this.activity,
    this.startTime,
    this.endTime,
    this.duration,
    this.isActive,
    this.identityKey,
    this.companyId,
    this.latitude,
    this.longitude,
    this.distance,
    this.workId,
    this.endlatitude,
    this.endlongitude,
  });

  ActivitySessions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    activity = json['activity'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    duration = json['duration'];
    isActive = json['is_active'];
    identityKey = json['identity_key'];
    companyId = json['company_id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    distance = json['distance'];
    workId = json['work_id'];
    endlatitude = json['end_latitude'];
    endlongitude = json['end_longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['activity'] = activity;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['duration'] = duration;
    data['is_active'] = isActive;
    data['identity_key'] = identityKey;
    data['company_id'] = companyId;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['distance'] = distance;
    data['work_id'] = workId;
    data['end_latitude'] = endlatitude;
    data['end_longitude'] = endlongitude;
    return data;
  }
}
