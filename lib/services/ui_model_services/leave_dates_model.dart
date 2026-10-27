class LeaveDates {
  final DateTime? startDate;
  final DateTime? endDate;
  final int? isHalfDay;
  final int? hour;
  final String? leaveSection;

  LeaveDates({this.startDate, this.endDate, this.isHalfDay, this.leaveSection, this.hour});
}

class TimeState {
  final int? hour;
  final bool isSelected;

  TimeState({this.hour, required this.isSelected});

  TimeState copyWith({int? hour, bool? isSelected}) {
    return TimeState(
      hour: hour ?? this.hour,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

class ApplyLeaveModel {
  final String employeeId;
  final String companyId;
  final String leaveDateFrom;
  final String leaveDateTo;
  final String totalLeaveDays;
  final String? maximumLeaveLimit;
  final String? leaveSection;
  final String? createdBy;
  final String leaveApplied;
  final String leaveType;
  final String leaveReason;
  final String isActive;
  final int? isHalfDay;
  final List<String> files;
  final String? isHourBased;
  final int? leaveHours;
  final String? hourLeaveDate;

  ApplyLeaveModel({
    required this.employeeId,
    required this.companyId,
    required this.leaveDateFrom,
    required this.leaveDateTo,
    required this.totalLeaveDays,
    this.maximumLeaveLimit,
    this.leaveSection,
    required this.leaveApplied,
    this.createdBy,
    required this.leaveType,
    required this.leaveReason,
    required this.isActive,
    this.isHalfDay,
    required this.files,
    this.isHourBased,
    this.leaveHours,
    this.hourLeaveDate,
  });
}
