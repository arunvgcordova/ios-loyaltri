import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as map;
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/View/field/core/asset_utils.dart';
import 'package:loyaltri_minimal/View/field/core/utils.dart';
import 'package:loyaltri_minimal/View/field/features/form/work_form_screen.dart';
import 'package:loyaltri_minimal/View/field/features/home/controller/home_controller.dart';
import 'package:loyaltri_minimal/View/field/features/tracking/tracker_controller.dart';
import 'package:loyaltri_minimal/View/field/features/widgets/app_bar.dart';
import 'package:loyaltri_minimal/View/field/features/widgets/filled_button.dart';
import 'package:loyaltri_minimal/View/field/features/widgets/out_line_button.dart';
import 'package:loyaltri_minimal/View/field/features/work_details/controller/work_details_controller.dart';
import 'package:loyaltri_minimal/View/field/features/work_details/model/work_details_response.dart';
import 'package:loyaltri_minimal/View/field/features/work_details/widget/details_view_widget.dart';
import 'package:loyaltri_minimal/View/field/features/work_details/widget/geofence_widget.dart';
import 'package:loyaltri_minimal/View/field/features/work_log/work_log_screen.dart';
import 'package:loyaltri_minimal/controller/ui_controller/home_controller.dart';
import '../../core/colour_utils.dart';

class WorkDetailsScreen extends GetView<WorkDetailController> {
  WorkDetailsScreen({
    super.key,
    required this.workId,
    required this.selectedDate,
  });

  final String workId;
  final DateTime selectedDate;
  String? geofenceOverrideStatus;

  @override
  Widget build(BuildContext context) {
    Get.put(WorkDetailController());
    controller.fetchWorkLogDetail(id: workId);
    return Scaffold(
      backgroundColor: ColourUtils.background,
      appBar: AppBarWidget(title: 'Work Details'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  controller.fetchWorkLogDetail(id: workId);
                },
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  child: GetX<WorkDetailController>(
                    builder: (controller) {
                      if (controller.isloading.value) {
                        return SizedBox(
                          height: 500.h,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else if (controller.workDetail.value == null) {
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
                      final currentPos = map.LatLng(
                        controller.workDetail.value?.data?.latLng?.lat ?? 0.0,
                        controller.workDetail.value?.data?.latLng?.lng ?? 0.0,
                      );

                      final Set<map.Marker> markers = {
                        if (currentPos.latitude != 0.0 &&
                            currentPos.longitude != 0.0)
                          map.Marker(
                            markerId: const map.MarkerId('work_location'),
                            position: currentPos,
                            infoWindow: map.InfoWindow(
                              title:
                                  controller.workDetail.value?.data?.title ??
                                  'Work Location',
                              snippet:
                                  controller.workDetail.value?.data?.location ??
                                  '',
                            ),
                          ),
                      };

                      final map.CameraPosition initialPosition =
                          map.CameraPosition(
                            target: currentPos,
                            zoom:
                                currentPos.latitude != 0.0 &&
                                    currentPos.longitude != 0.0
                                ? 16.0
                                : 2.0,
                          );

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // WORK SUMMARY HEADER CARD
                          _buildHeaderCard(
                            workData: controller.workDetail.value?.data,
                            context: context,
                          ),
                          SizedBox(height: 10.h),

                          // MAP VIEW CARD
                          // _buildMapCard(context),
                          // MapPreviewWidget(showGeofence: true, height: 150),
                          Container(
                            height: 210.h,
                            decoration: BoxDecoration(
                              color: const Color(0xFF14171A),
                              borderRadius: BorderRadius.circular(12.h),
                              border: Border.all(
                                color: ColourUtils.textWhite.withValues(
                                  alpha: 0.1,
                                ),
                                width: 1.h,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6.0),
                              child: Stack(
                                children: [
                                  map.GoogleMap(
                                    initialCameraPosition: initialPosition,
                                    markers: markers,
                                    gestureRecognizers:
                                        <Factory<OneSequenceGestureRecognizer>>{
                                          Factory<OneSequenceGestureRecognizer>(
                                            () => EagerGestureRecognizer(),
                                          ),
                                        },
                                    // myLocationEnabled: true,
                                    // myLocationButtonEnabled: true,
                                    // zoomControlsEnabled: false,
                                    scrollGesturesEnabled: false,
                                    compassEnabled: true,
                                    mapToolbarEnabled: false,
                                  ),
                                  if (currentPos.latitude == 0.0 &&
                                      currentPos.longitude == 0.0)
                                    Container(
                                      color: const Color(
                                        0xFF0F172A,
                                      ).withOpacity(0.85),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.map_outlined,
                                              color: Color(0xFF64748B),
                                              size: 40.0,
                                            ),
                                            const SizedBox(height: 8.0),
                                            const Text(
                                              'Map not available',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            // const SizedBox(height: 4.0),
                                            // const Text(
                                            //   'Press Start Tracking to begin live mapping.',
                                            //   style: TextStyle(
                                            //     color: Color(0xFF94A3B8),
                                            //     fontSize: 11.0,
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),

                          // GEOFENCE WARNING CARD
                          // _buildGeofenceWarningCard(),
                          GeofenceWidget(
                            workId: controller.workDetail.value?.data?.id ?? 0,
                            workInstanceId: controller.getWorkInstanceId(
                              controller.workDetail.value?.data?.instances,
                              selectedDate,
                            ),
                            status: controller.getOverrideRequestStatus(
                              controller.workDetail.value?.data?.instances,
                              selectedDate,
                            ),
                            isGeofenceRequired: controller.workDetail.value?.data?.geofenceRequired,
                          ),
                          SizedBox(height: 16.h),

                          // DETAILS CONTAINER
                          Text(
                            'Work Information',
                            style: GoogleFonts.inter(
                              color: ColourUtils.textMain,
                              fontSize: 16.h,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          _buildGridView(),
                          SizedBox(height: 10.h),
                          _buildDetailsContainer(
                            description:
                                controller.workDetail.value?.data?.description,
                            attachments:
                                controller.workDetail.value?.data?.attachments,
                          ),
                          SizedBox(height: 24.h),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            // Footer Start Action Button
            _buildFooterActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard({
    required WorkData? workData,
    required BuildContext context,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: ColourUtils.bgColour6,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: ColourUtils.borderColour, width: 1.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            // 'AC Maintenance - Sector 7 adidjiasjdis sadjaisidojioadoijoi',
            workData?.title ?? "",
            style: GoogleFonts.inter(
              color: ColourUtils.textMain,
              fontSize: 16.h,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 8.h),
          WorkTypeContainerWidget(text: workData?.workTypeDetail?.name ?? ""),
          SizedBox(height: 10.h),
          StoreNamewidget(text: workData?.customerDetail?.name ?? ""),
          SizedBox(height: 8.h),
          LocationTextWidget(text: workData?.location ?? ""),
          SizedBox(height: 12.h),
          Row(
            children: [
              SizedBox(
                height: 20.h,
                width: 20.h,
                child: SvgPicture.asset(AssetUtils.svg('phone')),
              ),
              SizedBox(width: 10.h),
              Text(
                // '+91 98765 43210',
                workData?.customerDetail?.phone ?? "",
                style: GoogleFonts.inter(
                  color: ColourUtils.fontColour1,
                  fontSize: 14.h,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              FillButtonWidget(
                label: 'Call Customer',
                icon: 'phone',
                function: () async {
                  makePhoneCall(workData?.customerDetail?.phone);
                },
                isRound: false,
              ),
              SizedBox(width: 10.h),
              OutLineButtonWidget(
                label: 'Navigate',
                icon: 'navigation',
                function: () {
                  openGoogleMaps(
                    latitude: workData?.latLng?.lat ?? 0.0,
                    longitude: workData?.latLng?.lng ?? 0.0,
                    context: context,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGridView() {
    final statusData = [
      {
        'label': 'Scheduled Date',
        // 'value': '06 May, 2026',
        'value': controller.getWorkDateByDate(
          controller.workDetail.value?.data?.instances,
          selectedDate,
        ),
        'color': ColourUtils.textMain,
        'bg': ColourUtils.cardBackgroundLight,
        'icon': "calendar",
      },
      {
        'label': 'Priority',
        'value': controller.workDetail.value?.data?.priority,
        'color': ColourUtils.pending,
        'bg': ColourUtils.pendingBg,
        'icon': "flag",
      },
      {
        'label': 'Start Time',
        'value': controller.getWorkStartTimeByDate(
          controller.workDetail.value?.data?.instances,
          selectedDate,
        ),
        'color': ColourUtils.completed,
        'bg': ColourUtils.completedBg,
        'icon': "clock",
      },
      {
        'label': 'End Time',
        'value': controller.getWorkEndTimeByDate(
          controller.workDetail.value?.data?.instances,
          selectedDate,
        ),
        'color': ColourUtils.delayed,
        'bg': ColourUtils.delayedBg,
        'icon': "clock",
      },
      {
        'label': 'OTP verification',
        'value': controller.workDetail.value?.data?.geofenceRequired == true
            ? 'Enabled'
            : 'Disable',
        'color': ColourUtils.overdue,
        'bg': ColourUtils.overdueBg,
        'icon': "shield_1",
      },
      {
        'label': 'Geofence',
        'value': controller.workDetail.value?.data?.geofenceRequired == true
            ? 'Required'
            : 'Not Required',
        'color': ColourUtils.overdue,
        'bg': ColourUtils.overdueBg,
        'icon': "point",
      },
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.h,
        mainAxisSpacing: 10.h,
        childAspectRatio: 3,
      ),
      itemCount: statusData.length,
      itemBuilder: (context, index) {
        final stat = statusData[index];
        return Container(
          decoration: BoxDecoration(
            color: ColourUtils.bgColour6,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: ColourUtils.borderColour, width: 1.w),
          ),
          child: Row(
            children: [
              SizedBox(width: 4.h),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  height: 20.h,
                  width: 20.h,
                  child: SvgPicture.asset(
                    AssetUtils.svg(stat['icon'] as String),
                  ),
                ),
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stat['label'] as String,
                    style: GoogleFonts.inter(
                      color: ColourUtils.textMuted,
                      fontSize: 12.h,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    stat['value'] as String,
                    style: GoogleFonts.inter(
                      color: stat['color'] as Color,
                      fontSize: 15.h,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailsContainer({
    required String? description,
    required List<Attachments>? attachments,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColourUtils.bgColour6,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: ColourUtils.borderColour, width: 1.5.w),
      ),
      child: Column(
        children: [
          DetailRow(
            label: 'Description / Instructions',
            value: description ?? "--",
            // value:
            //     'Inspect AC unit, clean filters, check gas levels, test performance and ensure proper cooling.',
          ),
          const Divider(color: ColourUtils.border, height: 1),
          _buildDetailRow(label: 'Attachments', attachments: attachments),
          const Divider(color: ColourUtils.border, height: 1),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.h,
                  width: 20.h,
                  child: SvgPicture.asset(AssetUtils.svg('menu')),
                ),
                SizedBox(width: 14.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Assigned By',
                      style: GoogleFonts.inter(
                        color: ColourUtils.textMuted,
                        fontSize: 12.h,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      // 'Amit Kumar (Manager)',
                      controller.assignedEmployee.value,
                      style: GoogleFonts.inter(
                        color: ColourUtils.textMain,
                        fontSize: 14.h,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                RoundFillButton(
                  icon: 'phone_fill',
                  function: () {
                    makePhoneCall(controller.assignedEmployeeNumber.value);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required String label,
    required List<Attachments>? attachments,
    bool isLongText = false,
  }) {
    String formatFileSize(int? bytes) {
      if (bytes == null || bytes <= 0) {
        return '0 MB';
      }

      final mb = bytes / (1024 * 1024);
      return '${mb.toStringAsFixed(2)} MB';
    }

    String getFileType(String? fileName) {
      if (fileName == null || fileName.isEmpty) {
        return "";
      }

      final extension = fileName.split('.').last.toUpperCase();
      return extension;
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20.h,
            width: 20.h,
            child: SvgPicture.asset(AssetUtils.svg('menu')),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    color: ColourUtils.textMuted,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 10.h),
                if (attachments == null || attachments.isEmpty)
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Text(
                        'No attachments',
                        style: GoogleFonts.inter(
                          color: ColourUtils.textWhite.withValues(alpha: 0.6),
                          fontSize: 12.h,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  )
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: attachments.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.w,
                      mainAxisSpacing: 8.h,
                      childAspectRatio: 2.5,
                    ),
                    itemBuilder: (context, index) {
                      final attachmentData = attachments[index];
                      return InkWell(
                        onTap: () {
                          openAttachment(attachmentData.accessPath);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: ColourUtils.bgColour19,
                            borderRadius: BorderRadius.circular(8.h),
                            border: Border.all(
                              color: ColourUtils.borderColour,
                              width: 1.w,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            child: Row(
                              children: [
                                SizedBox(width: 5.h),
                                SizedBox(
                                  height: 20.h,
                                  width: 20.h,
                                  child: Stack(
                                    children: [
                                      svgWidget(
                                        icon: 'file',
                                        height: 20.h,
                                        width: 20.h,
                                      ),
                                      Align(
                                        alignment:
                                            AlignmentGeometry.bottomCenter,
                                        child: Container(
                                          width: 20.h,
                                          height: 10.h,
                                          color: ColourUtils.bgColour19,
                                          child: Center(
                                            child: Text(
                                              getFileType(attachmentData.name),
                                              style: GoogleFonts.inter(
                                                color: Colors.white,
                                                fontSize: 7.h,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 5.h),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        attachmentData.name ?? "",
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: 12.h,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        formatFileSize(attachmentData.size),
                                        style: GoogleFonts.inter(
                                          color: Colors.white.withValues(
                                            alpha: 0.6,
                                          ),
                                          fontSize: 12.h,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  size: 25.h,
                                  color: ColourUtils.textWhite,
                                ),
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

  Widget _buildFooterActions(BuildContext context) {
    return GetX<WorkDetailController>(
      builder: (controller) {
        final geofenceOverrideStatus = controller.getOverrideRequestStatus(
          controller.workDetail.value?.data?.instances,
          selectedDate,
        );
        return controller.getWorkInstanceStatus(
                      controller.workDetail.value?.data?.instances,
                      selectedDate,
                    ) ==
                    'completed' ||
                controller.isloading.value
            ? SizedBox()
            : Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(color: ColourUtils.cardBackground),
                child: Row(
                  children: [
                    FillButtonWidget(
                      label:
                          controller.getWorkInstanceStatus(
                                controller.workDetail.value?.data?.instances,
                                selectedDate,
                              ) ==
                              'assigned'
                          ? 'Start Work'
                          : 'Submit Work',
                      isLoading: controller.isloading.value,
                      function: () async {
                        if (Get.find<HomeController>().punchTime.value == "") {
                          AttendanceCommonWidgets().showSnackBar(
                            context: context,
                            backgroundColor: Colors.red,
                            message: "Please check in first",
                          );
                          return;
                        } else {
                          // AttendanceCommonWidgets().printF(
                          //   "jidjoisdj osa - work id  = $workId",
                          // );

                          if (controller.getWorkInstanceStatus(
                                controller.workDetail.value?.data?.instances,
                                selectedDate,
                              ) ==
                              'assigned') {
                            // for check if already in work //
                            final status = await Get.find<FieldHomeController>()
                                .checkInprogressWork(context: context);
                            if (status == true) {
                              return;
                            }
                            // await Get.find<TrackingController>().startWork();
                            // controller
                            //     .workStatusUpdate(
                            //       context: context,
                            //       workId:
                            //           controller.workDetail.value?.data?.id ??
                            //           0,
                            //       workInstanceId: controller.getWorkInstanceId(
                            //         controller
                            //             .workDetail
                            //             .value
                            //             ?.data
                            //             ?.instances,
                            //         selectedDate,
                            //       ),
                            //       date: DateFormat(
                            //         'yyyy-MM-dd',
                            //       ).format(DateTime.now()),
                            //       status: 'in_progress',
                            //     )
                            //     .then((value) {
                            //       controller.fetchWorkLogDetail(id: workId);
                            //     });

                            if (geofenceOverrideStatus != "approved" &&
                                controller
                                        .workDetail
                                        .value
                                        ?.data
                                        ?.geofenceRequired ==
                                    true) {
                              final targetLat = controller
                                  .workDetail
                                  .value
                                  ?.data
                                  ?.latLng
                                  ?.lat;
                              final targetLng = controller
                                  .workDetail
                                  .value
                                  ?.data
                                  ?.latLng
                                  ?.lng;

                              if (targetLat != null &&
                                  targetLng != null &&
                                  targetLat != 0.0 &&
                                  targetLng != 0.0) {
                                // controller.isloading.value = true;
                                try {
                                  bool serviceEnabled =
                                      await Geolocator.isLocationServiceEnabled();
                                  if (!serviceEnabled) {
                                    AttendanceCommonWidgets().showSnackBar(
                                      context: context,
                                      backgroundColor: Colors.red,
                                      message:
                                          "Location services are disabled. Please enable them in settings.",
                                    );
                                    // controller.isloading.value = false;
                                    return;
                                  }

                                  LocationPermission permission =
                                      await Geolocator.checkPermission();
                                  if (permission == LocationPermission.denied) {
                                    permission =
                                        await Geolocator.requestPermission();
                                    if (permission ==
                                        LocationPermission.denied) {
                                      AttendanceCommonWidgets().showSnackBar(
                                        context: context,
                                        backgroundColor: Colors.red,
                                        message:
                                            "Location permission is denied.",
                                      );
                                      // controller.isloading.value = false;
                                      return;
                                    }
                                  }

                                  if (permission ==
                                      LocationPermission.deniedForever) {
                                    AttendanceCommonWidgets().showSnackBar(
                                      context: context,
                                      backgroundColor: Colors.red,
                                      message:
                                          "Location permission is permanently denied. Please enable it in app settings.",
                                    );
                                    controller.isloading.value = false;
                                    return;
                                  }

                                  Position currentPosition =
                                      await Geolocator.getCurrentPosition(
                                        desiredAccuracy: LocationAccuracy.high,
                                      );

                                  double distanceInMeters =
                                      Geolocator.distanceBetween(
                                        currentPosition.latitude,
                                        currentPosition.longitude,
                                        targetLat,
                                        targetLng,
                                      );

                                      final double allowedRadiusMeters = (Get.isRegistered<TrackingController>() &&
                                          Get.find<TrackingController>().companySettings.value != null)
                                      ? Get.find<TrackingController>().companySettings.value!.geofencingRadiusMeters
                                      : 500.0;

                                  if (distanceInMeters > allowedRadiusMeters) {
                                    AttendanceCommonWidgets().showSnackBar(
                                      context: context,
                                      backgroundColor: Colors.red,
                                      message:
                                          "please move to the location or make request to geolocation override",
                                    );
                                    // controller.isloading.value = false;
                                    return;
                                  }
                                } catch (e) {
                                  AttendanceCommonWidgets().showSnackBar(
                                    context: context,
                                    backgroundColor: Colors.red,
                                    message:
                                        "Failed to determine your location. Please check GPS and try again.",
                                  );
                                  // controller.isloading.value = false;
                                  return;
                                }
                              }
                            }

                            controller.isloading.value = true;
                            await Get.find<TrackingController>().startWork(
                              workId:
                                  controller.workDetail.value?.data?.id ?? 0,
                            );
                            await controller
                                .workStatusUpdate(
                                  context: context,
                                  workId:
                                      controller.workDetail.value?.data?.id ??
                                      0,
                                  workInstanceId: controller.getWorkInstanceId(
                                    controller
                                        .workDetail
                                        .value
                                        ?.data
                                        ?.instances,
                                    selectedDate,
                                  ),
                                  date: DateFormat(
                                    'yyyy-MM-dd',
                                  ).format(selectedDate),
                                  status: 'in_progress',
                                );
                            controller.fetchWorkLogDetail(id: workId);
                            final openFormOnStart = Get.isRegistered<TrackingController>() &&
                                Get.find<TrackingController>().companySettings.value?.openWorkFormOnStart == true;
                            if (openFormOnStart) {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WorkFormScreen(
                                    workTypeId:
                                    controller
                                        .workDetail
                                        .value
                                        ?.data
                                        ?.workType
                                        .toString() ??
                                        "",
                                    workDetail: controller.workDetail.value?.data,
                                    selectedDate: selectedDate,
                                    workid: workId,
                                    workInstanceId: controller.getWorkInstanceId(
                                      controller
                                          .workDetail
                                          .value
                                          ?.data
                                          ?.instances,
                                      selectedDate,
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              if(Get.isRegistered<FieldHomeController>()) {
                                await Get.find<FieldHomeController>().fetchHomeDetail();
                              }
                              await Get.find<HomeController>().fetchWorkLogByDate();
                            }
                            controller.isloading.value = false;
                          } else {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WorkFormScreen(
                                  workTypeId:
                                      controller
                                          .workDetail
                                          .value
                                          ?.data
                                          ?.workType
                                          .toString() ??
                                      "",
                                  workDetail: controller.workDetail.value?.data,
                                  selectedDate: selectedDate,
                                  workid: workId,
                                  workInstanceId: controller.getWorkInstanceId(
                                    controller
                                        .workDetail
                                        .value
                                        ?.data
                                        ?.instances,
                                    selectedDate,
                                  ),
                                ),
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              );
      },
    );
  }
}
