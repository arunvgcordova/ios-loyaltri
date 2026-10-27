class WorkExpenseListModel {
  int? status;
  String? message;
  List<dynamic>? errors;
  List<WorkExpenseData>? result;

  WorkExpenseListModel({this.status, this.message, this.errors, this.result});

  WorkExpenseListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    errors = json['errors'];
    if (json['result'] != null) {
      result = <WorkExpenseData>[];
      json['result'].forEach((v) {
        result!.add(WorkExpenseData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['errors'] = errors;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WorkExpenseData {
  // String? employeeWorkExpenseId;
  // String? companyId;
  // String? financialYearId;
  // String? employeeId;
  // String? categoryId;
  String? description;
  String? amount;
  String? expenseDate;
  List<Attachment>? attachments;
  String? workExpenseStatus;
  // String? isSalaryPayoutDone;
  // String? salaryPayoutMonthYear;
  // String? isEditable;
  // String? isActive;
  // String? createdBy;
  String? createdOn;
  // Null? modifiedBy;
  // String? modifiedOn;
  // String? salaryMonthYear;
  String? categoryName;
  // List<Null>? approvers;

  WorkExpenseData({
    // this.employeeWorkExpenseId,
    // this.companyId,
    // this.financialYearId,
    // this.employeeId,
    // this.categoryId,
    this.description,
    this.amount,
    this.expenseDate,
    this.attachments,
    this.workExpenseStatus,
    // this.isSalaryPayoutDone,
    // this.salaryPayoutMonthYear,
    // this.isEditable,
    // this.isActive,
    // this.createdBy,
    this.createdOn,
    // this.modifiedBy,
    // this.modifiedOn,
    // this.salaryMonthYear,
    this.categoryName,
    // this.approvers,
  });

  WorkExpenseData.fromJson(Map<String, dynamic> json) {
    // employeeWorkExpenseId = json['employeeWorkExpenseId'];
    // companyId = json['companyId'];
    // financialYearId = json['financialYearId'];
    // employeeId = json['employeeId'];
    // categoryId = json['categoryId'];
    description = json['description'];
    amount = json['amount'];
    expenseDate = json['expenseDate'];
    attachments = json['attachments'] != null
        ? (json['attachments'] as List)
        .map((e) => Attachment.fromJson(e))
        .toList()
        : [];
    workExpenseStatus = json['workExpenseStatus'];
    // isSalaryPayoutDone = json['isSalaryPayoutDone'];
    // salaryPayoutMonthYear = json['salaryPayoutMonthYear'];
    // isEditable = json['isEditable'];
    // isActive = json['isActive'];
    // createdBy = json['createdBy'];
    createdOn = json['createdOn'];
    // modifiedBy = json['modifiedBy'];
    // modifiedOn = json['modifiedOn'];
    // salaryMonthYear = json['salaryMonthYear'];
    categoryName = json['categoryName'];
    // if (json['approvers'] != null) {
    //   approvers = <Null>[];
    //   json['approvers'].forEach((v) {
    //     approvers!.add(new Null.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // data['employeeWorkExpenseId'] = employeeWorkExpenseId;
    // data['companyId'] = companyId;
    // data['financialYearId'] = financialYearId;
    // data['employeeId'] = employeeId;
    // data['categoryId'] = categoryId;
    data['description'] = description;
    data['amount'] = amount;
    data['expenseDate'] = expenseDate;
    data['attachments'] = attachments?.map((e) => e.toJson()).toList();
    data['workExpenseStatus'] = workExpenseStatus;
    // data['isSalaryPayoutDone'] = isSalaryPayoutDone;
    // data['salaryPayoutMonthYear'] = salaryPayoutMonthYear;
    // data['isEditable'] = isEditable;
    // data['isActive'] = isActive;
    // data['createdBy'] = createdBy;
    data['createdOn'] = createdOn;
    // data['modifiedBy'] = this.modifiedBy;
    // data['modifiedOn'] = modifiedOn;
    // data['salaryMonthYear'] = salaryMonthYear;
    data['categoryName'] = categoryName;
    // if (this.approvers != null) {
    //   data['approvers'] = this.approvers!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class Attachment {
  String? path;
  String? type;
  String? url;

  Attachment({
    this.path,
    this.type,
    this.url,
  });

  Attachment.fromJson(Map<String, dynamic> json) {
    path = json['path'];
    type = json['type'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'type': type,
      'url': url,
    };
  }
}