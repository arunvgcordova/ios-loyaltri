

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/CWidgets/cwidgets.dart';
import '../../../controller/leaveTypeController.dart';
import '../../../models/leave_type_api_model.dart';
import '../../../utils/color_utils.dart';
import '../Leave_Request.dart';
import 'leave_type_card.dart';

Future<void> leaveTypeBottomSheet({context, isHomePage, Function(LeaveType)? type, VoidCallback? reload, String? date}) async {
  await showModalBottomSheet(
    context: context,
    backgroundColor: Colors.black,
    barrierColor: ColorUtils.workEntryHead.withOpacity(0.81),
    builder: (BuildContext context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GetX<LeaveTypeController>(
            builder: (LeaveTypeController controller) {
              List<LeaveType> list = controller.leaveType.value.result ?? [];
              return Container(
                width: ScreenUtil().screenWidth,
                // height: 273.w,
                decoration: BoxDecoration(
                  color: ColorUtils.backgroundBlack,
                  borderRadius: BorderRadius.circular(20).w,
                  border: Border.all(
                    width: 1.w,
                    color: const Color(0xFF404040),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15.0, right: 15.0).w,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Select a leave type",
                          style: GoogleFonts.poppins(
                            color: ColorUtils.textWhite,
                            fontWeight: FontWeight.w600,
                            fontSize: 18.sp,
                          ),
                        ),
                        SizedBox(height: 15.w),
                        // const Spacer(),
                        for(int i = 0; i < list.length; i++)
                          GestureDetector(
                            onTap: () async {
                              if(list[i].leaveBalance != "0") {
                                if (isHomePage) {
                                  type!(list[i]);
                                  Navigator.of(context).pop();
                                } else {
                                  final result = await Navigator.of(context).push(
                                    newSlideNavigation(LeaveRequest(
                                      selectedLeave: list[i],
                                      date: date,
                                    )),
                                  );
                                  reload?.call();
                                  Navigator.of(context).pop(result);
                                }
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10).w,
                              child: LeaveTypeCard(
                                leaveBalance: list[i].leaveBalance,
                                imageIcon: list[i].leaveType?.toUpperCase() == "SICK LEAVE"
                                    ? "assets/images/sickleave-3d.webp"
                                    : list[i].leaveType?.toUpperCase() == "VACATION LEAVE" || list[i].leaveType?.toUpperCase() == "VACATION"
                                    ? "assets/images/vacation3d.webp"
                                    : "assets/images/calendar-blue.webp",
                                title: list[i].leaveType ?? '--',
                                subTitle: list[i].basicLeaveType.toString() != "1" ? list[i].leaveBalance != "0" ? (list[i].hideLeaveBalance ?? false) ? "Take ${list[i].leaveType}" : "Available ${list[i].leaveBalance} ${list[i].leaveBalance == '1' ? list[i].isHourBased == '1' ? 'hour' : 'leave' : list[i].isHourBased == '1' ? 'hours' : 'leaves'}" : "No leaves available" : "Take ${list[i].leaveType}",
                              ),
                            ),
                          ),
                        if(list.isEmpty)
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 12.h,
                                horizontal: 14.h,
                              ),
                              child: Column(
                                children: [
                                  Image.asset(
                                    "assets/images/manager_view/no_leaveType.png",
                                    height: 44.h,
                                    fit: BoxFit.fitHeight,
                                  ),
                                  SizedBox(height: 10.h),
                                  Text(
                                    "No Leave type found",
                                    style: GoogleFonts.poppins(
                                      color: ColorUtils.textWhite,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 11.h,
                                    ),
                                  ),
                                  SizedBox(height: 5.h),
                                  Text(
                                    "Please contact HR",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      color: ColorUtils.textWhite.withValues(alpha: 0.7),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 11.h,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    },
  );
}