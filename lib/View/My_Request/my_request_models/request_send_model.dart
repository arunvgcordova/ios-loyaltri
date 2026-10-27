class RequestSendModel {
  String? reqId;
  String? employeeId;
  String? companyId;
  String? requestType;
  String? description;
  String? fromDate;
  String? toDate;
  String? fromTime;
  String? toTime;
  String? amount;
  String? dropdown1;
  String? dropdown2;
  String? text1;
  String? text2;
  List<String>? files;

  RequestSendModel({
    this.employeeId,
    this.companyId,
    this.requestType,
    this.description,
    this.fromDate,
    this.toDate,
    this.fromTime,
    this.toTime,
    this.reqId,
    this.amount,
    this.dropdown1,
    this.dropdown2,
    this.text1,
    this.text2,
    this.files,
  });
}
