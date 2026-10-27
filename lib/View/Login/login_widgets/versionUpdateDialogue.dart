

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/color_utils.dart';

Future<bool?> updationDialogue(
    {required BuildContext context, required String url}) async {
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
            content: Text(
              "New version is available.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
                color: ColorUtils.textWhite,
              ),
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
                        await launchUrl(Uri.parse(url));
                      },
                      child: Text(
                        "Update",
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