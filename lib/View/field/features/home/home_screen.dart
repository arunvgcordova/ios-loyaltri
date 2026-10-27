import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/View/field/features/home/controller/home_controller.dart';
import 'package:loyaltri_minimal/View/field/features/home/widget/empty_card.dart';
import 'package:loyaltri_minimal/View/field/features/home/widget/quick_action_row.dart';
import 'package:loyaltri_minimal/View/field/features/home/widget/timeline.dart';
import 'package:loyaltri_minimal/View/field/features/home/widget/work_overview.dart';
import 'package:loyaltri_minimal/View/field/features/home/widget/work_progress_card.dart';
import 'package:loyaltri_minimal/View/field/features/tracking/tracker_controller.dart';
import 'package:loyaltri_minimal/View/field/features/widgets/add_work_customre_dialog.dart';
import 'package:loyaltri_minimal/View/field/features/widgets/app_bar.dart';
import 'package:loyaltri_minimal/View/field/features/widgets/location_always_permission_dialog.dart';
import 'package:loyaltri_minimal/View/field/features/widgets/physicalActivityPermissionDialog.dart';
import 'package:loyaltri_minimal/controller/userAuthentication.dart';
import '../../core/colour_utils.dart';

class FieldHomeScreen extends StatefulWidget {
  const FieldHomeScreen({super.key});

  @override
  State<FieldHomeScreen> createState() => _FieldHomeScreenState();
}

class _FieldHomeScreenState extends State<FieldHomeScreen> {
  late FieldHomeController controller;
  // late Timer _timer;

  @override
  void initState() {
    super.initState();
    final trackingCtrl = Get.isRegistered<TrackingController>()
        ? Get.find<TrackingController>()
        : Get.put(TrackingController());
    trackingCtrl.fetchCompanySettings();

    controller = Get.put(FieldHomeController());
    controller.fetchHomeDetail();

    WidgetsBinding.instance.addPostFrameCallback((_) async{
      if (Platform.isAndroid) {
        await _checkLocationAlwaysPermission();
        await _checkPhysicalActivityPermission();
      }
    });
  }

  Future<void> _checkLocationAlwaysPermission() async {
    if (!mounted) return;
    await LocationAlwaysPermissionHelper.checkAndRequestPermission(context: context);
  }
  
  Future<void> _checkPhysicalActivityPermission() async {
    if (!mounted) return;
    await ActivityPermissionHelper.checkAndRequestPermission(context: context);
  }

  @override
  void dispose() {
    // _timer.cancel();
    Get.delete<FieldHomeController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColourUtils.background,
      appBar: AppBarWithAddWidget(
        title: 'Field',
        icon: 'map',
        onAddTap: () {
          final trackingCtrl = Get.isRegistered<TrackingController>()
              ? Get.find<TrackingController>()
              : null;
          final empId = Get.find<UserAuthController>()
              .userData
              .value
              .userData
              ?.employeeId;
          final settings = trackingCtrl?.companySettings.value;
          final canWork = settings?.canStaffCreateWork(empId) ?? true;
          final canCust = settings?.canStaffCreateCustomer(empId) ?? true;

          if (!canWork && !canCust) {
            AttendanceCommonWidgets().showSnackBar(
              context: context,
              backgroundColor: Colors.orange,
              message:
                  "You do not have permission to create work or customers.",
            );
            return;
          }

          showModalBottomSheet(
            context: context,
            builder: (context) {
              return AddWorkCustomreDialog();
            },
          );
        },
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          if (Get.isRegistered<TrackingController>()) {
            await Get.find<TrackingController>().fetchCompanySettings();
          }
          if (Platform.isAndroid) {
            await _checkLocationAlwaysPermission();
            await _checkPhysicalActivityPermission();
          }
          controller.fetchHomeDetail();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: SafeArea(
            child: GetX<FieldHomeController>(
              builder: (controller) {
                if (controller.isloading.value) {
                  return SizedBox(
                    height: 500.h,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (controller.homeData.value == null) {
                  return SizedBox(
                    height: 500.h,
                    child: Center(
                      child: Text(
                        'No work detail',
                        style: GoogleFonts.inter(
                          color: ColourUtils.textMuted,
                          fontSize: 14.h,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // WORK IN PROGRESS CARD
                    controller.homeData.value?.data?.highlights?.hasNoWork ==
                            true
                        ? EmptyWorkInProgressCard()
                        : WorkInProgressCard(
                            homeData: controller.homeData.value?.data,
                            isProgress:
                                controller
                                        .homeData
                                        .value
                                        ?.data
                                        ?.highlights
                                        ?.inProgressWork ==
                                    null
                                ? false
                                : true,
                          ),
                    SizedBox(height: 10.h),
                    // QUICK ACTIONS SECTION
                    QuickActionRow(),
                    SizedBox(height: 10.h),
                    // STATUS OVERVIEW
                    WorkOverview(),
                    SizedBox(height: 10.h),
                    // TIMELINE & MINI MAP CARD
                    // TimelineMap(),
                    Builder(
                      builder: (context) {
                        final trackingCtrl =
                            Get.isRegistered<TrackingController>()
                            ? Get.find<TrackingController>()
                            : null;
                        final empId = Get.find<UserAuthController>()
                            .userData
                            .value
                            .userData
                            ?.employeeId;
                        final hasTimeline =
                            trackingCtrl?.companySettings.value
                                ?.hasTimelineAccess(empId) ??
                            true;
                        if (!hasTimeline) return const SizedBox.shrink();
                        return Column(
                          children: [
                            TimelineMap(),
                            SizedBox(height: 24.h),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 24.h),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
