
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loyaltri_minimal/View/CWidgets/cwidgets.dart';
import 'package:loyaltri_minimal/View/field/features/tracking/tracker_controller.dart';
import 'package:loyaltri_minimal/controller/locationFetchController.dart';
import 'package:loyaltri_minimal/controller/punchTypeController.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../controller/attendanceUploadController.dart';
import '../../../controller/userAuthentication.dart';
import '../../../controller/userProfileController.dart';
import '../../../models/checkIn_model.dart';
import '../../../models/punch_type_model.dart';
import '../../../services/flutter_secure_storage.dart';
import '../../../utils/color_utils.dart';
import '../../CWidgets/error_dialog.dart';
import '../../Work_Entry/work_entry_widgets/alert_dialogue.dart';
import '../../menu_page.dart';
import '../Camera_View.dart';

class MapCheckInWidget extends StatelessWidget {
  final String whichCheck;
  final bool isCheckIn;
  final Position? position;
  final bool geoSelfie;
  const MapCheckInWidget({super.key, required this.whichCheck, required this.isCheckIn, this.position, required this.geoSelfie});

  @override
  Widget build(BuildContext context) {
    List<LocationGeoFencing>? locationGeoFencing = Get.find<PunchTypeController>().punchType.value.result.locationGeoFencing;
    int notInside = 0;
    String lastUpdated = '--';
    if(locationGeoFencing != null && locationGeoFencing.isNotEmpty && position?.latitude != null && position?.longitude != null) {
      for(LocationGeoFencing locData in locationGeoFencing) {
        if(locData.northLat != null && locData.southLat != null && locData.eastLong != null && locData.westLong != null) {
          final double? north = double.tryParse(locData.northLat ?? '');
          final double? south = double.tryParse(locData.southLat ?? '');
          final double? east = double.tryParse(locData.eastLong ?? '');
          final double? west = double.tryParse(locData.westLong ?? '');
          if (north != null && south != null && east != null && west != null) {
            if ((position!.latitude < north) &&
                (position!.latitude > south) &&
                (position!.longitude < east) &&
                (position!.longitude > west)) {
              notInside = 1;
              break;
            }
          }
        }
      }
    }
    if(position?.latitude != null && position?.longitude != null) {
      try {
        lastUpdated = DateFormat('hh:mm:ss a').format(position!.timestamp.toLocal());
      } catch(e) {}
    }
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(15).r,
              onTap: () async {
                context.loaderOverlay.show();
                await Get.find<LocationFetchController>().fetchLocationData();
                context.loaderOverlay.hide();
              },
              child: Container(
                padding: EdgeInsets.all(10).h,
                decoration:
                BoxDecoration(
                  color: ColorUtils.workEntryHead.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(15).r,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/refresh-icon.png',
                      height: 12.h,
                    ),
                    SizedBox(width: 8.h),
                    Text(
                      'Refresh',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w300,
                        color: ColorUtils.textWhite,
                        fontSize: 11.h,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 5.h),
          ],
        ),
        SizedBox(height: 10.h),
        Container(
          // height: 223.h,
          padding: EdgeInsets.all(14.0),
          decoration: BoxDecoration(
            color: ColorUtils.backgroundBlack,
            borderRadius: BorderRadius.circular(20).r,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset(
                    notInside == 1 ? 'assets/images/check-icon.png' : 'assets/images/alert-icon.png',
                    height: 24.h,
                  ),
                  SizedBox(width: 2.h),
                  Expanded(
                    child: Text(
                      notInside == 1 ? 'Ready to punch' : 'Outside Check ${isCheckIn ? 'In' : "Out"} Zone',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: ColorUtils.textWhite,
                        fontSize: 17.h,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              Row(
                children: [
                  SizedBox(width: 4.h),
                  Text(
                    notInside == 1 ? 'You are within the allowed radius' : 'Move closer to the zone',
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      color: ColorUtils.textWhite,
                      fontSize: 11.h,
                    ),
                  ),
                ],
              ),
              if(notInside == 0)
                SizedBox(height: 15.h),
              if(notInside == 0)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/images/manager_view/edit_att_time.svg',
                      colorFilter: ColorFilter.mode(ColorUtils.textWhite, BlendMode.srcIn),
                      height: 14.h,
                    ),
                    SizedBox(width: 8.h),
                    Flexible(
                      child: Text(
                        'Waiting for you to reach the punch zone',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          color: ColorUtils.textWhite,
                          fontSize: 11.h,
                        ),
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 13.h),
              InkWell(
                onTap: () async {
                  if(notInside == 1 && geoSelfie) {
                    Navigator.of(context).push(
                      newSlideNavigation(CameraCheckInView(whichCheck: isCheckIn ? "Check In" : "Check Out", isCheckIn: isCheckIn, showTimer: true)),
                    );
                  } else if(notInside == 1 && !geoSelfie) {
                    try {
                      context.loaderOverlay.show();
                      DateTime punchDate = DateTime.now();
                      final SecureStorageUtils prefs = SecureStorageUtils();
                      String? punchTime = await prefs.getString("punch");
                      AttendanceCheckModel attData =
                      AttendanceCheckModel(
                        employeeId: Get.find<UserAuthController>()
                            .userData.value.userData?.employeeId ?? '--',
                        companyId: Get.find<UserProfileController>().userData.value.result.companyId?.toString() ?? '',
                        punchDate: DateFormat('yyyy-MM-dd')
                            .format(punchDate),
                        punchTime:
                        DateFormat('HH:mm:ss').format(punchDate),
                        latitude: position?.latitude.toString() ?? '',
                        longitude: position?.longitude.toString() ?? '',
                        locationName: Get.find<LocationFetchController>().locName.value ?? '',
                        punchState: isCheckIn ? "punchIn" : "punchOut",
                      );
                      await Get.find<AttendanceUploadController>()
                          .sendAttendance(attendance: attData);
                          final trackingCtr = Get.isRegistered<TrackingController>()
                                                        ? Get.find<TrackingController>()
                                                         : Get.put(TrackingController());
                                          final workStatus =await  trackingCtr.checkEmployeWorkStatus();
                                          if(workStatus){
                                            context.loaderOverlay.hide();
                                            return;
                                          }
                      if (Get.find<AttendanceUploadController>()
                          .errorMsg.value == null) {
                        if(punchTime != null) {
                          await prefs.remove('punch');
                        }
                        if (punchTime != null) {
                          // await prefs.remove("punch");
                          ShowWarnDialog().showWarn(
                              context: context,
                              whichCheck: isCheckIn ? "Check In" : "Check Out");
                          await HapticFeedback.lightImpact();
                          Timer.periodic(const Duration(seconds: 3),
                                  (timer) {
                                timer.cancel();
                                // _cameraController.dispose();
                                Navigator.of(context).pushAndRemoveUntil(
                                  newSlideNavigation(const MenuPage(afterCheck: true)),
                                        (route) => false);
                              });
                        } else {
                          // await prefs.setString(
                          //     "punch", "$punchDate");
                          ShowWarnDialog().showWarn(
                              context: context,
                              whichCheck: isCheckIn ? "Check In" : "Check Out");
                          await HapticFeedback.lightImpact();
                          Timer.periodic(const Duration(seconds: 3),
                                  (timer) {
                                timer.cancel();
                                // _cameraController.dispose();
                                Navigator.of(context).pushAndRemoveUntil(
                                  newSlideNavigation(const MenuPage(afterCheck: true)),
                                        (route) => false);
                              });
                        }
                      } else {
                        await HapticFeedback.lightImpact();
                        String? msg = Get.find<AttendanceUploadController>().errorMsg.value == 'msg' ? "${punchTime == null ? 'Check in' : 'Check out'} is not allowed within 3 minutes after ${punchTime == null ? 'checkout' : 'check in'}. Please try again later." : null;
                        ErrorDialog().showWarn(
                            context: context,
                            title: punchTime == null
                                ? "Check In Failed!"
                                : "Check Out Failed!",
                            subTitle: msg ?? "Something went wrong");
                      }
                    } catch(e) {} finally {
                      context.loaderOverlay.hide();
                    }
                  }
                },
                child: Container(
                  height: 54.h,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xFF794DFD),
                      width: 1.h,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(43)).r,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        ColorUtils.secondaryBlue.withValues(alpha: notInside == 1 ? 1.0 : 0.2),
                        const Color(0xFF6434ED).withValues(alpha: notInside == 1 ? 1.0 : 0.2),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      isCheckIn ? 'Check in' : 'Check out',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        color: ColorUtils.textWhite.withValues(alpha: notInside == 1 ? 1.0 : 0.2),
                        fontSize: 15.h,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Divider(
                color: ColorUtils.textWhite.withValues(alpha: 0.1),
                thickness: 1.h,
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  SizedBox(width: 3.h),
                  Expanded(
                    child: Text(
                      'Last Updated: $lastUpdated',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        color: ColorUtils.textWhite,
                        fontSize: 11.h,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 7.h,
                        height: 7.h,
                        decoration: BoxDecoration(
                          color: notInside == 1 ? Color(0xFF19B500) : Color(0xFFD90202),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 3.h),
                      Text(
                        notInside == 1 ? 'In range' : 'Out of range',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          color: ColorUtils.textWhite,
                          fontSize: 11.h,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 3.h),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
