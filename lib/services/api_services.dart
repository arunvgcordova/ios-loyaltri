import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/models/goals_and_subgoals_model.dart';
import 'package:loyaltri_minimal/models/growth_home_model.dart';
import 'package:loyaltri_minimal/models/manager/air_ticket_list_api_model.dart';
import 'package:loyaltri_minimal/models/manager/feed_data_list_model.dart';
import 'package:loyaltri_minimal/models/manager/piece_work_model.dart';
import 'package:loyaltri_minimal/models/task_api_models.dart';
import 'package:loyaltri_minimal/models/user_profile_api_model.dart';
import 'package:loyaltri_minimal/services/connectivity_service.dart';
import 'package:loyaltri_minimal/services/ui_model_services/api_request_model.dart';
import 'package:loyaltri_minimal/services/ui_model_services/leave_dates_model.dart';
import 'package:loyaltri_minimal/services/ui_model_services/regularization_submit_model.dart';
import 'package:loyaltri_minimal/services/ui_model_services/work_expense_model.dart';
import 'package:loyaltri_minimal/utils/api_constants.dart';
import '../View/ManagerView/Manager_Request/manager_request_controller/manager_request_controller.dart';
import '../View/My_Request/my_request_models/request_send_model.dart';
import '../View/field/features/tracking/model/sync_model.dart';
import '../View/field/features/tracking/services/sync_manager.dart';
import '../controller/userAuthentication.dart';
import '../models/checkIn_model.dart';
import '../models/work_apply_model.dart';
import 'flutter_secure_storage.dart';

class ApiServices {
  static Future<Map<String, dynamic>> userLogin({
    required String userName,
    required String psw,
    required int thirdPartyLogin,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.loginUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "username": userName,
      "password": psw,
      "thirdPartyLogin": thirdPartyLogin,
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> appliedLeaveList({
    required String empId,
    required String compId,
    required String monthYear,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.leaveListAction,
      "method": "POST",
      "kwargs": {
        "id": empId,
        "companyId": compId,
        "neededYearAndMonth": monthYear, // "2025-04"
      },
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> applyLeave({
    required ApplyLeaveModel applyLeaveData,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.fileHandler}";
    AttendanceCommonWidgets().printF(url);
    // Map apiBody = {
    //   "action": apiConstants.applyLeaveAction,
    //   "method": "POST",
    //   "jsonParams": {
    //     "employeeId": applyLeaveData.employeeId,
    //     "companyId": applyLeaveData.companyId,
    //     "leaveDateFrom": applyLeaveData.leaveDateFrom,
    //     "leaveDateTo": applyLeaveData.leaveDateTo,
    //     "totalLeaveDays": applyLeaveData.totalLeaveDays,
    //     "leaveType": applyLeaveData.leaveType,
    //     "leaveReason": applyLeaveData.leaveReason,
    //     "isActive": applyLeaveData.isActive
    //   }
    // };
    if (connection) {
      try {
        var request = http.MultipartRequest('POST', Uri.parse(url));
        // var jsonParams = {
        //   "employeeId": applyLeaveData.employeeId,
        //   "companyId": applyLeaveData.companyId,
        //   "leaveDateFrom": applyLeaveData.leaveDateFrom,
        //   "leaveDateTo": applyLeaveData.leaveDateTo,
        //   "totalLeaveDays": applyLeaveData.totalLeaveDays,
        //   "maximumLeaveLimit": applyLeaveData.maximumLeaveLimit,
        //   "leaveApplied": applyLeaveData.leaveApplied,
        //   "leaveType": applyLeaveData.leaveType,
        //   "leaveReason": applyLeaveData.leaveReason,
        //   "isActive": applyLeaveData.isActive,
        //   "isHalfDay": applyLeaveData.isHalfDay,
        // };
        var jsonParams = {
          "employeeId": applyLeaveData.employeeId,
          "companyId": applyLeaveData.companyId,
          "leaveDateFrom": applyLeaveData.leaveDateFrom,
          "leaveDateTo": applyLeaveData.leaveDateTo,
          "totalLeaveDays": applyLeaveData.totalLeaveDays,
          "leaveTypeId": applyLeaveData.leaveType,
          "leaveReason": applyLeaveData.leaveReason,
          "appliedCount": "",
          "count": applyLeaveData.maximumLeaveLimit,
          "isActive": applyLeaveData.isActive,
          "isLeave": "1",
          "createdBy": applyLeaveData.createdBy ?? applyLeaveData.employeeId,
          "halfDay": applyLeaveData.isHalfDay,
          "isRegularization": "0",
          "isExtraDuty": "0",
          "maximumLeaveLimit": applyLeaveData.maximumLeaveLimit,
          "leaveApplied": applyLeaveData.leaveApplied,
          "leaveSection": applyLeaveData.leaveSection,
          "removeAttendance": 0,
          "employeeDailyAttendanceId": [],
          "isHourBased": applyLeaveData.isHourBased,
          "leaveDate": applyLeaveData.hourLeaveDate,
          "leaveHours": applyLeaveData.leaveHours,
        };
        request.fields['action'] = apiConstants.applyLeaveAction;
        request.fields['jsonParams'] = json.encode(jsonParams);
        request.fields['action'] = apiConstants.applyLeaveAction;
        AttendanceCommonWidgets().printF(
          "---------fields----------${request.fields}",
        );
        if (applyLeaveData.files.isNotEmpty) {
          for (var file in applyLeaveData.files) {
            request.files.add(
              http.MultipartFile.fromBytes(
                'file',
                await File(file).readAsBytes(),
                filename: 'file.${file.split('.').last}',
                contentType: MediaType('file', file.split('.').last),
              ),
            );
          }
        }
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getLeaveSummary({
    required String empId,
    required String monthYr,
    String? regType,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.leaveSummaryAction,
      "method": "POST",
      "kwargs": {
        "id": empId,
        "monthYear": monthYr,
        if (regType != null) "isRegularization": 1,
        if (regType != null) "regularizeType": regType,
      },
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getLeaveType({
    required String compId,
    required String empId,
    String? monthYear,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.leaveTypeAction,
      "method": "POST",
      "kwargs": {
        "id": empId,
        "companyId": compId,
        if(monthYear != null)
          "neededYearAndMonth": monthYear,
      },
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getAttendanceList({
    required String empId,
    required String compId,
    required String yrMonth,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.attendanceListAction,
      "method": "POST",
      "kwargs": {
        "employeeId": empId,
        "companyId": compId,
        "neededYearAndMonth": yrMonth,
      },
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        AttendanceCommonWidgets().printF(
          'token---------------------->${Get.find<UserAuthController>().userData.value.userData?.token}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getCycleMonth({
    required String compId,
    required String currentData,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.payRoll}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.attendanceCycle,
      "method": "POST",
      "kwargs": {"companyId": compId, "currentDate": currentData},
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getUserProfileDetails({
    required String empId,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.employeeDetailsAction,
      "method": "POST",
      "kwargs": {"id": empId},
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException {
        throw Exception("Poor Connection");
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getUserCompanyDetails({
    required String compId,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.companyDetailsAction,
      "method": "POST",
      "kwargs": {"id": compId},
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException {
        throw Exception("Poor Connection");
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> fetchWorkEntryList({
    required String month,
    required String empId,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.workEntryAction,
      "method": "POST",
      "kwargs": {"month": month, "employeeId": empId},
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> sendWorkDetails({
    required WorkData workData,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = apiConstants.domain + apiConstants.fileHandler;
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.workEntrySendAction,
      "workName": workData.workName,
      "unitCount": workData.unitCount,
      "date": workData.date,
      // "description": workData.description,
      "location": workData.location,
      "isActive": workData.isActive,
      "createdBy": workData.createdBy,
      "employeeId": workData.employeeId,
      "companyId": workData.companyId,
    };
    if (connection) {
      try {
        var request = http.MultipartRequest('POST', Uri.parse(url));
        request.fields['action'] = apiConstants.workEntrySendAction;
        request.fields['workName'] = workData.workName;
        request.fields['unitCount'] = workData.unitCount;
        request.fields['date'] = workData.date;
        request.fields['description'] = workData.description;
        request.fields['location'] = json.encode(workData.location);
        request.fields['isActive'] = workData.isActive.toString();
        request.fields['createdBy'] = workData.createdBy.toString();
        request.fields['employeeId'] = workData.employeeId.toString();
        request.fields['companyId'] = workData.companyId.toString();
        if (workData.files.isNotEmpty) {
          for (var file in workData.files) {
            request.files.add(
              http.MultipartFile.fromBytes(
                'file[]',
                await File(file).readAsBytes(),
                filename: 'file.${file.split('.').last}',
                contentType: MediaType('file', file.split('.').last),
              ),
            );
          }
        }
        // request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->$apiBody',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> forgotPassword({
    required String email,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    final formatted = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    Map apiBody = {
      "action": apiConstants.forgotPswAction,
      "method": "POST",
      "kwargs": {
        "emailId": email,
        "dateTime": formatted, //"2026-01-07 09:26:47",
        "resetLink": apiConstants.resetLink,
      },
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("NO_INTERNET");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("NO_INTERNET");
    }
  }

  static Future<Map<String, dynamic>> changePassword({
    String? empId,
    String? oldPsw,
    String? newPsw,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.changePassword,
      "method": "POST",
      "kwargs": {
        "employeeId": empId,
        "oldPassword": oldPsw,
        "newPassword": newPsw
      }
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> sendCheckInData({
    required AttendanceCheckModel attendance,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = apiConstants.addPunch;
    AttendanceCommonWidgets().printF(url);
    String? base64Image;
    try {
      if (attendance.punchImage != null) {
        List<int> compressedBytes = await FlutterImageCompress.compressWithList(
          File(attendance.punchImage!).readAsBytesSync(),
          minHeight: 1920,
          minWidth: 1080,
          quality: 85,
        );
        base64Image = base64Encode(compressedBytes);
      }
    } catch(e) {}
    Map apiBody = {
      "action": apiConstants.sendCheckInAction,
      "method": "POST",
      "kwargs": {
        "employeeId": attendance.employeeId,
        "companyId": attendance.companyId,
        "punchDate": attendance.punchDate,
        "punchTime": attendance.punchTime,
        "punchType": "Mobile",
        "punchState": attendance.punchState,
        "punchLocation": {
          "lattitude": attendance.latitude,
          "longitude": attendance.longitude,
          "locationName": attendance.locationName ?? "",
        },
        "punchRemarks": "",
        "punchImage": base64Image,
      },
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getCalendarData({
    required String empId,
    required String monthYear,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.calendarEventAction,
      "method": "POST",
      "kwargs": {"employeeId": empId, "neededYearAndMonth": monthYear},
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getGrowthPercentage({
    required String companyId,
    required String employeeId,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {"companyId": companyId, "superiorEmployeeId": employeeId};
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getLeaveCalendarCycle({
    required String compId,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.leaveCycleAction,
      "method": "POST",
      "kwargs": {"companyId": compId},
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getUserNotifications({
    required String compId,
    required String empId,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.userNotifications,
      "method": "POST",
      "kwargs": {"superiorEmployeeId": empId, "companyId": compId},
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getAllSpecialRequestType() async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.getAllSpecialRequestType,
      "method": "POST",
      "kwargs": {"isActive": 1},
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getSpecialRequestByEmployeeId({
    required String empId,
    required String compId,
    required String filter,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.getSpecialRequestByEmployeeId,
      "method": "POST",
      "kwargs": {
        "employeeId": empId,
        "requestModule": filter, // All, Hr, Finance, Other
        "companyId": compId,
      },
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> saveShiftSwapRequest({
    required RequestSendModel requestModel,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.saveShiftSwapRequest,
      "method": "POST",
      "kwargs": {
        "date": requestModel.fromDate,
        "employeeId": requestModel.employeeId,
        "companyId": requestModel.companyId,
        "shiftId": requestModel.requestType,
        "description": requestModel.description,
      },
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> saveSalaryAdvanceRequest({
    required RequestSendModel requestModel,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.payRoll}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.saveSalaryAdvanceRequest,
      "method": "POST",
      "kwargs": {
        "companyId": requestModel.companyId,
        "employeeId": requestModel.employeeId,
        "salaryMonthYear": requestModel.dropdown1,
        "reqAmount": requestModel.amount,
        "reason": requestModel.description,
        "createdBy": requestModel.employeeId
      },
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> saveAttendanceRequest({
    required RequestSendModel requestModel,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.saveAttendanceRequest,
      "method": "POST",
      "kwargs": {
        "date": requestModel.fromDate,
        "employeeId": requestModel.employeeId,
        "companyId": requestModel.companyId,
        "checkIn": requestModel.fromTime,
        "checkOut": requestModel.toTime,
        "shiftId": requestModel.requestType,
        "description": requestModel.description,
      },
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getAllResignationReasonList() async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.getAllResignationReasonList,
      "method": "POST",
      "kwargs": {},
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getLeaveTypesWithCompanyId({
    required String compId,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.getLeaveTypesWithCompanyId,
      "method": "POST",
      "kwargs": {"companyId": compId, "isActive": 1},
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getAllLoanPolicies({
    required String compId,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.payRoll}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.getAllLoanPolicies,
      "method": "POST",
      "kwargs": {"companyId": compId, "isActive": "1"},
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> employeeLoanRequestSave({
    required RequestSendModel requestModel,
    required List<Map<String, dynamic>> tenureAmounts,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.payRoll}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.employeeLoanRequestSave,
      "method": "POST",
      "kwargs": {
        "companyId": requestModel.companyId,
        "employeeId": requestModel.employeeId,
        "loanPolicyId": requestModel.dropdown1,
        "amount": requestModel.amount,
        "reason": requestModel.description,
        "tenureMonths": requestModel.dropdown2,
        "createdBy": requestModel.employeeId,
        "tenureAmountData": tenureAmounts,
        "specialRequestTypeId": requestModel.reqId,
        "approvalTypeId": requestModel.requestType
      },
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getAllITRequestType() async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.getAllITRequestType,
      "method": "POST",
      "kwargs": {},
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getAllWorkPlaceType() async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.getAllWorkPlaceType,
      "method": "POST",
      "kwargs": {},
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> saveResignationRequest({
    required RequestSendModel requestModel,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.saveResignationRequest,
      "method": "POST",
      "kwargs": {
        "reason": requestModel.requestType,
        "employeeId": requestModel.employeeId,
        "description": requestModel.description,
        "companyId": requestModel.companyId,
      },
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getEmployeeDocuments({
    required String empId,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.getEmployeeDocuments,
      "method": "POST",
      "kwargs": {"employeeId": empId},
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getEmployeeAssetsById({
    required String empId,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.getEmployeeAssetsById,
      "method": "POST",
      "kwargs": {"employeeId": empId},
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> faceAuth({
    required String source,
    required String user,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = apiConstants.faceAuthUrl;
    AttendanceCommonWidgets().printF(url);
    List<int> compressedBytes = await FlutterImageCompress.compressWithList(
      File(source).readAsBytesSync(),
      minHeight: 1920,
      minWidth: 1080,
      quality: 85,
    );
    String base64Image = base64Encode(compressedBytes);
    Map apiBody = {
      "sourceImage": base64Image,
      "userImage": base64Image,
      "threshold": 0.92,
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> versionCheck({
    String? empId,
    String? deviceId,
    String? fcmToken,
    String? lastTime,
    String? logoutChecker,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.versionCheckHeader,
      "method": "POST",
      "kwargs": {
        "employee_id": empId,
        "device_id": deviceId,
        "firebase_message_token": fcmToken,
        "currentVersion": ApiConstants.appVersion,
        "last_used_time": lastTime,
        "platform": Platform.isIOS ? "iOS" : "Android",
        "logoutChecker": logoutChecker,
      },
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getAttSummary({
    required String empId,
    required String compId,
    required String monthYr,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.attSummaryAction,
      "method": "POST",
      "kwargs": {
        "employeeId": empId,
        "companyId": compId,
        "neededYearAndMonth": monthYr,
      },
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getPunchType({
    required String empId,
    required String compId,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.punchTypeAction,
      "method": "POST",
      "kwargs": {"companyId": compId, "employeeId": empId},
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getCheckInDetails({
    required String empId,
    required String compId,
    required String date,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.checkInAction,
      "method": "POST",
      "kwargs": {"companyId": compId, "employeeId": empId, "checkInDate": date},
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200 || response.statusCode == 401) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getWorkExpenseCategory() async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.payRoll}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.workExpenseCategory,
      "method": "POST",
      "kwargs": {"isActive": 1},
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getWorkExpenseList({
    required String compId,
    required String empId,
    required String monthYr,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.payRoll}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.workExpenseListAction,
      "method": "POST",
      "kwargs": {
        "companyId": compId,
        "requestStatus": null,
        "salaryPayoutMonthYear": monthYr, // "June 2026"
        "employeeId": [empId],
      },
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> sendWorkExpense({
    required WorkExpenseSubmitModel workExpenseData,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.payRoll}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.submitWorkExpenseAction,
      "method": "POST",
      "kwargs": {
        "financialYearId": 1,
        "companyId": workExpenseData.companyId,
        "employeeId": workExpenseData.employeId,
        "categoryId": workExpenseData.categoryId,
        "description": workExpenseData.discription,
        if(workExpenseData.reference != null)
          "reference": workExpenseData.reference,
        "amount": workExpenseData.amount,
        "expenseDate": workExpenseData.expenseDate,
        "salaryMonthYear": workExpenseData.saleryMonthYear,
        "attachments": null,
        "isActive": 1,
        "createdBy": workExpenseData.createdBy,
      },
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> sendExpenseAttachment({
    required String insertedId,
    required String selectedFile,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = apiConstants.payRoll + apiConstants.fileHandler;
    AttendanceCommonWidgets().printF(url);
    if (connection) {
      try {
        var request = http.MultipartRequest('POST', Uri.parse(url));
        request.fields['action'] = apiConstants.workExpenseAttachAction;
        request.fields['employeeWorkExpenseId'] = insertedId;
        request.files.add(
          http.MultipartFile.fromBytes(
            'file',
            await File(selectedFile).readAsBytes(),
            filename: 'file.${selectedFile.split('.').last}',
            contentType: MediaType('file', selectedFile.split('.').last),
          ),
        );

        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> saveITRequest({
    required RequestSendModel requestModel,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = apiConstants.domain + apiConstants.fileHandler;
    AttendanceCommonWidgets().printF(url);
    if (connection) {
      try {
        var request = http.MultipartRequest('POST', Uri.parse(url));
        request.fields['action'] = apiConstants.saveITRequest;
        if(request.files.isNotEmpty) {
          request.files.add(
            http.MultipartFile.fromBytes(
              'file',
              await File(requestModel.files!.first).readAsBytes(),
              filename: 'file.${requestModel.files!.first.split('.').last}',
              contentType: MediaType(
                'file',
                requestModel.files!.first.split('.').last,
              ),
            ),
          );
        }
        request.fields['jsonParams'] = json.encode({
          "employeeId": requestModel.employeeId,
          "companyId": requestModel.companyId,
          "type": requestModel.requestType,
          "title": requestModel.text1,
          "location": requestModel.text2,
          "reason": requestModel.description,
        });

        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> saveWorkPlaceRequest({
    required RequestSendModel requestModel,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = apiConstants.domain + apiConstants.fileHandler;
    AttendanceCommonWidgets().printF(url);
    if (connection) {
      try {
        var request = http.MultipartRequest('POST', Uri.parse(url));
        request.fields['action'] = apiConstants.saveWorkPlaceRequest;
        if(request.files.isNotEmpty) {
          request.files.add(
            http.MultipartFile.fromBytes(
              'file',
              await File(requestModel.files!.first).readAsBytes(),
              filename: 'file.${requestModel.files!.first.split('.').last}',
              contentType: MediaType(
                'file',
                requestModel.files!.first.split('.').last,
              ),
            ),
          );
        }
        request.fields['jsonParams'] = json.encode({
          "employeeId": requestModel.employeeId,
          "companyId": requestModel.companyId,
          "type": requestModel.requestType,
          "location": requestModel.text1,
          "reason": requestModel.description,
        });

        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> saveOtherRequest({
    required RequestSendModel requestModel,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = apiConstants.domain + apiConstants.fileHandler;
    AttendanceCommonWidgets().printF(url);
    if (connection) {
      try {
        var request = http.MultipartRequest('POST', Uri.parse(url));
        request.fields['action'] = apiConstants.saveOtherRequest;
        if(requestModel.files?.isNotEmpty ?? false) {
          request.files.add(
            http.MultipartFile.fromBytes(
              'file',
              await File(requestModel.files!.first).readAsBytes(),
              filename: 'file.${requestModel.files!.first.split('.').last}',
              contentType: MediaType(
                'file',
                requestModel.files!.first.split('.').last,
              ),
            ),
          );
        }
        request.fields['jsonParams'] = json.encode({
          "employeeId": requestModel.employeeId,
          "companyId": requestModel.companyId,
          "categoryType": requestModel.text1,
          "type": requestModel.text1,
          "reason": requestModel.description,
        });

        request.headers.addAll(apiConstants.apiHeader);
        AttendanceCommonWidgets().printF(request.fields);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        AttendanceCommonWidgets().printF(respString);
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getPayrollData({
    required String compId,
    required String empId,
    required String monthYear,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.payRoll}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.payrollAction,
      "method": "POST",
      "kwargs": {
        "companyId": compId,
        "employeeId": empId,
        "salaryPayoutMonthYear": monthYear,
      },
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        AttendanceCommonWidgets().printF(
          'Api header---------------------->${apiConstants.apiHeader}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Uint8List> getPaySlip({
    required String compId,
    required String empId,
    required String monthYear,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.genPayPdf}";
    AttendanceCommonWidgets().printF('url---------------------->$url');

    if (!connection) throw Exception("No internet connection");

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['empId'] = empId;
    request.fields['companyId'] = compId;
    request.fields['yearMonth'] = monthYear;
    // request.headers['Authorization'] = 'Bearer ${Get.find<UserAuthController>().userData.value.userData?.token ?? ''}';
    request.headers.addAll(apiConstants.apiHeader);

    AttendanceCommonWidgets().printF(
      'Api body---------------------->${request.fields}',
    );
    AttendanceCommonWidgets().printF(
      'Api header---------------------->${apiConstants.apiHeader}',
    );

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return await response.stream.toBytes();
    } else {
      throw Exception("Failed: ${response.statusCode}");
    }
  }

  static Future<Map<String, dynamic>> requestRegularization({
    required RegularizationSubmit regularizationDetails,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.regularizationSubmitAction,
      "method": "POST",
      "kwargs": [
        {
          "employeeId": regularizationDetails.employeeId,
          "employeeCompanyId": regularizationDetails.employeeCompanyId,
          "employeeDailyAttendanceId":
              regularizationDetails.employeeDailyAttendanceId,
          "deductionDetails": regularizationDetails.deductionDetails,
          "excuseReason": regularizationDetails.excuseReason,
          "applyLeave": regularizationDetails.leaveTypeId != null
              ? 1
              : 0, // pass 1 if you regulerize with leave application
          "leaveTypeId": regularizationDetails
              .leaveTypeId, //pass leave type id only if you want to make the regulerization with leave application
          "requestedBy": regularizationDetails.createdBy,
        },
      ],
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${apiConstants.apiHeader}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getMyExcuseList({
    required String empId,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.myExcuseReqAction,
      "method": "POST",
      "kwargs": {"neededYearAndMonth": null, "employeeId": empId},
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getWFHRequestList({
    required String empId,
    required String compId,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.myRequestListAction,
      "method": "POST",
      "kwargs": {"companyId": compId, "employeeId": empId, "requestType": 1},
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getLetterRequestList({
    required String empId,
    required String compId,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.myRequestListAction,
      "method": "POST",
      "kwargs": {"companyId": compId, "employeeId": empId, "requestType": 2},
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> saveWorkFromHome({
    required RequestSendModel requestModel,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.workFromHomeSubmitAction,
      "method": "POST",
      "kwargs": {
        "companyId": requestModel.companyId,
        "employeeId": requestModel.employeeId,
        "requestType": 1,
        "requestDescription": requestModel.description,
        "fromDate": requestModel.fromDate,
        "toDate": requestModel.toDate,
        "requestStatus": 0,
        "createdBy": requestModel.employeeId,
        "requestLetterType": null,
      },
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> saveLetterRequest({
    required RequestSendModel requestModel,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.workFromHomeSubmitAction,
      "method": "POST",
      "kwargs": {
        "companyId": requestModel.companyId,
        "employeeId": requestModel.employeeId,
        "requestType": 2,
        "requestDescription": requestModel.description,
        "fromDate": requestModel.fromDate,
        "toDate": requestModel.toDate,
        "requestStatus": 0,
        "createdBy": requestModel.employeeId,
        "requestLetterType": requestModel.requestType,
      },
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> sendBreakDetails({
    required BreakRequestModel breakRequest,
  }) async {
    // bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = apiConstants.addPunch;
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.addBreakAction,
      "method": "POST",
      "kwargs": {
        "employeeId": breakRequest.employeeId,
        "type": breakRequest.breakType == BreakType.startBreak
            ? "startBreak"
            : "endBreak", //endBreak startBreak
        "punchState": breakRequest.breakType == BreakType.startBreak
            ? "breakIn"
            : "breakOut", //breakOut breakIn
        "punchDate": breakRequest.date,
        "time": breakRequest.time,
      },
    };
    // if (connection) {
    try {
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      AttendanceCommonWidgets().printF(
        'Api body---------------------->${request.body}',
      );
      request.headers.addAll(apiConstants.apiHeader);
      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        return json.decode(respString);
      } else {
        throw Exception(response.statusCode);
      }
    } on SocketException catch (e) {
      throw Exception("Poor Network Connection");
    } catch (e) {
      throw Exception("Service Error");
    }
    // } else {
    //   throw Exception("No internet connection");
    // }
  }

  static Future<Map<String, dynamic>> updateProfilePic({
    required String selectedFile,
    required String empId,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = apiConstants.domain + apiConstants.fileHandler;
    AttendanceCommonWidgets().printF(url);
    if (connection) {
      try {
        List<int> compressedBytes = await FlutterImageCompress.compressWithList(
          await File(selectedFile).readAsBytes(),
          minHeight: 1920,
          minWidth: 1080,
          quality: 85,
        );
        var request = http.MultipartRequest('POST', Uri.parse(url));
        request.fields['action'] = apiConstants.uploadProfilePicAction;
        request.fields['employeeId'] = empId;
        request.files.add(
          http.MultipartFile.fromBytes(
            'file',
            compressedBytes,
            filename: 'file.${selectedFile.split('.').last}',
            contentType: MediaType('file', selectedFile.split('.').last),
          ),
        );

        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getUpcomingShiftsApi({
    required String employeeId,
    required String companyId,
    required String date,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.upcomingShiftsAction,
      "kwargs": {
        "companyId": companyId,
        "employeeId": employeeId,
        "todayDate": date,
      },
      "method": "POST",
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        AttendanceCommonWidgets().printF(
          'Api header---------------------->${apiConstants.apiHeader}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getAttendanceDetails({
    required String attId,
    required String empId,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.attendanceDetailAction,
      "method": "POST",
      "kwargs": {"employeeDailyAttendanceId": attId, "employeeId": empId},
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getCalendarLeaveData({
    required String empId,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.leaveDetailsAction,
      "method": "POST",
      "kwargs": {"id": empId},
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getCalendarHolidayData({
    required String empId,
    required String compId,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.holidayDetailsAction,
      "kwargs": {"companyId": compId, "id": empId},
      "method": "POST",
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getManagerAttSummary({
    required String empId,
    required String compId,
    required String date,
    required bool isListAll,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    // Map apiBody = {
    //   "action": apiConstants.managerAttendanceSummary,
    //   "kwargs": {
    //     "superiorEmployeeId": empId,
    //     "companyId": compId,
    //     "summaryDate": date,
    //     "isListAll": false,
    //   },
    //   "method": "POST",
    // };
    Map apiBody = {
      "action": apiConstants.managerAttendanceSummary,
      "method": "POST",
      "kwargs": {
        "companyId": compId,
        "superiorEmployeeId": empId,
        "neededYearAndMonthAndDate": date,
        "locationId": null,
        "categoryId": null,
        "subcategoryId": null,
        "departmentId": null,
        "shiftSchemeId": null,
        "isListAll": isListAll,
      },
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        AttendanceCommonWidgets().printF(
          'token---------------------->${Get.find<UserAuthController>().userData.value.userData?.token}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getManagerAttDetails({
    required String empId,
    required String compId,
    required String date,
    required int pageNo,
    required bool isListAll,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.getHierarchyEmployeeAttendanceDetails,
      "kwargs": {
        "superiorEmployeeId": empId,
        "neededYearAndMonthAndDate": date,
        "companyId": compId,
        "isListAll": isListAll,
        "per_page": 10,
        "current_page": pageNo,
      },
      "method": "POST",
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getAllShiftEmployee({
    required String compId,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.getAllShiftAction,
      "method": "POST",
      "kwargs": {"companyId": compId, "isActive": 1},
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getEmployeeAttendanceDetail({
    required String empId,
    required String? shiftId,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.employeeAttendanceDetail,
      "method": "POST",
      "kwargs": {"id": empId, if (shiftId != null) "shiftId": shiftId},
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getEmployeeExcuseList({
    required String supervisorId,
    required String companyId,
    required String yearMonth,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.allExcuseList,
      "method": "POST",
      "kwargs": {
        "superiorEmployeeId": supervisorId,
        "neededYearAndMonth": yearMonth,
        "companyId": companyId,
      },
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getEmployeeOvertimeList({
    required String supervisorId,
    required String companyId,
    required String yearMonth,
    required String filter,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.overtimeRequestList,
      "method": "POST",
      "kwargs": {
        "superiorEmployeeId": supervisorId,
        "neededYearAndMonth": yearMonth,
        "companyId": companyId,
        "filter": filter,
      },
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getFilteredEmployeeExcuseList({
    required String supervisorId,
    required String companyId,
    required String yearMonth,
    required String filter,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.filteredExcuseList,
      "method": "POST",
      "kwargs": {
        "filter": filter,
        "superiorEmployeeId": supervisorId,
        "neededYearAndMonth": yearMonth,
        "companyId": companyId,
      },
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> excuseReqSubmit({
    required String supervisorId,
    required String companyId,
    required String remarks,
    required List<String> employees,
    required SubmissionType type,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.excuseSubmit,
      "method": "POST",
      "kwargs": {
        "companyId": companyId,
        "selectedType": type == SubmissionType.pardon ? "pardon" : "fine",
        "responseBy": supervisorId,
        "remarks": remarks,
        "employeeAttendanceDeductionIds": employees,
      },
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> deductionDetailsGet({
    required String deductionId,
    required String action,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": action,
      "method": "POST",
      "kwargs": {"id": deductionId},
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> punchApprovalReqList({
    required String comId,
    required String empId,
    required String yearAndMonth,
    required String filter,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.punchReqListAction,
      "method": "POST",
      "kwargs": {
        "superiorEmployeeId": empId,
        "neededYearAndMonth": yearAndMonth,
        "companyId": comId,
        // "filter": "All"
        "filter": filter,
      },
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> punchApprovalReject({
    required String remark,
    required String empId,
    required List<String> punchList,
    required SubmissionType type,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.approveRejectPunch,
      "method": "POST",
      "kwargs": {
        "selectedType": type == SubmissionType.approve ? "approved" : "reject",
        "responseBy": empId,
        "remarks": remark,
        "employeeDailyAttendanceIds": punchList,
      },
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> approveOrRejectOvertime({
    required String remark,
    required String empId,
    required List<String> overtimeIds,
    required SubmissionType type,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.overtimeSubmission,
      "method": "POST",
      "kwargs": {
        "selectedType": type == SubmissionType.approve
            ? "Approved"
            : "Rejected",
        "responseBy": empId,
        "remarks": remark,
        "employeeOvertimeDataIds": overtimeIds,
      },
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getSpecialRequestsWfhLr({
    required String compId,
    required String empId,
    required String monthYr,
    required SubmissionType type,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.wfhAndLrAction,
      "method": "POST",
      "kwargs": {
        "superiorEmployeeId": empId,
        "companyId": compId,
        "requestType": type == SubmissionType.wfh ? 1 : 2,
        "month": monthYr,
      },
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        AttendanceCommonWidgets().printF(
          'token---------------------->${Get.find<UserAuthController>().userData.value.userData?.token}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> submitSpcRequest({
    required String reqId,
    required String empId,
    required String compId,
    int? punchMethodId,
    required String remark,
    required SubmissionType type,
    required RequestType reqType,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.wfhLrApproval,
      "method": "POST",
      "kwargs": {
        "specialRequestId": reqId,
        "actionEmployeeId": empId,
        "actionStatus": type == SubmissionType.approve ? 1 : 2,
        "actionRemarks": remark,
        "companyId": compId,
        "requestType": reqType == RequestType.wfh ? 1 : 2,
        if(reqType == RequestType.wfh)
          "allowedPunchMethod": punchMethodId,
        "module": "HR",
      },
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getEmployeeLeaveList({
    required String compId,
    required String empId,
    required String? yrMonth,
    required String status,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.employeeLeaveList,
      "method": "POST",
      "kwargs": {
        "id": empId,
        "companyId": compId,
        "neededYearAndMonth": yrMonth,
        "status": status, // "Pending"
      },
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> deleteLeaveReq({
    required String leaveId,
    required String reason,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.deleteLeaveApplication,
      "method": "POST",
      "kwargs": {"id": leaveId, "message": reason},
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> approveOrRejectLeave({
    required String compId,
    required String empId,
    required bool isHourBased,
    required List<String> leaveTypeId,
    required String remarks,
    required List<String> leaveApplicationId,
    required List<String> employeeIds,
    required List<String> hierarchyList,
    required SubmissionType type,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": isHourBased ? apiConstants.updateEmployeeHourLeaveApplicationById : apiConstants.leaveRequestUpdate,
      "method": "POST",
      "kwargs": {
        "id": empId,
        "employeeId": employeeIds,
        "remarks": remarks,
        "superiorEmployeeId": empId,
        "requestStatus": type == SubmissionType.approve
            ? "Approved"
            : "Rejected",
        "companyId": compId,
        "leaveTypeId": leaveTypeId,
        "employeeLeaveApplicationId": leaveApplicationId,
        "isFinalHeirarchy": hierarchyList,
        "createdBy": empId,
      },
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> attendanceMarkPresent({
    required Map<String, dynamic> data,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.editAttendanceSubmit,
      "method": "POST",
      "kwargs": data,
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> paidLeaveApply({
    required Map<String, dynamic> data,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.paidLeaveSubmit,
      "method": "POST",
      "kwargs": data,
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getEmployeeLeaveData({
    required String attEmpId,
    required String attCompId,
    required String leaveTypeId,
    required String attMonth,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.employeeLeaveData,
      "method": "POST",
      "kwargs": {
        "employeeId": attEmpId,
        "companyId": attCompId,
        "leaveTypeId": leaveTypeId,
        "leaveDateFrom": attMonth, // "2025-04"
      },
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> calculateFineAmount({
    required String method,
    String? time,
    required String type,
    required String attId,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.fineAmountCalculate,
      "method": "POST",
      "kwargs": {
        "method": method, // "Short Time",
        if (time != null) "hours": time, // "04:00",
        "type": type, // "halfDay",
        "employeeDailyAttendanceId": attId, // 726216
      },
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getActionCentre({
    required String empId,
    required String compId,
    required String yrMonth,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.actionCenter,
      "method": "POST",
      "kwargs": {
        "employeeId": empId,
        "companyId": compId,
        "neededMonthYear": yrMonth, //"2025-04"
      },
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getAllEmployee({
    required String empId,
    required String compId,
    required bool isListAll,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.getAllEmployee,
      "method": "POST",
      "kwargs": {
        "companyId": compId,
        "employeeId": empId,
        "isListAll": isListAll,
        "isActive": 1,
      },
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> next7DaysLeaveList({
    required String empId,
    required String compId,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.nextSevenDaysLeave,
      "method": "POST",
      "kwargs": {
        "id": empId, // "11144",
        "companyId": compId, // "184",
        "isSevenDays": 1,
      },
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getFeedDataList({
    required String empId,
    required String compId,
    required int page,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.feedsMain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.getAllFeeds,
      "method": "POST",
      "kwargs": {
        "companyId": compId,
        "page": page,
        "limit": 50,
        "employeeId": empId,
      },
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> saveCommentApi({
    required String feedsId,
    required String comment,
    required String companyId,
    required String employeeId,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.feedsMain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.saveComments,
      "method": "POST",
      "kwargs": {
        "feedsId": feedsId,
        "comment": comment,
        "companyId": companyId,
        "employeeId": employeeId,
        "isActive": 1,
        "createdBy": employeeId,
      },
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = json.encode(apiBody);
        AttendanceCommonWidgets().printF(
          'Save Comment Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> deleteCommentApi({
    required String commentId,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.feedsMain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.deleteCommentsById,
      "method": "POST",
      "kwargs": {
        "id": commentId,
      },
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = json.encode(apiBody);
        AttendanceCommonWidgets().printF(
          'Delete Comment Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getCompanyList({
    required String organizationId,
    String? empId,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    final url = Uri.parse(apiConstants.domain + apiConstants.baseUrl);
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.getAllCompanyList,
      "method": "POST",
      "kwargs": {
        if (empId != null) "employeeId": empId,
        "organisationId": organizationId,
        "isActive": 1,
      },
    };
    if (connection) {
      try {
        var request = http.Request('POST', url);
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getSettings({
    required String? compId,
    required PostSettings? type,
  }) async {
    final hasConnection = await ConnectivityService().check();
    final apiConstants = ApiConstants();
    final url = Uri.parse('${apiConstants.domain}${apiConstants.baseUrl}');

    if (!hasConnection) {
      throw Exception("No internet connection");
    }

    // Choose correct API action based on type
    String? action;
    switch (type) {
      case PostSettings.location:
        action = apiConstants.getAllLocation;
        break;
      case PostSettings.category:
        action = apiConstants.getAllCategory;
        break;
      case PostSettings.department:
        action = apiConstants.getAllDepartment;
        break;
      default:
        action = null;
    }

    if (action == null) {
      throw Exception("Invalid PostSettings type provided");
    }

    final apiBody = {
      "action": action,
      "method": "POST",
      "kwargs": {"companyId": compId, "isActive": 1},
    };

    try {
      final request = http.Request('POST', url)
        ..body = json.encode(apiBody)
        ..headers.addAll(apiConstants.apiHeader);

      AttendanceCommonWidgets().printF('➡️ API URL: $url');
      AttendanceCommonWidgets().printF('📦 Request Body: ${request.body}');

      final response = await request.send().timeout(
        const Duration(seconds: 20),
      );
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return json.decode(responseBody) as Map<String, dynamic>;
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } on SocketException {
      throw Exception("Poor network connection");
    } catch (e) {
      throw Exception("Service error: $e");
    }
  }

  static Future<Map<String, dynamic>> postAFeed({
    required String title,
    required List<String> compIds,
    required List<String> locIds,
    required List<String> categoryIds,
    required List<String> deptIds,
    required String empId,
    required String orgId,
    required String description,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    final url = Uri.parse(apiConstants.feedsMain + apiConstants.baseUrl);
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.saveFeeds,
      "method": "POST",
      "kwargs": {
        "title": title,
        "description": description,
        "employeeId": empId,
        "isActive": 1,
        "createdBy": empId,
        "organizationId": orgId,
        "companyId": compIds,
        "locationId": locIds,
        "categoryId": categoryIds,
        "departmentId": deptIds,
      },
    };

    if (connection) {
      try {
        var request = http.Request('POST', url);
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        // if (response.statusCode == 200) {
          return json.decode(respString);
        // } else {
        //   throw Exception(response.statusCode);
        // }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> feedFileUpload({
    required String insertedId,
    required String imagePath,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = apiConstants.feedsMain + apiConstants.fileHandler;
    AttendanceCommonWidgets().printF(url);
    if (connection) {
      try {
        var request = http.MultipartRequest('POST', Uri.parse(url));
        request.fields['action'] = apiConstants.feedsFileUpload;
        request.fields['feedsId'] = insertedId;
        request.files.add(
          http.MultipartFile.fromBytes(
            'files[]',
            await File(imagePath).readAsBytes(),
            filename: 'file.${imagePath.split('.').last}',
            contentType: MediaType('file', imagePath.split('.').last),
          ),
        );

        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> likeFeedApi({
    required String feedId,
    required String compId,
    required String empId,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    final url = Uri.parse(apiConstants.feedsMain + apiConstants.baseUrl);
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.likeFeed,
      "method": "POST",
      "kwargs": {
        "feedsId": feedId,
        "companyId": compId,
        "employeeId": empId,
        "isActive": 1,
        "createdBy": empId,
      },
    };
    if (connection) {
      try {
        var request = http.Request('POST', url);
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> departmentFilters({
    required String compId,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    final url = Uri.parse(apiConstants.domain + apiConstants.baseUrl);
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.getAllDepartment,
      "method": "POST",
      "kwargs": {"companyId": compId},
    };
    if (connection) {
      try {
        var request = http.Request('POST', url);
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> locationFilters({
    required String compId,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    final url = Uri.parse(apiConstants.domain + apiConstants.baseUrl);
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.locationFilter,
      "method": "POST",
      "kwargs": {"companyId": compId},
    };
    if (connection) {
      try {
        var request = http.Request('POST', url);
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> shiftWiseFilters({
    required String compId,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    final url = Uri.parse(apiConstants.domain + apiConstants.baseUrl);
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.shiftSchemeFilter,
      "method": "POST",
      "kwargs": {"companyId": compId},
    };
    if (connection) {
      try {
        var request = http.Request('POST', url);
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> punchTypeWiseFilters({
    required String compId,
    required String empId,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    final url = Uri.parse(apiConstants.domain + apiConstants.baseUrl);
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.punchTypeFilter,
      "method": "POST",
      "kwargs": {"companyId": compId, "superiorEmployeeId": empId},
    };
    if (connection) {
      try {
        var request = http.Request('POST', url);
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> taskDashboardCount({
    required String compId,
    required String empId,
    required String filterName,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    final url = Uri.parse(apiConstants.domain + apiConstants.baseUrl);
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.taskDashCount,
      "method": "POST",
      "kwargs": {
        "superiorEmployeeId": empId,
        "companyId": compId,
        "search": filterName,
      },
    };
    if (connection) {
      try {
        var request = http.Request('POST', url);
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getTaskListData({
    required String compId,
    required String empId,
    required String filterName,
    required int currentPage,
    required Map<String, dynamic> filterArray,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    final url = Uri.parse(apiConstants.domain + apiConstants.baseUrl);
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.taskListData,
      "method": "POST",
      "kwargs": {
        "superiorEmployeeId": empId,
        "companyId": compId,
        "current_page": currentPage,
        "per_page": "10",
        "search": filterName,
        "filterArr": filterArray,
      },
    };
    if (connection) {
      try {
        var request = http.Request('POST', url);
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getTemplateData({
    required String compId,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    final url = Uri.parse(apiConstants.domain + apiConstants.baseUrl);
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.getTemplateList,
      "method": "POST",
      "kwargs": {"companyId": compId},
    };
    if (connection) {
      try {
        var request = http.Request('POST', url);
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getTaskExtraFields({
    required String tempId,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    final url = Uri.parse(apiConstants.domain + apiConstants.baseUrl);
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.getTaskExtraFields,
      "method": "POST",
      "kwargs": {"templateId": tempId},
    };
    if (connection) {
      try {
        var request = http.Request('POST', url);
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getSubGoals({
    required String empId,
    required String compId,
    required bool admin,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    final url = Uri.parse(apiConstants.domain + apiConstants.baseUrl);
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.getSubGoals,
      "method": "POST",
      "kwargs": {
        "employeeId": empId,
        "companyId": compId,
        "adminLevel": admin // 1 or 0
      }
    };
    if (connection) {
      try {
        var request = http.Request('POST', url);
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> subGoalTaskList({
    int? goalId,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    final url = Uri.parse(apiConstants.growth + apiConstants.subGoalTaskList);
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "goalId": goalId
    };
    if (connection) {
      try {
        var request = http.Request('POST', url);
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        // if (response.statusCode == 200) {
          return json.decode(respString);
        // } else {
        //   throw Exception(response.statusCode);
        // }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> unlinkTask({
    int? taskId,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    final url = Uri.parse(apiConstants.growth + apiConstants.unlinkTask);
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "taskId": taskId
    };
    if (connection) {
      try {
        var request = http.Request('POST', url);
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        // if (response.statusCode == 200) {
          return json.decode(respString);
        // } else {
        //   throw Exception(response.statusCode);
        // }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getTaskInDetail({
    required String taskId,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    final url = Uri.parse(apiConstants.domain + apiConstants.baseUrl);
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.taskDetailed,
      "method": "POST",
      "kwargs": {"taskId": taskId},
    };
    if (connection) {
      try {
        var request = http.Request('POST', url);
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> updateTaskStatus({
    required List<String> taskIds,
    required String empId,
    required String compId,
    required String location,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    final url = Uri.parse(apiConstants.domain + apiConstants.baseUrl);
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.updateTaskStatus,
      "method": "POST",
      "kwargs": {
        "superiorEmployeeId": empId,
        "companyId": compId,
        "taskId": taskIds,
        "search": "all",
        "location": location,
      },
    };
    if (connection) {
      try {
        var request = http.Request('POST', url);
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> createNewTask({
    required CreateTaskModel createTask,
    String? taskId,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.fileHandler}";
    AttendanceCommonWidgets().printF(url);
    if (connection) {
      try {
        var request = http.MultipartRequest('POST', Uri.parse(url));
        request.fields['action'] = apiConstants.createNewTask;
        request.fields['superiorEmployeeId'] = createTask.supervisorId ?? '';
        request.fields['companyId'] = createTask.companyId ?? '';
        request.fields['workName'] = createTask.workName ?? '';
        request.fields['description'] = createTask.description ?? '';
        request.fields['dueDate'] = createTask.dueDate ?? '';
        request.fields['templateId'] = createTask.templateId ?? '';
        request.fields['assignedTo'] = createTask.assignedToId ?? '';
        request.fields['subGoalId'] = createTask.subGoalId ?? '';
        request.fields['location'] = json.encode(
          createTask.locationData?.toJson(),
        );
        if (taskId != null) {
          request.fields['workId'] = taskId;
        }
        request.fields['fields'] = json.encode(
          createTask.fieldData?.map((e) {
            Map<String, dynamic> result = e.toJson();
            if (e.value == null) {
              result.remove('value');
            }
            return result;
          }).toList(),
        );
        AttendanceCommonWidgets().printF(
          "-----fields-----${request.fields}",
        );
        if (createTask.attachment?.isNotEmpty ?? false) {
          createTask.attachment?.forEach((file) async {
            request.files.add(
              http.MultipartFile.fromBytes(
                'file[]',
                await File(file).readAsBytes(),
                filename: 'file.${file.split('.').last}',
                contentType: MediaType('file', file.split('.').last),
              ),
            );
          });
        }
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> taskDelete({
    String? taskId,
    String? empId,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    final url = Uri.parse(apiConstants.domain + apiConstants.baseUrl);
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.taskDelete,
      "method": "POST",
      "kwargs": {
        "taskId": taskId,
        "employeeId": empId
      },
    };
    if (connection) {
      try {
        var request = http.Request('POST', url);
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> airTicketBooking({
    required AirTicketCreatingModel airTicketCreate,
    required List<String> selectedFiles,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.fileHandler}";
    AttendanceCommonWidgets().printF(url);
    if (connection) {
      try {
        var request = http.MultipartRequest('POST', Uri.parse(url));
        var jsonParams = airTicketCreate.toJson();

        request.fields['action'] = apiConstants.airTicketRequest;
        AttendanceCommonWidgets().printF(
          "---------jsonParams----------$jsonParams",
        );
        request.fields['jsonParams'] = json.encode(jsonParams);
        if (selectedFiles.isNotEmpty) {
          for (var file in selectedFiles) {
            request.files.add(
              http.MultipartFile.fromBytes(
                'file[]',
                await File(file).readAsBytes(),
                filename: 'file.${file.split('.').last}',
                contentType: MediaType('file', file.split('.').last),
              ),
            );
          }
        }
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> airTicketList({
    required String compId,
    required String empId,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    final url = Uri.parse(apiConstants.domain + apiConstants.baseUrl);
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.airTicketList,
      "method": "POST",
      "kwargs": {"companyId": compId, "employeeId": empId},
    };
    if (connection) {
      try {
        var request = http.Request('POST', url);
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> airTicketDetails({
    required String empId,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    final url = Uri.parse(apiConstants.domain + apiConstants.baseUrl);
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.airTicketDetails,
      "method": "POST",
      "kwargs": {"employeeId": empId},
    };
    if (connection) {
      try {
        var request = http.Request('POST', url);
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<dynamic> pieceWorkList({
    required String compId,
    required String date,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    final url = Uri.parse(apiConstants.payRoll + apiConstants.baseUrl);
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.getPieceWorkList,
      "method": "POST",
      "kwargs": {
        "companyId": compId,
        "date": date, // "2025/10/1"
      },
    };
    if (connection) {
      try {
        var request = http.Request('POST', url);
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<dynamic> getAllPieceRate({required String compId}) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    final url = Uri.parse(apiConstants.payRoll + apiConstants.baseUrl);
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.getAllPieceRate,
      "method": "POST",
      "kwargs": {"companyId": compId},
    };
    if (connection) {
      try {
        var request = http.Request('POST', url);
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<dynamic> savePieceRatePayment({
    required AddPieceWork pieceWork,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    final url = Uri.parse(apiConstants.payRoll + apiConstants.baseUrl);
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.savePieceRatePayment,
      "method": "POST",
      "kwargs": pieceWork.toJson(),
    };
    if (connection) {
      try {
        var request = http.Request('POST', url);
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<dynamic> deletePieceRate({required String? pieceWorkId}) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    final url = Uri.parse(apiConstants.payRoll + apiConstants.baseUrl);
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.deletePieceRate,
      "method": "POST",
      "kwargs": {"id": pieceWorkId},
    };
    if (connection) {
      try {
        var request = http.Request('POST', url);
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<dynamic> getRegularizingEmployeeDetail({
    required String? attId,
    required String? shiftId,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    final url = Uri.parse(apiConstants.domain + apiConstants.baseUrl);
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.getRegularizingEmployeeDetail,
      "method": "POST",
      "kwargs": {"regularizingEmployeeAttendanceId": attId, "shiftId": shiftId},
    };
    if (connection) {
      try {
        var request = http.Request('POST', url);
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<dynamic> getMissionVision({
    required String organizationId,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    final url = Uri.parse(apiConstants.growth + apiConstants.visionMission);
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {"id": organizationId};
    if (connection) {
      try {
        var request = http.Request('POST', url);
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<dynamic> getProgress({
    required String companyId,
    required String employeeId,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    final url = Uri.parse(apiConstants.growth + apiConstants.homePercentage);
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {"companyId": companyId, "superiorEmployeeId": employeeId};
    if (connection) {
      try {
        var request = http.Request('POST', url);
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<dynamic> getMoodPulse({
    required String companyId,
    required String employeeId,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    final url = Uri.parse(apiConstants.growth + apiConstants.getMoodPulse);
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {"companyId": companyId, "superiorEmployeeId": employeeId};
    if (connection) {
      try {
        var request = http.Request('POST', url);
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<dynamic> submitMoodPulse({
    required String companyId,
    required String employeeId,
    required int score,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    final url = Uri.parse(apiConstants.growth + apiConstants.saveMoodPulse);
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "companyId": companyId,
      "superiorEmployeeId": employeeId,
      "score": score,
    };
    if (connection) {
      try {
        var request = http.Request('POST', url);
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<dynamic> getEvaluationList({
    required String companyId,
    required String employeeId,
    required String year,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    final url = Uri.parse(apiConstants.growth + apiConstants.getEvaluationList);
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "companyId": companyId,
      "employeeId": employeeId,
      "year": year,
    };
    if (connection) {
      try {
        var request = http.Request('POST', url);
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<dynamic> getGoalsAndSubGoals({
    String? companyId,
    String? employeeId,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    final url = Uri.parse(apiConstants.growth + apiConstants.goalsAndSubGoals);
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "superiorEmployeeId": employeeId,
      "companyId": companyId,
      "fromDb": true,
    };
    if (connection) {
      try {
        var request = http.Request('POST', url);
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<dynamic> goalComments({
    String? companyId,
    String? employeeId,
    int? goalId,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    final url = Uri.parse(apiConstants.growth + apiConstants.goalComments);
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "goalId": goalId,
      "superiorEmployeeId": employeeId,
      "companyId": companyId,
    };
    if (connection) {
      try {
        var request = http.Request('POST', url);
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<dynamic> commentGoal({
    int? goalId,
    String? employeeId,
    String? comment,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    final url = Uri.parse(apiConstants.growth + apiConstants.commentGoal);
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "superiorEmployeeId": int.parse(employeeId ?? ''),
      "goalId": goalId,
      "commentParentId": null,
      "commentText": comment,
    };
    if (connection) {
      try {
        var request = http.Request('POST', url);
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        // if (response.statusCode == 200) {
        return json.decode(respString);
        // } else {
        //   throw Exception(response.statusCode);
        // }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<dynamic> goalDetails({
    int? goalId,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    final url = Uri.parse(apiConstants.growth + apiConstants.goalDetails);
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {"id": goalId};
    if (connection) {
      try {
        var request = http.Request('POST', url);
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        // if (response.statusCode == 200) {
        return json.decode(respString);
        // } else {
        //   throw Exception(response.statusCode);
        // }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<dynamic> saveGoal({
    SaveGoalModel? goalData,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    final url = Uri.parse(apiConstants.growth + apiConstants.saveGoal);
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "superiorEmployeeId": goalData?.superiorEmployeeId,
      "organisationId": goalData?.organisationId,
      "goalTitile": goalData?.goalTitile,
      "goalDescription": goalData?.goalDescription,
      "goalDepartmentId": goalData?.goalDepartmentId,
      "goalLocationId": goalData?.goalLocationId,
      "goalCategoryId": goalData?.goalCategoryId,
      "goalCompanyId": goalData?.goalCompanyId,
      "goalTimePeriod": goalData?.goalTimePeriod,
      "goalParentId": goalData?.goalParentId,
      "assignedEmployees": goalData?.assignedEmployees
    };

    if (connection) {
      try {
        var request = http.Request('POST', url);
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        // if (response.statusCode == 200) {
        return json.decode(respString);
        // } else {
        //   throw Exception(response.statusCode);
        // }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<dynamic> updateGoal({
    SaveGoalModel? goalData,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    final url = Uri.parse(apiConstants.growth + apiConstants.updateGoal.replaceAll(':id', goalData?.goalParentId?.toString() ?? ''));
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "superiorEmployeeId": goalData?.superiorEmployeeId,
      "organisationId": goalData?.organisationId,
      "goalTitile": goalData?.goalTitile,
      "goalDescription": goalData?.goalDescription,
      "goalDepartmentId": goalData?.goalDepartmentId,
      "goalCompanyId": goalData?.goalCompanyId,
      // "goalDueDate": goalData?.goalDueDate,
      // "goalStartDate": goalData?.goalStartDate,
      "id": goalData?.goalParentId,
      "goalTimePeriod": goalData?.goalTimePeriod,
      "assignedEmployees": goalData?.assignedEmployees,
      if(goalData?.subGoalId != null)
        "goalParentId": goalData?.subGoalId
    };

    if (connection) {
      try {
        var request = http.Request('POST', url);
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        // if (response.statusCode == 200) {
        return json.decode(respString);
        // } else {
        //   throw Exception(response.statusCode);
        // }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<dynamic> deleteGoal({
    String? goalId,
    String? employeeId,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    final url = Uri.parse('${apiConstants.growth}${apiConstants.deleteGoal}');
    AttendanceCommonWidgets().printF(url);

    Map apiBody = {
      "id": goalId,
      "employeeId": employeeId
    };

    if (connection) {
      try {
        var request = http.Request('POST', url);
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        return json.decode(respString);
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<dynamic> getTimePeriod() async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    final url = Uri.parse(apiConstants.growth + apiConstants.timePeriod);
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {};

    if (connection) {
      try {
        var request = http.Request('POST', url);
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        // if (response.statusCode == 200) {
        return json.decode(respString);
        // } else {
        //   throw Exception(response.statusCode);
        // }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<dynamic> savePerformance({SelfEvaluationSave? data}) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    final url = Uri.parse(apiConstants.growth + apiConstants.savePerformance);
    AttendanceCommonWidgets().printF(url);
    Map apiBody = data?.toJson() ?? {};
    // Map apiBody = {
    //   "companyId": "7",
    //   "employeeId": "5339",
    //   "superiorEmployeeId": "5339",
    //   "overallComment": "Fdsfds",
    //   "isSelfReview": 1,
    //   "reviewId": 13,
    //   "points": [
    //     {
    //       "cyclePointId": 5,
    //       "score": 46,
    //       "comments": [
    //         {
    //           "comment": "Test"
    //         }
    //       ]
    //     }
    //   ],
    //   "cycleId": 3,
    //   "recommentedAction": 1,
    //   "recommentedSubAction": "",
    //   "employeeFeedback": "Dfsdfs"
    // };

    if (connection) {
      try {
        var request = http.Request('POST', url);
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
        return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<dynamic> getToken({String? username, String? compId}) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    final url = Uri.parse(apiConstants.domain + apiConstants.baseUrl);
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.getToken,
      "method": "POST",
      "kwargs": {
        "userName" : username,
        "companyId" : compId
      }
    };

    if (connection) {
      try {
        var request = http.Request('POST', url);
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
        return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<String?> checkFileType(String url) async {
    final response = await http.head(Uri.parse(url));
    AttendanceCommonWidgets().printF(
      "Content-Type: ${response.headers['content-type']}",
    );
    return response.headers['content-type'];
  }

  static Future<Map<String, dynamic>> getShiftSchedulerEmployees({
    required List<int?>? shiftSchemeId,
    required String startDate,
    required String endDate,
    required String companyId,
    required String superiorEmployeeId,
    List<int?>? departmentId,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.getAllEmployeeWithShiftSchemeId,
      "method": "POST",
      "kwargs": {
        "shiftSchemeId": shiftSchemeId,
        "startDate": startDate,
        "departmentId": departmentId,
        "endDate": endDate,
        "superiorEmployeeId": superiorEmployeeId,
        "companyId": companyId
      }
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getShiftSchemes({
    required String companyId,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.getAllShiftSchemesByCompanyIdWithFilter,
      "method": "POST",
      "kwargs": {
        "companyId": companyId,
        "shiftSchemeType": "roster"
      }
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getDepartments({
    required String companyId,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.getAllDepartment,
      "method": "POST",
      "kwargs": {
        "companyId": companyId
      }
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> saveRosterShiftScheduler({
    required String compId,
    required String empId,
    required String assignedTo,
    required String schemeId,
    required String date,
    required List<String?> shiftId,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.saveRosterShiftScheduler,
      "method": "POST",
      "kwargs": {
        "companyId": compId,
        "shiftSchemeId": 93,
        "employeeId": assignedTo,
        "date": date, // "2026-04-06"
        "superiorEmployeeId": empId,
        "shiftId": shiftId,
        "attendanceLogs": []
      }
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> checkCompanyMonthPayoutList({
    required String compId,
    required String monthYr,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.payRoll}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.checkCompanyMonthPayoutList,
      "method": "POST",
      "kwargs": {
        "companyId": 25,
        "salaryMonthYear": monthYr // "2026-06"
      }
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getAllDocumentType({
    required String compId,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.getAllDocumentType,
      "method": "POST",
      "kwargs": {
        "companyId": compId,
        "isActive": 1
      }
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getCountryStateCity() async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.baseUrl}";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": apiConstants.getCountryStateCity,
      "method": "POST",
      "kwargs": {}
    };
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> employeeDocumentUpload({
    required DocumentAdd docData,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.fileHandler}";
    AttendanceCommonWidgets().printF(url);
    List<int> compressedBytes = [];
    try {
      if (docData.file != null) {
        compressedBytes = await FlutterImageCompress.compressWithList(
          File(docData.file!).readAsBytesSync(),
          minHeight: 1920,
          minWidth: 1080,
          quality: 85,
        );
      }
    } catch(e) {}
    if (connection) {
      try {
        var request = http.MultipartRequest('POST', Uri.parse(url));
        addField(request, 'action', apiConstants.employeeDocumentFileUpload);
        addField(request, 'employeeId', docData.employeeId);
        addField(request, 'companyId', docData.companyId);
        addField(request, 'documentTypeId', docData.documentTypeId);
        addField(request, 'fileName', docData.filename);
        if (docData.file != null && compressedBytes.isNotEmpty) {
          request.files.add(
            http.MultipartFile.fromBytes(
              'file',
              compressedBytes,
              filename: 'file.${docData.file!.split('.').last}',
              contentType: MediaType(
                'file',
                docData.file!.split('.').last,
              ),
            ),
          );
        }
        addField(request, 'description', docData.description);
        addField(request, 'isUnderWarranty', docData.isUnderWarranty);
        addField(request, 'countryId', docData.countryId);
        addField(request, 'issuedOn', docData.issuedOn);
        addField(request, 'validFrom', docData.validFrom);
        addField(request, 'validTo', docData.validTo);
        addField(request, 'expiresOn', docData.expiresOn);
        addField(request, 'isRenewal', docData.isRenewal);
        log(
          "---------fields----------${json.encode(request.fields)}",
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> uploadLetterRequestFiles({
    required String specialRequestId,
    required String employeeId,
    required List<String> filePaths,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.domain}${apiConstants.fileHandler}";
    AttendanceCommonWidgets().printF("Upload URL: $url");
    if (connection) {
      try {
        var request = http.MultipartRequest('POST', Uri.parse(url));
        request.headers.addAll(apiConstants.apiHeader);
        request.fields['action'] = apiConstants.letterRequestFileUpload;
        request.fields['specialRequestId'] = specialRequestId;
        request.fields['documentUploadedBy'] = employeeId;

        for (var filePath in filePaths) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'file[]',
              filePath,
              filename: filePath.split('/').last,
            ),
          );
        }

        AttendanceCommonWidgets().printF("Multipart fields: ${request.fields}");
        AttendanceCommonWidgets().printF("Multipart files count: ${request.files.length}");

        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        AttendanceCommonWidgets().printF("Upload Response status: ${response.statusCode}, body: $respString");
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error: $e");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  // <------------------ Loyaltri Field ---------------------> //

  static Future<Map<String, dynamic>> getWorkLogList({required Map<String,dynamic> data }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.loyaltriField}${apiConstants.getWorkLogList}";
    AttendanceCommonWidgets().printF(url);
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        AttendanceCommonWidgets().printF(
          'token ---------------------->${apiConstants.apiHeader}',
        );
        request.body = (json.encode(data));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        AttendanceCommonWidgets().printF(
          'response ---------------------->${respString}',
        );
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getWorkLogDetail({required String id }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.loyaltriField}${apiConstants.getWorkLogDetail.replaceAll("#id", id)}";
    AttendanceCommonWidgets().printF(url);
    if (connection) {
      try {
        var request = http.Request('GET', Uri.parse(url));
        AttendanceCommonWidgets().printF(
          'token ---------------------->${apiConstants.apiHeader}',
        );
        // request.body = (json.encode(data));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        AttendanceCommonWidgets().printF(
          'response ---------------------->${respString}',
        );
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getCustomerList({required String companyId, String? search,String? empId }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.loyaltriField}${apiConstants.geCustomerList.replaceAll("#company_id", companyId).replaceAll("#search", search ??"").replaceAll("#emp_id", empId ??"")}";
    AttendanceCommonWidgets().printF(url);
    if (connection) {
      try {
        var request = http.Request('GET', Uri.parse(url));
        AttendanceCommonWidgets().printF(
          'token ---------------------->${apiConstants.apiHeader}',
        );
        // request.body = (json.encode(data));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        AttendanceCommonWidgets().printF(
          'response ---------------------->${respString}',
        );
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getWorktype({required String companyId }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.loyaltriField}${apiConstants.getWorkType.replaceAll("#company_id", companyId)}";
    AttendanceCommonWidgets().printF(url);
    if (connection) {
      try {
        var request = http.Request('GET', Uri.parse(url));
        AttendanceCommonWidgets().printF(
          'token ---------------------->${apiConstants.apiHeader}',
        );
        // request.body = (json.encode(data));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        AttendanceCommonWidgets().printF(
          'response ---------------------->${respString}',
        );
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> addWorkLog({required Map<String,dynamic> data }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.loyaltriField}${apiConstants.addWorkLog}";
    AttendanceCommonWidgets().printF(url);
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        AttendanceCommonWidgets().printF(
          'token ---------------------->${apiConstants.apiHeader}',
        );
        request.body = (json.encode(data));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        AttendanceCommonWidgets().printF(
          'response ---------------------->${respString}',
        );
        if (response.statusCode == 201 || response.statusCode == 400) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }


  static Future<Map<String, dynamic>> uploadfile({
    required String companyId,
    required String filePath,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url =
        "${apiConstants.loyaltriField}${apiConstants.uploadFile.replaceAll("#company_id", companyId)}";
    AttendanceCommonWidgets().printF(url);
    if (connection) {
      try {
        var request = http.MultipartRequest('POST', Uri.parse(url));

        request.files.add(
          await http.MultipartFile.fromPath('attachment', filePath),
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        AttendanceCommonWidgets().printF(
          'response ---------------------->${respString}',
        );
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> syncActivity({
    required SynModel data,
  }) async {
    AttendanceCommonWidgets().printF(
      'start syncActivity api call -----------------------------------',
    );
    bool connection = await ConnectivityService().check();
    AttendanceCommonWidgets().printF(
      'start syncActivity api call -----------------------------------2',
    );
    // ApiConstants apiConstants = ApiConstants();
    AttendanceCommonWidgets().printF(
      'start syncActivity api call -----------------------------------3',
    );
    // String url = "https://field-dev-api.loyaltri.com/api/app/employee-live-track";
    String url = "https://field-api.loyaltri.com/api/app/employee-live-track"; // live
    AttendanceCommonWidgets().printF(url);
    if (connection) {
      try {
        await SyncManager().fetchTokenInBG();
        final userdata = await SecureStorageUtils().getUserData();
        var request = http.Request('POST', Uri.parse(url));
        AttendanceCommonWidgets().printF(
          'token ---------------------->${userdata?.userData?.token}',
        );
        request.body = (json.encode(data));
        AttendanceCommonWidgets().printF(
          'Api body---synchDatabody------------------->${request.body}',
        );
        log(
          'Api body---synchDatabody------------------->${request.body}',
        );
        Map<String, String> apiHeader = {
          'Authorization': 'Bearer ${userdata?.userData?.token}',
          'Content-Type': 'application/json',
        };
        request.headers.addAll(apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        AttendanceCommonWidgets().printF(
          'response ---------------------->${respString}',
        );
        if (response.statusCode == 202 || response.statusCode == 400) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<bool> deleteRoutePoint({required int id}) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.loyaltriField}${apiConstants.deleteRoutePoint.replaceAll("#id", id.toString())}";
    AttendanceCommonWidgets().printF('DELETE route-point: $url');
    if (connection) {
      try {
        await SyncManager().fetchTokenInBG();
        final userdata = await SecureStorageUtils().getUserData();
        var request = http.Request('DELETE', Uri.parse(url));
        Map<String, String> apiHeader = {
          'Authorization': 'Bearer ${userdata?.userData?.token}',
          'Content-Type': 'application/json',
        };
        request.headers.addAll(apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        AttendanceCommonWidgets().printF(
          'DELETE route-point response: $respString (${response.statusCode})',
        );
        return response.statusCode == 200 ||
            response.statusCode == 202 ||
            response.statusCode == 204;
      } catch (e) {
        log('Error deleting route point $id: $e');
        return false;
      }
    }
    return false;
  }

  static Future<Map<String, dynamic>> getCustomerDetail({required String id }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.loyaltriField}${apiConstants.getCustomerDetail.replaceAll("#id", id)}";
    AttendanceCommonWidgets().printF(url);
    if (connection) {
      try {
        var request = http.Request('GET', Uri.parse(url));
        AttendanceCommonWidgets().printF(
          'token ---------------------->${apiConstants.apiHeader}',
        );
        // request.body = (json.encode(data));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        AttendanceCommonWidgets().printF(
          'response ---------------------->${respString}',
        );
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getTimeLineDetail({required String employeeId,required String date }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.loyaltriField}${apiConstants.getTimeLineActivity.replaceAll("#employee_id", employeeId).replaceAll("#date", date)}";
    AttendanceCommonWidgets().printF(url);
    if (connection) {
      try {
        var request = http.Request('GET', Uri.parse(url));
        AttendanceCommonWidgets().printF(
          'token ---------------------->${apiConstants.apiHeader}',
        );
        // request.body = (json.encode(data));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        AttendanceCommonWidgets().printF(
          'response ---------------------->${respString}',
        );
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getTrackV2Sessions({
    required String employeeId,
    int limit = 100,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    final String url =
        "${apiConstants.loyaltriField}${apiConstants.getTrackV2Sessions.replaceAll("#employee_id", Uri.encodeComponent(employeeId))}?limit=$limit";
    AttendanceCommonWidgets().printF(url);
    if (connection) {
      try {
        var request = http.Request('GET', Uri.parse(url));
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        AttendanceCommonWidgets().printF(
          'track v2 sessions ---------------------->${respString}',
        );
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getTrackV2SessionDetail({
    required String sessionId,
    required String employeeId,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    final String url =
        "${apiConstants.loyaltriField}${apiConstants.getTrackV2SessionDetail.replaceAll("#id", Uri.encodeComponent(sessionId))}?employee_id=${Uri.encodeComponent(employeeId)}";
    AttendanceCommonWidgets().printF(url);
    if (connection) {
      try {
        var request = http.Request('GET', Uri.parse(url));
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        AttendanceCommonWidgets().printF(
          'track v2 session ---------------------->${respString}',
        );
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<dynamic> getTokenInBG({String? username, String? compId}) async {
    bool connection = await ConnectivityService().check();
    // final url = Uri.parse("https://alpha-api.loyaltri.com/api/main");
    final url = Uri.parse("https://web-api.loyaltri.com/api/main"); // live
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": "getToken",
      "method": "POST",
      "kwargs": {
        "userName" : username,
        "companyId" : compId
      }
    };

    if (connection) {
      try {
        var request = http.Request('POST', url);
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        // request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getWorkFormDetils({required String id }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.loyaltriField}${apiConstants.getWorkFormDetils.replaceAll("#id", id)}";
    AttendanceCommonWidgets().printF(url);
    if (connection) {
      try {
        var request = http.Request('GET', Uri.parse(url));
        AttendanceCommonWidgets().printF(
          'token ---------------------->${apiConstants.apiHeader}',
        );
        // request.body = (json.encode(data));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        AttendanceCommonWidgets().printF(
          'response ---------------------->${respString}',
        );
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getcustomerTemplate({required String companyId }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.loyaltriField}${apiConstants.customerTemplateForm.replaceAll("#company_id", companyId)}";
    AttendanceCommonWidgets().printF(url);
    if (connection) {
      try {
        var request = http.Request('GET', Uri.parse(url));
        AttendanceCommonWidgets().printF(
          'token ---------------------->${apiConstants.apiHeader}',
        );
        // request.body = (json.encode(data));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        AttendanceCommonWidgets().printF(
          'response ---------------------->${respString}',
        );
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> addCustomer({required Map<String,dynamic> body }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.loyaltriField}${apiConstants.addCustomer}";
    AttendanceCommonWidgets().printF(url);
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        AttendanceCommonWidgets().printF(
          'token ---------------------->${apiConstants.apiHeader}',
        );
        request.body = (json.encode(body));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        AttendanceCommonWidgets().printF(
          'response ---------------------->${respString}',
        );
        if (response.statusCode == 201 || response.statusCode == 400) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> submitWork({required Map<String,dynamic> body }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.loyaltriField}${apiConstants.submitWork}";
    AttendanceCommonWidgets().printF(url);
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        AttendanceCommonWidgets().printF(
          'token ---------------------->${apiConstants.apiHeader}',
        );
        request.body = (json.encode(body));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        AttendanceCommonWidgets().printF(
          'response ---------------------->${respString}',
        );
        if (response.statusCode == 201 || response.statusCode == 400) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> fetchHomeDetail({
    required String employeeId,
    required String frequency,
    required String startDate,
    required String endDate,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url;
    if (frequency == "custom") {
      url =
      "${apiConstants.loyaltriField}${apiConstants.homeCustom.replaceAll("#employee_id", employeeId).replaceAll("#frequency", frequency).replaceAll("#start_date", startDate).replaceAll("#end_date", endDate)}";
    } else {
      url =
      "${apiConstants.loyaltriField}${apiConstants.home.replaceAll("#employee_id", employeeId).replaceAll("#frequency", frequency)}";
    }

    AttendanceCommonWidgets().printF(url);
    if (connection) {
      try {
        var request = http.Request('GET', Uri.parse(url));
        AttendanceCommonWidgets().printF(
          'token ---------------------->${apiConstants.apiHeader}',
        );
        // request.body = (json.encode(data));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        AttendanceCommonWidgets().printF(
          'response ---------------------->${respString}',
        );
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> workStatusUpdate({required Map<String,dynamic> body }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.loyaltriField}${apiConstants.workStatusUpdate}";
    AttendanceCommonWidgets().printF(url);
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        AttendanceCommonWidgets().printF(
          'token ---------------------->${apiConstants.apiHeader}',
        );
        request.body = (json.encode(body));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        AttendanceCommonWidgets().printF(
          'response ---------------------->${respString}',
        );
        // if (response.statusCode == 201 || response.statusCode == 400) {
          return json.decode(respString);
        // } else {
        //   throw Exception(response.statusCode);
        // }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> otpOverride({required String workInstanceId }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.loyaltriField}${apiConstants.otpOverride.replaceAll("#work_instance_id", workInstanceId)}";
    AttendanceCommonWidgets().printF(url);
    if (connection) {
      try {
        var request = http.Request('GET', Uri.parse(url));
        AttendanceCommonWidgets().printF(
          'token ---------------------->${apiConstants.apiHeader}',
        );
        // request.body = (json.encode(data));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        AttendanceCommonWidgets().printF(
          'response ---------------------->${respString}',
        );
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> otpOverrideRequest({required Map<String,dynamic> body }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.loyaltriField}${apiConstants.otpOverrideRequest}";
    AttendanceCommonWidgets().printF(url);
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        AttendanceCommonWidgets().printF(
          'token ---------------------->${apiConstants.apiHeader}',
        );
        request.body = (json.encode(body));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        AttendanceCommonWidgets().printF(
          'response ---------------------->${respString}',
        );
        if (response.statusCode == 201 || response.statusCode == 400) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> checkWorkInprogress({required Map<String,dynamic> body }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.loyaltriField}${apiConstants.checkWorkInprogress}";
    AttendanceCommonWidgets().printF(url);
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        AttendanceCommonWidgets().printF(
          'token ---------------------->${apiConstants.apiHeader}',
        );
        request.body = (json.encode(body));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        AttendanceCommonWidgets().printF(
          'response ---------------------->${respString}',
        );
        if (response.statusCode == 200 || response.statusCode == 400) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> sendDeviceInfo({required Map<String,dynamic> body }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.loyaltriField}${apiConstants.sendDeviceInfo}";
    AttendanceCommonWidgets().printF(url);
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        AttendanceCommonWidgets().printF(
          'token ---------------------->${apiConstants.apiHeader}',
        );
        request.body = (json.encode(body));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        AttendanceCommonWidgets().printF(
          'response ---------------------->${respString}',
        );
        if (response.statusCode == 200 || response.statusCode == 400) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> checkEmployeWorkStatus({required Map<String,dynamic> body }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url = "${apiConstants.loyaltriField}${apiConstants.checkEmployeWorkStatus}";
    AttendanceCommonWidgets().printF(url);
    if (connection) {
      try {
        var request = http.Request('POST', Uri.parse(url));
        AttendanceCommonWidgets().printF(
          'token ---------------------->${apiConstants.apiHeader}',
        );
        request.body = (json.encode(body));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        AttendanceCommonWidgets().printF(
          'response ---------------------->${respString}',
        );
        if (response.statusCode == 200 || response.statusCode == 400) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getCompanySettings({
    required String companyId,
  }) async {
    bool connection = await ConnectivityService().check();
    ApiConstants apiConstants = ApiConstants();
    String url =
        "${apiConstants.loyaltriField}${apiConstants.fetchFieldSettings.replaceAll("#company_id", companyId)}";
    AttendanceCommonWidgets().printF(url);
    if (connection) {
      try {
        var request = http.Request('GET', Uri.parse(url));
        AttendanceCommonWidgets().printF(
          'token ---------------------->${apiConstants.apiHeader}',
        );
        request.headers.addAll(apiConstants.apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        AttendanceCommonWidgets().printF(
          'response ---------------------->$respString',
        );
        if (response.statusCode == 200) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  static Future<Map<String, dynamic>> getCheckInDetailsBG({
    required String empId,
    required String compId,
  }) async {
       String todayDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
    bool connection = await ConnectivityService().check();
    String url = "https://web-api.loyaltri.com/api/main";
    AttendanceCommonWidgets().printF(url);
    Map apiBody = {
      "action": "getCheckIn",
      "method": "POST",
      "kwargs": {"companyId": compId, "employeeId": empId, "checkInDate": todayDate},
    };
    if (connection) {
      try {
        await SyncManager().fetchTokenInBG();
        final userdata = await SecureStorageUtils().getUserData();
        var request = http.Request('POST', Uri.parse(url));
        request.body = (json.encode(apiBody));
        AttendanceCommonWidgets().printF(
          'Api body---------------------->${request.body}',
        );
        Map<String, String> apiHeader = {
          'Authorization': 'Bearer ${userdata?.userData?.token}',
          'Content-Type': 'application/json',
        };
        request.headers.addAll(apiHeader);
        http.StreamedResponse response = await request.send();
        var respString = await response.stream.bytesToString();
        if (response.statusCode == 200 || response.statusCode == 401) {
          return json.decode(respString);
        } else {
          throw Exception(response.statusCode);
        }
      } on SocketException catch (e) {
        throw Exception("Poor Network Connection");
      } catch (e) {
        throw Exception("Service Error");
      }
    } else {
      throw Exception("No internet connection");
    }
  }

  // <------------------ Loyaltri Field ---------------------> //

  static void addField(
      http.MultipartRequest request,
      String key,
      dynamic value,
      ) {
    if (value != null) {
      request.fields[key] = value.toString();
    }
  }

  static final ApiServices _instance = ApiServices._();

  factory ApiServices() => _instance;

  ApiServices._();
}
