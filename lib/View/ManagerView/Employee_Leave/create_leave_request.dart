
import 'dart:async';
import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loyaltri_minimal/View/CWidgets/cwidgets.dart';
import 'package:loyaltri_minimal/View/ManagerView/Employee_Leave/employee_leave_controller/employee_leave_controller.dart';
import 'package:loyaltri_minimal/View/ManagerView/Employee_Leave/leave_widgets_manager/employee_leave_bottomSheet.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Employee/employee_page_controller/employee_page_controller.dart';
import 'package:loyaltri_minimal/controller/leaveTypeController.dart';
import 'package:loyaltri_minimal/models/manager/all_employee_list.dart';
import '../../../controller/applyForLeave.dart';
import '../../../controller/userAuthentication.dart';
import '../../../controller/userProfileController.dart';
import '../../../models/leave_type_api_model.dart';
import '../../../services/ui_model_services/leave_dates_model.dart';
import '../../../utils/color_utils.dart';
import '../../CWidgets/error_dialog.dart';
import '../../CWidgets/loyaltri_blue_text_button.dart';
import '../../Leave_Page/Leave_Request.dart';
import '../../Leave_Page/leave_widgets/camera_view_leave.dart';
import '../../Leave_Page/leave_widgets/leave_type_card.dart';
import '../../Leave_Page/leave_widgets/success_dialogue.dart';
import 'leave_widgets_manager/choose_leaveDates.dart';

class CreateEmployeeLeave extends StatefulWidget {
  const CreateEmployeeLeave({super.key});

  @override
  State<CreateEmployeeLeave> createState() => _CreateEmployeeLeaveState();
}

class _CreateEmployeeLeaveState extends State<CreateEmployeeLeave> {
  LeaveApplyController leaveApplyController = Get.find<LeaveApplyController>();
  // LeaveTypeController _leaveTypeController = Get.find<LeaveTypeController>();
  UserAuthController userAuthController = Get.find<UserAuthController>();
  // AppliedLeaveList appliedLeaveList = Get.find<AppliedLeaveList>();
  TextEditingController _reasonController = TextEditingController();
  ValueNotifier<bool> leaveTypeSelected = ValueNotifier(false);
  ValueNotifier<bool> selectDatesSelected = ValueNotifier(false);
  ValueNotifier<bool> leaveReasonSelected = ValueNotifier(false);
  ValueNotifier<bool> employeeValidator = ValueNotifier(false);
  ValueNotifier<bool> leaveTypeValidator = ValueNotifier(false);
  ValueNotifier<bool> leaveDateValidator = ValueNotifier(false);
  ValueNotifier<bool> leaveReasonValidator = ValueNotifier(false);
  // ValueNotifier<LeaveType?> currentItem = ValueNotifier(null);
  ValueNotifier<LeaveDates?> leaveRange = ValueNotifier(null);
  ApplyLeaveModel? leaveData;
  FocusNode _reasonFocus = FocusNode();
  List<String> selectedImages = [];
  TextEditingController searchTextController = TextEditingController();
  final managerController = Get.find<ManagerEmployeeController>();
  final leaveController = Get.find<EmployeeLeaveController>();

  String? getFullName(CompanyEmployeeData? e) {
    if (e == null) return null;
    return [e.firstName, e.middleName, e.lastName]
        .where((name) => name != null && name.trim().isNotEmpty)
        .join(' ');
  }

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  Future<void> _initialize() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      context.loaderOverlay.show();
      await managerController.fetchAllEmployee(isAll: true);
      context.loaderOverlay.hide();
    });
  }

  @override
  void dispose() {
    leaveController.currentItem.value = null;
    leaveController.selectedEmployeeId.value = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      left: false,
      right: false,
      child: Scaffold(
        backgroundColor: ColorUtils.textWhite,
        extendBody: true,
        body: GestureDetector(
          onTap: () {
            // if (_reasonFocus.hasFocus) {
            //   _reasonFocus.unfocus();
            // }
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 8, left: 8, right: 8).w,
            child: SafeArea(
              top: true,
              bottom: false,
              left: false,
              right: false,
              child: Container(
                width: ScreenUtil().screenWidth,
                height: ScreenUtil().screenHeight,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0).h,
                      child: EmployeeLeaveTitle(title: "Create Leave Request", image: "assets/images/manager_view/employee_leave_calendar.png"),
                    ),
                    SizedBox(height: 8.h),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          if(leaveController.selectedEmployeeId.value.trim().isNotEmpty) {
                            final employeeList = managerController.allEmployeesCopy;
                            final selectedEmployee = employeeList
                                .firstWhereOrNull((e) => e.employeeId == leaveController.selectedEmployeeId.value);

                            if (selectedEmployee != null) {
                              if (employeeValidator.value) {
                                validateFields();
                              }
                              await Get.find<LeaveTypeController>().fetchLeaveType(
                                empId: selectedEmployee.employeeId ?? '',
                                compId: selectedEmployee.companyId ?? '',
                              );
                            }
                          }
                        },
                        child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0).h,
                                child: Obx(() {
                                  final employeeList = managerController.allEmployeesCopy;

                                  final selectedId = employeeList
                                      .any((e) => e.employeeId == leaveController.selectedEmployeeId.value)
                                      ? leaveController.selectedEmployeeId.value
                                      : null;

                                  return ValueListenableBuilder(
                                    valueListenable: employeeValidator,
                                    builder: (context, validator, child) {
                                      return Container(
                                        height: 44.h,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50.r),
                                          color: ColorUtils.paleLavenderMist,
                                          border: validator
                                              ? Border.all(color: Colors.red, width: 0.5.h)
                                              : null,
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton2<String>(
                                            isExpanded: true,
                                            value: selectedId,
                                            hint: Text(
                                              'Search employee*',
                                              style: GoogleFonts.poppins(
                                                color: validator
                                                    ? Colors.red
                                                    : ColorUtils.workEntryHead.withValues(alpha: 0.5),
                                                fontSize: 12.h,
                                              ),
                                            ),

                                            items: employeeList
                                                .where((e) => e.employeeId != null)
                                                .map((employee) {
                                              return DropdownMenuItem<String>(
                                                value: employee.employeeId,
                                                child: Text(
                                                  getFullName(employee) ?? '--',
                                                  overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 13.h,
                                                    color: ColorUtils.workEntryHead,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              );
                                            }).toList(),

                                            onChanged: (value) async {
                                              if (value == null) return;

                                              leaveController.selectedEmployeeId.value = value;

                                              final selectedEmployee = employeeList
                                                  .firstWhereOrNull((e) => e.employeeId == value);

                                              if (selectedEmployee != null) {
                                                if (employeeValidator.value) {
                                                  validateFields();
                                                }
                                                await Get.find<LeaveTypeController>().fetchLeaveType(
                                                  empId: selectedEmployee.employeeId ?? '',
                                                  compId: selectedEmployee.companyId ?? '',
                                                );
                                              }
                                            },

                                            iconStyleData: IconStyleData(
                                              icon: Icon(
                                                Icons.keyboard_arrow_down,
                                                color: validator
                                                    ? Colors.red.withValues(alpha: 0.5)
                                                    : const Color(0xFF9A9A9A),
                                              ),
                                            ),

                                            buttonStyleData: ButtonStyleData(
                                              padding: EdgeInsets.only(right: 16.h),
                                              overlayColor:
                                              WidgetStateProperty.all(Colors.transparent),
                                            ),

                                            dropdownStyleData: DropdownStyleData(
                                              maxHeight: ScreenUtil().screenHeight * 0.6,
                                            ),

                                            menuItemStyleData:
                                            MenuItemStyleData(height: 40.h),

                                            dropdownSearchData: DropdownSearchData(
                                              searchController: searchTextController,
                                              searchInnerWidgetHeight: 50.h,
                                              searchInnerWidget: Padding(
                                                padding: EdgeInsets.all(8.h),
                                                child: TextField(
                                                  controller: searchTextController,
                                                  decoration: InputDecoration(
                                                    hintText: 'Search employee',
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(8.r),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              searchMatchFn: (item, searchValue) {
                                                final text =
                                                    (item.child as Text).data ?? '';
                                                return text
                                                    .toLowerCase()
                                                    .contains(searchValue.toLowerCase());
                                              },
                                            ),

                                            onMenuStateChange: (isOpen) {
                                              if (!isOpen) {
                                                searchTextController.clear();
                                              }
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.all(8.0).h,
                              //   child: Container(
                              //     decoration: BoxDecoration(
                              //       color: ColorUtils.paleLavenderMist,
                              //       borderRadius: BorderRadius.circular(50).r,
                              //     ),
                              //     height: 44.h,
                              //     child: TextField(
                              //       style: GoogleFonts.poppins(
                              //         color: ColorUtils.workEntryHead,
                              //         fontSize: 13.h,
                              //         fontWeight: FontWeight.w400,
                              //       ),
                              //       textAlignVertical: TextAlignVertical.center,
                              //       decoration: InputDecoration(
                              //         isDense: true,
                              //         enabledBorder: InputBorder.none,
                              //         focusedBorder: InputBorder.none,
                              //         hintText: "Search employee",
                              //         hintStyle: GoogleFonts.poppins(
                              //           color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                              //           fontSize: 12.h,
                              //           fontWeight: FontWeight.w400,
                              //         ),
                              //         // contentPadding: EdgeInsets.symmetric(
                              //         //   vertical: 12.h,
                              //         //   horizontal: 10.h,
                              //         // ),
                              //         prefixIconConstraints: BoxConstraints(
                              //           minWidth: 38.h,
                              //         ),
                              //         prefixIcon: Padding(
                              //           padding: EdgeInsets.only(
                              //             top: 12.h,
                              //             left: 12.h,
                              //             bottom: 12.h,
                              //           ),
                              //           child: Row(
                              //             mainAxisSize: MainAxisSize.min,
                              //             children: [
                              //               SvgPicture.asset(
                              //                 "assets/images/manager_view/search_icon_req.svg",
                              //                 fit: BoxFit.contain,
                              //               ),
                              //             ],
                              //           ),
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              Padding(
                                padding: const EdgeInsets.all(8.0).h,
                                child: ValueListenableBuilder(
                                  valueListenable: leaveTypeSelected,
                                  builder: (BuildContext context, value, Widget? child) {
                                    return ValueListenableBuilder(
                                        valueListenable: leaveTypeValidator,
                                        builder: (BuildContext context, validator, Widget? child) {
                                        return GestureDetector(
                                          onTap: () {
                                            leaveTypeSelected.value = true;
                                            selectDatesSelected.value = false;
                                            leaveReasonSelected.value = false;
                                            leaveTypeBottomSheet(
                                              context: context,
                                              isHomePage: true,
                                              type: (LeaveType leaveType) {
                                                Get.find<EmployeeLeaveController>().currentItem.value = leaveType;

                                                if(leaveTypeValidator.value) {
                                                  validateFields();
                                                }
                                              },
                                            );
                                          },
                                          child: Container(
                                            width: ScreenUtil().screenWidth,
                                            height: 70.h,
                                            decoration: BoxDecoration(
                                              color: ColorUtils.paleLavenderMist,
                                              borderRadius: BorderRadius.circular(12).r,
                                              border: validator ? Border.all(
                                                width: 0.5.h,
                                                color: Colors.red,
                                              ) : value ? Border.all(
                                                width: 0.5.h,
                                                color: ColorUtils.secondaryBlue,
                                              ) : null,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10.0).h,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "Leave type*",
                                                        style: GoogleFonts.poppins(
                                                          fontWeight: FontWeight.w400,
                                                          fontSize: 14.h,
                                                          color: validator ? Colors.red : ColorUtils.obsidianGrey,
                                                        ),
                                                      ),
                                                      SizedBox(height: 4.h),
                                                      GetX<EmployeeLeaveController>(
                                                        builder: (EmployeeLeaveController controller) {
                                                          LeaveType? leaveType = controller.currentItem.value;
                                                          if(leaveType != null) {
                                                            return Text(
                                                              leaveType.leaveType ?? '--',
                                                              style: GoogleFonts.poppins(
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: 15.h,
                                                                color: ColorUtils.workEntryHead,
                                                              ),
                                                            );
                                                          } else {
                                                            return Text(
                                                              "Select leave type",
                                                              style: GoogleFonts.poppins(
                                                                fontWeight: FontWeight.w400,
                                                                fontSize: 15.h,
                                                                color: validator ? Colors.red.withValues(alpha: 0.5) : ColorUtils.eerieBlack.withValues(alpha: 0.2),
                                                              ),
                                                            );
                                                          }
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                  Icon(
                                                    Icons.keyboard_arrow_down,
                                                    color: validator ? Colors.red.withValues(alpha: 0.5) : Color(0xFF9A9A9A),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0).h,
                                child: ValueListenableBuilder(
                                  valueListenable: selectDatesSelected,
                                  builder: (BuildContext context, value, Widget? child) {
                                    return ValueListenableBuilder(
                                        valueListenable: leaveDateValidator,
                                        builder: (BuildContext context, validator, Widget? child) {
                                        return GestureDetector(
                                          onTap: () {
                                            leaveTypeSelected.value = false;
                                            selectDatesSelected.value = true;
                                            leaveReasonSelected.value = false;
                                            Navigator.of(context).push(
                                              newSlideNavigation(ChooseDatesManager(
                                                leaveType: Get.find<EmployeeLeaveController>().currentItem.value,
                                              )),
                                            ).then((value) {
                                              if (value != null && value is LeaveDates) {
                                                leaveRange.value = value;

                                                if(leaveDateValidator.value) {
                                                  validateFields();
                                                }
                                              }
                                            });
                                          },
                                          child: GetX<EmployeeLeaveController>(
                                            builder: (EmployeeLeaveController controller) {
                                              return Container(
                                                width: ScreenUtil().screenWidth,
                                                height: 70.h,
                                                decoration: BoxDecoration(
                                                  color: ColorUtils.paleLavenderMist,
                                                  borderRadius: BorderRadius.circular(12).r,
                                                  border: validator ? Border.all(
                                                    width: 0.5.h,
                                                    color: Colors.red.withValues(alpha: 0.5),
                                                  ) : value ? Border.all(
                                                    width: 0.5.h,
                                                    color: ColorUtils.secondaryBlue,
                                                  ) : null,
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(10.0).h,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            "Select ${controller.currentItem.value?.isHourBased == '1' ? 'Date & Hour' : 'Dates'}*",
                                                            style: GoogleFonts.poppins(
                                                              fontWeight: FontWeight.w400,
                                                              fontSize: 14.h,
                                                              color: validator ? Colors.red : ColorUtils.obsidianGrey,
                                                            ),
                                                          ),
                                                          SizedBox(height: 4.h),
                                                          ValueListenableBuilder(
                                                            valueListenable: leaveRange,
                                                            builder: (BuildContext context, value, Widget? child) {
                                                              if (value != null) {
                                                                if(controller.currentItem.value?.isHourBased == '1') {
                                                                  return Text(
                                                                    "${DateFormat('dd/MM/yyyy').format(value.startDate!)} - ${value.hour ?? ''} hour",
                                                                    style: GoogleFonts.poppins(
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: 15.h,
                                                                      color: ColorUtils.workEntryHead,
                                                                    ),
                                                                  );
                                                                } else if(value.endDate != value.startDate) {
                                                                  return Text(
                                                                    "${DateFormat('dd/MM/yyyy').format(value.startDate!)} - ${DateFormat('dd/MM/yyyy').format(value.endDate!)}",
                                                                    style: GoogleFonts.poppins(
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: 15.h,
                                                                      color: ColorUtils.workEntryHead,
                                                                    ),
                                                                  );
                                                                } else {
                                                                  return Text(
                                                                    "${DateFormat('dd/MM/yyyy').format(value.startDate!)} ${value.leaveSection != "" ? "(${convertToTitleCase(value.leaveSection!)})" : ""}",
                                                                    style: GoogleFonts.poppins(
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: 15.h,
                                                                      color: ColorUtils.workEntryHead,
                                                                    ),
                                                                  );
                                                                }
                                                              } else {
                                                                return Text(
                                                                  controller.currentItem.value?.isHourBased == '1' ? "Select" : "dd/mm/yyyy - dd/mm/yyyy",
                                                                  style: GoogleFonts.poppins(
                                                                    fontWeight: FontWeight.w400,
                                                                    fontSize: 15.h,
                                                                    color: validator ? Colors.red.withValues(alpha: 0.5) : ColorUtils.eerieBlack.withValues(alpha: 0.2),
                                                                  ),
                                                                );
                                                              }
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                      Icon(
                                                        controller.currentItem.value?.isHourBased  == '1' ? Icons.access_time : Icons.calendar_today_outlined,
                                                        color: validator ? Colors.red.withValues(alpha: 0.5) : Color(0xFF9A9A9A),
                                                        size: 24.h,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }
                                          ),
                                        );
                                      }
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0).h,
                                child: ValueListenableBuilder(
                                  valueListenable: leaveReasonSelected,
                                  builder: (BuildContext context, value, Widget? child) {
                                    return ValueListenableBuilder(
                                        valueListenable: leaveReasonValidator,
                                        builder: (BuildContext context, validator, Widget? child) {
                                        return GestureDetector(
                                          onTap: () {
                                            leaveTypeSelected.value = false;
                                            selectDatesSelected.value = false;
                                            leaveReasonSelected.value = true;
                                          },
                                          child: Container(
                                            width: ScreenUtil().screenWidth,
                                            height: 70.h,
                                            decoration: BoxDecoration(
                                              color: ColorUtils.paleLavenderMist,
                                              borderRadius: BorderRadius.circular(12).r,
                                              border: validator ? Border.all(
                                                width: 0.5.h,
                                                color: Colors.red.withValues(alpha: 0.5),
                                              ) : value ? Border.all(
                                                width: 0.5.h,
                                                color: ColorUtils.secondaryBlue,
                                              ) : null,
                                            ),
                                            child: Center(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 10, top: 4).h,
                                                    child: Text(
                                                      "Leave Reason*",
                                                      style: GoogleFonts.inter(
                                                        fontWeight: FontWeight.w400,
                                                        fontSize: 14.h,
                                                        color: validator ? Colors.red : const Color(0xFFAAAAAA),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 10).h,
                                                    child: TextField(
                                                      controller: _reasonController,
                                                      focusNode: _reasonFocus,
                                                      cursorColor: Colors.grey,
                                                      onTap: () {
                                                        leaveTypeSelected.value = false;
                                                        selectDatesSelected.value = false;
                                                        leaveReasonSelected.value = true;
                                                      },
                                                      onChanged: (value) {
                                                        if(leaveReasonValidator.value) {
                                                          validateFields();
                                                        }
                                                      },
                                                      textAlignVertical: TextAlignVertical.center,
                                                      decoration: InputDecoration(
                                                        hintText: "Type reason...",
                                                        isDense: true,
                                                        hintStyle: GoogleFonts.poppins(
                                                          fontWeight: FontWeight.w400,
                                                          fontSize: 15.h,
                                                          color: validator ? Colors.red.withValues(alpha: 0.5) : ColorUtils.eerieBlack.withValues(alpha: 0.2),
                                                        ),
                                                        border: InputBorder.none,
                                                        contentPadding: EdgeInsets.all(0),
                                                        // contentPadding: const EdgeInsets.only(
                                                        //     left: 10, bottom: 0, top: 0)
                                                        //     .h,
                                                      ),
                                                      style: GoogleFonts.poppins(
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 15.h,
                                                        color: ColorUtils.workEntryHead,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(18.0).h,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Text(
                                    //   "Attachments",
                                    //   style: GoogleFonts.poppins(
                                    //     fontWeight: FontWeight.w400,
                                    //     fontSize: 14.sp,
                                    //     color: const Color(0xFFAAAAAA),
                                    //   ),
                                    // ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Attachments",
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 13.h,
                                            color: const Color(0xFFAAAAAA),
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          "Max 1 File (Optional)",
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15.h,
                                            color: const Color(0xFF5D626D),
                                          ),
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if(_reasonFocus.hasFocus) {
                                          _reasonFocus.unfocus();
                                        }
                                        if (selectedImages.isNotEmpty) {
                                          ErrorDialog().showWarnManager(
                                            context: context,
                                            title: "Error",
                                            subTitle: "Maximum 1 file allowed",
                                          );
                                          return;
                                        }
                                        attachBottomSheetShow(context);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8).h,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFEEEEEE),
                                          borderRadius: BorderRadius.circular(23).r,
                                        ),
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              "assets/images/attach_icon.svg",
                                              height: 17.h,
                                              colorFilter: ColorFilter.mode(ColorUtils.workEntryHead, BlendMode.srcIn),
                                            ),
                                            SizedBox(width: 12.h),
                                            Text(
                                              "Add",
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 11.h,
                                                color: ColorUtils.workEntryHead,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              for(int index = 0; index < selectedImages.length; index++)
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9).h,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8).h,
                                    decoration: BoxDecoration(
                                      color: ColorUtils.paleLavenderMist,
                                      borderRadius: BorderRadius.circular(12).r,
                                    ),
                                    child: Row(
                                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                selectedImages.removeAt(index);
                                                setState(() {});
                                              },
                                              child: Icon(
                                                Icons.close,
                                                color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                                              ),
                                            ),
                                            SizedBox(width: 10.h),
                                            if(selectedImages[index].split('.').isNotEmpty && selectedImages[index].split('.').last == 'pdf')
                                              Image.asset(
                                                "assets/images/manager_view/pdf_icon.png",
                                                height: 35.h,
                                              )
                                            else
                                              Image.file(
                                                File(selectedImages[index]),
                                                height: 60.h,
                                                width: 80.h,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) {
                                                  return Transform.rotate(
                                                    angle: 180,
                                                    child: Icon(
                                                      Icons.attach_file,
                                                      size: 28.h,
                                                      color: Colors.blueGrey,
                                                    ),
                                                  );
                                                },
                                              ),
                                          ],
                                        ),
                                        SizedBox(width: 10.h),
                                        SizedBox(
                                          width: 150.h,
                                          child: Text(
                                            selectedImages[index].split("/").last,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12.h,
                                              color: ColorUtils.workEntryHead,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              // Padding(
                              //   padding: const EdgeInsets.symmetric(vertical: 9).h,
                              //   child: SizedBox(
                              //     height: 400.h,
                              //     child: ListView.builder(
                              //         itemCount: selectedImages.length,
                              //         padding: const EdgeInsets.only(bottom: 200).h,
                              //         itemBuilder: (context, index) {
                              //           return Padding(
                              //             padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9).h,
                              //             child: Container(
                              //               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8).h,
                              //               decoration: BoxDecoration(
                              //                 color: ColorUtils.paleLavenderMist,
                              //                 borderRadius: BorderRadius.circular(12).r,
                              //               ),
                              //               child: Row(
                              //                 // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //                 children: [
                              //                   Row(
                              //                     mainAxisSize: MainAxisSize.min,
                              //                     children: [
                              //                       InkWell(
                              //                         onTap: () {
                              //                           selectedImages.removeAt(index);
                              //                           setState(() {});
                              //                         },
                              //                         child: Icon(
                              //                           Icons.close,
                              //                           color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                              //                         ),
                              //                       ),
                              //                       SizedBox(width: 10.h),
                              //                       Image.file(
                              //                         File(selectedImages[index]),
                              //                         height: 60.h,
                              //                         width: 80.h,
                              //                         fit: BoxFit.cover,
                              //                       ),
                              //                     ],
                              //                   ),
                              //                   SizedBox(width: 10.h),
                              //                   SizedBox(
                              //                     width: 150.h,
                              //                     child: Text(
                              //                       selectedImages[index].split("/").last,
                              //                       overflow: TextOverflow.ellipsis,
                              //                       style: GoogleFonts.poppins(
                              //                         fontWeight: FontWeight.w500,
                              //                         fontSize: 12.h,
                              //                         color: ColorUtils.workEntryHead,
                              //                       ),
                              //                     ),
                              //                   ),
                              //                 ],
                              //               ),
                              //             ),
                              //           );
                              //         }
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: GetX<UserAuthController>(
          builder: (UserAuthController controller) {
            if (controller.isLoading.value) {
              context.loaderOverlay.show();
            } else {
              context.loaderOverlay.hide();
            }
            return Container(
              width: ScreenUtil().screenWidth,
              height: 86.h,
              decoration: BoxDecoration(
                color: ColorUtils.textWhite,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFB9B8FF).withValues(alpha: 0.18),
                    offset: Offset(0, -16),
                    blurRadius: 31,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20).w,
                    child: GetX<LeaveApplyController>(
                      builder: (LeaveApplyController controller) {
                        if(controller.isLoading.value) {
                          return Container(
                            width: ScreenUtil().screenWidth,
                            height: 52.h,
                            decoration: BoxDecoration(
                              color: ColorUtils.secondaryBlue,
                              borderRadius: BorderRadius.circular(37).w,
                            ),
                            child: Center(
                              child: SizedBox(
                                width: 10.h,
                                height: 10.h,
                                child: const CircularProgressIndicator(
                                  color: ColorUtils.textWhite,
                                ),
                              ),
                            ),
                          );
                        } else {
                          return GestureDetector(
                            onTap: () async {
                              validateFields();
                              if(Get.find<EmployeeLeaveController>().selectedEmployeeId.value != null &&
                                  Get.find<EmployeeLeaveController>().currentItem.value != null &&
                                  leaveRange.value != null &&
                                  _reasonController.text.trim().isNotEmpty) {
                                if(_reasonFocus.hasFocus) {
                                  _reasonFocus.unfocus();
                                }
                                DateTime fromDate = leaveRange.value!.startDate!;
                                DateTime toDate = leaveRange.value!.endDate!;
                                Duration difference = toDate.difference(fromDate);
                                int totalLeaveCount = difference.inDays + 1;

                                ApplyLeaveModel leaveData = ApplyLeaveModel(
                                  employeeId: Get.find<EmployeeLeaveController>().selectedEmployeeId.value,
                                  createdBy: Get.find<UserProfileController>().userData.value.result.employeeId ?? '',
                                  companyId: Get.find<UserProfileController>().userData.value.result.companyId.toString(),
                                  leaveDateFrom: DateFormat('yyyy-MM-dd').format(leaveRange.value!.startDate!),
                                  leaveDateTo: DateFormat('yyyy-MM-dd').format(leaveRange.value!.endDate!),
                                  totalLeaveDays: totalLeaveCount.toString(),
                                  leaveType: Get.find<EmployeeLeaveController>().currentItem.value?.leaveTypeId?.toString() ?? '',
                                  leaveReason: _reasonController.text,
                                  isActive: "1",
                                  files: selectedImages,
                                  isHalfDay: leaveRange.value!.isHalfDay,
                                  maximumLeaveLimit: Get.find<EmployeeLeaveController>().currentItem.value?.maximumLeaveLimit?.toString() ?? '',
                                  leaveApplied: Get.find<EmployeeLeaveController>().currentItem.value?.leaveApplied?.toString() ?? '',
                                  leaveSection: leaveRange.value?.leaveSection,
                                    isHourBased: Get.find<EmployeeLeaveController>().currentItem.value?.isHourBased,
                                    hourLeaveDate: Get.find<EmployeeLeaveController>().currentItem.value?.isHourBased == '1' ? DateFormat(
                                      'yyyy-MM-dd',
                                    ).format(leaveRange.value!.startDate!) : null,
                                    leaveHours: leaveRange.value?.hour
                                );
                                await leaveApplyController.requestLeave(leaveData: leaveData);
                                if(leaveApplyController.dataLoaded.value) {
                                  if(leaveApplyController.success.value) {
                                    EmployeeLeaveController employeeLeaveController = Get.find<EmployeeLeaveController>();
                                    employeeLeaveController.resetValues();
                                    Get.find<LeaveTypeController>().leaveTypeList.value = [];
                                    await employeeLeaveController.fetchEmployeeLeaveList();
                                    // await appliedLeaveList.fetchLeaveList(empId: userAuthController.userData.value.userData?.employeeId ?? '--').then((value) {
                                    ShowSuccessDialog().showWarn(context: context);
                                    HapticFeedback.lightImpact();
                                    Get.find<EmployeeLeaveController>().currentItem.value = null;
                                    leaveRange.value = null;
                                    _reasonController.clear();
                                    setState(() {
                                      selectedImages = [];
                                    });
                                    await Future.delayed(const Duration(seconds: 2));
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    // });
                                  } else {
                                    ErrorDialog().showWarnManager(context: context, title: "Failed!", subTitle: leaveApplyController.msg.value);
                                  }
                                } else {
                                  ErrorDialog().showWarnManager(context: context, title: "Submission Failed!", subTitle: "Something went wrong");
                                }
                              }
                            },
                            child: const LoyaltriBlueIconTextButton(
                              text: 'Submit Request',
                            ),
                          );
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
    );
  }

  void validateFields() {
    if(leaveController.selectedEmployeeId.value.trim().isEmpty) {
      employeeValidator.value = true;
    } else {
      employeeValidator.value = false;
    }

    if(leaveController.currentItem.value == null) {
      leaveTypeValidator.value = true;
    } else {
      leaveTypeValidator.value = false;
    }

    if(leaveRange.value == null) {
      leaveDateValidator.value = true;
    } else {
      leaveDateValidator.value = false;
    }

    if(_reasonController.text.trim().isEmpty) {
      leaveReasonValidator.value = true;
    } else {
      leaveReasonValidator.value = false;
    }
  }

  String convertToTitleCase(String input) {
    return input.replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (match) {
      return '${match.group(1)} ${match.group(2)}';
    }).replaceFirstMapped(RegExp(r'^[a-z]'), (match) {
      return match.group(0)!.toUpperCase();
    });
  }

  attachBottomSheetShow(mainContext) {
    showModalBottomSheet(
      context: mainContext,
      backgroundColor: Colors.white,
      barrierColor: ColorUtils.workEntryHead.withValues(alpha: 0.3),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0).h,
            child: Container(
              width: ScreenUtil().screenWidth,
              height: 273.h,
              padding: EdgeInsets.all(1).h,
              decoration: BoxDecoration(
                color: ColorUtils.textWhite,
                borderRadius: BorderRadius.circular(21).r,
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15.0, right: 15.0).w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select Source",
                      style: GoogleFonts.poppins(
                        color: ColorUtils.workEntryHead.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w600,
                        fontSize: 18.sp,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                          newSlideNavigation(const CameraViewLeave()),
                        ).then((value) async {
                          if(value != null) {
                            final file = File(value);
                            final fileSizeInBytes = await file.length();
                            final fileSizeInMB = fileSizeInBytes / (1024 * 1024);

                            if (fileSizeInMB > 5) {
                              ErrorDialog().showWarnManager(
                                context: mainContext,
                                title: "Error",
                                subTitle: "File size should be less than 5 MB",
                              );
                              return;
                            }

                            selectedImages.add(value);
                            setState(() {});
                          }
                        },
                        );
                      },
                      child: AttachMenuCard(
                        imageIcon: "assets/images/camera.webp",
                        title: "Camera",
                        subTitle: "Lorem ipsum dolor sit amet, consectetur elit.",
                        containerColor: ColorUtils.softPearl,
                        textColor: ColorUtils.workEntryHead.withValues(alpha: 0.7),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () async {
                        Navigator.of(context).pop();
                        try {
                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                            allowMultiple: false,
                            type: FileType.custom,
                            allowedExtensions: ['png', 'jpg', 'jpeg', 'gif', 'bmp', 'tiff', 'webp'],
                          );

                          if(result?.files.isNotEmpty ?? false) {
                            final file = File(result!.files.single.path!);
                            final fileSizeInBytes = await file.length();
                            final fileSizeInMB = fileSizeInBytes / (1024 * 1024);

                            if (fileSizeInMB > 5) {
                              ErrorDialog().showWarnManager(
                                context: mainContext,
                                title: "Error",
                                subTitle: "File size should be less than 5 MB",
                              );
                              return;
                            }

                            if(result.files.isEmpty) return;
                            final filePath = result.files.single.path;

                            if(filePath == null) {
                              AttendanceCommonWidgets().showSnackBar(
                                context: mainContext,
                                backgroundColor: Colors.red,
                                message: "File path not found",
                              );
                              return;
                            }

                            selectedImages.add(file.path);
                            setState(() {});
                          } else {
                            return;
                          }
                        } catch(e) {
                          AttendanceCommonWidgets().printF("------error-------${e.toString()}");
                        }
                      },
                      child: AttachMenuCard(
                        imageIcon: "assets/images/image-3d.webp",
                        title: "Photos",
                        subTitle: "Lorem ipsum dolor sit amet, consectetur elit.",
                        containerColor: ColorUtils.softPearl,
                        textColor: ColorUtils.workEntryHead.withValues(alpha: 0.7),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () async {
                        Navigator.of(context).pop();
                        FilePickerResult? result = await FilePicker.platform
                            .pickFiles(
                          allowMultiple: false,
                          type: FileType.custom,
                          allowedExtensions: [
                            'png',
                            'jpg',
                            'jpeg',
                            'gif',
                            'bmp',
                            'tiff',
                            'webp',
                            'pdf',
                          ],
                        );

                        if (result != null) {
                          List<File> files = result.paths.map((path) => File(path!)).toList();
                          if(files.isEmpty) return;

                          final file = File(result.files.single.path!);
                          final fileSizeInBytes = await file.length();
                          final fileSizeInMB = fileSizeInBytes / (1024 * 1024);

                          if (fileSizeInMB > 5) {
                            ErrorDialog().showWarnManager(
                              context: mainContext,
                              title: "Error",
                              subTitle: "File size should be less than 5 MB",
                            );
                            return;
                          }

                          if(result.files.isEmpty) return;
                          final filePath = result.files.single.path;

                          if(filePath == null) {
                            AttendanceCommonWidgets().showSnackBar(
                              context: mainContext,
                              backgroundColor: Colors.red,
                              message: "File path not found",
                            );
                            return;
                          }

                          selectedImages.add(file.path);
                          setState(() {});
                        } else {
                          // User canceled the picker
                        }
                      },
                      child: AttachMenuCard(
                        imageIcon: "assets/images/file-3d.webp",
                        title: "Browse",
                        subTitle: "Lorem ipsum dolor sit amet, consectetur elit.",
                        containerColor: ColorUtils.softPearl,
                        textColor: ColorUtils.workEntryHead.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // attachBottomSheetShow(mainContext) {
  //   showModalBottomSheet(
  //     context: mainContext,
  //     backgroundColor: Colors.black,
  //     barrierColor: ColorUtils.workEntryHead.withOpacity(0.81),
  //     builder: (BuildContext context) {
  //       return Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: Container(
  //           width: ScreenUtil().screenWidth,
  //           height: 273.w,
  //           decoration: BoxDecoration(
  //             color: ColorUtils.backgroundBlack,
  //             borderRadius: BorderRadius.circular(20).w,
  //             border: Border.all(
  //               width: 1.w,
  //               color: const Color(0xFF404040),
  //             ),
  //           ),
  //           child: Padding(
  //             padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15.0, right: 15.0).w,
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   "Select Source",
  //                   style: GoogleFonts.poppins(
  //                     color: ColorUtils.textWhite,
  //                     fontWeight: FontWeight.w600,
  //                     fontSize: 18.sp,
  //                   ),
  //                 ),
  //                 const Spacer(),
  //                 GestureDetector(
  //                   onTap: () {
  //                     Navigator.of(context).pop();
  //                     Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CameraViewLeave())).then((value) => {
  //
  //                       if(selectedImages.length < 5) {
  //                         selectedImages.add(value),
  //                         setState(() {})
  //                       } else {
  //                         ErrorDialog().showWarn(context: mainContext, title: "Error", subTitle: "Maximum files selected")
  //                       }
  //                     });
  //                   },
  //                   child: const AttachMenuCard(
  //                     imageIcon: "assets/images/camera.webp",
  //                     title: "Camera",
  //                     subTitle: "Lorem ipsum dolor sit amet, consectetur elit.",
  //                   ),
  //                 ),
  //                 const Spacer(),
  //                 GestureDetector(
  //                   onTap: () async {
  //                     Navigator.of(context).pop();
  //                     try {
  //                       await getLostData(mainContext);
  //                     } catch(e) {
  //                       AttendanceCommonWidgets().printF("------error-------${e.toString()}");
  //                     }
  //                   },
  //                   child: const AttachMenuCard(
  //                     imageIcon: "assets/images/image-3d.webp",
  //                     title: "Photos",
  //                     subTitle: "Lorem ipsum dolor sit amet, consectetur elit.",
  //                   ),
  //                 ),
  //                 const Spacer(),
  //                 GestureDetector(
  //                   onTap: () async {
  //                     Navigator.of(context).pop();
  //                     FilePickerResult? result = await FilePicker.platform.pickFiles(
  //                       allowMultiple: true,
  //                     );
  //
  //                     if (result != null) {
  //                       List<File> files = result.paths.map((path) => File(path!)).toList();
  //                       setState(() {
  //                         if(selectedImages.length < 5) {
  //                           if(files.length < (6 - selectedImages.length)) {
  //                             for (var file in files) {
  //                               selectedImages.add(file.path);
  //                             }
  //                           } else {
  //                             ErrorDialog().showWarn(context: mainContext, title: "Error", subTitle: "Maximum 5 files allowed");
  //                           }
  //                         } else {
  //                           ErrorDialog().showWarn(context: mainContext, title: "Error", subTitle: "Maximum files selected");
  //                         }
  //                       });
  //                     } else {
  //                       // User canceled the picker
  //                     }
  //                   },
  //                   child: const AttachMenuCard(
  //                     imageIcon: "assets/images/file-3d.webp",
  //                     title: "Browse",
  //                     subTitle: "Lorem ipsum dolor sit amet, consectetur elit.",
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  Future<void> getLostData(mainContext) async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> image = await picker.pickMultiImage();
    final LostDataResponse response = await picker.retrieveLostData();
    // AttendanceCommonWidgets().printF("------path------${image.path}");
    if(image != null) {
      if(selectedImages.length < 5) {
        if(image.length < (6 - selectedImages.length)) {
          for (var file in image) {
            selectedImages.add(file.path);
          }
          setState(() {});
        } else {
          ErrorDialog().showWarn(context: mainContext, title: "Error", subTitle: "Maximum 5 files allowed");
        }
      } else {
        ErrorDialog().showWarn(context: mainContext, title: "Error", subTitle: "Maximum files selected");
      }
    }
    if (response.isEmpty) {
      return;
    }
    final List<XFile>? files = response.files;

    files?.forEach((element) {
      setState(() {
        if(selectedImages.length < 5) {
          if(files.length < (6 - selectedImages.length)) {
            for (var file in files) {
              selectedImages.add(file.path);
            }
          } else {
            ErrorDialog().showWarn(context: mainContext, title: "Error", subTitle: "Maximum 5 files allowed");
          }
        } else {
          ErrorDialog().showWarn(context: mainContext, title: "Error", subTitle: "Maximum files selected");
        }
      });
      AttendanceCommonWidgets().printF("------path------${element.path}");
    });
    if (files != null) {
      // _handleLostFiles(files);
    } else {
      // _handleError(response.exception);
    }
  }

  leaveTypeBottomSheet({context, isHomePage, Function(LeaveType)? type}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      barrierColor: ColorUtils.workEntryHead.withValues(alpha: 0.3),
      builder: (BuildContext context) {
        List<LeaveType> list = Get.find<LeaveTypeController>().leaveTypeList.value;
        // List<LeaveType> list = [
        //   LeaveType(
        //     leaveType: "Sick Leave",
        //     leaveBalance: "3",
        //   ),
        //   LeaveType(
        //     leaveType: "Vacation Leave",
        //     leaveBalance: "1",
        //   ),
        //   LeaveType(
        //     leaveType: "Casual Leave",
        //     leaveBalance: "12",
        //   ),
        // ];
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0).h,
            child: Container(
              width: ScreenUtil().screenWidth,
              // height: 273.w,
              decoration: BoxDecoration(
                color: ColorUtils.textWhite,
                borderRadius: BorderRadius.circular(20).r,
                // border: Border.all(
                //   width: 1.w,
                //   color: const Color(0xFF404040),
                // ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15.0, right: 15.0).h,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Select a leave type",
                        style: GoogleFonts.poppins(
                          color: ColorUtils.workEntryHead,
                          fontWeight: FontWeight.w500,
                          fontSize: 15.h,
                        ),
                      ),
                      SizedBox(height: 15.h),
                      // const Spacer(),
                      for(int i = 0; i < list.length; i++)
                        GestureDetector(
                          onTap: () {
                            if(list[i].leaveBalance != "0") {
                              type?.call(list[i]);
                              Navigator.of(context).pop();
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10).h,
                            child: LeaveTypeCardManager(
                              leaveBalance: list[i].leaveBalance,
                              imageIcon: list[i].leaveType?.toUpperCase() == "SICK LEAVE"
                                  ? "assets/images/sickleave-3d.webp"
                                  : list[i].leaveType?.toUpperCase() == "VACATION LEAVE" || list[i].leaveType?.toUpperCase() == "VACATION"
                                  ? "assets/images/vacation3d.webp"
                                  : "assets/images/calendar-blue.webp",
                              title: list[i].leaveType ?? '--',
                              subTitle: list[i].basicLeaveType.toString() != "1" ? list[i].leaveBalance != "0" ? "Available ${list[i].leaveBalance} ${list[i].leaveBalance == '1' ? 'leave' : 'leaves'}" : "No leaves available" : "Take ${list[i].leaveType}",
                            ),
                          ),
                        ),
                      if(list.isEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 12.h,
                            horizontal: 14.h,
                          ),
                          child: Column(
                            children: [
                              Image.asset(
                                "assets/images/manager_view/no_leaveType.png",
                                height: 44.h,
                                fit: BoxFit.fitHeight,
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                "No Leave type found",
                                style: GoogleFonts.poppins(
                                  color: ColorUtils.workEntryHead,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11.h,
                                ),
                              ),
                              SizedBox(height: 5.h),
                              Text(
                                "Please contact HR or configure leave types in settings.",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  color: ColorUtils.workEntryHead.withValues(alpha: 0.7),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 11.h,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class LeaveTypeCardManager extends GetView<EmployeeLeaveController> {
  final String imageIcon;
  final String title;
  final String? subTitle;
  final String? leaveBalance;
  const LeaveTypeCardManager(
      {super.key,
        required this.imageIcon,
        required this.title,
        this.leaveBalance,
        this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(1).h,
      decoration: BoxDecoration(
        color: controller.currentItem.value?.leaveType == title ? ColorUtils.secondaryBlue : Colors.transparent,
        borderRadius: BorderRadius.circular(12).r,
      ),
      child: Container(
        width: ScreenUtil().screenWidth,
        decoration: BoxDecoration(
          color: (leaveBalance != null && leaveBalance == "0") ? Color(0xFF3E3C42).withValues(alpha: 0.1) : ColorUtils.paleLavenderMist,
          borderRadius: BorderRadius.circular(11).r,
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              left: 8.0, right: 8.0, top: 10.0, bottom: 10.0)
              .h,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0).h,
                child: Image.asset(
                  imageIcon,
                  width: 34.h,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 13.h,
                        color: ColorUtils.workEntryHead,
                      ),
                    ),
                    if(subTitle != null)
                      Text(
                        subTitle!,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 11.h,
                          color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
