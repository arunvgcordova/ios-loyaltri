class RequestSendModel {
  final String employeeId;
  final String companyId;
  final String? requestType;
  final String description;
  final String? fromDate;
  final String? toDate;

  const RequestSendModel({
    required this.employeeId,
    required this.companyId,
    this.requestType,
    required this.description,
    this.fromDate,
    this.toDate,
  });
}
