
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:upgrader/upgrader.dart';

import '../../../utils/color_utils.dart';

class MyUpgradeCard extends UpgradeCard {
  MyUpgradeCard({super.key, super.upgrader});

  /// Override the [createState] method to provide a custom class
  /// with overridden methods.
  @override
  UpgradeCardState createState() => MyUpgradeCardState();
}

class MyUpgradeCardState extends UpgradeCardState {
  @override
  Widget buildUpgradeCard(BuildContext context, Key? key) {
    final appMessages = widget.upgrader.determineMessages(context);
    final title = appMessages.message(UpgraderMessage.title);
    final question = appMessages.message(UpgraderMessage.prompt);
    final appName = widget.upgrader.appName();
    final currentAppStoreVersion = widget.upgrader.currentAppStoreVersion;
    final currentInstalledVersion = widget.upgrader.currentInstalledVersion;
    final content = appMessages.message(UpgraderMessage.body)?.replaceAll("{{appName}}", appName).replaceAll("{{currentAppStoreVersion}}", currentAppStoreVersion ?? '').replaceAll("{{currentInstalledVersion}}", currentInstalledVersion ?? '');
    bool isIos = Platform.isIOS;
    return Card(
      color: ColorUtils.textWhite,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.w, horizontal: 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AlertStyleWidget(
              title: const Text("Update Available !"),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Tap 'Update' to experience new features and improved performance."),
                  SizedBox(height: 8.h),
                  Text("Version $currentAppStoreVersion is here !"),
                ],
              ),
              actions: [
                // GestureDetector(
                //   onTap: () {
                //     widget.upgrader.saveIgnored();
                //     onUserIgnored();
                //   },
                //   child: Container(
                //     height: 40.h,
                //     padding: EdgeInsets.symmetric(
                //       vertical: 5.h,
                //       horizontal: 20.w,
                //     ),
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(10).r,
                //     ),
                //     child: Center(
                //       child: Text(
                //         'Ignore',
                //         style: TextStyle(
                //           color: isIos ? ColorUtils.backgroundBlack1 : ColorUtils.googleGreen,
                //           fontSize: 14.h,
                //           fontWeight: FontWeight.w600,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await widget.upgrader.saveLastAlerted();
                          await Upgrader.clearSavedSettings();
                          onUserLater();
                        },
                        child: Container(
                          height: 40.h,
                          padding: EdgeInsets.symmetric(
                            vertical: 5.h,
                            horizontal: 20.w,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10).r,
                          ),
                          child: Center(
                            child: Text(
                              'Later',
                              style: TextStyle(
                                color: isIos ? ColorUtils.backgroundBlack1 : ColorUtils.googleGreen,
                                fontSize: 14.h,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.h),
                      GestureDetector(
                        onTap: () async {
                          await widget.upgrader.saveLastAlerted();
                          await Upgrader.clearSavedSettings();
                          onUserUpdated();
                        },
                        child: Container(
                          height: 40.h,
                          padding: EdgeInsets.symmetric(
                            vertical: 5.h,
                            horizontal: 20.w,
                          ),
                          decoration: BoxDecoration(
                            color: isIos ? ColorUtils.backgroundBlack1 : ColorUtils.googleGreen,
                            borderRadius: BorderRadius.circular(10).r,
                          ),
                          child: Center(
                            child: Text(
                              'Update',
                              style: TextStyle(
                                color: ColorUtils.textWhite,
                                fontSize: 14.h,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(
              indent: 10.w,
              endIndent: 10.w,
              thickness: 0.5,
            ),
            Row(
              children: [
                SvgPicture.asset(
                  isIos ? "assets/images/app_store_icon.svg" : "assets/images/google_play_icon.svg",
                  height: 40.h,
                  fit: BoxFit.fitHeight,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}