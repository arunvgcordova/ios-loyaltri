import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loyaltri_minimal/View/CWidgets/cwidgets.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/attendance_appBar.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/attendance_card_absent_employee.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/attendance_summary_widget.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/date_selector.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/manager_attendance_controller/manager_attendance_controller.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';
import '../../Attendance_Page/attendance_widgets/strip_graph.dart';
import '../Manager_Request/request_wigets_manager/searchAndFilter.dart';
import 'attendance_widgets_manager/attendance_card_incomplete_employee.dart';
import 'attendance_widgets_manager/attendance_widget_shimmer.dart';

class ManagerAttendancePage extends StatefulWidget {
  const ManagerAttendancePage({super.key});

  @override
  State<ManagerAttendancePage> createState() => _ManagerAttendancePageState();
}

class _ManagerAttendancePageState extends State<ManagerAttendancePage> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // _scrollController = FixedExtentScrollController(initialItem: Get.find<ManagerAttendanceController>().currentDateIndex.value);
    // String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    // initialize(selectedDate: date);
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  Future<void> initialize({required String selectedDate}) async {
    // context.loaderOverlay.show();
    Get.find<ManagerAttendanceController>().attDetailsShimmer.value = false;
    await Get.find<ManagerAttendanceController>().fetchManagerAttSummary(
      date: selectedDate,
    );
    await Get.find<ManagerAttendanceController>().fetchManagerAttDetails(
      date: selectedDate,
    );
    // context.loaderOverlay.hide();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300 && !Get.find<ManagerAttendanceController>().loadingNextPage.value) {
      Get.find<ManagerAttendanceController>().fetchManagerAttDetailsNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Stack(
          children: [
            gradientContainer1,
            SafeArea(
              child: Column(
                children: [
                  SizedBox(height: 15.h),
                  GestureDetector(
                    onTap: () async {
                      await _showDatePicker(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18.h),
                      child: AttendanceAppBar(),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  DateSelector(
                    onMonthChanged: (int? selectedIndex) async {
                      if (selectedIndex != null) {
                        HapticFeedback.lightImpact();
                        DateTime dateTime =
                            Get.find<ManagerAttendanceController>()
                                .dateList
                                .value[selectedIndex];
                        int index = Get.find<ManagerAttendanceController>()
                            .dateList
                            .value
                            .indexWhere((date) => date == dateTime);
                        Get.find<ManagerAttendanceController>()
                            .currentDateIndex
                            .value = index;
                        String formated = DateFormat(
                          'yyyy-MM-dd',
                        ).format(dateTime);
                        await initialize(selectedDate: formated);
                      }
                    },
                  ),
                  SizedBox(height: 12.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.h),
                    child: SearchAndFilter(
                      filterPage: FilterPage.attendance,
                      color: ColorUtils.snowGrey,
                      result: (value) {
                        Get.find<ManagerAttendanceController>().searchText.value = value;
                        Get.find<ManagerAttendanceController>()
                            .filterManagerAttDetails(type: AttendanceFilterTypes.search);
                      },
                      showFilter: true,
                      isDarkMode: false,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Expanded(
                    child: GetX<ManagerAttendanceController>(
                      builder: (ManagerAttendanceController controller) {
                        return RefreshIndicator(
                          onRefresh: () async {
                            ManagerAttendanceController managerAttendanceController = Get.find<ManagerAttendanceController>();
                            String formated = DateFormat('yyyy-MM-dd').format(managerAttendanceController.dateList.value[managerAttendanceController.currentDateIndex.value]);

                            await initialize(selectedDate: formated);
                          },
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 7.h),
                                if(!controller.attDetailsShimmer.value)
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 13.h),
                                  child: AttendanceSummaryShimmer(),
                                )
                                else
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 13.h),
                                  child: AttendanceSummaryWidget(),
                                ),
                                SizedBox(height: 15.h),
                                if(!controller.attDetailsShimmer.value)
                                for(int index=0; index<10;index++)
                                 Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [

                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.h,
                                          ),
                                        child: AttendanceCardShimmer(),
                                      ),
                                       SizedBox(height: 13.h)
                                    ],
                                  )
                                  else if(controller.fliterdDeatialsData.value.isEmpty && !controller.loadingNextPage.value)
                                  RefreshIndicator(
                                    onRefresh: () async {
                                      ManagerAttendanceController managerAttendanceController = Get.find<ManagerAttendanceController>();
                                      String formated = DateFormat('yyyy-MM-dd').format(managerAttendanceController.dateList.value[managerAttendanceController.currentDateIndex.value]);

                                      await initialize(selectedDate: formated);
                                    },
                                    child: SingleChildScrollView(
                                      physics: AlwaysScrollableScrollPhysics(),
                                      child: SizedBox(
                                        height: ScreenUtil().screenHeight * 0.5,
                                        child: Center(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              left: 50.w,
                                              right: 50.w,
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    gradient: LinearGradient(
                                                      begin: Alignment.topCenter,
                                                      end: Alignment.bottomCenter,
                                                      colors: [
                                                        Color(0xFFF1F0F7),
                                                        Color(0xFFF8F8F8),
                                                      ],
                                                    ),
                                                  ),
                                                  padding: EdgeInsets.all(30.h),
                                                  child: Image.asset(
                                                    "assets/images/manager_view/attendance_icon.png",
                                                    height: 37.h,
                                                    fit: BoxFit.fitHeight,
                                                  ),
                                                ),
                                                SizedBox(height: 15.h),
                                                Text(
                                                  "No Attendance Records Found",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.dmSans(
                                                    fontWeight: FontWeight.w600,
                                                    color: ColorUtils.workEntryHead,
                                                    fontSize: 15.h,
                                                  ),
                                                ),
                                                SizedBox(height: 10.h),
                                                Text(
                                                  "Attendance data is not available for the selected month.",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.dmSans(
                                                    fontWeight: FontWeight.w400,
                                                    color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                                                    fontSize: 12.h,
                                                  ),
                                                ),
                                                SizedBox(height: 50.h),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  //  SizedBox(
                                  //   height: ScreenUtil().screenHeight * 0.3,
                                  //   child: Center(
                                  //     child: Text(
                                  //       "No Data Found",
                                  //       style: GoogleFonts.inter(
                                  //         color: Colors.grey,
                                  //         fontSize: 12.h,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // )

                                else
                                  for(int index = 0; index < controller.fliterdDeatialsData.value.length; index++)
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 15.h,
                                          ),
                                          child: AttendanceCardAbsentEmployee(
                                            employeeData:
                                            controller
                                                .fliterdDeatialsData
                                                .value[index],
                                          ),

                                        ),
                                        SizedBox(height: 13.h)
                                      ],
                                    ),
                                // ListView.separated(
                                //   physics: NeverScrollableScrollPhysics(),
                                //   padding: EdgeInsets.only(bottom: 100.h),
                                //   itemCount: controller.fliterdDeatialsData.value.length,
                                //   shrinkWrap: true,
                                //   itemBuilder: (context, index) {
                                //     return Padding(
                                //       padding: EdgeInsets.symmetric(
                                //         horizontal: 15.h,
                                //       ),
                                //       child: AttendanceCardAbsentEmployee(
                                //         employeeData:
                                //             controller
                                //                 .fliterdDeatialsData
                                //                 .value[index],
                                //       ),
                                //     );
                                //   },
                                //   separatorBuilder:
                                //       (context, index) => SizedBox(height: 13.h),
                                // ),
                                if(controller.loadingNextPage.value)
                                  SpinKitFadingCircle(
                                    size: 20,
                                    color: ColorUtils.royalPurple,
                                  ),
                                SizedBox(height: 100.h),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatNumber(double input) {
    // Check if the number is an integer.
    if (input % 1 == 0) {
      return input.toInt().toString(); // Return as an integer string
    }
    // Otherwise, return the original number as a string.
    return input.toString();
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final controller = Get.find<ManagerAttendanceController>();

    List<DateTime> dateList = controller.dateList.value;
    List<String> monthList = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    List<int> yearList = dateList.map((e) => e.year).toSet().toList();

    int currentMonthIndex = monthList.indexOf(
      DateFormat('MMM').format(dateList[controller.currentDateIndex.value]),
    );
    int currentYearIndex = yearList.indexOf(
      dateList[controller.currentDateIndex.value].year,
    );

    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Cancel",
      barrierColor: ColorUtils.workEntryHead.withAlpha(128),
      pageBuilder: (ctx, a1, a2) => const SizedBox.shrink(),
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: Center(
            child: Container(
              height: 250.h,
              width: 200.h,
              decoration: BoxDecoration(
                color: ColorUtils.textWhite,
                borderRadius: BorderRadius.circular(12).r,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Month Picker
                        Expanded(
                          child: CupertinoPicker(
                            scrollController: FixedExtentScrollController(
                              initialItem: currentMonthIndex,
                            ),
                            itemExtent: 40,
                            onSelectedItemChanged: (index) {
                              currentMonthIndex = index;
                            },
                            children:
                                monthList
                                    .map(
                                      (month) => Center(
                                        child: Text(
                                          month,
                                          style: TextStyle(fontSize: 18.h),
                                        ),
                                      ),
                                    )
                                    .toList(),
                          ),
                        ),
                        // Year Picker
                        Expanded(
                          child: CupertinoPicker(
                            scrollController: FixedExtentScrollController(
                              initialItem: currentYearIndex,
                            ),
                            itemExtent: 40,
                            onSelectedItemChanged: (index) {
                              currentYearIndex = index;
                            },
                            children:
                                yearList
                                    .map(
                                      (year) => Center(
                                        child: Text(
                                          "$year",
                                          style: TextStyle(fontSize: 18.h),
                                        ),
                                      ),
                                    )
                                    .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Color(0xFF565656).withValues(alpha: 0.2),
                    thickness: 0.5.h,
                    height: 0,
                  ),
                  Material(
                    color: ColorUtils.textWhite,
                    borderRadius: BorderRadius.circular(12).r,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 10.h,
                        horizontal: 12.h,
                      ),
                      decoration: BoxDecoration(
                        color: ColorUtils.textWhite,
                        borderRadius: BorderRadius.circular(12).r,
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: SizedBox(
                                width: 80.h,
                                height: 20.h,
                                child: Center(
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                      fontSize: 14.h,
                                      color: ColorUtils.workEntryHead,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 0.5.h,
                              height: 15.h,
                              color: Color(0xFF565656).withValues(alpha: 0.2),
                            ),
                            InkWell(
                              onTap: () {
                                // Update selected date in controller
                                String selectedMonth =
                                    monthList[currentMonthIndex];
                                int selectedYear = yearList[currentYearIndex];

                                DateTime? matchedDate = dateList.lastWhere(
                                  (d) =>
                                      DateFormat('MMM').format(d) ==
                                          selectedMonth &&
                                      d.year == selectedYear,
                                );

                                if (matchedDate != null) {
                                  controller.currentDateIndex.value = dateList
                                      .indexOf(matchedDate);
                                  controller.isChangedFromMonth.value = true;
                                  // _scrollController.animateToItem(
                                  //   controller.currentDateIndex.value,
                                  //   duration: const Duration(milliseconds: 300),
                                  //   curve: Curves.easeInOut,
                                  // );
                                }
                                Navigator.of(context).pop();
                              },
                              child: SizedBox(
                                width: 80.h,
                                height: 20.h,
                                child: Center(
                                  child: Text(
                                    "Ok",
                                    style: TextStyle(
                                      fontSize: 14.h,
                                      color: ColorUtils.workEntryHead,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
