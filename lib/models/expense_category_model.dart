

class WorkExpenseCategoryModel {
  int? status;
  String? message;
  List<dynamic>? errors;
  List<Category>? result;

  WorkExpenseCategoryModel(
      {this.status, this.message, this.errors, this.result});

  WorkExpenseCategoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    errors = json['errors'];
    if (json['result'] != null) {
      result = <Category>[];
      json['result'].forEach((v) {
        result!.add(Category.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['errors'] = errors;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Category {
  int? categoryId;
  // String? companyId;
  String? categoryName;
  // int? isActive;
  // int? createdBy;
  // String? createdOn;
  // int? modifiedBy;
  // String? modifiedOn;

  Category(
      {this.categoryId,
        // this.companyId,
        this.categoryName,
        // this.isActive,
        // this.createdBy,
        // this.createdOn,
        // this.modifiedBy,
        // this.modifiedOn,
      });

  Category.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'];
    // companyId = json['companyId'];
    categoryName = json['categoryName'];
    // isActive = json['isActive'];
    // createdBy = json['createdBy'];
    // createdOn = json['createdOn'];
    // modifiedBy = json['modifiedBy'];
    // modifiedOn = json['modifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['categoryId'] = categoryId;
    // data['companyId'] = companyId;
    data['categoryName'] = categoryName;
    // data['isActive'] = isActive;
    // data['createdBy'] = createdBy;
    // data['createdOn'] = createdOn;
    // data['modifiedBy'] = modifiedBy;
    // data['modifiedOn'] = modifiedOn;
    return data;
  }
}