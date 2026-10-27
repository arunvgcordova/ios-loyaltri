class ActionCentreApi {
  int? status;
  String? message;
  // List<Null>? errors;
  List<ActionData>? result;

  ActionCentreApi({this.status, this.message, this.result});

  ActionCentreApi.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    // if (json['errors'] != null) {
    //   errors = <Null>[];
    //   json['errors'].forEach((v) {
    //     errors!.add(new Null.fromJson(v));
    //   });
    // }
    if (json['result'] != null) {
      result = <ActionData>[];
      json['result'].forEach((v) {
        result!.add(new ActionData.fromJson(v));
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

class ActionData {
  String? type;
  String? actionTitle;
  String? actionDescription;

  ActionData({this.type, this.actionTitle, this.actionDescription});

  ActionData.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    actionTitle = json['actionTitle'];
    actionDescription = json['actionDescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['actionTitle'] = this.actionTitle;
    data['actionDescription'] = this.actionDescription;
    return data;
  }
}