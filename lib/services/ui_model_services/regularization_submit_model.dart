
import 'package:loyaltri_minimal/models/attendance_details_api_model.dart';

class RegularizationSubmit {
  final String employeeId;
  final String employeeCompanyId;
  final String employeeDailyAttendanceId;
  final String deductionDetails;
  final RegularizationType regularizationType;
  LateEntryData? regularizationData;
  final OverTimeData? overTimeData;
  final String? excuseReason;
  String? status;
  final String? leaveTypeId;
  final String? createdBy;

  RegularizationSubmit({
    required this.employeeId,
    required this.deductionDetails,
    required this.employeeCompanyId,
    required this.employeeDailyAttendanceId,
    required this.regularizationType,
    this.regularizationData,
    this.overTimeData,
    this.excuseReason,
    this.status,
    this.leaveTypeId,
    this.createdBy,
  });
}

enum RegularizationType {le, ot, eb, ee, mp, st}
