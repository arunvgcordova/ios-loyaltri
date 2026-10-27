
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../utils/color_utils.dart';

Future<bool?> showPermissionDialogue({required BuildContext mainContext, required String title, required String subTitle}) async {
  return showGeneralDialog<bool>(
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
              "assets/images/alert.webp",
              // width: 10.w,
              height: 60.w,
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                    color: ColorUtils.textWhite,
                  ),
                ),
                Text(
                  subTitle,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 12.sp,
                    color: ColorUtils.textWhite.withOpacity(0.4),
                  ),
                ),
              ],
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 110.w,
                    height: 40.w,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        // foregroundColor: Colors.white,
                          backgroundColor: const Color(0xFF6A4BFC),
                          elevation: 0),
                      onPressed: () async {
                        await openAppSettings();
                      },
                      child: Text(
                        "Enable",
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
                    width: 110.w,
                    height: 40.w,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        // foregroundColor: Colors.white,
                          backgroundColor: ColorUtils.foregroundBlack,
                          elevation: 0),
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.close,
                            color: ColorUtils.textWhite,
                            size: 15.w,
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
            ],
          ),
        ),
      );
    },
  );
}