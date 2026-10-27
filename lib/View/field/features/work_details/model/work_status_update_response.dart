// class WorkStatusUpdateResponse {
//   int? status;
//   String? message;
//   Data? data;

//   WorkStatusUpdateResponse({this.status, this.message, this.data});

//   WorkStatusUpdateResponse.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     data = json['data'] != null ? Data.fromJson(json['data']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['status'] = status;
//     data['message'] = message;
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     return data;
//   }
// }

// class Data {
//   int? id;
//   int? workId;
//   int? employeeId;
//   // String? scheduledDate;
//   // String? plannedStartTime;
//   // String? plannedEndTime;
//   // String? actualStartTime;
//   // Null? actualEndTime;
//   // String? workStatus;
//   // String? otpStatus;
//   // Null? approvalStatus;
//   // String? createdAt;

//   Data(
//       {this.id,
//       this.workId,
//       this.employeeId,
//       // this.scheduledDate,
//       // this.plannedStartTime,
//       // this.plannedEndTime,
//       // this.actualStartTime,
//       // this.actualEndTime,
//       // this.workStatus,
//       // this.otpStatus,
//       // this.approvalStatus,
//       // this.createdAt
//       });

//   Data.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     workId = json['work_id'];
//     employeeId = json['employee_id'];
//     // scheduledDate = json['scheduled_date'];
//     // plannedStartTime = json['planned_start_time'];
//     // plannedEndTime = json['planned_end_time'];
//     // actualStartTime = json['actual_start_time'];
//     // actualEndTime = json['actual_end_time'];
//     // workStatus = json['work_status'];
//     // otpStatus = json['otp_status'];
//     // approvalStatus = json['approval_status'];
//     // createdAt = json['created_at'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();
//     data['id'] = id;
//     data['work_id'] = workId;
//     // data['employee_id'] = employeeId;
//     // data['scheduled_date'] = scheduledDate;
//     // data['planned_start_time'] = plannedStartTime;
//     // data['planned_end_time'] = plannedEndTime;
//     // data['actual_start_time'] = actualStartTime;
//     // data['actual_end_time'] = actualEndTime;
//     // data['work_status'] = workStatus;
//     // data['otp_status'] = otpStatus;
//     // data['approval_status'] = approvalStatus;
//     // data['created_at'] = createdAt;
//     return data;
//   }
// }
