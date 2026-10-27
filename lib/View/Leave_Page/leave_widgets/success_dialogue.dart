
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/controller/locationFetchController.dart';
import '../../../utils/color_utils.dart';

class ShowSuccessDialog {

  Future<bool?> showWarn(
      {required BuildContext context}) async {
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
                      "Leave Applied Successfully",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                        color: ColorUtils.textWhite,
                      ),
                    ),
                    SizedBox(height: 5.w),
                    Text(
                      DateFormat('hh:mm a').format(DateTime.now()),
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                        color: ColorUtils.textWhite,
                      ),
                    ),
                    SizedBox(height: 5.w),
                    GetX<LocationFetchController>(
                      builder: (LocationFetchController controller) {
                        if(controller.locName.value != null && controller.locName.value != "null") {
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
                                  controller.locName.value ?? '--',
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
                          return SizedBox.shrink();
                        }
                      }
                    ),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }

  Future<bool?> showSuccess({
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
                      ),
                      title: Image.asset(
                        "assets/images/Success-icon3d.webp",
                        // width: 10.w,
                        height: 60.w,
                        fit: BoxFit.fitHeight,
                      ),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if(title != null)
                            Text(
                            title,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
                              color: ColorUtils.textWhite,
                            ),
                          ),
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

  Future<bool?> showSuccessManager({
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
                      backgroundColor: ColorUtils.textWhite,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28.0).w,
                      ),
                      title: Image.asset(
                        "assets/images/Success-icon3d.webp",
                        // width: 10.w,
                        height: 60.w,
                        fit: BoxFit.fitHeight,
                      ),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if(title != null)
                            Text(
                            title,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
                              color: ColorUtils.workEntryHead,
                            ),
                          ),
                          if(subTitle != null)
                            Text(
                            subTitle,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 12.sp,
                              color: ColorUtils.workEntryHead.withValues(alpha: 0.4),
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
