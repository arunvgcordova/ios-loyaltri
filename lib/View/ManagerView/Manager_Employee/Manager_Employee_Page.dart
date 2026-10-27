
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loyaltri_minimal/View/CWidgets/cwidgets.dart';
import 'package:loyaltri_minimal/controller/ui_controller/home_controller.dart';
import 'package:loyaltri_minimal/controller/ui_controller/page_controller.dart';
import 'package:loyaltri_minimal/models/manager/all_employee_list.dart';
import '../../../controller/userAuthentication.dart';
import '../../../utils/color_utils.dart';
import '../Manager_Attendance/manager_attendance_controller/manager_attendance_controller.dart';
import '../Manager_Request/request_wigets_manager/searchAndFilter.dart';
import 'Employee_Profile_Page.dart';
import 'employee_page_controller/employee_page_controller.dart';
import 'employee_widgets_manager/employee_card.dart';

class ManagerEmployeePage extends StatefulWidget {
  final bool isSelectEmployee;
  final bool isDarkMode;
  final Function(CompanyEmployeeData)? onSelected;
  const ManagerEmployeePage({super.key, required this.isSelectEmployee, this.onSelected, required this.isDarkMode});

  @override
  State<ManagerEmployeePage> createState() => _ManagerEmployeePageState();
}

class _ManagerEmployeePageState extends State<ManagerEmployeePage> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if(widget.isSelectEmployee) {
        context.loaderOverlay.show();
        await Get.find<ManagerEmployeeController>().fetchAllEmployee(isAll: widget.isSelectEmployee ? true : Get.find<UserAuthController>().userData.value.userData?.unrestrictedList ?? false);
        context.loaderOverlay.hide();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    if(Get.find<UserPageController>().appView.value == AppView.manager) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        if(widget.isSelectEmployee) {
          if(!(Get.find<UserAuthController>().userData.value.userData?.unrestrictedList ?? false)) {
            Get.find<ManagerEmployeeController>().fetchAllEmployee(isAll: Get.find<UserAuthController>().userData.value.userData?.unrestrictedList ?? false);
          }
        }
      });
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: widget.isDarkMode ? ColorUtils.workEntryHead : ColorUtils.textWhite,
        body: Stack(
          children: [
            if(!widget.isDarkMode)
              gradientContainer1,
            SafeArea(
              child: RefreshIndicator(
                onRefresh: () async {
                  await Get.find<ManagerEmployeeController>().fetchAllEmployee(isAll: widget.isSelectEmployee ? true : Get.find<UserAuthController>().userData.value.userData?.unrestrictedList ?? false);
                },
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 28.h, right: 15.h, left: 15.h),
                      child: Row(
                        mainAxisAlignment: widget.isSelectEmployee ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                        children: [
                          if(widget.isSelectEmployee)
                            Container(
                              height: 48.h,
                              width: 48.h,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(14.r),
                                border: Border.all(
                                  color: Colors.transparent,
                                ),
                              ),
                            ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                "assets/images/manager_view/people_icon.png",
                                width: 23.h,
                              ),
                              SizedBox(width: 5.h),
                              Text(
                                widget.isSelectEmployee ? "Select Employee" : "People",
                                style: GoogleFonts.poppins(
                                  color: widget.isDarkMode ? ColorUtils.textWhite : ColorUtils.workEntryHead,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15.h,
                                ),
                              ),
                            ],
                          ),
                          if(widget.isSelectEmployee)
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Container(
                                height: 48.h,
                                width: 48.h,
                                decoration: BoxDecoration(
                                  color: widget.isDarkMode ? ColorUtils.foregroundBlack : ColorUtils.textWhite,
                                  borderRadius: BorderRadius.circular(14.r),
                                  border: Border.all(
                                    color: const Color(0xFF3F4450).withValues(alpha: 0.1),
                                  ),
                                ),
                                child: Center(child: Icon(Icons.close, size: 23.h, color: widget.isDarkMode ? ColorUtils.textWhite : ColorUtils.workEntryHead)),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15.w,
                        // vertical: 10.h,
                      ),
                      child: SearchAndFilter(
                        filterPage: FilterPage.empProfile,
                        color: widget.isDarkMode ? ColorUtils.foregroundBlack : ColorUtils.snowGrey,
                        result: (value) {
                          Get.find<ManagerEmployeeController>()
                              .filterEmployeeByName(name: value);
                        },
                        showFilter: false,
                        isDarkMode: widget.isDarkMode,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    GetX<ManagerEmployeeController>(
                      builder: (ManagerEmployeeController controller) {
                        return Expanded(
                          child:
                              controller.allEmployees.isNotEmpty
                                  ? ListView.separated(
                                    itemCount: controller.allEmployees.length,
                                    padding: EdgeInsets.only(
                                      bottom: 100.h,
                                      left: 5.w,
                                      right: 5.w,
                                    ),
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.w,
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            if(widget.isSelectEmployee) {
                                              widget.onSelected!(controller.allEmployees[index]);
                                              Navigator.of(context).pop();
                                            } else {
                                              Navigator.of(context).push(
                                                newSlideNavigation(EmployeeProfilePage(companyEmployeeData: controller.allEmployees[index])),
                                              );
                                            }
                                          },
                                          child: EmployeeCardManager(
                                            companyEmployeeData:
                                                controller.allEmployees[index],
                                            isDarkMode: widget.isDarkMode,
                                          ),
                                        ),
                                      );
                                    },
                                    separatorBuilder:
                                        (context, index) => SizedBox(height: 8.h),
                                  )
                                  : LayoutBuilder(
                                builder: (context, constraints) {
                                  return SingleChildScrollView(
                                    physics: AlwaysScrollableScrollPhysics(),
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        minHeight: constraints.maxHeight, // Fill remaining space
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(vertical: 50.h),
                                          child: Text(
                                            "No Data Found",
                                            style: TextStyle(
                                              color: widget.isDarkMode ? ColorUtils.textWhite.withValues(alpha: 0.6) : ColorUtils.workEntryHead
                                                  .withValues(alpha: 0.6),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                                  // : Center(
                                  //   child: Text(
                                  //     "No Data Found",
                                  //     style: TextStyle(
                                  //       color: ColorUtils.workEntryHead
                                  //           .withValues(alpha: 0.6),
                                  //     ),
                                  //   ),
                                  // ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
