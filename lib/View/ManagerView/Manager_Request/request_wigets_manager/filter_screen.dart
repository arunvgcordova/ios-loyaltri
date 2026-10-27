import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/manager_attendance_controller/manager_attendance_controller.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';

import '../../../Login/login_widgets/custom_check_box.dart';
import '../manager_request_controller/manager_request_controller.dart';

class AttendanceFilterScreen extends StatelessWidget {
  const AttendanceFilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      left: false,
      right: false,
      child: Scaffold(
        backgroundColor: ColorUtils.textWhite,
        appBar: PreferredSize(
          preferredSize: Size(ScreenUtil().screenWidth, 0),
          child: Container(),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: 25.h, left: 15.h, right: 15.h),
            child: GetX<ManagerAttendanceController>(
              builder: (ManagerAttendanceController controller) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(14).r,
                          onTap: () {
                            for (var filter in controller.filters) {
                              for (var value in filter.filters) {
                                value.isSelected = false;
                              }
                            }
                            controller.applyFilterButtonClick();
                            controller.filters.refresh();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 4.h,
                              horizontal: 10.h,
                            ),
                            decoration: BoxDecoration(
                              color: ColorUtils.iceGrey,
                              borderRadius: BorderRadius.circular(14).r,
                            ),
                            child: Text(
                              "Clear All",
                              style: GoogleFonts.inter(
                                fontSize: 12.h,
                                fontWeight: FontWeight.w500,
                                color: ColorUtils.deepSlate,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          "Filters",
                          style: GoogleFonts.inter(
                            fontSize: 16.h,
                            fontWeight: FontWeight.w500,
                            color: ColorUtils.workEntryHead,
                          ),
                        ),
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
                                size: 20.h,
                                color: ColorUtils.workEntryHead,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if(controller.filterLoaded.value)
                      Expanded(
                        child: ListView.builder(
                          itemCount: controller.filters.value.length,
                          padding: EdgeInsets.symmetric(
                            vertical: 10.h,
                          ),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.filters[index].filterTitle,
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13.h,
                                      color: ColorUtils.workEntryHead,
                                    ),
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: controller.filters[index].filters.length,
                                    itemBuilder: (context, i) {
                                      if (i <= 3 || controller.filters[index].isExpanded) {
                                        return GestureDetector(
                                          onTap: () {
                                            if(controller.filters[index].isExpanded) {
                                              controller.updateExpansion(index);
                                            }
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 10.h,
                                              horizontal: 10.h,
                                            ),
                                            child: Row(
                                              children: [
                                                CustomCheckbox(
                                                  size: 16.h,
                                                  iconSize: 12.h,
                                                  borderWidth: 0.5.h,
                                                  borderRadius:
                                                  BorderRadius.circular(5).r,
                                                  checkIcon: const Icon(
                                                    Icons.done_rounded,
                                                  ),
                                                  // selectedIconColor:
                                                  // ColorUtils.lavenderIndigo,
                                                  borderColor: controller.filters[index].filters[i].isSelected
                                                      ? ColorUtils.secondaryBlue
                                                      : ColorUtils.silverGrey,
                                                  selectedColor: controller.filters[index].filters[i].isSelected
                                                      ? ColorUtils.secondaryBlue
                                                      : ColorUtils.paleLilac,
                                                  fillColor: ColorUtils.paleLilac,
                                                  isChecked: controller.filters[index].filters[i].isSelected,
                                                  onChange: (bool? value) {
                                                    controller.filters[index].filters[i].isSelected = !controller.filters[index].filters[i].isSelected;
                                                    controller.filters.refresh();
                                                    // controller.update();
                                                  },
                                                ),
                                                SizedBox(width: 6.h),
                                                Text(
                                                  controller.filters[index].filters[i].name,
                                                  style: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12.h,
                                                    color: ColorUtils.jetBlack,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      } else if (i == 4) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 12.h,
                                            horizontal: 10.h,
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              controller.updateExpansion(index);
                                            },
                                            child: Row(
                                              children: [
                                                Text(
                                                  "${controller.filters[index].filters.length - 4} more ${controller.filters[index].filterTitle.toLowerCase()}",
                                                  style: GoogleFonts.inter(
                                                    fontSize: 12.h,
                                                    fontWeight: FontWeight.w600,
                                                    color: ColorUtils.steelBlue,
                                                  ),
                                                ),
                                                SizedBox(width: 5.h),
                                                SvgPicture.asset(
                                                  "assets/images/manager_view/filter_arrow_down.svg",
                                                  height: 16.h,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      } else {
                                        return Container();
                                      }
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    else if(controller.filterLoading.value)
                      Expanded(
                        child: Center(
                          child: SpinKitThreeInOut(
                            color: ColorUtils.primaryBlue,
                            size: 28.w,
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: Center(
                          child: Text(
                            "No Data Found",
                            style: GoogleFonts.inter(
                              color: Colors.grey,
                              fontSize: 12.h,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              }
            ),
          ),
        ),
        bottomNavigationBar: Container(
          height: 70.h,
          padding: EdgeInsets.symmetric(horizontal: 15.h),
          decoration: BoxDecoration(
            color: ColorUtils.textWhite,
            border: Border(
              top: BorderSide(color: ColorUtils.workEntryHead.withValues(alpha: 0.1), width: 1.h),
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                spreadRadius: 5,
                color: ColorUtils.stoneGrey.withValues(alpha: 0.1),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 50.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(37).r,
                    color: ColorUtils.textWhite,
                    border: Border.all(
                      color: ColorUtils.ashGrey,
                      width: 1.h,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Cancel",
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w500,
                        fontSize: 15.h,
                        color: ColorUtils.workEntryHead,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.h),
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(37).r,
                  onTap: () {
                    Get.find<ManagerAttendanceController>().applyFilterButtonClick();
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: ColorUtils.secondaryBlue,
                      borderRadius: BorderRadius.circular(37).r,
                    ),
                    child: Center(
                      child: Text(
                        "Apply Filters",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 15.h,
                          color: ColorUtils.textWhite,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
