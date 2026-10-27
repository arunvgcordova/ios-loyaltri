
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loyaltri_minimal/View/Leave_Page/leave_widgets/success_dialogue.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/View/My_Request/controller/my_request_controller.dart';
import 'package:loyaltri_minimal/View/Profile_Page/Documents/docCreate.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../controller/userAuthentication.dart';
import '../../../models/user_profile_api_model.dart';
import '../../../utils/color_utils.dart';
import '../../CWidgets/cwidgets.dart';
import '../../ManagerView/Employee_Leave/leave_widgets_manager/employee_leave_appBar.dart';
import 'DocInfo.dart';

class Documents extends StatelessWidget {
  const Documents({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<UserProfileController>().fetchEmployeeDocuments();
    bool createPermission = Get.find<UserAuthController>().allowUploadDocument.value;
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorUtils.workEntryHead,
        extendBody: true,
        body: Padding(
          padding: const EdgeInsets.only(left: 10, top: 8, right: 10).w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const CustomAppBar(title: "Documents", isActionVisible: true),
              Padding(
                padding: EdgeInsets.only(left: 10.h, right: 10.h, top: 10.h),
                child: ManagerScreensAppBar(
                  title: "Documents",
                  isDark: true,
                  cancelAction: () {
                    Navigator.of(context).pop();
                  },
                  okAction: createPermission
                      ? () async {
                          Get.find<MyRequestControllerNew>().initDocAdd();
                          final out = await Navigator.of(
                            context,
                          ).push(newSlideNavigation(DocCreation()));
                          if (out != null && out is String) {
                            ShowSuccessDialog().showSuccess(
                              context: context,
                              title: 'Success',
                              subTitle: out,
                            );
                          }
                        }
                      : null,
                ),
              ),
              Expanded(
                child: GetX<UserProfileController>(
                  builder: (UserProfileController controller) {
                    if (controller.documentsLoading.value) {
                      context.loaderOverlay.show();
                    } else {
                      context.loaderOverlay.hide();
                    }
                    List<EmployeeDocument> docs =
                        controller.employeeDocuments.value;
                    if (controller.documentsLoading.value) {
                      return SizedBox(
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
                      );
                    } else if (docs.isNotEmpty) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.only(bottom: 50).w,
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListView.separated(
                              itemCount: docs.length,
                              padding: EdgeInsets.symmetric(vertical: 15.h),
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () async {
                                    if (docs[index].documentName == null) {
                                      AttendanceCommonWidgets().showSnackBar(
                                        context: context,
                                        backgroundColor: Colors.red.shade400,
                                        message: 'File not fount',
                                      );
                                      return;
                                    }
                                    try {
                                      if (await canLaunchUrl(
                                        Uri.parse(docs[index].documentName!),
                                      )) {
                                        await launchUrl(
                                          Uri.parse(docs[index].documentName!),
                                        );
                                      } else {
                                        AttendanceCommonWidgets().showSnackBar(
                                          context: context,
                                          backgroundColor: Colors.red.shade400,
                                          message: 'Cant open image file',
                                        );
                                      }
                                    } catch (e) {
                                      AttendanceCommonWidgets().showSnackBar(
                                        context: context,
                                        backgroundColor: Colors.red.shade400,
                                        message: 'Failed to open file',
                                      );
                                    }
                                  },
                                  child: DocInfo(
                                    fstname: docs[index].documentType ?? "--",
                                    scndname:
                                        'Expires in ${docs[index].validTo ?? "--"}',
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 10.h),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.only(left: 10, top: 20).w,
                            //   child: Text(
                            //     "Mandatory Documents",
                            //     style: GoogleFonts.poppins(
                            //       color: ColorUtils.textWhite.withOpacity(0.7),
                            //       fontWeight: FontWeight.w400,
                            //       fontSize: 16.sp,
                            //     ),
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.only(top: 10,bottom: 15).w,
                            //   child: const DocInfo(fstname: 'Passport',scndname: 'Expires in 10 years'),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.only(top: 10,bottom: 15).w,
                            //   child: const DocInfo(fstname: 'Passport Photo',scndname: 'uploaded on 04-01-2023'),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.only(top: 10,bottom: 15).w,
                            //   child: const DocInfo(fstname: 'Emirates Id Front',scndname: 'Not uploaded'),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.only(left: 10,top: 15).w,
                            //   child: Text(
                            //     "Other Documents",
                            //     style: GoogleFonts.poppins(
                            //       color: ColorUtils.textWhite.withOpacity(0.7),
                            //       fontWeight: FontWeight.w400,
                            //       fontSize: 16.sp,
                            //     ),
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.only(top: 10,bottom: 15).w,
                            //   child: const DocInfo(fstname: 'Educational Certificate',scndname: 'Uploaded'),
                            // ),
                          ],
                        ),
                      );
                    } else {
                      return SizedBox(
                        width: ScreenUtil().screenWidth,
                        height: ScreenUtil().screenHeight * 0.8,
                        child: Center(
                          child: Text(
                            "No Documents",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
