class PieceWorkListApi {
  int? status;
  String? message;
  List<EmployeePiece>? result;

  PieceWorkListApi({this.status, this.message, this.result});

  PieceWorkListApi.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['result'] != null) {
      result = <EmployeePiece>[];
      json['result'].forEach((v) {
        result!.add(EmployeePiece.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EmployeePiece {
  String? employeeName;
  String? employeeImage;
  String? employeeId;
  String? employeeCode;
  String? employeeDesignation;
  List<PaymetArr>? paymetArr;

  EmployeePiece(
      {this.employeeName,
        this.employeeImage,
        this.employeeId,
        this.employeeCode,
        this.employeeDesignation,
        this.paymetArr});

  EmployeePiece.fromJson(Map<String, dynamic> json) {
    employeeName = json['employeeName'];
    employeeImage = json['employeeImage'];
    employeeId = json['employeeId'];
    employeeCode = json['employeeCode'];
    employeeDesignation = json['employeeDesignation'];
    if (json['paymetArr'] != null) {
      paymetArr = <PaymetArr>[];
      json['paymetArr'].forEach((v) {
        paymetArr!.add(PaymetArr.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['employeeName'] = employeeName;
    data['employeeImage'] = employeeImage;
    data['employeeId'] = employeeId;
    data['employeeCode'] = employeeCode;
    data['employeeDesignation'] = employeeDesignation;
    if (paymetArr != null) {
      data['paymetArr'] = paymetArr!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PaymetArr {
  String? pieceWorkEmpMappingId;
  String? pieceRateId;
  String? employeeId;
  String? ratePerUnit;
  String? unit;
  String? totalAmount;
  String? createdOn;
  String? createdBy;
  String? modifiedBy;
  String? modifiedOn;
  String? isActive;
  String? status;
  String? workDate;
  String? companyId;
  String? code;
  String? type;
  String? unitName;
  String? subType;
  String? unitMeasurement;

  PaymetArr(
      {this.pieceWorkEmpMappingId,
        this.pieceRateId,
        this.employeeId,
        this.ratePerUnit,
        this.unit,
        this.totalAmount,
        this.createdOn,
        this.createdBy,
        this.modifiedBy,
        this.modifiedOn,
        this.isActive,
        this.status,
        this.workDate,
        this.companyId,
        this.code,
        this.type,
        this.unitName,
        this.subType,
        this.unitMeasurement});

  PaymetArr.fromJson(Map<String, dynamic> json) {
    pieceWorkEmpMappingId = json['pieceWorkEmpMappingId'];
    pieceRateId = json['pieceRateId'];
    employeeId = json['employeeId'];
    ratePerUnit = json['ratePerUnit'];
    unit = json['unit'];
    totalAmount = json['totalAmount'];
    createdOn = json['createdOn'];
    createdBy = json['createdBy'];
    modifiedBy = json['modifiedBy'];
    modifiedOn = json['modifiedOn'];
    isActive = json['isActive'];
    status = json['status'];
    workDate = json['workDate'];
    companyId = json['companyId'];
    code = json['code'];
    type = json['type'];
    unitName = json['unitName'];
    subType = json['subType'];
    unitMeasurement = json['unitMeasurement'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pieceWorkEmpMappingId'] = pieceWorkEmpMappingId;
    data['pieceRateId'] = pieceRateId;
    data['employeeId'] = employeeId;
    data['ratePerUnit'] = ratePerUnit;
    data['unit'] = unit;
    data['totalAmount'] = totalAmount;
    data['createdOn'] = createdOn;
    data['createdBy'] = createdBy;
    data['modifiedBy'] = modifiedBy;
    data['modifiedOn'] = modifiedOn;
    data['isActive'] = isActive;
    data['status'] = status;
    data['workDate'] = workDate;
    data['companyId'] = companyId;
    data['code'] = code;
    data['type'] = type;
    data['unitName'] = unitName;
    data['subType'] = subType;
    data['unitMeasurement'] = unitMeasurement;
    return data;
  }
}

class AllPieceRateApi {
  int? status;
  String? message;
  // List<dynamic>? errors;
  List<PieceRate>? result;

  AllPieceRateApi({this.status, this.message, this.result});

  AllPieceRateApi.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    // if (json['errors'] != null) {
    //   errors = [];
    //   json['errors'].forEach((v) {
    //     errors!.add(v); // keeping errors as dynamic
    //   });
    // }
    if (json['result'] != null) {
      result = [];
      json['result'].forEach((v) {
        result!.add(PieceRate.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    data['message'] = message;
    // if (errors != null) {
    //   data['errors'] = errors;
    // }
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PieceRate {
  String? pieceRateId;
  String? companyId;
  String? unitName;
  String? code;
  String? type;
  String? subType;
  String? unitMeasurement;
  String? ratePerUnit;
  String? isActive;
  String? createdBy;
  String? createdOn;
  String? modifiedBy;
  String? modifiedOn;
  int? unitCount;
  String? totalAmount;
  String? codeValidation;
  String? itemValidation;
  String? typeValidation;
  String? subTypeValidation;
  String? unitValidation;
  String? rateValidation;

  PieceRate({
    this.pieceRateId,
    this.companyId,
    this.unitName,
    this.code,
    this.type,
    this.subType,
    this.unitMeasurement,
    this.ratePerUnit,
    this.isActive,
    this.createdBy,
    this.createdOn,
    this.modifiedBy,
    this.modifiedOn,
    this.unitCount,
    this.totalAmount,
    this.codeValidation,
    this.itemValidation,
    this.typeValidation,
    this.subTypeValidation,
    this.unitValidation,
    this.rateValidation,
  });

  PieceRate.fromJson(Map<String, dynamic> json) {
    pieceRateId = json['pieceRateId'];
    companyId = json['companyId'];
    unitName = json['unitName'];
    code = json['code'];
    type = json['type'];
    subType = json['subType'];
    unitMeasurement = json['unitMeasurement'];
    ratePerUnit = json['ratePerUnit'];
    isActive = json['isActive'];
    createdBy = json['createdBy'];
    createdOn = json['createdOn'];
    modifiedBy = json['modifiedBy'];
    modifiedOn = json['modifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['pieceRateId'] = pieceRateId;
    data['companyId'] = companyId;
    data['unitName'] = unitName;
    data['code'] = code;
    data['type'] = type;
    data['subType'] = subType;
    data['unitMeasurement'] = unitMeasurement;
    data['ratePerUnit'] = ratePerUnit;
    data['isActive'] = isActive;
    data['createdBy'] = createdBy;
    data['createdOn'] = createdOn;
    data['modifiedBy'] = modifiedBy;
    data['modifiedOn'] = modifiedOn;
    return data;
  }
}

class AddPieceWork {
  String? loggedInEmployeeId;
  String? date;
  String? companyId;
  List<PieceWorkEmployeeData>? data;

  AddPieceWork({this.loggedInEmployeeId, this.date, this.companyId, this.data});

  factory AddPieceWork.fromJson(Map<String, dynamic> json) {
    return AddPieceWork(
      loggedInEmployeeId: json['loggedInEmployeeId'],
      date: json['date'],
      companyId: json['companyId'],
      data: json['data'] != null
          ? (json['data'] as List).map((e) => PieceWorkEmployeeData.fromJson(e)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'loggedInEmployeeId': loggedInEmployeeId,
      'date': date,
      'companyId': companyId,
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }
}

class PieceWorkEmployeeData {
  String? employeeId;
  num? totalAmount;
  List<Record>? records;

  PieceWorkEmployeeData({this.employeeId, this.totalAmount, this.records});

  factory PieceWorkEmployeeData.fromJson(Map<String, dynamic> json) {
    return PieceWorkEmployeeData(
      employeeId: json['employeeId'],
      totalAmount: json['totalAmount'],
      records: json['records'] != null
          ? (json['records'] as List).map((e) => Record.fromJson(e)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employeeId': employeeId,
      'totalAmount': totalAmount,
      'records': records?.map((e) => e.toJson()).toList(),
    };
  }
}

class Record {
  String? pieceWorkEmpMappingId;
  String? pieceRateId;
  String? code;
  String? itemName;
  String? type;
  String? subType;
  num? rate;
  num? units;
  num? totalAmount;

  Record({
    this.pieceWorkEmpMappingId,
    this.pieceRateId,
    this.code,
    this.itemName,
    this.type,
    this.subType,
    this.rate,
    this.units,
    this.totalAmount,
  });

  factory Record.fromJson(Map<String, dynamic> json) {
    return Record(
      pieceWorkEmpMappingId: json['pieceWorkEmpMappingId'],
      pieceRateId: json['pieceRateId'],
      code: json['code'],
      itemName: json['itemName'],
      type: json['type'],
      subType: json['subType'],
      rate: json['rate'],
      units: json['units'],
      totalAmount: json['totalAmount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pieceWorkEmpMappingId': pieceWorkEmpMappingId,
      'pieceRateId': pieceRateId,
      'code': code,
      'itemName': itemName,
      'type': type,
      'subType': subType,
      'rate': rate,
      'units': units,
      'totalAmount': totalAmount,
    };
  }
}


