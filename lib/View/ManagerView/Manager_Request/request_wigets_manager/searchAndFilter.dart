import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:get/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loyaltri_minimal/View/CWidgets/cwidgets.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/manager_attendance_controller/manager_attendance_controller.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Request/request_wigets_manager/filter_screen.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Request/request_wigets_manager/request_filter_screen.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Task/task_controller/task_controller.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Task/task_widgets/task_filter_screen.dart';
import 'package:loyaltri_minimal/View/ManagerView/Shift_Scheduler/shift_scheduler_controller/shift_scheduler_controller.dart';
import 'package:loyaltri_minimal/View/ManagerView/Shift_Scheduler/widgets/shift_scheduler_filter_screen.dart';
import 'package:loyaltri_minimal/View/ManagerView/Piece_Work/piece_work_controller/piece_work_controller.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';

import '../../../../controller/userAuthentication.dart';
import '../../../../controller/userProfileController.dart';

class SearchAndFilter extends StatelessWidget {
  final Color color;
  final Function(String) result;
  final bool showFilter;
  final FilterPage filterPage;
  final bool isDarkMode;
  const SearchAndFilter({
    super.key,
    required this.color,
    required this.result,
    required this.showFilter,
    required this.filterPage,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(50).r,
            ),
            height: 44.h,
            child: TextField(
              controller: filterPage == FilterPage.pieceWork
                  ? null
                  : Get.find<ManagerAttendanceController>().employeeSerachcontroller,
              onChanged: (value) {
                result(value);
              },
              style: GoogleFonts.poppins(
                color: isDarkMode ? ColorUtils.textWhite : ColorUtils.workEntryHead,
                fontSize: 13.h,
                fontWeight: FontWeight.w400,
              ),
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                isDense: true,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: filterPage == FilterPage.task ? "Search..." : "Search employee",
                hintStyle: GoogleFonts.poppins(
                  color: isDarkMode ? ColorUtils.textWhite.withValues(alpha: 0.5) : ColorUtils.workEntryHead.withValues(alpha: 0.5),
                  fontSize: 12.h,
                  fontWeight: FontWeight.w400,
                ),
                // contentPadding: EdgeInsets.symmetric(
                //   vertical: 12.h,
                //   horizontal: 10.h,
                // ),
                prefixIconConstraints: BoxConstraints(minWidth: 38.h),
                prefixIcon: Padding(
                  padding: EdgeInsets.only(top: 12.h, left: 12.h, bottom: 12.h),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        "assets/images/manager_view/search_icon_req.svg",
                        fit: BoxFit.contain,
                        colorFilter: isDarkMode ? ColorFilter.mode(ColorUtils.textWhite.withValues(alpha: 0.7), BlendMode.srcIn) : null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        if(showFilter)
          SizedBox(width: 12.h),
        if(showFilter)
          InkWell(
          borderRadius: BorderRadius.circular(14).r,
          onTap: () async {
            if (filterPage == FilterPage.attendance) {
              if (!Get.find<ManagerAttendanceController>().filterLoaded.value) {
                context.loaderOverlay.show();
                Get.find<ManagerAttendanceController>().fetchAllFilters();
                context.loaderOverlay.hide();
              }
              Navigator.of(context).push(
                newSlideFromBottomNavigation(AttendanceFilterScreen()),
              );
            }
            if (filterPage == FilterPage.requests) {Navigator.of(context).push(
              newSlideFromBottomNavigation(RequestFilterScreen()),
              );
            }
            if (filterPage == FilterPage.shiftScheduler) {
              Navigator.of(context).push(
                newSlideFromBottomNavigation(const ShiftSchedulerFilterScreen()),
              );
            }
            if(filterPage == FilterPage.task) {
             await Navigator.of(context).push(
               newSlideFromBottomNavigation(TaskFilterScreen(isDarkMode: isDarkMode)),
             ).then((value) {
                if(value ?? false) {
                  UserProfileController userProfileController = Get.find<UserProfileController>();
                  String? companyId;
                  if(!isDarkMode) {
                    companyId = userProfileController.currentCompany.value?.companyId?.toString() ?? userProfileController.userData.value.result.companyId.toString();
                  } else {
                    companyId = userProfileController.userData.value.result.companyId.toString();
                  }
                  String employeeId = Get.find<UserAuthController>().userData.value.userData?.employeeId ?? '--';
                  Get.find<ManagerTaskController>().fetchTaskListData(empId: employeeId, compId: companyId);
                } else {
                  for (var filter in Get.find<ManagerTaskController>().filters.value[1].filters) {
                    filter.isSelected = false;
                  }
                  for (var filter in Get.find<ManagerTaskController>().filters.value[0].filters) {
                    filter.isSelected = false;
                  }
                  Get.find<ManagerTaskController>().filters.value[2].filters = [];
                }
              });
            }
          },
          child: Container(
            width: 44.h,
            height: 44.h,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(14).r,
              border: isDarkMode ? Border.all(color: Color(0xFFDEDEDE).withValues(alpha: 0.12), width: 1.h) : null,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 13.h),
                  child: SvgPicture.asset(
                    "assets/images/manager_view/filter_icon_req.svg",
                    width: 18.h,
                    colorFilter: isDarkMode ? ColorFilter.mode(ColorUtils.textWhite, BlendMode.srcIn) : null,
                  ),
                ),
                if(filterPage == FilterPage.task)
                  Obx(() {
                    if (Get.find<ManagerTaskController>().isFilterApplied) {
                      return Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 10.h,
                          height: 10.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ColorUtils.mediumPurple,
                          ),
                        ),
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  })
                else if (filterPage == FilterPage.shiftScheduler)
                  Obx(() {
                    if (Get.find<ShiftSchedulerController>().isFilterApplied.value) {
                      return Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 10.h,
                          height: 10.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ColorUtils.mediumPurple,
                          ),
                        ),
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  })
                else
                  Obx(() {
                    List<AttendanceFilterTypes> types =
                        Get.find<ManagerAttendanceController>()
                            .selectedFilters
                            .value;
                    if (types.contains(AttendanceFilterTypes.location) ||
                        types.contains(AttendanceFilterTypes.department) ||
                        types.contains(AttendanceFilterTypes.shiftScheme) ||
                        types.contains(AttendanceFilterTypes.punchType) ||
                        filterPage == FilterPage.requests) {
                      return Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 10.h,
                          height: 10.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ColorUtils.mediumPurple,
                          ),
                        ),
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
