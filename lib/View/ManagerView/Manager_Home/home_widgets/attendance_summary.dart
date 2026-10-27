import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loyaltri_minimal/View/ManagerView/Employee_Leave/Employee_Leave_Page.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/manager_attendance_controller/manager_attendance_controller.dart'
    show ManagerAttendanceController;
import 'package:loyaltri_minimal/View/ManagerView/Manager_Home/manager_home_controller/manager_home_controller.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Task/Manager_Task_Screen.dart';
import '../../../../controller/ui_controller/page_controller.dart';
import '../../../../models/manager/leave_request_list_model.dart';
import '../../../../utils/color_utils.dart';
import '../../../Attendance_Page/attendance_widgets/strip_graph.dart';
import '../../Employee_Leave/employee_leave_controller/employee_leave_controller.dart';
import '../../Manager_Attendance/attendance_widgets_manager/common_widgets.dart';

class AttendanceSummary extends StatelessWidget {
  const AttendanceSummary({super.key});

  @override
  Widget build(BuildContext context) {
    // double workingDayCount = 28;
    // double incompleteDayCount = 3;
    // double overtimeDayCount = 5;
    // double absentDayCount = 1;
    // double offDayCount = 6;
    // double total = 1;
    // total =
    //     workingDayCount +
    //     incompleteDayCount +
    //     overtimeDayCount +
    //     absentDayCount +
    //     offDayCount;
    // int workdays = 1;
    // int incomplete = 1;
    // int overtime = 1;
    // int absent = 1;
    // int offday = 1;

    // if (total != 0) {
    //   workdays = (360 * workingDayCount) ~/ total;
    //   incomplete = (360 * incompleteDayCount) ~/ total;
    //   overtime = (360 * overtimeDayCount) ~/ total;
    //   absent = (360 * absentDayCount) ~/ total;
    //   offday = (360 * offDayCount) ~/ total;
    // }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.h),
      child: Container(
        decoration: BoxDecoration(
          color: ColorUtils.textWhite,
          borderRadius: BorderRadius.circular(16).r,
          border: Border.all(
            color: ColorUtils.workEntryHead.withValues(alpha: 0.1),
          ),
        ),
        child: GetX<ManagerAttendanceController>(
          builder: (ManagerAttendanceController controller) {
            int workingDayCount = controller.summaryData.value?.present ?? 0;
            int halfDayCount = controller.summaryData.value?.halfDay ?? 0;
            int overtimeDayCount = controller.summaryData.value?.onLeave ?? 0;
            int absentDayCount = controller.summaryData.value?.absent ?? 0;
            int offDayCount = controller.summaryData.value?.offDays ?? 0;
            num total = 1;
            int totalemployees =
                controller.summaryData.value?.totalEmployees ?? 0;
            int onLeaveDayCount = controller.summaryData.value?.onLeave ?? 0;
            // total =
            //     workingDayCount +
            //         halfDayCount +
            //         overtimeDayCount +
            //         absentDayCount +
            //         offDayCount;
            total =
                workingDayCount + halfDayCount + absentDayCount + offDayCount + onLeaveDayCount;
            int workdays = 1;
            int halfDay = 1;
            int overtime = 1;
            int absent = 1;
            int offday = 1;
            int incomplete = 1;

            if (total != 0) {
              workdays = (320 * workingDayCount) ~/ total;
              halfDay = (320 * halfDayCount) ~/ total;
              overtime = (320 * overtimeDayCount) ~/ total;
              absent = (320 * absentDayCount) ~/ total;
              offday = (320 * offDayCount) ~/ total;
              incomplete = (320 *onLeaveDayCount) ~/ total;
            }
            bool isZero = false;
            // if(workdays == 0 && halfDay == 0 && overtime == 0 && absent == 0 && offday == 0) {
            //   isZero = true;
            // }
            if (workdays == 0 && halfDay == 0 && absent == 0 && offday == 0) {
              isZero = true;
            }
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10.h,
                    horizontal: 10.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            "assets/images/manager_view/att_summary_colorImg.png",
                            height: 23.h,
                          ),
                          SizedBox(width: 8.h),
                          Text(
                            'Attendance Summary',
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 13.h,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.find<UserPageController>().currentIndex.value = 1;
                        },
                        child: Row(
                          children: [
                            Text(
                              'View All',
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                color: ColorUtils.workEntryHead,
                                fontSize: 12.h,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 3.h),
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: ColorUtils.workEntryHead,
                              size: 9.h,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: ColorUtils.workEntryHead.withValues(alpha: 0.1),
                  height: 0.h,
                ),
                SizedBox(height: 15.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            borderRadius: BorderRadius.circular(10).r,
                            onTap: () async {
                              if (controller.currentDateIndex.value < 364) {
                                controller.currentDateIndex.value++;
                                Get.find<ManagerAttendanceController>()
                                    .isChangedFromMonth
                                    .value = true;

                                DateTime dateTime =
                                    Get.find<ManagerAttendanceController>().dateList.value[Get.find<ManagerAttendanceController>().currentDateIndex.value];
                                String formated = DateFormat('yyyy-MM-dd',).format(dateTime);
                                // context.loaderOverlay.show();
                                // await Get.find<ManagerAttendanceController>()
                                //     .fetchManagerAttSummary(date: formated);
                                // await Get.find<ManagerAttendanceController>()
                                //     .fetchManagerAttDetails(date: formated);
                                // context.loaderOverlay.hide();
                              }
                            },
                            child: Container(
                              width: 32.h,
                              height: 32.h,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1.h,
                                  color: ColorUtils.silverMist,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.arrow_back_ios_new_outlined,
                                  color: ColorUtils.foregroundBlack,
                                  size: 13.h,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.h),
                          Text(
                            DateFormat('MMM dd, yyyy').format(
                              controller.dateList[controller
                                  .currentDateIndex
                                  .value],
                            ),
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 11.h,
                              color: ColorUtils.workEntryHead.withValues(
                                alpha: 0.56,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.h),
                          InkWell(
                            borderRadius: BorderRadius.circular(10).r,
                            onTap: () async {
                              if (controller.currentDateIndex.value > 0) {
                                Get.find<ManagerAttendanceController>()
                                    .currentDateIndex
                                    .value--;
                                Get.find<ManagerAttendanceController>()
                                    .isChangedFromMonth
                                    .value = true;

                                // DateTime dateTime =
                                //     Get.find<ManagerAttendanceController>()
                                //         .dateList
                                //         .value[Get.find<
                                //           ManagerAttendanceController
                                //         >()
                                //         .currentDateIndex
                                //         .value];
                                // String formated = DateFormat(
                                //   'yyyy-MM-dd',
                                // ).format(dateTime);
                                // context.loaderOverlay.show();
                                // await Get.find<ManagerAttendanceController>()
                                //     .fetchManagerAttSummary(date: formated);
                                // await Get.find<ManagerAttendanceController>()
                                //     .fetchManagerAttDetails(date: formated);
                                // context.loaderOverlay.hide();
                              }
                            },
                            child: Container(
                              width: 32.h,
                              height: 32.h,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1.h,
                                  color: ColorUtils.silverMist,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: ColorUtils.foregroundBlack,
                                  size: 13.h,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Total Employees : ",
                            style: GoogleFonts.inter(
                              fontSize: 11.h,
                              fontWeight: FontWeight.w500,
                              color: ColorUtils.workEntryHead,
                            ),
                          ),
                          Text(
                            totalemployees.toInt().toString(),
                            style: GoogleFonts.inter(
                              fontSize: 13.h,
                              fontWeight: FontWeight.w600,
                              color: ColorUtils.workEntryHead,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if(total != 0)
                  SizedBox(height: 15.h),
                if(total != 0)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        StripGraphManager(
                          width: workdays,
                          height: 22,
                          radius:
                          BorderRadius.only(
                            topLeft: const Radius.circular(6),
                            bottomLeft: const Radius.circular(6),
                            topRight:
                            incomplete == 0 &&
                                overtime == 0 &&
                                absent == 0 &&
                                offday == 0
                                ? const Radius.circular(6)
                                : const Radius.circular(0),
                            bottomRight:
                            incomplete == 0 &&
                                overtime == 0 &&
                                absent == 0 &&
                                offday == 0
                                ? const Radius.circular(6)
                                : const Radius.circular(0),
                          ).w,
                          colors: const [Color(0xFF229B63), Color(0xFF2E875D)],
                        ),
                        StripGraphManager(
                          width: incomplete,
                          height: 22,
                          radius:
                          BorderRadius.only(
                            topLeft:
                            workdays == 0
                                ? const Radius.circular(6)
                                : const Radius.circular(0),
                            bottomLeft:
                            workdays == 0
                                ? const Radius.circular(6)
                                : const Radius.circular(0),
                            topRight:
                            absent == 0 && offday == 0
                                ? const Radius.circular(6)
                                : const Radius.circular(0),
                            bottomRight:
                            absent == 0 && offday == 0
                                ? const Radius.circular(6)
                                : const Radius.circular(0),
                          ).w,
                          colors: const [Color(0xFFED8E1F), Color(0xFFFBA759)],
                        ),
                        // StripGraphManager(
                        //   width: overtime,
                        //   radius: BorderRadius.only(
                        //     topLeft: incomplete == 0 && workdays == 0 ? const Radius.circular(6) : const Radius.circular(0),
                        //     bottomLeft: incomplete == 0 && workdays == 0 ? const Radius.circular(6) : const Radius.circular(0),
                        //     topRight: absent == 0 && offday == 0 ? const Radius.circular(6) : const Radius.circular(0),
                        //     bottomRight: absent == 0 && offday == 0 ? const Radius.circular(6) : const Radius.circular(0),
                        //   ).w,
                        //   colors: const [
                        //     Color(0xFF8B0FAE),
                        //     Color(0xFFB736DC),
                        //   ],
                        // ),
                        StripGraphManager(
                          width: absent,
                          height: 22,
                          radius:
                          BorderRadius.only(
                            topLeft:
                            overtime == 0 &&
                                workdays == 0 &&
                                incomplete == 0
                                ? const Radius.circular(6)
                                : const Radius.circular(0),
                            bottomLeft:
                            overtime == 0 &&
                                workdays == 0 &&
                                incomplete == 0
                                ? const Radius.circular(6)
                                : const Radius.circular(0),
                            topRight:
                            offday == 0
                                ? const Radius.circular(6)
                                : const Radius.circular(0),
                            bottomRight:
                            offday == 0
                                ? const Radius.circular(6)
                                : const Radius.circular(0),
                          ).w,
                          colors: const [Color(0xFFAF2B21), Color(0xFFC83C31)],
                        ),
                        StripGraphManager(
                          width: offday,
                          height: 22,
                          radius:
                          BorderRadius.only(
                            topLeft:
                            workdays == 0 &&
                                incomplete == 0 &&
                                overtime == 0 &&
                                absent == 0
                                ? const Radius.circular(6)
                                : const Radius.circular(0),
                            bottomLeft:
                            workdays == 0 &&
                                incomplete == 0 &&
                                overtime == 0 &&
                                absent == 0
                                ? const Radius.circular(6)
                                : const Radius.circular(0),
                            topRight: const Radius.circular(6),
                            bottomRight: const Radius.circular(6),
                          ).w,
                          colors: const [Color(0xFFE0E0E4), Color(0xFFC6C6C6)],
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.h),
                  child: Container(
                    height: 74.h,
                    padding: EdgeInsets.symmetric(horizontal: 10.h),
                    decoration: BoxDecoration(
                      color: ColorUtils.frostWhite,
                      borderRadius: BorderRadius.circular(7).r,
                      image: DecorationImage(
                        image: AssetImage(
                          "assets/images/manager_view/att_summary_bg.png",
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Present",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w400,
                                fontSize: 11.h,
                                color: ColorUtils.workEntryHead,
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 10.h,
                                  height: 10.h,
                                  decoration: BoxDecoration(
                                    color: ColorUtils.emeraldGreen.withValues(
                                      alpha: 0.15,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Container(
                                      width: 5.h,
                                      height: 5.h,
                                      decoration: BoxDecoration(
                                        color: ColorUtils.emeraldGreen,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  formatNumber(workingDayCount),
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.h,
                                    color: ColorUtils.workEntryHead,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          width: 1.h,
                          height: 31.h,
                          color: ColorUtils.softSilver,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Absent",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w400,
                                fontSize: 11.h,
                                color: ColorUtils.workEntryHead,
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 10.h,
                                  height: 10.h,
                                  decoration: BoxDecoration(
                                    color: ColorUtils.cherryRed.withValues(
                                      alpha: 0.15,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Container(
                                      width: 5.h,
                                      height: 5.h,
                                      decoration: BoxDecoration(
                                        color: ColorUtils.cherryRed,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  formatNumber(absentDayCount),
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.h,
                                    color: ColorUtils.workEntryHead,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          width: 1.h,
                          height: 31.h,
                          color: ColorUtils.softSilver,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "On Leave",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w400,
                                fontSize: 11.h,
                                color: ColorUtils.workEntryHead,
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 10.h,
                                  height: 10.h,
                                  decoration: BoxDecoration(
                                    color: ColorUtils.goldenOrange.withValues(
                                      alpha: 0.15,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Container(
                                      width: 5.h,
                                      height: 5.h,
                                      decoration: BoxDecoration(
                                        color: ColorUtils.goldenOrange,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  formatNumber(onLeaveDayCount),
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.h,
                                    color: ColorUtils.workEntryHead,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          width: 1.h,
                          height: 31.h,
                          color: ColorUtils.softSilver,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Half Day",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w400,
                                fontSize: 11.h,
                                color: ColorUtils.workEntryHead,
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 10.h,
                                  height: 10.h,
                                  decoration: BoxDecoration(
                                    color: ColorUtils.steelGrey.withValues(
                                      alpha: 0.15,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Container(
                                      width: 5.h,
                                      height: 5.h,
                                      decoration: BoxDecoration(
                                        color: ColorUtils.steelGrey,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  formatNumber(halfDayCount),
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.h,
                                    color: ColorUtils.workEntryHead,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 8.h,
                          horizontal: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: ColorUtils.roseMint,
                          borderRadius: BorderRadius.circular(8).r,
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/images/manager_view/att_summary_calendar.png",
                              height: 18.h,
                            ),
                            SizedBox(width: 5.h),
                            RichText(
                              text: TextSpan(
                                style: GoogleFonts.dmSans(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.h,
                                  color: ColorUtils.workEntryHead,
                                ),
                                children: [
                                  TextSpan(text: "Next "),
                                  TextSpan(
                                    text: "7 days",
                                    style: GoogleFonts.dmSans(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12.h,
                                      color: ColorUtils.workEntryHead,
                                    ),
                                  ),
                                  TextSpan(text: " Leaves"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          List<EmployeeLeaveData> leaveList = Get.find<ManagerAttendanceController>().next7DaysLeaveList.value;
                          if(leaveList.isNotEmpty) {
                            showModalBottomSheet(
                              backgroundColor: ColorUtils.textWhite,
                              context: context,
                              isScrollControlled: true,
                              barrierColor: ColorUtils.workEntryHead
                                  .withValues(alpha: 0.5),
                              constraints: BoxConstraints(
                                maxHeight: ScreenUtil().screenHeight * 0.6,
                              ),
                              builder: (BuildContext context) {
                                return GestureDetector(
                                  onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                                  child: SafeArea(
                                    child: Container(
                                      // height: MediaQuery.of(context).viewInsets.bottom + 530.h,
                                      width: ScreenUtil().screenWidth,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.only(
                                          topLeft: Radius.circular(30),
                                          topRight: Radius.circular(30),
                                        ).r,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 15.w, left: 15.w, right: 15.w),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(width: 48.h, height: 48.h),
                                                const Spacer(),
                                                Text(
                                                  leaveList.length == 1 ? "Employee" : "Employees",
                                                  style: GoogleFonts.poppins(
                                                    color: ColorUtils.workEntryHead,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 15.h,
                                                  ),
                                                ),
                                                const Spacer(),
                                                GestureDetector(
                                                  onTap: () async {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.all(1).h,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(14).r,
                                                      color: ColorUtils.charcoalBlue.withValues(alpha: 0.1),
                                                    ),
                                                    child: Container(
                                                      height: 46.h,
                                                      width: 46.h,
                                                      decoration: BoxDecoration(
                                                        color: ColorUtils.textWhite,
                                                        borderRadius: BorderRadius.circular(13).r,
                                                        // border: Border.all(
                                                        //   width: 1.h,
                                                        //   color: ColorUtils.charcoalBlue.withValues(alpha: 0.1),
                                                        // ),
                                                      ),
                                                      child: Center(
                                                        child: Icon(
                                                          Icons.close,
                                                          size: 18.h,
                                                          color: ColorUtils.workEntryHead,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            // Obx(() {
                                            //     return RegularizeTitle(
                                            //         title: "Regularize",
                                            //       action: () {
                                            //         Navigator.of(context).pop();
                                            //         Navigator.of(context).pop();
                                            //       },
                                            //     );
                                            //   }
                                            // ),
                                            SizedBox(height: 20.h),
                                            Flexible(
                                              child: ListView.separated(
                                                shrinkWrap: true,
                                                itemCount: leaveList.length,
                                                padding: EdgeInsets.only(
                                                  bottom: 10.h,
                                                ),
                                                itemBuilder: (context, i) {
                                                  String? formattedFromDate;
                                                  String? formattedToDate;
                                                  try {
                                                    DateTime from = DateTime.parse(leaveList[i].leaveDateFrom!);
                                                    formattedFromDate = DateFormat('dd MMM yyyy').format(from);
                                                    DateTime to = DateTime.parse(leaveList[i].leaveDateTo!);
                                                    formattedToDate = DateFormat('dd MMM yyyy').format(to);
                                                  } catch(e) {}
                                                  return Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          AttendanceCommonWidgets().cachedNetworkImage(
                                                            leaveList[i].profilePicture ?? '',
                                                          ),
                                                          SizedBox(width: 8.h),
                                                          Expanded(
                                                            child: AttendanceCommonWidgets().nameWithDesignation(
                                                              name: leaveList[i].employeeName ?? '--',
                                                              designation: leaveList[i].designation ?? '--',
                                                            ),
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment.end,
                                                            children: [
                                                              Text(
                                                                "No of days",
                                                                style: GoogleFonts.poppins(
                                                                  color: ColorUtils.workEntryHead,
                                                                  fontWeight: FontWeight.w400,
                                                                  fontSize: 11.h,
                                                                ),
                                                                overflow: TextOverflow.ellipsis,
                                                              ),
                                                              Text(
                                                                leaveList[i].totalLeaveDays ?? '--',
                                                                style: GoogleFonts.inter(
                                                                  color: ColorUtils.fieryScarlet,
                                                                  fontWeight: FontWeight.w600,
                                                                  fontSize: 11.h,
                                                                ),
                                                                overflow: TextOverflow.ellipsis,
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 10.h),
                                                      Padding(
                                                        padding: EdgeInsets.symmetric(
                                                          horizontal: 3.h,
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  "Leave Type",
                                                                  style: GoogleFonts.poppins(
                                                                    fontSize: 11.h,
                                                                    fontWeight: FontWeight.w400,
                                                                    color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  leaveList[i].leaveTypeName ?? '--',
                                                                  style: GoogleFonts.inter(
                                                                    fontSize: 11.h,
                                                                    fontWeight: FontWeight.w500,
                                                                    color: ColorUtils.workEntryHead,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Container(width: 1.h, height: 15.h, color: ColorUtils.paleSilver),
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  "Start Date",
                                                                  style: GoogleFonts.poppins(
                                                                    fontSize: 11.h,
                                                                    fontWeight: FontWeight.w400,
                                                                    color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  formattedFromDate ?? '--',
                                                                  style: GoogleFonts.inter(
                                                                    fontSize: 11.h,
                                                                    fontWeight: FontWeight.w500,
                                                                    color: ColorUtils.workEntryHead,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Container(width: 1.h, height: 15.h, color: ColorUtils.paleSilver),
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  "End Date",
                                                                  style: GoogleFonts.poppins(
                                                                    fontSize: 11.h,
                                                                    fontWeight: FontWeight.w400,
                                                                    color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  formattedToDate ?? '--',
                                                                  style: GoogleFonts.inter(
                                                                    fontSize: 11.h,
                                                                    fontWeight: FontWeight.w500,
                                                                    color: ColorUtils.workEntryHead,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                                separatorBuilder: (context, index) => Divider(
                                                  color: ColorUtils.workEntryHead.withValues(alpha: 0.1),
                                                  height: 30.h,
                                                  thickness: 1.h,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                        child: Row(
                          children: [
                            Text(
                              "${controller.next7DaysLeaveList.value.length}",
                              style: GoogleFonts.dmSans(
                                fontSize: 14.h,
                                fontWeight: FontWeight.w600,
                                color: ColorUtils.workEntryHead,
                              ),
                            ),
                            Text(
                              controller.next7DaysLeaveList.value.length == 1 ? " employee" : " employees",
                              style: GoogleFonts.dmSans(
                                fontSize: 12.h,
                                fontWeight: FontWeight.w400,
                                color: ColorUtils.workEntryHead,
                                letterSpacing: -0.2,
                              ),
                            ),
                            SizedBox(width: 5.h),
                            if(controller.next7DaysLeaveList.value.isNotEmpty)
                              Container(
                                width: controller.empWidth.value,
                                height: 26.h,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Stack(
                                    children: [
                                      for (int i = 0; i < controller.next7DaysLeaveList.value.length; i++)
                                        if (i < 3)
                                          Positioned(
                                            left: (i * 15).h,
                                            top: 0,
                                            bottom: 0,
                                            child: Container(
                                              height: 29.h,
                                              width: 29.h,
                                              child: FittedBox(
                                                child: AttendanceCommonWidgets().cachedNetworkImage(
                                                  controller.next7DaysLeaveList.value[i].profilePicture ?? '',
                                                  height: 29.h,
                                                ),
                                              ),
                                            ),
                                          ),
                                    ],
                                  ),
                                ),
                              ),
                            // SizedBox(
                            //   width: 60.h,
                            //   child: Stack(
                            //     children: [
                            //       Image.asset(
                            //         "assets/examples/user_approval2.png",
                            //         height: 26.h,
                            //       ),
                            //       Positioned(
                            //         left: 15.h,
                            //         child: Image.asset(
                            //           "assets/examples/user_request.png",
                            //           height: 26.h,
                            //         ),
                            //       ),
                            //       Positioned(
                            //         left: 30.h,
                            //         child: Image.asset(
                            //           "assets/examples/user_approval1.png",
                            //           height: 26.h,
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 13.h),
              ],
            );
          },
        ),
      ),
    );
  }

  String formatNumber(int input) {
    // Check if the number is an integer.
    if (input % 1 == 0) {
      return input.toInt().toString(); // Return as an integer string
    }
    // Otherwise, return the original number as a string.
    return input.toString();
  }
}
