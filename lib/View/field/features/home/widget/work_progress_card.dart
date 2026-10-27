import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/View/field/core/colour_utils.dart';
import 'package:loyaltri_minimal/View/field/core/utils.dart';
import 'package:loyaltri_minimal/View/field/features/form/work_form_screen.dart';
import 'package:loyaltri_minimal/View/field/features/home/controller/home_controller.dart';
import 'package:loyaltri_minimal/View/field/features/home/model/home_response.dart';
import 'package:loyaltri_minimal/View/field/features/tracking/tracker_controller.dart';
import 'package:loyaltri_minimal/View/field/features/work_details/controller/work_details_controller.dart';
import 'package:loyaltri_minimal/View/field/features/work_details/work_details_screen.dart';
import 'package:loyaltri_minimal/View/field/features/work_log/work_log_screen.dart';
import 'package:loyaltri_minimal/controller/ui_controller/home_controller.dart';

class WorkInProgressCard extends StatelessWidget {
  const WorkInProgressCard({
    super.key,
    this.homeData,
    required this.isProgress,
  });

  final HomeData? homeData;
  final bool isProgress;

  @override
  Widget build(BuildContext context) {
    final TrackingController controller = Get.put(TrackingController());
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WorkDetailsScreen(
              workId: isProgress
                  ? homeData?.highlights?.inProgressWork?.workId.toString() ??
                        ""
                  : homeData?.highlights?.nextUpcomingWork?.workId
                            ?.toString() ??
                        "",
              selectedDate: DateTime.now(),
            ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.h),
        decoration: BoxDecoration(
          // color: ColourUtils.cardBackground,
          gradient: LinearGradient(
            begin: AlignmentGeometry.topCenter,
            end: AlignmentGeometry.bottomCenter,
            colors: [ColourUtils.gdColourS, ColourUtils.gdColourE],
          ),
          borderRadius: BorderRadius.circular(12.h),
          border: Border.all(color: ColourUtils.borderColour, width: 1.h),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // 'AC Maintenance - Sector 7 sdoisaijidojidd jdsjidja jsdjiasjds ',
                  isProgress
                      ? homeData?.highlights?.inProgressWork?.work?.title ?? ""
                      : homeData?.highlights?.nextUpcomingWork?.work?.title ??
                            "",
                  style: GoogleFonts.inter(
                    color: ColourUtils.textMain,
                    fontSize: 16.h,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 10.h),
                WorkTypeContainerWidget(
                  text: isProgress
                      ? homeData
                                ?.highlights
                                ?.inProgressWork
                                ?.work
                                ?.workType
                                ?.name ??
                            ""
                      : homeData
                                ?.highlights
                                ?.nextUpcomingWork
                                ?.work
                                ?.workType
                                ?.name ??
                            "",
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StoreNamewidget(
                            // text: "Sharma Electronics dasjoidhjisadjasidjijsdji",
                            text: isProgress
                                ? homeData
                                          ?.highlights
                                          ?.inProgressWork
                                          ?.work
                                          ?.customer
                                          ?.name ??
                                      ""
                                : homeData
                                          ?.highlights
                                          ?.nextUpcomingWork
                                          ?.work
                                          ?.customer
                                          ?.name ??
                                      "",
                          ),
                          SizedBox(height: 8.h),
                          LocationTextWidget(
                            // text: 'Connaught Place, New Delhi hsdajdiiadisjo',
                            text: isProgress
                                ? homeData
                                          ?.highlights
                                          ?.inProgressWork
                                          ?.work
                                          ?.location ??
                                      ""
                                : homeData
                                          ?.highlights
                                          ?.nextUpcomingWork
                                          ?.work
                                          ?.location ??
                                      "",
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    RoundFillButton(
                      icon: 'navigation_fill',
                      function: () {
                        openGoogleMaps(
                          latitude: isProgress
                              ? homeData
                                    ?.highlights
                                    ?.inProgressWork
                                    ?.work
                                    ?.latLng
                                    ?.lat
                              : homeData
                                    ?.highlights
                                    ?.nextUpcomingWork
                                    ?.work
                                    ?.latLng
                                    ?.lat,
                          longitude: isProgress
                              ? homeData
                                    ?.highlights
                                    ?.inProgressWork
                                    ?.work
                                    ?.latLng
                                    ?.lng
                              : homeData
                                    ?.highlights
                                    ?.nextUpcomingWork
                                    ?.work
                                    ?.latLng
                                    ?.lng,
                          context: context,
                        );
                      },
                    ),
                    SizedBox(width: 10.h),
                    RoundFillButton(
                      icon: 'phone_fill',
                      function: () {
                        makePhoneCall(
                          isProgress
                              ? homeData
                                    ?.highlights
                                    ?.inProgressWork
                                    ?.work
                                    ?.customer
                                    ?.phone
                              : homeData
                                    ?.highlights
                                    ?.nextUpcomingWork
                                    ?.work
                                    ?.customer
                                    ?.phone,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Divider(color: ColourUtils.borderColour, height: 0),
            SizedBox(height: 10.h),
            Obx(
              () => IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              svgWidget(
                                height: 20.h,
                                width: 20.h,
                                icon: 'clock',
                                color: ColourUtils.textWhite.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                'Start Time',
                                style: GoogleFonts.inter(
                                  color: ColourUtils.textSecondary,
                                  fontSize: 12.h,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(width: 20.h, height: 20.h),
                              SizedBox(width: 10.w),
                              Builder(
                                builder: (context) {
                                  String displayTime = '';

                                  if (isProgress) {
                                    final actualStartTime = homeData
                                        ?.highlights
                                        ?.inProgressWork
                                        ?.actualStartTime;

                                    if (actualStartTime != null &&
                                        actualStartTime.isNotEmpty) {
                                      displayTime = formatActualTime(
                                        actualStartTime,
                                      );
                                    } else {
                                      displayTime = formatTime(
                                        homeData
                                                ?.highlights
                                                ?.inProgressWork
                                                ?.plannedStartTime ??
                                            '',
                                      );
                                    }
                                  } else {
                                    displayTime = formatTime(
                                      homeData
                                              ?.highlights
                                              ?.nextUpcomingWork
                                              ?.plannedStartTime ??
                                          '',
                                    );
                                  }

                                  return Text(
                                    displayTime,
                                    style: GoogleFonts.inter(
                                      color: ColourUtils.textWhite,
                                      fontSize: 16.h,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    VerticalDivider(color: ColourUtils.borderColour),
                    Expanded(
                      child: isProgress
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    svgWidget(
                                      height: 20.h,
                                      width: 20.h,
                                      icon: 'clock',
                                      color: ColourUtils.textWhite.withValues(
                                        alpha: 0.6,
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Text(
                                      'Running Time',
                                      style: GoogleFonts.inter(
                                        color: ColourUtils.textSecondary,
                                        fontSize: 12.h,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(width: 20.h, height: 20.h),
                                    SizedBox(width: 10.w),
                                    Text(
                                      Get.find<FieldHomeController>()
                                          .runningTime
                                          .value,
                                      style: GoogleFonts.inter(
                                        color: ColourUtils.textWhite,
                                        fontSize: 16.h,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                svgWidget(
                                  height: 20.h,
                                  width: 20.h,
                                  icon: 'clock',
                                  color: ColourUtils.textWhite.withValues(
                                    alpha: 0.6,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: Text(
                                    Get.find<FieldHomeController>()
                                        .runningTime
                                        .value,
                                    style: GoogleFonts.inter(
                                      color: ColourUtils.textSecondary,
                                      fontSize: 12.h,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            (homeData
                        ?.highlights
                        ?.nextUpcomingWork
                        ?.geofenceStatusOverrideRequestStatus ==
                    "pending")
                ? Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(14.r),
                    decoration: BoxDecoration(
                      color: ColourUtils.delayedBg,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: ColourUtils.delayed.withOpacity(0.3),
                        width: 1.w,
                      ),
                    ),
                    child: Text(
                      'Override geofence request sent. Waiting for admin approval.',
                      // title,
                      style: GoogleFonts.inter(
                        color: ColourUtils.delayed,
                        fontSize: 12.h,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : SizedBox(
                    width: double.infinity,
                    height: 44.h,
                    child: ElevatedButton(
                      onPressed: () async {
                        final WorkDetailscontroller = Get.put(
                          WorkDetailController(),
                        );
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

                          if (!isProgress) {
                            // for check if already in work //
                            final status = await Get.find<FieldHomeController>()
                                .checkInprogressWork(context: context);
                            if (status == true) {
                              return;
                            }

                            if (homeData
                                        ?.highlights
                                        ?.nextUpcomingWork
                                        ?.geofenceStatusOverrideRequestStatus !=
                                    "approved" &&
                                homeData
                                        ?.highlights
                                        ?.nextUpcomingWork
                                        ?.work
                                        ?.geofenceRequired ==
                                    true) {
                              final targetLat = homeData
                                  ?.highlights
                                  ?.nextUpcomingWork
                                  ?.work
                                  ?.latLng
                                  ?.lat;
                              final targetLng = homeData
                                  ?.highlights
                                  ?.nextUpcomingWork
                                  ?.work
                                  ?.latLng
                                  ?.lng;

                              if (targetLat != null &&
                                  targetLng != null &&
                                  targetLat != 0.0 &&
                                  targetLng != 0.0) {
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
                                    return;
                                  }
                                } catch (e) {
                                  AttendanceCommonWidgets().showSnackBar(
                                    context: context,
                                    backgroundColor: Colors.red,
                                    message:
                                        "Failed to determine your location. Please check GPS and try again.",
                                  );
                                  return;
                                }
                              }
                            }
                            await Get.find<TrackingController>().startWork(
                              workId:
                                  homeData
                                      ?.highlights
                                      ?.nextUpcomingWork
                                      ?.workId ??
                                  0,
                            );

                            await WorkDetailscontroller.workStatusUpdate(
                              context: context,
                              workId:
                                  homeData
                                      ?.highlights
                                      ?.nextUpcomingWork
                                      ?.workId ??
                                  0,
                              workInstanceId:
                                  homeData
                                      ?.highlights
                                      ?.nextUpcomingWork
                                      ?.instanceId ??
                                  0,
                              date: DateFormat(
                                'yyyy-MM-dd',
                              ).format(DateTime.now()),
                              status: 'in_progress',
                            );
                            Get.find<FieldHomeController>().fetchHomeDetail();
                            final openFormOnStart = Get.isRegistered<TrackingController>() &&
                                Get.find<TrackingController>().companySettings.value?.openWorkFormOnStart == true;
                            if (openFormOnStart) {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WorkFormScreen(
                                    workTypeId:
                                    homeData
                                        ?.highlights
                                        ?.nextUpcomingWork
                                        ?.work
                                        ?.workType
                                        ?.id
                                        .toString() ??
                                        "",
                                    workDetail: null,
                                    selectedDate: DateTime.now(),
                                    workid:
                                    homeData
                                        ?.highlights
                                        ?.nextUpcomingWork
                                        ?.workId
                                        .toString() ??
                                        "",
                                    workInstanceId:
                                    homeData
                                        ?.highlights
                                        ?.nextUpcomingWork
                                        ?.instanceId ??
                                        0,
                                  ),
                                ),
                              );
                            } else {
                              if(Get.isRegistered<FieldHomeController>()) {
                                await Get.find<FieldHomeController>().fetchHomeDetail();
                              }
                              await Get.find<HomeController>().fetchWorkLogByDate();
                            }
                          } else {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WorkFormScreen(
                                  workTypeId:
                                      homeData
                                          ?.highlights
                                          ?.inProgressWork
                                          ?.work
                                          ?.workType
                                          ?.id
                                          .toString() ??
                                      "",
                                  workDetail: null,
                                  selectedDate: DateTime.now(),
                                  workid:
                                      homeData
                                          ?.highlights
                                          ?.inProgressWork
                                          ?.workId
                                          .toString() ??
                                      "",
                                  workInstanceId:
                                      homeData
                                          ?.highlights
                                          ?.inProgressWork
                                          ?.instanceId ??
                                      0,
                                ),
                              ),
                            );
                          }
                        }
                      }, // Navigate to Screen 7 (Index 6: Work Completed)
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColourUtils.bgColour1,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        isProgress ? 'Complete Work' : 'Start Work',
                        style: GoogleFonts.inter(
                          fontSize: 14.h,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  String formatActualTime(String? dateTime) {
    if (dateTime == null || dateTime.isEmpty) return '';

    final DateTime dt = DateTime.parse(dateTime).toLocal();
    return DateFormat('h:mm a').format(dt);
  }

  String formatTime(String? time) {
    if (time == null || time.trim().isEmpty) {
      return '';
    }
    try {
      final inputFormat = DateFormat("HH:mm:ss");
      final outputFormat = DateFormat("h:mm a");

      final dateTime = inputFormat.parse(time);
      return outputFormat.format(dateTime);
    } catch (e) {
      return '';
    }
  }
}

// Widget _buildWorkInProgressCard(HomeData? homeData, bool isProgress) {
//     final TrackingController controller = Get.put(TrackingController());
//     return InkWell(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => WorkDetailsScreen(
//               workId: isProgress
//                   ? homeData?.highlights?.inProgressWork?.workId.toString() ??
//                         ""
//                   : homeData?.highlights?.nextUpcomingWork?.workId
//                             ?.toString() ??
//                         "",
//               selectedDate: DateTime.now(),
//             ),
//           ),
//         );
//       },
//       child: Container(
//         width: double.infinity,
//         padding: EdgeInsets.all(16.h),
//         decoration: BoxDecoration(
//           // color: ColourUtils.cardBackground,
//           gradient: LinearGradient(
//             begin: AlignmentGeometry.topCenter,
//             end: AlignmentGeometry.bottomCenter,
//             colors: [ColourUtils.gdColourS, ColourUtils.gdColourE],
//           ),
//           borderRadius: BorderRadius.circular(12.h),
//           border: Border.all(color: ColourUtils.borderColour, width: 1.h),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   // 'AC Maintenance - Sector 7 sdoisaijidojidd jdsjidja jsdjiasjds ',
//                   isProgress
//                       ? homeData?.highlights?.inProgressWork?.work?.title ?? ""
//                       : homeData?.highlights?.nextUpcomingWork?.work?.title ??
//                             "",
//                   style: GoogleFonts.inter(
//                     color: ColourUtils.textMain,
//                     fontSize: 16.h,
//                     fontWeight: FontWeight.w600,
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 SizedBox(height: 10.h),
//                 WorkTypeContainerWidget(
//                   text: isProgress
//                       ? homeData
//                                 ?.highlights
//                                 ?.inProgressWork
//                                 ?.work
//                                 ?.workType
//                                 ?.name ??
//                             ""
//                       : homeData
//                                 ?.highlights
//                                 ?.nextUpcomingWork
//                                 ?.work
//                                 ?.workType
//                                 ?.name ??
//                             "",
//                 ),
//                 SizedBox(height: 10.h),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           StoreNamewidget(
//                             // text: "Sharma Electronics dasjoidhjisadjasidjijsdji",
//                             text: isProgress
//                                 ? homeData
//                                           ?.highlights
//                                           ?.inProgressWork
//                                           ?.work
//                                           ?.customer
//                                           ?.name ??
//                                       ""
//                                 : homeData
//                                           ?.highlights
//                                           ?.nextUpcomingWork
//                                           ?.work
//                                           ?.customer
//                                           ?.name ??
//                                       "",
//                           ),
//                           SizedBox(height: 8.h),
//                           LocationTextWidget(
//                             // text: 'Connaught Place, New Delhi hsdajdiiadisjo',
//                             text: isProgress
//                                 ? homeData
//                                           ?.highlights
//                                           ?.inProgressWork
//                                           ?.work
//                                           ?.location ??
//                                       ""
//                                 : homeData
//                                           ?.highlights
//                                           ?.nextUpcomingWork
//                                           ?.work
//                                           ?.location ??
//                                       "",
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(width: 8.w),
//                     RoundFillButton(
//                       icon: 'navigation_fill',
//                       function: () {
//                         openGoogleMaps(
//                           latitude: isProgress
//                               ? homeData
//                                     ?.highlights
//                                     ?.inProgressWork
//                                     ?.work
//                                     ?.latLng
//                                     ?.lat
//                               : homeData
//                                     ?.highlights
//                                     ?.nextUpcomingWork
//                                     ?.work
//                                     ?.latLng
//                                     ?.lat,
//                           longitude: isProgress
//                               ? homeData
//                                     ?.highlights
//                                     ?.inProgressWork
//                                     ?.work
//                                     ?.latLng
//                                     ?.lng
//                               : homeData
//                                     ?.highlights
//                                     ?.nextUpcomingWork
//                                     ?.work
//                                     ?.latLng
//                                     ?.lng,
//                           context: context,
//                         );
//                       },
//                     ),
//                     SizedBox(width: 10.h),
//                     RoundFillButton(
//                       icon: 'phone_fill',
//                       function: () {
//                         makePhoneCall(
//                           homeData
//                               ?.highlights
//                               ?.inProgressWork
//                               ?.work
//                               ?.customer
//                               ?.phone,
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             SizedBox(height: 16.h),
//             Divider(color: ColourUtils.borderColour, height: 0),
//             SizedBox(height: 10.h),
//             IntrinsicHeight(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             svgWidget(
//                               height: 20.h,
//                               width: 20.h,
//                               icon: 'clock',
//                               color: ColourUtils.textWhite.withValues(
//                                 alpha: 0.6,
//                               ),
//                             ),
//                             SizedBox(width: 10.w),
//                             Text(
//                               'Start Time',
//                               style: GoogleFonts.inter(
//                                 color: ColourUtils.textSecondary,
//                                 fontSize: 12.h,
//                                 fontWeight: FontWeight.w400,
//                               ),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             SizedBox(width: 20.h, height: 20.h),
//                             SizedBox(width: 10.w),
//                             Builder(
//                               builder: (context) {
//                                 String displayTime = '';

//                                 if (isProgress) {
//                                   final actualStartTime = homeData
//                                       ?.highlights
//                                       ?.inProgressWork
//                                       ?.actualStartTime;

//                                   if (actualStartTime != null &&
//                                       actualStartTime.isNotEmpty) {
//                                     displayTime = formatActualTime(
//                                       actualStartTime,
//                                     );
//                                   } else {
//                                     displayTime = formatTime(
//                                       homeData
//                                               ?.highlights
//                                               ?.inProgressWork
//                                               ?.plannedStartTime ??
//                                           '',
//                                     );
//                                   }
//                                 } else {
//                                   displayTime = formatTime(
//                                     homeData
//                                             ?.highlights
//                                             ?.nextUpcomingWork
//                                             ?.plannedStartTime ??
//                                         '',
//                                   );
//                                 }

//                                 return Text(
//                                   displayTime,
//                                   style: GoogleFonts.inter(
//                                     color: ColourUtils.textWhite,
//                                     fontSize: 16.h,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 );
//                               },
//                             ),
//                             // Text(
//                             //   // '10:00 AM',
//                             //   formatTime(
//                             //     isProgress ? homeData
//                             //             ?.highlights
//                             //             ?.inProgressWork
//                             //             ?.plannedStartTime ??"" :
//                             //     homeData
//                             //             ?.highlights
//                             //             ?.nextUpcomingWork
//                             //             ?.plannedStartTime ??
//                             //         "",
//                             //   ),
//                             //   style: GoogleFonts.inter(
//                             //     color: ColourUtils.textWhite,
//                             //     fontSize: 16.h,
//                             //     fontWeight: FontWeight.w600,
//                             //   ),
//                             // ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   VerticalDivider(color: ColourUtils.borderColour),
//                   Expanded(
//                     child: isProgress
//                         ? Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   svgWidget(
//                                     height: 20.h,
//                                     width: 20.h,
//                                     icon: 'clock',
//                                     color: ColourUtils.textWhite.withValues(
//                                       alpha: 0.6,
//                                     ),
//                                   ),
//                                   SizedBox(width: 10.w),
//                                   Text(
//                                     'Running Time',
//                                     style: GoogleFonts.inter(
//                                       color: ColourUtils.textSecondary,
//                                       fontSize: 12.h,
//                                       fontWeight: FontWeight.w400,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   SizedBox(width: 20.h, height: 20.h),
//                                   SizedBox(width: 10.w),
//                                   Text(
//                                     Get.find<FieldHomeController>()
//                                         .runningTime
//                                         .value,
//                                     style: GoogleFonts.inter(
//                                       color: ColourUtils.textWhite,
//                                       fontSize: 16.h,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           )
//                         : Row(
//                             children: [
//                               svgWidget(
//                                 height: 20.h,
//                                 width: 20.h,
//                                 icon: 'clock',
//                                 color: ColourUtils.textWhite.withValues(
//                                   alpha: 0.6,
//                                 ),
//                               ),
//                               SizedBox(width: 10.w),
//                               Expanded(
//                                 child: Text(
//                                   // _getStartsIn(
//                                   //   homeData
//                                   //       ?.highlights
//                                   //       ?.nextUpcomingWork
//                                   //       ?.plannedStartTime,
//                                   // ),
//                                   Get.find<FieldHomeController>()
//                                       .runningTime
//                                       .value,
//                                   style: GoogleFonts.inter(
//                                     color: ColourUtils.textSecondary,
//                                     fontSize: 12.h,
//                                     fontWeight: FontWeight.w400,
//                                   ),
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                             ],
//                           ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 20.h),
//             SizedBox(
//               width: double.infinity,
//               height: 44.h,
//               child: ElevatedButton(
//                 onPressed: () async {
//                   final WorkDetailscontroller = Get.put(WorkDetailController());
//                   if (Get.find<HomeController>().punchTime.value == "") {
//                     AttendanceCommonWidgets().showSnackBar(
//                       context: context,
//                       backgroundColor: Colors.red,
//                       message: "Please check in first",
//                     );
//                     return;
//                   } else {
//                     // AttendanceCommonWidgets().printF(
//                     //   "jidjoisdj osa - work id  = $workId",
//                     // );

//                     if (!isProgress) {
//                       final targetLat = homeData
//                           ?.highlights
//                           ?.nextUpcomingWork
//                           ?.work
//                           ?.customer
//                           ?.location
//                           ?.lat;
//                       final targetLng = homeData
//                           ?.highlights
//                           ?.nextUpcomingWork
//                           ?.work
//                           ?.customer
//                           ?.location
//                           ?.lng;

//                       if (targetLat != null &&
//                           targetLng != null &&
//                           targetLat != 0.0 &&
//                           targetLng != 0.0) {
//                         try {
//                           bool serviceEnabled =
//                               await Geolocator.isLocationServiceEnabled();
//                           if (!serviceEnabled) {
//                             AttendanceCommonWidgets().showSnackBar(
//                               context: context,
//                               backgroundColor: Colors.red,
//                               message:
//                                   "Location services are disabled. Please enable them in settings.",
//                             );
//                             return;
//                           }

//                           LocationPermission permission =
//                               await Geolocator.checkPermission();
//                           if (permission == LocationPermission.denied) {
//                             permission = await Geolocator.requestPermission();
//                             if (permission == LocationPermission.denied) {
//                               AttendanceCommonWidgets().showSnackBar(
//                                 context: context,
//                                 backgroundColor: Colors.red,
//                                 message: "Location permission is denied.",
//                               );
//                               return;
//                             }
//                           }

//                           if (permission == LocationPermission.deniedForever) {
//                             AttendanceCommonWidgets().showSnackBar(
//                               context: context,
//                               backgroundColor: Colors.red,
//                               message:
//                                   "Location permission is permanently denied. Please enable it in app settings.",
//                             );
//                             return;
//                           }

//                           Position currentPosition =
//                               await Geolocator.getCurrentPosition(
//                                 desiredAccuracy: LocationAccuracy.high,
//                               );

//                           double distanceInMeters = Geolocator.distanceBetween(
//                             currentPosition.latitude,
//                             currentPosition.longitude,
//                             targetLat,
//                             targetLng,
//                           );

//                           if (distanceInMeters > 500.0) {
//                             AttendanceCommonWidgets().showSnackBar(
//                               context: context,
//                               backgroundColor: Colors.red,
//                               message:
//                                   "please move to the location or make request to geolocation override",
//                             );
//                             return;
//                           }
//                         } catch (e) {
//                           AttendanceCommonWidgets().showSnackBar(
//                             context: context,
//                             backgroundColor: Colors.red,
//                             message:
//                                 "Failed to determine your location. Please check GPS and try again.",
//                           );
//                           return;
//                         }
//                       }
//                       await Get.find<TrackingController>().startWork();

//                       WorkDetailscontroller.workStatusUpdate(
//                         context: context,
//                         workId:
//                             homeData?.highlights?.nextUpcomingWork?.workId ?? 0,
//                         workInstanceId:
//                             homeData
//                                 ?.highlights
//                                 ?.nextUpcomingWork
//                                 ?.instanceId ??
//                             0,
//                         date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
//                         status: 'in_progress',
//                       ).then((value) {
//                         Get.find<FieldHomeController>().fetchHomeDetail();
//                       });
//                     } else {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => WorkFormScreen(
//                             workTypeId:
//                                 homeData
//                                     ?.highlights
//                                     ?.inProgressWork
//                                     ?.work
//                                     ?.workType
//                                     ?.id
//                                     .toString() ??
//                                 "",
//                             workDetail: null,
//                             selectedDate: DateTime.now(),
//                             workid:
//                                 homeData?.highlights?.inProgressWork?.workId
//                                     .toString() ??
//                                 "",
//                             workInstanceId:
//                                 homeData
//                                     ?.highlights
//                                     ?.inProgressWork
//                                     ?.instanceId ??
//                                 0,
//                           ),
//                         ),
//                       );
//                     }
//                   }
//                 }, // Navigate to Screen 7 (Index 6: Work Completed)
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: ColourUtils.bgColour1,
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10.r),
//                   ),
//                   elevation: 0,
//                 ),
//                 child: Text(
//                   isProgress ? 'Complete Work' : 'Start Work',
//                   style: GoogleFonts.inter(
//                     fontSize: 14.h,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
