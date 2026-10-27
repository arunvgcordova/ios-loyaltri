import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/controller/userAuthentication.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';
import '../../../../utils/color_utils.dart';
import '../task_controller/task_controller.dart';

class TaskTabSwitch extends StatelessWidget {
  final bool isDarkMode;
  const TaskTabSwitch({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(58.r),
        color: isDarkMode ? ColorUtils.foregroundBlack : ColorUtils.cloudWhite,
        border: Border.all(color: isDarkMode ? const Color(0xFF414141) : ColorUtils.pearlGrey, width: 1.h),
      ),
      child: LayoutBuilder(
        builder: (context, constrains) {
          return GetX<ManagerTaskController>(
            builder: (ManagerTaskController controller) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(controller.allTabs.length, (index) {
                  return Padding(
                    padding: EdgeInsets.all(3.h),
                    child: GestureDetector(
                      onTap: () {
                        controller.currentTabIndex.value = index;
                        UserProfileController userProfileController = Get.find<UserProfileController>();
                        String? companyId;
                        if(!isDarkMode) {
                          companyId = userProfileController.currentCompany.value?.companyId?.toString() ?? userProfileController.userData.value.result.companyId.toString();
                        } else {
                          companyId = userProfileController.userData.value.result.companyId.toString();
                        }
                        String employeeId = Get.find<UserAuthController>().userData.value.userData?.employeeId ?? '--';
                        controller.fetchTaskDashboardCount(empId: employeeId, compId: companyId);
                        controller.fetchTaskListData(empId: employeeId, compId: companyId);
                      },
                      child: Container(
                        width: controller.allTabs.length == 2 ? (constrains.maxWidth * 0.48) : null,
                        padding: controller.allTabs.length == 2 ? null : EdgeInsets.only(
                          left:
                              (controller.currentTabIndex.value == index ||
                                      index == 0)
                                  ? 15.w
                                  : 0,
                          right:
                              (controller.currentTabIndex.value == index ||
                                      (controller.allTabs.length == (index + 1)))
                                  ? 15.w
                                  : 0,
                        ),
                        decoration: isDarkMode ? BoxDecoration(
                          color: controller.currentTabIndex.value == index ? Color(0xFF454052) : ColorUtils.foregroundBlack,
                          borderRadius: BorderRadius.circular(46.r),
                          boxShadow:
                          controller.currentTabIndex.value == index
                              ? [
                            BoxShadow(
                              spreadRadius: 0,
                              color: ColorUtils.workEntryHead.withValues(
                                alpha: 0.13,
                              ),
                              blurRadius: 7.2,
                              blurStyle: BlurStyle.outer,
                              offset: Offset(0, 2),
                            ),
                          ]
                              : null,
                        ) : BoxDecoration(
                          borderRadius: BorderRadius.circular(46.r),
                          gradient:
                              controller.currentTabIndex.value == index
                                  ? LinearGradient(
                                    colors: [
                                      ColorUtils.textWhite,
                                      ColorUtils.softCold,
                                      ColorUtils.textWhite,
                                      ColorUtils.textWhite,
                                    ],
                                  )
                                  : null,
                          boxShadow:
                              controller.currentTabIndex.value == index
                                  ? [
                                    BoxShadow(
                                      spreadRadius: 0,
                                      color: ColorUtils.workEntryHead.withValues(
                                        alpha: 0.13,
                                      ),
                                      blurRadius: 7.2,
                                      blurStyle: BlurStyle.outer,
                                      // offset: Offset(0, 2),
                                    ),
                                  ]
                                  : null,
                        ),
                        child: Center(
                          child: Row(
                            // mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                controller.allTabs[index].title,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  fontSize: 11.h,
                                  fontWeight:
                                      controller.currentTabIndex.value == index
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                  color: isDarkMode ? ColorUtils.textWhite : ColorUtils.workEntryHead,
                                ),
                              ),
                              SizedBox(width: 4.h),
                              Container(
                                height: 18.h,
                                width: 20.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4.r),
                                  color:
                                      controller.currentTabIndex.value == index
                                          ? ColorUtils.secondaryBlue
                                          : ColorUtils.warmGrey,
                                ),
                                child: Center(
                                  child: Text(
                                    controller.allTabs[index].count,
                                    style:
                                        controller.currentTabIndex.value == index
                                            ? GoogleFonts.inter(
                                              color: ColorUtils.textWhite,
                                              fontSize: 9.h,
                                              fontWeight: FontWeight.w600,
                                            )
                                            : GoogleFonts.inter(
                                              color: ColorUtils.steelBlue,
                                              fontSize: 10.h,
                                              fontWeight: FontWeight.w500,
                                            ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              );
            }
          );
        }
      ),
    );
  }
}
