class ShiftSchedulerDepartmentResponse {
  int? status;
  String? message;
  List<dynamic>? errors;
  List<DepartmentData>? result;

  ShiftSchedulerDepartmentResponse({
    this.status,
    this.message,
    this.errors,
    this.result,
  });

  factory ShiftSchedulerDepartmentResponse.fromJson(
          Map<String, dynamic> json) =>
      ShiftSchedulerDepartmentResponse(
        status: json["status"],
        message: json["message"],
        errors: json["errors"] == null
            ? []
            : List<dynamic>.from(json["errors"]!.map((x) => x)),
        result: json["result"] == null
            ? []
            : List<DepartmentData>.from(
                json["result"]!.map((x) => DepartmentData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "errors":
            errors == null ? [] : List<dynamic>.from(errors!.map((x) => x)),
        "result": result == null
            ? []
            : List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class DepartmentData {
  int? departmentId;
  String? companyId;
  String? department;
  String? description;
  int? isActive;
  String? createdOn;
  String? modifiedBy;
  String? modifiedOn;
  int? createdBy;
  dynamic responsibility;

  DepartmentData({
    this.departmentId,
    this.companyId,
    this.department,
    this.description,
    this.isActive,
    this.createdOn,
    this.modifiedBy,
    this.modifiedOn,
    this.createdBy,
    this.responsibility,
  });

  factory DepartmentData.fromJson(Map<String, dynamic> json) => DepartmentData(
        departmentId: json["departmentId"],
        companyId: json["companyId"]?.toString(),
        department: json["department"],
        description: json["description"],
        isActive: json["isActive"],
        createdOn: json["createdOn"],
        modifiedBy: json["modifiedBy"],
        modifiedOn: json["modifiedOn"],
        createdBy: json["createdBy"],
        responsibility: json["responsibility"],
      );

  Map<String, dynamic> toJson() => {
        "departmentId": departmentId,
        "companyId": companyId,
        "department": department,
        "description": description,
        "isActive": isActive,
        "createdOn": createdOn,
        "modifiedBy": modifiedBy,
        "modifiedOn": modifiedOn,
        "createdBy": createdBy,
        "responsibility": responsibility,
      };
}
