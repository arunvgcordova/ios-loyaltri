class CustomerModelResponse {
  int? status;
  String? message;
  List<CustomerData>? data;
  // bool? isCustomerTemplateExist;
  Pagination? pagination;

  CustomerModelResponse(
      {this.status,
      this.message,
      this.data,
      // this.isCustomerTemplateExist,
      this.pagination});

  CustomerModelResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CustomerData>[];
      json['data'].forEach((v) {
        data!.add(CustomerData.fromJson(v));
      });
    }
    // isCustomerTemplateExist = json['is_customer_template_exist'];
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    // data['is_customer_template_exist'] = isCustomerTemplateExist;
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    return data;
  }
}

class CustomerData {
  int? id;
  int? companyId;
  String? customerCode;
  String? name;
  String? phone;
  String? email;
  String? locationName;
  Location? location;
  // int? createdBy;
  // String? employeeAssignType;
  // List<int>? assignedEmployeeIds;
  // String? status;
  String? profilePhoto;
  // String? createdAt;
  // String? updatedAt;
  DynamicFields? dynamicFields;

  CustomerData(
      {this.id,
      this.companyId,
      this.customerCode,
      this.name,
      this.phone,
      this.email,
      this.locationName,
      this.location,
      // this.createdBy,
      // this.employeeAssignType,
      // this.assignedEmployeeIds,
      // this.status,
      this.profilePhoto,
      // this.createdAt,
      // this.updatedAt,
      this.dynamicFields});

  CustomerData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    customerCode = json['customer_code'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    locationName = json['location_name'];
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    // createdBy = json['created_by'];
    // employeeAssignType = json['employee_assign_type'];
    // assignedEmployeeIds = json['assigned_employee_ids'].cast<int>();
    // status = json['status'];
    profilePhoto = json['profile_photo'];
    // createdAt = json['created_at'];
    // updatedAt = json['updated_at'];
    dynamicFields = json['dynamic_fields'] != null
        ? DynamicFields.fromJson(json['dynamic_fields'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['company_id'] = companyId;
    data['customer_code'] = customerCode;
    data['name'] = name;
    data['phone'] = phone;
    data['email'] = email;
    data['location_name'] = locationName;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    // data['created_by'] = createdBy;
    // data['employee_assign_type'] = employeeAssignType;
    // data['assigned_employee_ids'] = assignedEmployeeIds;
    // data['status'] = status;
    data['profile_photo'] = profilePhoto;
    // data['created_at'] = createdAt;
    // data['updated_at'] = updatedAt;
    if (dynamicFields != null) {
      data['dynamic_fields'] = dynamicFields!.toJson();
    }
    return data;
  }
}

class DynamicFields {
  String? locationName;
  String? name;
  String? phoneNumber;
  // String? pointOfContactName;
  // String? pocContactNumber;
  String? emailId;
  Location? location;
  // List<String>? otpEnabled;
  // String? notes;
  // String? sdfe;

  DynamicFields(
      {this.locationName,
      this.name,
      this.phoneNumber,
      // this.pointOfContactName,
      // this.pocContactNumber,
      this.emailId,
      this.location,
      // this.otpEnabled,
      // this.notes,
      // this.sdfe
      });

  DynamicFields.fromJson(Map<String, dynamic> json) {
    locationName = json['location_name'];
    name = json['name'];
    phoneNumber = json['phone_number'];
    // pointOfContactName = json['point_of_contact_name'];
    // pocContactNumber = json['poc_contact_number'];
    emailId = json['email_id'];
    location = json['location'] != null
        ? Location.fromJson(json['location'])
        : null;
    // otpEnabled = json['otp_enabled'].cast<String>();
    // notes = json['notes'];
    // sdfe = json['sdfe'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['location_name'] = locationName;
    data['name'] = name;
    data['phone_number'] = phoneNumber;
    // data['point_of_contact_name'] = pointOfContactName;
    // data['poc_contact_number'] = pocContactNumber;
    data['email_id'] = emailId;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    // data['otp_enabled'] = otpEnabled;
    // data['notes'] = notes;
    // data['sdfe'] = sdfe;
    return data;
  }
}

class Location {
  double? lat;
  double? lng;

  Location({this.lat, this.lng});

  Location.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}

class Pagination {
  int? total;
  int? page;
  int? limit;
  int? totalPages;

  Pagination({this.total, this.page, this.limit, this.totalPages});

  Pagination.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    page = json['page'];
    limit = json['limit'];
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['page'] = page;
    data['limit'] = limit;
    data['totalPages'] = totalPages;
    return data;
  }
}
