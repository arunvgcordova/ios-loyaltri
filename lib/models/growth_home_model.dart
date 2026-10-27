class MissionVisionModel {
  String? status;
  String? message;
  MissionVisionData? data;

  MissionVisionModel({this.status, this.message, this.data});

  MissionVisionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? MissionVisionData.fromJson(json['data'])
        : null;
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

class MissionVisionData {
  // String? id;
  // int? organisationId;
  String? mission;
  String? vision;
  // int? isActive;
  // String? createdOn;
  // int? createdBy;
  // int? modifiedBy;
  // String? modifiedOn;

  MissionVisionData({
    // this.id,
    // this.organisationId,
    this.mission,
    this.vision,
    // this.isActive,
    // this.createdOn,
    // this.createdBy,
    // this.modifiedBy,
    // this.modifiedOn
  });

  MissionVisionData.fromJson(Map<String, dynamic> json) {
    // id = json['id'];
    // organisationId = json['organisationId'];
    mission = json['mission'];
    vision = json['vision'];
    // isActive = json['isActive'];
    // createdOn = json['createdOn'];
    // createdBy = json['createdBy'];
    // modifiedBy = json['modifiedBy'];
    // modifiedOn = json['modifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // data['id'] = id;
    // data['organisationId'] = organisationId;
    data['mission'] = mission;
    data['vision'] = vision;
    // data['isActive'] = isActive;
    // data['createdOn'] = createdOn;
    // data['createdBy'] = createdBy;
    // data['modifiedBy'] = modifiedBy;
    // data['modifiedOn'] = modifiedOn;
    return data;
  }
}

class ProgressModel {
  int? status;
  String? message;
  ProgressData? data;

  ProgressModel({this.status, this.message, this.data});

  ProgressModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? ProgressData.fromJson(json['data']) : null;
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

class ProgressData {
  double? overallPercentage;
  // double? improvementPercentage;

  ProgressData({
    this.overallPercentage,
    // this.improvementPercentage
  });

  ProgressData.fromJson(Map<String, dynamic> json) {
    overallPercentage = double.tryParse(
      json['overallPercentage']?.toString() ?? '0.0',
    );
    // improvementPercentage = json['improvementPercentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['overallPercentage'] = overallPercentage;
    // data['improvementPercentage'] = improvementPercentage;
    return data;
  }
}

class MoodPulseApi {
  int? status;
  String? message;
  MoodPulseData? data;

  MoodPulseApi({this.status, this.message, this.data});

  MoodPulseApi.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? MoodPulseData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class MoodPulseData {
  int? score;
  // String? label;
  // String? createdOn;

  MoodPulseData({
    this.score,
    // this.label,
    // this.createdOn
  });

  MoodPulseData.fromJson(Map<String, dynamic> json) {
    score = json['score'];
    // label = json['label'];
    // createdOn = json['createdOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['score'] = this.score;
    // data['label'] = this.label;
    // data['createdOn'] = this.createdOn;
    return data;
  }
}

class MoodPulseSubmitRep {
  int? status;
  String? message;
  MoodPulseSubmitData? data;

  MoodPulseSubmitRep({this.status, this.message, this.data});

  MoodPulseSubmitRep.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? new MoodPulseSubmitData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class MoodPulseSubmitData {
  // int? id;
  // int? companyId;
  int? score;
  // String? label;
  // int? createdBy;
  // String? createdOn;

  MoodPulseSubmitData({
    // this.id,
    // this.companyId,
    this.score,
    // this.label,
    // this.createdBy,
    // this.createdOn
  });

  MoodPulseSubmitData.fromJson(Map<String, dynamic> json) {
    // id = json['id'];
    // companyId = json['companyId'];
    score = json['score'];
    // label = json['label'];
    // createdBy = json['createdBy'];
    // createdOn = json['createdOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['id'] = this.id;
    // data['companyId'] = this.companyId;
    data['score'] = this.score;
    // data['label'] = this.label;
    // data['createdBy'] = this.createdBy;
    // data['createdOn'] = this.createdOn;
    return data;
  }
}

class EvaluationListApi {
  int? status;
  String? message;
  List<EvaluationData>? data;

  EvaluationListApi({this.status, this.message, this.data});

  EvaluationListApi.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <EvaluationData>[];
      json['data'].forEach((v) {
        data!.add(new EvaluationData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EvaluationData {
  String? templateName;
  String? cycleName;
  String? displayShortForm;
  int? cycleId;
  String? status;
  String? startMonth;
  String? endMonth;
  String? statusColor;
  List<CycleReviews>? cycleReviews;
  int? isSelfReview;
  double? avgScore;
  List<KraTemplate>? kraTemplate;

  List<ManagerCommentData>? reviews;

  EvaluationData({
    this.templateName,
    this.cycleName,
    this.displayShortForm,
    this.cycleId,
    this.status,
    this.startMonth,
    this.endMonth,
    this.statusColor,
    this.cycleReviews,
    this.isSelfReview,
    this.avgScore,
    this.kraTemplate,
    this.reviews,
  });

  EvaluationData.fromJson(Map<String, dynamic> json) {
    templateName = json['templateName'];
    cycleName = json['cycleName'];
    displayShortForm = json['displayShortForm']?.toString();
    cycleId = json['cycleId'];
    status = json['status']?.toString();
    startMonth = json['startMonth'];
    endMonth = json['endMonth'];
    statusColor = json['statusColor'];
    if (json['cycleReviews'] != null) {
      cycleReviews = <CycleReviews>[];
      json['cycleReviews'].forEach((v) {
        cycleReviews!.add(new CycleReviews.fromJson(v));
      });
    }
    isSelfReview = json['isSelfReview'];
    avgScore = double.parse(json['avgScore']?.toString() ?? '0');
    if (json['kraTemplate'] != null) {
      kraTemplate = <KraTemplate>[];
      json['kraTemplate'].forEach((v) {
        kraTemplate!.add(new KraTemplate.fromJson(v));
      });
    }
    if (json['reviews'] != null) {
      reviews = <ManagerCommentData>[];
      json['reviews'].forEach((v) {
        reviews!.add(ManagerCommentData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['templateName'] = this.templateName;
    data['cycleName'] = this.cycleName;
    data['displayShortForm'] = this.displayShortForm;
    data['cycleId'] = this.cycleId;
    data['status'] = this.status;
    data['startMonth'] = this.startMonth;
    data['endMonth'] = this.endMonth;
    data['statusColor'] = this.statusColor;
    if (this.cycleReviews != null) {
      data['cycleReviews'] = this.cycleReviews!.map((v) => v.toJson()).toList();
    }
    data['isSelfReview'] = this.isSelfReview;
    data['avgScore'] = this.avgScore;
    if (this.kraTemplate != null) {
      data['kraTemplate'] = this.kraTemplate!.map((v) => v.toJson()).toList();
    }
    if (this.reviews != null) {
      data['reviews'] = this.reviews!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ManagerCommentData {
  String? overallComment;
  String? createdOn;
  CreatedByEmployee? createdByEmployee;

  ManagerCommentData({
    this.overallComment,
    this.createdOn,
    this.createdByEmployee,
  });

  ManagerCommentData.fromJson(Map<String, dynamic> json) {
    overallComment = json['overallComment'];
    createdOn = json['createdOn'];

    if (json['createdByEmployee'] != null && json['createdByEmployee'] is Map<String, dynamic>) {
      createdByEmployee = CreatedByEmployee.fromJson(json['createdByEmployee']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['overallComment'] = overallComment;
    data['createdOn'] = createdOn;
    if (createdByEmployee != null) {
      data['createdByEmployee'] = createdByEmployee!.toJson();
    }
    return data;
  }
}

class CreatedByEmployee {
  int? employeeId;
  String? fullName;
  String? designation;
  String? profilePicture;

  CreatedByEmployee({
    this.employeeId,
    this.fullName,
    this.designation,
    this.profilePicture,
  });

  CreatedByEmployee.fromJson(Map<String, dynamic> json) {
    employeeId = json['employeeId'] is int
        ? json['employeeId']
        : int.tryParse(json['employeeId']?.toString() ?? '');
    fullName = json['fullName'];
    designation = json['designation'];
    profilePicture = json['profilePicture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['employeeId'] = employeeId;
    data['fullName'] = fullName;
    data['designation'] = designation;
    data['profilePicture'] = profilePicture;
    return data;
  }
}

class CycleReviews {
  int? overallScore;
  int? isSelfReview;
  int? reviewId;

  CycleReviews({this.overallScore, this.isSelfReview, this.reviewId});

  CycleReviews.fromJson(Map<String, dynamic> json) {
    overallScore = json['overallScore'];
    isSelfReview = json['isSelfReview'];
    reviewId = json['reviewId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['overallScore'] = this.overallScore;
    data['isSelfReview'] = this.isSelfReview;
    data['reviewId'] = this.reviewId;
    return data;
  }
}

class KraTemplate {
  String? kraName;
  List<CyclePoints>? cyclePoints;

  KraTemplate({this.kraName, this.cyclePoints});

  KraTemplate.fromJson(Map<String, dynamic> json) {
    kraName = json['kraName'];
    if (json['cyclePoints'] != null) {
      cyclePoints = <CyclePoints>[];
      json['cyclePoints'].forEach((v) {
        cyclePoints!.add(new CyclePoints.fromJson(v, json['kraName']));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kraName'] = this.kraName;
    if (this.cyclePoints != null) {
      data['cyclePoints'] = this.cyclePoints!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CyclePoints {
  int? cyclePointId;
  String? title;
  String? kraName;
  int? weight;
  List<CyclePointScores>? cyclePointScores;
  double? avgScore;

  CyclePoints({
    this.cyclePointId,
    this.title,
    this.kraName,
    this.weight,
    this.cyclePointScores,
    this.avgScore,
  });

  CyclePoints.fromJson(Map<String, dynamic> json, String? kra) {
    cyclePointId = json['cyclePointId'];
    title = json['title'];
    kraName = kra;
    weight = json['weight'];
    if (json['cyclePointScores'] != null) {
      cyclePointScores = <CyclePointScores>[];
      json['cyclePointScores'].forEach((v) {
        cyclePointScores!.add(new CyclePointScores.fromJson(v));
      });
    }
    avgScore = double.parse(json['avgScore']?.toString() ?? '0');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cyclePointId'] = this.cyclePointId;
    data['title'] = this.title;
    data['weight'] = this.weight;
    if (this.cyclePointScores != null) {
      data['cyclePointScores'] = this.cyclePointScores!
          .map((v) => v.toJson())
          .toList();
    }
    data['avgScore'] = this.avgScore;
    return data;
  }
}

class CyclePointScores {
  int? score;

  CyclePointScores({this.score});

  CyclePointScores.fromJson(Map<String, dynamic> json) {
    score = json['score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['score'] = this.score;
    return data;
  }
}

class SelfEvaluationSave {
  String? companyId;
  String? employeeId;
  String? superiorEmployeeId;
  String? overallComment;
  int? isSelfReview;
  int? reviewId;
  List<Points>? points;
  int? cycleId;
  int? recommentedAction;
  String? recommentedSubAction;
  String? employeeFeedback;

  SelfEvaluationSave({
    this.companyId,
    this.employeeId,
    this.superiorEmployeeId,
    this.overallComment,
    this.isSelfReview,
    this.reviewId,
    this.points,
    this.cycleId,
    this.recommentedAction,
    this.recommentedSubAction,
    this.employeeFeedback,
  });

  SelfEvaluationSave.fromJson(Map<String, dynamic> json) {
    companyId = json['companyId'];
    employeeId = json['employeeId'];
    superiorEmployeeId = json['superiorEmployeeId'];
    overallComment = json['overallComment'];
    isSelfReview = json['isSelfReview'];
    reviewId = json['reviewId'];
    if (json['points'] != null) {
      points = <Points>[];
      json['points'].forEach((v) {
        points!.add(new Points.fromJson(v));
      });
    }
    cycleId = json['cycleId'];
    recommentedAction = json['recommentedAction'];
    recommentedSubAction = json['recommentedSubAction'];
    employeeFeedback = json['employeeFeedback'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['companyId'] = this.companyId;
    data['employeeId'] = this.employeeId;
    data['superiorEmployeeId'] = this.superiorEmployeeId;
    data['overallComment'] = this.overallComment;
    data['isSelfReview'] = this.isSelfReview;
    data['reviewId'] = this.reviewId;
    if (this.points != null) {
      data['points'] = this.points!.map((v) => v.toJson()).toList();
    }
    data['cycleId'] = this.cycleId;
    data['recommentedAction'] = this.recommentedAction;
    data['recommentedSubAction'] = this.recommentedSubAction;
    data['employeeFeedback'] = this.employeeFeedback;
    return data;
  }
}

class Points {
  int? cyclePointId;
  int? score;
  List<Comments>? comments;

  Points({this.cyclePointId, this.score, this.comments});

  Points.fromJson(Map<String, dynamic> json) {
    cyclePointId = json['cyclePointId'];
    score = json['score'];
    if (json['comments'] != null) {
      comments = <Comments>[];
      json['comments'].forEach((v) {
        comments!.add(new Comments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cyclePointId'] = this.cyclePointId;
    data['score'] = this.score;
    if (this.comments != null) {
      data['comments'] = this.comments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Comments {
  String? comment;

  Comments({this.comment});

  Comments.fromJson(Map<String, dynamic> json) {
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comment'] = this.comment;
    return data;
  }
}
