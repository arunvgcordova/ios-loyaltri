import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/ManagerView/Shift_Scheduler/shift_scheduler_controller/shift_scheduler_controller.dart';
import 'package:loyaltri_minimal/models/manager/shift_scheduler_employee.dart';

import '../../../../../utils/color_utils.dart';
import '../../Manager_Attendance/attendance_widgets_manager/common_widgets.dart';

class ShiftListSheet extends StatefulWidget {
  const ShiftListSheet({super.key});

  @override
  State<ShiftListSheet> createState() => _ShiftListSheetState();
}

class _ShiftListSheetState extends State<ShiftListSheet> {

  void _selectShift(int index) {
    Get.find<ShiftSchedulerController>().allShifts.value[index].isSelected = !Get.find<ShiftSchedulerController>().allShifts.value[index].isSelected;
    Get.find<ShiftSchedulerController>().allShifts.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorUtils.textWhite,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 12.h),
            // Header
            Container(
              width: 97.h,
              height: 5.h,
              decoration: BoxDecoration(
                color: ColorUtils.workEntryHead.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(5.r),
              ),
            ),
            SizedBox(height: 18.h),
            Text(
              "Choose a shift",
              style: GoogleFonts.poppins(
                fontSize: 15.h,
                fontWeight: FontWeight.w500,
                color: ColorUtils.workEntryHead,
              ),
            ),
            SizedBox(height: 20.h),
            
            // Shift List Cards
            Flexible(
              child: GetX<ShiftSchedulerController>(
                builder: (ShiftSchedulerController controller) {
                  if(controller.allShifts.value.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 12.h,
                        horizontal: 14.h,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                  Icons.calendar_month,
                                  color: ColorUtils.workEntryHead.withValues(alpha: 0.4),
                                size: 35.h,
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            "No Shifts found",
                            style: GoogleFonts.poppins(
                              color: ColorUtils.workEntryHead,
                              fontWeight: FontWeight.w500,
                              fontSize: 11.h,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            "Configure shifts in settings.",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: ColorUtils.workEntryHead.withValues(alpha: 0.7),
                              fontWeight: FontWeight.w400,
                              fontSize: 11.h,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.allShifts.value.length,
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    itemBuilder: (context, index) {
                      final shift = controller.allShifts.value[index];
                      return GestureDetector(
                        onTap: () => _selectShift(index),
                        child: AnimatedContainer(
                          height: 46.h,
                          duration: const Duration(milliseconds: 200),
                          margin: EdgeInsets.only(bottom: 10.h),
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          decoration: BoxDecoration(
                            color: ColorUtils.softLilac,
                            borderRadius: BorderRadius.circular(8).r,
                            border: Border.all(
                              color: shift.isSelected ? ColorUtils.secondaryBlue : Colors.transparent,
                              width: 2.h,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                shift.shift ?? '--',
                                style: GoogleFonts.poppins(
                                  fontSize: 13.h,
                                  fontWeight: FontWeight.w500,
                                  color: ColorUtils.workEntryHead,
                                ),
                              ),
                              if (shift.isSelected)
                                Icon(
                                  Icons.check,
                                  color: ColorUtils.secondaryBlue,
                                  size: 22.h,
                                )
                              else
                                SizedBox(width: 22.h), // Consistent spacing
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              ),
            ),
            SizedBox(height: 10.h),
            
            // Bottom Save Button
            GetX<ShiftSchedulerController>(
              builder: (ShiftSchedulerController controller) {
                if(controller.selectedSchemes.value.isEmpty) {
                  return SizedBox.shrink();
                } else {
                  return Padding(
                    padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 15.h),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30).r,
                      onTap: () async {
                        ShiftSchedulerEmployeeResponse? resp = await controller.saveRosterShiftScheduler();
                        if(resp?.status == 200) {
                          AttendanceCommonWidgets().showSnackBar(
                            context: context,
                            backgroundColor: Colors.green,
                            message: resp?.message ?? 'Shift added.',
                          );
                        } else {
                          AttendanceCommonWidgets().showSnackBar(
                            context: context,
                            backgroundColor: Colors.red,
                            message: resp?.message ?? 'Failed to add shift.',
                          );
                        }
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: 52.h,
                        decoration: BoxDecoration(
                          color: ColorUtils.secondaryBlue,
                          borderRadius: BorderRadius.circular(37).r,
                        ),
                        child: Center(
                          child: controller.showButtonLoading.value
                              ? SizedBox(
                            width: 20.h,
                                height: 20.h,
                                child: CircularProgressIndicator(
                                color: ColorUtils.textWhite,
                                                          ),
                              )
                              : Text(
                            "Save",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 15.h,
                              color: ColorUtils.textWhite,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }
              }
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showShiftListSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) {
      return const ShiftListSheet();
    },
  );
}
