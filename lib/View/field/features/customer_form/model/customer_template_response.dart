class CustomerTemplateResponse {
  int? status;
  String? message;
  List<Data>? data;
  // Pagination? pagination;

  CustomerTemplateResponse({
    this.status,
    this.message,
    this.data,
    // this.pagination,
  });

  CustomerTemplateResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    // pagination = json['pagination'] != null
    //     ? new Pagination.fromJson(json['pagination'])
    //     : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    // if (this.pagination != null) {
    //   data['pagination'] = this.pagination!.toJson();
    // }
    return data;
  }
}

class Data {
  int? id;
  int? companyId;
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
  // String? createdAt;
  // String? updatedAt;

  Data({
    this.id,
    this.companyId,
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
    // this.createdAt,
    // this.updatedAt,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
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
    // createdAt = json['created_at'];
    // updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['company_id'] = companyId;
    data['field_key'] = fieldKey;
    data['field_label'] = fieldLabel;
    data['field_type'] = fieldType;
    data['is_required'] = isRequired;
    data['placeholder'] = placeholder;
    // data['default_value'] = defaultValue;
    // data['validation_rules'] = validationRules;
    data['values'] = values;
    data['sort_order'] = sortOrder;
    data['is_active'] = isActive;
    // data['created_at'] = createdAt;
    // data['updated_at'] = updatedAt;
    return data;
  }
}

// class Pagination {
//   int? total;
//   int? page;
//   int? limit;
//   int? totalPages;

//   Pagination({this.total, this.page, this.limit, this.totalPages});

//   Pagination.fromJson(Map<String, dynamic> json) {
//     total = json['total'];
//     page = json['page'];
//     limit = json['limit'];
//     totalPages = json['totalPages'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['total'] = this.total;
//     data['page'] = this.page;
//     data['limit'] = this.limit;
//     data['totalPages'] = this.totalPages;
//     return data;
//   }
// }
