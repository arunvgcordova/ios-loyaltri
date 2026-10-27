import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/controller/attSummaryController.dart';
import 'package:loyaltri_minimal/controller/attendanceListController.dart';
import 'package:loyaltri_minimal/controller/locationFetchController.dart';
import 'package:loyaltri_minimal/controller/ui_controller/home_controller.dart';
import 'package:loyaltri_minimal/controller/userAuthentication.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';
import 'package:loyaltri_minimal/controller/ui_controller/page_controller.dart';

import '../../controller/attendanceUploadController.dart';
import '../../models/checkIn_model.dart';
import '../../services/connectivity_service.dart';
import '../../sqflite_db/punch_db.dart';
import '../../utils/color_utils.dart';
import '../splash.dart';

class ErrorDialog {
  Future<bool?> showWarn({
    required BuildContext context,
    String? title,
    String? subTitle,
  }) async {
    return await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: false,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: PopScope(
            canPop: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 35.h,
                  ),
                  child: Container(
                    padding: EdgeInsets.all(1.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(29.0).w,
                      color: const Color(0xFF666666),
                    ),
                    child: AlertDialog(insetPadding: EdgeInsets.zero,
                      backgroundColor: ColorUtils.backgroundBlack,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28.0).w,
                        // side: BorderSide(
                        //   color: const Color(0xFF666666),
                        //   width: 1.w,
                        // ),
                      ),
                      title: Padding(
                        padding: EdgeInsets.only(
                          right: 10.h,
                        ),
                        child: Image.asset(
                          "assets/images/error_msg.png",
                          // width: 10.h,
                          height: 60.h,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      // titlePadding: EdgeInsets.zero,
                      // contentPadding: EdgeInsets.zero,
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if(title != null)
                            Text(
                              title,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 16.sp,
                                color: ColorUtils.textWhite,
                              ),
                            ),
                          if(title != null)
                            SizedBox(height: 6.h),
                          if(subTitle != null)
                            Text(
                              subTitle,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 12.sp,
                                color: ColorUtils.textWhite.withValues(alpha: 0.4),
                              ),
                            ),
                        ],
                      ),
                      actions: [
                        Container(
                          width: ScreenUtil().screenWidth,
                          height: 50.w,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ColorUtils.foregroundBlack,
                                elevation: 0),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0).w,
                                  child: Icon(
                                    Icons.close,
                                    color: ColorUtils.textWhite,
                                    size: 15.w,
                                  ),
                                ),
                                Text(
                                  "Close",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13.sp,
                                    color: ColorUtils.textWhite,
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
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool?> showWarnManager({
    required BuildContext context,
    String? title,
    String? subTitle,
  }) async {
    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: false,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: PopScope(
            canPop: false,
            child: AlertDialog(
              backgroundColor: ColorUtils.textWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(29.0).w,
                // side: BorderSide(
                //   color: const Color(0xFF666666),
                //   width: 1.w,
                // ),
              ),
              title: Image.asset(
                "assets/images/error_msg.png",
                // width: 10.w,
                height: 60.w,
                fit: BoxFit.fitHeight,
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title ?? "",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                      color: ColorUtils.workEntryHead,
                    ),
                  ),
                  Text(
                    subTitle ?? "",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 12.sp,
                      color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
              actions: [
                Container(
                  width: ScreenUtil().screenWidth,
                  height: 50.w,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ColorUtils.foregroundBlack.withValues(alpha: 0.5),
                        elevation: 0),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0).w,
                          child: Icon(
                            Icons.close,
                            color: ColorUtils.textWhite,
                            size: 15.w,
                          ),
                        ),
                        Text(
                          "Close",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 13.sp,
                            color: ColorUtils.textWhite,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool?> internetWarn({
    required BuildContext context,
    String? title,
    String? subTitle,
    required Function() onPressed,
  }) async {
    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: "",
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          // child: PopScope(
          //   canPop: false,
          child: AlertDialog(
            backgroundColor: ColorUtils.backgroundBlack,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(29.0).w,
              side: BorderSide(
                color: const Color(0xFF666666),
                width: 1.w,
              ),
            ),
            title: Icon(
              Icons.warning_amber,
              color: Colors.orangeAccent,
              size: 40.h,
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title ?? "",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                    color: ColorUtils.textWhite,
                  ),
                ),
                Text(
                  subTitle ?? "",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 12.sp,
                    color: ColorUtils.textWhite.withOpacity(0.4),
                  ),
                ),
              ],
            ),
            actions: [
              Container(
                width: ScreenUtil().screenWidth,
                height: 50.w,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ColorUtils.primaryBlue, elevation: 0),
                  onPressed: () {
                    onPressed();
                    // Navigator.of(context).pushAndRemoveUntil(
                    //     MaterialPageRoute(
                    //         builder: (context) => const SplashScreen()),
                    //     (route) => false);
                  },
                  child: Text(
                    'Try Again...',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 13.sp,
                      color: ColorUtils.textWhite,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // ),
        );
      },
    );
  }

  Future<Future> submitDialogue({
    String? title,
    String? subTitle,
  }) async {
    return Get.dialog(
      PopScope(
        canPop: false,
        child: AlertDialog(
          backgroundColor: ColorUtils.backgroundBlack,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(29.0).w,
            side: BorderSide(
              color: const Color(0xFF666666),
              width: 1.w,
            ),
          ),
          title: Image.asset(
            "assets/images/error_msg.png",
            // width: 10.w,
            height: 60.w,
            fit: BoxFit.fitHeight,
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title ?? "",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp,
                  color: ColorUtils.textWhite,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                subTitle ?? "",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 12.sp,
                  color: ColorUtils.textWhite.withOpacity(0.4),
                ),
              ),
            ],
          ),
          actions: [
            Container(
              width: ScreenUtil().screenWidth,
              height: 50.w,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: ColorUtils.foregroundBlack, elevation: 0),
                onPressed: () {
                  Get.back();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0).w,
                      child: Icon(
                        Icons.close,
                        color: ColorUtils.textWhite,
                        size: 15.w,
                      ),
                    ),
                    Text(
                      "Close",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 13.sp,
                        color: ColorUtils.textWhite,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> syncPopUp({
    String? title,
    required BuildContext mainContext,
  }) async {
    ValueNotifier<bool> isLoading = ValueNotifier(false);
    await showGeneralDialog<bool>(
      context: mainContext,
      barrierDismissible: false,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: PopScope(
            canPop: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 35.h,
                  ),
                  child: Container(
                    padding: EdgeInsets.all(1.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(29.0).w,
                      color: const Color(0xFF666666),
                    ),
                    child: AlertDialog(insetPadding: EdgeInsets.zero,
                      backgroundColor: ColorUtils.backgroundBlack,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28.0).w,
                      ),
                      title: Text(
                        title ?? "",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                          color: ColorUtils.textWhite,
                        ),
                      ),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ValueListenableBuilder(
                            valueListenable: isLoading,
                            builder: (context, value, child) {
                              return Container(
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  onPressed: () async {
                                    bool connection = await ConnectivityService().check();
                                    if(!connection) {
                                      await ErrorDialog().internetWarn(
                                        context: mainContext,
                                        title: "No Internet Connection",
                                        subTitle: "Please check if your connection is stable.",
                                        onPressed: () {
                                          Navigator.of(mainContext).pop();
                                        },
                                      );
                                    } else {
                                      // Navigator.of(context).pop();
                                      try {
                                        isLoading.value = true;
                                        await Get.find<AttendanceUploadController>().sendAttendance();
                                        // String companyId = Get.find<UserProfileController>().userData.value.result.companyId.toString();
                                        // String employeeId = Get.find<UserAuthController>().userData.value.userData?.employeeId ?? '--';
                                        await Get.find<HomeController>().getHomeData(context);
                                        // Get.find<AttendanceList>().fetchAttendanceList(empId: employeeId, compId: companyId);
                                        // Get.find<AttendanceSummaryController>().getAttendanceSummary(empId: employeeId, compId: companyId);
                                        Timer.periodic(const Duration(milliseconds: 500), (timer) {
                                          if(!isLoading.value) {
                                            timer.cancel();
                                            context.loaderOverlay.hide();
                                            if(context.mounted) Navigator.of(context).pop();
                                          }
                                        });
                                      } catch(e) {
                                        AttendanceCommonWidgets().printF("--------upload error---------${e.toString()}");
                                      } finally {
                                        isLoading.value = false;
                                      }
                                    }
                                  },
                                  icon: SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: value ?
                                    const CircularProgressIndicator(color: Colors.white)
                                        : const Icon(Icons.sync, color: Colors.white),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      actions: [
                        Container(
                          width: ScreenUtil().screenWidth,
                          height: 50.w,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ColorUtils.foregroundBlack,
                                elevation: 0),
                            onPressed: () {
                              Navigator.of(mainContext).pop();
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0).w,
                                  child: Icon(
                                    Icons.close,
                                    color: ColorUtils.textWhite,
                                    size: 15.w,
                                  ),
                                ),
                                Text(
                                  "Close",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13.sp,
                                    color: ColorUtils.textWhite,
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
              ],
            ),
          ),
        );
      },
    );
    // return Get.dialog(
    //   PopScope(
    //     canPop: false,
    //     child: StatefulBuilder(
    //       builder: (BuildContext context, void Function(void Function()) setState) {
    //         ValueNotifier<bool> isLoading = ValueNotifier(false);
    //         return AlertDialog(
    //           backgroundColor: ColorUtils.backgroundBlack,
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(29.0).w,
    //             side: BorderSide(
    //               color: const Color(0xFF666666),
    //               width: 1.w,
    //             ),
    //           ),
    //           // title: Text(
    //           //   title ?? "",
    //           //   style: GoogleFonts.poppins(
    //           //     fontWeight: FontWeight.w500,
    //           //     fontSize: 16.sp,
    //           //     color: ColorUtils.textWhite,
    //           //   ),
    //           // ),
    //           content: Column(
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             mainAxisSize: MainAxisSize.min,
    //             children: [
    //               Text(
    //                 title ?? "",
    //                 textAlign: TextAlign.center,
    //                 style: GoogleFonts.poppins(
    //                   fontWeight: FontWeight.w500,
    //                   fontSize: 16.sp,
    //                   color: ColorUtils.textWhite,
    //                 ),
    //               ),
    //               SizedBox(height: 8.h),
    //               ValueListenableBuilder(
    //                   valueListenable: isLoading,
    //                   builder: (context, value, child) {
    //                     return Container(
    //                       decoration: const BoxDecoration(
    //                         color: Colors.red,
    //                         shape: BoxShape.circle,
    //                       ),
    //                       child: IconButton(
    //                         onPressed: () async {
    //                           bool connection = await ConnectivityService().check();
    //                           if(!connection) {
    //                             await ErrorDialog().internetWarn(
    //                               context: mainContext,
    //                               title: "No Internet Connection",
    //                               subTitle: "Please check if your connection is stable.",
    //                               onPressed: () {
    //                                 Navigator.of(mainContext).pop();
    //                               },
    //                             );
    //                           } else {
    //                             // Navigator.of(context).pop();
    //                             try {
    //                               isLoading.value = true;
    //                               await Get.find<AttendanceUploadController>().sendAttendance();
    //                               // String companyId = Get.find<UserProfileController>().userData.value.result.companyId.toString();
    //                               // String employeeId = Get.find<UserAuthController>().userData.value.userData?.employeeId ?? '--';
    //                               await Get.find<HomeController>().getHomeData(context);
    //                               // Get.find<AttendanceList>().fetchAttendanceList(empId: employeeId, compId: companyId);
    //                               // Get.find<AttendanceSummaryController>().getAttendanceSummary(empId: employeeId, compId: companyId);
    //                               Timer.periodic(const Duration(milliseconds: 500), (timer) {
    //                                 if(!isLoading.value) {
    //                                   timer.cancel();
    //                                   context.loaderOverlay.hide();
    //                                   if(context.mounted) Navigator.of(context).pop();
    //                                 }
    //                               });
    //                             } catch(e) {
    //                               AttendanceCommonWidgets().printF("--------upload error---------${e.toString()}");
    //                             } finally {
    //                               isLoading.value = false;
    //                             }
    //                           }
    //                         },
    //                         icon: SizedBox(
    //                           width: 30,
    //                           height: 30,
    //                           child: value ?
    //                           const CircularProgressIndicator(color: Colors.white)
    //                               : const Icon(Icons.sync, color: Colors.white),
    //                         ),
    //                       ),
    //                     );
    //                   },
    //               ),
    //               // Text(
    //               //   subTitle ?? "",
    //               //   textAlign: TextAlign.center,
    //               //   style: GoogleFonts.poppins(
    //               //     fontWeight: FontWeight.w500,
    //               //     fontSize: 12.sp,
    //               //     color: ColorUtils.textWhite.withOpacity(0.4),
    //               //   ),
    //               // ),
    //             ],
    //           ),
    //           actions: [
    //             Container(
    //               width: ScreenUtil().screenWidth,
    //               height: 50.w,
    //               child: ElevatedButton(
    //                 style: ElevatedButton.styleFrom(
    //                     backgroundColor: ColorUtils.foregroundBlack, elevation: 0),
    //                 onPressed: () {
    //                   Get.back();
    //                 },
    //                 child: Row(
    //                   mainAxisSize: MainAxisSize.min,
    //                   children: [
    //                     Padding(
    //                       padding: const EdgeInsets.all(8.0).w,
    //                       child: Icon(
    //                         Icons.close,
    //                         color: ColorUtils.textWhite,
    //                         size: 15.w,
    //                       ),
    //                     ),
    //                     Text(
    //                       "Close",
    //                       style: GoogleFonts.poppins(
    //                         fontWeight: FontWeight.w500,
    //                         fontSize: 13.sp,
    //                         color: ColorUtils.textWhite,
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ],
    //         );
    //       },
    //     ),
    //   ),
    // );
  }

  Future<Future> permissionDialogue({
    String? title,
    String? subTitle,
    Function? okFunction,
    Function? cancelFunction,
  }) async {
    final isManager = Get.find<UserPageController>().appView.value == AppView.manager;

    return Get.dialog(
      PopScope(
        canPop: false,
        child: AlertDialog(
          backgroundColor: isManager ? ColorUtils.textWhite : ColorUtils.backgroundBlack,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(29.0).w,
            side: isManager
                ? BorderSide.none
                : BorderSide(
              color: const Color(0xFF666666),
              width: 1.w,
            ),
          ),
          title: Icon(
            Icons.warning_amber,
            color: Colors.orangeAccent,
            size: 40.h,
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title ?? "",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp,
                  color: isManager ? ColorUtils.workEntryHead : ColorUtils.textWhite,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                subTitle ?? "",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 12.sp,
                  color: isManager
                      ? ColorUtils.workEntryHead.withValues(alpha: 0.5)
                      : ColorUtils.textWhite.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40.w,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6A4BFC),
                        elevation: 0),
                    onPressed: () async {
                      if (okFunction != null) {
                        await okFunction();
                      }
                    },
                    child: Text(
                      "Settings",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 13.sp,
                        color: ColorUtils.textWhite,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  height: 40.w,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: isManager ? const Color(0xFFE5E5E5) : ColorUtils.foregroundBlack,
                        elevation: 0),
                    onPressed: () async {
                      if (cancelFunction != null) {
                        await cancelFunction();
                      }
                    },
                    child: (subTitle?.toLowerCase().contains('location') ?? true) && !(subTitle?.toLowerCase().contains('mock') ?? true)
                        ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.close,
                          color: isManager ? ColorUtils.workEntryHead : ColorUtils.textWhite,
                          size: 15.w,
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          "Close",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 13.sp,
                            color: isManager ? ColorUtils.workEntryHead : ColorUtils.textWhite,
                          ),
                        ),
                      ],
                    )
                        : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.exit_to_app,
                          color: isManager ? ColorUtils.workEntryHead : ColorUtils.textWhite,
                          size: 15.w,
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          "Exit",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 13.sp,
                            color: isManager ? ColorUtils.workEntryHead : ColorUtils.textWhite,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}