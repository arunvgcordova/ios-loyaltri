

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Request/request_wigets_manager/work_from_home_bottomSheet.dart';

import '../../../../models/manager/wfh_lr_list_model.dart';
import '../../../../utils/color_utils.dart';
import '../../../Login/login_widgets/custom_check_box.dart';
import '../manager_request_controller/manager_request_controller.dart';

class WorkFromHomeCard extends StatelessWidget {
  final WfhLrData? wfhLrList;
  const WorkFromHomeCard({super.key, required this.wfhLrList});

  @override
  Widget build(BuildContext context) {
    String? formattedFromDate;
    String? formattedToDate;
    try {
      DateTime from = DateTime.parse(wfhLrList!.fromDate!);
      formattedFromDate = DateFormat('dd MMM yyyy').format(from);
      DateTime to = DateTime.parse(wfhLrList!.toDate!);
      formattedToDate = DateFormat('dd MMM yyyy').format(to);
    } catch(e) {}
    return Padding(
      padding: EdgeInsets.only(
        bottom: 10.h,
        right: 6.h,
        left: 6.h,
      ),
      child: GestureDetector(
        onTap: () async {
          final controller = Get.find<ManagerRequestController>();

          final selectedId = wfhLrList?.specialRequestId;

          for (var element in controller.wfhLrListPending) {
            element.isSelected = element.specialRequestId == selectedId;
          }

          controller.wfhLrListPending.refresh();
          await showModalBottomSheet(
            backgroundColor: ColorUtils.textWhite,
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            barrierColor: ColorUtils.workEntryHead.withValues(alpha: 0.5),
            builder: (BuildContext context) {
              return WorkFromHomeBottomSheetManager(wfhLrData: wfhLrList);
            },
          ).then((value) {
            controller.reasonController.text = '';
            controller.remarksController.text = '';
            controller.showReasonValidation.value = false;
            for (var element in controller.wfhLrListPending) {
              if(element.specialRequestId == selectedId) {
                element.isSelected = false;
                controller.wfhLrListPending.refresh();
                break;
              }
            }
          });
        },
        child: Container(
          padding: EdgeInsets.all(6).h,
          decoration: BoxDecoration(
            color: ColorUtils.textWhite,
            borderRadius: BorderRadius.circular(14).r,
            border: Border.all(
              color: wfhLrList?.isSelected ?? false
                  ? Color(0xFFC4B8FF)
                  : ColorUtils.workEntryHead.withValues(alpha: 0.1),
              width: 1.h,
            ),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AttendanceCommonWidgets().cachedNetworkImage(
                    wfhLrList?.profilePicture ?? '--',
                    height: 30.h,
                  ),
                  SizedBox(width: 8.h),
                  Expanded(
                    child: AttendanceCommonWidgets().nameWithDesignation(
                        name: wfhLrList?.employeeName ?? '--',
                        designation: wfhLrList?.employeeDesignation?? '--',
                    ),
                  ),
                  // if(wfhLrList?.requestStatusName.toString().toLowerCase() == 'pending')
                  //   Padding(
                  //     padding: EdgeInsets.only(
                  //       right: 3.h,
                  //     ),
                  //     child: CustomCheckbox(
                  //       size: 17.h,
                  //       iconSize: 12.h,
                  //       borderWidth: 0.5.h,
                  //       borderRadius: BorderRadius.circular(5).r,
                  //       checkIcon: const Icon(Icons.done_rounded),
                  //       borderColor: wfhLrList?.isSelected ?? false
                  //           ? ColorUtils.secondaryBlue
                  //           : ColorUtils.silverGrey,
                  //       selectedColor: ColorUtils.secondaryBlue,
                  //       isChecked: wfhLrList?.isSelected ?? false,
                  //       onChange: (bool? value) {
                  //         Get.find<ManagerRequestController>().markSelectEmployee(wfhLrList?.specialRequestId ?? '');
                  //       },
                  //     ),
                  //   ),

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
                            color: AttendanceCommonWidgets().hexToColor(wfhLrList?.requestStatusColour) ?? ColorUtils.rustRed,
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "From Date",
                          style: GoogleFonts.poppins(
                            fontSize: 11.h,
                            fontWeight: FontWeight.w400,
                            color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                          ),
                        ),
                        Text(
                          formattedFromDate ?? '--',
                          style: GoogleFonts.poppins(
                            fontSize: 11.h,
                            fontWeight: FontWeight.w500,
                            color: ColorUtils.workEntryHead,
                          ),
                        ),
                      ],
                    ),
                    Container(width: 1.h, height: 15.h, color: ColorUtils.paleSilver),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "To Date",
                          style: GoogleFonts.poppins(
                            fontSize: 11.h,
                            fontWeight: FontWeight.w400,
                            color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                          ),
                        ),
                        Text(
                          formattedToDate ?? '--',
                          style: GoogleFonts.poppins(
                            fontSize: 11.h,
                            fontWeight: FontWeight.w500,
                            color: ColorUtils.workEntryHead,
                          ),
                        ),
                      ],
                    ),
                    // Container(width: 1.h, height: 15.h, color: ColorUtils.paleSilver),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Reason: ",
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
