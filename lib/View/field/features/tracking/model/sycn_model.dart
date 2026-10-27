// class SynModel {
//   int? employeeId;
//   List<RoutePoints>? routePoints;
//   List<ActivitySessions>? activitySessions;

//   SynModel({this.employeeId, this.routePoints, this.activitySessions});

//   SynModel.fromJson(Map<String, dynamic> json) {
//     employeeId = json['employee_id'];
//     if (json['route_points'] != null) {
//       routePoints = <RoutePoints>[];
//       json['route_points'].forEach((v) {
//         routePoints!.add(RoutePoints.fromJson(v));
//       });
//     }
//     if (json['activity_sessions'] != null) {
//       activitySessions = <ActivitySessions>[];
//       json['activity_sessions'].forEach((v) {
//         activitySessions!.add(ActivitySessions.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();
//     data['employee_id'] = employeeId;
//     if (routePoints != null) {
//       data['route_points'] = routePoints!.map((v) => v.toJson()).toList();
//     }
//     if (activitySessions != null) {
//       data['activity_sessions'] =
//           activitySessions!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class RoutePoints {
//   int? id;
//   double? latitude;
//   double? longitude;
//   double? speed;
//   double? heading;
//   String? timestamp;

//   RoutePoints(
//       {this.id,
//       this.latitude,
//       this.longitude,
//       this.speed,
//       this.heading,
//       this.timestamp});

//   RoutePoints.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     latitude = json['latitude'];
//     longitude = json['longitude'];
//     speed = json['speed'];
//     heading = json['heading'];
//     timestamp = json['timestamp'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();
//     data['id'] = id;
//     data['latitude'] = latitude;
//     data['longitude'] = longitude;
//     data['speed'] = speed;
//     data['heading'] = heading;
//     data['timestamp'] = timestamp;
//     return data;
//   }
// }

// class ActivitySessions {
//   int? id;
//   String? activity;
//   String? startTime;
//   String? endTime;
//   int? duration;
//   bool? isActive;

//   ActivitySessions(
//       {this.id,
//       this.activity,
//       this.startTime,
//       this.endTime,
//       this.duration,
//       this.isActive});

//   ActivitySessions.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     activity = json['activity'];
//     startTime = json['start_time'];
//     endTime = json['end_time'];
//     duration = json['duration'];
//     isActive = json['is_active'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();
//     data['id'] = id;
//     data['activity'] = activity;
//     data['start_time'] = startTime;
//     data['end_time'] = endTime;
//     data['duration'] = duration;
//     data['is_active'] = isActive;
//     return data;
//   }
// }
