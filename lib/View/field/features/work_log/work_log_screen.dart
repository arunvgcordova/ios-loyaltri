import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/View/field/features/tracking/tracker_controller.dart';
import 'package:loyaltri_minimal/View/field/features/work_log/controller/work_log_controller.dart';
import 'package:loyaltri_minimal/View/field/core/utils.dart';
import 'package:loyaltri_minimal/View/field/features/widgets/app_bar.dart';
import 'package:loyaltri_minimal/View/field/features/widgets/calender.dart';
import 'package:loyaltri_minimal/View/field/features/add_work_log/add_work_screen.dart';
import 'package:loyaltri_minimal/View/field/features/work_details/work_details_screen.dart';
import 'package:loyaltri_minimal/View/field/features/work_log/widget/work_log_card.dart';
import 'package:loyaltri_minimal/controller/userAuthentication.dart';
import '../../core/colour_utils.dart';

class WorkLogScreen extends StatefulWidget {
  const WorkLogScreen({super.key});

  @override
  State<WorkLogScreen> createState() => _WorkLogScreenState();
}

class _WorkLogScreenState extends State<WorkLogScreen> {

  String _searchQuery = '';
  final _searchController = TextEditingController();

  late WorkLogController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller = Get.put(WorkLogController());
  }

  @override
  void dispose() {
    Get.delete<WorkLogController>();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller.fetchWorkLogList(status: "", search: _searchController.text);
    return Scaffold(
      backgroundColor: ColourUtils.background,
      appBar: AppBarWithAddWidget(
        title: 'Work Log',
        onAddTap: () async {
          final trackingCtrl = Get.isRegistered<TrackingController>()
                  ? Get.find<TrackingController>()
                  : null;
              final empId = Get.find<UserAuthController>().userData.value.userData?.employeeId;
              final canWork = trackingCtrl?.companySettings.value?.canStaffCreateWork(empId) ?? true;
              if (!canWork) {
                AttendanceCommonWidgets().showSnackBar(
                  context: context,
                  backgroundColor: Colors.orange,
                  message: "You do not have permission to create work.",
                );
                return;
              }
          bool result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddWorkScreen()),
          );

          if (result == true) {
            controller.fetchWorkLogList(
              status: "",
              search: _searchController.text,
            );
          }
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            // HORIZONTAL CALENDAR SELECTOR
            // _buildCalendarBar(),
            SizedBox(height: 8.h),
            CalenderWidget(
              onDateChanged: (date) {
                controller.selectedDate = date;
                controller.fetchWorkLogList(
                  status: "",
                  search: _searchController.text,
                );
              },
            ),
            SizedBox(height: 12.h),

            // SEARCH BAR
            _buildSearchBar(),
            SizedBox(height: 12.h),

            // COUNTERS SUMMARY TALLY BAR
            Expanded(
              child: GetX<WorkLogController>(
                builder: (controller) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      await controller.fetchWorkLogList(
                        status: "",
                        search: _searchController.text,
                      );
                    },
                    child: controller.isloading.value
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              SizedBox(
                                height: ScreenUtil().screenHeight - 300.h,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            ],
                          )
                        : controller.WorkLogCompletedList.isEmpty &&
                              controller.WorkLogPendingList.isEmpty
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [_buildEmptyState()],
                          )
                        : Column(
                            children: [
                              _buildTallyBar(
                                controller.pendingCount +
                                    controller.completedCount,
                                controller.completedCount,
                                controller.pendingCount,
                              ),
                              SizedBox(height: 16.h),
                              // WORK ITEMS LIST
                              Expanded(
                                child: ListView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                  ),
                                  children: [
                                    // OverDue Section
                                    if (controller
                                        .overdueList
                                        .isNotEmpty) ...[
                                      _buildSectionHeader(
                                        "Overdue",
                                        controller.overdueCount.toString(),
                                      ),
                                      ...controller.overdueList.map(
                                        (item) => WorkLogCard(
                                          context: context,
                                          workId: item.id.toString(),
                                          workTitle: item.title ?? "",
                                          workTypeName:
                                              item.workTypeDetail?.name ?? "",
                                          customerName:
                                              item.customerDetail?.name ?? "",
                                          locationName: item.location ?? "",
                                          startTime: formatTime(
                                            controller.getWorkStartTimeByDate(
                                              item.instances,
                                              controller.selectedDate,
                                            ),
                                          ),
                                          scheduledDate: formatDate(
                                            controller.getWorkDateByDate(
                                              item.instances,
                                              controller.selectedDate,
                                            ),
                                          ),
                                          lat: item.latLng?.lat ?? 0.0,
                                          lng: item.latLng?.lng ?? 0.0,
                                          customerNumber:
                                              item.customerDetail?.phone ?? "",
                                          priority: item.priority ?? "",
                                          status: controller
                                              .getWorkStatusByDate(
                                                item.instances,
                                                controller.selectedDate,
                                              ),
                                          type: "Overdue",
                                        ),
                                      ),
                                      SizedBox(height: 16.h),
                                    ],

                                    // Pending Section
                                    if (controller
                                        .WorkLogPendingList
                                        .isNotEmpty) ...[
                                      _buildSectionHeader(
                                        "Pending",
                                        controller.pendingCount.toString(),
                                      ),
                                      ...controller.WorkLogPendingList.map(
                                        (item) => WorkLogCard(
                                          context: context,
                                          workId: item.id.toString(),
                                          workTitle: item.title ?? "",
                                          workTypeName:
                                              item.workTypeDetail?.name ?? "",
                                          customerName:
                                              item.customerDetail?.name ?? "",
                                          locationName: item.location ?? "",
                                          startTime: formatTime(
                                            controller.getWorkStartTimeByDate(
                                              item.instances,
                                              controller.selectedDate,
                                            ),
                                          ),
                                          scheduledDate: formatDate(
                                            controller.getWorkDateByDate(
                                              item.instances,
                                              controller.selectedDate,
                                            ),
                                          ),
                                          lat: item.latLng?.lat ?? 0.0,
                                          lng: item.latLng?.lng ?? 0.0,
                                          customerNumber:
                                              item.customerDetail?.phone ?? "",
                                          priority: item.priority ?? "",
                                          status: controller
                                              .getWorkStatusByDate(
                                                item.instances,
                                                controller.selectedDate,
                                              ),
                                              type: "Pending",
                                        ),
                                      ),
                                      SizedBox(height: 16.h),
                                    ],

                                    // Completed Section
                                    if (controller
                                        .WorkLogCompletedList
                                        .isNotEmpty) ...[
                                      _buildSectionHeader(
                                        "Done",
                                        controller.completedCount.toString(),
                                      ),
                                      ...controller.WorkLogCompletedList.map(
                                        (item) => WorkLogCard(
                                          context: context,
                                          workId: item.id.toString(),
                                          workTitle: item.title ?? "",
                                          workTypeName:
                                              item.workTypeDetail?.name ?? "",
                                          customerName:
                                              item.customerDetail?.name ?? "",
                                          locationName: item.location ?? "",
                                          startTime: formatTime(
                                            controller.getWorkStartTimeByDate(
                                              item.instances,
                                              controller.selectedDate,
                                            ),
                                          ),
                                          scheduledDate: formatDate(
                                            controller.getWorkDateByDate(
                                              item.instances,
                                              controller.selectedDate,
                                            ),
                                          ),
                                          lat: item.latLng?.lat ?? 0.0,
                                          lng: item.latLng?.lng ?? 0.0,
                                          customerNumber:
                                              item.customerDetail?.phone ?? "",
                                          priority: item.priority ?? "",
                                          status: controller
                                              .getWorkStatusByDate(
                                                item.instances,
                                                controller.selectedDate,
                                              ),
                                          type: "Done",
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String count) {
    return Row(
      children: [
        svgWidget(
          height: 20.h,
          width: 20.h,
          icon: 'clock',
          color:title == 'Overdue'? ColourUtils.overdue :title == 'Pending'
              ? ColourUtils.pending
              : ColourUtils.fontColour5,
        ),
        SizedBox(width: 10.h),
        Text(
          title,
          style: GoogleFonts.inter(
            color: ColourUtils.textMain,
            fontSize: 16.h,
            fontWeight: FontWeight.w500,
          ),
        ),
        Spacer(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.h),
          child: Text(
            count,
            style: GoogleFonts.inter(
              color:title == 'Overdue'? ColourUtils.overdue : title == 'Pending'
                  ? ColourUtils.pending
                  : ColourUtils.fontColour5,
              fontSize: 16.h,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
    // Padding(
    //   padding: EdgeInsets.symmetric(vertical: 8.h),
    //   child: Text(
    //     title,
    //     style: TextStyle(
    //       fontSize: 16.sp,
    //       fontWeight: FontWeight.bold,
    //     ),
    //   ),
    // );
  }

  Widget _buildTallyBar(int total, int completed, int overdue) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTallyBox(
            'Pending',
            overdue.toString(),
            ColourUtils.pending,
            ColourUtils.pendingBg,
          ),
          SizedBox(width: 8.w),
          _buildTallyBox(
            'Done',
            completed.toString(),
            ColourUtils.fontColour5,
            ColourUtils.completedBg,
          ),
          SizedBox(width: 8.w),
          _buildTallyBox(
            'Total',
            total.toString(),
            ColourUtils.textWhite,
            ColourUtils.bgColour10,
          ),
        ],
      ),
    );
  }

  Widget _buildTallyBox(
    String label,
    String value,
    Color color,
    Color bgColor,
  ) {
    return Expanded(
      child: Container(
        height: 76.h,

        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12.h),
          border: Border.all(color: ColourUtils.borderColour, width: 1.w),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: GoogleFonts.inter(
                color: color,
                fontSize: 18.h,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.inter(
                color: color,
                fontSize: 12.h,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 56.h,
              child: TextFormField(
                controller: _searchController,
                onChanged: (val) => setState(() => _searchQuery = val),
                style: GoogleFonts.inter(
                  color: ColourUtils.textMain,
                  fontSize: 14.h,
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  hintText: 'Search work',
                  hintStyle: GoogleFonts.inter(
                    color: ColourUtils.textMuted,
                    fontSize: 14.h,
                    fontWeight: FontWeight.w400,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: ColourUtils.textMuted,
                    size: 20.h,
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.clear,
                            color: ColourUtils.textMuted,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: ColourUtils.textWhite.withValues(alpha: 0.05),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.h),
                    borderSide: BorderSide(
                      color: ColourUtils.borderColour,
                      width: 1.w,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.h),
                    borderSide: const BorderSide(
                      color: ColourUtils.primary,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // SizedBox(width: 10.w),
          // Container(
          //   height: 56.w,
          //   width: 56.w,
          //   decoration: BoxDecoration(
          //     color: ColourUtils.textWhite.withValues(alpha: 0.05),
          //     borderRadius: BorderRadius.circular(12.h),
          //     border: Border.all(color: ColourUtils.borderColour, width: 1.w),
          //   ),
          //   child: Center(
          //     child: svgWidget(height: 20.h, width: 20.h, icon: 'filter'),
          //   ),
          // ),
        ],
      ),
    );
  }

  

  String formatDate(String? date) {
    if (date == null || date.trim().isEmpty) {
      return '';
    }

    try {
      final parsedDate = DateFormat('yyyy-MM-dd').parse(date);
      return DateFormat('dd MMM yyyy').format(parsedDate);
    } catch (e) {
      return '';
    }
  }

  String formatTime(String? time) {
    if (time == null || time.trim().isEmpty) {
      return '';
    }

    try {
      final parsedTime = DateFormat('HH:mm:ss').parse(time);
      return DateFormat('h:mm a').format(parsedTime);
    } catch (e) {
      return '';
    }
  }

  Widget _buildEmptyState() {
    return SizedBox(
      height: ScreenUtil().screenHeight - 300.h,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              color: ColourUtils.textMuted,
              size: 48.h,
            ),
            SizedBox(height: 12.h),
            Text(
              'No work logs found',
              style: GoogleFonts.inter(
                color: ColourUtils.textMuted,
                fontSize: 14.h,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WorkTypeContainerWidget extends StatelessWidget {
  const WorkTypeContainerWidget({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        height: 30.h,
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
          color: ColourUtils.primary.withOpacity(0.12),
          borderRadius: BorderRadius.circular(8.h),
        ),
        child: Center(
          child: Text(
            // 'Maintenance',
            text,
            style: GoogleFonts.inter(
              color: ColourUtils.textWhite,
              fontSize: 12.h,
              fontWeight: FontWeight.w400,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

class LocationTextWidget extends StatelessWidget {
  const LocationTextWidget({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        svgWidget(
          height: 20.h,
          width: 20.h,
          icon: 'gps',
          color: ColourUtils.textWhite,
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            // 'Connaught Place, New Delhi dksaok odaosp sdiaospopk',
            text,
            style: GoogleFonts.inter(
              color: ColourUtils.textWhite,
              fontSize: 14.h,
              fontWeight: FontWeight.w400,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class StoreNamewidget extends StatelessWidget {
  const StoreNamewidget({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        svgWidget(
          height: 20.h,
          width: 20.h,
          icon: 'store',
          color: ColourUtils.textWhite,
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            // 'Sharma Electronics idjiaso jsjdias jjdsajas ijdijo',
            text,
            style: GoogleFonts.inter(
              color: ColourUtils.textWhite,
              fontSize: 14.h,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class RoundFillButton extends StatelessWidget {
  const RoundFillButton({
    super.key,
    required this.function,
    required this.icon,
  });

  final Function() function;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: Container(
        height: 44.h,
        width: 44.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ColourUtils.bgColour8,
        ),
        child: Center(
          child: svgWidget(height: 20.h, width: 20.h, icon: icon),
        ),
      ),
    );
  }
}
