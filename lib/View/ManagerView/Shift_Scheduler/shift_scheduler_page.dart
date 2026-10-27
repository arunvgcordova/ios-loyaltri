import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';
import 'package:loyaltri_minimal/utils/api_constants.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Request/request_wigets_manager/request_app_bar.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Request/request_wigets_manager/searchAndFilter.dart';
import 'package:loyaltri_minimal/View/ManagerView/Shift_Scheduler/widgets/shift_list_sheet.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/models/manager/shift_scheduler_employee.dart';
import 'package:loyaltri_minimal/View/ManagerView/Shift_Scheduler/shift_scheduler_controller/shift_scheduler_controller.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/manager_attendance_controller/manager_attendance_controller.dart';
import 'package:loyaltri_minimal/View/ManagerView/Shift_Scheduler/widgets/shift_scheduler_shimmer.dart';

class ShiftSchedulerScreen extends StatelessWidget {
  const ShiftSchedulerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ShiftSchedulerController controller = Get.find<ShiftSchedulerController>();

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: ColorUtils.textWhite,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                ColorUtils.lavenderPurple,
                ColorUtils.lavenderMist,
                ColorUtils.textWhite,
              ],
              stops: [0.0, 0.1, 0.15],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildAppBar(context),
                _buildSearchBar(),
                SizedBox(height: 10.h),
                Obx(() => _buildDateNavigator(controller)),
                SizedBox(height: 10.h),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const ShiftSchedulerShimmer();
                    } else if (controller.employees.isEmpty) {
                      return RefreshIndicator(
                        onRefresh: () async => await controller.fetchEmployees(),
                        color: ColorUtils.secondaryBlue,
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(height: 200.h),
                            Center(
                              child: Text(
                                "No employees found",
                                style: GoogleFonts.inter(
                                    color: ColorUtils.workEntryHead.withValues(alpha: 0.7),
                                    fontSize: 13.h,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: () async => await controller.fetchEmployees(),
                      color: ColorUtils.secondaryBlue,
                      notificationPredicate: (notification) => notification.depth == 1,
                      child: _buildMainGrid(context, controller),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 15.h,
        left: 15.w,
        right: 15.w,
        bottom: 10.h,
      ),
      child: const RequestAppBar(
        title: 'Shift Scheduler',
        icon: 'assets/images/shift_scheduler/scheduler_icon.png',
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 15.w,
        vertical: 10.h,
      ),
      child: SearchAndFilter(
        filterPage: FilterPage.shiftScheduler,
        color: ColorUtils.paleLavenderMist,
        result: (value) {},
        showFilter: true,
        isDarkMode: false,
      ),
    );
  }

  Widget _buildDateNavigator(ShiftSchedulerController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => controller.previousWeek(),
            child: Container(
              height: 36.h,
              width: 36.h,
              decoration: BoxDecoration(
                color: ColorUtils.lavenderWhisper,
                borderRadius: BorderRadius.circular(12).r,
              ),
              child: Icon(Icons.arrow_back_ios_new, size: 14.h, color: ColorUtils.shadowGrey),
            ),
          ),
          Text(
            controller.weekDateRangeLabel,
            style: GoogleFonts.inter(
              fontSize: 13.h,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          GestureDetector(
            onTap: () => controller.nextWeek(),
            child: Container(
              height: 36.h,
              width: 36.h,
              decoration: BoxDecoration(
                color: ColorUtils.lavenderWhisper,
                borderRadius: BorderRadius.circular(12).r,
              ),
              child: Icon(Icons.arrow_forward_ios, size: 14.h, color: ColorUtils.shadowGrey),
            ),
          ),
        ],
      ),
    );
  }

   Map<int, TableColumnWidth> get _columnWidths => {
    0: FixedColumnWidth(140.h), // Emp & Date
    1: FixedColumnWidth(150.h),
    2: FixedColumnWidth(150.h),
    3: FixedColumnWidth(150.h),
    4: FixedColumnWidth(150.h),
    5: FixedColumnWidth(150.h),
    6: FixedColumnWidth(150.h),
    7: FixedColumnWidth(150.h),
  };

  Widget _buildMainGrid(BuildContext context, ShiftSchedulerController controller) {
    final gridDates = controller.formattedGridDates;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        width: 140.h + (150.h * 7),
        child: Column(
          children: [
            // Fixed Header Row
            Table(
              columnWidths: _columnWidths,
              border: const TableBorder(
                bottom: BorderSide(color: ColorUtils.platinum, width: 0.8),
              ),
              children: [
                TableRow(
                  children: [
                    _buildEmpHeaderCell(),
                    ...List.generate(7, (index) {
                      final map = gridDates[index];
                      return _buildDateHeaderCell(map['day']! as String, map['date']! as String, map['isToday'] as bool);
                    }),
                  ]
                )
              ],
            ),
            
            // Vertically Scrolling Content underneath fixed headers
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: const AlwaysScrollableScrollPhysics(),
                child: Table(
                  columnWidths: _columnWidths,
                  border: const TableBorder(
                    bottom: BorderSide(color: ColorUtils.platinum, width: 0.8),
                    horizontalInside: BorderSide(color: ColorUtils.platinum, width: 0.8),
                  ),
                  children: List.generate(controller.employees.length, (index) => _buildDataTableRow(context, controller, index)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpHeaderCell() {
    return SizedBox(
      height: 50.h,
      child: Padding(
        padding: EdgeInsets.only(left: 13.h),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Emp & Date',
            style: GoogleFonts.poppins(
              color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
              fontSize: 11.h,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateHeaderCell(String day, String date, bool isToday) {
    return SizedBox(
      height: 50.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: GoogleFonts.inter(
              color: ColorUtils.workEntryHead.withValues(alpha: 0.7),
              fontSize: 13.h,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 6.h),
          if (isToday)
            Container(
              width: 30.h,
              height: 30.h,
              decoration: const BoxDecoration(color: ColorUtils.secondaryBlue, shape: BoxShape.circle),
              child: Center(
                child: Text(
                  date,
                  style: GoogleFonts.inter(
                    color: ColorUtils.textWhite,
                    fontWeight: FontWeight.w500,
                    fontSize: 13.h,
                  ),
                ),
              ),
            )
          else
            Text(
              date,
              style: GoogleFonts.inter(
                color: ColorUtils.workEntryHead,
                fontWeight: FontWeight.w500,
                fontSize: 13.h,
              ),
            ),
        ],
      ),
    );
  }

  TableRow _buildDataTableRow(BuildContext context, ShiftSchedulerController controller, int index) {
    final emp = controller.employees[index];
    final empName = emp.employeeName ?? '--';
    final empCode = emp.employeeId ?? '--';
    final initials = empName.isNotEmpty ? empName.trim().split(' ').map((e) => e.isNotEmpty ? e[0].toUpperCase() : '').take(2).join() : '';
    final seedColors = [ColorUtils.steelBlue, ColorUtils.fieryScarlet, ColorUtils.lavenderIndigo, ColorUtils.jungleGreen, ColorUtils.tigerOrange, ColorUtils.neonViolet, ColorUtils.royalBlue, ColorUtils.amethystPurple, ColorUtils.darkEspresso, ColorUtils.deepSlate, ColorUtils.fieryRed];
    final seedColor = seedColors[empName.hashCode % seedColors.length];

    return TableRow(
      children: [
        _buildEmpCell(empName, empCode, initials, seedColor, emp.profilePicture),
        ...List.generate(7, (dayIndex) => _buildShiftCellContent(context, controller, emp, dayIndex)),
      ],
    );
  }

  Widget _buildEmpCell(String name, String id, String initials, Color seedColor, String? imgUrl) {
    String profileImageUrl = '';
    if (imgUrl != null && imgUrl.isNotEmpty) {
      profileImageUrl = imgUrl;
    }

    return Container(
      padding: EdgeInsets.only(left: 10.h, top: 8.h, bottom: 8.h, right: 8.h),
      alignment: Alignment.centerLeft,
      decoration: const BoxDecoration(
        color: ColorUtils.textWhite,
        border: Border(
          right: BorderSide(color: ColorUtils.platinum, width: 0.8), // Only employee column needs a right border separator
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: Container(
              width: 40.h,
              height: 40.h,
              color: seedColor.withValues(alpha: 0.15),
              child: CachedNetworkImage(
                imageUrl: profileImageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) {
                  return Center(
                    child: Text(
                      initials,
                      style: TextStyle(
                        color: seedColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 11.h,
                      ),
                    ),
                  );
                },
                errorWidget: (context, url, error) {
                  return Center(
                    child: Text(
                      initials,
                      style: TextStyle(
                        color: seedColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 11.h,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(width: 8.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 11.h,
                    color: ColorUtils.workEntryHead,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  id,
                  style: GoogleFonts.inter(
                    color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                    fontSize: 11.h,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildShiftCellContent(BuildContext context, ShiftSchedulerController controller, ShiftSchedulerEmployee emp, int dayIndex) {
    DateTime currentDay = controller.currentWorkingDays[dayIndex];
    String formattedDay = DateFormat('yyyy-MM-dd').format(currentDay);
    
    // Find the shift for this day
    var shiftData = emp.shiftSheduledData?.firstWhereOrNull((s) => s.date == formattedDay);
    
    Widget shiftWidget;
    if (shiftData == null) {
      shiftWidget = _buildEmptyAddShift(context);
    } else if (shiftData.shiftType?.toLowerCase() == 'off day' || shiftData.shift?.toLowerCase() == 'off day') {
       shiftWidget = _buildOffDayShift();
    } else {
       String displayText = shiftData.shift ?? '';
       if (shiftData.startTime != null && shiftData.endTime != null && shiftData.startTime!.isNotEmpty && shiftData.endTime!.isNotEmpty) {
         displayText = '${shiftData.startTime} - ${shiftData.endTime}';
       } else if (displayText.isEmpty) {
         displayText = shiftData.workHours ?? 'Shift';
       }

       // Pick a color based on shiftId or string length to be somewhat consistent
       int colorSeed = (shiftData.shiftId?.hashCode ?? displayText.length) % 4;
       switch (colorSeed) {
         case 0: shiftWidget = _buildPeachShift(displayText); break;
         case 1: shiftWidget = _buildYellowShift(displayText); break;
         case 2: shiftWidget = _buildMintShift(displayText); break;
         case 3: shiftWidget = _buildWhiteShift(displayText); break;
         default: shiftWidget = _buildPeachShift(displayText); break;
       }
    }
    
    return InkWell(
      onTap: () async {
        controller.selectedEmployee = emp;
        await showShiftListSheet(context);
        controller.selectedEmployee = null;
      },
      child: Container(
        padding: EdgeInsets.all(4.h),
        decoration: const BoxDecoration(
          color: ColorUtils.textWhite,
          border: Border(
            right: BorderSide(color: ColorUtils.platinum, width: 0.8),
          ),
        ),
        child: shiftWidget,
      ),
    );
  }

  Widget _buildPeachShift(String text) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 4.h, vertical: 8.h),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFFAE7CD), // Peach
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          color: ColorUtils.workEntryHead,
          fontSize: 11.h,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildYellowShift(String text) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 4.h, vertical: 8.h),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFFCF1CE), // Yellow
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          color: ColorUtils.workEntryHead,
          fontSize: 11.h,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildMintShift(String text) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 4.h, vertical: 8.h),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFE4F3E8), // Mint
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          color: ColorUtils.workEntryHead,
          fontSize: 11.h,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDarkGreyShift(String text) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 4.h, vertical: 8.h),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFF696464),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          color: ColorUtils.textWhite,
          fontSize: 11.h,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildWhiteShift(String text) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 4.h, vertical: 8.h),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          color: ColorUtils.workEntryHead,
          fontSize: 11.h,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildEmptyAddShift(BuildContext context) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 4.h, vertical: 8.h),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFF6F8FE),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Container(
        width: 21.h,
        height: 21.h,
        decoration: const BoxDecoration(
          color: Color(0xFFD8D8FF),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(Icons.add, color: ColorUtils.secondaryBlue, size: 16.h),
        ),
      ),
    );
  }

  Widget _buildOffDayShift() {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 4.h, vertical: 8.h),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFF2EEED),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/shift_scheduler/off_ring.png',
            width: 10.h,
            height: 10.h,
          ),
          SizedBox(width: 6.h),
          Text(
            'Off Day',
            style: GoogleFonts.inter(
              color: ColorUtils.workEntryHead,
              fontSize: 11.h,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
