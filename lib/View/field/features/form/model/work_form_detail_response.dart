class WorkFormDetailResponse {
  int? status;
  String? message;
  Data? data;

  WorkFormDetailResponse({this.status, this.message, this.data});

  WorkFormDetailResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }<String, dynamic>{};
    return data;
  }
}

class Data {
  int? id;
  int? companyId;
  String? workTypeKey;
  String? name;
  String? description;
  int? sortOrder;
  bool? isActive;
  bool? isFeedbackRequired;
  bool? isGpsRequired;
  bool? isOtpRequired;
  bool? isSignatureRequired;
  bool? isWorkApprovalRequired;
  String? createdAt;
  String? updatedAt;
  List<TemplateFields>? templateFields;

  Data(
      {this.id,
      this.companyId,
      this.workTypeKey,
      this.name,
      this.description,
      this.sortOrder,
      this.isActive,
      this.isFeedbackRequired,
      this.isGpsRequired,
      this.isOtpRequired,
      this.isSignatureRequired,
      this.isWorkApprovalRequired,
      this.createdAt,
      this.updatedAt,
      this.templateFields});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    workTypeKey = json['work_type_key'];
    name = json['name'];
    description = json['description'];
    sortOrder = json['sort_order'];
    isActive = json['is_active'];
    isFeedbackRequired = json['is_feedback_required'];
    isGpsRequired = json['is_gps_required'];
    isOtpRequired = json['is_otp_required'];
    isSignatureRequired = json['is_signature_required'];
    isWorkApprovalRequired = json['is_work_approval_required'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['template_fields'] != null) {
      templateFields = <TemplateFields>[];
      json['template_fields'].forEach((v) {
        templateFields!.add(TemplateFields.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['company_id'] = companyId;
    data['work_type_key'] = workTypeKey;
    data['name'] = name;
    data['description'] = description;
    data['sort_order'] = sortOrder;
    data['is_active'] = isActive;
    data['is_feedback_required'] = isFeedbackRequired;
    data['is_gps_required'] = isGpsRequired;
    data['is_otp_required'] = isOtpRequired;
    data['is_signature_required'] = isSignatureRequired;
    data['is_work_approval_required'] = isWorkApprovalRequired;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (templateFields != null) {
      data['template_fields'] =
          templateFields!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TemplateFields {
  int? id;
  int? companyId;
  int? workTypeId;
  String? fieldKey;
  String? fieldLabel;
  String? fieldType;
  bool? isRequired;
  String? placeholder;
  // Null? defaultValue;
  // Null? validationRules;
  List<String>? values;
  int? sortOrder;
  bool? isActive;
  String? createdAt;
  String? updatedAt;

  TemplateFields(
      {this.id,
      this.companyId,
      this.workTypeId,
      this.fieldKey,
      this.fieldLabel,
      this.fieldType,
      this.isRequired,
      this.placeholder,
      // this.defaultValue,
      // this.validationRules,
      this.values,
      this.sortOrder,
      this.isActive,
      this.createdAt,
      this.updatedAt});

  TemplateFields.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    workTypeId = json['work_type_id'];
    fieldKey = json['field_key'];
    fieldLabel = json['field_label'];
    fieldType = json['field_type'];
    isRequired = json['is_required'];
    placeholder = json['placeholder'];
    // defaultValue = json['default_value'];
    // validationRules = json['validation_rules'];
    values = json['values'].cast<String>();
    sortOrder = json['sort_order'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['company_id'] = companyId;
    data['work_type_id'] = workTypeId;
    data['field_key'] = fieldKey;
    data['field_label'] = fieldLabel;
    data['field_type'] = fieldType;
    data['is_required'] = isRequired;
    data['placeholder'] = placeholder;
    // data['default_value'] = this.defaultValue;
    // data['validation_rules'] = this.validationRules;
    data['values'] = values;
    data['sort_order'] = sortOrder;
    data['is_active'] = isActive;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
