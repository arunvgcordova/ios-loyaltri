import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';
import '../../../Login/login_widgets/custom_check_box.dart';
import '../manager_request_controller/manager_request_controller.dart';

class RequestFilterScreen extends GetView<ManagerRequestController> {
  const RequestFilterScreen({super.key});

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
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 48.h,
                      width: 48.h,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(14).r,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.close,
                          size: 20.h,
                          color: Colors.transparent,
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
                            color: ColorUtils.charcoalBlue.withValues(
                              alpha: 0.1,
                            ),
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
                SizedBox(height: 15.h),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: controller.availableFilters.length,
                    itemBuilder: (context, i) {
                      return Obx(() {
                        String name = '--';
                        if (controller.availableFilters[i] ==
                            RequestFilterTypes.pending) {
                          name = "Pending";
                        } else if (controller.availableFilters[i] ==
                            RequestFilterTypes.approved) {
                          name =
                          controller.currentTabIndex.value == 0
                              ? "Pardon"
                              : "Approved";
                        } else if (controller.availableFilters[i] ==
                            RequestFilterTypes.rejected) {
                          name =
                          controller.currentTabIndex.value == 0
                              ? "Applied Fine"
                              : "Rejected";
                        }
                        bool isSelected =
                            controller
                                .filters
                                .value[controller.currentTabIndex.value]
                                .filter ==
                                controller.availableFilters[i];
                        return Padding(
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
                                borderRadius: BorderRadius.circular(5).r,
                                checkIcon: const Icon(Icons.done_rounded),
                                // selectedIconColor:
                                // ColorUtils.lavenderIndigo,
                                borderColor:
                                isSelected
                                    ? ColorUtils.secondaryBlue
                                    : ColorUtils.silverGrey,
                                selectedColor:
                                isSelected
                                    ? ColorUtils.secondaryBlue
                                    : ColorUtils.paleLilac,
                                fillColor: ColorUtils.paleLilac,
                                isChecked: isSelected,
                                onChange: (bool? value) {
                                  controller.changeFilter(i);
                                },
                              ),
                              SizedBox(width: 6.h),
                              Text(
                                name,
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.h,
                                  color: ColorUtils.jetBlack,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          height: 70.h,
          padding: EdgeInsets.symmetric(horizontal: 15.h),
          decoration: BoxDecoration(
            color: ColorUtils.textWhite,
            border: Border(
              top: BorderSide(
                color: ColorUtils.workEntryHead.withValues(alpha: 0.1),
                width: 1.h,
              ),
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
                    border: Border.all(color: ColorUtils.ashGrey, width: 1.h),
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
                    ManagerRequestController managerRequestController = Get.find<ManagerRequestController>();
                    if(managerRequestController.currentTabIndex.value == 0) {
                      if(managerRequestController.filters.value[managerRequestController.currentTabIndex.value].filter == RequestFilterTypes.pending) {
                        managerRequestController.fetchExcuseList(
                          monthYear: managerRequestController.monthString[managerRequestController.currentMonthIndex.value],
                        );
                      } else {
                        managerRequestController.fetchExcuseListFilter(
                          monthYear: managerRequestController.monthString[managerRequestController.currentMonthIndex.value],
                        );
                      }
                    }

                    if(managerRequestController.currentTabIndex.value == 1) {
                      managerRequestController.fetchPunchApprovalReqList(
                        monthYr: managerRequestController.monthString[managerRequestController.currentMonthIndex.value],
                      );
                    }

                    if(managerRequestController.currentTabIndex.value == 2) {
                      managerRequestController.fetchOvertimeList(
                        monthYear: managerRequestController.monthString[managerRequestController.currentMonthIndex.value],
                      );
                    }

                    if(managerRequestController.currentTabIndex.value == 5) {
                      managerRequestController.fetchEmployeeLeaveList(
                        monthYr: managerRequestController.monthString[managerRequestController.currentMonthIndex.value],
                      );
                    }

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
