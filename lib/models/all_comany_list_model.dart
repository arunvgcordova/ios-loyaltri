class AllCompanyListApi {
  int? status;
  String? message;
  // List<Null>? errors;
  List<CompanyListData>? result;

  AllCompanyListApi({this.status, this.message, this.result});

  AllCompanyListApi.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    // if (json['errors'] != null) {
    //   errors = <Null>[];
    //   json['errors'].forEach((v) {
    //     errors!.add(new Null.fromJson(v));
    //   });
    // }
    if (json['result'] != null) {
      result = <CompanyListData>[];
      json['result'].forEach((v) {
        result!.add(new CompanyListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    // if (this.errors != null) {
    //   data['errors'] = this.errors!.map((v) => v.toJson()).toList();
    // }
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CompanyListData {
  int? companyId;
  String? organisationId;
  String? countryId;
  String? company;
  String? description;
  String? logo;
  String? url;
  String? address;
  String? country;
  String? zipCode;
  String? cin;
  String? phone;
  String? email;
  int? isActive;
  int? createdBy;
  String? createdOn;
  // Null? modifiedBy;
  String? modifiedOn;
  String? fileType;
  String? stateId;
  String? cityId;
  String? groupId;
  String? logoName;
  int? noOfEmployees;
  String? organisation;
  String? cityName;
  String? stateName;
  String? countryName;

  CompanyListData(
      {this.companyId,
        this.organisationId,
        this.countryId,
        this.company,
        this.description,
        this.logo,
        this.url,
        this.address,
        this.country,
        this.zipCode,
        this.cin,
        this.phone,
        this.email,
        this.isActive,
        this.createdBy,
        this.createdOn,
        // this.modifiedBy,
        this.modifiedOn,
        this.fileType,
        this.stateId,
        this.cityId,
        this.groupId,
        this.logoName,
        this.noOfEmployees,
        this.organisation,
        this.cityName,
        this.stateName,
        this.countryName});

  CompanyListData.fromJson(Map<String, dynamic> json) {
    companyId = json['companyId'];
    organisationId = json['organisationId'];
    countryId = json['countryId'];
    company = json['company'];
    description = json['description'];
    logo = json['logo'];
    url = json['url'];
    address = json['address'];
    country = json['country'];
    zipCode = json['zipCode'];
    cin = json['cin'];
    phone = json['phone'];
    email = json['email'];
    isActive = json['isActive'];
    createdBy = json['createdBy'];
    createdOn = json['createdOn'];
    // modifiedBy = json['modifiedBy'];
    modifiedOn = json['modifiedOn'];
    fileType = json['fileType'];
    stateId = json['stateId'];
    cityId = json['cityId'];
    groupId = json['groupId'];
    logoName = json['logoName'];
    noOfEmployees = json['noOfEmployees'];
    organisation = json['organisation'];
    cityName = json['cityName'];
    stateName = json['stateName'];
    countryName = json['countryName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['companyId'] = this.companyId;
    data['organisationId'] = this.organisationId;
    data['countryId'] = this.countryId;
    data['company'] = this.company;
    data['description'] = this.description;
    data['logo'] = this.logo;
    data['url'] = this.url;
    data['address'] = this.address;
    data['country'] = this.country;
    data['zipCode'] = this.zipCode;
    data['cin'] = this.cin;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['isActive'] = this.isActive;
    data['createdBy'] = this.createdBy;
    data['createdOn'] = this.createdOn;
    // data['modifiedBy'] = this.modifiedBy;
    data['modifiedOn'] = this.modifiedOn;
    data['fileType'] = this.fileType;
    data['stateId'] = this.stateId;
    data['cityId'] = this.cityId;
    data['groupId'] = this.groupId;
    data['logoName'] = this.logoName;
    data['noOfEmployees'] = this.noOfEmployees;
    data['organisation'] = this.organisation;
    data['cityName'] = this.cityName;
    data['stateName'] = this.stateName;
    data['countryName'] = this.countryName;
    return data;
  }
}