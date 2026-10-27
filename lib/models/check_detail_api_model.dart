class CheckInDataAPI {
  final int status;
  final String message;
  final List errors;
  final CheckData result;

  const CheckInDataAPI(
      {required this.status,
      required this.message,
      required this.errors,
      required this.result});

  factory CheckInDataAPI.fromJson(Map<String, dynamic> json) => CheckInDataAPI(
        status: json['status'],
        message: json['message'],
        errors: json['errors'],
        result: CheckData.fromJson(json['result']),
      );
}

class CheckData {
  final String? checkInTime;
  final String? checkOutTime;
  final String? checkInDateTime;
  final List<BreakDates>? breakDatas;
  final bool? enableTracking;
  final String? shiftEndTimeApp;

  const CheckData(
      {this.checkInTime,
      this.checkOutTime,
      this.breakDatas,
      this.checkInDateTime,
      this.enableTracking,
      this.shiftEndTimeApp});

  factory CheckData.fromJson(Map<String, dynamic> json) => CheckData(
      checkInTime: json['checkInTime'],
      checkOutTime: json['checkOutTime'],
      checkInDateTime: json['checkInDateTime'],
      breakDatas: List<BreakDates>.from(
          json['breakDatas'].map((x) => BreakDates.fromJson(x))),
      enableTracking: json['enableTracking'],
      shiftEndTimeApp: json['shiftEndTimeApp'],);
      
}

class BreakDates {
  final String? startTime;
  final String? endTime;
  final String? minutesTaken;

  const BreakDates({this.startTime, this.endTime, this.minutesTaken});

  factory BreakDates.fromJson(Map<String, dynamic> json) => BreakDates(
        startTime: json['startTime'],
        endTime: json['endTime'],
        minutesTaken: json['minutesTaken'],
      );
}

CheckInDataAPI checkInDataAPI = const CheckInDataAPI(
  status: 0,
  message: "",
  errors: [],
  result: CheckData(),
);
