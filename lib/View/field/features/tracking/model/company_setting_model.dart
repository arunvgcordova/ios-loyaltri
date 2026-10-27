class CompanySettingsResponse {
  int? status;
  String? message;
  CompanySettingData? data;

  CompanySettingsResponse({this.status, this.message, this.data});

  CompanySettingsResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? CompanySettingData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data!.toJson();
    }
    return map;
  }
}

class CompanySettingData {
  int? id;
  int? companyId;
  String? locationInterval;
  String? idleTime;
  int? idleTimeCustomMinutes;
  String? staffCanCreateWork;
  List<dynamic>? staffCanCreateWorkEmployeeIds;
  String? timelineAccessStaff;
  List<dynamic>? timelineAccessStaffEmployeeIds;
  String? staffCanCreateCustomer;
  List<dynamic>? staffCanCreateCustomerEmployeeIds;
  num? geofencingRadius;
  String? workFormOpens;
  String? updatedAt;

  CompanySettingData({
    this.id,
    this.companyId,
    this.locationInterval,
    this.idleTime,
    this.idleTimeCustomMinutes,
    this.staffCanCreateWork,
    this.staffCanCreateWorkEmployeeIds,
    this.timelineAccessStaff,
    this.timelineAccessStaffEmployeeIds,
    this.staffCanCreateCustomer,
    this.staffCanCreateCustomerEmployeeIds,
    this.geofencingRadius,
    this.workFormOpens,
    this.updatedAt,
  });

  CompanySettingData.fromJson(Map<String, dynamic> json) {
    id = json['id'] is num ? (json['id'] as num).toInt() : int.tryParse(json['id']?.toString() ?? '');
    companyId = json['company_id'] is num
        ? (json['company_id'] as num).toInt()
        : int.tryParse(json['company_id']?.toString() ?? '');
    locationInterval = json['location_interval']?.toString();
    idleTime = json['idle_time']?.toString();
    idleTimeCustomMinutes = json['idle_time_custom_minutes'] is num
        ? (json['idle_time_custom_minutes'] as num).toInt()
        : int.tryParse(json['idle_time_custom_minutes']?.toString() ?? '');
    staffCanCreateWork = json['staff_can_create_work']?.toString();
    staffCanCreateWorkEmployeeIds = json['staff_can_create_work_employee_ids'] is List
        ? List<dynamic>.from(json['staff_can_create_work_employee_ids'])
        : [];
    timelineAccessStaff = json['timeline_access_staff']?.toString();
    timelineAccessStaffEmployeeIds = json['timeline_access_staff_employee_ids'] is List
        ? List<dynamic>.from(json['timeline_access_staff_employee_ids'])
        : [];
    staffCanCreateCustomer = json['staff_can_create_customer']?.toString();
    staffCanCreateCustomerEmployeeIds = json['staff_can_create_customer_employee_ids'] is List
        ? List<dynamic>.from(json['staff_can_create_customer_employee_ids'])
        : [];
    geofencingRadius = json['geofencing_radius'] is num
        ? json['geofencing_radius']
        : num.tryParse(json['geofencing_radius']?.toString() ?? '');
    workFormOpens = json['work_form_opens']?.toString();
    updatedAt = json['updated_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['company_id'] = companyId;
    data['location_interval'] = locationInterval;
    data['idle_time'] = idleTime;
    data['idle_time_custom_minutes'] = idleTimeCustomMinutes;
    data['staff_can_create_work'] = staffCanCreateWork;
    data['staff_can_create_work_employee_ids'] = staffCanCreateWorkEmployeeIds;
    data['timeline_access_staff'] = timelineAccessStaff;
    data['timeline_access_staff_employee_ids'] = timelineAccessStaffEmployeeIds;
    data['staff_can_create_customer'] = staffCanCreateCustomer;
    data['staff_can_create_customer_employee_ids'] = staffCanCreateCustomerEmployeeIds;
    data['geofencing_radius'] = geofencingRadius;
    data['work_form_opens'] = workFormOpens;
    data['updated_at'] = updatedAt;
    return data;
  }

  /// Location interval in minutes (default 5 min if not specified)
  int get locationIntervalMinutes {
    if (locationInterval == null || locationInterval!.trim().isEmpty) return 5;
    final digits = locationInterval!.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(digits) ?? 5;
  }

  /// Location interval in milliseconds for BackgroundGeolocation config
  int get locationIntervalMillis => locationIntervalMinutes * 60 * 1000;

  /// Idle time in minutes for stopTimeout (default 10 min if not specified)
  int get idleTimeMinutes {
    if (idleTimeCustomMinutes != null && idleTimeCustomMinutes! > 0) {
      return idleTimeCustomMinutes!;
    }
    if (idleTime == null || idleTime!.trim().isEmpty) return 10;
    final digits = idleTime!.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(digits) ?? 10;
  }

  /// Geofencing radius in meters (default 500m if not specified)
  double get geofencingRadiusMeters {
    if (geofencingRadius == null) return 500.0;
    return geofencingRadius!.toDouble();
  }

  /// Formatted radius string for display (e.g. "1 km" or "500 m")
  String get geofencingRadiusDisplay {
    final meters = geofencingRadiusMeters;
    if (meters >= 1000.0) {
      final km = meters / 1000.0;
      final kmStr = (km % 1 == 0) ? km.toInt().toString() : km.toStringAsFixed(1);
      return '$kmStr km';
    }
    return '${meters.toInt()} m';
  }

  /// Whether staff member can create work
  bool canStaffCreateWork(String? employeeId) {
    if (staffCanCreateWork == 'all_staff') return true;
    if (employeeId == null || employeeId.isEmpty) return false;
    final empStr = employeeId.trim();
    return staffCanCreateWorkEmployeeIds?.any((id) => id.toString().trim() == empStr) ?? false;
  }

  /// Whether staff member can create customer
  bool canStaffCreateCustomer(String? employeeId) {
    if (staffCanCreateCustomer == 'all_staff') return true;
    if (employeeId == null || employeeId.isEmpty) return false;
    final empStr = employeeId.trim();
    return staffCanCreateCustomerEmployeeIds?.any((id) => id.toString().trim() == empStr) ?? false;
  }

  /// Whether staff member has access to timeline
  bool hasTimelineAccess(String? employeeId) {
    if (timelineAccessStaff == 'on') return true;
    if (timelineAccessStaff == 'off') {
      if (employeeId == null || employeeId.isEmpty) return false;
      final empStr = employeeId.trim();
      return timelineAccessStaffEmployeeIds?.any((id) => id.toString().trim() == empStr) ?? false;
    }
    return true;
  }

  /// Whether work form opens on starting work
  bool get openWorkFormOnStart => workFormOpens == 'on_start_work';

  /// Whether work form opens on ending work
  bool get openWorkFormOnEnd => workFormOpens == 'on_end_work' || workFormOpens == null;
}


// class CompanySettingsResponse {
//   int? status;
//   String? message;
//   CompanySettingData? data;

//   CompanySettingsResponse({this.status, this.message, this.data});

//   CompanySettingsResponse.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     data = json['data'] != null
//         ? CompanySettingData.fromJson(json['data'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> map = {};
//     map['status'] = status;
//     map['message'] = message;
//     if (data != null) {
//       map['data'] = data!.toJson();
//     }
//     return map;
//   }
// }

// class CompanySettingData {
//   int? id;
//   int? companyId;
//   String? locationInterval;
//   String? idleTime;
//   int? idleTimeCustomMinutes;
//   String? staffCanCreateWork;
//   List<dynamic>? staffCanCreateWorkEmployeeIds;
//   String? timelineAccessStaff;
//   List<dynamic>? timelineAccessStaffEmployeeIds;
//   String? staffCanCreateCustomer;
//   List<dynamic>? staffCanCreateCustomerEmployeeIds;
//   num? geofencingRadius;
//   String? workFormOpens;
//   String? updatedAt;

//   CompanySettingData({
//     this.id,
//     this.companyId,
//     this.locationInterval,
//     this.idleTime,
//     this.idleTimeCustomMinutes,
//     this.staffCanCreateWork,
//     this.staffCanCreateWorkEmployeeIds,
//     this.timelineAccessStaff,
//     this.timelineAccessStaffEmployeeIds,
//     this.staffCanCreateCustomer,
//     this.staffCanCreateCustomerEmployeeIds,
//     this.geofencingRadius,
//     this.workFormOpens,
//     this.updatedAt,
//   });

//   CompanySettingData.fromJson(Map<String, dynamic> json) {
//     id = json['id'] is num ? (json['id'] as num).toInt() : int.tryParse(json['id']?.toString() ?? '');
//     companyId = json['company_id'] is num
//         ? (json['company_id'] as num).toInt()
//         : int.tryParse(json['company_id']?.toString() ?? '');
//     locationInterval = json['location_interval']?.toString();
//     idleTime = json['idle_time']?.toString();
//     idleTimeCustomMinutes = json['idle_time_custom_minutes'] is num
//         ? (json['idle_time_custom_minutes'] as num).toInt()
//         : int.tryParse(json['idle_time_custom_minutes']?.toString() ?? '');
//     staffCanCreateWork = json['staff_can_create_work']?.toString();
//     staffCanCreateWorkEmployeeIds = json['staff_can_create_work_employee_ids'] is List
//         ? List<dynamic>.from(json['staff_can_create_work_employee_ids'])
//         : [];
//     timelineAccessStaff = json['timeline_access_staff']?.toString();
//     timelineAccessStaffEmployeeIds = json['timeline_access_staff_employee_ids'] is List
//         ? List<dynamic>.from(json['timeline_access_staff_employee_ids'])
//         : [];
//     staffCanCreateCustomer = json['staff_can_create_customer']?.toString();
//     staffCanCreateCustomerEmployeeIds = json['staff_can_create_customer_employee_ids'] is List
//         ? List<dynamic>.from(json['staff_can_create_customer_employee_ids'])
//         : [];
//     geofencingRadius = json['geofencing_radius'] is num
//         ? json['geofencing_radius']
//         : num.tryParse(json['geofencing_radius']?.toString() ?? '');
//     workFormOpens = json['work_form_opens']?.toString();
//     updatedAt = json['updated_at']?.toString();
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {};
//     data['id'] = id;
//     data['company_id'] = companyId;
//     data['location_interval'] = locationInterval;
//     data['idle_time'] = idleTime;
//     data['idle_time_custom_minutes'] = idleTimeCustomMinutes;
//     data['staff_can_create_work'] = staffCanCreateWork;
//     data['staff_can_create_work_employee_ids'] = staffCanCreateWorkEmployeeIds;
//     data['timeline_access_staff'] = timelineAccessStaff;
//     data['timeline_access_staff_employee_ids'] = timelineAccessStaffEmployeeIds;
//     data['staff_can_create_customer'] = staffCanCreateCustomer;
//     data['staff_can_create_customer_employee_ids'] = staffCanCreateCustomerEmployeeIds;
//     data['geofencing_radius'] = geofencingRadius;
//     data['work_form_opens'] = workFormOpens;
//     data['updated_at'] = updatedAt;
//     return data;
//   }

//   /// Location interval in minutes (default 5 min if not specified)
//   int get locationIntervalMinutes {
//     if (locationInterval == null || locationInterval!.trim().isEmpty) return 5;
//     final digits = locationInterval!.replaceAll(RegExp(r'[^0-9]'), '');
//     return int.tryParse(digits) ?? 5;
//   }

//   /// Location interval in milliseconds for BackgroundGeolocation config
//   int get locationIntervalMillis => locationIntervalMinutes * 60 * 1000;

//   /// Idle time in minutes for stopTimeout (default 10 min if not specified)
//   int get idleTimeMinutes {
//     if (idleTimeCustomMinutes != null && idleTimeCustomMinutes! > 0) {
//       return idleTimeCustomMinutes!;
//     }
//     if (idleTime == null || idleTime!.trim().isEmpty) return 10;
//     final digits = idleTime!.replaceAll(RegExp(r'[^0-9]'), '');
//     return int.tryParse(digits) ?? 10;
//   }

//   /// Geofencing radius in meters (if <= 10, assumed to be in kilometers; e.g. 1 -> 1000m)
//   double get geofencingRadiusMeters {
//     if (geofencingRadius == null) return 1000.0;
//     final val = geofencingRadius!.toDouble();
//     if (val <= 10.0) {
//       return val * 1000.0;
//     }
//     return val;
//   }

//   /// Formatted radius string for display (e.g. "1 km" or "500 m")
//   String get geofencingRadiusDisplay {
//     final meters = geofencingRadiusMeters;
//     if (meters >= 1000.0) {
//       final km = meters / 1000.0;
//       final kmStr = (km % 1 == 0) ? km.toInt().toString() : km.toStringAsFixed(1);
//       return '$kmStr km';
//     }
//     return '${meters.toInt()} m';
//   }

//   /// Whether staff member can create work
//   bool canStaffCreateWork(String? employeeId) {
//     if (staffCanCreateWork == 'all_staff') return true;
//     if (employeeId == null || employeeId.isEmpty) return false;
//     final empStr = employeeId.trim();
//     return staffCanCreateWorkEmployeeIds?.any((id) => id.toString().trim() == empStr) ?? false;
//   }

//   /// Whether staff member can create customer
//   bool canStaffCreateCustomer(String? employeeId) {
//     if (staffCanCreateCustomer == 'all_staff') return true;
//     if (employeeId == null || employeeId.isEmpty) return false;
//     final empStr = employeeId.trim();
//     return staffCanCreateCustomerEmployeeIds?.any((id) => id.toString().trim() == empStr) ?? false;
//   }

//   /// Whether staff member has access to timeline
//   bool hasTimelineAccess(String? employeeId) {
//     if (timelineAccessStaff == 'on') return true;
//     if (timelineAccessStaff == 'off') {
//       if (employeeId == null || employeeId.isEmpty) return false;
//       final empStr = employeeId.trim();
//       return timelineAccessStaffEmployeeIds?.any((id) => id.toString().trim() == empStr) ?? false;
//     }
//     return true;
//   }

//   /// Whether work form opens on starting work
//   bool get openWorkFormOnStart => workFormOpens == 'on_start_work';

//   /// Whether work form opens on ending work
//   bool get openWorkFormOnEnd => workFormOpens == 'on_end_work' || workFormOpens == null;
// }
