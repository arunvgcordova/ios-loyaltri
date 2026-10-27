class FeedListDataApi {
  int? status;
  String? message;
  // List<Null>? errors;
  List<FeedData>? result;

  FeedListDataApi({this.status, this.message, this.result});

  FeedListDataApi.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    // if (json['errors'] != null) {
    //   errors = <Null>[];
    //   json['errors'].forEach((v) {
    //     errors!.add(new Null.fromJson(v));
    //   });
    // }
    if (json['result'] != null) {
      result = <FeedData>[];
      json['result'].forEach((v) {
        result!.add(new FeedData.fromJson(v));
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

class FeedData {
  String? feedsId;
  String? companyId;
  String? title;
  String? description;
  String? isActive;
  String? createdBy;
  String? createdOn;
  // Null? modifiedBy;
  String? modifiedOn;
  String? employeeId;
  String? likesCount;
  String? commentsCount;
  List<Comments>? comments;
  int? isSignedInEmployeeLiked;
  // Null? likedPrimaryKey;
  List<Files>? files;
  // Null? feedsFiles;
  String? employeeName;
  String? profilePicture;
  String? designation;

  FeedData({
    this.feedsId,
    this.companyId,
    this.title,
    this.description,
    this.isActive,
    this.createdBy,
    this.createdOn,
    // this.modifiedBy,
    this.modifiedOn,
    this.employeeId,
    this.likesCount,
    this.commentsCount,
    this.comments,
    this.isSignedInEmployeeLiked,
    // this.likedPrimaryKey,
    this.files,
    // this.feedsFiles,
    this.employeeName,
    this.profilePicture,
    this.designation,
  });

  FeedData.fromJson(Map<String, dynamic> json) {
    feedsId = json['feedsId'];
    companyId = json['companyId'];
    title = json['title'];
    description = json['description'];
    isActive = json['isActive'];
    createdBy = json['createdBy'];
    createdOn = json['createdOn'];
    // modifiedBy = json['modifiedBy'];
    modifiedOn = json['modifiedOn'];
    employeeId = json['employeeId'];
    likesCount = json['likes_count'];
    commentsCount = json['comments_count'];
    if (json['comments'] != null) {
      comments = <Comments>[];
      json['comments'].forEach((v) {
        comments!.add(new Comments.fromJson(v));
      });
    }
    isSignedInEmployeeLiked = json['isSignedInEmployeeLiked'];
    // likedPrimaryKey = json['likedPrimaryKey'];
    if (json['files'] != null) {
      files = <Files>[];
      json['files'].forEach((v) {
        files!.add(new Files.fromJson(v));
      });
    }
    // feedsFiles = json['feeds_files'];
    employeeName = json['employeeName'];
    profilePicture = json['profilePicture'];
    designation = json['designation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['feedsId'] = this.feedsId;
    data['companyId'] = this.companyId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['isActive'] = this.isActive;
    data['createdBy'] = this.createdBy;
    data['createdOn'] = this.createdOn;
    // data['modifiedBy'] = this.modifiedBy;
    data['modifiedOn'] = this.modifiedOn;
    data['employeeId'] = this.employeeId;
    data['likes_count'] = this.likesCount;
    data['comments_count'] = this.commentsCount;
    if (this.comments != null) {
      data['comments'] = this.comments!.map((v) => v.toJson()).toList();
    }
    data['isSignedInEmployeeLiked'] = this.isSignedInEmployeeLiked;
    // data['likedPrimaryKey'] = this.likedPrimaryKey;
    if (this.files != null) {
      data['files'] = this.files!.map((v) => v.toJson()).toList();
    }
    // data['feeds_files'] = this.feedsFiles;
    data['employeeName'] = this.employeeName;
    data['profilePicture'] = this.profilePicture;
    data['designation'] = this.designation;
    return data;
  }
}

class Comments {
  String? commentsId;
  String? feedsId;
  String? employeeId;
  String? comment;
  String? isActive;
  String? createdBy;
  String? createdOn;
  // Null? modifiedBy;
  String? modifiedOn;
  String? companyId;
  String? userName;
  String? userImage;
  String? designation;

  Comments({
    this.commentsId,
    this.feedsId,
    this.employeeId,
    this.comment,
    this.isActive,
    this.createdBy,
    this.createdOn,
    // this.modifiedBy,
    this.modifiedOn,
    this.companyId,
    this.userName,
    this.userImage,
    this.designation,
  });

  Comments.fromJson(Map<String, dynamic> json) {
    commentsId = json['commentsId'];
    feedsId = json['feedsId'];
    employeeId = json['employeeId'];
    comment = json['comment'];
    isActive = json['isActive'];
    createdBy = json['createdBy'];
    createdOn = json['createdOn'];
    // modifiedBy = json['modifiedBy'];
    modifiedOn = json['modifiedOn'];
    companyId = json['companyId'];
    userName = json['userName'];
    userImage = json['userImage'];
    designation = json['designation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commentsId'] = this.commentsId;
    data['feedsId'] = this.feedsId;
    data['employeeId'] = this.employeeId;
    data['comment'] = this.comment;
    data['isActive'] = this.isActive;
    data['createdBy'] = this.createdBy;
    data['createdOn'] = this.createdOn;
    // data['modifiedBy'] = this.modifiedBy;
    data['modifiedOn'] = this.modifiedOn;
    data['companyId'] = this.companyId;
    data['userName'] = this.userName;
    data['userImage'] = this.userImage;
    data['designation'] = this.designation;
    return data;
  }
}

class Files {
  String? feedsFileId;
  String? file;

  Files({this.feedsFileId, this.file});

  Files.fromJson(Map<String, dynamic> json) {
    feedsFileId = json['feedsFileId'];
    file = json['file'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['feedsFileId'] = this.feedsFileId;
    data['file'] = this.file;
    return data;
  }
}

enum PostSettings { organization, entity, location, category, department }

class PostSetting {
  final PostSettings type;
  final String icon;
  final String title;
  final String subtitle;

  const PostSetting({
    required this.type,
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

class AllLocationsApi {
  int? status;
  String? message;
  // List<dynamic>? errors;
  List<LocationData>? result;

  AllLocationsApi({this.status, this.message, this.result});

  AllLocationsApi.fromJson(Map<String, dynamic> json) {
    if (json["status"] is num) {
      status = (json["status"] as num).toInt();
    }
    if (json["message"] is String) {
      message = json["message"];
    }
    // if (json["errors"] is List) {
    //   errors = json["errors"] ?? [];
    // }
    if (json["result"] is List) {
      result =
          json["result"] == null
              ? null
              : (json["result"] as List)
                  .map((e) => LocationData.fromJson(e))
                  .toList();
    }
  }

  static List<AllLocationsApi> fromList(List<Map<String, dynamic>> list) {
    return list.map(AllLocationsApi.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["status"] = status;
    _data["message"] = message;
    // if (errors != null) {
    //   _data["errors"] = errors;
    // }
    if (result != null) {
      _data["result"] = result?.map((e) => e.toJson()).toList();
    }
    return _data;
  }

  AllLocationsApi copyWith({
    int? status,
    String? message,
    // List<dynamic>? errors,
    List<LocationData>? result,
  }) => AllLocationsApi(
    status: status ?? this.status,
    message: message ?? this.message,
    // errors: errors ?? this.errors,
    result: result ?? this.result,
  );
}

class LocationData {
  int? locationId;
  // String? companyId;
  String? location;
  // String? description;
  // int? isActive;
  // dynamic createdBy;
  // String? createdOn;
  // dynamic modifiedBy;
  // String? modifiedOn;
  // String? locationGeoFencing;
  // dynamic locationData;
  // dynamic responsibility;

  LocationData({
    this.locationId,
    // this.companyId,
    this.location,
    // this.description,
    // this.isActive,
    // this.createdBy,
    // this.createdOn,
    // this.modifiedBy,
    // this.modifiedOn,
    // this.locationGeoFencing,
    // this.locationData,
    // this.responsibility,
  });

  LocationData.fromJson(Map<String, dynamic> json) {
    if (json["locationId"] is num) {
      locationId = (json["locationId"] as num).toInt();
    }
    // if (json["companyId"] is String) {
    //   companyId = json["companyId"];
    // }
    if (json["location"] is String) {
      location = json["location"];
    }
    // if (json["description"] is String) {
    //   description = json["description"];
    // }
    // if (json["isActive"] is num) {
    //   isActive = (json["isActive"] as num).toInt();
    // }
    // createdBy = json["createdBy"];
    // if (json["createdOn"] is String) {
    //   createdOn = json["createdOn"];
    // }
    // modifiedBy = json["modifiedBy"];
    // if (json["modifiedOn"] is String) {
    //   modifiedOn = json["modifiedOn"];
    // }
    // if (json["locationGeoFencing"] is String) {
    //   locationGeoFencing = json["locationGeoFencing"];
    // }
    // locationData = json["locationData"];
    // responsibility = json["responsibility"];
  }

  static List<LocationData> fromList(List<Map<String, dynamic>> list) {
    return list.map(LocationData.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["locationId"] = locationId;
    // _data["companyId"] = companyId;
    _data["location"] = location;
    // _data["description"] = description;
    // _data["isActive"] = isActive;
    // _data["createdBy"] = createdBy;
    // _data["createdOn"] = createdOn;
    // _data["modifiedBy"] = modifiedBy;
    // _data["modifiedOn"] = modifiedOn;
    // _data["locationGeoFencing"] = locationGeoFencing;
    // _data["locationData"] = locationData;
    // _data["responsibility"] = responsibility;
    return _data;
  }

  LocationData copyWith({
    int? locationId,
    // String? companyId,
    String? location,
    // String? description,
    // int? isActive,
    // dynamic createdBy,
    // String? createdOn,
    // dynamic modifiedBy,
    // String? modifiedOn,
    // String? locationGeoFencing,
    // dynamic locationData,
    // dynamic responsibility,
  }) => LocationData(
    locationId: locationId ?? this.locationId,
    // companyId: companyId ?? this.companyId,
    location: location ?? this.location,
    // description: description ?? this.description,
    // isActive: isActive ?? this.isActive,
    // createdBy: createdBy ?? this.createdBy,
    // createdOn: createdOn ?? this.createdOn,
    // modifiedBy: modifiedBy ?? this.modifiedBy,
    // modifiedOn: modifiedOn ?? this.modifiedOn,
    // locationGeoFencing: locationGeoFencing ?? this.locationGeoFencing,
    // locationData: locationData ?? this.locationData,
    // responsibility: responsibility ?? this.responsibility,
  );
}

class AllCategoryApi {
  int? status;
  String? message;
  // List<dynamic>? errors;
  List<CategoryData>? result;

  AllCategoryApi({this.status, this.message, this.result});

  AllCategoryApi.fromJson(Map<String, dynamic> json) {
    if (json["status"] is num) {
      status = (json["status"] as num).toInt();
    }
    if (json["message"] is String) {
      message = json["message"];
    }
    // if(json["errors"] is List) {
    //   errors = json["errors"] ?? [];
    // }
    if (json["result"] is List) {
      result =
          json["result"] == null
              ? null
              : (json["result"] as List)
                  .map((e) => CategoryData.fromJson(e))
                  .toList();
    }
  }

  static List<AllCategoryApi> fromList(List<Map<String, dynamic>> list) {
    return list.map(AllCategoryApi.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["status"] = status;
    _data["message"] = message;
    // if(errors != null) {
    //   _data["errors"] = errors;
    // }
    if (result != null) {
      _data["result"] = result?.map((e) => e.toJson()).toList();
    }
    return _data;
  }

  AllCategoryApi copyWith({
    int? status,
    String? message,
    // List<dynamic>? errors,
    List<CategoryData>? result,
  }) => AllCategoryApi(
    status: status ?? this.status,
    message: message ?? this.message,
    // errors: errors ?? this.errors,
    result: result ?? this.result,
  );
}

class CategoryData {
  int? categoryId;
  // int? companyId;
  String? category;
  // String? description;
  // int? isActive;
  // dynamic createdBy;
  // String? createdOn;
  // dynamic modifiedBy;
  // String? modifiedOn;
  // dynamic responsibility;

  CategoryData({
    this.categoryId,
    // this.companyId,
    this.category,
    // this.description,
    // this.isActive,
    // this.createdBy,
    // this.createdOn,
    // this.modifiedBy,
    // this.modifiedOn,
    // this.responsibility,
  });

  CategoryData.fromJson(Map<String, dynamic> json) {
    if (json["categoryId"] is num) {
      categoryId = (json["categoryId"] as num).toInt();
    }
    // if (json["companyId"] is num) {
    //   companyId = (json["companyId"] as num).toInt();
    // }
    if (json["category"] is String) {
      category = json["category"];
    }
    // if (json["description"] is String) {
    //   description = json["description"];
    // }
    // if (json["isActive"] is num) {
    //   isActive = (json["isActive"] as num).toInt();
    // }
    // createdBy = json["createdBy"];
    // if (json["createdOn"] is String) {
    //   createdOn = json["createdOn"];
    // }
    // modifiedBy = json["modifiedBy"];
    // if (json["modifiedOn"] is String) {
    //   modifiedOn = json["modifiedOn"];
    // }
    // responsibility = json["responsibility"];
  }

  static List<CategoryData> fromList(List<Map<String, dynamic>> list) {
    return list.map(CategoryData.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["categoryId"] = categoryId;
    // _data["companyId"] = companyId;
    _data["category"] = category;
    // _data["description"] = description;
    // _data["isActive"] = isActive;
    // _data["createdBy"] = createdBy;
    // _data["createdOn"] = createdOn;
    // _data["modifiedBy"] = modifiedBy;
    // _data["modifiedOn"] = modifiedOn;
    // _data["responsibility"] = responsibility;
    return _data;
  }

  CategoryData copyWith({
    int? categoryId,
    // int? companyId,
    String? category,
    // String? description,
    // int? isActive,
    // dynamic createdBy,
    // String? createdOn,
    // dynamic modifiedBy,
    // String? modifiedOn,
    // dynamic responsibility,
  }) => CategoryData(
    categoryId: categoryId ?? this.categoryId,
    // companyId: companyId ?? this.companyId,
    category: category ?? this.category,
    // description: description ?? this.description,
    // isActive: isActive ?? this.isActive,
    // createdBy: createdBy ?? this.createdBy,
    // createdOn: createdOn ?? this.createdOn,
    // modifiedBy: modifiedBy ?? this.modifiedBy,
    // modifiedOn: modifiedOn ?? this.modifiedOn,
    // responsibility: responsibility ?? this.responsibility,
  );
}

class AllDepartmentApi {
  int? status;
  String? message;
  // List<dynamic>? errors;
  List<DepartmentData>? result;

  AllDepartmentApi({this.status, this.message, this.result});

  AllDepartmentApi.fromJson(Map<String, dynamic> json) {
    if (json["status"] is num) {
      status = (json["status"] as num).toInt();
    }
    if (json["message"] is String) {
      message = json["message"];
    }
    // if(json["errors"] is List) {
    //   errors = json["errors"] ?? [];
    // }
    if (json["result"] is List) {
      result =
          json["result"] == null
              ? null
              : (json["result"] as List)
                  .map((e) => DepartmentData.fromJson(e))
                  .toList();
    }
  }

  static List<AllDepartmentApi> fromList(List<Map<String, dynamic>> list) {
    return list.map(AllDepartmentApi.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["status"] = status;
    _data["message"] = message;
    // if(errors != null) {
    //   _data["errors"] = errors;
    // }
    if (result != null) {
      _data["result"] = result?.map((e) => e.toJson()).toList();
    }
    return _data;
  }

  AllDepartmentApi copyWith({
    int? status,
    String? message,
    // List<dynamic>? errors,
    List<DepartmentData>? result,
  }) => AllDepartmentApi(
    status: status ?? this.status,
    message: message ?? this.message,
    // errors: errors ?? this.errors,
    result: result ?? this.result,
  );
}

class DepartmentData {
  int? departmentId;
  // String? companyId;
  String? department;
  // String? description;
  // int? isActive;
  // String? createdOn;
  // dynamic modifiedBy;
  // String? modifiedOn;
  // dynamic createdBy;
  // String? responsibility;

  DepartmentData({
    this.departmentId,
    // this.companyId,
    this.department,
    // this.description,
    // this.isActive,
    // this.createdOn,
    // this.modifiedBy,
    // this.modifiedOn,
    // this.createdBy,
    // this.responsibility,
  });

  DepartmentData.fromJson(Map<String, dynamic> json) {
    if (json["departmentId"] is num) {
      departmentId = (json["departmentId"] as num).toInt();
    }
    // if (json["companyId"] is String) {
    //   companyId = json["companyId"];
    // }
    if (json["department"] is String) {
      department = json["department"];
    }
    // if (json["description"] is String) {
    //   description = json["description"];
    // }
    // if (json["isActive"] is num) {
    //   isActive = (json["isActive"] as num).toInt();
    // }
    // if (json["createdOn"] is String) {
    //   createdOn = json["createdOn"];
    // }
    // modifiedBy = json["modifiedBy"];
    // if (json["modifiedOn"] is String) {
    //   modifiedOn = json["modifiedOn"];
    // }
    // createdBy = json["createdBy"];
    // if (json["responsibility"] is String) {
    //   responsibility = json["responsibility"];
    // }
  }

  static List<DepartmentData> fromList(List<Map<String, dynamic>> list) {
    return list.map(DepartmentData.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["departmentId"] = departmentId;
    // _data["companyId"] = companyId;
    _data["department"] = department;
    // _data["description"] = description;
    // _data["isActive"] = isActive;
    // _data["createdOn"] = createdOn;
    // _data["modifiedBy"] = modifiedBy;
    // _data["modifiedOn"] = modifiedOn;
    // _data["createdBy"] = createdBy;
    // _data["responsibility"] = responsibility;
    return _data;
  }

  DepartmentData copyWith({
    int? departmentId,
    // String? companyId,
    String? department,
    // String? description,
    // int? isActive,
    // String? createdOn,
    // dynamic modifiedBy,
    // String? modifiedOn,
    // dynamic createdBy,
    // String? responsibility,
  }) => DepartmentData(
    departmentId: departmentId ?? this.departmentId,
    // companyId: companyId ?? this.companyId,
    department: department ?? this.department,
    // description: description ?? this.description,
    // isActive: isActive ?? this.isActive,
    // createdOn: createdOn ?? this.createdOn,
    // modifiedBy: modifiedBy ?? this.modifiedBy,
    // modifiedOn: modifiedOn ?? this.modifiedOn,
    // createdBy: createdBy ?? this.createdBy,
    // responsibility: responsibility ?? this.responsibility,
  );
}
