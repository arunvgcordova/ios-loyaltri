import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/shift_selector.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/manager_attendance_controller/manager_attendance_controller.dart';
import '../../../../controller/userAuthentication.dart';
import '../../../../utils/color_utils.dart';

class PresentView extends StatelessWidget {
  const PresentView({super.key});

  @override
  Widget build(BuildContext context) {
    bool canEditAttendance =
        Get.find<UserAuthController>()
            .userData
            .value
            .userData
            ?.attendanceEdit ??
            false;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 13.h),
      child: Column(
        children: [
          SizedBox(height: 15.h),
          // Mark as off day toggle card
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 12.h),
            decoration: BoxDecoration(
              color: ColorUtils.textWhite,
              borderRadius: BorderRadius.circular(12).r,
              border: Border.all(
                color: const Color(0xFFE5E7EB),
                width: 1.h,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Mark as off day",
                        style: GoogleFonts.dmSans(
                          fontSize: 14.h,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1F2937),
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        "Designate this day as a scheduled off day",
                        style: GoogleFonts.dmSans(
                          fontSize: 12.h,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10.w),
                GetX<ManagerAttendanceController>(
                  builder: (ManagerAttendanceController controller) {
                    return CupertinoSwitch(
                      value: controller.isOffDay.value,
                      activeColor: const Color(0xFF6342E8),
                      onChanged: (val) {
                        controller.isOffDay.value = val;
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 15.h),
          GetX<ManagerAttendanceController>(
            builder: (ManagerAttendanceController controller) {
              if (controller.isOffDay.value) {
                return Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 10.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEBF3FF),
                        borderRadius: BorderRadius.circular(10).r,
                        border: Border.all(color: const Color(0xFFC7DCFE), width: 1.h),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 2.h),
                            child: Icon(
                              Icons.info,
                              color: const Color(0xFF2563EB),
                              size: 16.h,
                            ),
                          ),
                          SizedBox(width: 8.h),
                          Expanded(
                            child: Text(
                              "This day is marked as off. If you set shift and time, it will be considered as Compensatory Off - the employee will receive a day off in lieu for working on their scheduled off day.",
                              style: GoogleFonts.dmSans(
                                fontSize: 12.h,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF1E40AF),
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Shift Name ",
                          style: GoogleFonts.dmSans(
                            fontSize: 13.h,
                            fontWeight: FontWeight.w500,
                            color: ColorUtils.workEntryHead,
                          ),
                        ),
                        Text(
                          "*",
                          style: GoogleFonts.dmSans(
                            fontSize: 13.h,
                            fontWeight: FontWeight.w500,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    ShiftSelector(),
                    SizedBox(height: 20.h),
                  ],
                );
              }
            },
          ),
          GetX<ManagerAttendanceController>(
            builder: (ManagerAttendanceController controller) {
              final isOffDay = controller.isOffDay.value;
              return ListView.separated(
                shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                itemCount: controller.addedTimeList.value.length,
                  itemBuilder: (context, index) {
                  if(controller.addedTimeList[index].type == CheckInType.punchAdd) {
                    return Column(
                      children: [
                        Obx(() => Row(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Time ",
                                  style: GoogleFonts.dmSans(
                                    fontSize: 13.h,
                                    fontWeight: FontWeight.w500,
                                    color: ColorUtils.workEntryHead,
                                  ),
                                ),
                                if(!controller.isOffDay.value)
                                  Text(
                                    "*",
                                    style: GoogleFonts.dmSans(
                                      fontSize: 13.h,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.red,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        )),
                        SizedBox(height: 5.h),
                        InkWell(
                          borderRadius: BorderRadius.circular(12).r,
                          onTap: () {
                            _showTimePicker(context, index);
                          },
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 13.h, vertical: 12.h),
                                      decoration: BoxDecoration(
                                        color: ColorUtils.textWhite,
                                        borderRadius: BorderRadius.circular(12).r,
                                        border: Border.all(color: (controller.addedTimeList[index].isValidationChecked && !controller.addedTimeList[index].isValidationSuccess) || (controller.addedTimeList[index].isAbovePrev != null && controller.addedTimeList[index].isAbovePrev != false) ? Colors.red : Color(0xFFB9B0B0), width: 0.5.h),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          if(controller.addedTimeList[index].time1 == null)
                                            Text(
                                              "Choose Time",
                                              style: GoogleFonts.dmSans(
                                                fontSize: 14.h,
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xFFABABAB),
                                              ),
                                            )
                                          else
                                            Text(
                                              controller.addedTimeList[index].time1 ?? '--',
                                              style: GoogleFonts.dmSans(
                                                fontSize: 14.h,
                                                fontWeight: FontWeight.w400,
                                                color: ColorUtils.workEntryHead,
                                              ),
                                            ),
                                          SvgPicture.asset(
                                            "assets/images/manager_view/edit_att_time.svg",
                                            height: 19.h,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if(index != 0)
                                    InkWell(
                                      onTap: () {
                                        Get.find<ManagerAttendanceController>().addedTimeList.value.removeAt(index);
                                        Get.find<ManagerAttendanceController>().addedTimeList.refresh();
                                      },
                                      child: SizedBox(
                                        width: 30.h,
                                        height: 30.h,
                                        child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Icon(Icons.cancel_outlined, color: Colors.red, size: 15.h)),
                                      ),
                                    ),
                                ],
                              ),
                              if((controller.addedTimeList[index].isValidationChecked && !controller.addedTimeList[index].isValidationSuccess) || (controller.addedTimeList[index].isAbovePrev != null && controller.addedTimeList[index].isAbovePrev != false))
                                Padding(
                                  padding: EdgeInsets.only(top: 5, left: 5).h,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          (controller.addedTimeList[index].isAbovePrev ?? false) ? "Time must be greater than the previous time" : "Time is required",
                                          style: GoogleFonts.inter(
                                            height: 1.h,
                                            color: Colors.red,
                                            fontSize: 12.h,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12).r,
                            onTap: () {
                              _showTimePicker(context, index, true);
                            },
                            child: Column(
                              children: [
                                Obx(() => Row(
                                  children: [
                                    Text(
                                      "Start Break ",
                                      style: GoogleFonts.dmSans(
                                        fontSize: 13.h,
                                        fontWeight: FontWeight.w500,
                                        color: ColorUtils.workEntryHead,
                                      ),
                                    ),
                                    if(!controller.isOffDay.value)
                                      Text(
                                        "*",
                                        style: GoogleFonts.dmSans(
                                          fontSize: 13.h,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.red,
                                        ),
                                      ),
                                  ],
                                )),
                                SizedBox(height: 5.h),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 13.h, vertical: 12.h),
                                  decoration: BoxDecoration(
                                    color: ColorUtils.textWhite,
                                    borderRadius: BorderRadius.circular(12).r,
                                    border: Border.all(color: (controller.addedTimeList[index].isValidationChecked && !controller.addedTimeList[index].isValidationSuccess) || (controller.addedTimeList[index].isAbovePrevBreak1 != null && controller.addedTimeList[index].isAbovePrevBreak1 != false) ? Colors.red : Color(0xFFB9B0B0), width: 0.5.h),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      if(controller.addedTimeList[index].time1 == null)
                                        Text(
                                          "Choose Time",
                                          style: GoogleFonts.dmSans(
                                            fontSize: 14.h,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xFFABABAB),
                                          ),
                                        )
                                      else
                                        Text(
                                          controller.addedTimeList[index].time1 ?? '--',
                                          style: GoogleFonts.dmSans(
                                            fontSize: 14.h,
                                            fontWeight: FontWeight.w400,
                                            color: ColorUtils.workEntryHead,
                                          ),
                                        ),
                                      SvgPicture.asset(
                                        "assets/images/manager_view/edit_att_time.svg",
                                        height: 19.h,
                                      ),
                                    ],
                                  ),
                                ),
                                if((controller.addedTimeList[index].isValidationChecked && !controller.addedTimeList[index].isValidationSuccess) || (controller.addedTimeList[index].isAbovePrevBreak1 != null && controller.addedTimeList[index].isAbovePrevBreak1 != false))
                                  Padding(
                                    padding: EdgeInsets.only(top: 5, left: 5).h,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            (controller.addedTimeList[index].isAbovePrevBreak1 ?? false) ? "Start Break time must be greater than previous time" : "Start Break Time is required",
                                            style: GoogleFonts.inter(
                                              height: 1.h,
                                              color: Colors.red,
                                              fontSize: 12.h,
                                              fontWeight: FontWeight.w500,
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
                        SizedBox(width: 10.h),
                        Expanded(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12).r,
                            onTap: () {
                              _showTimePicker(context, index, false);
                            },
                            child: Column(
                              children: [
                                Obx(() => Row(
                                  children: [
                                    Text(
                                      "End Break ",
                                      style: GoogleFonts.dmSans(
                                        fontSize: 13.h,
                                        fontWeight: FontWeight.w500,
                                        color: ColorUtils.workEntryHead,
                                      ),
                                    ),
                                    if(!controller.isOffDay.value)
                                      Text(
                                        "*",
                                        style: GoogleFonts.dmSans(
                                          fontSize: 13.h,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.red,
                                        ),
                                      ),
                                  ],
                                )),
                                SizedBox(height: 5.h),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 13.h, vertical: 12.h),
                                  decoration: BoxDecoration(
                                    color: ColorUtils.textWhite,
                                    borderRadius: BorderRadius.circular(12).r,
                                    border: Border.all(color: (controller.addedTimeList[index].isValidationChecked && !(controller.addedTimeList[index].isValidationSuccessBreak2 ?? false) || (controller.addedTimeList[index].isAbovePrevBreak2 != null && controller.addedTimeList[index].isAbovePrevBreak2 != false)) ? Colors.red : Color(0xFFB9B0B0), width: 0.5.h),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      if(controller.addedTimeList[index].time2 == null)
                                        Text(
                                          "Choose Time",
                                          style: GoogleFonts.dmSans(
                                            fontSize: 14.h,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xFFABABAB),
                                          ),
                                        )
                                      else
                                        Text(
                                          controller.addedTimeList[index].time2 ?? '--',
                                          style: GoogleFonts.dmSans(
                                            fontSize: 14.h,
                                            fontWeight: FontWeight.w400,
                                            color: ColorUtils.workEntryHead,
                                          ),
                                        ),
                                      SvgPicture.asset(
                                        "assets/images/manager_view/edit_att_time.svg",
                                        height: 19.h,
                                      ),
                                    ],
                                  ),
                                ),
                                if((controller.addedTimeList[index].isValidationChecked && !(controller.addedTimeList[index].isValidationSuccessBreak2 ?? false) || (controller.addedTimeList[index].isAbovePrevBreak2 != null && controller.addedTimeList[index].isAbovePrevBreak2 != false)))
                                  Padding(
                                    padding: EdgeInsets.only(top: 5, left: 5).h,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            (controller.addedTimeList[index].isAbovePrevBreak2 ?? false) ? "End Break time must be greater than Start Break time" : "End Break Time is required",
                                            style: GoogleFonts.inter(
                                              height: 1.h,
                                              color: Colors.red,
                                              fontSize: 12.h,
                                              fontWeight: FontWeight.w500,
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
                        Padding(
                          padding: EdgeInsets.only(
                            top: 30.h,
                          ),
                          child: InkWell(
                            onTap: () {
                              Get.find<ManagerAttendanceController>().addedTimeList.value.removeAt(index);
                              Get.find<ManagerAttendanceController>().addedTimeList.refresh();
                            },
                            child: SizedBox(
                              width: 30.h,
                              height: 30.h,
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Icon(Icons.cancel_outlined, color: Colors.red, size: 15.h)),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 20.h),
              );
            }
          ),
          // InkWell(
          //   borderRadius: BorderRadius.circular(12).r,
          //   onTap: () {
          //     _showTimePicker(context);
          //   },
          //   child: Container(
          //     padding: EdgeInsets.symmetric(horizontal: 13.h, vertical: 12.h),
          //     decoration: BoxDecoration(
          //       color: ColorUtils.textWhite,
          //       borderRadius: BorderRadius.circular(12).r,
          //       border: Border.all(color: Color(0xFFB9B0B0), width: 0.5.h),
          //     ),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Text(
          //           "Choose Time",
          //           style: GoogleFonts.dmSans(
          //             fontSize: 14.h,
          //             fontWeight: FontWeight.w400,
          //             color: Color(0xFFABABAB),
          //           ),
          //         ),
          //         SvgPicture.asset(
          //           "assets/images/manager_view/edit_att_time.svg",
          //           height: 19.h,
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          SizedBox(height: 20.h),
          if(canEditAttendance)
            Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GetX<ManagerAttendanceController>(
                builder: (ManagerAttendanceController controller) {
                  List<AddTimeModel> list = controller.addedTimeList.value.where((element) => element.type == CheckInType.punchAdd).toList();
                  if(list.length.isOdd) {
                    return InkWell(
                      borderRadius: BorderRadius.circular(27).r,
                      onTap: () {
                        Get.find<ManagerAttendanceController>().addedTimeList.value.add(
                          AddTimeModel(
                              type: CheckInType.breakAdd,
                            isValidationChecked: false,
                            isValidationSuccess: false,
                            isValidationSuccessBreak2: false,
                          ),
                        );
                        Get.find<ManagerAttendanceController>().addedTimeList.refresh();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.h),
                        decoration: BoxDecoration(
                          color: ColorUtils.textWhite,
                          borderRadius: BorderRadius.circular(27).r,
                          border: Border.all(
                            color: Color(0xFF565656).withValues(alpha: 0.2),
                            width: 1.h,
                          ),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              "assets/images/manager_view/add_attendance.svg",
                              height: 15.h,
                            ),
                            SizedBox(width: 5.h),
                            Text(
                              "Add Break",
                              style: GoogleFonts.inter(
                                fontSize: 13.h,
                                fontWeight: FontWeight.w400,
                                color: ColorUtils.workEntryHead,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                }
              ),
              SizedBox(width: 10.h),
              InkWell(
                borderRadius: BorderRadius.circular(27).r,
                onTap: () {
                  Get.find<ManagerAttendanceController>().addedTimeList.value.add(
                    AddTimeModel(
                        type: CheckInType.punchAdd,
                      isValidationChecked: false,
                      isValidationSuccess: false,
                    ),
                  );
                  Get.find<ManagerAttendanceController>().addedTimeList.refresh();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.h),
                  decoration: BoxDecoration(
                    color: ColorUtils.textWhite,
                    borderRadius: BorderRadius.circular(27).r,
                    border: Border.all(
                      color: Color(0xFF565656).withValues(alpha: 0.2),
                      width: 1.h,
                    ),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        "assets/images/manager_view/add_attendance.svg",
                        height: 15.h,
                      ),
                      SizedBox(width: 5.h),
                      Text(
                        "Add Time",
                        style: GoogleFonts.inter(
                          fontSize: 13.h,
                          fontWeight: FontWeight.w400,
                          color: ColorUtils.workEntryHead,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Future<void> _showTimePicker(BuildContext context, int index, [bool? isBreakStart]) async {
    final now = DateTime.now();
    final currentHour = now.hour;
    final currentMinute = now.minute;
    int selectedHour = currentHour;
    int selectedMinute = currentMinute;

    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Cancel",
      barrierColor: ColorUtils.workEntryHead.withValues(alpha: 0.5),
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 250.h,
                width: 200.h,
                decoration: BoxDecoration(
                  color: ColorUtils.textWhite,
                  borderRadius: BorderRadius.circular(12).r,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: CupertinoPicker(
                              scrollController: FixedExtentScrollController(
                                initialItem: currentHour,
                              ),
                              itemExtent: 40,
                              onSelectedItemChanged: (int index) {
                                selectedHour = index;
                              },
                              children: List.generate(24, (index) {
                                return Center(child: Text(index.toString().padLeft(2, '0'), style: TextStyle(fontSize: 18.h)));
                              }),
                            ),
                          ),
                          Expanded(
                            child: CupertinoPicker(
                              scrollController: FixedExtentScrollController(
                                  initialItem: currentMinute),
                              itemExtent: 40,
                              onSelectedItemChanged: (int index) {
                                selectedMinute = index;
                              },
                              children: List.generate(60, (index) {
                                return Center(child: Text(index.toString().padLeft(2, '0'), style: TextStyle(fontSize: 18.h)));
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: Color(0xFF565656).withValues(alpha: 0.2), thickness: 0.5.h, height: 0),
                    Material(
                      color: ColorUtils.textWhite,
                      borderRadius: BorderRadius.circular(12).r,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 10.h,
                          horizontal: 12.h,
                        ),
                          decoration: BoxDecoration(
                            color: ColorUtils.textWhite,
                            borderRadius: BorderRadius.circular(12).r,
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: SizedBox(
                                    width: 80.h,
                                    height: 20.h,
                                    child: Center(
                                      child: Text(
                                          "Cancel",
                                          style: TextStyle(
                                              fontSize: 14.h,
                                            color: ColorUtils.workEntryHead,
                                          ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 0.5.h,
                                  height: 15.h,
                                  color: Color(0xFF565656).withValues(alpha: 0.2),
                                ),
                                InkWell(
                                  onTap: () {
                                    if(Get.find<ManagerAttendanceController>().addedTimeList.value[index].type == CheckInType.punchAdd) {
                                      Get.find<ManagerAttendanceController>().addedTimeList.value[index].time1 = "${selectedHour.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')}";
                                      Get.find<ManagerAttendanceController>().addedTimeList.refresh();
                                    }
                                    if(Get.find<ManagerAttendanceController>().addedTimeList.value[index].type == CheckInType.breakAdd) {
                                      if(isBreakStart!) {
                                        Get.find<ManagerAttendanceController>().addedTimeList.value[index].time1 = "${selectedHour.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')}";
                                      } else {
                                        Get.find<ManagerAttendanceController>().addedTimeList.value[index].time2 = "${selectedHour.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')}";
                                      }
                                      Get.find<ManagerAttendanceController>().addedTimeList.refresh();
                                    }
                                    Navigator.of(context).pop();
                                  },
                                  child: SizedBox(
                                    width: 80.h,
                                    height: 20.h,
                                    child: Center(
                                      child: Text(
                                          "Ok",
                                          style: TextStyle(
                                              fontSize: 14.h,
                                            color: ColorUtils.workEntryHead,
                                          ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
