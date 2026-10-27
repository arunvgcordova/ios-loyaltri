
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Employee/Employee_Profile_Page.dart';
import 'package:loyaltri_minimal/models/manager/all_employee_list.dart';

import '../../../../utils/color_utils.dart';
import '../../Manager_Attendance/attendance_widgets_manager/common_widgets.dart';

class EmployeeCardManager extends StatelessWidget {
  final CompanyEmployeeData companyEmployeeData;
  final bool isDarkMode;
  const EmployeeCardManager({super.key, required this.companyEmployeeData, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6).h,
      decoration: BoxDecoration(
        // color: ColorUtils.textWhite,
        borderRadius: BorderRadius.circular(14).r,
        // border: Border.all(
        //   color: ColorUtils.workEntryHead.withValues(alpha: 0.1),
        //   width: 1.h,
        // ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AttendanceCommonWidgets().cachedNetworkImage(companyEmployeeData.profilePicture ?? '', height: 31.h),
              SizedBox(width: 8.h),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      companyEmployeeData.fullName ?? '--',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 11.h,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode ? ColorUtils.textWhite.withValues(alpha: 0.9) : ColorUtils.workEntryHead.withValues(alpha: 0.9),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          companyEmployeeData.designation ?? '--',
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 11.h,
                            fontWeight: FontWeight.w400,
                            color: isDarkMode ? ColorUtils.textWhite.withValues(alpha: 0.5) : ColorUtils.workEntryHead.withValues(alpha: 0.5),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.h,
                          ),
                          child: Container(
                            width: 1.h,
                            height: 10.h,
                            color: isDarkMode ? ColorUtils.textWhite.withValues(alpha: 0.5) : ColorUtils.workEntryHead.withValues(alpha: 0.5),
                          ),
                        ),
                        Text(
                          "ID ${companyEmployeeData.code ?? '--'}",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 11.h,
                            fontWeight: FontWeight.w400,
                            color: isDarkMode ? ColorUtils.textWhite.withValues(alpha: 0.5) : ColorUtils.workEntryHead.withValues(alpha: 0.5),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Container(
              //   padding: EdgeInsets.symmetric(
              //     vertical: 5.h,
              //     horizontal: 18.h,
              //   ),
              //   constraints: BoxConstraints(
              //     maxWidth: 150.w,
              //   ),
              //   decoration: BoxDecoration(
              //     color: ColorUtils.softPearl,
              //     borderRadius: BorderRadius.circular(14).r,
              //   ),
              //   child: Text(
              //     employeeData?.shiftName ?? 'No Shift',
              //     overflow: TextOverflow.ellipsis,
              //     style: GoogleFonts.inter(
              //       fontSize: 11.h,
              //       fontWeight: FontWeight.w400,
              //       color: ColorUtils.workEntryHead.withValues(alpha: 0.54),
              //     ),
              //   ),
              // ),
            ],
          ),
          // Divider(color: ColorUtils.softGrey, thickness: 1.h, indent: 3.h, endIndent: 3.h),
        ],
      ),
    );
  }
}
