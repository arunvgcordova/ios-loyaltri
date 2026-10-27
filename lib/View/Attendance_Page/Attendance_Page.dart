
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loyaltri_minimal/View/Attendance_Page/attendance_widgets/new_attendance_summary.dart';
import 'package:loyaltri_minimal/View/Attendance_Page/attendance_widgets/roster_attendance_widget.dart';
import 'package:loyaltri_minimal/controller/leaveTypeController.dart';
import 'package:loyaltri_minimal/controller/userAuthentication.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';
import 'package:loyaltri_minimal/models/attendance_summary_model.dart';
import '../../controller/attSummaryController.dart';
import '../../controller/attendanceListController.dart';
import '../../utils/color_utils.dart';
import 'attendance_widgets/daily_activity_widget.dart';
import 'attendance_widgets/date_header.dart';
import 'attendance_widgets/summery_widget.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  final AttendanceList _attendanceListController = Get.find<AttendanceList>();
  final UserAuthController _userAuthController = Get.find<UserAuthController>();
  AttendanceSummaryController attendanceSummaryController = Get.find<AttendanceSummaryController>();

  // @override
  // void initState() {
  //   initialize();
  //   super.initState();
  // }

  Future initialize() async {
    String companyId = Get.find<UserProfileController>().userData.value.result.companyId?.toString() ?? '';
    DateTime date = DateFormat('yyyy-MM').parse(attendanceSummaryController.changedMonth.value);
    attendanceSummaryController.totalDays.value = DateTime(date.year, date.month + 1, 0).day;

    await _attendanceListController.fetchMonthCycleData(compId: companyId);
    await _attendanceListController.fetchAttendanceList(empId: _userAuthController.userData.value.userData?.employeeId ?? '--', compId: companyId);
    await attendanceSummaryController.getAttendanceSummary(empId: _userAuthController.userData.value.userData?.employeeId ?? '--', compId: companyId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.workEntryHead,
      body: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                DateHeader(
                  onMonthChanged: (String month) async {
                    DateTime changedMonth = DateFormat.yMMM().parse(month);
                    String employeeId = Get.find<UserAuthController>().userData.value.userData?.employeeId ?? '--';
                    String companyId = Get.find<UserProfileController>().userData.value.result.companyId?.toString() ?? '';
                    attendanceSummaryController.totalDays.value = DateTime(changedMonth.year, changedMonth.month + 1, 0).day;
                    _attendanceListController.changedMonth.value = DateFormat('yyyy-MM').format(changedMonth);
                    attendanceSummaryController.changedMonth.value = DateFormat('yyyy-MM').format(changedMonth);
                    attendanceSummaryController.attendanceSummary.value = AttendanceSummaryModel();
                    await _attendanceListController.fetchAttendanceList(empId: employeeId, compId: companyId);
                    await attendanceSummaryController.getAttendanceSummary(empId: employeeId, compId: companyId);
                  },
                ),
                GetX<AttendanceList>(
                  builder: (AttendanceList controller) {
                    // if (controller.isLoading.value) {
                    //   context.loaderOverlay.show();
                    // } else {
                    //   context.loaderOverlay.hide();
                    // }
                    return Container(
                      width: ScreenUtil().screenWidth,
                      height: ScreenUtil().screenHeight * 0.8,
                      child: RefreshIndicator(
                        onRefresh: () async {
                          await initialize();
                        },
                        child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.only(bottom: Platform.isIOS ? 120 : 100).w,
                          child: Column(
                            children: [
                              // Padding(
                              //   padding: const EdgeInsets.only(top: 5, bottom: 5, left: 8, right: 8).w,
                              //   child: Container(
                              //     // height: 310.w,
                              //     width: ScreenUtil().screenWidth,
                              //     decoration: BoxDecoration(
                              //         color: ColorUtils.backgroundBlack,
                              //         borderRadius: BorderRadius.circular(14).w
                              //     ),
                              //     child: const SummeryWidget(),
                              //   ),
                              // ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5, bottom: 5, left: 8, right: 8).w,
                                child: NewAttendanceSummary(),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 10).w,
                                child: Row(
                                  children: [
                                    Text(
                                      "Daily Activity",
                                      style: GoogleFonts.poppins(
                                        color: ColorUtils.textWhite,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if(controller.filteredAttendancePerMonth.isNotEmpty)
                                for(int i = 0; i < controller.filteredAttendancePerMonth.length; i++)
                                  if(controller.filteredAttendancePerMonth[i].shiftSchemeType == 'roster')
                                    RosterAttendanceWidget(activity: controller.filteredAttendancePerMonth[i])
                                  else
                                    DailyActivityWidget(activity: controller.filteredAttendancePerMonth[i])
                              else
                                SizedBox(
                                  height: 200.h,
                                  child: Center(
                                    child: Text(
                                      controller.isLoading.value ? "Loading..." : "No Activity",
                                      style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                                    ),
                                  ),
                                ),
                              SafeArea(top: false, child: SizedBox()),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
