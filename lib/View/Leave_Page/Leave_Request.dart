import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:loyaltri_minimal/View/Leave_Page/Leave_Page.dart';
import 'package:loyaltri_minimal/View/Leave_Page/choose_dates.dart';
import 'package:loyaltri_minimal/View/Leave_Page/leave_widgets/leave_type_bottomSheet.dart';
import 'package:loyaltri_minimal/View/Leave_Page/leave_widgets/success_dialogue.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';
import '../../controller/appliedLeaveList.dart';
import '../../controller/applyForLeave.dart';
import '../../controller/leaveTypeController.dart';
import '../../controller/userAuthentication.dart';
import '../../models/leave_type_api_model.dart';
import '../../services/connectivity_service.dart';
import '../../services/ui_model_services/leave_dates_model.dart';
import '../CWidgets/error_dialog.dart';
import '../../utils/color_utils.dart';
import '../CWidgets/app_bar.dart';
import '../CWidgets/loyaltri_blue_text_button.dart';
import 'leave_widgets/camera_view_leave.dart';
import 'leave_widgets/leave_type_card.dart';

class LeaveRequest extends StatefulWidget {
  final LeaveType? selectedLeave;
  final String? date;
  const LeaveRequest({super.key, this.selectedLeave, this.date});

  @override
  State<LeaveRequest> createState() => _LeaveRequestState();
}

class _LeaveRequestState extends State<LeaveRequest> {
  LeaveApplyController leaveApplyController = Get.find<LeaveApplyController>();
  final LeaveTypeController _leaveTypeController =
  Get.find<LeaveTypeController>();
  UserAuthController userAuthController = Get.find<UserAuthController>();
  AppliedLeaveList appliedLeaveList = Get.find<AppliedLeaveList>();
  final TextEditingController _reasonController = TextEditingController();
  ValueNotifier<bool> leaveTypeSelected = ValueNotifier(false);
  ValueNotifier<bool> selectDatesSelected = ValueNotifier(false);
  ValueNotifier<bool> leaveReasonSelected = ValueNotifier(false);
  ValueNotifier<bool> leaveTypeValidation = ValueNotifier(false);
  ValueNotifier<bool> leaveDateValidation = ValueNotifier(false);
  ValueNotifier<bool> leaveReasonValidation = ValueNotifier(false);
  ValueNotifier<LeaveType?> currentItem = ValueNotifier(null);
  ValueNotifier<LeaveDates?> leaveRange = ValueNotifier(null);
  ApplyLeaveModel? leaveData;
  final FocusNode _reasonFocus = FocusNode();
  List<String> selectedImages = [];

  @override
  void initState() {
    currentItem.value = widget.selectedLeave;
    leaveApi();
    super.initState();
  }

  Future<void> leaveApi() async {
    bool connection = await ConnectivityService().check();
    if (!connection) {
      await ErrorDialog().internetWarn(
        context: context,
        title: "No Internet Connection",
        subTitle: "Please check if your connection is stable.",
        onPressed: () {
          Navigator.of(context).pop();
          leaveApi();
        },
      );
    } else {
      context.loaderOverlay.show();
      await _leaveTypeController.fetchLeaveType(
        compId:
        Get.find<UserProfileController>().userData.value.result.companyId
            ?.toString() ??
            '',
        empId:
        userAuthController.userData.value.userData?.employeeId.toString() ??
            '--',
        monthYear: widget.date
      );
      context.loaderOverlay.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorUtils.workEntryHead,
        extendBody: true,
        body: GestureDetector(
          onTap: () {
            if (_reasonFocus.hasFocus) {
              _reasonFocus.unfocus();
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 8, left: 8, right: 8).w,
            child: Column(
              children: [
                const CustomAppBar(
                  title: "Leave Request",
                  isActionVisible: true,
                  image: "assets/images/leave-calendar3d.webp",
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await _leaveTypeController.fetchLeaveType(
                        compId:
                        Get.find<UserProfileController>()
                            .userData
                            .value
                            .result
                            .companyId
                            ?.toString() ??
                            '',
                        empId:
                        userAuthController
                            .userData
                            .value
                            .userData
                            ?.employeeId
                            .toString() ??
                            '--',
                        monthYear: widget.date
                      );
                    },
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0).w,
                            child: ValueListenableBuilder(
                              valueListenable: leaveTypeValidation,
                              builder: (BuildContext context, validation, Widget? child) {
                                return ValueListenableBuilder(
                                  valueListenable: leaveTypeSelected,
                                  builder: (BuildContext context, value, Widget? child) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            leaveTypeSelected.value = true;
                                            selectDatesSelected.value = false;
                                            leaveReasonSelected.value = false;
                                            leaveTypeBottomSheet(
                                              context: context,
                                              isHomePage: true,
                                              type: (LeaveType leaveType) {
                                                currentItem.value = leaveType;
                                                if (leaveTypeValidation.value) {
                                                  validateFields();
                                                }
                                              },
                                            );
                                          },
                                          child: Container(
                                            width: ScreenUtil().screenWidth,
                                            height: 70.h,
                                            decoration: BoxDecoration(
                                              color: ColorUtils.foregroundBlack,
                                              borderRadius: BorderRadius.circular(
                                                12,
                                              ).r,
                                              border: validation
                                                  ? Border.all(
                                                width: 0.5.h,
                                                color: Colors.red,
                                              )
                                                  : value
                                                  ? Border.all(
                                                width: 0.5.h,
                                                color: const Color(
                                                  0xFF666666,
                                                ),
                                              )
                                                  : null,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10.0).h,
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: [
                                                  Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "Leave Type *",
                                                        style: GoogleFonts.poppins(
                                                          fontWeight:
                                                          FontWeight.w400,
                                                          fontSize: 14.h,
                                                          color: validation
                                                              ? Colors.red
                                                              : const Color(
                                                            0xFFAAAAAA,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 4.h),
                                                      ValueListenableBuilder(
                                                        valueListenable:
                                                        currentItem,
                                                        builder:
                                                            (
                                                            BuildContext context,
                                                            leaveType,
                                                            Widget? child,
                                                            ) {
                                                          if (leaveType !=
                                                              null) {
                                                            return Text(
                                                              leaveType
                                                                  .leaveType ??
                                                                  '--',
                                                              style: GoogleFonts.poppins(
                                                                fontWeight:
                                                                FontWeight
                                                                    .w500,
                                                                fontSize: 16.h,
                                                                color: ColorUtils
                                                                    .textWhite,
                                                              ),
                                                            );
                                                          } else {
                                                            return Text(
                                                              "Select leave type",
                                                              style: GoogleFonts.poppins(
                                                                fontWeight:
                                                                FontWeight
                                                                    .w500,
                                                                fontSize: 16.h,
                                                                color:
                                                                validation
                                                                    ? Colors.red.withValues(
                                                                  alpha:
                                                                  0.5,
                                                                )
                                                                    : ColorUtils
                                                                    .textWhite
                                                                    .withValues(
                                                                  alpha:
                                                                  0.5,
                                                                ),
                                                              ),
                                                            );
                                                          }
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                  Icon(
                                                    Icons.keyboard_arrow_down,
                                                    color: validation
                                                        ? Colors.red.withValues(
                                                      alpha: 0.5,
                                                    )
                                                        : Color(0xFFAAAAAA),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        if(validation)
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 10.h, top: 5.h),
                                              child: Text(
                                                "Leave type is required",
                                                style: GoogleFonts.inter(
                                                  color: ColorUtils.errorRedText,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 11.sp,
                                                ),
                                              ),
                                            ),
                                          )
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0).w,
                            child: ValueListenableBuilder(
                              valueListenable: leaveDateValidation,
                              builder: (BuildContext context, validation, Widget? child) {
                                return ValueListenableBuilder(
                                  valueListenable: selectDatesSelected,
                                  builder: (BuildContext context, value, Widget? child) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            leaveTypeSelected.value = false;
                                            selectDatesSelected.value = true;
                                            leaveReasonSelected.value = false;
                                            Navigator.of(context)
                                                .push(
                                              newSlideNavigation(
                                                ChooseDates(
                                                  leaveType: currentItem.value,
                                                  date: widget.date,
                                                ),
                                              ),
                                            )
                                                .then((value) {
                                              if (value != null &&
                                                  value is LeaveDates) {
                                                leaveRange.value = value;

                                                if (leaveDateValidation.value) {
                                                  validateFields();
                                                }
                                              }
                                            });
                                          },
                                          child: Container(
                                            width: ScreenUtil().screenWidth,
                                            height: 70.h,
                                            decoration: BoxDecoration(
                                              color: ColorUtils.foregroundBlack,
                                              borderRadius: BorderRadius.circular(
                                                12,
                                              ).r,
                                              border: validation
                                                  ? Border.all(
                                                width: 0.5.h,
                                                color: Colors.red,
                                              )
                                                  : value
                                                  ? Border.all(
                                                width: 0.5.h,
                                                color: const Color(
                                                  0xFF666666,
                                                ),
                                              )
                                                  : null,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10.0).h,
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: [
                                                  ValueListenableBuilder(
                                                      valueListenable: currentItem,
                                                      builder: (BuildContext context, selectedType, Widget? child) {
                                                        return Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              "Select ${selectedType?.isHourBased == '1' ? 'Date & Hour' : 'Dates'} *",
                                                              style: GoogleFonts.poppins(
                                                                fontWeight:
                                                                FontWeight.w400,
                                                                fontSize: 14.h,
                                                                color: validation
                                                                    ? Colors.red
                                                                    : const Color(
                                                                  0xFFAAAAAA,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(height: 4.h),
                                                            ValueListenableBuilder(
                                                              valueListenable: leaveRange,
                                                              builder:
                                                                  (
                                                                  BuildContext context,
                                                                  value,
                                                                  Widget? child,
                                                                  ) {
                                                                if (value != null) {
                                                                  if(selectedType?.isHourBased == '1') {
                                                                    return Text(
                                                                      "${DateFormat('dd/MM/yyyy').format(value.startDate!)} - ${value.hour ?? ''} hour",
                                                                      style: GoogleFonts.poppins(
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                        fontSize:
                                                                        16.h,
                                                                        color: ColorUtils
                                                                            .textWhite,
                                                                      ),
                                                                    );
                                                                  } else if (value.endDate !=
                                                                      value
                                                                          .startDate) {
                                                                    return Text(
                                                                      "${DateFormat('dd/MM/yyyy').format(value.startDate!)} - ${DateFormat('dd/MM/yyyy').format(value.endDate!)}",
                                                                      style: GoogleFonts.poppins(
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                        fontSize:
                                                                        16.h,
                                                                        color: ColorUtils
                                                                            .textWhite,
                                                                      ),
                                                                    );
                                                                  } else {
                                                                    return Text(
                                                                      "${DateFormat('dd/MM/yyyy').format(value.startDate!)} ${value.leaveSection != "" ? "(${convertToTitleCase(value.leaveSection!)})" : ""}",
                                                                      style: GoogleFonts.poppins(
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                        fontSize:
                                                                        16.h,
                                                                        color: ColorUtils
                                                                            .textWhite,
                                                                      ),
                                                                    );
                                                                  }
                                                                } else {
                                                                  return Text(
                                                                    selectedType?.isHourBased == '1' ? "Select" : "dd/mm/yyyy - dd/mm/yyyy",
                                                                    style: GoogleFonts.poppins(
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                      fontSize: 16.h,
                                                                      color:
                                                                      validation
                                                                          ? Colors.red.withValues(
                                                                        alpha:
                                                                        0.5,
                                                                      )
                                                                          : ColorUtils
                                                                          .textWhite
                                                                          .withValues(
                                                                        alpha:
                                                                        0.2,
                                                                      ),
                                                                    ),
                                                                  );
                                                                }
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      }
                                                  ),
                                                  ValueListenableBuilder(
                                                      valueListenable: currentItem,
                                                      builder: (BuildContext context, selectedType, Widget? child) {
                                                      return Icon(
                                                        selectedType?.isHourBased == '1' ? Icons.access_time : Icons.calendar_today_outlined,
                                                        color: validation
                                                            ? Colors.red.withValues(
                                                          alpha: 0.5,
                                                        )
                                                            : const Color(
                                                          0xFF9A9A9A,
                                                        ).withValues(alpha: 0.6),
                                                        size: 24.h,
                                                      );
                                                    }
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        if(validation)
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 10.h, top: 5.h),
                                              child: ValueListenableBuilder(
                                                  valueListenable: currentItem,
                                                  builder: (BuildContext context, selectedType, Widget? child) {
                                                  return Text(
                                                    "Leave date${selectedType?.isHourBased == '1' ? ' & hour' : ''} is required",
                                                    style: GoogleFonts.inter(
                                                      color: ColorUtils.errorRedText,
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 11.sp,
                                                    ),
                                                  );
                                                }
                                              ),
                                            ),
                                          )
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0).w,
                            child: ValueListenableBuilder(
                              valueListenable: leaveReasonValidation,
                              builder: (BuildContext context, validation, Widget? child) {
                                return ValueListenableBuilder(
                                  valueListenable: leaveReasonSelected,
                                  builder: (BuildContext context, value, Widget? child) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            leaveTypeSelected.value = false;
                                            selectDatesSelected.value = false;
                                            leaveReasonSelected.value = true;
                                          },
                                          child: Container(
                                            width: ScreenUtil().screenWidth,
                                            height: 70.h,
                                            decoration: BoxDecoration(
                                              color: ColorUtils.foregroundBlack,
                                              borderRadius: BorderRadius.circular(
                                                12,
                                              ).r,
                                              border: validation
                                                  ? Border.all(
                                                width: 0.5.h,
                                                color: Colors.red,
                                              )
                                                  : value
                                                  ? Border.all(
                                                width: 0.5.h,
                                                color: const Color(
                                                  0xFF666666,
                                                ),
                                              )
                                                  : null,
                                            ),
                                            child: Center(
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(
                                                      left: 10,
                                                      top: 10,
                                                    ).h,
                                                    child: Text(
                                                      "Leave Reason *",
                                                      style: GoogleFonts.inter(
                                                        fontWeight: FontWeight.w400,
                                                        fontSize: 14.h,
                                                        color: validation
                                                            ? Colors.red
                                                            : const Color(
                                                          0xFFAAAAAA,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(
                                                      left: 10,
                                                    ).h,
                                                    child: SizedBox(
                                                      height: 35.h,
                                                      child: TextFormField(
                                                        controller:
                                                        _reasonController,
                                                        focusNode: _reasonFocus,
                                                        cursorColor: Colors.grey,
                                                        onChanged: (value) {
                                                          if (leaveReasonValidation
                                                              .value) {
                                                            validateFields();
                                                          }
                                                        },
                                                        onTap: () {
                                                          leaveTypeSelected.value =
                                                          false;
                                                          selectDatesSelected
                                                              .value =
                                                          false;
                                                          leaveReasonSelected
                                                              .value =
                                                          true;
                                                        },
                                                        decoration: InputDecoration(
                                                          hintText:
                                                          "Type reason...",
                                                          hintStyle: GoogleFonts.inter(
                                                            color: validation
                                                                ? Colors.red
                                                                .withValues(
                                                              alpha: 0.5,
                                                            )
                                                                : ColorUtils
                                                                .textWhite
                                                                .withValues(
                                                              alpha: 0.2,
                                                            ),
                                                            fontWeight:
                                                            FontWeight.w500,
                                                            fontSize: 16.h,
                                                          ),
                                                          border: InputBorder.none,
                                                          // contentPadding: const EdgeInsets.only(
                                                          //     left: 10, bottom: 0, top: 0)
                                                          //     .h,
                                                        ),
                                                        style: GoogleFonts.inter(
                                                          color:
                                                          ColorUtils.textWhite,
                                                          fontWeight:
                                                          FontWeight.w500,
                                                          fontSize: 16.h,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        if(validation)
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 10.h, top: 5.h),
                                              child: Text(
                                                "Reason is required",
                                                style: GoogleFonts.inter(
                                                  color: ColorUtils.errorRedText,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 11.sp,
                                                ),
                                              ),
                                            ),
                                          )
                                      ],
                                    );
                                  },
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
                                        fontSize: 14.h,
                                        color: const Color(0xFFAAAAAA),
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      "Max 1 File (Optional)",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12.h,
                                        color: const Color(0xFF5D626D),
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (selectedImages.isNotEmpty) {
                                      ErrorDialog().showWarn(
                                        context: context,
                                        title: "Error",
                                        subTitle: "Maximum 1 file allowed",
                                      );
                                      return;
                                    }
                                    attachBottomSheetShow(context);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 8,
                                    ).h,
                                    decoration: BoxDecoration(
                                      color: ColorUtils.foregroundBlack,
                                      borderRadius: BorderRadius.circular(23).r,
                                    ),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/images/attach_icon.svg",
                                          height: 17.h,
                                        ),
                                        SizedBox(width: 12.h),
                                        Text(
                                          "Add",
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12.h,
                                            color: ColorUtils.textWhite,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 9).h,
                            child: ListView.builder(
                              itemCount: selectedImages.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.only(bottom: 100).h,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 9,
                                  ).h,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 8,
                                    ).h,
                                    decoration: BoxDecoration(
                                      color: ColorUtils.foregroundBlack,
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
                                                selectedImages = [];
                                                setState(() {});
                                              },
                                              child: const Icon(
                                                Icons.close,
                                                color: ColorUtils.textWhite,
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
                                        Flexible(
                                          child: Text(
                                            selectedImages[index]
                                                .split("/")
                                                .last,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12.h,
                                              color: ColorUtils.textWhite,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
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
              height: 70.h,
              decoration: blueTextButtonDecoration,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20).w,
                    child: GetX<LeaveApplyController>(
                      builder: (LeaveApplyController controller) {
                        if (controller.isLoading.value) {
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
                              if (!leaveTypeValidation.value &&
                                  !leaveDateValidation.value &&
                                  !leaveReasonValidation.value) {
                                if (_reasonFocus.hasFocus) {
                                  _reasonFocus.unfocus();
                                }
                                DateTime fromDate =
                                leaveRange.value!.startDate!;
                                DateTime toDate = leaveRange.value!.endDate!;
                                Duration difference = toDate.difference(
                                  fromDate,
                                );
                                int totalLeaveCount = difference.inDays + 1;

                                ApplyLeaveModel leaveData = ApplyLeaveModel(
                                  employeeId:
                                  userAuthController
                                      .userData
                                      .value
                                      .userData
                                      ?.employeeId ??
                                      '--',
                                  companyId:
                                  Get.find<UserProfileController>()
                                      .userData
                                      .value
                                      .result
                                      .companyId
                                      ?.toString() ??
                                      '',
                                  leaveDateFrom: DateFormat(
                                    'yyyy-MM-dd',
                                  ).format(leaveRange.value!.startDate!),
                                  leaveDateTo: DateFormat(
                                    'yyyy-MM-dd',
                                  ).format(leaveRange.value!.endDate!),
                                  totalLeaveDays: totalLeaveCount.toString(),
                                  leaveType: currentItem.value!.leaveTypeId
                                      .toString(),
                                  leaveReason: _reasonController.text,
                                  isActive: "1",
                                  files: selectedImages,
                                  isHalfDay: leaveRange.value!.isHalfDay,
                                  maximumLeaveLimit:
                                  currentItem.value?.maximumLeaveLimit,
                                  leaveApplied: currentItem.value!.leaveApplied
                                      .toString(),
                                  leaveSection: leaveRange.value?.leaveSection,
                                  isHourBased: currentItem.value?.isHourBased,
                                  hourLeaveDate: currentItem.value?.isHourBased == '1' ? DateFormat(
                                    'yyyy-MM-dd',
                                  ).format(leaveRange.value!.startDate!) : null,
                                  leaveHours: leaveRange.value?.hour
                                );
                                await leaveApplyController.requestLeave(
                                  leaveData: leaveData,
                                );
                                if (leaveApplyController.dataLoaded.value) {
                                  if (leaveApplyController.success.value) {
                                    // await appliedLeaveList.fetchLeaveList(empId: userAuthController.userData.value.userData?.employeeId ?? '--').then((value) {
                                    ShowSuccessDialog().showWarn(
                                      context: context,
                                    );
                                    HapticFeedback.lightImpact();
                                    currentItem.value = null;
                                    leaveRange.value = null;
                                    _reasonController.clear();
                                    setState(() {
                                      selectedImages = [];
                                    });
                                    await Future.delayed(const Duration(seconds: 2));
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop(true);
                                    // });
                                  } else {
                                    ErrorDialog().showWarn(
                                      context: context,
                                      title: "Failed!",
                                      subTitle: leaveApplyController.msg.value,
                                    );
                                  }
                                } else {
                                  ErrorDialog().showWarn(
                                    context: context,
                                    title: "Submission Failed!",
                                    subTitle:
                                    leaveApplyController
                                        .msg
                                        .value
                                        .isNotEmpty
                                        ? leaveApplyController.msg.value
                                        : "Something went wrong",
                                  );
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
    if (currentItem.value?.leaveType?.isEmpty ?? true) {
      leaveTypeValidation.value = true;
    } else {
      leaveTypeValidation.value = false;
    }
    if (leaveRange.value == null) {
      leaveDateValidation.value = true;
    } else {
      leaveDateValidation.value = false;
    }
    if (_reasonController.text.trim().isEmpty) {
      leaveReasonValidation.value = true;
    } else {
      leaveReasonValidation.value = false;
    }
  }

  String convertToTitleCase(String input) {
    return input
        .replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (match) {
      return '${match.group(1)} ${match.group(2)}';
    })
        .replaceFirstMapped(RegExp(r'^[a-z]'), (match) {
      return match.group(0)!.toUpperCase();
    });
  }

  attachBottomSheetShow(mainContext) {
    showModalBottomSheet(
      context: mainContext,
      backgroundColor: Colors.black,
      barrierColor: ColorUtils.workEntryHead.withValues(alpha: 0.81),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: ScreenUtil().screenWidth,
              height: 273.h,
              decoration: BoxDecoration(
                color: ColorUtils.backgroundBlack,
                borderRadius: BorderRadius.circular(20).r,
                border: Border.all(width: 1.h, color: const Color(0xFF404040)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 10.0,
                  bottom: 10.0,
                  left: 15.0,
                  right: 15.0,
                ).h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select Source",
                      style: GoogleFonts.poppins(
                        color: ColorUtils.textWhite,
                        fontWeight: FontWeight.w600,
                        fontSize: 17.h,
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
                                ErrorDialog().showWarn(
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
                      child: const AttachMenuCard(
                        imageIcon: "assets/images/camera.webp",
                        title: "Camera",
                        subTitle: "Lorem ipsum dolor sit amet, consectetur elit.",
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
                              ErrorDialog().showWarn(
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
                      child: const AttachMenuCard(
                        imageIcon: "assets/images/image-3d.webp",
                        title: "Photos",
                        subTitle:
                        "Lorem ipsum dolor sit amet, consectetur elit.",
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
                            ErrorDialog().showWarn(
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
                      child: const AttachMenuCard(
                        imageIcon: "assets/images/file-3d.webp",
                        title: "Browse",
                        subTitle:
                        "Lorem ipsum dolor sit amet, consectetur elit.",
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

  Future<void> getLostData(mainContext) async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> image = await picker.pickMultiImage();
    final LostDataResponse response = await picker.retrieveLostData();
    // AttendanceCommonWidgets().printF("------path------${image.path}");
    if(image != null) {
      if(image.isEmpty) return;
      if(selectedImages.isEmpty) {
        if(image.length < (2 - selectedImages.length)) {
          for (var file in image) {
            selectedImages.add(file.path);
          }
          setState(() {});
        } else {
          ErrorDialog().showWarn(context: mainContext, title: "Error", subTitle: "Maximum 1 file allowed");
        }
      } else {
        ErrorDialog().showWarn(context: mainContext, title: "Error", subTitle: "Maximum files selected");
      }
    }
    if (response.isEmpty) {
      return;
    }
    final List<XFile>? files = response.files;

    if(files?.isEmpty ?? false) return;
    files?.forEach((element) {
      if(selectedImages.isEmpty) {
        if(files.length < (2 - selectedImages.length)) {
          for (var file in files) {
            selectedImages.add(file.path);
          }
          setState(() {});
        } else {
          ErrorDialog().showWarn(context: mainContext, title: "Error", subTitle: "Maximum 1 file allowed");
        }
      } else {
        ErrorDialog().showWarn(context: mainContext, title: "Error", subTitle: "Maximum files selected");
      }
      AttendanceCommonWidgets().printF("------path------${element.path}");
    });
    if (files != null) {
      // _handleLostFiles(files);
    } else {
      // _handleError(response.exception);
    }
  }
}
