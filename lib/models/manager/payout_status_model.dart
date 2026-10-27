
class PayoutStatusModel {
  int? status;
  String? message;
  List<PayoutStatus>? result;

  PayoutStatusModel({this.status, this.message, this.result});

  PayoutStatusModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['result'] != null) {
      result = <PayoutStatus>[];
      json['result'].forEach((v) {
        result!.add(new PayoutStatus.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PayoutStatus {
  String? employeeId;
  String? salaryMonthYear;
  int? payoutStatus;
  String? payoutToDate;

  PayoutStatus(
      {this.employeeId,
        this.salaryMonthYear,
        this.payoutStatus,
        this.payoutToDate});

  PayoutStatus.fromJson(Map<String, dynamic> json) {
    employeeId = json['employeeId'];
    salaryMonthYear = json['salaryMonthYear'];
    payoutStatus = json['payoutStatus'];
    payoutToDate = json['payoutToDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employeeId'] = this.employeeId;
    data['salaryMonthYear'] = this.salaryMonthYear;
    data['payoutStatus'] = this.payoutStatus;
    data['payoutToDate'] = this.payoutToDate;
    return data;
  }
}