import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/overtime_rate_selector.dart';
import '../../../../models/manager/edit_attendance_models.dart';
import '../../../../utils/color_utils.dart';
import '../manager_attendance_controller/manager_attendance_controller.dart';

class OverTimeView extends GetView<ManagerAttendanceController> {
  const OverTimeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 13.h, vertical: 10.h),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Overtime Hours ",
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
              SizedBox(height: 6.h),
              InkWell(
                borderRadius: BorderRadius.circular(12).r,
                onTap: () {
                  _showTimePicker(context);
                },
                child: Container(
                  padding: EdgeInsets.all(0.5).h,
                  decoration: BoxDecoration(
                    color: controller.showOverTimeHourValidation.value ? Colors.red : Color(0xFFB9B0B0),
                    borderRadius: BorderRadius.circular(12).r,
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 13.h, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: ColorUtils.textWhite,
                      borderRadius: BorderRadius.circular(11).r,
                      // border: Border.all(
                      //   color: Color(0xFFB9B0B0),
                      //   width: 0.5.h,
                      // ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          controller.selectedOvertimeHour.value.isEmpty ? "Hours worked" : controller.selectedOvertimeHour.value,
                          style: GoogleFonts.dmSans(
                            fontSize: 14.h,
                            fontWeight: FontWeight.w400,
                            color: controller.selectedOvertimeHour.value.isEmpty ? Color(0xFFABABAB) :  ColorUtils.workEntryHead,
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
              ),
              SizedBox(height: 3.h),
              Row(
                children: [
                  Text(
                    "Overtime after the shift ends",
                    style: GoogleFonts.dmSans(
                      fontSize: 11.h,
                      fontWeight: FontWeight.w400,
                      color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
              if(controller.showOverTimeHourValidation.value)
                Padding(
                  padding: EdgeInsets.only(top: 5, left: 5).h,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Overtime hours is required",
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
              SizedBox(height: 20.h),
              Row(
                children: [
                  Text(
                    "Overtime Rate ",
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
              SizedBox(height: 6.h),
              OverTimeRateSelector(),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Text(
                    "Amount ",
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
              SizedBox(height: 6.h),
              Container(
                padding: EdgeInsets.all(0.5).h,
                decoration: BoxDecoration(
                  color: controller.showOverTimeAmountValidation.value ? Colors.red : Color(0xFFB9B0B0),
                  borderRadius: BorderRadius.circular(12).r,
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 13.h, vertical: 0), // Remove vertical for proper text field rendering
                  decoration: BoxDecoration(
                    color: controller.selectedOvertimeRate.value == "Fixed Amount" ? ColorUtils.textWhite : Color(0xFFE4E4E4),
                    borderRadius: BorderRadius.circular(11).r,
                  ),
                  child: TextField(
                    controller: controller.selectedOvertimeAmountController,
                    readOnly: controller.selectedOvertimeRate.value != "Fixed Amount",
                    onChanged: (value) {
                      controller.selectedOvertimeAmountController.text = value;
                      controller.selectedOvertimeAmount.value = value;
                    },
                    style: GoogleFonts.dmSans(
                      fontSize: 14.h,
                      fontWeight: FontWeight.w400,
                      color: ColorUtils.workEntryHead,
                    ),
                    decoration: InputDecoration(
                      hintText: "Enter amount per hour",
                      hintStyle: GoogleFonts.dmSans(
                        fontSize: 14.h,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFABABAB),
                      ),
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
              if(controller.showOverTimeAmountValidation.value)
                Padding(
                  padding: EdgeInsets.only(top: 5, left: 5).h,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Amount is required.",
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
              // Container(
              //   padding: EdgeInsets.all(0.5).h,
              //   decoration: BoxDecoration(
              //     color: Color(0xFFB9B0B0),
              //     borderRadius: BorderRadius.circular(12).r,
              //   ),
              //   child: Container(
              //     padding: EdgeInsets.symmetric(horizontal: 13.h, vertical: 12.h),
              //     decoration: BoxDecoration(
              //       color: ColorUtils.textWhite,
              //       borderRadius: BorderRadius.circular(11).r,
              //       // border: Border.all(
              //       //   color: Color(0xFFB9B0B0),
              //       //   width: 0.5.h,
              //       // ),
              //     ),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         Text(
              //           "Enter amount per hour",
              //           style: GoogleFonts.dmSans(
              //             fontSize: 14.h,
              //             fontWeight: FontWeight.w400,
              //             color: Color(0xFFABABAB),
              //           ),
              //         ),
              //         SvgPicture.asset(
              //           "assets/images/manager_view/arrow_down_deductionType.svg",
              //           height: 8.h,
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              SizedBox(height: 30.h),
            ],
          ),
        );
      }
    );
  }
}

Future<void> _showTimePicker(BuildContext context) async {
  FocusManager.instance.primaryFocus?.unfocus();
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
                                final controller = Get.find<ManagerAttendanceController>();

                                controller.selectedOvertimeHour.value = "${selectedHour.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')}";

                                if(controller.selectedOvertimeRate.value.isNotEmpty) {
                                  controller.fetchSelectedFineAmount(
                                    FineData(
                                      deductionDetails: "Overtime",
                                      deductionHours: controller.selectedOvertimeHour.value,
                                      deductionType: controller.selectedOvertimeRate.value,
                                    ),
                                  );
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
