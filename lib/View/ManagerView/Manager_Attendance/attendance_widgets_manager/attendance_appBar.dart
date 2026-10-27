import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/manager_attendance_controller/manager_attendance_controller.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';

class AttendanceAppBar extends StatelessWidget {
  const AttendanceAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              // Navigator.of(context).pop();
            },
            child: Container(
              width: 48.h,
              height: 48.h,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(14).r,
              ),
              // child: Center(
              //   child: Icon(
              //     Icons.arrow_back_ios_rounded,
              //     color: ColorUtils.workEntryHead,
              //     size: 20.h,
              //   ),
              // ),
            ),
          ),
          Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/images/manager_view/attendance_icon.png",
                height: 24.h,
              ),
              SizedBox(width: 5.h),
              Text(
                "Attendance",
                style: GoogleFonts.poppins(
                  color: ColorUtils.workEntryHead,
                  fontWeight: FontWeight.w500,
                  fontSize: 15.h,
                ),
              ),
            ],
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.all(8).h,
            decoration: BoxDecoration(
              color: ColorUtils.textWhite,
              borderRadius: BorderRadius.circular(14).r,
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  "assets/images/manager_view/punch_approval_month.svg",
                  height: 15.h,
                ),
                SizedBox(width: 3.h),
                GetX<ManagerAttendanceController>(
                  builder: (ManagerAttendanceController controller) {
                    return Text(
                      DateFormat('MMM, yyyy').format(controller.dateList.value[controller.currentDateIndex.value]),
                      style: GoogleFonts.poppins(
                        fontSize: 11.h,
                        fontWeight: FontWeight.w500,
                        color: ColorUtils.workEntryHead,
                      ),
                    );
                  }
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // void _showDatePicker(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext builder) {
  //       return Container(
  //         height: 250,
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             // Day Picker
  //             Expanded(
  //               child: CupertinoPicker(
  //                 scrollController: FixedExtentScrollController(initialItem: _selectedDay - 1),
  //                 itemExtent: 40,
  //                 onSelectedItemChanged: (int index) {
  //                   setState(() {
  //                     _selectedDay = _daysInMonth(_selectedMonth, _selectedYear)[index];
  //                   });
  //                 },
  //                 children: _daysInMonth(_selectedMonth, _selectedYear)
  //                     .map((day) => Center(child: Text("$day", style: TextStyle(fontSize: 18))))
  //                     .toList(),
  //               ),
  //             ),
  //             // Month Picker
  //             Expanded(
  //               child: CupertinoPicker(
  //                 scrollController: FixedExtentScrollController(initialItem: _selectedMonth - 1),
  //                 itemExtent: 40,
  //                 onSelectedItemChanged: (int index) {
  //                   setState(() {
  //                     _selectedMonth = index + 1;
  //                     _selectedDay = 1; // Reset day when month changes
  //                   });
  //                 },
  //                 children: List.generate(12, (index) {
  //                   return Center(child: Text("${index + 1}", style: TextStyle(fontSize: 18)));
  //                 }),
  //               ),
  //             ),
  //             // Year Picker
  //             Expanded(
  //               child: CupertinoPicker(
  //                 scrollController: FixedExtentScrollController(initialItem: 0),
  //                 itemExtent: 40,
  //                 onSelectedItemChanged: (int index) {
  //                   setState(() {
  //                     _selectedYear = _yearsList()[index];
  //                   });
  //                 },
  //                 children: _yearsList()
  //                     .map((year) => Center(child: Text("$year", style: TextStyle(fontSize: 18))))
  //                     .toList(),
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
}
