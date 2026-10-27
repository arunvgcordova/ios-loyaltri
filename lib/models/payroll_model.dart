class PayrollModel {
  int? status;
  String? message;
  List<dynamic>? errors;
  List<SalaryData>? result;

  PayrollModel({this.status, this.message, this.errors, this.result});

  PayrollModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    errors = json['errors'];
    if (json['result'] != null) {
      result = <SalaryData>[];
      json['result'].forEach((v) {
        result!.add(SalaryData.fromJson(v));
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

class SalaryData {
  String? accountNo;
  String? monthYear;
  // int? isSettled;
  // int? isSalaryHold;
  List<Earnings>? earnings;
  List<Earnings>? deductions;
  double? totalErnings;
  double? totalDeductions;
  // double? basicPay;
  // double? totalAllowances;
  // double? grossSalary;
  // double? totalWorkExpense;
  // double? totalDeductionsAdjustment;
  double? totalAdditionsAdjustment;
  // String? companyId;
  // String? salaryTemplateId;
  // SSC? sSC;
  // int? arrears;
  String? currency;
  String? paySlipUrl;
  String? paymentMethod;
  String? paymentMethodMobile;
  double? netSalary;

  SalaryData(
      {this.accountNo,
      this.monthYear,
      // this.isSettled,
      // this.isSalaryHold,
      this.earnings,
      this.deductions,
      this.totalErnings,
      this.totalDeductions,
      // this.basicPay,
      // this.totalAllowances,
      // this.grossSalary,
      // this.totalWorkExpense,
      // this.totalDeductionsAdjustment,
      this.totalAdditionsAdjustment,
      // this.companyId,
      // this.salaryTemplateId,
      // this.sSC,
      // this.arrears,
      this.currency,
      this.paySlipUrl,
      this.paymentMethod,
      this.paymentMethodMobile,
      this.netSalary});

  SalaryData.fromJson(Map<String, dynamic> json) {
    accountNo = json['accountNo'];
    monthYear = json['monthYear'];
    // isSettled = json['isSettled'];
    // isSalaryHold = json['isSalaryHold'];
    if (json['earnings'] != null) {
      earnings = <Earnings>[];
      json['earnings'].forEach((v) {
        earnings!.add(Earnings.fromJson(v));
      });
    }
    if (json['deductions'] != null) {
      deductions = <Earnings>[];
      json['deductions'].forEach((v) {
        deductions!.add(Earnings.fromJson(v));
      });
    }
    if (json['totalErnings'] != null) {
      totalErnings = double.parse(json['totalErnings'].toString());
    }
    if (json['totalDeductions'] != null) {
      totalDeductions = double.parse(json['totalDeductions'].toString());
    }
    // if(json['Basic Pay'] != null) {
    //   basicPay = double.parse(json['Basic Pay'].toString());
    // }
    // if(json['totalAllowances'] != null) {
    //   totalAllowances = double.parse(json['totalAllowances'].toString());
    // }
    // if(json['grossSalary'] != null) {
    //   grossSalary = double.parse(json['grossSalary'].toString());
    // }
    // if(json['totalWorkExpense'] != null) {
    //   totalWorkExpense = double.parse(json['totalWorkExpense'].toString());
    // }
    // if(json['totalDeductionsAdjustment'] != null) {
    //   totalDeductionsAdjustment = double.parse(json['totalDeductionsAdjustment'].toString());
    // }
    if (json['totalAdditionsAdjustment'] != null) {
      totalAdditionsAdjustment =
          double.parse(json['totalAdditionsAdjustment'].toString());
    }
    // companyId = json['companyId'];
    // salaryTemplateId = json['salaryTemplateId'];
    // sSC = json['SSC'] != null ? SSC.fromJson(json['SSC']) : null;
    // arrears = json['Arrears'];
    currency = json['Currency'];
    paySlipUrl = json['paySlipUrl'];
    paymentMethod = json['paymentMethod'];
    paymentMethodMobile = json['paymentMethodMobile'];
    if (json['netSalary'] != null) {
      netSalary = double.parse(json['netSalary'].toString());
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accountNo'] = accountNo;
    data['monthYear'] = monthYear;
    // data['isSettled'] = isSettled;
    // data['isSalaryHold'] = isSalaryHold;
    if (earnings != null) {
      data['earnings'] = earnings!.map((v) => v.toJson()).toList();
    }
    if (deductions != null) {
      data['deductions'] = deductions!.map((v) => v.toJson()).toList();
    }
    data['totalErnings'] = totalErnings;
    data['totalDeductions'] = totalDeductions;
    // data['Basic Pay'] = basicPay;
    // data['totalAllowances'] = totalAllowances;
    // data['grossSalary'] = grossSalary;
    // data['totalWorkExpense'] = totalWorkExpense;
    // data['totalDeductionsAdjustment'] = totalDeductionsAdjustment;
    data['totalAdditionsAdjustment'] = totalAdditionsAdjustment;
    // data['companyId'] = companyId;
    // data['salaryTemplateId'] = salaryTemplateId;
    // if (sSC != null) {
    //   data['SSC'] = sSC!.toJson();
    // }
    // data['Arrears'] = arrears;
    data['Currency'] = currency;
    data['paySlipUrl'] = paySlipUrl;
    data['paymentMethod'] = paymentMethod;
    data['paymentMethodMobile'] = paymentMethodMobile;
    data['netSalary'] = netSalary;
    return data;
  }
}

class Earnings {
  double? amount;
  // String? componentId;
  String? componentName;

  Earnings({
    this.amount,
    // this.componentId,
    this.componentName,
  });

  Earnings.fromJson(Map<String, dynamic> json) {
    if (json['amount'] != null) {
      amount = double.parse(json['amount'].toString());
    }
    // componentId = json['componentId'];
    componentName = json['componentName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    // data['componentId'] = componentId;
    data['componentName'] = componentName;
    return data;
  }
}

class SSC {
  double? totalssamount;

  SSC({this.totalssamount});

  SSC.fromJson(Map<String, dynamic> json) {
    if (json['totalssamount'] != null) {
      totalssamount = double.parse(json['totalssamount'].toString());
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalssamount'] = totalssamount;
    return data;
  }
}
