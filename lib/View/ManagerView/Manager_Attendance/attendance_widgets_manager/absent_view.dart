
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/attendance_type_buttons.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/manager_attendance_controller/manager_attendance_controller.dart';

class AbsentView extends StatelessWidget {
  const AbsentView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ScreenUtil().screenHeight * 0.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/manager_view/absent_exclemation.png",
            height: 141.h,
          ),
          SizedBox(height: 15.h),
          GetX<ManagerAttendanceController>(
            builder: (ManagerAttendanceController controller) {
              String? status = Get.find<ManagerAttendanceController>().selectedEmployeeData.value?.status?.replaceAll(" ", "").trim().toLowerCase();
              return Text(
                status == 'absent'
                    ? "The employee is marked as Absent.\nSelect a different status to edit\ndetails."
                    : "Mark as Absent",
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(
                  fontSize: 15.h,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF969696),
                  fontStyle: FontStyle.italic,
                ),
              );
            }
          ),

        ],
      ),
    );
  }
}
