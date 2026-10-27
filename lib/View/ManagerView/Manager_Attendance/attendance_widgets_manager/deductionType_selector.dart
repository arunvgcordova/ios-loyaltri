
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/models/manager/edit_attendance_models.dart';

import '../../../../utils/color_utils.dart';
import '../manager_attendance_controller/manager_attendance_controller.dart';

class DeductionTypeSelector extends GetView<ManagerAttendanceController> {
  final FineData fineData;
  const DeductionTypeSelector({super.key, required this.fineData});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
        return Column(
          children: [
            DropdownButtonFormField2<String?>(
              isExpanded: true,
              dropdownStyleData: DropdownStyleData(
                padding: EdgeInsets.zero,
                scrollPadding: EdgeInsets.zero,
                isOverButton: false,
                offset: Offset(0, -5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12).r,
                  color: ColorUtils.textWhite,
                  // border: Border.all(
                  //   color: const Color(0xFFB9B0B0),
                  //   width: 0.5.h,
                  // ),
                ),
              ),
              iconStyleData: IconStyleData(
                icon: SvgPicture.asset(
                  "assets/images/manager_view/arrow_down_deductionType.svg",
                  height: 8.h,
                ),
                openMenuIcon: SvgPicture.asset(
                  "assets/images/manager_view/arrow_down_deductionType.svg",
                  height: 8.h,
                  colorFilter: ColorFilter.mode(ColorUtils.secondaryBlue, BlendMode.srcIn),
                ),
              ),
              buttonStyleData: ButtonStyleData(
                padding: EdgeInsets.zero,
                width: ScreenUtil().screenWidth,
                height: 20.h,
                decoration: BoxDecoration(),
              ),
              isDense: true,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 13.h, vertical: 12.h),
                isDense: true,
                filled: true,
                fillColor: ColorUtils.textWhite,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12).r,
                    borderSide: BorderSide(
                      color: controller.showDeductionTypeValidation.value ? Colors.red : const Color(0xFFB9B0B0),
                      width: 0.5.h,
                    )
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12).r,
                    borderSide: BorderSide(
                      color: ColorUtils.secondaryBlue,
                      width: 1.h,
                    )
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12).r,
                    borderSide: BorderSide(
                      color: controller.showDeductionTypeValidation.value ? Colors.red : const Color(0xFFB9B0B0),
                      width: 0.5.h,
                    )
                ),
              ),
              value: fineData.deductionType ?? "Choose Type",
              hint: Text(
                "Choose Type",
                style: GoogleFonts.dmSans(
                  fontSize: 14.h,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFFABABAB),
                ),
              ),
              selectedItemBuilder: (context) => controller.deductionTypes.map((e) {
                return Text(
                  fineData.deductionType ?? "Choose Type",
                  style: GoogleFonts.dmSans(
                    fontSize: 14.h,
                    fontWeight: FontWeight.w400,
                    color: fineData.deductionType == null ? const Color(0xFFABABAB) : ColorUtils.workEntryHead,
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if(newValue != "Choose Type") {
                  for (var fine in controller.fineList.value) {
                    if (fine.deductionDetails == fineData.deductionDetails) {
                      fine.deductionType = newValue;
                      fine.deductionAmount = null;
                      controller.amountControllers[fineData.deductionDetails ?? '']?.text = '';
                    }
                  }
                  controller.fineList.refresh();
                  if(newValue != "Fixed" && (fineData.deductionHours != null || fineData.deductionDetails == "Miss Punch")) {
                    controller.fetchSelectedFineAmount(fineData);
                  }
                } else {
                  for (var fine in controller.fineList.value) {
                    if (fine.deductionDetails == fineData.deductionDetails) {
                      fine.deductionType = null;
                      fine.deductionAmount = null;
                      controller.amountControllers[fineData.deductionDetails ?? '']?.text = '';
                    }
                  }
                  controller.fineList.refresh();
                }
              },
              menuItemStyleData: MenuItemStyleData(
                selectedMenuItemBuilder: (context, child) {
                  return Container(
                    color: ColorUtils.dutyCircle.withAlpha(50),
                    child: child,
                  );
                },
              ),
              items: controller.deductionTypes.map<DropdownMenuItem<String?>>((type) {
                return DropdownMenuItem<String?>(
                  value: type,
                  child: Container(
                    color: Colors.transparent,
                    child: Text(
                      type,
                      style: GoogleFonts.dmSans(
                        fontSize: 14.h,
                        fontWeight: FontWeight.w400,
                        color: type == "Choose Type" ? const Color(0xFFABABAB) : Colors.black,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            if(controller.showDeductionTypeValidation.value)
              Padding(
                padding: EdgeInsets.only(top: 5, left: 5).h,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Deduction Type is required.",
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
        );
      },
    );
  }
}
