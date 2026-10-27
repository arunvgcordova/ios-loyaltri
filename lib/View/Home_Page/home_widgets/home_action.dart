import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';

import '../../../services/ui_model_services/home_actions_model.dart';

class HomeAction extends StatelessWidget {
  final HomeActionsModel actionEntry;
  const HomeAction({super.key, required this.actionEntry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0).w,
      child: Container(
        height: 110.w,
        width: 90.w,
        decoration: BoxDecoration(
          color: actionEntry.id == 5 ? null : ColorUtils.foregroundBlack,
          borderRadius: BorderRadius.circular(18).w,
          gradient: actionEntry.id == 5
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    ColorUtils.electricIndigo,
                    ColorUtils.electricPeriwinkle,
                    ColorUtils.lightIndigo,
                  ],
                )
              : null,
        ),
        child: actionEntry.id == 5
            ? ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Stack(
                  children: [
                    // Inner shadow simulation
                    // Positioned.fill(
                    //   child: DecoratedBox(
                    //     decoration: BoxDecoration(
                    //       boxShadow: [
                    //         BoxShadow(
                    //           color: ColorUtils.textWhite.withValues(
                    //             alpha: 0.25,
                    //           ),
                    //           offset: const Offset(2, 2),
                    //           blurRadius: 10.r,
                    //           spreadRadius: 0,
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0).w,
                            child: Image.asset(
                              actionEntry.svgIcon,
                              height: 26.h,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0).w,
                            child: Text(
                              actionEntry.title,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 10.sp,
                                color: ColorUtils.textWhite,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0).w,
                      child: Image.asset(
                        actionEntry.svgIcon,
                        height: actionEntry.id == 1
                            ? 26.h
                            : actionEntry.id == 2
                            ? 28.h
                            : actionEntry.id == 9
                            ? 28.h
                            : actionEntry.id == 3
                            ? 26.h
                            : actionEntry.id == 4
                            ? 34.h
                            : 29.w,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: actionEntry.id == 4 ? 2 : 8.0, bottom: 8, left: 8, right: 8).w,
                      child: Text(
                        actionEntry.title,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 10.sp,
                          color: ColorUtils.textWhite,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
