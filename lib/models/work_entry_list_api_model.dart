class WorkEntryListApiModel {
  final int status;
  final String message;
  final List errors;
  final List<WorkEntryDetail> result;

  const WorkEntryListApiModel({
    required this.status,
    required this.message,
    required this.errors,
    required this.result,
  });

  factory WorkEntryListApiModel.fromJson(Map<String, dynamic> json) =>
      WorkEntryListApiModel(
        status: json['status'],
        message: json['message'],
        errors: json['errors'],
        result: List<WorkEntryDetail>.from(
            json['result'].map((x) => WorkEntryDetail.fromJson(x))),
      );
}

class WorkEntryDetail {
  // final int? workEntryId;
  final String? workName;
  final String? unitCount;
  final String? description;
  // final int? isActive;
  final String? date;
  final String? dateTime;
  // final String? createdOn;
  // final String? modifiedOn;
  final String? location;
  // final int? createdBy;
  // final int? modifiedBy;
  final List<String>? attachments;

  const WorkEntryDetail({
    // this.workEntryId,
    this.workName,
    this.unitCount,
    this.description,
    // this.isActive,
    this.date,
    this.dateTime,
    // this.createdOn,
    // this.modifiedOn,
    this.location,
    // this.createdBy,
    // this.modifiedBy,
    this.attachments,
  });

  factory WorkEntryDetail.fromJson(Map<String, dynamic> json) =>
      WorkEntryDetail(
        // workEntryId: json['workEntryId'],
        workName: json['workName'],
        unitCount: json['unitCount'],
        description: json['description'],
        // isActive: json['isActive'],
        date: json['date'],
        dateTime: json['dateTime'],
        // createdOn: json['createdOn'],
        // modifiedOn: json['modifiedOn'],
        location: json['location'],
        // createdBy: json['createdBy'],
        // modifiedBy: json['modifiedBy'],
        attachments: json['Attachments'] != null ? (json['Attachments'] as List<dynamic>?)
            ?.map((item) => item as String)
            .toList() : [],
      );
}

WorkEntryListApiModel workEntryListApiModel = WorkEntryListApiModel(
  status: 0,
  message: "Error",
  errors: [],
  result: workEntryDetail,
);

List<WorkEntryDetail> workEntryDetail = [
  const WorkEntryDetail(
    // workEntryId: null,
    // modifiedOn: null,
    // modifiedBy: null,
    // isActive: null,
    description: null,
    // createdOn: null,
    // createdBy: null,
    date: null,
    dateTime: null,
    location: null,
    unitCount: null,
    workName: null,
  ),
];
