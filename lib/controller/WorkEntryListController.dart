import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/models/work_entry_list_api_model.dart';
import '../View/Work_Entry/work_entry_widgets/work_entry_widget.dart';
import '../services/api_services.dart';
import '../utils/color_utils.dart';

class WorkEntryListController extends GetxController {
  Rx<bool> isLoading = false.obs;
  Rx<bool> dataLoaded = false.obs;
  Rx<bool> isError = false.obs;
  late Rx<WorkEntryListApiModel> workEntryList = workEntryListApiModel.obs;
  // RxList<WorkEntryDetail> dataPerMonth = workEntryDetail.obs;
  RxList dataPerMonth = [].obs;

  void resetStatus() {
    isLoading.value = false;
    isError.value = false;
  }

  Future fetchWorkEntryList({
    required DateTime month,
    required String empId,
  }) async {
    isLoading.value = true;
    String formattedDate = DateFormat('yyyy-MM').format(month);
    try {
      Map<String, dynamic> resp = await ApiServices.fetchWorkEntryList(
        month: formattedDate,
        empId: empId,
      );
      workEntryList.value = WorkEntryListApiModel.fromJson(resp);
      dataPerMonth.value = [];
      if (workEntryList.value.status == 200) {
        if (workEntryList.value.result.isNotEmpty) {
          await getListPerMonth(date: month);
        }
        dataLoaded.value = true;
      }
    } catch (e) {
      isError.value = true;
      AttendanceCommonWidgets().printF(
        "------work entry list error-------${e.toString()}",
      );
    } finally {
      resetStatus();
    }
  }

  Future getListPerMonth({required DateTime date}) async {
    List<String> dates = getAllDatesOfMonth(date.year, date.month);
    List<WorkEntryDetail> details = workEntryList.value.result;
    dates = dates.reversed.toList();
    try {
      details.sort((a, b) => a.date!.compareTo(b.date!));
      details = details.reversed.toList();
    } catch (e) {}
    // for (var element in details) {
    //   AttendanceCommonWidgets().printF("-------element.date---------${element.date}");
    // }
    // for (var date in dates) {
    //   AttendanceCommonWidgets().printF("-------date---------$date");
    // }
    for (var date in dates) {
      bool firstDate = true;
      for (int i = 0; i < details.length; i++) {
        if (date == details[i].date) {
          if (firstDate) {
            if (date == DateFormat('yyyy-MM-dd').format(DateTime.now())) {
              dataPerMonth.addAll([
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 8, bottom: 5).w,
                  child: Text(
                    'Today',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      color: ColorUtils.textWhite,
                    ),
                  ),
                ),
                WorkEntryContainerWidget(workEntryDetail: details[i]),
              ]);
            } else if (date ==
                DateFormat(
                  'yyyy-MM-dd',
                ).format(DateTime.now().subtract(const Duration(days: 1)))) {
              Widget widget = Container();
              if (details[i] != details.first) {
                if (details[i].date != details[i - 1].date) {
                  widget = Divider(
                    thickness: 1.w,
                    endIndent: 10.w,
                    indent: 10.w,
                    color: ColorUtils.textWhite.withOpacity(0.12),
                  );
                }
              }
              dataPerMonth.addAll([
                widget,
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 8, bottom: 5).w,
                  child: Text(
                    'Yesterday',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      color: ColorUtils.textWhite,
                    ),
                  ),
                ),
                WorkEntryContainerWidget(workEntryDetail: details[i]),
              ]);
            } else {
              Widget widget = Container();
              if (details[i] != details.first) {
                if (details[i].date != details[i - 1].date) {
                  widget = Divider(
                    thickness: 1.w,
                    endIndent: 10.w,
                    indent: 10.w,
                    color: ColorUtils.textWhite.withOpacity(0.12),
                  );
                }
              }
              dataPerMonth.addAll([
                widget,
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 8, bottom: 5).w,
                  child: Text(
                    DateFormat('MMM dd').format(DateTime.parse(date)),
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      color: ColorUtils.textWhite,
                    ),
                  ),
                ),
                WorkEntryContainerWidget(workEntryDetail: details[i]),
              ]);
            }
            firstDate = false;
          } else if (date != dates.first) {
            if (details[i].date != details[i - 1].date) {
              dataPerMonth.addAll([
                Divider(
                  thickness: 1.w,
                  endIndent: 10.w,
                  indent: 10.w,
                  color: ColorUtils.textWhite.withOpacity(0.12),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 8, bottom: 5).w,
                  child: Text(
                    DateFormat('MMM dd').format(DateTime.parse(date)),
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      color: ColorUtils.textWhite,
                    ),
                  ),
                ),
                WorkEntryContainerWidget(workEntryDetail: details[i]),
              ]);
            } else {
              dataPerMonth.add(
                WorkEntryContainerWidget(workEntryDetail: details[i]),
              );
            }
          } else {
            dataPerMonth.add(
              WorkEntryContainerWidget(workEntryDetail: details[i]),
            );
          }
        }
      }
    }
  }

  List<String> getAllDatesOfMonth(int year, int month) {
    List<String> dates = [];
    DateTime firstDayOfMonth = DateTime(year, month, 1);
    DateTime lastDayOfMonth = DateTime(year, month + 1, 1);

    for (
      var i = firstDayOfMonth;
      i.isBefore(lastDayOfMonth);
      i = i.add(const Duration(days: 1))
    ) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(i);
      dates.add(formattedDate);
    }

    List<String> datesInWork = [];
    for (var work in workEntryList.value.result) {
      if (work.date != null) {
        datesInWork.add(work.date.toString());
      }
    }
    datesInWork = datesInWork.toSet().toList();
    dates.retainWhere((element) => datesInWork.contains(element));
    dates.sort((a, b) => a.compareTo(b));

    return dates;
  }
}
