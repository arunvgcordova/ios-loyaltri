class LoginCredentials {
  final String username;
  final String password;
  const LoginCredentials({required this.username, required this.password});

  factory LoginCredentials.fromJson(Map<String, dynamic> json) =>
      LoginCredentials(username: json['username'], password: json['password']);

  Map<String, dynamic> toJson(LoginCredentials loginData) => {
    'username': loginData.username,
    'password': loginData.password,
  };
}

class UserAPI {
  final bool? status;
  final String? message;
  final UserData? userData;
  const UserAPI({this.status, this.message, this.userData});

  factory UserAPI.fromJson(Map<String, dynamic> json) => UserAPI(
    status: json['status'],
    message: json['message'],
    userData: json['userData'] is Map
        ? json['userData'] != null
        ? UserData.fromJson(json['userData'])
        : null
        : null,
  );

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'userData': userData?.toJson(),
  };
}

class UserData {
  final String? employeeId;
  final List<int>? companyId;
  // final String? firstName;
  // final String? middleName;
  // final String? lastName;
  // final String? nickName;
  // final String? dateOfBirth;
  // final String? gender;
  // final String? religionId;
  // final String? bloodGroup;
  // final String? isActive;
  // final String? createdBy;
  // final String? createdOn;
  // final String? modifiedBy;
  // final String? modifiedOn;
  // final String? phone;
  final String? email;
  final String? organisationId;
  String? token;
  final int? loginType;
  final bool? attendanceEdit;
  final bool? unrestrictedList;
  final bool? isGrowthModule;
  final List<int>? permissions;
  final bool? offlineMode;
  // final String? profilePicture;

  UserData({
    this.employeeId,
    this.companyId,
    // this.firstName,
    // this.middleName,
    // this.lastName,
    // this.nickName,
    // this.dateOfBirth,
    // this.gender,
    // this.religionId,
    // this.bloodGroup,
    // this.isActive,
    // this.createdBy,
    // this.createdOn,
    // this.modifiedBy,
    // this.modifiedOn,
    // this.phone,
    this.email,
    this.organisationId,
    this.token,
    this.loginType,
    this.attendanceEdit,
    this.unrestrictedList,
    this.isGrowthModule,
    this.permissions,
    this.offlineMode,
    // this.profilePicture,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    employeeId: json['employeeId'],
    companyId: (json['companyId'] as List?)?.cast<int>(),
    // firstName: json['firstName'],
    // middleName: json['middleName'],
    // lastName: json['lastName'],
    // nickName: json['nickName'],
    // dateOfBirth: json['dateOfBirth'],
    // gender: json['gender'],
    // religionId: json['religionId'],
    // bloodGroup: json['bloodGroup'],
    // isActive: json['isActive'],
    // createdBy: json['createdBy'],
    // createdOn: json['createdOn'],
    // modifiedBy: json['modifiedBy'],
    // modifiedOn: json['modifiedOn'],
    // phone: json['phone'],
    email: json['email'],
    organisationId: json['organisationId'],
    token: json['token'],
    loginType: json['loginType'],
    attendanceEdit: json['attendanceEdit'],
    unrestrictedList: json['unrestrictedList'],
    isGrowthModule: json['isGrowthModule'],
    permissions: json['permissions'] is List
        ? (json['permissions'] as List?)?.cast<int>()
        : [],
    offlineMode: json['offlineMode'] is bool
        ? json['offlineMode']
        : json['offlineMode'] is int
        ? json['offlineMode'] == 1
        : json['offlineMode'] is String
        ? (json['offlineMode'].toLowerCase() == 'true' ||
        json['offlineMode'] == '1')
        : false,
    // profilePicture: json['profilePicture'],
  );

  Map<String, dynamic> toJson() => {
    'employeeId': employeeId,
    'companyId': companyId,
    // 'firstName': firstName,
    // 'middleName': middleName,
    // 'lastName': lastName,
    // 'nickName': nickName,
    // 'dateOfBirth': dateOfBirth,
    // 'gender': gender,
    // 'religionId': religionId,
    // 'bloodGroup': bloodGroup,
    // 'isActive': isActive,
    // 'createdBy': createdBy,
    // 'createdOn': createdOn,
    // 'modifiedBy': modifiedBy,
    // 'modifiedOn': modifiedOn,
    // 'phone': phone,
    'email': email,
    'organisationId': organisationId,
    'token': token,
    'loginType': loginType,
    'attendanceEdit': attendanceEdit,
    'unrestrictedList': unrestrictedList,
    'isGrowthModule': isGrowthModule,
    'permissions': permissions,
    'offlineMode': offlineMode,
    // 'profilePicture': profilePicture,
  };
}