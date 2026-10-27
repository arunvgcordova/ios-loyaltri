import 'dart:async';
import 'dart:io';

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
import 'package:loyaltri_minimal/View/Home_Page/Map_View.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/View/field/features/tracking/tracker_controller.dart';
import 'package:loyaltri_minimal/View/field/features/widgets/location_always_permission_dialog.dart';
import 'package:loyaltri_minimal/View/field/features/widgets/physicalActivityPermissionDialog.dart';
import 'package:loyaltri_minimal/controller/locationFetchController.dart';
import 'package:loyaltri_minimal/controller/punchTypeController.dart';
import 'package:loyaltri_minimal/controller/ui_controller/home_controller.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';
import 'package:loyaltri_minimal/models/punch_type_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controller/attendanceUploadController.dart';
import '../../../controller/userAuthentication.dart';
import '../../../models/checkIn_model.dart';
import '../../../services/connectivity_service.dart';
import '../../../services/flutter_secure_storage.dart';
import '../../../services/ui_model_services/check_type_model.dart';
import '../../../services/warning_message.dart';
import '../../../utils/color_utils.dart';
import '../../CWidgets/error_dialog.dart';
import '../../Work_Entry/work_entry_widgets/alert_dialogue.dart';
import '../../menu_page.dart';
import '../Camera_View.dart';
import '../QR_View.dart';

chooseCheckTypeBottomSheet(
    {required BuildContext mainContext, required bool isIn}) {
  showModalBottomSheet(
    context: mainContext,
    backgroundColor: Colors.black,
    barrierColor: ColorUtils.workEntryHead.withOpacity(0.81),
    builder: (BuildContext context) {
      return SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(15.0).w,
          child: Container(
            width: ScreenUtil().screenWidth,
            // height: 200.w,
            decoration: BoxDecoration(
              color: ColorUtils.backgroundBlack,
              borderRadius: BorderRadius.circular(20).w,
              border: Border.all(
                width: 1.w,
                color: ColorUtils.sheetBorder,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Flexible(flex: 1, child: Container()),
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 10, bottom: 10).w,
                  child: Row(
                    children: [
                      Text(
                        "Choose your ${isIn ? "Check In" : "Check Out"}",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 18.sp,
                          color: ColorUtils.textWhite,
                        ),
                      ),
                    ],
                  ),
                ),
                // Flexible(flex: 2, child: Container()),
                Padding(
                  padding: const EdgeInsets.all(4.0).w,
                  child: GetX<PunchTypeController>(
                    builder: (PunchTypeController controller) {
                      if(controller.checkInMethods.isNotEmpty) {
                        return SizedBox(
                          height: 120.w,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: isIn ? controller.checkInMethods.length : controller.checkOutMethods.length,
                            itemBuilder: (context, index) {
                              CheckType type = isIn ? controller.checkInMethods[index] : controller.checkOutMethods[index];
                              return Padding(
                                padding: const EdgeInsets.all(4.0).w,
                                child: GestureDetector(
                                  onTap: () async {
                                    bool fieldAccess = Get.find<UserAuthController>().fieldAccess.value;
                                    if(fieldAccess && Platform.isAndroid) {
                                     final canStart = await ActivityPermissionHelper.checkAndRequestPermission();
                                     final location =   await LocationAlwaysPermissionHelper.checkAndRequestPermission(context: context);
                                     if(!canStart || !location) {
                                      return;
                                     }
                                    }
                                    context.loaderOverlay.show();
                                    // bool connection = await ConnectivityService().check();
                                    // if(!connection) {
                                    //   context.loaderOverlay.hide();
                                    //   Navigator.of(context).pop();
                                    //   await ErrorDialog().internetWarn(
                                    //     context: mainContext,
                                    //     title: "No Internet Connection",
                                    //     subTitle: "Please check if your connection is stable.",
                                    //   );
                                    // } else {
                                      if(type.typeId == 5 || type.typeId == 4) {
                                        // Navigator.of(context).pop();
                                        DateTime punchDate = DateTime.now();
                                        final SecureStorageUtils prefs = SecureStorageUtils();
                                        LocationFetchController locationFetch = Get.find<LocationFetchController>();
                                        String? latitude = locationFetch.position.value?.latitude.toString();
                                        String? longitude = locationFetch.position.value?.longitude.toString();
                                        String? locName = locationFetch.locName.value;

                                        AttendanceCommonWidgets().printF("-----kkk-------($latitude, $longitude)");

                                        try {
                                          if((latitude == null || latitude == 'null') && (longitude == null || longitude == 'null')) {
                                            Position? position = await locationFetch.fetchCurrentLocation();
                                            latitude = position?.latitude.toString();
                                            longitude = position?.longitude.toString();
                                          }

                                          if(locName == null) {
                                            String? locationName = await locationFetch.fetchCurrentLocName(lat: latitude!, long: longitude!);
                                            locName = locationName;
                                          }
                                        } catch(e) {} finally {}

                                        // await locationFetch.fetchLocationData();
                                        if(latitude != null && longitude != null) {
                                          String? punchTime = await prefs.getString("punch");
                                          if(type.typeId == 4) {
                                            context.loaderOverlay.hide();
                                            Navigator.of(context).pop();
                                            Navigator.of(context).push(
                                              newSlideNavigation(MapCheckInView(whichCheck: isIn ? "Check In" : "Check Out", isCheckIn: isIn, geoSelfie: false)),
                                    );
                                            // List<LocationGeoFencing>? locationGeoFencing = controller.punchType.value.result.locationGeoFencing;
                                            // if(locationGeoFencing != null && locationGeoFencing.isNotEmpty) {
                                            //   int notInside = 0;
                                            //   for(LocationGeoFencing locData in locationGeoFencing) {
                                            //     if(locData.northLat != null && locData.southLat != null && locData.eastLong != null && locData.westLong != null) {
                                            //       if((double.parse(latitude) < double.parse(locData.northLat!)) &&
                                            //           (double.parse(latitude) > double.parse(locData.southLat!)) &&
                                            //           (double.parse(longitude) < double.parse(locData.eastLong!)) &&
                                            //           (double.parse(longitude) > double.parse(locData.westLong!))) {
                                            //         notInside = 1;
                                            //         context.loaderOverlay.hide();
                                            //         Navigator.of(context).pop();
                                            //         Navigator.of(context).push(MaterialPageRoute(
                                            //             builder: (context) =>
                                            //                 MapCheckInView(whichCheck: isIn ? "Check In" : "Check Out", isCheckIn: isIn)));
                                            //         AttendanceCheckModel attData =
                                            //         AttendanceCheckModel(
                                            //           employeeId: Get.find<UserAuthController>()
                                            //               .userData.value.userData?.employeeId ?? '--',
                                            //           companyId: Get.find<UserProfileController>().userData.value.result.companyId?.toString() ?? '',
                                            //           punchDate: DateFormat('yyyy-MM-dd')
                                            //               .format(punchDate),
                                            //           punchTime:
                                            //           DateFormat('HH:mm:ss').format(punchDate),
                                            //           latitude: latitude,
                                            //           longitude: longitude,
                                            //           locationName: locName,
                                            //           punchState: isIn ? "punchIn" : "punchOut",
                                            //         );
                                            //         await Get.find<AttendanceUploadController>()
                                            //             .sendAttendance(attendance: attData);
                                            //         if (Get.find<AttendanceUploadController>()
                                            //             .errorMsg.value == null) {
                                            //           context.loaderOverlay.hide();
                                            //           if (punchTime != null) {
                                            //             // await prefs.remove("punch");
                                            //             ShowWarnDialog().showWarn(
                                            //                 context: context,
                                            //                 whichCheck: isIn ? "Check In" : "Check Out");
                                            //             await HapticFeedback.lightImpact();
                                            //             Timer.periodic(const Duration(seconds: 3),
                                            //                     (timer) {
                                            //                   timer.cancel();
                                            //                   // _cameraController.dispose();
                                            //                   Navigator.of(context).pushAndRemoveUntil(
                                            //                       MaterialPageRoute(
                                            //                           builder: (context) =>
                                            //                           const MenuPage()),
                                            //                           (route) => false);
                                            //                 });
                                            //           } else {
                                            //             // await prefs.setString(
                                            //             //     "punch", "$punchDate");
                                            //             ShowWarnDialog().showWarn(
                                            //                 context: context,
                                            //                 whichCheck: isIn ? "Check In" : "Check Out");
                                            //             await HapticFeedback.lightImpact();
                                            //             Timer.periodic(const Duration(seconds: 3),
                                            //                     (timer) {
                                            //                   timer.cancel();
                                            //                   // _cameraController.dispose();
                                            //                   Navigator.of(context).pushAndRemoveUntil(
                                            //                       MaterialPageRoute(
                                            //                           builder: (context) =>
                                            //                           const MenuPage()),
                                            //                           (route) => false);
                                            //                 });
                                            //           }
                                            //         } else {
                                            //           context.loaderOverlay.hide();
                                            //           await HapticFeedback.lightImpact();
                                            //           String? msg = Get.find<AttendanceUploadController>().errorMsg.value;
                                            //           ErrorDialog().showWarn(
                                            //               context: context,
                                            //               title: punchTime == null
                                            //                   ? "Check In Failed!"
                                            //                   : "Check Out Failed!",
                                            //               subTitle: msg ?? "Something went wrong");
                                            //         }
                                            //         break;
                                            //       }
                                            //     } else {
                                            //       notInside = 1;
                                            //       context.loaderOverlay.hide();
                                            //       ErrorDialog().showWarn(
                                            //           context: context,
                                            //           title: punchTime == null
                                            //               ? "Check In Failed!"
                                            //               : "Check Out Failed!",
                                            //           subTitle: "Location is not assigned to you.");
                                            //       break;
                                            //     }
                                            //   }
                                            //   context.loaderOverlay.hide();
                                            //   if(notInside == 0) {
                                            //     print("-----double tap-----");
                                            //     context.loaderOverlay.hide();
                                            //     ErrorDialog().showWarn(
                                            //         context: context,
                                            //         title: punchTime == null
                                            //             ? "Check In Failed!"
                                            //             : "Check Out Failed!",
                                            //         subTitle: "You are outside the boundary.");
                                            //   }
                                            // } else {
                                            //   context.loaderOverlay.hide();
                                            //   ErrorDialog().showWarn(
                                            //       context: context,
                                            //       title: punchTime == null
                                            //           ? "Check In Failed!"
                                            //           : "Check Out Failed!",
                                            //       subTitle: "Location is not assigned to you.");
                                            // }
                                          } else {
                                            AttendanceCheckModel attData =
                                            AttendanceCheckModel(
                                              employeeId: Get.find<UserAuthController>()
                                                  .userData.value.userData?.employeeId ?? '--',
                                              companyId: Get.find<UserProfileController>().userData.value.result.companyId?.toString() ?? '',
                                              punchDate: DateFormat('yyyy-MM-dd')
                                                  .format(punchDate),
                                              punchTime:
                                              DateFormat('HH:mm:ss').format(punchDate),
                                              latitude: latitude,
                                              longitude: longitude,
                                              locationName: locName,
                                              punchState: isIn ? "punchIn" : "punchOut",
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
                                            if (punchTime != null) {
                                              await prefs.remove("punch");
                                            }
                                              context.loaderOverlay.hide();
                                              if (punchTime != null) {
                                                ShowWarnDialog().showWarn(
                                                    context: context,
                                                    whichCheck: isIn ? "Check In" : "Check Out");
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
                                                    whichCheck: isIn ? "Check In" : "Check Out");
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
                                              context.loaderOverlay.hide();
                                              await HapticFeedback.lightImpact();
                                              String? msg = Get.find<AttendanceUploadController>().errorMsg.value == 'msg' ? "${punchTime == null ? 'Check in' : 'Check out'} is not allowed within 3 minutes after ${punchTime == null ? 'checkout' : 'check in'}. Please try again later." : null;
                                              ErrorDialog().showWarn(
                                                  context: context,
                                                  title: punchTime == null
                                                      ? "Check In Failed!"
                                                      : "Check Out Failed!",
                                                  subTitle: msg ?? "Something went wrong");
                                            }
                                          }
                                        } else {
                                          context.loaderOverlay.hide();
                                          await ErrorDialog().showWarn(context: context, title: "Failed", subTitle: "Location data not fetched.").then((value) async {
                                            await locationFetch.initialize();
                                          });
                                        }
                                        // Navigator.of(context).push(MaterialPageRoute(
                                        //     builder: (context) => QRCheckInView(whichCheck: whichCheck)));
                                      } else if(type.typeId == 3) {
                                        context.loaderOverlay.hide();
                                        Navigator.of(context).pop();
                                        Navigator.of(context).push(
                                          newSlideNavigation(CameraCheckInView(whichCheck: isIn ? "Check In" : "Check Out", isCheckIn: isIn, showTimer: false)),
                                        );
                                      } else if(type.typeId == 6) {
                                        context.loaderOverlay.hide();
                                        Navigator.of(context).pop();
                                        Navigator.of(context).push(
                                          newSlideNavigation(QRCheckInView(whichCheck: isIn ? "Check In" : "Check Out", isCheckIn: isIn)),
                                        );
                                      } else if(type.typeId == 9) {
                                        context.loaderOverlay.hide();
                                        Navigator.of(context).pop();
                                        Navigator.of(context).push(
                                          newSlideNavigation(MapCheckInView(whichCheck: isIn ? "Check In" : "Check Out", isCheckIn: isIn, geoSelfie: true)),
                                        );
                                      } else {
                                        context.loaderOverlay.hide();
                                      }
                                    // }
                                  },
                                  child: Container(
                                    width: 155.w,
                                    height: 111.w,
                                    padding: const EdgeInsets.all(10.0).w,
                                    decoration: BoxDecoration(
                                      color: ColorUtils.foregroundBlack,
                                      borderRadius: BorderRadius.circular(15).w,
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(vertical: type.iconType == CustomImageType.webm ? 0 : 8).w,
                                          child: Row(
                                            children: [
                                              if(type.typeId == 4)
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(8).r,
                                                  child: Image.asset(
                                                    type.icon,
                                                    width: 30.w,
                                                  ),
                                                ),
                                              if(type.typeId != 4)
                                                type.iconType == CustomImageType.svg
                                                    ? SvgPicture.asset(type.icon, width: 25.w)
                                                    : Image.asset(type.icon, width: 40.w),
                                            ],
                                          ),
                                        ),
                                        if(type.typeId == 4)
                                          const Spacer(),
                                        Row(
                                          children: [
                                            Text(
                                              type.title,
                                              style: GoogleFonts.inter(
                                                color: ColorUtils.textWhite,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              constraints: BoxConstraints(
                                                maxWidth: 131.w,
                                              ),
                                              child: Text(
                                                type.subTitle,
                                                style: GoogleFonts.inter(
                                                  color: ColorUtils.textWhite.withOpacity(0.5),
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 10.sp,
                                                ),
                                              ),
                                            ),
                                            // GetX<AttendanceUploadController>(
                                            //   builder: (AttendanceUploadController controller) {
                                            //     if(controller.isLoading.value) {
                                            //       context.loaderOverlay.show();
                                            //     } else {
                                            //       context.loaderOverlay.hide();
                                            //     }
                                            //     if(type.typeId == 5 && controller.isLoading.value) {
                                            //       return Padding(
                                            //         padding: const EdgeInsets.only(left: 5).w,
                                            //         child: SizedBox(
                                            //           width: 10.w,
                                            //           height: 10.w,
                                            //           child: CircularProgressIndicator(
                                            //             strokeWidth: 2.w,
                                            //           ),
                                            //         ),
                                            //       );
                                            //     } else {
                                            //       return Container();
                                            //     }
                                            //   },
                                            // ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return Container(height: 120.w);
                      }
                    },
                  ),
                ),
                // Flexible(flex: 1, child: Container()),
              ],
            ),
          ),
        ),
      );
    },
  );
}
