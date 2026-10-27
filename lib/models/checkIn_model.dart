

const String punchTableName = "punchTable";

class PunchFields {
  static List<String> values = [
    id,
    employeeId,
    companyId,
    punchDate,
    punchTime,
    punchType,
    punchRemarks,
    punchImage,
    locationName,
    latitude,
    longitude,
    punchState,
    isSynced
  ];

  static const String id = "_id";
  static const String employeeId = "employeeId";
  static const String companyId = "companyId";
  static const String punchDate = "punchDate";
  static const String punchTime = "punchTime";
  static const String punchType = "punchType";
  static const String punchRemarks = "punchRemarks";
  static const String punchImage = "punchImage";
  static const String locationName = "locationName";
  static const String latitude = "latitude";
  static const String longitude = "longitude";
  static const String punchState = "punchState";
  static const String isSynced = "isSynced";
}

class AttendanceCheckModel {
  final int? id;
  final String employeeId;
  final String companyId;
  final String punchDate;
  final String punchTime;
  final String? punchType;
  final String? punchRemarks;
  final String? punchImage;
  final String? locationName;
  final String latitude;
  final String longitude;
  final String punchState;
  final int? isSynced;

  const AttendanceCheckModel({
    this.id,
    required this.employeeId,
    required this.companyId,
    required this.punchDate,
    required this.punchTime,
    this.punchType,
    this.punchRemarks,
    required this.latitude,
    required this.longitude,
    this.locationName,
    required this.punchState,
    this.punchImage,
    this.isSynced,
  });

  AttendanceCheckModel copy({
    int? id,
    String? employeeId,
    String? companyId,
    String? punchDate,
    String? punchTime,
    String? punchType,
    String? punchRemarks,
    String? punchImage,
    String? locationName,
    String? latitude,
    String? longitude,
    String? punchState,
    int? isSynced,
  }) =>
      AttendanceCheckModel(
        id: id ?? this.id,
        employeeId: employeeId ?? this.employeeId,
        companyId: companyId ?? this.companyId,
        punchDate: punchDate ?? this.punchDate,
        punchTime: punchTime ?? this.punchTime,
        punchType: punchType ?? this.punchType,
        punchRemarks: punchRemarks ?? this.punchRemarks,
        punchImage: punchImage ?? this.punchImage,
        locationName: locationName ?? this.locationName,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        punchState: punchState ?? this.punchState,
        isSynced: isSynced ?? this.isSynced,
      );

  factory AttendanceCheckModel.fromJson(Map<String, dynamic> json) =>
      AttendanceCheckModel(
        id: json[PunchFields.id],
        employeeId: json[PunchFields.employeeId],
        companyId: json[PunchFields.companyId],
        punchDate: json[PunchFields.punchDate],
        punchTime: json[PunchFields.punchTime],
        punchType: json[PunchFields.punchType],
        punchRemarks: json[PunchFields.punchRemarks],
        punchImage: json[PunchFields.punchImage],
        locationName: json[PunchFields.locationName],
        latitude: json[PunchFields.latitude],
        longitude: json[PunchFields.longitude],
        punchState: json[PunchFields.punchState],
        isSynced: json[PunchFields.isSynced],
      );

  Map<String, dynamic> toJson() => {
        PunchFields.id: id,
        PunchFields.employeeId: employeeId,
        PunchFields.companyId: companyId,
        PunchFields.punchDate: punchDate,
        PunchFields.punchTime: punchTime,
        PunchFields.punchType: punchType,
        PunchFields.punchRemarks: punchRemarks,
        PunchFields.punchImage: punchImage,
        PunchFields.locationName: locationName,
        PunchFields.latitude: latitude,
        PunchFields.longitude: longitude,
        PunchFields.punchState: punchState,
        PunchFields.isSynced: isSynced,
      };
}
