class LeaveSummaryModel {
  final int status;
  final String message;
  final List errors;
  final List<Summary> result;

  const LeaveSummaryModel(
      {required this.status,
      required this.message,
      required this.errors,
      required this.result});

  factory LeaveSummaryModel.fromJson(Map<String, dynamic> json) =>
      LeaveSummaryModel(
        status: json['status'],
        message: json['message'],
        errors: json['errors'],
        result:
            List<Summary>.from(json['result'].map((x) => Summary.fromJson(x))),
      );
}

class Summary {
  final String leaveCount;
  // final String leaveTaken;
  final String leaveBalance;
  // final String leaveTypeId;
  final String leaveType;
  final String colourCode;
  final bool hideLeaveBalance;

  const Summary({
    required this.leaveCount,
    // required this.leaveTaken,
    required this.leaveBalance,
    // required this.leaveTypeId,
    required this.leaveType,
    required this.colourCode,
    required this.hideLeaveBalance,
  });

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
        leaveCount: json['leaveCount'] ?? "0",
        // leaveTaken: json['leaveTaken'] ?? "",
        leaveBalance: json['leaveBalance'] ?? "0",
        // leaveTypeId: json['leaveTypeId'] ?? "",
        leaveType: json['leaveType'] ?? "",
        colourCode: json['colourCode'] ?? "",
    hideLeaveBalance: json['hideLeaveBalance'] ?? false,
      );
}

LeaveSummaryModel leaveSummaryAPI = const LeaveSummaryModel(
  status: 0,
  message: "",
  errors: [],
  result: [
    Summary(
      leaveBalance: "",
      leaveCount: "",
      // leaveTaken: "",
      leaveType: "",
      // leaveTypeId: "",
      colourCode: "",
      hideLeaveBalance: false
    ),
  ],
);

List<Summary> summaryLeave = [
  const Summary(
    leaveBalance: "",
    leaveCount: "",
    // leaveTaken: "",
    leaveType: "",
    // leaveTypeId: "",
    colourCode: "",
    hideLeaveBalance: false,
  )
];
