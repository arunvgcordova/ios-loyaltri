
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/controller/locationFetchController.dart';

import '../../../utils/color_utils.dart';

class ShowWarnDialog {

  Future<bool?> showWarn(
      {required BuildContext context, required String whichCheck}) async {
    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black,
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
              backgroundColor: ColorUtils.backgroundBlack,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(29.0).w,
                side: BorderSide(
                  color: const Color(0xFF666666),
                  width: 1.w,
                ),
              ),
              title: Image.asset(
                "assets/images/Success-icon3d.webp",
                // width: 10.w,
                height: 60.w,
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "$whichCheck Successful",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                      color: ColorUtils.textWhite,
                    ),
                  ),
                  SizedBox(height: 5.w),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/images/attendance-3d.webp",
                        width: 20.w,
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        DateFormat('hh:mm a').format(DateTime.now()),
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 12.sp,
                          color: ColorUtils.textWhite,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.w),
                  GetX<LocationFetchController>(
                    builder: (LocationFetchController controller) {
                      if(controller.locName.value != null) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              "assets/images/navigation-3d.webp",
                              width: 25.w,
                              fit: BoxFit.fitWidth,
                            ),
                            SizedBox(width: 5.w),
                            SizedBox(
                              width: ScreenUtil().screenWidth * 0.3,
                              child: Text(
                                "${controller.locName.value}",
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  color: ColorUtils.textWhite,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ],
              ),
              // actions: [
              //   Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       SizedBox(
              //         width: 110.w,
              //         height: 40.w,
              //         child: ElevatedButton(
              //           style: ElevatedButton.styleFrom(
              //             // foregroundColor: Colors.white,
              //               backgroundColor: const Color(0xFF6A4BFC),
              //               elevation: 0),
              //           onPressed: () {
              //             Navigator.pop(ctx);
              //           },
              //           child: Text(
              //             "View",
              //             style: GoogleFonts.poppins(
              //               fontWeight: FontWeight.w500,
              //               fontSize: 13.sp,
              //               color: ColorUtils.textWhite,
              //             ),
              //           ),
              //         ),
              //       ),
              //       const SizedBox(
              //         width: 10,
              //       ),
              //       Container(
              //         width: 110.w,
              //         height: 40.w,
              //         child: ElevatedButton(
              //           style: ElevatedButton.styleFrom(
              //             // foregroundColor: Colors.white,
              //               backgroundColor: ColorUtils.foregroundBlack,
              //               elevation: 0),
              //           onPressed: () {
              //             Navigator.pop(ctx);
              //           },
              //           child: Row(
              //             mainAxisSize: MainAxisSize.min,
              //             children: [
              //               Icon(
              //                 Icons.close,
              //                 color: ColorUtils.textWhite,
              //                 size: 15.w,
              //               ),
              //               Text(
              //                 "Close",
              //                 style: GoogleFonts.poppins(
              //                   fontWeight: FontWeight.w500,
              //                   fontSize: 13.sp,
              //                   color: ColorUtils.textWhite,
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ],
            ),
          ),
        );
      }
    );
  }
}

class UploadSuccessDialog {
  Future<bool?> showWarn(
      {required BuildContext context, required String message}) async {
    return showGeneralDialog<bool>(
        context: context,
        barrierDismissible: false,
        // barrierColor: Colors.black,
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
                backgroundColor: ColorUtils.backgroundBlack,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(29.0).w,
                  side: BorderSide(
                    color: const Color(0xFF666666),
                    width: 1.w,
                  ),
                ),
                title: Image.asset(
                  "assets/images/Success-icon3d.webp",
                  // width: 10.w,
                  height: 60.w,
                ),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                        color: ColorUtils.textWhite,
                      ),
                    ),
                    SizedBox(height: 5.w),
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
          );
        }
    );
  }

  Future<bool?> showWarnManager(
      {required BuildContext context, required String message}) async {
    return showGeneralDialog<bool>(
        context: context,
        barrierDismissible: false,
        // barrierColor: Colors.black,
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
                  "assets/images/Success-icon3d.webp",
                  // width: 10.w,
                  height: 60.w,
                ),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                        color: ColorUtils.workEntryHead,
                      ),
                    ),
                    SizedBox(height: 5.w),
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
                      child: Center(
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
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
}
