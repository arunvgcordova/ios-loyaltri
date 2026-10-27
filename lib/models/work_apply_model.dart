class WorkData {
  final String workName;
  final String unitCount;
  final String date;
  final String description;
  final String employeeId;
  final String companyId;
  final Map<String, String>? location;
  final List<String> files;
  final int isActive;
  final String createdBy;

  const WorkData(
      {required this.workName,
      required this.unitCount,
      required this.date,
      required this.description,
      this.location,
      required this.files,
      required this.isActive,
      required this.employeeId,
      required this.companyId,
      required this.createdBy});
}
