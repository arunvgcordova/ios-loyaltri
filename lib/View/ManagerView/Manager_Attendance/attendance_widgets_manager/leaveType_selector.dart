
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../models/leave_type_api_model.dart';
import '../../../../models/manager/employee_shift_model.dart';
import '../../../../utils/color_utils.dart';
import '../manager_attendance_controller/manager_attendance_controller.dart';

class LeaveTypeSelector extends StatelessWidget {
  const LeaveTypeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<ManagerAttendanceController>(
      builder: (ManagerAttendanceController controller) {
        return Column(
          children: [
            DropdownButtonFormField2<LeaveType?>(
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
                      color: controller.showLeaveTypeValidation.value ? Colors.red : const Color(0xFFB9B0B0),
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
                      color: controller.showLeaveTypeValidation.value ? Colors.red : const Color(0xFFB9B0B0),
                      width: 0.5.h,
                    )
                ),
              ),
              value: controller.selectedLeaveType.value,
              hint: Text(
                "Select leave type",
                style: GoogleFonts.dmSans(
                  fontSize: 14.h,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFFABABAB),
                ),
              ),
              onChanged: (LeaveType? newValue) async {
                controller.selectedLeaveType.value = newValue;
                await controller.fetchEmployeeLeaveData();
              },
              menuItemStyleData: MenuItemStyleData(
                selectedMenuItemBuilder: (context, child) {
                  return Container(
                    color: ColorUtils.dutyCircle.withAlpha(50),
                    child: child,
                  );
                },
              ),
              items: controller.employeeLeaveTypeList.value.map<DropdownMenuItem<LeaveType?>>((leave) {
                return DropdownMenuItem<LeaveType?>(
                  value: leave,
                  child: Container(
                    color: Colors.transparent,
                    child: Text(
                      leave.leaveType ?? '--',
                      style: GoogleFonts.dmSans(
                        fontSize: 14.h,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            if(controller.showLeaveTypeValidation.value)
              Padding(
                padding: EdgeInsets.only(top: 5, left: 5).h,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Leave Type is required",
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
