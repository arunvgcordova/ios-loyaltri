
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/models/check_detail_api_model.dart';
import 'package:loyaltri_minimal/sqflite_db/punch_db.dart';
import '../View/Login/Login_Screen.dart';
import '../models/checkIn_model.dart';
import '../services/api_services.dart';
import '../services/controller_handling.dart';
import '../services/flutter_secure_storage.dart';
import 'attendanceUploadController.dart';

class CheckInController extends GetxController {
  Rx<bool> isLoading = false.obs;
  Rx<bool> dataLoaded = false.obs;
  Rx<bool> isError = false.obs;
  Rx<bool> breakTimeRunning = false.obs;
  Rx<String> breakTimeDuration = "".obs;
  Rx<CheckInDataAPI> checkInData = checkInDataAPI.obs;
  Rx<BreakDates> breakDates = const BreakDates().obs;

  void resetStatus() {
    isLoading.value = false;
    isError.value = false;
  }

  Future getCheckInData({required String compId, required String empId}) async {
    isLoading.value = true;
    final SecureStorageUtils prefs = SecureStorageUtils();
    try {
      await Get.find<AttendanceUploadController>().sendAttendance();
      String todayDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
      Map<String, dynamic> resp = await ApiServices.getCheckInDetails(empId: empId, compId: compId, date: todayDate);
      AttendanceCommonWidgets().printF("-------resp--------$resp");
      if (resp['status'] == 200) {
        await prefs.remove("punch");
        CheckInDataAPI data = CheckInDataAPI.fromJson(resp);
        checkInData.value = data;
        String? timeString;
        if(checkInData.value.result.checkInTime != null && checkInData.value.result.checkOutTime == null) {

          if(checkInData.value.result.breakDatas != null) {
            if(checkInData.value.result.breakDatas!.isNotEmpty) {

              breakDates.value = checkInData.value.result.breakDatas?.last ?? const BreakDates();
              if(breakDates.value.startTime != null && breakDates.value.endTime == null) {
                timeString = breakDates.value.startTime;
                breakTimeRunning.value = true;
              } else {
                timeString = checkInData.value.result.checkInDateTime!;
                breakTimeRunning.value = false;
              }
            } else {
              timeString = checkInData.value.result.checkInDateTime!;
              breakTimeRunning.value = false;
            }
          } else {
            timeString = checkInData.value.result.checkInDateTime!;
            breakTimeRunning.value = false;
          }

          timeString ?? checkInData.value.result.checkInDateTime!;
          // List<String> timeParts = timeString!.split(":");
          // DateTime now = DateTime.now();
          // int hours = int.parse(timeParts[0]);
          // int minutes = int.parse(timeParts[1]);
          // int seconds = int.parse(timeParts[2]);
          // DateTime dateTime = DateTime(now.year, now.month, now.day, hours, minutes, seconds);
          DateTime dateTime = DateTime.parse(timeString!);

          dataLoaded.value = true;
        }

        AttendanceCommonWidgets().printF("------timeString--------$timeString");

        // if(timeString == null) {
        //   String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
        //   List<AttendanceCheckModel> punchData = await PunchDatabase.instance.readTodayPunchData(todayDate);
        //
        //   if(punchData.isNotEmpty) {
        //     if(punchData.last.punchState == "breakIn") {
        //       String dateTime = "${punchData.last.punchDate} ${punchData.last.punchTime}";
        //       await prefs.setString("punch", dateTime);
        //       breakTimeRunning.value = true;
        //     } else {
        //       breakTimeRunning.value = false;
        //       for(int i = punchData.length - 1; i >= 0; i--) {
        //         if(punchData.last.punchState == "punchOut") {
        //           break;
        //         } else if(punchData[i].punchState == "punchIn") {
        //           String dateTime = "${punchData[i].punchDate} ${punchData[i].punchTime}";
        //           await prefs.setString("punch", dateTime);
        //         }
        //       }
        //     }
        //   }
        // } else {
        await prefs.setString("punch", timeString ?? '');
        // }

        if(checkInData.value.result.breakDatas != null) {
          if(checkInData.value.result.breakDatas!.isNotEmpty) {
            int minutes = 0;
            checkInData.value.result.breakDatas?.forEach((element) {
              minutes += int.parse(element.minutesTaken ?? "0");
            });
            if(minutes != 0) {
              breakTimeDuration.value = minutes.toString();
            }
          }
        }

      } else if(resp['status'] == 401 && resp['message'] == "Access denied") {
        await SecureStorageUtils().removeUserData();
        await SecureStorageUtils().removeProfileData();
        await SecureStorageUtils().removePunchTypeData();
        await SecureStorageUtils().removeErrorOccurs();
        await PunchDatabase.instance.deleteTable();
        await HandleControllers.deleteAllGetControllers();
        await HandleControllers.createGetControllers();
        await Get.offAll(() => const LoginScreen());
      } else {
        String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
        List<AttendanceCheckModel> punchData = await PunchDatabase.instance.readTodayPunchData(todayDate);

        if(punchData.isNotEmpty) {
          DateTime now = DateTime.now();
          String nowDate = now.toString().split(' ').first;
          if(punchData.last.punchState == "breakIn" && nowDate == punchData.last.punchDate) {
            String dateTime = "${punchData.last.punchDate} ${punchData.last.punchTime}";
            await prefs.setString("punch", dateTime);
            breakTimeRunning.value = true;
          } else {
            breakTimeRunning.value = false;
            for(int i = punchData.length - 1; i >= 0; i--) {
              DateTime now = DateTime.now();
              String nowDate = now.toString().split(' ').first;
              if(punchData.last.punchState == "punchOut") {
                break;
              } else if(punchData[i].punchState == "punchIn" && nowDate == punchData[i].punchDate) {
                String dateTime = "${punchData[i].punchDate} ${punchData[i].punchTime}";
                await prefs.setString("punch", dateTime);
              }
            }
          }
        }
      }
    } catch(e) {
      isError.value = true;
      dataLoaded.value = false;
      String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      List<AttendanceCheckModel> punchData = await PunchDatabase.instance.readTodayPunchData(todayDate);

      if(punchData.isNotEmpty) {
        DateTime now = DateTime.now();
        String nowDate = now.toString().split(' ').first;
        if(punchData.last.punchState == "breakIn" && nowDate == punchData.last.punchDate) {
          String dateTime = "${punchData.last.punchDate} ${punchData.last.punchTime}";
          await prefs.setString("punch", dateTime);
          breakTimeRunning.value = true;
        } else {
          breakTimeRunning.value = false;
          for(int i = punchData.length - 1; i >= 0; i--) {
            DateTime now = DateTime.now();
            String nowDate = now.toString().split(' ').first;
            if(punchData.last.punchState == "punchOut") {
              break;
            } else if(punchData[i].punchState == "punchIn" && nowDate == punchData[i].punchDate) {
              String dateTime = "${punchData[i].punchDate} ${punchData[i].punchTime}";
              await prefs.setString("punch", dateTime);
            }
          }
        }
      }

      // if(punchData.isNotEmpty && (punchData.last.punchState == "punchIn" || punchData.last.punchState == "breakIn")) {
      //   String dateTime = "${punchData.last.punchDate} ${punchData.last.punchTime}";
      //   await prefs.setString("punch", dateTime);
      //   if(punchData.last.punchState == "breakIn") {
      //     breakTimeRunning.value = true;
      //   }
      // } else {
      //
      // }
      AttendanceCommonWidgets().printF("------checkIn error-------${e.toString()}");
    } finally {
      resetStatus();
    }
  }
}

extension TimeFormatExtension on String {
  String toAmPm() {
    try {
      DateTime time;

      // Accept `HH:mm` or `HH:mm:ss`
      if (length == 5) {
        time = DateFormat("HH:mm").parse(this);
      } else {
        time = DateFormat("HH:mm:ss").parse(this);
      }

      return DateFormat("hh:mm a").format(time);
    } catch (_) {
      return this; // return original string if parsing fails
    }
  }
}