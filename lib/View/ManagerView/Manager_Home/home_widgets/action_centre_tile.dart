import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/CWidgets/cwidgets.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Request/manager_request_controller/manager_request_controller.dart';
import 'package:loyaltri_minimal/controller/ui_controller/page_controller.dart';
import 'package:loyaltri_minimal/models/manager/action_centre_model.dart';
import '../../../../utils/color_utils.dart';
import '../../Employee_Leave/Employee_Leave_Page.dart';
import '../../Employee_Leave/employee_leave_controller/employee_leave_controller.dart';
import '../../Manager_Request/Manager_Reqest_Page.dart';

class ActionCentreTile extends StatelessWidget {
  final ActionData? actionData;
  const ActionCentreTile({super.key, this.actionData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.h),
      child: InkWell(
        onTap: () {
          if(actionData?.type == 'request') {
            // Get.find<UserPageController>().currentIndex.value = 4;
            Get.find<ManagerRequestController>().currentTabIndex.value = 0;
            Navigator.of(context).push(
              newSlideNavigation(const ManagerRequestPage()),
            );
          } else if(actionData?.type == 'leave') {
            // Get.find<UserPageController>().currentIndex.value = 4;
            Get.find<ManagerRequestController>().currentTabIndex.value = 5;
            Navigator.of(context).push(
              newSlideNavigation(const ManagerRequestPage()),
            );
          } else if(actionData?.type == 'overtime') {
            // Get.find<UserPageController>().currentIndex.value = 4;
            Get.find<ManagerRequestController>().currentTabIndex.value = 2;
            Navigator.of(context).push(
              newSlideNavigation(const ManagerRequestPage()),
            );
          } else if(actionData?.type == 'wfh') {
            // Get.find<UserPageController>().currentIndex.value = 4;
            Get.find<ManagerRequestController>().currentTabIndex.value = 3;
            Navigator.of(context).push(
              newSlideNavigation(const ManagerRequestPage()),
            );
          } else if(actionData?.type == 'letterRequest') {
            // Get.find<UserPageController>().currentIndex.value = 4;
            Get.find<ManagerRequestController>().currentTabIndex.value = 4;
            Navigator.of(context).push(
              newSlideNavigation(const ManagerRequestPage()),
            );
          } else if(actionData?.type == 'punchApproval') {
            // Get.find<UserPageController>().currentIndex.value = 4;
            Get.find<ManagerRequestController>().currentTabIndex.value = 1;
            Navigator.of(context).push(
              newSlideNavigation(const ManagerRequestPage()),
            );
          }
        },
        child: Container(
          height: 58.h,
          decoration: BoxDecoration(
            color: ColorUtils.pureSnow,
            borderRadius: BorderRadius.circular(10).r,
          ),
          child: Row(
            children: [
              SizedBox(width: 8.h),
              Container(
                width: 29.h,
                height: 29.h,
                decoration: BoxDecoration(
                  color: ColorUtils.mistGrey,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image.asset(
                    takeIcon(actionData?.type ?? ''),
                    height: 18.h,
                  ),
                ),
              ),
              SizedBox(width: 10.h),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            actionData?.actionTitle ?? '--',
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 13.h,
                              fontWeight: FontWeight.w500,
                              color: ColorUtils.workEntryHead,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        // Text(
                        //   '3',
                        //   overflow: TextOverflow.ellipsis,
                        //   style: GoogleFonts.inter(
                        //     fontSize: 12.h,
                        //     fontWeight: FontWeight.w600,
                        //     color: ColorUtils.workEntryHead,
                        //   ),
                        // ),
                        Expanded(
                          child: Text(
                            actionData?.actionDescription ?? '--',
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 12.h,
                              fontWeight: FontWeight.w400,
                              color: ColorUtils.workEntryHead,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Spacer(),
              Icon(
                Icons.arrow_forward_ios_outlined,
                color: ColorUtils.workEntryHead,
                size: 11.h,
              ),
              SizedBox(width: 8.h),
            ],
          ),
        ),
      ),
    );
  }

  String takeIcon(String type) {
    String action =
        type.toLowerCase().contains('request')
            ? 'request'
            : type.toLowerCase().contains('document')
            ? 'document'
            : type.toLowerCase().contains('leave')
            ? 'leave'
            : 'default';
    switch (action) {
      case 'request':
        return "assets/images/manager_view/alarm_icon.png";
      case 'document':
        return "assets/images/manager_view/file_icon.png";
      case 'leave':
        return "assets/images/manager_view/hourglass_icon.png";
      default:
        return "assets/images/manager_view/hourglass_icon.png";
    }
  }
}
