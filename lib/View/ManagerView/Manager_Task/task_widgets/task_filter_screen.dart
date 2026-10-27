import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/manager_attendance_controller/manager_attendance_controller.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Task/task_controller/task_controller.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Task/task_controller/task_controller.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Task/task_controller/task_controller.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';
import '../../../../controller/ui_controller/home_controller.dart';
import '../../../../controller/ui_controller/page_controller.dart';
import '../../../../controller/userAuthentication.dart';
import '../../../CWidgets/date_picker.dart';
import '../../../Login/login_widgets/custom_check_box.dart';
import '../../Manager_Employee/employee_page_controller/employee_page_controller.dart';

class TaskFilterScreen extends StatefulWidget {
  final bool isDarkMode;
  const TaskFilterScreen({super.key, required this.isDarkMode});

  @override
  State<TaskFilterScreen> createState() => _TaskFilterScreenState();
}

class _TaskFilterScreenState extends State<TaskFilterScreen> {
  ManagerTaskController managerTaskController = Get.find<ManagerTaskController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      context.loaderOverlay.show();
      await Get.find<ManagerEmployeeController>().fetchAllEmployee(isAll: true);

      managerTaskController.employees = [];
      if(managerTaskController.filters.value[1].filters.isEmpty) {
        for(int i = 0; i < Get.find<ManagerEmployeeController>().allEmployeesCopy.value.length; i++) {
          managerTaskController.filters.value[1].filters.add(Filters(
            id: Get.find<ManagerEmployeeController>().allEmployeesCopy.value[i].employeeId ?? '',
            name: Get.find<ManagerEmployeeController>().allEmployeesCopy.value[i].fullName ?? '',
            isSelected: false,
          ));
        }
      }
      managerTaskController.filters.refresh();
      context.loaderOverlay.hide();
    });
    super.initState();
  }

  @override
  void dispose() {
    if(Get.find<UserPageController>().appView.value == AppView.manager) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        if(!(Get.find<UserAuthController>().userData.value.userData?.unrestrictedList ?? false)) {
          await Get.find<ManagerEmployeeController>().fetchAllEmployee(isAll: Get.find<UserAuthController>().userData.value.userData?.unrestrictedList ?? false);
        }
      });
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        bottom: true,
        top: false,
        left: false,
        right: false,
        child: Scaffold(
          backgroundColor: widget.isDarkMode ? ColorUtils.workEntryHead : ColorUtils.textWhite,
          appBar: PreferredSize(
            preferredSize: Size(ScreenUtil().screenWidth, 0),
            child: Container(),
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 25.h, left: 15.h, right: 15.h),
            child: GetX<ManagerTaskController>(
                builder: (ManagerTaskController controller) {
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
                              controller.filters.value[2].filters = [];
                              // controller.applyFilterButtonClick();
                              controller.filters.refresh();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 4.h,
                                horizontal: 10.h,
                              ),
                              decoration: BoxDecoration(
                                color: widget.isDarkMode ? ColorUtils.jetGrey : ColorUtils.iceGrey,
                                borderRadius: BorderRadius.circular(14).r,
                              ),
                              child: Text(
                                "Clear All",
                                style: GoogleFonts.inter(
                                  fontSize: 12.h,
                                  fontWeight: FontWeight.w500,
                                  color: widget.isDarkMode ? ColorUtils.textWhite : ColorUtils.deepSlate,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            "Filters",
                            style: GoogleFonts.inter(
                              fontSize: 16.h,
                              fontWeight: FontWeight.w500,
                              color: widget.isDarkMode ? ColorUtils.textWhite : ColorUtils.workEntryHead,
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
                                color: widget.isDarkMode ? ColorUtils.jetGrey : ColorUtils.textWhite,
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
                                  color: widget.isDarkMode ? ColorUtils.textWhite : ColorUtils.workEntryHead,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        controller.filters[index].filterTitle,
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13.h,
                                          color: widget.isDarkMode ? ColorUtils.textWhite : ColorUtils.workEntryHead,
                                        ),
                                      ),
                                      if(index != 2)
                                        InkWell(
                                        onTap: () {
                                          if(controller.filters[index].filters.every((filter) => filter.isSelected)) {
                                            for (var filter in controller.filters[index].filters) {
                                              filter.isSelected = false;
                                            }
                                          } else {
                                            for (var filter in controller.filters[index].filters) {
                                              filter.isSelected = true;
                                            }
                                          }
                                          controller.filters.refresh();
                                        },
                                        child: Text(
                                          'Select All',
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 11.h,
                                            color: widget.isDarkMode ? ColorUtils.textWhite : ColorUtils.jetBlack,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if(controller.filters[index].filterTitle == 'Assignee')
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 15.h,
                                      ),
                                      child: SizedBox(
                                        height: 40.h,
                                        child: TextFormField(
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 13.h,
                                            color: widget.isDarkMode ? ColorUtils.textWhite : ColorUtils.workEntryHead,
                                          ),
                                          onChanged: (value) {
                                            controller.searchFilter(value);
                                          },
                                          decoration: InputDecoration(
                                            prefixIconConstraints: BoxConstraints(
                                              minWidth: 35.h,
                                              minHeight: 30.h,
                                            ),
                                            prefixIcon: Padding(
                                              padding: EdgeInsets.only(left: 14.h),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/images/manager_view/search_icon_req.svg",
                                                    fit: BoxFit.contain,
                                                    height: 17.h,
                                                    colorFilter: widget.isDarkMode ? ColorFilter.mode(Color(0xff667085), BlendMode.srcIn) : null,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            hintText: 'Search',
                                            hintStyle: GoogleFonts.inter(
                                              fontWeight: FontWeight.w400,
                                                fontSize: 13.h,
                                                color: widget.isDarkMode ? Color(0xff667085) : ColorUtils.steelBlue,
                                            ),
                                            contentPadding: EdgeInsets.zero,
                                            filled: true,
                                            fillColor: widget.isDarkMode ? ColorUtils.jetGrey : ColorUtils.textWhite,
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(7).r,
                                              borderSide: BorderSide(color: Color(0xFFD0D5DD), width: 1.h),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(7).r,
                                              borderSide: BorderSide(color: Color(0xFFD0D5DD), width: 1.h),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  if(controller.filters[index].filterTitle == 'Created on')
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 15.h,
                                      ),
                                      child: SizedBox(
                                        height: 40.h,
                                        child: TextFormField(
                                          controller: TextEditingController(
                                              text: controller.filters.value[2].filters.length == 2
                                              ? "${controller.filters.value[2].filters.first.name} - ${controller.filters.value[2].filters.last.name}"
                                              : ''),
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 13.h,
                                            color: widget.isDarkMode ? ColorUtils.textWhite : ColorUtils.workEntryHead,
                                          ),
                                          onChanged: (value) {},
                                          onTap: () async {
                                            FocusManager.instance.primaryFocus?.unfocus();
                                            DateTimeRange? picked = await pickDateRange(
                                              context,
                                              ThemeMode.light,
                                              firstDate: DateTime(DateTime.now().year - 2),
                                              lastDate: DateTime(DateTime.now().year + 2),
                                            );

                                            if(picked?.start != null && picked?.end != null) {
                                              String startDate = DateFormat('yyyy-MM-dd').format(picked!.start);
                                              String endDate = DateFormat('yyyy-MM-dd').format(picked!.end);
                                              controller.filters.value[2].filters = [
                                                Filters(
                                                    id: startDate,
                                                    name: startDate,
                                                    isSelected: true,
                                                ),
                                                Filters(
                                                    id: endDate,
                                                    name: endDate,
                                                    isSelected: true,
                                                ),
                                              ];
                                              managerTaskController.filters.refresh();
                                            }
                                          },
                                          decoration: InputDecoration(
                                            prefixIconConstraints: BoxConstraints(
                                              minWidth: 35.h,
                                              minHeight: 30.h,
                                            ),
                                            prefixIcon: Padding(
                                              padding: EdgeInsets.only(left: 14.h),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(Icons.calendar_today_outlined, size: 17.h, color: widget.isDarkMode ? ColorUtils.textWhite : ColorUtils.workEntryHead),
                                                ],
                                              ),
                                            ),
                                            hintText: 'Select Date',
                                            hintStyle: GoogleFonts.inter(
                                              fontWeight: FontWeight.w400,
                                                fontSize: 13.h,
                                              color: widget.isDarkMode ? Color(0xff667085) : ColorUtils.steelBlue,
                                            ),
                                            contentPadding: EdgeInsets.zero,
                                            filled: true,
                                            fillColor: widget.isDarkMode ? ColorUtils.jetGrey : ColorUtils.textWhite,
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(7).r,
                                              borderSide: BorderSide(color: Color(0xFFD0D5DD)),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(7).r,
                                              borderSide: BorderSide(color: Color(0xFFD0D5DD)),
                                            ),
                                          ),
                                          readOnly: true,
                                          // initialValue: controller.filters.value[2].filters.length == 2
                                          //   ? "${controller.filters.value[2].filters.first} - ${controller.filters.value[2].filters.last}"
                                          //   : null,
                                        ),
                                      ),
                                    ),
                                  if(controller.filters[index].filterTitle != 'Created on')
                                    GestureDetector(
                                      onTap: () {
                                        if(controller.filters[index].isExpanded) {
                                          controller.updateExpansion(index);
                                        }
                                      },
                                      child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: controller.filters[index].filters.length,
                                      itemBuilder: (context, i) {
                                        if (i <= 3 || controller.filters[index].isExpanded) {
                                          return GestureDetector(
                                            onTap: () {
                                              controller.filters[index].filters[i].isSelected = !controller.filters[index].filters[i].isSelected;
                                              controller.filters.refresh();
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 10.h,
                                                horizontal: 10.h,
                                              ),
                                              child: Row(
                                                children: [
                                                  CustomCheckbox(
                                                    size: 18.h,
                                                    iconSize: 12.h,
                                                    borderWidth: 0.5.h,
                                                    borderRadius:
                                                    BorderRadius.circular(5).r,
                                                    checkIcon: Icon(
                                                      Icons.done_rounded,
                                                      color: ColorUtils.lavenderIndigo,
                                                    ),
                                                    // selectedIconColor:
                                                    // ColorUtils.lavenderIndigo,
                                                    selectedIconColor: ColorUtils.lavenderIndigo,
                                                    borderColor: controller.filters[index].filters[i].isSelected
                                                        ? ColorUtils.secondaryBlue
                                                        : ColorUtils.silverGrey,
                                                    selectedColor: ColorUtils.paleLilac,
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
                                                      color: widget.isDarkMode ? ColorUtils.textWhite : ColorUtils.jetBlack,
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
                                                    "${controller.filters[index].filters.length - 4} more",
                                                    style: GoogleFonts.inter(
                                                      fontSize: 12.h,
                                                      fontWeight: FontWeight.w600,
                                                      color: widget.isDarkMode ? ColorUtils.textWhite : ColorUtils.steelBlue,
                                                    ),
                                                  ),
                                                  SizedBox(width: 5.h),
                                                  SvgPicture.asset(
                                                    "assets/images/manager_view/filter_arrow_down.svg",
                                                    height: 16.h,
                                                    colorFilter: widget.isDarkMode ? ColorFilter.mode(ColorUtils.textWhite, BlendMode.srcIn) : null,
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
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
            ),
          ),
          bottomNavigationBar: Container(
            height: 70.h,
            padding: EdgeInsets.symmetric(horizontal: 15.h),
            decoration: BoxDecoration(
              color: widget.isDarkMode ? Color(0xFF181717) : ColorUtils.textWhite,
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
                  child: InkWell(
                    borderRadius: BorderRadius.circular(37).r,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 50.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(37).r,
                        color: widget.isDarkMode ? ColorUtils.jetGrey : ColorUtils.textWhite,
                        border: Border.all(
                          color: widget.isDarkMode ? ColorUtils.jetGrey : ColorUtils.ashGrey,
                          width: 1.h,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.dmSans(
                            fontWeight: FontWeight.w500,
                            fontSize: 15.h,
                            color: widget.isDarkMode ? ColorUtils.textWhite : ColorUtils.workEntryHead,
                          ),
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
                      Navigator.of(context).pop(true);
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
      ),
    );
  }
}
