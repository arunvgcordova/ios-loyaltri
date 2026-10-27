
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/deductionType_selector.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/manager_attendance_controller/manager_attendance_controller.dart';
import 'package:loyaltri_minimal/controller/userAuthentication.dart';
import 'package:loyaltri_minimal/models/manager/edit_attendance_models.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';

import '../../../../controller/userProfileController.dart';
import 'edit_att_save_button.dart';

class FineView extends StatelessWidget {
  const FineView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<ManagerAttendanceController>(
      builder: (ManagerAttendanceController controller) {
        double totalAmount = 0.0;
        try {
          for (var fine in controller.fineList.value) {
            if(fine.isFineApplied ?? false) {
              totalAmount += double.parse(fine.deductionAmount ?? '0.0');
            }
          }
        } catch(e) {}
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 13.h,
            vertical: 10.h,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14).r,
              border: Border.all(
                color: Color(0xFFE0E0E0),
                width: 1.h,
              )
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(12).h,
                  child: Row(
                    children: [
                      Text(
                        "Fine Types",
                        style: GoogleFonts.inter(
                          fontSize: 12.h,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF101828).withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(color: Color(0xFFE0E0E0), thickness: 1.h, height: 0),
                ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.fineList.length,
                  shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 8.h,
                          horizontal: 12.h,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              controller.fineTypes[index],
                              style: GoogleFonts.dmSans(
                                fontSize: 15.h,
                                fontWeight: FontWeight.w500,
                                color: ColorUtils.workEntryHead,
                              ),
                            ),
                            if(controller.fineList[index].isFineApplied ?? false)
                            //   if(controller.fineList[index].deductionType == "Pardon")
                            //     SizedBox.shrink()
                            // else
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if(controller.fineList[index].deductionDetails != 'Miss Punch')
                                      Text(
                                      convertToReadableTime(controller.fineList[index].deductionHours),
                                      style: GoogleFonts.inter(
                                        fontSize: 11.h,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFFCF0101),
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    if(!Get.find<UserAuthController>().restrictRsInfo.value)
                                      Text(
                                      "-${Get.find<UserProfileController>().userCompanyData.value.result?.currency?.toString() ?? '-'}${controller.fineList[index].deductionAmount ?? '--'}",
                                      style: GoogleFonts.inter(
                                        fontSize: 11.h,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFFCF0101),
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                            for(int i = 0; i < (controller.employeeAttendance.value?.deductions?.length ?? 0); i++)
                              if(controller.fineList[index].deductionDetails == controller.employeeAttendance.value?.deductions?[i].deductionDetails)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 3.h,
                                    horizontal: 10.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: controller.employeeAttendance.value?.deductions?[i].regularizationApplied?.toString() == "1" && controller.employeeAttendance.value?.deductions?[i].remarks?.toString().toLowerCase().trim() == "pardon"
                                        ? ColorUtils.approved.withValues(alpha: 0.08)
                                        : Color(0xFFFFEDED),
                                    borderRadius: BorderRadius.circular(50).r,
                                  ),
                                  child: Text(
                                    controller.employeeAttendance.value?.deductions?[i].regularizationApplied == null || (controller.employeeAttendance.value?.deductions?[i].regularizationApplied?.toString() == "1" && controller.employeeAttendance.value?.deductions?[i].remarks?.toString().toLowerCase().trim() == "pending")
                                        ? "Auto Deduction"
                                        : controller.employeeAttendance.value?.deductions?[i].regularizationApplied?.toString() == "1" && controller.employeeAttendance.value?.deductions?[i].remarks?.toString().toLowerCase().trim() == "fine"
                                        ? "Fine Applied"
                                        : controller.employeeAttendance.value?.deductions?[i].regularizationApplied?.toString() == "1" && controller.employeeAttendance.value?.deductions?[i].remarks?.toString().toLowerCase().trim() == "pardon"
                                        ? "Regularised"
                                        : "",
                                    style: GoogleFonts.inter(
                                      fontSize: 11.h,
                                      fontWeight: FontWeight.w400,
                                      color: controller.employeeAttendance.value?.deductions?[i].regularizationApplied?.toString() == "1" && controller.employeeAttendance.value?.deductions?[i].remarks?.toString().toLowerCase().trim() == "pardon"
                                          ? ColorUtils.approved : Color(0xFFD70000),
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                            // if(controller.fineList[index].isFineApplied ?? false)
                            //   if(controller.fineList[index].deductionType == "Pardon")
                            //     Container(
                            //       padding: EdgeInsets.symmetric(
                            //         vertical: 3.h,
                            //         horizontal: 10.h,
                            //       ),
                            //       decoration: BoxDecoration(
                            //         color: ColorUtils.approved.withValues(alpha: 0.08),
                            //         borderRadius: BorderRadius.circular(50).r,
                            //       ),
                            //       child: Text(
                            //         "Pardon",
                            //         style: GoogleFonts.inter(
                            //           fontSize: 11.h,
                            //           fontWeight: FontWeight.w400,
                            //           color: ColorUtils.approved,
                            //           fontStyle: FontStyle.italic,
                            //         ),
                            //       ),
                            //     )
                            // else
                            //     Container(
                            //       padding: EdgeInsets.symmetric(
                            //         vertical: 3.h,
                            //         horizontal: 10.h,
                            //       ),
                            //       decoration: BoxDecoration(
                            //         color: Color(0xFFFFEDED),
                            //         borderRadius: BorderRadius.circular(50).r,
                            //       ),
                            //       child: Text(
                            //         "Fine Applied",
                            //         style: GoogleFonts.inter(
                            //           fontSize: 11.h,
                            //           fontWeight: FontWeight.w400,
                            //           color: Color(0xFFD70000),
                            //           fontStyle: FontStyle.italic,
                            //         ),
                            //       ),
                            //     ),
                            InkWell(
                              borderRadius: BorderRadius.circular(12).r,
                              onTap: () {
                                // if(controller.fineTypes[index] == "Miss Punch") {
                                //   showModalBottomSheet(
                                //     backgroundColor: Color(0xFFECECEC),
                                //     context: context,
                                //     isScrollControlled: true,
                                //     barrierColor: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                                //     // constraints: BoxConstraints(
                                //     //   maxHeight: ScreenUtil().screenHeight * 0.8,
                                //     // ),
                                //     builder: (BuildContext context) {
                                //       return _MissPunchBottomSheet();
                                //     },
                                //   );
                                // } else {
                                controller.resetDeductionValues();
                                  showModalBottomSheet(
                                    backgroundColor: Color(0xFFECECEC),
                                    context: context,
                                    isScrollControlled: true,
                                    barrierColor: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                                    // constraints: BoxConstraints(
                                    //   maxHeight: ScreenUtil().screenHeight * 0.8,
                                    // ),
                                    builder: (BuildContext context) {
                                      return GestureDetector(
                                          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                                          child: _FineApplyBottomSheet(controller.fineList[index].deductionDetails ?? ''),
                                      );
                                    },
                                  );
                                // }
                              },
                              child: Container(
                                padding: EdgeInsets.all(12).h,
                                decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12).r,
                                border: Border.all(
                                    color: Color(0xFFE7E7E7),
                                    width: 1.h,
                                  ),
                                ),
                                child: SvgPicture.asset(
                                  (controller.fineList[index].isFineApplied ?? false) ? "assets/images/manager_view/fine_edit_pencil.svg" : "assets/images/manager_view/fine_add.svg",
                                  height: 15.h,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => Divider(color: Color(0xFFE0E0E0), thickness: 1.h, height: 0),
                ),
                if(!Get.find<UserAuthController>().restrictRsInfo.value)
                  Divider(color: Color(0xFFE0E0E0), thickness: 1.h, height: 0),
                if(!Get.find<UserAuthController>().restrictRsInfo.value)
                  Padding(
                  padding: EdgeInsets.all(12).h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Amount:",
                        style: GoogleFonts.dmSans(
                          fontSize: 13.h,
                          fontWeight: FontWeight.w400,
                          color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // SvgPicture.asset(
                          //   "assets/images/manager_view/rupees_red.svg",
                          //   height: 15.h,
                          // ),
                          Text(
                            " ${Get.find<UserProfileController>().userCompanyData.value.result?.currency?.toString() ?? '-'}",
                            style: GoogleFonts.inter(
                              fontSize: 23.h,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFD70000),
                            ),
                          ),
                          Text(
                            " ${totalAmount.toStringAsFixed(2)}",
                            style: GoogleFonts.dmSans(
                              fontSize: 23.h,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFD70000),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String convertToReadableTime(String? time) {
    if (time == null || time.isEmpty || !time.contains(":")) {
      return "0 mins";
    }

    try {
      final parts = time.split(":").map(int.parse).toList();
      if (parts.length != 2) return "0 mins";

      final hours = parts[0];
      final minutes = parts[1];

      if (hours > 0 && minutes > 0) {
        return "${hours}hr ${minutes}mins";
      } else if (hours > 0) {
        return "${hours}hr";
      } else if (minutes > 0) {
        return "${minutes}mins";
      } else {
        return "0 mins";
      }
    } catch (e) {
      return "0 mins";
    }
  }
}

class _FineApplyBottomSheet extends GetView<ManagerAttendanceController> {
  final String fineType;
  const _FineApplyBottomSheet(this.fineType);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(() {
        FineData fineData = controller.fineList.value.singleWhere((fine) => fine.deductionDetails == fineType);
        controller.amountControllers[fineData.deductionDetails]?.text = fineData.deductionAmount ?? '';
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            top: 15.w,
            left: 15.w,
            right: 15.w,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 48.h, height: 48.h),
                  const Spacer(),
                  Image.asset("assets/images/my_request.webp", width: 32.h),
                  SizedBox(width: 3.h),
                  Text(
                    fineType,
                    style: GoogleFonts.dmSans(
                      color: ColorUtils.workEntryHead,
                      fontWeight: FontWeight.w500,
                      fontSize: 15.h,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () async {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 48.h,
                      width: 48.h,
                      padding: EdgeInsets.all(1.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14).r,
                        color: ColorUtils.charcoalBlue.withValues(alpha: 0.1),
                      ),
                      child: Container(
                        // height: 47.h,
                        // width: 47.h,
                        decoration: BoxDecoration(
                          color: ColorUtils.textWhite,
                          borderRadius: BorderRadius.circular(13).r,
                          // border: Border.all(
                          //   width: 1.h,
                          //   color: ColorUtils.charcoalBlue.withValues(alpha: 0.1),
                          // ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.close,
                            size: 18.h,
                            color: ColorUtils.workEntryHead,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              if(fineType != "Miss Punch")
                Row(
                children: [
                  Text(
                    "Hours ",
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
              if(fineType != "Miss Punch")
                SizedBox(height: 6.h),
              if(fineType != "Miss Punch")
                Container(
                padding: EdgeInsets.all(0.5).h,
                decoration: BoxDecoration(
                  color: controller.showHoursValidation.value ? Colors.red : Color(0xFFB9B0B0),
                  borderRadius: BorderRadius.circular(12).r,
                ),
                child: InkWell(
                  onTap: () async {
                    await _showTimePicker(context, fineType);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 13.h,
                      vertical: 12.h,
                    ),
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
                          fineData.deductionHours ?? "Choose Time",
                          style: GoogleFonts.dmSans(
                            fontSize: 14.h,
                            fontWeight: FontWeight.w400,
                            color: fineData.deductionHours == null ? Color(0xFFABABAB) : ColorUtils.workEntryHead,
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
              if(fineType != "Miss Punch")
                if(controller.showHoursValidation.value)
                  Padding(
                    padding: EdgeInsets.only(top: 5, left: 5).h,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Hours is required.",
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
                    "Deduction Type ",
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
              DeductionTypeSelector(fineData: fineData),
              SizedBox(height: 20.h),
              if(!Get.find<UserAuthController>().restrictRsInfo.value || fineData.deductionType == "Fixed")
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
              if(!Get.find<UserAuthController>().restrictRsInfo.value || fineData.deductionType == "Fixed")
                SizedBox(height: 6.h),
              if(!Get.find<UserAuthController>().restrictRsInfo.value || fineData.deductionType == "Fixed")
                Container(
                padding: EdgeInsets.all(0.5).h,
                decoration: BoxDecoration(
                  color: controller.showDeductionAmountValidation.value ? Colors.red : Color(0xFFB9B0B0),
                  borderRadius: BorderRadius.circular(12).r,
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 13.h, vertical: 0), // Remove vertical for proper text field rendering
                  decoration: BoxDecoration(
                    color: fineData.deductionType == "Fixed" ? ColorUtils.textWhite : Color(0xFFE4E4E4),
                    borderRadius: BorderRadius.circular(11).r,
                  ),
                  child: TextField(
                    controller: controller.amountControllers[fineData.deductionDetails],
                    readOnly: fineData.deductionType != "Fixed",
                    onChanged: (value) {
                      fineData.deductionAmount = value;
                    },
                    style: GoogleFonts.dmSans(
                      fontSize: 14.h,
                      fontWeight: FontWeight.w400,
                      color: ColorUtils.workEntryHead,
                    ),
                    decoration: InputDecoration(
                      hintText: "Enter amount",
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
              if(controller.showDeductionAmountValidation.value && (!Get.find<UserAuthController>().restrictRsInfo.value || fineData.deductionType == "Fixed"))
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
              //     padding: EdgeInsets.symmetric(
              //       horizontal: 13.h,
              //       vertical: 12.h,
              //     ),
              //     decoration: BoxDecoration(
              //       color: Color(0xFFE4E4E4),
              //       borderRadius: BorderRadius.circular(11).r,
              //     ),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         Text(
              //           fineData.deductionAmount ?? "Enter amount",
              //           style: GoogleFonts.dmSans(
              //             fontSize: 14.h,
              //             fontWeight: FontWeight.w400,
              //             color: fineData.deductionAmount == null ? Color(0xFFABABAB) : ColorUtils.workEntryHead,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              SizedBox(height: 30.h),
              SizedBox(
                height: 75.h,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 15).h,
                  child: EditAttSaveButton(
                    cancelText: "Cancel",
                    confirmText: "Submit",
                    actionCancel: () {
                      fineData.isFineApplied = false;
                      fineData.deductionAmount = null;
                      fineData.deductionType = null;
                      fineData.deductionHours = null;
                      controller.fineList.refresh();
                      Navigator.of(context).pop();
                    },
                    actionSuccess: () {
                      bool ok = controller.validateFine(fineType);
                      if(ok) {
                        fineData.isFineApplied = true;
                        controller.fineList.refresh();
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
      ),
    );
  }
}

class _MissPunchBottomSheet extends StatelessWidget {
  const _MissPunchBottomSheet();

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Padding(
        padding: EdgeInsets.only(top: 15.w, left: 15.w, right: 15.w),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 48.h, height: 48.h),
                const Spacer(),
                Image.asset("assets/images/my_request.webp", width: 32.h),
                SizedBox(width: 3.h),
                Text(
                  "Late Entry",
                  style: GoogleFonts.dmSans(
                    color: ColorUtils.workEntryHead,
                    fontWeight: FontWeight.w500,
                    fontSize: 15.h,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () async {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height: 48.h,
                    width: 48.h,
                    decoration: BoxDecoration(
                      color: ColorUtils.textWhite,
                      borderRadius: BorderRadius.circular(14).r,
                      border: Border.all(
                        width: 1.h,
                        color: ColorUtils.charcoalBlue.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.close,
                        size: 18.h,
                        color: ColorUtils.workEntryHead,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Text(
                  "Deduction Type",
                  style: GoogleFonts.dmSans(
                    fontSize: 13.h,
                    fontWeight: FontWeight.w500,
                    color: ColorUtils.workEntryHead,
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            // DeductionTypeSelector(),
            // Container(
            //   padding: EdgeInsets.all(0.5).h,
            //   decoration: BoxDecoration(
            //     color: Color(0xFFB9B0B0),
            //     borderRadius: BorderRadius.circular(12).r,
            //   ),
            //   child: Container(
            //     padding: EdgeInsets.symmetric(
            //       horizontal: 13.h,
            //       vertical: 12.h,
            //     ),
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
            //           "Select shift name",
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
            SizedBox(height: 20.h),
            Row(
              children: [
                Text(
                  "Amount",
                  style: GoogleFonts.dmSans(
                    fontSize: 13.h,
                    fontWeight: FontWeight.w500,
                    color: ColorUtils.workEntryHead,
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            Container(
              padding: EdgeInsets.all(0.5).h,
              decoration: BoxDecoration(
                color: Color(0xFFB9B0B0),
                borderRadius: BorderRadius.circular(12).r,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 13.h,
                  vertical: 12.h,
                ),
                decoration: BoxDecoration(
                  color: Color(0xFFE4E4E4),
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
                      "Enter amount",
                      style: GoogleFonts.dmSans(
                        fontSize: 14.h,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFABABAB),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30.h),
            // SizedBox(
            //   height: 75.h,
            //   child: Padding(
            //     padding: const EdgeInsets.only(top: 10, bottom: 15).h,
            //     child: EditAttSaveButton(
            //       cancelText: "Cancel",
            //       confirmText: "Submit",
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

Future<void> _showTimePicker(BuildContext context, String fineType) async {
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
                                List<FineData> fineList = controller.fineList.value;

                                for (var fine in fineList) {
                                  if (fineType == fine.deductionDetails) {
                                    fine.deductionHours =
                                    "${selectedHour.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')}";
                                    if(fine.deductionType != null) {
                                      controller.fetchSelectedFineAmount(fine);
                                    }
                                  }
                                }

                                controller.fineList.refresh();
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

