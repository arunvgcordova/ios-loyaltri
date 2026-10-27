
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loyaltri_minimal/View/OldMyRequest/my_request_widgets/workFromHomeRequest_Bottom_Sheet.dart';

import '../../../controller/locationFetchController.dart';
import '../../../utils/color_utils.dart';
import 'letterRequest_Bottom_Sheet.dart';

newRequestBottomSheet(
    {required BuildContext context}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.black,
    barrierColor: ColorUtils.workEntryHead.withOpacity(0.81),
    builder: (BuildContext context) {
      return SafeArea(
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
                color: const Color(0xFF404040),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Flexible(flex: 1, child: Container()),
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 10, bottom: 8).w,
                  child: Row(
                    children: [
                      GetX<LocationFetchController>(
                        builder: (LocationFetchController controller) {
                          if(controller.isLoading.value) {
                            context.loaderOverlay.show();
                          } else {
                            context.loaderOverlay.hide();
                          }
                          return Text(
                            "New Request",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 18.sp,
                              color: ColorUtils.textWhite,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                // Flexible(flex: 2, child: Container()),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10).w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          HapticFeedback.lightImpact();
                          showModalBottomSheet(
                            backgroundColor: ColorUtils.backgroundBlack,
                            context: context,
                            isScrollControlled: true,
                            barrierColor: ColorUtils.workEntryHead,
                            useSafeArea: true,
                            builder: (BuildContext context) {
                              return const WorkFromHomeRequestBottomSheet();
                            },
                          );
                        },
                        child: Container(
                          width: 155.w,
                          height: 120.w,
                          padding: const EdgeInsets.all(10.0).w,
                          decoration: BoxDecoration(
                            color: ColorUtils.foregroundBlack,
                            borderRadius: BorderRadius.circular(15).w,
                          ),
                          child: Column(
                            children: [
                              const Spacer(),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/images/work_from_home_request.webp",
                                    width: 30.w,
                                  ),
                                ],
                              ),
                              const Spacer(flex: 3),
                              Row(
                                children: [
                                  Text(
                                    "Work From Home",
                                    style: GoogleFonts.inter(
                                      color: ColorUtils.textWhite,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    constraints: BoxConstraints(
                                      maxWidth: 131.w,
                                    ),
                                    child: Text(
                                      "Apply For Work From Home Request",
                                      style: GoogleFonts.inter(
                                        color: ColorUtils.textWhite.withOpacity(0.5),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          HapticFeedback.lightImpact();
                          showModalBottomSheet(
                          backgroundColor: ColorUtils.backgroundBlack,
                          context: context,
                          isScrollControlled: true,
                          barrierColor: ColorUtils.workEntryHead,
                          useSafeArea: true,
                          builder: (BuildContext context) {
                            return const LetterRequestBottomSheet();
                          },
                          );
                        },
                        child: Container(
                          width: 155.w,
                          height: 120.w,
                          padding: const EdgeInsets.all(10.0).w,
                          decoration: BoxDecoration(
                            color: ColorUtils.foregroundBlack,
                            borderRadius: BorderRadius.circular(15).w,
                          ),
                          child: Column(
                            children: [
                              const Spacer(),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/images/letter_request.webp",
                                    width: 30.w,
                                  ),
                                ],
                              ),
                              const Spacer(flex: 3),
                              Row(
                                children: [
                                  Text(
                                    "Letter Request",
                                    style: GoogleFonts.inter(
                                      color: ColorUtils.textWhite,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    constraints: BoxConstraints(
                                      maxWidth: 131.w,
                                    ),
                                    child: Text(
                                      "Apply For New Letter Request",
                                      style: GoogleFonts.inter(
                                        color: ColorUtils.textWhite.withOpacity(0.5),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ),
                    ],
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
