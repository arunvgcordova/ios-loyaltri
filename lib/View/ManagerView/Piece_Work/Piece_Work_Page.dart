import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
import 'package:loyaltri_minimal/View/ManagerView/Piece_Work/piece_work_controller/piece_work_controller.dart';
import 'package:loyaltri_minimal/View/ManagerView/Piece_Work/piece_work_widgets/calendar_sheet.dart';
import 'package:loyaltri_minimal/View/ManagerView/Piece_Work/piece_work_widgets/day_switch_view.dart';
import 'package:loyaltri_minimal/View/ManagerView/Piece_Work/piece_work_widgets/list_loading_shimmer.dart';
import 'package:loyaltri_minimal/View/ManagerView/Piece_Work/piece_work_widgets/piece_work_appBar.dart';
import 'package:loyaltri_minimal/View/ManagerView/Piece_Work/piece_work_widgets/piece_work_card.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';
import '../../../controller/calendarEventsController.dart';
import '../Manager_Request/request_wigets_manager/searchAndFilter.dart';

class PieceWorkPage extends StatefulWidget {
  const PieceWorkPage({super.key});

  @override
  State<PieceWorkPage> createState() => _PieceWorkPageState();
}

class _PieceWorkPageState extends State<PieceWorkPage> {

  @override
  void initState() {
    loadCalendar();
    super.initState();
  }

  Future<void> loadCalendar() async {
    Get.find<PieceWorkController>().listLoading.value = true;
    await Get.find<CalendarEventController>().fetchCalendarEventsForLeave();
    PieceWorkController pieceWorkController = Get.find<PieceWorkController>();
    String formated = DateFormat('yyyy/MM/d').format(pieceWorkController.dateList.value[pieceWorkController.currentDateIndex.value]);
    Get.find<PieceWorkController>().searchText.value = '';
    await initialize(selectedDate: formated);
    Get.find<PieceWorkController>().listLoading.value = false;
  }

  Future<void> initialize({required String selectedDate}) async {
    // context.loaderOverlay.show();
    await Get.find<PieceWorkController>().fetchPieceWorkList(selectedDate);
    // context.loaderOverlay.hide();
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
                      final result = await showModalBottomSheet(
                          context: context,
                          barrierColor: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                          backgroundColor: ColorUtils.textWhite,
                          isDismissible: false,
                          isScrollControlled: true,
                          builder: (context) {
                            return PieceWorkCalendarSheet();
                          },
                      );
                      if(result != null && result is DateTime) {
                        String selectedDate = result.toString().split(' ').first;
                        HapticFeedback.lightImpact();
                        int index = Get.find<PieceWorkController>().dateList.value.indexWhere((date) => date.toString().split(' ').first == selectedDate);
                        Get.find<PieceWorkController>().currentDateIndex.value = index;
                        Get.find<PieceWorkController>().isChangedFromMonth.value = true;
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18.h),
                      child: PieceWorkAppBar(),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  DaySwitchView(
                    onMonthChanged: (int? selectedIndex) async {
                      if (selectedIndex != null) {
                        HapticFeedback.lightImpact();
                        DateTime dateTime =
                        Get.find<PieceWorkController>()
                            .dateList
                            .value[selectedIndex];
                        int index = Get.find<PieceWorkController>()
                            .dateList
                            .value
                            .indexWhere((date) => date == dateTime);
                        Get.find<PieceWorkController>()
                            .currentDateIndex
                            .value = index;
                        String formated = DateFormat(
                          'yyyy/MM/d',
                        ).format(dateTime);
                        await initialize(selectedDate: formated);
                      }
                    },
                  ),
                  SizedBox(height: 12.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.h),
                    child: SearchAndFilter(
                      filterPage: FilterPage.pieceWork,
                      color: ColorUtils.paleLavenderMist,
                      result: (value) {
                        Get.find<PieceWorkController>().searchText.value = value;
                        Get.find<PieceWorkController>().filterPieceWorkListByName(value);
                      },
                      showFilter: false,
                      isDarkMode: false,
                    ),
                  ),
                  SizedBox(height: 13.h),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        PieceWorkController pieceWorkController = Get.find<PieceWorkController>();
                        String formated = DateFormat('yyyy/MM/d').format(pieceWorkController.dateList.value[pieceWorkController.currentDateIndex.value]);

                        await initialize(selectedDate: formated);
                      },
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: GetX<PieceWorkController>(
                          builder: (PieceWorkController controller) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if(controller.listLoading.value)
                                  for(int index = 0; index < 10; index++)
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 15.h,
                                          ),
                                          child: ListLoadingShimmer(),
                                        ),
                                        SizedBox(height: 13.h)
                                      ],
                                    )
                                else if(controller.pieceWorkList.value.isEmpty && !controller.listLoading.value)
                                  RefreshIndicator(
                                  onRefresh: () async {
                                    PieceWorkController pieceWorkController = Get.find<PieceWorkController>();
                                    String formated = DateFormat('yyyy/MM/d').format(pieceWorkController.dateList.value[pieceWorkController.currentDateIndex.value]);

                                    await initialize(selectedDate: formated);
                                  },
                                  child: SingleChildScrollView(
                                    physics: AlwaysScrollableScrollPhysics(),
                                    child: SizedBox(
                                      height: ScreenUtil().screenHeight * 0.6,
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            left: 50.h,
                                            right: 50.h,
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
                                                  "assets/images/manager_view/piece_work_icon.png",
                                                  height: 37.h,
                                                  fit: BoxFit.fitHeight,
                                                ),
                                              ),
                                              SizedBox(height: 15.h),
                                              Text(
                                                "No Piece Work Records Found",
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.dmSans(
                                                  fontWeight: FontWeight.w600,
                                                  color: ColorUtils.workEntryHead,
                                                  fontSize: 15.h,
                                                ),
                                              ),
                                              SizedBox(height: 10.h),
                                              Text(
                                                "Piece Work data is not available for the selected date.",
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
                                else
                                  for(int index = 0; index < controller.pieceWorkList.value.length; index++)
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 15.h,
                                          ),
                                          child: PieceWorkCard(employeePiece: controller.pieceWorkList.value[index]),

                                        ),
                                        SizedBox(height: 13.h)
                                      ],
                                    ),
                              ],
                            );
                          }
                        ),
                      ),
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
}
