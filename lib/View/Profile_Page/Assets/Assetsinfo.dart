import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/user_profile_api_model.dart';
import '../../../utils/color_utils.dart';
import '../../CWidgets/app_bar.dart';
import 'Currentinfo.dart';

class Assetinfo extends StatelessWidget {
  const Assetinfo({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<UserProfileController>().fetchEmployeeAssets();
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorUtils.workEntryHead,
        extendBody: true,
        body: Padding(
          padding: const EdgeInsets.only(left: 10, top: 8, right: 10).h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomAppBar(title: "Assets", isActionVisible: true),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 50).h,
                  child: GetX<UserProfileController>(
                    builder: (UserProfileController controller) {
                      if(controller.assetsLoading.value) {
                        context.loaderOverlay.show();
                      } else {
                        context.loaderOverlay.hide();
                      }
                      List<EmployeeAsset>? assets = controller.employeeAssets.value;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if(controller.assetsLoading.value)
                            SizedBox(
                              width: ScreenUtil().screenWidth,
                              height: ScreenUtil().screenHeight * 0.8,
                              child: Center(
                                child: Text(
                                  "Loading...",
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.5),
                                  ),
                                ),
                              ),
                            )
                          else if (assets.isNotEmpty)
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                    top: 20,
                                  ).h,
                                  child: Text(
                                    "Current Assets",
                                    style: GoogleFonts.poppins(
                                      color: ColorUtils.textWhite.withValues(alpha: 0.7),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15.h,
                                    ),
                                  ),
                                ),
                                ListView.separated(
                                  itemCount: assets.length,
                                  padding: EdgeInsets.symmetric(vertical: 15.h),
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () async {
                                        if (assets[index].image == null) {
                                          AttendanceCommonWidgets()
                                              .showSnackBar(
                                                context: context,
                                                backgroundColor: Colors.red.shade400,
                                                message: 'File not fount',
                                              );
                                          return;
                                        }
                                        try {
                                          if (await canLaunchUrl(
                                            Uri.parse(assets[index].image!),
                                          )) {
                                            await launchUrl(
                                              Uri.parse(assets[index].image!),
                                            );
                                          } else {
                                            AttendanceCommonWidgets()
                                                .showSnackBar(
                                              context: context,
                                              backgroundColor: Colors.red.shade400,
                                              message: 'Cant open image file',
                                            );
                                          }
                                        } catch(e) {
                                          AttendanceCommonWidgets()
                                              .showSnackBar(
                                            context: context,
                                            backgroundColor: Colors.red.shade400,
                                            message: 'Failed to open file',
                                          );
                                        }
                                      },
                                      child: CurrentInfo(
                                        text1: assets[index].assetTypeName,
                                        text2: assets[index].model,
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      SizedBox(height: 10.h),
                                ),
                              ],
                            )
                          else
                            SizedBox(
                              width: ScreenUtil().screenWidth,
                              height: ScreenUtil().screenHeight * 0.8,
                              child: Center(
                                child: Text(
                                  "No Assets",
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.5),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
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
