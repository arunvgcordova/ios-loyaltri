
import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/CWidgets/cwidgets.dart';
import 'package:loyaltri_minimal/View/CWidgets/error_dialog.dart';
import 'package:loyaltri_minimal/View/Home_Page/home_widgets/actionRowHome.dart';
import 'package:loyaltri_minimal/View/Home_Page/home_widgets/appBarHeader.dart';
import 'package:loyaltri_minimal/View/Home_Page/home_widgets/bottomSheet_chooseCheckType.dart';
import 'package:loyaltri_minimal/View/Home_Page/home_widgets/flexibleSpaceBar.dart';
import 'package:loyaltri_minimal/View/Home_Page/home_widgets/loyaltri_calender.dart';
import 'package:loyaltri_minimal/View/Home_Page/home_widgets/notificationIcon.dart';
import 'package:loyaltri_minimal/View/Home_Page/home_widgets/timerColumnAppBar.dart';
import 'package:loyaltri_minimal/View/Home_Page/home_widgets/workEntryView_Home.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/View/NotificationScreen/NotificationScreen.dart';
import 'package:loyaltri_minimal/View/field/features/work_log/work_log_screen.dart';
import 'package:loyaltri_minimal/controller/calendarEventsController.dart';
import 'package:loyaltri_minimal/controller/punchTypeController.dart';
import 'package:loyaltri_minimal/controller/ui_controller/home_controller.dart';
import 'package:loyaltri_minimal/controller/ui_controller/page_controller.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';
import '../../controller/WorkEntryListController.dart';
import '../../controller/attSummaryController.dart';
import '../../controller/attendanceListController.dart';
import '../../controller/attendanceUploadController.dart';
import '../../controller/checkInController.dart';
import '../../controller/payrollController.dart';
import '../../controller/userAuthentication.dart';
import '../../controller/work_expence_controller.dart';
import '../../utils/color_utils.dart';
import '../Excuse_Page/Excuse_Page.dart';
import '../Leave_Page/Leave_Page.dart';
import '../ManagerView/Employee_Leave/Employee_Leave_Page.dart';
import '../ManagerView/Employee_Leave/employee_leave_controller/employee_leave_controller.dart';
import '../ManagerView/Manager_Home/home_widgets/task_view.dart';
import '../ManagerView/Manager_Request/Manager_Reqest_Page.dart';
import 'home_widgets/checkButtonHome.dart';
import 'home_widgets/updation_dialogue.dart';
import 'home_widgets/works_dashboard_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  HomeController homeController = Get.find<HomeController>();
  final UserAuthController userAuthController = Get.find<UserAuthController>();
  final UserProfileController userProfileController = Get.find<UserProfileController>();
  final PunchTypeController punchTypeController = Get.find<PunchTypeController>();
  WorkEntryListController workEntryListController = Get.find<WorkEntryListController>();
  CalendarEventController calendarEventController = Get.find<CalendarEventController>();
  CheckInController checkInController = Get.find<CheckInController>();
  AttendanceSummaryController attendanceSummaryController = Get.find<AttendanceSummaryController>();
  AttendanceList attendanceListController = Get.find<AttendanceList>();
  WorkExpenseController workExpenseController = Get.find<WorkExpenseController>();
  PayrollController payrollController = Get.find<PayrollController>();
  ScrollController _scrollController = ScrollController();
  final ValueNotifier _isNotExpanded = ValueNotifier(false);
  ValueNotifier<DateTime> calendarDate = ValueNotifier(DateTime.now());
  // DateTime calendarDate = DateTime.now();
  DateTime dateTime = DateTime.now();
  double expandedHeight = Get.find<CheckInController>().breakTimeDuration.value != "" ? 290.w : 270.w;
  double collapsedHeight = 84.h;

  @override
  void initState() {
    initialize();
    WidgetsBinding.instance.addObserver(this);
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    setupInteractedMessage();
    expandedHeight = checkInController.breakTimeDuration.value != "" ? 290.w : 270.w;
    // Timer.periodic(const Duration(seconds: 10), (timer) {
    //   setState(() {});
    //   timer.cancel();
    // });
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    if(message.data['category'] == 'my_leave') {
      Navigator.of(context).push(
        newSlideNavigation(const LeavePage()),
      );
    } else if(message.data['category'] == 'my_excuse') {
      Navigator.of(context).push(
        newSlideNavigation(const MyExcuse()),
      );
    } else if(message.data['category'] == 'leave') {
      EmployeeLeaveController employeeLeaveController = Get.find<EmployeeLeaveController>();
      employeeLeaveController.resetValues();
      employeeLeaveController.fetchEmployeeLeaveList();
      Navigator.of(context).push(
        newSlideNavigation(const EmployeeLeavePage()),
      );
    } else if(message.data['category'] == 'excuse') {
      Navigator.of(context).push(
        newSlideNavigation(const ManagerRequestPage()),
      );
    } else if(message.data['category'] == 'Feed') {
      Get.find<UserPageController>().currentIndex.value = 2;
    }
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed) {
  //     setState(() {
  //       // Force a rebuild
  //     });
  //   }
  // }

  initialize() async {
    // employeeId = userAuthController.userData.value.userData?.employeeId ?? '';
    // companyId = userProfileController.userData.value.result.companyId?.toString() ?? '';
    // await checkInController.getCheckInData(compId: companyId, empId: employeeId);
    //
    // await homeController.getTimer();
    //
    // await punchTypeController.checkPunchType(empId: employeeId, compId: companyId);
    // await calendarEventController.fetchCalendarData(empId: employeeId, monthYear: DateFormat('yyyy-MM').format(DateTime.now()));
    await homeController.getHomeData(context);
    // if(homeController.dataLoaded.value) {
    //   await homeController.getHomeData();
    // }
    // await homeController.getHomeData();
    // if(companyId != null && employeeId != null) {
    //   if(!userProfileController.dataLoaded.value) {
    //     await userProfileController.fetchUserData(empId: employeeId!);
    //   }
    //   if(!punchTypeController.dataLoaded.value) {
    //     await punchTypeController.checkPunchType(empId: employeeId!, compId: companyId!);
    //   }
    //   if(!checkInController.dataLoaded.value) {
    //     await checkInController.getCheckInData(compId: companyId!, empId: employeeId!);
    //   }
    //   if(!calendarEventController.dataLoaded.value) {
    //     await calendarEventController.fetchCalendarData(empId: employeeId!);
    //   }
    //   if(!workEntryListController.dataLoaded.value) {
    //     await workEntryListController.fetchWorkEntryList(month: dateTime, empId: employeeId!);
    //   }
    //   if(!attendanceListController.dataLoaded.value) {
    //     await attendanceListController.fetchAttendanceList(empId: employeeId!, compId: companyId!);
    //   }
    //   if(!attendanceSummaryController.dataLoaded.value) {
    //     await attendanceSummaryController.getAttendanceSummary(empId: employeeId!, compId: companyId!);
    //   }
    //   if(!workExpenseController.dataLoaded.value) {
    //     await workExpenseController.fetchWorkExpenseList(compId: companyId!, empId: employeeId!);
    //     await workExpenseController.fetchWorkExpenseCategory(compId: companyId!);
    //   }
    //   if(!payrollController.dataLoaded.value) {
    //     await payrollController.fetchPayrollData(compId: companyId!, empId: employeeId!, dateTime: dateTime);
    //   }
    // }
  }

  Future<void> getWorkList() async => await homeController.getWorkList();

  Future<void> getMonthData(DateTime date) async {
    AttendanceCommonWidgets().printF("-----change month-------$date");
    await calendarEventController.fetchCalendarData(empId: userAuthController.userData.value.userData?.employeeId ?? '--', monthYear: DateFormat('yyyy-MM').format(calendarDate.value));
  }

  void _scrollListener() {
    _isNotExpanded.value = _scrollController.hasClients && _scrollController.offset > 50;

    final direction = _scrollController.position.userScrollDirection;
    final offset = _scrollController.offset;

    final collapseRange = expandedHeight - collapsedHeight;
    final threshold = collapseRange * 0.25;

    // 🟢 SCROLL UP → COLLAPSE
    if (direction == ScrollDirection.reverse &&
        offset > threshold &&
        offset < collapseRange) {
      _snapTo(collapseRange);
    }

    // 🔵 SCROLL DOWN → EXPAND
    if (direction == ScrollDirection.forward &&
        offset < collapseRange - threshold &&
        offset > 0) {
      _snapTo(0);
    }
  }

  bool _isSnapping = false;

  void _snapTo(double offset) {
    if (_isSnapping) return;
    _isSnapping = true;

    _scrollController
        .animateTo(
      offset,
      duration: const Duration(milliseconds: 900),
      curve: Curves.elasticOut,
    )
        .whenComplete(() => _isSnapping = false);
  }

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    //   context.loaderOverlay.show();
    //   await initialize();
    //   context.loaderOverlay.hide();
    // });
    expandedHeight = checkInController.breakTimeDuration.value != "" ? 290.w : 270.w;
    return SafeArea(
      top: false,
      bottom: true,
      left: false,
      right: false,
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            GetX<HomeController>(
              builder: (HomeController controller) {
                // if(controller.isLoading.value) {
                //   context.loaderOverlay.show();
                // } else {
                //   context.loaderOverlay.hide();
                // }
                return RefreshIndicator(
                  onRefresh: () async {
                      String employeeId = Get.find<UserAuthController>().userData.value.userData?.employeeId ?? '';
                      String companyId = Get.find<UserProfileController>().userData.value.result.companyId?.toString() ?? '';
                      DateTime dateTime = DateTime.now();
                      await Get.find<CheckInController>().getCheckInData(compId: companyId, empId: employeeId);
                      await Get.find<HomeController>().getTimer();
                      await Get.find<PunchTypeController>().checkPunchType(empId: employeeId, compId: companyId);
                      bool fieldAccess = Get.find<UserAuthController>().fieldAccess.value;
                      if(fieldAccess) {
                        await Get.find<HomeController>().fetchWorkLogByDate();
                      }
                      await Get.find<CalendarEventController>().fetchCalendarData(empId: employeeId, monthYear: DateFormat('yyyy-MM').format(dateTime));
                      await Get.find<WorkEntryListController>().fetchWorkEntryList(month: dateTime, empId: employeeId);
                      await Get.find<UserProfileController>().fetchAllNotifications();
                  },
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: <Widget>[
                      SliverAppBar(
                        expandedHeight: expandedHeight,
                        collapsedHeight: collapsedHeight,
                        backgroundColor: ColorUtils.secondaryBlue,
                        systemOverlayStyle: systemUiOverlayStyleDark,
                        pinned: true,
                        snap: false,
                        toolbarHeight: 84.h,
                        leadingWidth: 80.w,
                        centerTitle: false,
                        foregroundColor: Colors.black,
                        actions: [
                          ValueListenableBuilder(
                            valueListenable: _isNotExpanded,
                            builder: (BuildContext context, value, Widget? child) {
                              if(controller.punchTime.value == "" || (controller.punchTime.value != "" && !value)) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      newSlideNavigation(const NotificationScreen()),
                                    );
                                  },
                                  child: const NotificationIcon(),
                                );
                              } else if(controller.punchTime.value != "" && value) {
                                return GestureDetector(
                                  onTap: () async {
                                    PunchTypeController punchTypeController = Get.find<PunchTypeController>();
                                    bool isPunchMethodsEmpty = punchTypeController.checkInMethods.value.isEmpty || punchTypeController.checkOutMethods.value.isEmpty;
                                    if(!isPunchMethodsEmpty) {
                                      String? msg = await Get.find<AttendanceUploadController>().checkInGuard();
                                      if(msg == null) {
                                        chooseCheckTypeBottomSheet(
                                          mainContext: context,
                                          isIn: controller.punchTime.value == "" ? true : false,
                                        );
                                      } else {
                                        await HapticFeedback.lightImpact();
                                        String? msg = "${controller.punchTime.value == "" ? 'Check in' : 'Check out'} is not allowed within 3 minutes after ${controller.punchTime.value == "" ? 'checkout' : 'check in'}. Please try again later.";
                                        ErrorDialog().showWarn(
                                            context: context,
                                            title: "Message",
                                            subTitle: msg);
                                      }
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 20).w,
                                    child: const AppBarCheckButtonHome(isChecked: true),
                                    // child: const AppBarBreakButtonHome(isChecked: true),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            },
                          ),
                        ],
                        title: ValueListenableBuilder(
                          valueListenable: _isNotExpanded,
                          builder: (BuildContext context, value, Widget? child) {
                            if(controller.punchTime.value == "" || (controller.punchTime.value != "" && !value)) {
                              return GestureDetector(
                                onTap: () {
                                  Get.find<UserPageController>().currentIndex.value = 4;
                                  // widget.pageIndex!(3);
                                },
                                child: const AppBarHeader(),
                              );
                            } else if(controller.punchTime.value != "" && value) {
                              return TimerColumnAppBar(punchTime: controller.punchTime.value);
                            } else {
                              return Container();
                            }
                          },
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(34),
                              bottomRight: Radius.circular(34),
                            ).w),
                        flexibleSpace: ClipRRect(
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(34),
                              bottomRight: Radius.circular(34))
                              .w,
                          child: FlexibleSpaceBar(
                            background: Container(
                              // height: 309.65.h,
                              // width: 390.w,
                              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    ColorUtils.primaryDarkBlue,
                                    ColorUtils.secondaryBlue,
                                  ], // Replace with your colors
                                ),
                              ),
                              child: FlexibleSpaceBarHome(punchTime: controller.punchTime.value),
                            ),
                          ),
                        ),
                      ),
                      SliverPersistentHeader(
                        pinned: true,
                        floating: false,
                        delegate: _CustomHeaderDelegate(
                          child: HomeActionRow(
                            whichCheck: controller.punchTime.value != "" ? false : true,
                            callBack: getWorkList,
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              GetX<UserAuthController>(
                                builder: (UserAuthController authController) {
                                  if(authController.fieldAccess.value) {
                                    return WorksDashboardWidget(
                                      onViewAllTap: () {
                                        Navigator.of(context).push(
                                          newSlideNavigation(WorkLogScreen()),
                                        ).then((_) {
                                          if (Get.isRegistered<HomeController>()) {
                                            Get.find<HomeController>().fetchWorkLogByDate();
                                          }
                                        });
                                      },
                                    );
                                  } else {
                                    return SizedBox.shrink();
                                  }
                                }
                              ),
                              SizedBox(height: 10.h),
                              Padding(
                                padding: const EdgeInsets.all(8.0).w,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: ColorUtils.backgroundBlack,
                                    borderRadius: BorderRadius.circular(18).w,
                                  ),
                                  child: ValueListenableBuilder(
                                    valueListenable: calendarDate,
                                    builder: (context, value, child) {
                                      return LoyaltriCalender(loadMonthData: (date) async {
                                        calendarDate.value = date;
                                        await getMonthData(date);
                                      }, focusedDate: value);
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              TaskView(isDarkMode: true),
                              SizedBox(height: 10.h),
                              GetX<WorkEntryListController>(
                                builder: (WorkEntryListController controller) {
                                  // if(controller.isLoading.value) {
                                  //   context.loaderOverlay.show();
                                  // } else {
                                  //   context.loaderOverlay.hide();
                                  // }
                                  if(controller.dataLoaded.value && controller.workEntryList.value.result.isNotEmpty) {
                                    return HomeWorkEntryView(workDetails: controller.workEntryList.value.result.reversed.toList(), callBack: getWorkList);
                                  } else {
                                    return Container(height: 150.h);
                                  }
                                },
                              ),
                              SizedBox(height: 100.h),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: MyUpgradeCard(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _CustomHeaderDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 110.w; // Set the maximum extent of the header

  @override
  double get minExtent => 110.w; // Set the minimum extent of the header

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
