import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../../../../models/manager/manager_attendance_list_model.dart';
import '../../../../utils/color_utils.dart';
import '../manager_attendance_controller/manager_attendance_controller.dart';

class AttendanceTypeButtons extends StatelessWidget {
  const AttendanceTypeButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 13.h, vertical: 6.h),
      child: Container(
        decoration: BoxDecoration(
          color: ColorUtils.textWhite,
          borderRadius: BorderRadius.circular(16).r,
          border: Border.all(
            color: ColorUtils.workEntryHead.withValues(alpha: 0.1),
            width: 1.h,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 10.h),
              child: Row(
                children: [
                  SvgPicture.asset(
                    "assets/images/manager_view/pencil_icon.svg",
                    height: 12.h,
                    colorFilter: ColorFilter.mode(
                      ColorUtils.workEntryHead,
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(width: 6.h),
                  Text(
                    "Edit Attendance",
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.dmSans(
                      fontSize: 13.h,
                      fontWeight: FontWeight.w600,
                      color: ColorUtils.workEntryHead,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: ColorUtils.workEntryHead.withValues(alpha: 0.1),
              thickness: 1.h,
              height: 0,
            ),
            GridView.builder(
              itemCount: leaveTypes.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.h),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10.h,
                mainAxisSpacing: 10.h,
                childAspectRatio: 2.5.w,
              ),
              itemBuilder: (context, index) {
                return Obx(
                  () => InkWell(
                    borderRadius: BorderRadius.circular(7.r),
                    onTap: () async {
                      String? status = Get.find<ManagerAttendanceController>().selectedEmployeeData.value?.status?.replaceAll(" ", "").trim().toLowerCase();
                      String? halfDay = Get.find<ManagerAttendanceController>().selectedEmployeeData.value?.isHalfDay;
                      String? isOffDay = Get.find<ManagerAttendanceController>().selectedEmployeeData.value?.isOffDay;
                      String? isHoliday = Get.find<ManagerAttendanceController>().selectedEmployeeData.value?.isHoliday;
                      if(status == 'absent' && (leaveTypes[index].type == EditAttType.fine || leaveTypes[index].type == EditAttType.overTime)) return;
                      if(status == 'present' && leaveTypes[index].type == EditAttType.paidLeave && halfDay != '1') return;
                      if(isOffDay == '1' && (leaveTypes[index].type == EditAttType.halfDay || leaveTypes[index].type == EditAttType.fine || leaveTypes[index].type == EditAttType.paidLeave || leaveTypes[index].type == EditAttType.overTime)) return;
                      if(isHoliday == '1' && (leaveTypes[index].type == EditAttType.halfDay || leaveTypes[index].type == EditAttType.fine || leaveTypes[index].type == EditAttType.paidLeave || leaveTypes[index].type == EditAttType.absent || leaveTypes[index].type == EditAttType.overTime)) return;

                      context.loaderOverlay.show();
                      ManagerAttendanceController managerAttendanceController = Get.find<ManagerAttendanceController>();
                      managerAttendanceController.editType.value = leaveTypes[index];
                      Get.find<ManagerAttendanceController>().savedEditType.value = leaveTypes[index];
                      ManagerEmployeeData? employeeData = managerAttendanceController.selectedEmployeeData.value;
                      managerAttendanceController.resetPunchValues();
                      if(leaveTypes[index].type == EditAttType.present) {
                        await managerAttendanceController.fetchEmployeeShift();
                        await managerAttendanceController.fetchEmployeeAttDetail(attId: employeeData?.employeeDailyAttendanceId.toString() ?? '');
                      }
                      if(leaveTypes[index].type == EditAttType.halfDay) {
                        await managerAttendanceController.fetchEmployeeShift();
                        await managerAttendanceController.fetchEmployeeLeaveType();
                        await managerAttendanceController.fetchEmployeeAttDetail(attId: employeeData?.employeeDailyAttendanceId.toString() ?? '');
                      }
                      if(leaveTypes[index].type == EditAttType.fine) {
                        await managerAttendanceController.fetchEmployeeAttDetail(attId: employeeData?.employeeDailyAttendanceId.toString() ?? '');
                      }
                      if(leaveTypes[index].type == EditAttType.overTime) {
                        await managerAttendanceController.fetchEmployeeAttDetail(attId: employeeData?.employeeDailyAttendanceId.toString() ?? '');
                      }
                      if(leaveTypes[index].type == EditAttType.paidLeave) {
                        await managerAttendanceController.fetchEmployeeAttDetail(attId: employeeData?.employeeDailyAttendanceId.toString() ?? '');
                        await managerAttendanceController.fetchEmployeeLeaveType();
                      }
                      context.loaderOverlay.hide();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color:
                            Get.find<ManagerAttendanceController>()
                                        .editType
                                        .value ==
                                    leaveTypes[index]
                                ? leaveTypes[index].selectedColor
                                : Color(0xFFE4E8EB),
                        borderRadius: BorderRadius.circular(7.r),
                      ),
                      child: Text(
                        leaveTypes[index].title,
                        style: GoogleFonts.dmSans(
                          fontSize: 12.h,
                          fontWeight: FontWeight.w500,
                          color:
                              Get.find<ManagerAttendanceController>()
                                          .editType
                                          .value ==
                                      leaveTypes[index]
                                  ? leaveTypes[index].selectedTextColor
                                  : ColorUtils.workEntryHead,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

List<EditLeaveTypes> leaveTypes = [
  EditLeaveTypes(
    type: EditAttType.present,
    title: "Present",
    selectedColor: Color(0xFF07AD5F),
    selectedTextColor: ColorUtils.textWhite,
  ),
  EditLeaveTypes(
    type: EditAttType.halfDay,
    title: "Half Day",
    selectedColor: Color(0xFFFCAE33).withValues(alpha: 0.149),
    selectedTextColor: Color(0xFFD78100),
  ),
  EditLeaveTypes(
    type: EditAttType.absent,
    title: "Absent",
    selectedColor: Color(0xFFED2F2F),
    selectedTextColor: ColorUtils.textWhite,
  ),
  EditLeaveTypes(
    type: EditAttType.fine,
    title: "Fine",
    selectedColor: Color(0xFFFFE0DE),
    selectedTextColor: Color(0xFFB80000),
  ),
  EditLeaveTypes(
    type: EditAttType.overTime,
    title: "Overtime",
    selectedColor: Color(0xFFF3ABFF).withValues(alpha: 0.149),
    selectedTextColor: ColorUtils.ot2,
  ),
  EditLeaveTypes(
    type: EditAttType.paidLeave,
    title: "Paid Leave",
    selectedColor: Color(0xFFCBE9FF),
    selectedTextColor: Color(0xFF045FBB),
  ),
];

enum EditAttType { present, halfDay, absent, fine, overTime, paidLeave }

class EditLeaveTypes {
  final String title;
  final Color selectedColor;
  final Color selectedTextColor;
  final EditAttType type;

  const EditLeaveTypes({
    required this.title,
    required this.selectedColor,
    required this.selectedTextColor,
    required this.type,
  });
}
