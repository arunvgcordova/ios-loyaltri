
class BreakRequestModel {
  final String employeeId;
  final BreakType breakType;
  final String date;
  final String time;

  const BreakRequestModel(
      {required this.employeeId,
      required this.breakType,
      required this.date,
      required this.time});
}

enum BreakType { startBreak, endBreak }
