class PunchTypeModel {
  final int status;
  final String message;
  final List errors;
  final PunchTypeData result;

  const PunchTypeModel(
      {required this.status,
      required this.message,
      required this.errors,
      required this.result});

  factory PunchTypeModel.fromJson(Map<String, dynamic> json) => PunchTypeModel(
        status: json['status'],
        message: json['message'],
        errors: json['errors'],
        result: PunchTypeData.fromJson(json['result']),
      );
}

class PunchTypeData {
  // final String? punchMethod;
  // final String? employeeId;
  final List<LocationGeoFencing>? locationGeoFencing;
  final List<dynamic>? punchMethodId;

  const PunchTypeData({
    // this.punchMethod,
    // this.employeeId,
    this.locationGeoFencing,
    this.punchMethodId,
  });

  factory PunchTypeData.fromJson(Map<String, dynamic> json) => PunchTypeData(
        // employeeId: json['employeeId'],
        // punchMethod: json['punchMethod'],
        locationGeoFencing: (json['locationGeoFencing'] as List<dynamic>?)?.map((e) => LocationGeoFencing.fromJson(e as Map<String, dynamic>)).toList() ?? [],
        punchMethodId: json['punchMethodId'],
      );
}

class LocationGeoFencing {
  String? eastLong;
  String? northLat;
  String? southLat;
  String? westLong;

  LocationGeoFencing(
      {this.eastLong, this.northLat, this.southLat, this.westLong});

  LocationGeoFencing.fromJson(Map<String, dynamic> json) {
    eastLong = json['eastLong'];
    northLat = json['northLat'];
    southLat = json['southLat'];
    westLong = json['westLong'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['eastLong'] = eastLong;
    data['northLat'] = northLat;
    data['southLat'] = southLat;
    data['westLong'] = westLong;
    return data;
  }
}

PunchTypeModel punchTypeModel = const PunchTypeModel(
  status: 0,
  message: "",
  errors: [],
  result: PunchTypeData(),
);
