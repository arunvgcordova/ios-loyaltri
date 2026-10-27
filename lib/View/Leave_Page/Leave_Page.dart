
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loyaltri_minimal/View/CWidgets/app_bar.dart';
import 'package:loyaltri_minimal/View/Home_Page/home_widgets/calender_chevron.dart';
import 'package:loyaltri_minimal/View/Leave_Page/leave_widgets/leave_detail_bottomSheet.dart';
import 'package:loyaltri_minimal/View/Leave_Page/leave_widgets/leave_info_card.dart';
import 'package:loyaltri_minimal/View/Leave_Page/leave_widgets/leave_row.dart';
import 'package:loyaltri_minimal/View/Leave_Page/leave_widgets/teave_tab_view.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';
import 'package:loyaltri_minimal/services/ui_model_services/leave_tab_model.dart';
import '../../controller/appliedLeaveList.dart';
import '../../controller/leaveSummary.dart';
import '../../controller/leaveTypeController.dart';
import '../../controller/userAuthentication.dart';
import '../../models/leave_list_api_model.dart';
import '../../models/leave_summary_model.dart';
import '../../services/connectivity_service.dart';
import '../../utils/color_utils.dart';
import '../CWidgets/error_dialog.dart';
import '../CWidgets/loyaltri_blue_text_button.dart';
import 'leave_widgets/leave_type_bottomSheet.dart';

class LeavePage extends StatefulWidget {
  const LeavePage({super.key});

  @override
  State<LeavePage> createState() => _LeavePageState();
}

class _LeavePageState extends State<LeavePage> {
  AppliedLeaveList appliedLeaveList = Get.find<AppliedLeaveList>();
  UserAuthController userAuthController = Get.find<UserAuthController>();
  LeaveSummaryController _leaveSummaryController = Get.find<LeaveSummaryController>();
  LeaveTypeController _leaveTypeController = Get.find<LeaveTypeController>();
  int currentValue = 10;
  ValueNotifier<int> currentTab = ValueNotifier(0);

  List<String> monthString = List.generate(21, (index) {
    DateTime currentDate = DateTime.now();

    // Adjust the month for each iteration
    DateTime targetDate =
    DateTime(currentDate.year, currentDate.month - 10 + index, 1);

    // Format the date using DateFormat
    String formattedDate = DateFormat.yMMM().format(targetDate);

    return formattedDate;
  });

  @override
  void initState() {
    leaveApi();
    super.initState();
  }

  Future<void> leaveApi() async {
    bool connection = await ConnectivityService().check();
    if(!connection) {
      await ErrorDialog().internetWarn(
        context: context,
        title: "No Internet Connection",
        subTitle: "Please check if your connection is stable.",
        onPressed: () {
          Navigator.of(context).pop();
          leaveApi();
        },
      );
    } else {
      context.loaderOverlay.show();
      DateTime parsedDateTime = DateFormat.yMMM().parse(monthString[currentValue]);
      String formatted = DateFormat('yyyy-MM').format(parsedDateTime);
      await appliedLeaveList.fetchLeaveList(monthYr: formatted);
      await _leaveSummaryController.fetchLeaveSummary(empId: userAuthController.userData.value.userData?.employeeId ?? '--', monthYr: formatted);
      await _leaveTypeController.fetchLeaveType(
          compId: Get.find<UserProfileController>().userData.value.result.companyId?.toString() ?? '',
          empId: userAuthController.userData.value.userData?.employeeId.toString() ?? '--',
        monthYear: formatted
      );
      if(!mounted) return;
      context.loaderOverlay.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorUtils.workEntryHead,
        extendBody: true,
        body: Padding(
          padding: const EdgeInsets.only(top: 8).w,
          child: Container(
            width: ScreenUtil().screenWidth,
            height: ScreenUtil().screenHeight,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  const CustomAppBar(
                      title: "Leave",
                      isActionVisible: true,
                    image: "assets/images/leave-calendar3d.webp",
                  ),
                  RefreshIndicator(
                    onRefresh: () async {
                      await leaveApi();
                    },
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15).w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Leave Summary",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp,
                                    color: ColorUtils.textWhite.withOpacity(0.6),
                                  ),
                                ),
                                SizedBox(
                                  width: 150.w,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          if (currentValue != 0) {
                                            setState(() => currentValue = currentValue - 1);
                                            DateTime parsedDateTime = DateFormat.yMMM().parse(monthString[currentValue]);
                                            String formatted = DateFormat('yyyy-MM').format(parsedDateTime);
                                            await appliedLeaveList.fetchLeaveList(monthYr: formatted);
                                            await _leaveSummaryController.fetchLeaveSummary(empId: userAuthController.userData.value.userData?.employeeId ?? '--', monthYr: formatted);
                                            await _leaveTypeController.fetchLeaveType(
                                                compId: Get.find<UserProfileController>().userData.value.result.companyId?.toString() ?? '',
                                                empId: userAuthController.userData.value.userData?.employeeId.toString() ?? '--',
                                                monthYear: formatted
                                            );
                                            // await appliedLeaveList.fetchDataPerMonth(selectedData: parsedDateTime);
                                          }
                                        },
                                        child: const ChevronIconLeft(chevronIcon: Icons.arrow_back_ios),
                                      ),
                                      FittedBox(
                                        child: Text(
                                          monthString[currentValue], // Month and year text
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12.sp,
                                            color: ColorUtils.textWhite,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          if (currentValue != (monthString.length - 1)) {
                                            setState(() => currentValue = currentValue + 1);
                                            DateTime parsedDateTime = DateFormat.yMMM().parse(monthString[currentValue]);
                                            String formatted = DateFormat('yyyy-MM').format(parsedDateTime);
                                            await appliedLeaveList.fetchLeaveList(monthYr: formatted);
                                            await _leaveSummaryController.fetchLeaveSummary(empId: userAuthController.userData.value.userData?.employeeId ?? '--', monthYr: formatted);
                                            await _leaveTypeController.fetchLeaveType(
                                                compId: Get.find<UserProfileController>().userData.value.result.companyId?.toString() ?? '',
                                                empId: userAuthController.userData.value.userData?.employeeId.toString() ?? '--',
                                                monthYear: formatted
                                            );
                                            // await appliedLeaveList.fetchDataPerMonth(selectedData: parsedDateTime);
                                          }
                                        },
                                        child: const ChevronIconRight(chevronIcon: Icons.arrow_forward_ios),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10).w,
                            child: GetX<LeaveSummaryController>(
                              builder: (LeaveSummaryController controller) {
                                List<Summary> leaveSummary = controller.leaveSummary.value.result;
                                // List<Summary> leaveSummary = [
                                //   const Summary(leaveCount: "4", leaveTaken: "5", leaveBalance: "4", leaveTypeId: "1", leaveType: "casualcasualcasualcasualcasualcasual", colourCode: "#C20000"),
                                //   const Summary(leaveCount:---punch type error---- "4", leaveTaken: "5", leaveBalance: "4", leaveTypeId: "1", leaveType: "casual", colourCode: "#C20000"),
                                //   const Summary(leaveCount: "4", leaveTaken: "5", leaveBalance: "4", leaveTypeId: "1", leaveType: "casual", colourCode: "#C20000"),
                                //   const Summary(leaveCount: "4", leaveTaken: "5", leaveBalance: "4", leaveTypeId: "1", leaveType: "casual", colourCode: "#C20000"),
                                //   const Summary(leaveCount: "4", leaveTaken: "5", leaveBalance: "4", leaveTypeId: "1", leaveType: "casual", colourCode: "#C20000"),
                                // ];
                                return Container(
                                  width: ScreenUtil().screenWidth,
                                  height: 180.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14).w,
                                    color: ColorUtils.backgroundBlack,
                                  ),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10, left: 10, bottom: 10).w,
                                        child: Container(
                                          width: ScreenUtil().screenWidth * 0.45,
                                          child: Column(
                                            // mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Leave Balance",
                                                style: GoogleFonts.poppins(
                                                  color: ColorUtils.textWhite.withOpacity(0.5),
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                              // Padding(
                                              //   padding: const EdgeInsets.only(bottom: 5).w,
                                              //   child: Text(
                                              //     "${controller.totalLeave.value} ${controller.totalLeave.value <= 1 ? 'Leave' : 'Leaves'}",
                                              //     style: GoogleFonts.poppins(
                                              //       color: ColorUtils.textWhite,
                                              //       fontWeight: FontWeight.w700,
                                              //       fontSize: 20.sp,
                                              //     ),
                                              //   ),
                                              // ),
                                              SizedBox(height: 10.h),
                                              if(controller.dataLoaded.value)
                                                Container(
                                                  width: 200.w,
                                                  height: 105.w,
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        for(int i = 0; i < leaveSummary.length; i++)
                                                          if(leaveSummary[i].leaveBalance.isNotEmpty)
                                                            LeaveRow(
                                                              colors: [
                                                                Color(int.parse('0xff${leaveSummary[i].colourCode.replaceFirst('#', '')}')),
                                                                Color(int.parse('0xff${leaveSummary[i].colourCode.replaceFirst('#', '')}')).withValues(alpha: 0.5),
                                                              ],
                                                              title: leaveSummary[i].leaveType,
                                                              count: num.tryParse(leaveSummary[i].leaveBalance) ?? 0,
                                                              hideBalance: leaveSummary[i].hideLeaveBalance,
                                                            ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      if(controller.dataLoaded.value)
                                        AspectRatio(
                                          aspectRatio: 0.9.w,
                                          child: RotatedBox(
                                            quarterTurns: -1,
                                            child: PieChart(
                                              PieChartData(
                                                centerSpaceRadius: 30.0.w,
                                                sections: [
                                                  for(int i = 0; i < leaveSummary.length; i++)
                                                    if(leaveSummary[i].leaveCount.isNotEmpty)
                                                      PieChartSectionData(
                                                        value: double.tryParse(leaveSummary[i].leaveCount),
                                                        radius: 25.w,
                                                        title: '',
                                                        gradient: LinearGradient(
                                                          colors: [
                                                            Color(int.parse('0xff${leaveSummary[i].colourCode.replaceFirst('#', '')}')),
                                                            Color(int.parse('0xff${leaveSummary[i].colourCode.replaceFirst('#', '')}')).withOpacity(0.5),
                                                          ],
                                                        ),
                                                      ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15).w,
                            child: Row(
                              children: [
                                Text(
                                  "Leave Request Info",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp,
                                    color: ColorUtils.textWhite.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10).w,
                            child: ValueListenableBuilder<int>(
                              valueListenable: currentTab,
                              builder: (BuildContext context, int tabIndex, Widget? child) {
                                return LeaveTabView(
                                  selectedTab: tabIndex,
                                  onTabClick: (int clickedIndex) {
                                    currentTab.value = clickedIndex;
                                  },
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            width: ScreenUtil().screenWidth,
                            height: ScreenUtil().screenHeight * 0.5,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 2, right: 2, top: 10).w,
                              child: GetX<AppliedLeaveList>(
                                builder: (AppliedLeaveList controller) {
                                  List<AppliedLeave> approvedLeaveList = controller.approvedLeaveList.value;
                                  List<AppliedLeave> pendingLeaveList = controller.pendingLeaveList.value;
                                  List<AppliedLeave> rejectedLeaveList = controller.rejectedLeaveList.value;
                                  if(controller.isLoading.value) {
                                    context.loaderOverlay.show();
                                  } else {
                                    context.loaderOverlay.hide();
                                  }
                                  return ValueListenableBuilder(
                                    valueListenable: currentTab,
                                    builder: (BuildContext context, value, Widget? child) {
                                      if (value == 0) {
                                        if(approvedLeaveList.isNotEmpty) {
                                          return ListView.builder(
                                            itemCount: approvedLeaveList.length,
                                            padding: const EdgeInsets.only(bottom: 150).w,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding: const EdgeInsets.all(8.0).w,
                                                child: ValueListenableBuilder(
                                                  valueListenable: currentTab,
                                                  builder: (BuildContext context, value, Widget? child) {
                                                    return LeaveInfoCard(
                                                      // color: leaveTabItem[value].color,
                                                      appliedLeave: approvedLeaveList[index],
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                          );
                                        } else {
                                          return Padding(
                                            padding: EdgeInsets.symmetric(vertical: 150.h),
                                            child: Align(
                                              alignment: Alignment.topCenter,
                                              child: Text(
                                                "No Data Found",
                                                style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                                              ),
                                            ),
                                          );
                                        }
                                      } else if (value == 1) {
                                        if(pendingLeaveList.isNotEmpty) {
                                          return ListView.builder(
                                            itemCount: pendingLeaveList.length,
                                            padding: const EdgeInsets.only(bottom: 150).w,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding: const EdgeInsets.all(8.0).w,
                                                child: ValueListenableBuilder(
                                                  valueListenable: currentTab,
                                                  builder: (BuildContext context, value, Widget? child) {
                                                    return LeaveInfoCard(
                                                      // color: leaveTabItem[value].color,
                                                      appliedLeave: pendingLeaveList[index],
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                          );
                                        } else {
                                          return Padding(
                                            padding: EdgeInsets.symmetric(vertical: 150.h),
                                            child: Align(
                                              alignment: Alignment.topCenter,
                                              child: Text(
                                                "No Data Found",
                                                style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                                              ),
                                            ),
                                          );
                                        }
                                      } else if (value == 2) {
                                        if(rejectedLeaveList.isNotEmpty) {
                                          return ListView.builder(
                                            itemCount: rejectedLeaveList.length,
                                            padding: const EdgeInsets.only(bottom: 150).w,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding: const EdgeInsets.all(8.0).w,
                                                child: ValueListenableBuilder(
                                                  valueListenable: currentTab,
                                                  builder: (BuildContext context, value, Widget? child) {
                                                    return LeaveInfoCard(
                                                      // color: leaveTabItem[value].color,
                                                      appliedLeave: rejectedLeaveList[index],
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                          );
                                        } else {
                                          return Padding(
                                            padding: EdgeInsets.symmetric(vertical: 150.h),
                                            child: Align(
                                              alignment: Alignment.topCenter,
                                              child: Text(
                                                "No Data Found",
                                                style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                                              ),
                                            ),
                                          );
                                        }
                                      } else {
                                        return Container();
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          width: ScreenUtil().screenWidth,
          height: 70.w,
          decoration: blueTextButtonDecoration,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20).w,
                child: GestureDetector(
                  onTap: () async {
                    DateTime parsedDateTime = DateFormat.yMMM().parse(monthString[currentValue]);
                    String formatted = DateFormat('yyyy-MM').format(parsedDateTime);
                    await leaveTypeBottomSheet(
                      context: context,
                      isHomePage: false,
                      date: formatted,
                      reload: () async {
                        currentTab.value = 1;
                        await leaveApi();
                      },
                    );
                  },
                  child: const LoyaltriBlueIconTextButton(
                    text: 'Request a leave',
                    icon: Icons.add,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
