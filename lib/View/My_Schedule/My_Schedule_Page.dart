
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loyaltri_minimal/View/CWidgets/app_bar.dart';
import 'package:loyaltri_minimal/View/My_Schedule/my_schedule_widgets/scheduled_item_row_widget.dart';
import 'package:loyaltri_minimal/controller/upcomingShiftController.dart';
import '../../services/connectivity_service.dart';
import '../../utils/color_utils.dart';
import '../CWidgets/error_dialog.dart';

class MySchedule extends StatefulWidget {
  const MySchedule({super.key});

  @override
  State<MySchedule> createState() => _MyScheduleState();
}

class _MyScheduleState extends State<MySchedule> {
  ValueNotifier<int> tabNotifier = ValueNotifier(0);
  UpcomingShiftController upcomingShiftController = Get.find<UpcomingShiftController>();

  @override
  void initState() {
    initialize();
    super.initState();
  }

  Future<void> initialize() async {
    bool connection = await ConnectivityService().check();
    if(!connection) {
      await ErrorDialog().internetWarn(
        context: context,
        title: "No Internet Connection",
        subTitle: "Please check if your connection is stable.",
        onPressed: () {
          Navigator.of(context).pop();
          initialize();
        },
      );
    } else {
      context.loaderOverlay.show();
      await upcomingShiftController.fetchUpcomingShiftDetails();
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
                    title: "My Schedule",
                    image: "assets/images/my_schedule.webp",
                    isActionVisible: true,
                  ),
                  SizedBox(height: 8.w),
                  Padding(
                    padding: const EdgeInsets.all(8.0).w,
                    child: SizedBox(
                      width: ScreenUtil().screenWidth,
                      height: ScreenUtil().screenHeight * 0.9,
                      child: GetX<UpcomingShiftController>(
                        builder: (UpcomingShiftController controller) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              controller.upcomingShifts.isNotEmpty ? Expanded(
                                child: ListView.separated(
                                  padding: EdgeInsets.only(bottom: Platform.isIOS ? 150 : 100).w,
                                  itemCount: controller.upcomingShifts.length,
                                  itemBuilder: (context, index) {
                                    String datePart = controller.upcomingShifts[index].date?.split(',')[1] ?? '';
                                    DateTime? parsedDate;
                                    String? formattedDate;
                                    try {
                                      parsedDate = DateTime.parse(datePart);
                                      formattedDate = DateFormat('MMM d - EEEE').format(parsedDate);
                                    } catch(e) {}
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          children: [
                                            InkWell(
                                              onTap: () {

                                              },
                                              child: Text(
                                                formattedDate ?? '--',
                                                style: GoogleFonts.poppins(
                                                  color: ColorUtils.textWhite,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16.sp,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10.w),
                                        SizedBox(
                                          width: ScreenUtil().screenWidth,
                                          child: ScheduledItemRowWidget(shiftDetails: controller.upcomingShifts[index], intNum: index),
                                        ),
                                        // SizedBox(
                                        //   height: 142.w,
                                        //   width: ScreenUtil().screenWidth,
                                        //   child: ListView.separated(
                                        //     scrollDirection: Axis.horizontal,
                                        //     shrinkWrap: true,
                                        //     itemCount: 10,
                                        //     itemBuilder: (context, index) {
                                        //       return const ScheduledItemRowWidget();
                                        //     },
                                        //     separatorBuilder: (context, index) => SizedBox(width: 8.w),
                                        //   ),
                                        // ),
                                      ],
                                    );
                                  },
                                  separatorBuilder: (context, index) => SizedBox(height: 15.w),
                                ),
                              ) : SizedBox(
                                height: ScreenUtil().screenHeight * 0.8,
                                child: Center(
                                  child: Text(
                                    "No Data Found",
                                    style: TextStyle(color: Colors.white.withOpacity(0.5)),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
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
          height: 55.w,
          padding: const EdgeInsets.symmetric(horizontal: 8).w,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                ColorUtils.workEntryHead.withOpacity(0),
                ColorUtils.workEntryHead.withOpacity(0.2),
                ColorUtils.workEntryHead.withOpacity(0.4),
                ColorUtils.workEntryHead.withOpacity(0.6),
                ColorUtils.workEntryHead.withOpacity(0.8),
                ColorUtils.workEntryHead.withOpacity(1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
