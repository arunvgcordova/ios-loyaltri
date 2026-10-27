class CustomerDetailsResponse {
  int? status;
  String? message;
  Data? data;

  CustomerDetailsResponse({this.status, this.message, this.data});

  CustomerDetailsResponse.fromJson(Map<String, dynamic> json) {
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
    }
    return data;
  }
}

class Data {
  int? id;
  int? companyId;
  String? customerCode;
  String? name;
  String? phone;
  String? email;
  Location? location;
  String? locationName;
  int? createdBy;
  String? employeeAssignType;
  // Null? assignedEmployeeIds;
  String? status;
  String? profilePhoto;
  String? createdAt;
  String? updatedAt;
  DynamicFields? dynamicFields;
  

  Data(
      {this.id,
      this.companyId,
      this.customerCode,
      this.name,
      this.phone,
      this.email,
      this.location,
      this.locationName,
      this.createdBy,
      this.employeeAssignType,
      // this.assignedEmployeeIds,
      this.status,
      this.profilePhoto,
      this.createdAt,
      this.updatedAt,
      this.dynamicFields});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    customerCode = json['customer_code'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    location = json['location'] != null
        ? Location.fromJson(json['location'])
        : null;
    locationName = json['location_name'];
    createdBy = json['created_by'];
    employeeAssignType = json['employee_assign_type'];
    // assignedEmployeeIds = json['assigned_employee_ids'];
    status = json['status'];
    profilePhoto = json['profile_photo'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['location_name'] = locationName;
    data['created_by'] = createdBy;
    data['employee_assign_type'] = employeeAssignType;
    // data['assigned_employee_ids'] = assignedEmployeeIds;
    data['status'] = status;
    data['profile_photo'] = profilePhoto;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
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
  String? pointOfContactName;
  String? pocContactNumber;
  String? emailId;
  // List<Null>? otpEnabled;
  String? notes;
  String? sdfe;
  Location? location;

  DynamicFields(
      {this.locationName,
      this.name,
      this.phoneNumber,
      this.pointOfContactName,
      this.pocContactNumber,
      this.emailId,
      // this.otpEnabled,
      this.notes,
      this.sdfe,this.location});

  DynamicFields.fromJson(Map<String, dynamic> json) {
    locationName = json['location_name'];
    name = json['name'];
    phoneNumber = json['phone_number'];
    pointOfContactName = json['point_of_contact_name'];
    pocContactNumber = json['poc_contact_number'];
    emailId = json['email_id'];
    // if (json['otp_enabled'] != null) {
    //   otpEnabled = <Null>[];
    //   json['otp_enabled'].forEach((v) {
    //     otpEnabled!.add(Null.fromJson(v));
    //   });
    // }
    notes = json['notes'];
    sdfe = json['sdfe'];
    location = json['location'] != null
        ? Location.fromJson(json['location'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['location_name'] = locationName;
    data['name'] = name;
    data['phone_number'] = phoneNumber;
    data['point_of_contact_name'] = pointOfContactName;
    data['poc_contact_number'] = pocContactNumber;
    data['email_id'] = emailId;
    // if (otpEnabled != null) {
    //   data['otp_enabled'] = otpEnabled!.map((v) => v.toJson()).toList();
    // }
    data['notes'] = notes;
    data['sdfe'] = sdfe;
    if (location != null) {
      data['location'] = location!.toJson();
    }
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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}
