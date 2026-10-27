

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Request/request_wigets_manager/work_from_home_bottomSheet.dart';

import '../../../../models/manager/wfh_lr_list_model.dart';
import '../../../../utils/color_utils.dart';
import '../../../Login/login_widgets/custom_check_box.dart';
import '../manager_request_controller/manager_request_controller.dart';
import 'letter_request_bottomSheet.dart';

class LetterRequestCard extends StatelessWidget {
  final WfhLrData? wfhLrList;
  const LetterRequestCard({super.key, this.wfhLrList});

  @override
  Widget build(BuildContext context) {
    String? requestDate;
    try {
      DateTime date = DateTime.parse(wfhLrList!.fromDate!);
      requestDate = DateFormat('dd MMM yyyy').format(date);
    } catch(e) {}
    return Padding(
      padding: EdgeInsets.only(
        bottom: 10.h,
        right: 6.h,
        left: 6.h,
      ),
      child: GestureDetector(
        onTap: () async {
          wfhLrList?.isSelected = true;
          Get.find<ManagerRequestController>().letterRequestFiles.clear();
          await showModalBottomSheet(
            backgroundColor: ColorUtils.textWhite,
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            barrierColor: ColorUtils.workEntryHead.withValues(alpha: 0.5),
            // constraints: BoxConstraints(
            //   maxHeight: ScreenUtil().screenHeight * 0.8,
            // ),
            builder: (BuildContext context) {
              return LetterRequestBottomSheetManager(wfhLrList: wfhLrList);
            },
          ).then((value) {
            Get.find<ManagerRequestController>().reasonController.text = '';
            Get.find<ManagerRequestController>().remarksController.text = '';
            wfhLrList?.isSelected = false;
          });
        },
        child: Container(
          padding: EdgeInsets.all(6).h,
          decoration: BoxDecoration(
            color: ColorUtils.textWhite,
            borderRadius: BorderRadius.circular(14).r,
            border: Border.all(
              color: ColorUtils.workEntryHead.withValues(alpha: 0.1),
              width: 1.h,
            ),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Image.asset("assets/examples/user_request.png", height: 32.h),
                  AttendanceCommonWidgets().cachedNetworkImage(
                    wfhLrList?.profilePicture ?? '',
                    height: 28.h,
                  ),
                  SizedBox(width: 8.h),
                  Expanded(
                    child: AttendanceCommonWidgets().nameWithDesignation(
                        name: wfhLrList?.employeeName ?? '--',
                        designation: wfhLrList?.employeeDesignation??'--',
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 2.h,
                      horizontal: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: AttendanceCommonWidgets().hexToColor(wfhLrList?.requestStatusColour)?.withValues(alpha: 0.1) ?? ColorUtils.textWhite,
                      borderRadius: BorderRadius.circular(100).r,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 6.h,
                          height: 6.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AttendanceCommonWidgets().hexToColor(wfhLrList?.requestStatusColour) ?? ColorUtils.workEntryHead,
                          ),
                        ),
                        SizedBox(width: 6.h),
                        Text(
                          wfhLrList?.requestStatusName ?? '--',
                          style: GoogleFonts.inter(
                            fontSize: 13.h,
                            fontWeight: FontWeight.w500,
                            color: AttendanceCommonWidgets().hexToColor(wfhLrList?.requestStatusColour) ?? ColorUtils.workEntryHead,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(color: ColorUtils.softGrey, thickness: 1.h, indent: 3.h, endIndent: 3.h),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 3.h,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Request Date",
                            style: GoogleFonts.poppins(
                              fontSize: 11.h,
                              fontWeight: FontWeight.w400,
                              color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                            ),
                          ),
                          Text(
                            requestDate ?? '--',
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 11.h,
                              fontWeight: FontWeight.w500,
                              color: ColorUtils.workEntryHead,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(width: 1.h, height: 15.h, color: ColorUtils.paleSilver),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Request For",
                              style: GoogleFonts.poppins(
                                fontSize: 11.h,
                                fontWeight: FontWeight.w400,
                                color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                              ),
                            ),
                            Text(
                              wfhLrList?.requestLetterType ?? '--',
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 11.h,
                                fontWeight: FontWeight.w500,
                                color: ColorUtils.workEntryHead,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 3.h,
                  vertical: 2.h,
                ),
                child: Row(
                  children: [
                    Text(
                      "Purpose: ",
                      style: GoogleFonts.poppins(
                        fontSize: 11.h,
                        fontWeight: FontWeight.w400,
                        color: ColorUtils.workEntryHead,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        wfhLrList?.requestDescription ?? '--',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 11.h,
                          fontWeight: FontWeight.w400,
                          color: ColorUtils.steelBlue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
