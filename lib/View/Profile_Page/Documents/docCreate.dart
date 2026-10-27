import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loyaltri_minimal/View/CWidgets/cwidgets.dart';
import 'package:loyaltri_minimal/View/Leave_Page/leave_widgets/success_dialogue.dart';
import 'package:loyaltri_minimal/View/My_Request/controller/my_request_controller.dart';
import 'package:loyaltri_minimal/View/My_Request/my_request_models/request_send_model.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';
import 'package:loyaltri_minimal/models/user_profile_api_model.dart';
import '../../../models/expense_category_model.dart' as categoryModel;
import '../../../models/special_reuest_type_model.dart';
import '../../../services/attachment_service.dart';
import '../../../services/ui_model_services/leave_dates_model.dart';
import '../../../utils/color_utils.dart';
import '../../CWidgets/error_dialog.dart';
import '../../CWidgets/file_selection_sheet.dart';
import '../../CWidgets/loyaltri_blue_text_button.dart';
import '../../Leave_Page/leave_widgets/camera_view_leave.dart';
import '../../Leave_Page/leave_widgets/leave_type_card.dart';
import '../../ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import '../../My_Request/my_request_widgets/Choose_Request_Dates.dart';
import '../../Work_Expenses/work_expense_widgets/Category_Bottom_Sheet.dart';

class DocCreation extends StatelessWidget {
  DocCreation({super.key});

  final TextEditingController reasonController = TextEditingController();
  final AttachmentService _attachmentService = AttachmentService();
  final MyRequestControllerNew _myRequestController = Get.find<MyRequestControllerNew>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        _myRequestController.clearReqCreateData();
        _attachmentService.clearFiles();
      },
      child: SafeArea(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            backgroundColor: ColorUtils.workEntryHead,
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.h),
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(14).r,
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: 48.h,
                          height: 48.h,
                          decoration: BoxDecoration(
                            color: ColorUtils.backgroundBlack,
                            borderRadius: BorderRadius.circular(14).r,
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5).h,
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: ColorUtils.textWhite,
                                size: 15.h,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        "Add Document",
                        style: GoogleFonts.poppins(
                          color: ColorUtils.textWhite,
                          fontWeight: FontWeight.w500,
                          fontSize: 15.h,
                        ),
                      ),
                      Container(
                        width: 48.h,
                        height: 48.h,
                        color: Colors.transparent,
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 10.h),
                          GetX<MyRequestControllerNew>(
                              builder: (MyRequestControllerNew controller) {
                                bool isError = controller.showValidation.value && (controller.selectedDropDown1.value?.trim().isEmpty ?? true);
                                List<String> parts = controller.selectedDropDown1.value?.split('<#>') ?? [];
                                String? selectedType = parts.isNotEmpty ? parts.first : null;
                                return Container(
                                  width: ScreenUtil().screenWidth,
                                  height: 54.h,
                                  decoration: BoxDecoration(
                                    color: ColorUtils.foregroundBlack,
                                    borderRadius: BorderRadius.circular(12).r,
                                    border: Border.all(
                                      color: isError
                                          ? Colors.red
                                          : ColorUtils.workEntryHead.withValues(alpha: 0.1),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Theme(
                                          data: Theme.of(context).copyWith(
                                            splashColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            splashFactory: NoSplash.splashFactory,
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              if(controller.documentTypes.value?.isEmpty ?? false) {
                                                AttendanceCommonWidgets().showSnackBar(
                                                  context: context,
                                                  backgroundColor: Colors.red,
                                                  message: 'Document types not available',
                                                );
                                              }
                                            },
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton2<String>(
                                                isExpanded: true,
                                                hint: Text(
                                                  'Choose Document Type',
                                                  style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14.h,
                                                    color: ColorUtils.textWhite,
                                                  ),
                                                ),
                                                customButton: Container(
                                                  width: ScreenUtil().screenWidth,
                                                  height: 54.h,
                                                  padding: EdgeInsets.only(left: 16.h, right: 10.h),
                                                  decoration: BoxDecoration(
                                                    color: ColorUtils.foregroundBlack,
                                                    borderRadius: BorderRadius.circular(12).r,
                                                    border: Border.all(
                                                      color: ColorUtils.workEntryHead.withValues(
                                                        alpha: 0.1,
                                                      ),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          selectedType ??
                                                              'Choose Document Type *',
                                                          overflow: TextOverflow.ellipsis,
                                                          style: GoogleFonts.dmSans(
                                                            fontSize: 14.h,
                                                            color: isError
                                                                ? Colors.red
                                                                : ColorUtils.textWhite.withValues(
                                                              alpha:
                                                              controller
                                                                  .selectedDropDown1
                                                                  .value ==
                                                                  null
                                                                  ? 0.5
                                                                  : 1,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const Icon(
                                                        Icons.keyboard_arrow_down,
                                                        color: Color(0xFF9A9A9A),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // selectedItemBuilder: (context) {
                                                //   return controller.shiftList.map((option) {
                                                //     // ... snippet
                                                //   }).toList();
                                                // },
                                                items: controller.documentTypes
                                                    .map(
                                                      (option) {
                                                        List<String> parts = option.documentType?.split('<#>') ?? [];
                                                        String? type = parts.isNotEmpty ? parts.first : null;
                                                        return DropdownMenuItem<String>(
                                                          value: option.documentType,
                                                          child: Text(
                                                            type ?? 'Choose Document Type',
                                                            overflow: TextOverflow.ellipsis,
                                                            style: GoogleFonts.dmSans(
                                                              fontWeight: FontWeight.w400,
                                                              fontSize: 14.h,
                                                              color: ColorUtils.textWhite.withValues(
                                                                alpha: option.documentType == 'Choose Document Type'
                                                                    ? 0.5
                                                                    : 1.0,
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                )
                                                    .toList(),
                                                value: controller.selectedDropDown1.value,
                                                onChanged: (selectedValue) async {
                                                  controller.selectedDropDown1.value = selectedValue;
                                                },
                                                dropdownStyleData: DropdownStyleData(
                                                  decoration: BoxDecoration(
                                                    color: ColorUtils.foregroundBlack,
                                                    borderRadius: BorderRadius.circular(8).r,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                          ),
                          GetX<MyRequestControllerNew>(
                              builder: (MyRequestControllerNew controller) {
                                bool isError = controller.showValidation.value && (controller.selectedDropDown1.value?.trim().isEmpty ?? true);
                                if(isError) {
                                  return Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(left: 15.h, top: 4.h),
                                    child: Text(
                                      "Document type is required",
                                      style: GoogleFonts.inter(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 11.h,
                                      ),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              }
                          ),
                          SizedBox(height: 15.h),
                          GetX<MyRequestControllerNew>(
                              builder: (MyRequestControllerNew controller) {
                                bool isError = controller.showValidation.value && (controller.selectedText1.value?.trim().isEmpty ?? true);
                                return Container(
                                  width: ScreenUtil().screenWidth,
                                  height: 54.h,
                                  padding: EdgeInsets.symmetric(horizontal: 15.h),
                                  decoration: BoxDecoration(
                                    color: ColorUtils.foregroundBlack,
                                    borderRadius: BorderRadius.circular(12).r,
                                    border: Border.all(
                                      color: isError
                                          ? Colors.red
                                          : ColorUtils.workEntryHead.withValues(alpha: 0.1),
                                    ),
                                  ),
                                  child: TextField(
                                    keyboardType: TextInputType.text,
                                    onChanged: (value) {
                                      _myRequestController.selectedText1.value = value;
                                    },
                                    style: GoogleFonts.inter(
                                      color: ColorUtils.textWhite,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15.h,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Enter Document Name *",
                                      contentPadding: EdgeInsets.symmetric(vertical: 15.h),
                                      border: const OutlineInputBorder(borderSide: BorderSide.none),
                                      hintStyle: GoogleFonts.inter(
                                        color: isError ? Colors.red : const Color(0xFFAAAAAA).withValues(alpha: 0.7),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15.h,
                                        letterSpacing: -0.3,
                                      ),
                                    ),
                                    maxLines: 1,
                                  ),
                                );
                              }
                          ),
                          GetX<MyRequestControllerNew>(
                              builder: (MyRequestControllerNew controller) {
                                bool isError = controller.showValidation.value && (controller.selectedText1.value?.trim().isEmpty ?? true);
                                if(isError) {
                                  return Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(left: 15.h, top: 4.h),
                                    child: Text(
                                      "Document Name is required",
                                      style: GoogleFonts.inter(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 11.h,
                                      ),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              }
                          ),
                          SizedBox(height: 15.h),
                          GetX<MyRequestControllerNew>(
                              builder: (MyRequestControllerNew controller) {
                                List<String> parts = controller.selectedDropDown2.value?.split('<#>') ?? [];
                                String? selectedType = parts.isNotEmpty ? parts.first : null;
                                return Container(
                                  width: ScreenUtil().screenWidth,
                                  height: 54.h,
                                  decoration: BoxDecoration(
                                    color: ColorUtils.foregroundBlack,
                                    borderRadius: BorderRadius.circular(12).r,
                                    border: Border.all(
                                      color: ColorUtils.workEntryHead.withValues(alpha: 0.1),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Theme(
                                          data: Theme.of(context).copyWith(
                                            splashColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            splashFactory: NoSplash.splashFactory,
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              if(controller.countryStateCityList.value?.isEmpty ?? false) {
                                                AttendanceCommonWidgets().showSnackBar(
                                                  context: context,
                                                  backgroundColor: Colors.red,
                                                  message: 'Country not available',
                                                );
                                              }
                                            },
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton2<String>(
                                                isExpanded: true,
                                                hint: Text(
                                                  'Select Country',
                                                  style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14.h,
                                                    color: ColorUtils.textWhite,
                                                  ),
                                                ),
                                                customButton: Container(
                                                  width: ScreenUtil().screenWidth,
                                                  height: 54.h,
                                                  padding: EdgeInsets.only(left: 16.h, right: 10.h),
                                                  decoration: BoxDecoration(
                                                    color: ColorUtils.foregroundBlack,
                                                    borderRadius: BorderRadius.circular(12).r,
                                                    border: Border.all(
                                                      color: ColorUtils.workEntryHead.withValues(
                                                        alpha: 0.1,
                                                      ),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          selectedType ??
                                                              'Select Country',
                                                          overflow: TextOverflow.ellipsis,
                                                          style: GoogleFonts.dmSans(
                                                            fontSize: 14.h,
                                                            color: ColorUtils.textWhite.withValues(
                                                              alpha:
                                                              controller
                                                                  .selectedDropDown2
                                                                  .value ==
                                                                  null
                                                                  ? 0.5
                                                                  : 1,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const Icon(
                                                        Icons.keyboard_arrow_down,
                                                        color: Color(0xFF9A9A9A),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                items: controller.countryStateCityList
                                                    .map(
                                                      (option) {
                                                    List<String> parts = option.countryName?.split('<#>') ?? [];
                                                    String? type = parts.isNotEmpty ? parts.first : null;
                                                    return DropdownMenuItem<String>(
                                                      value: option.countryName,
                                                      child: Text(
                                                        type ?? 'Select Country',
                                                        overflow: TextOverflow.ellipsis,
                                                        style: GoogleFonts.dmSans(
                                                          fontWeight: FontWeight.w400,
                                                          fontSize: 14.h,
                                                          color: ColorUtils.textWhite.withValues(
                                                            alpha: option.countryName == 'Select Country'
                                                                ? 0.5
                                                                : 1.0,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                )
                                                    .toList(),
                                                value: controller.selectedDropDown2.value,
                                                onChanged: (selectedValue) async {
                                                  controller.selectedDropDown2.value = selectedValue;
                                                },
                                                dropdownStyleData: DropdownStyleData(
                                                  decoration: BoxDecoration(
                                                    color: ColorUtils.foregroundBlack,
                                                    borderRadius: BorderRadius.circular(8).r,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                          ),
                          SizedBox(height: 15.h),
                          InkWell(
                            borderRadius: BorderRadius.circular(10).r,
                            onTap: () {
                              DateTime? fromDate;
                              try {
                                fromDate = DateTime.parse(_myRequestController.selectedFromDate.value!);
                              } catch(e) {}
                              Navigator.of(context).push(fadeNavigation(ChooseRequestDatesSingle(
                                showFutureDates: false,
                                selectedDates: LeaveDates(
                                    startDate: fromDate
                                ),
                                highlightToday: true,
                              )))
                                  .then((value) {
                                if (value != null && value is LeaveDates) {
                                  if (value.startDate != null) {
                                    _myRequestController.selectedFromDate.value =
                                        DateFormat('yyyy-MM-dd').format(value.startDate!);
                                  }
                                }
                              });
                            },
                            child: GetX<MyRequestControllerNew>(
                                builder: (MyRequestControllerNew controller) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 15).h,
                                    height: 54.h,
                                    decoration: BoxDecoration(
                                      color: ColorUtils.foregroundBlack,
                                      borderRadius: BorderRadius.circular(10).r,
                                      border: Border.all(
                                        color: Colors.transparent,
                                        width: 1.h,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            controller.selectedFromDate.value ?? 'Issued On',
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.inter(
                                              color: ColorUtils.textWhite.withValues(
                                                alpha: controller.selectedFromDate.value != null
                                                    ? 1.0
                                                    : 0.5,
                                              ),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 13.h,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 5.h),
                                        Icon(
                                          Icons.calendar_today_outlined,
                                          color: const Color(0xFF9A9A9A).withValues(alpha: 0.6),
                                          size: 17.h,
                                        ),
                                      ],
                                    ),
                                  );
                                }
                            ),
                          ),
                          SizedBox(height: 15.h),
                          InkWell(
                            borderRadius: BorderRadius.circular(10).r,
                            onTap: () {
                              DateTime? fromDate;
                              try {
                                fromDate = DateTime.parse(_myRequestController.selectedText2.value!);
                              } catch(e) {}
                              Navigator.of(context).push(fadeNavigation(ChooseRequestDatesSingle(
                                showFutureDates: true,
                                selectedDates: LeaveDates(
                                    startDate: fromDate
                                ),
                              )))
                                  .then((value) {
                                if (value != null && value is LeaveDates) {
                                  if (value.startDate != null) {
                                    _myRequestController.selectedText2.value =
                                        DateFormat('yyyy-MM-dd').format(value.startDate!);
                                  }
                                }
                              });
                            },
                            child: GetX<MyRequestControllerNew>(
                                builder: (MyRequestControllerNew controller) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 15).h,
                                    height: 54.h,
                                    decoration: BoxDecoration(
                                      color: ColorUtils.foregroundBlack,
                                      borderRadius: BorderRadius.circular(10).r,
                                      border: Border.all(
                                        color: Colors.transparent,
                                        width: 1.h,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            controller.selectedText2.value ?? 'Valid From',
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.inter(
                                              color: ColorUtils.textWhite.withValues(
                                                alpha: controller.selectedText2.value != null
                                                    ? 1.0
                                                    : 0.5,
                                              ),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 13.h,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 5.h),
                                        Icon(
                                          Icons.calendar_today_outlined,
                                          color: const Color(0xFF9A9A9A).withValues(alpha: 0.6),
                                          size: 17.h,
                                        ),
                                      ],
                                    ),
                                  );
                                }
                            ),
                          ),
                          SizedBox(height: 15.h),
                          InkWell(
                            borderRadius: BorderRadius.circular(10).r,
                            onTap: () {
                              DateTime? fromDate;
                              try {
                                fromDate = DateTime.parse(_myRequestController.selectedToDate.value!);
                              } catch(e) {}
                              Navigator.of(context).push(fadeNavigation(ChooseRequestDatesSingle(
                                showFutureDates: true,
                                selectedDates: LeaveDates(
                                    startDate: fromDate
                                ),
                              )))
                                  .then((value) {
                                if (value != null && value is LeaveDates) {
                                  if (value.startDate != null) {
                                    _myRequestController.selectedToDate.value =
                                        DateFormat('yyyy-MM-dd').format(value.startDate!);
                                  }
                                }
                              });
                            },
                            child: GetX<MyRequestControllerNew>(
                                builder: (MyRequestControllerNew controller) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 15).h,
                                    height: 54.h,
                                    decoration: BoxDecoration(
                                      color: ColorUtils.foregroundBlack,
                                      borderRadius: BorderRadius.circular(10).r,
                                      border: Border.all(
                                        color: Colors.transparent,
                                        width: 1.h,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            controller.selectedToDate.value ?? 'Expires On',
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.inter(
                                              color: ColorUtils.textWhite.withValues(
                                                alpha: controller.selectedToDate.value != null
                                                    ? 1.0
                                                    : 0.5,
                                              ),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 13.h,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 5.h),
                                        Icon(
                                          Icons.calendar_today_outlined,
                                          color: const Color(0xFF9A9A9A).withValues(alpha: 0.6),
                                          size: 17.h,
                                        ),
                                      ],
                                    ),
                                  );
                                }
                            ),
                          ),
                          SizedBox(height: 15.h),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 172.h,
                                width: ScreenUtil().screenWidth,
                                padding: const EdgeInsets.all(15).h,
                                decoration: BoxDecoration(
                                  color: ColorUtils.foregroundBlack,
                                  borderRadius: BorderRadius.circular(15).r,
                                  border: Border.all(
                                    color: Colors.transparent,
                                    width: 1.h,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Description",
                                      style: GoogleFonts.inter(
                                        color: const Color(
                                          0xFFAAAAAA,
                                        ).withValues(alpha: 0.7),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13.h,
                                      ),
                                    ),
                                    TextField(
                                      controller: reasonController,
                                      onChanged: (value) {
                                        _myRequestController.reasonText.value =
                                            value;
                                      },
                                      style: GoogleFonts.inter(
                                        color: ColorUtils.textWhite,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15.h,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: "Type here...",
                                        contentPadding: EdgeInsets.zero,
                                        border: const OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                        hintStyle: GoogleFonts.inter(
                                          color: const Color(
                                            0xFFAAAAAA,
                                          ).withValues(alpha: 0.7),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12.h,
                                          letterSpacing: -0.3,
                                        ),
                                      ),
                                      maxLines: 5,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15.h),
                          Row(
                            children: [
                              SizedBox(width: 15.h),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Is document under renewal ?",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.h,
                                      color: ColorUtils.lightGrey,
                                    ),
                                  ),
                                  GetX<MyRequestControllerNew>(
                                    builder: (MyRequestControllerNew controller) {
                                      return RadioGroup<String>(
                                        groupValue: controller.selectedFromTime.value,
                                        onChanged: (value) {
                                          controller.selectedFromTime.value = value;
                                        },
                                        child: Row(
                                          children: [
                                            const Radio<String>(
                                                value: 'yes', 
                                                activeColor: ColorUtils.primaryBlue,
                                              fillColor: WidgetStatePropertyAll(ColorUtils.offDayShift3),
                                            ),
                                            Text(
                                                'Yes',
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14.h,
                                                  color: ColorUtils.offDayShift3,
                                                ),
                                            ),
                                            const Radio<String>(
                                                value: 'no',
                                                activeColor: ColorUtils.primaryBlue,
                                              fillColor: WidgetStatePropertyAll(ColorUtils.offDayShift3),
                                            ),
                                            Text(
                                              'No',
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14.h,
                                                color: ColorUtils.offDayShift3,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  )
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 15.h),
                          Padding(
                            padding: EdgeInsets.only(
                              top: 18.0,
                              left: 18.0,
                              right: 18.0,
                              bottom: 5
                            ).h,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ValueListenableBuilder(
                                  valueListenable: _attachmentService.selectedFiles,
                                  builder: (context, files, child) {
                                    return GetX<MyRequestControllerNew>(
                                        builder: (MyRequestControllerNew controller) {
                                          bool isError = controller.showValidation.value && files.isEmpty;
                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Attachments *",
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14.h,
                                                  color: isError ? Colors.red : const Color(0xFFAAAAAA),
                                                ),
                                              ),
                                              SizedBox(height: 4.h),
                                              Text(
                                                "Max 1 File",
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12.h,
                                                  color: isError ? Colors.red : const Color(0xFF5D626D),
                                                ),
                                              ),
                                            ],
                                          );
                                        }
                                    );
                                  },
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (_attachmentService.selectedFiles.value.isNotEmpty) {
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
                          ValueListenableBuilder(
                              valueListenable: _attachmentService.selectedFiles,
                              builder: (context, files, child) {
                              return GetX<MyRequestControllerNew>(
                                  builder: (MyRequestControllerNew controller) {
                                    bool isError = controller.showValidation.value && files.isEmpty;
                                    if(isError) {
                                      return Container(
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.only(left: 18.h, top: 4.h),
                                        child: Text(
                                          "File is required",
                                          style: GoogleFonts.inter(
                                            color: Colors.red,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 11.h,
                                          ),
                                        ),
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  }
                              );
                            }
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 9).h,
                            child: ValueListenableBuilder(
                              valueListenable: _attachmentService.selectedFiles,
                              builder: (context, files, child) {
                                return ListView.builder(
                                  itemCount: files.length,
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
                                                    _attachmentService.clearFiles();
                                                  },
                                                  child: const Icon(
                                                    Icons.close,
                                                    color: ColorUtils.textWhite,
                                                  ),
                                                ),
                                                SizedBox(width: 10.h),
                                                if(files[index].split('.').isNotEmpty && files[index].split('.').last == 'pdf')
                                                  Image.asset(
                                                    "assets/images/manager_view/pdf_icon.png",
                                                    height: 35.h,
                                                  )
                                                else
                                                  Image.file(
                                                    File(files[index]),
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
                                                files[index]
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
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 10.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 5.h),
              child: InkWell(
                borderRadius: BorderRadius.circular(37).r,
                onTap: () async {
                  if(_myRequestController.documentCrating.value) return;
                  bool docType = _myRequestController.selectedDropDown1.value?.trim().isEmpty ?? true;
                  bool docName = _myRequestController.selectedText1.value?.trim().isEmpty ?? true;
                  bool attachment = _attachmentService.selectedFiles.value.isEmpty;
                  if(docType || docName || attachment) {
                    _myRequestController.showValidation.value = true;
                    await HapticFeedback.lightImpact();
                    return;
                  }
                  final resp = await _myRequestController.addDocument(_attachmentService.selectedFiles.value.first);
                  if(resp.status == 1) {
                    Navigator.of(context).pop(resp.message ?? 'Document Added Successfully');
                  } else {
                    AttendanceCommonWidgets().showSnackBar(
                        context: context,
                        backgroundColor: Colors.red,
                        message: resp.message ?? "Something went wrong",
                    );
                  }
                },
                  child: GetX<MyRequestControllerNew>(
                    builder: (MyRequestControllerNew controller) {
                      return LoyaltriBlueTextButton(text: 'Add', showLoading: controller.documentCrating.value);
                    }
                  ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// class ShiftSwapRequest extends StatelessWidget {
//   const ShiftSwapRequest({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         GetX<MyRequestController>(
//             builder: (MyRequestController controller) {
//               bool isError = controller.showValidation.value && controller.selectedFromDate.value == null;
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   InkWell(
//                     borderRadius: BorderRadius.circular(10).r,
//                     onTap: () {
//                       DateTime? fromDate;
//                       try {
//                         fromDate = DateTime.parse(_myRequestController.selectedFromDate.value!);
//                       } catch(e) {}
//                       Navigator.of(context).push(
//                         newSlideNavigation(ChooseRequestDatesSingle(
//                           selectedDates: LeaveDates(
//                               startDate: fromDate
//                           ),
//                         )),
//                       ).then((value) {
//                         if (value != null && value is LeaveDates) {
//                           if (value.startDate != null) {
//                             _myRequestController.selectedFromDate.value =
//                                 DateFormat('yyyy-MM-dd').format(value.startDate!);
//                           }
//                         }
//                       });
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 15).h,
//                       height: 54.h,
//                       decoration: BoxDecoration(
//                         color: ColorUtils.foregroundBlack,
//                         borderRadius: BorderRadius.circular(10).r,
//                         border: Border.all(
//                           color: isError ? Colors.red : Colors.transparent,
//                           width: 1.h,
//                         ),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Flexible(
//                             child: Text(
//                               controller.selectedFromDate.value ?? 'Choose Date *',
//                               overflow: TextOverflow.ellipsis,
//                               style: GoogleFonts.inter(
//                                 color: isError ? Colors.red : ColorUtils.textWhite.withValues(
//                                   alpha: controller.selectedFromDate.value != null
//                                       ? 1.0
//                                       : 0.5,
//                                 ),
//                                 fontWeight: FontWeight.w400,
//                                 fontSize: 13.h,
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: 5.h),
//                           Icon(
//                             Icons.calendar_today_outlined,
//                             color: const Color(0xFF9A9A9A).withValues(alpha: 0.6),
//                             size: 17.h,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   if (isError)
//                     Padding(
//                       padding: EdgeInsets.only(left: 15.h, top: 4.h),
//                       child: Text(
//                         "Date is required",
//                         style: GoogleFonts.inter(
//                           color: Colors.red,
//                           fontWeight: FontWeight.w400,
//                           fontSize: 11.h,
//                         ),
//                       ),
//                     ),
//                 ],
//               );
//             }
//         ),
//         SizedBox(height: 15.h),
//         Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Row(
//               children: [
//                 SizedBox(width: 15.h),
//                 Text(
//                   'Current Shift : ',
//                   overflow: TextOverflow.ellipsis,
//                   style: GoogleFonts.poppins(
//                     color: ColorUtils.textWhite,
//                     fontWeight: FontWeight.w400,
//                     fontSize: 11.h,
//                   ),
//                 ),
//                 Flexible(
//                   child: Container(
//                     padding: EdgeInsets.symmetric(
//                       vertical: 5.h,
//                       horizontal: 10.h,
//                     ),
//                     decoration: BoxDecoration(
//                       color: ColorUtils.textWhite.withValues(alpha: 0.1),
//                       borderRadius: BorderRadius.circular(50).r,
//                     ),
//                     child: GetX<UserProfileController>(
//                         builder: (UserProfileController controller) {
//                           List<ShiftData>? shift = controller.userData.value.result.employeeShift;
//                           return Text(
//                             (shift?.isNotEmpty ?? false) ? shift?.first.shift ?? '--' : '--',
//                             overflow: TextOverflow.ellipsis,
//                             style: GoogleFonts.poppins(
//                               color: ColorUtils.textWhite,
//                               fontWeight: FontWeight.w500,
//                               fontSize: 11.h,
//                             ),
//                           );
//                         }
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 15.h),
//               ],
//             ),
//             SizedBox(height: 15.h),
//           ],
//         ),
//         GetX<MyRequestController>(
//             builder: (MyRequestController controller) {
//               bool isError = controller.showValidation.value && (controller.selectedDropDown1.value?.trim().isEmpty ?? true);
//               return Container(
//                 width: ScreenUtil().screenWidth,
//                 height: 54.h,
//                 decoration: BoxDecoration(
//                   color: ColorUtils.foregroundBlack,
//                   borderRadius: BorderRadius.circular(12).r,
//                   border: Border.all(
//                     color: isError
//                         ? Colors.red
//                         : ColorUtils.workEntryHead.withValues(alpha: 0.1),
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Expanded(
//                       child: Theme(
//                         data: Theme.of(context).copyWith(
//                           splashColor: Colors.transparent,
//                           highlightColor: Colors.transparent,
//                           hoverColor: Colors.transparent,
//                           splashFactory: NoSplash.splashFactory,
//                         ),
//                         child: GestureDetector(
//                           onTap: () {
//                             if(controller.shiftList.value?.isEmpty ?? false) {
//                               AttendanceCommonWidgets().showSnackBar(
//                                 context: context,
//                                 backgroundColor: Colors.red,
//                                 message: 'No shifts available',
//                               );
//                             }
//                           },
//                           child: DropdownButtonHideUnderline(
//                             child: DropdownButton2<String>(
//                               isExpanded: true,
//                               hint: Text(
//                                 'Choose New Shift',
//                                 style: GoogleFonts.poppins(
//                                   fontWeight: FontWeight.w400,
//                                   fontSize: 14.h,
//                                   color: ColorUtils.textWhite,
//                                 ),
//                               ),
//                               customButton: Container(
//                                 width: ScreenUtil().screenWidth,
//                                 height: 54.h,
//                                 padding: EdgeInsets.only(left: 16.h, right: 10.h),
//                                 decoration: BoxDecoration(
//                                   color: ColorUtils.foregroundBlack,
//                                   borderRadius: BorderRadius.circular(12).r,
//                                   border: Border.all(
//                                     color: ColorUtils.workEntryHead.withValues(
//                                       alpha: 0.1,
//                                     ),
//                                   ),
//                                 ),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Expanded(
//                                       child: Text(
//                                         controller.selectedDropDown1.value ??
//                                             'Choose Shift *',
//                                         overflow: TextOverflow.ellipsis,
//                                         style: GoogleFonts.dmSans(
//                                           fontSize: 14.h,
//                                           color: isError
//                                               ? Colors.red
//                                               : ColorUtils.textWhite.withValues(
//                                             alpha:
//                                             controller
//                                                 .selectedDropDown1
//                                                 .value ==
//                                                 null
//                                                 ? 0.5
//                                                 : 1,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     const Icon(
//                                       Icons.keyboard_arrow_down,
//                                       color: Color(0xFF9A9A9A),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               // selectedItemBuilder: (context) {
//                               //   return controller.shiftList.map((option) {
//                               //     // ... snippet
//                               //   }).toList();
//                               // },
//                               items: controller.shiftList
//                                   .map(
//                                     (option) => DropdownMenuItem<String>(
//                                   value: option,
//                                   child: Text(
//                                     option ?? 'Choose New Shift',
//                                     overflow: TextOverflow.ellipsis,
//                                     style: GoogleFonts.dmSans(
//                                       fontWeight: FontWeight.w400,
//                                       fontSize: 14.h,
//                                       color: ColorUtils.textWhite.withValues(
//                                         alpha: option == 'Choose New Shift'
//                                             ? 0.5
//                                             : 1.0,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               )
//                                   .toList(),
//                               value: controller.selectedDropDown1.value,
//                               onChanged: (selectedValue) async {
//                                 controller.selectedDropDown1.value = selectedValue;
//                               },
//                               dropdownStyleData: DropdownStyleData(
//                                 decoration: BoxDecoration(
//                                   color: ColorUtils.foregroundBlack,
//                                   borderRadius: BorderRadius.circular(8).r,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             }
//         ),
//         GetX<MyRequestController>(
//             builder: (MyRequestController controller) {
//               bool isError = controller.showValidation.value && (controller.selectedDropDown1.value?.trim().isEmpty ?? true);
//               if(isError) {
//                 return Container(
//                   alignment: Alignment.centerLeft,
//                   padding: EdgeInsets.only(left: 15.h, top: 4.h),
//                   child: Text(
//                     "Shift is required",
//                     style: GoogleFonts.inter(
//                       color: Colors.red,
//                       fontWeight: FontWeight.w400,
//                       fontSize: 11.h,
//                     ),
//                   ),
//                 );
//               }
//               return const SizedBox.shrink();
//             }
//         ),
//       ],
//     );
//   }
// }
//
// class LetterRequest extends StatelessWidget {
//   const LetterRequest({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         InkWell(
//           borderRadius: BorderRadius.circular(10).r,
//           onTap: () {
//             Navigator.of(context).push(
//                 newSlideNavigation(ChooseLetterType(
//                   selectedValue:
//                   _myRequestController.selectedDropDown2.value ??
//                       '',
//                   setSelectedValue: (String value) {
//                     _myRequestController.selectedDropDown2.value =
//                         value;
//                   },
//                 ))
//             );
//           },
//           child: GetX<MyRequestController>(
//               builder: (MyRequestController controller) {
//                 bool isError = controller.showValidation.value && (controller.selectedDropDown2.value?.trim().isEmpty ?? true);
//                 return Container(
//                   height: 54.h,
//                   alignment: Alignment.centerLeft,
//                   padding: const EdgeInsets.only(left: 13, right: 13).h,
//                   width: ScreenUtil().screenWidth,
//                   decoration: BoxDecoration(
//                     color: ColorUtils.foregroundBlack,
//                     borderRadius: BorderRadius.circular(10).r,
//                     border: Border.all(
//                       color: isError ? Colors.red : Colors.transparent,
//                       width: 1.h,
//                     ),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         (controller.selectedDropDown2.value?.trim().isNotEmpty ??
//                             false)
//                             ? controller.selectedDropDown2.value!
//                             : "Choose Letter type *",
//                         style: GoogleFonts.poppins(
//                           fontWeight: FontWeight.w500,
//                           fontSize: 13.h,
//                           color:
//                           (controller.selectedDropDown2.value
//                               ?.trim()
//                               .isNotEmpty ??
//                               false)
//                               ? ColorUtils.textWhite
//                               : isError ? Colors.red : ColorUtils.textWhite.withValues(alpha: 0.5),
//                         ),
//                       ),
//                       Text(
//                         String.fromCharCode(Icons.arrow_forward_ios.codePoint),
//                         style: TextStyle(
//                           fontSize: 13.h,
//                           fontWeight: FontWeight.w500,
//                           color: ColorUtils.textWhite.withValues(alpha: 0.5),
//                           fontFamily: Icons.arrow_forward_ios.fontFamily,
//                           package: Icons.arrow_forward_ios.fontPackage,
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               }
//           ),
//         ),
//         GetX<MyRequestController>(
//             builder: (MyRequestController controller) {
//               bool isError = controller.showValidation.value && (controller.selectedDropDown2.value?.trim().isEmpty ?? true);
//               if(isError) {
//                 return Container(
//                   alignment: Alignment.centerLeft,
//                   padding: EdgeInsets.only(left: 13.h, top: 4.h),
//                   child: Text(
//                     "Letter type is required",
//                     style: GoogleFonts.inter(
//                       color: Colors.red,
//                       fontWeight: FontWeight.w400,
//                       fontSize: 11.h,
//                     ),
//                   ),
//                 );
//               }
//               return const SizedBox.shrink();
//             }
//         ),
//       ],
//     );
//   }
// }
//
// class RemoteRequest extends StatelessWidget {
//   const RemoteRequest({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           height: 54.h,
//           alignment: Alignment.centerLeft,
//           padding: const EdgeInsets.only(left: 13).h,
//           width: ScreenUtil().screenWidth,
//           decoration: BoxDecoration(
//             color: ColorUtils.foregroundBlack,
//             borderRadius: BorderRadius.circular(10).r,
//           ),
//           child: Text(
//             "Remote/On Duty Request",
//             style: GoogleFonts.poppins(
//               fontWeight: FontWeight.w500,
//               fontSize: 13.h,
//               color: ColorUtils.textWhite,
//             ),
//           ),
//         ),
//         SizedBox(height: 15.h),
//         InkWell(
//           borderRadius: BorderRadius.circular(10).r,
//           onTap: () {
//             DateTime? fromDate;
//             DateTime? toDate;
//             try {
//               fromDate = DateTime.parse(_myRequestController.selectedFromDate.value!);
//               toDate = DateTime.parse(_myRequestController.selectedToDate.value!);
//             } catch(e) {}
//             Navigator.of(context).push(
//               newSlideNavigation(ChooseRequestDates(
//                 selectedDates: LeaveDates(
//                     startDate: fromDate,
//                     endDate: toDate
//                 ),
//               )),
//             ).then((value) {
//               if (value != null && value is LeaveDates) {
//                 if (value.startDate != null) {
//                   _myRequestController.selectedFromDate.value =
//                       DateFormat('yyyy-MM-dd').format(value.startDate!);
//                 }
//                 if (value.endDate != null) {
//                   _myRequestController.selectedToDate.value =
//                       DateFormat('yyyy-MM-dd').format(value.endDate!);
//                 }
//               }
//             });
//           },
//           child: GetX<MyRequestController>(
//               builder: (MyRequestController controller) {
//                 bool isFromError = controller.showValidation.value && controller.selectedFromDate.value == null;
//                 bool isToError = controller.showValidation.value && controller.selectedToDate.value == null;
//                 return Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Flexible(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                             height: 54.h,
//                             padding: EdgeInsets.symmetric(horizontal: 15.h),
//                             decoration: BoxDecoration(
//                               color: ColorUtils.foregroundBlack,
//                               borderRadius: BorderRadius.circular(10).r,
//                               border: Border.all(
//                                 color: isFromError ? Colors.red : Colors.transparent,
//                                 width: 1.h,
//                               ),
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   controller.selectedFromDate.value ?? "From Date *",
//                                   style: GoogleFonts.inter(
//                                     color: isFromError ? Colors.red : ColorUtils.textWhite.withValues(
//                                       alpha: controller.selectedFromDate.value != null
//                                           ? 1.0
//                                           : 0.5,
//                                     ),
//                                     fontWeight: FontWeight.w400,
//                                     fontSize: 13.h,
//                                   ),
//                                 ),
//                                 Icon(
//                                   Icons.calendar_today_outlined,
//                                   color: const Color(0xFF9A9A9A).withValues(alpha: 0.6),
//                                   size: 17.h,
//                                 ),
//                               ],
//                             ),
//                           ),
//                           if (isFromError)
//                             Padding(
//                               padding: EdgeInsets.only(left: 10.h, top: 4.h),
//                               child: Text(
//                                 "From date is required",
//                                 style: GoogleFonts.inter(
//                                   color: Colors.red,
//                                   fontWeight: FontWeight.w400,
//                                   fontSize: 11.h,
//                                 ),
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(width: 15.h),
//                     Flexible(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                             height: 54.h,
//                             padding: EdgeInsets.symmetric(horizontal: 15.h),
//                             decoration: BoxDecoration(
//                               color: ColorUtils.foregroundBlack,
//                               borderRadius: BorderRadius.circular(10).r,
//                               border: Border.all(
//                                 color: isToError ? Colors.red : Colors.transparent,
//                                 width: 1.h,
//                               ),
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   controller.selectedToDate.value ?? "To Date *",
//                                   style: GoogleFonts.inter(
//                                     color: isToError ? Colors.red : ColorUtils.textWhite.withValues(
//                                       alpha: controller.selectedToDate.value != null
//                                           ? 1.0
//                                           : 0.5,
//                                     ),
//                                     fontWeight: FontWeight.w400,
//                                     fontSize: 13.h,
//                                   ),
//                                 ),
//                                 Icon(
//                                   Icons.calendar_today_outlined,
//                                   color: const Color(0xFF9A9A9A).withValues(alpha: 0.6),
//                                   size: 17.h,
//                                 ),
//                               ],
//                             ),
//                           ),
//                           if (isToError)
//                             Padding(
//                               padding: EdgeInsets.only(left: 10.h, top: 4.h),
//                               child: Text(
//                                 "To date is required",
//                                 style: GoogleFonts.inter(
//                                   color: Colors.red,
//                                   fontWeight: FontWeight.w400,
//                                   fontSize: 11.h,
//                                 ),
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 );
//               }
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class AttendanceRequest extends StatelessWidget {
//   const AttendanceRequest({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         InkWell(
//           borderRadius: BorderRadius.circular(10).r,
//           onTap: () {
//             DateTime? fromDate;
//             try {
//               fromDate = DateTime.parse(_myRequestController.selectedFromDate.value!);
//             } catch(e) {}
//             Navigator.of(context).push(fadeNavigation(ChooseRequestDatesSingle(
//               showFutureDates: false,
//               selectedDates: LeaveDates(
//                   startDate: fromDate
//               ),
//             )))
//                 .then((value) {
//               if (value != null && value is LeaveDates) {
//                 if (value.startDate != null) {
//                   _myRequestController.selectedFromDate.value =
//                       DateFormat('yyyy-MM-dd').format(value.startDate!);
//                 }
//               }
//             });
//           },
//           child: GetX<MyRequestController>(
//               builder: (MyRequestController controller) {
//                 bool isError = controller.showValidation.value && controller.selectedFromDate.value == null;
//                 return Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 15).h,
//                   height: 54.h,
//                   decoration: BoxDecoration(
//                     color: ColorUtils.foregroundBlack,
//                     borderRadius: BorderRadius.circular(10).r,
//                     border: Border.all(
//                       color: isError ? Colors.red : Colors.transparent,
//                       width: 1.h,
//                     ),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Flexible(
//                         child: Text(
//                           controller.selectedFromDate.value ?? 'Choose Date *',
//                           overflow: TextOverflow.ellipsis,
//                           style: GoogleFonts.inter(
//                             color: isError ? Colors.red : ColorUtils.textWhite.withValues(
//                               alpha: controller.selectedFromDate.value != null
//                                   ? 1.0
//                                   : 0.5,
//                             ),
//                             fontWeight: FontWeight.w400,
//                             fontSize: 13.h,
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 5.h),
//                       Icon(
//                         Icons.calendar_today_outlined,
//                         color: const Color(0xFF9A9A9A).withValues(alpha: 0.6),
//                         size: 17.h,
//                       ),
//                     ],
//                   ),
//                 );
//               }
//           ),
//         ),
//         GetX<MyRequestController>(
//             builder: (MyRequestController controller) {
//               bool isError = controller.showValidation.value && controller.selectedFromDate.value == null;
//               if(isError) {
//                 return Container(
//                   alignment: Alignment.centerLeft,
//                   padding: EdgeInsets.only(left: 15.h, top: 4.h),
//                   child: Text(
//                     "Date is required",
//                     style: GoogleFonts.inter(
//                       color: Colors.red,
//                       fontWeight: FontWeight.w400,
//                       fontSize: 11.h,
//                     ),
//                   ),
//                 );
//               }
//               return const SizedBox.shrink();
//             }
//         ),
//         SizedBox(height: 15.h),
//         GetX<MyRequestController>(
//           builder: (controller) {
//             bool isError = controller.showValidation.value && (controller.selectedDropDown1.value?.trim().isEmpty ?? true);
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Theme(
//                   data: Theme.of(context).copyWith(
//                     splashColor: Colors.transparent,
//                     highlightColor: Colors.transparent,
//                     hoverColor: Colors.transparent,
//                     splashFactory: NoSplash.splashFactory,
//                   ),
//                   child: GestureDetector(
//                     onTap: () {
//                       if(controller.shiftList.value?.isEmpty ?? false) {
//                         AttendanceCommonWidgets().showSnackBar(
//                           context: context,
//                           backgroundColor: Colors.red,
//                           message: 'No shifts available',
//                         );
//                       }
//                     },
//                     child: DropdownButtonHideUnderline(
//                       child: DropdownButton2<String>(
//                         isExpanded: true,
//                         customButton: Container(
//                           width: ScreenUtil().screenWidth,
//                           height: 54.h,
//                           padding: EdgeInsets.only(left: 16.h, right: 10.h),
//                           decoration: BoxDecoration(
//                             color: ColorUtils.foregroundBlack,
//                             borderRadius: BorderRadius.circular(12).r,
//                             border: Border.all(
//                               color: isError
//                                   ? Colors.red
//                                   : ColorUtils.workEntryHead.withValues(alpha: 0.1),
//                             ),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   controller.selectedDropDown1.value ??
//                                       'Choose Shift *',
//                                   overflow: TextOverflow.ellipsis,
//                                   style: GoogleFonts.dmSans(
//                                     fontSize: 14.h,
//                                     color: isError
//                                         ? Colors.red
//                                         : ColorUtils.textWhite.withValues(
//                                       alpha:
//                                       controller.selectedDropDown1.value == null
//                                           ? 0.5
//                                           : 1,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               const Icon(
//                                 Icons.keyboard_arrow_down,
//                                 color: Color(0xFF9A9A9A),
//                               ),
//                             ],
//                           ),
//                         ),
//                         hint: Text(
//                           'Choose Shift',
//                           style: GoogleFonts.poppins(
//                             fontWeight: FontWeight.w400,
//                             fontSize: 14.h,
//                             color: ColorUtils.textWhite.withValues(alpha: 0.5),
//                           ),
//                         ),
//                         items: controller.shiftList.value
//                             .map(
//                               (option) => DropdownMenuItem<String>(
//                             value: option,
//                             child: Text(
//                               option ?? 'Choose Shift',
//                               overflow: TextOverflow.ellipsis,
//                               style: GoogleFonts.dmSans(
//                                 fontSize: 14.h,
//                                 color: ColorUtils.textWhite,
//                               ),
//                             ),
//                           ),
//                         )
//                             .toList(),
//                         value: controller.selectedDropDown1.value,
//                         onChanged: (value) {
//                           controller.selectedDropDown1.value = value;
//                         },
//                         dropdownStyleData: DropdownStyleData(
//                           decoration: BoxDecoration(
//                             color: ColorUtils.foregroundBlack,
//                             borderRadius: BorderRadius.circular(8).r,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 if (isError)
//                   Padding(
//                     padding: EdgeInsets.only(left: 15.h, top: 4.h),
//                     child: Text(
//                       "Shift is required",
//                       style: GoogleFonts.inter(
//                         color: Colors.red,
//                         fontWeight: FontWeight.w400,
//                         fontSize: 11.h,
//                       ),
//                     ),
//                   ),
//               ],
//             );
//           },
//         ),
//         // Container(
//         //   width: ScreenUtil().screenWidth,
//         //   height: 54.h,
//         //   decoration: BoxDecoration(
//         //     color: ColorUtils.foregroundBlack,
//         //     borderRadius: BorderRadius.circular(12).r,
//         //     border: Border.all(
//         //       color: ColorUtils.workEntryHead.withValues(alpha: 0.1),
//         //     ),
//         //   ),
//         //   child: Row(
//         //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         //     crossAxisAlignment: CrossAxisAlignment.center,
//         //     children: [
//         //       Expanded(
//         //         child: GetX<MyRequestController>(
//         //           builder: (MyRequestController controller) {
//         //             return DropdownButtonHideUnderline(
//         //               child: DropdownButton2<String>(
//         //                 isExpanded: true,
//         //                 hint: Text(
//         //                   'Choose Shift',
//         //                   style: GoogleFonts.poppins(
//         //                     fontWeight: FontWeight.w400,
//         //                     fontSize: 14.h,
//         //                     color: ColorUtils.textWhite.withValues(alpha: 0.5),
//         //                   ),
//         //                 ),
//         //                 selectedItemBuilder: (context) {
//         //                   return controller.shiftList.value.map((option) {
//         //                     return Text(
//         //                       option ?? 'Choose Shift',
//         //                       overflow: TextOverflow.ellipsis,
//         //                       style: GoogleFonts.dmSans(
//         //                         fontWeight: FontWeight.w400,
//         //                         fontSize: 14.h,
//         //                         color: ColorUtils.textWhite.withValues(alpha: option == 'Choose Shift' ? 0.5 : 1.0),
//         //                       ),
//         //                     );
//         //                   }).toList();
//         //                 },
//         //                 items: controller.shiftList.value.map(
//         //                       (option) => DropdownMenuItem<String>(
//         //                     value: option,
//         //                     child: Text(
//         //                       option ?? 'Choose Shift',
//         //                       overflow: TextOverflow.ellipsis,
//         //                       style: GoogleFonts.dmSans(
//         //                         fontWeight: FontWeight.w400,
//         //                         fontSize: 14.h,
//         //                         color: ColorUtils.textWhite.withValues(alpha: option == 'Choose Shift' ? 0.5 : 1.0),
//         //                       ),
//         //                     ),
//         //                   ),
//         //                 ).toList(),
//         //                 value: controller.selectedDropDown1.value,
//         //                 onChanged: (selectedValue) async {
//         //                   controller.selectedDropDown1.value = selectedValue;
//         //                 },
//         //                 iconStyleData: IconStyleData(
//         //                   icon: SizedBox.shrink(),
//         //                 ),
//         //                 buttonStyleData: ButtonStyleData(
//         //                   height: 20.h,
//         //                   padding: EdgeInsets.only(right: 16.h),
//         //                   overlayColor: WidgetStateProperty.all(Colors.transparent),
//         //                 ),
//         //                 dropdownStyleData: DropdownStyleData(
//         //                   decoration: BoxDecoration(
//         //                     color: ColorUtils.foregroundBlack,
//         //                     borderRadius: BorderRadius.circular(8).r,
//         //                   ),
//         //                 ),
//         //               ),
//         //             );
//         //           }
//         //         ),
//         //       ),
//         //       const Icon(
//         //         Icons.keyboard_arrow_down,
//         //         color: Color(0xFF9A9A9A),
//         //       ),
//         //       SizedBox(width: 10.h),
//         //     ],
//         //   ),
//         // ),
//         SizedBox(height: 15.h),
//         GetX<MyRequestController>(
//             builder: (MyRequestController controller) {
//               bool isFromTimeError = controller.showValidation.value && controller.selectedFromTime.value == null;
//               bool isToTimeError = controller.showValidation.value && controller.selectedToTime.value == null;
//               return Row(
//                 children: [
//                   Flexible(
//                     child: GestureDetector(
//                       onTap: () {
//                         _showTimePicker(context, 0);
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 15).h,
//                         height: 54.h,
//                         decoration: BoxDecoration(
//                           color: ColorUtils.foregroundBlack,
//                           borderRadius: BorderRadius.circular(10).r,
//                           border: Border.all(
//                             color: isFromTimeError ? Colors.red : Colors.transparent,
//                             width: 1.h,
//                           ),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               controller.selectedFromTime.value ?? 'Check in *',
//                               overflow: TextOverflow.ellipsis,
//                               style: GoogleFonts.inter(
//                                 color: isFromTimeError ? Colors.red : ColorUtils.textWhite.withValues(
//                                   alpha: controller.selectedFromTime.value != null
//                                       ? 1.0
//                                       : 0.5,
//                                 ),
//                                 fontWeight: FontWeight.w400,
//                                 fontSize: 13.h,
//                               ),
//                             ),
//                             SizedBox(width: 5.h),
//                             SvgPicture.asset(
//                               'assets/images/manager_view/edit_att_time.svg',
//                               height: 17.h,
//                               colorFilter: ColorFilter.mode(
//                                 ColorUtils.textWhite.withValues(alpha: 0.5),
//                                 BlendMode.srcIn,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 15.h),
//                   Flexible(
//                     child: GestureDetector(
//                       onTap: () {
//                         _showTimePicker(context, 1);
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 15).h,
//                         height: 54.h,
//                         decoration: BoxDecoration(
//                           color: ColorUtils.foregroundBlack,
//                           borderRadius: BorderRadius.circular(10).r,
//                           border: Border.all(
//                             color: isToTimeError ? Colors.red : Colors.transparent,
//                             width: 1.h,
//                           ),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               controller.selectedToTime.value ?? 'Check out *',
//                               overflow: TextOverflow.ellipsis,
//                               style: GoogleFonts.inter(
//                                 color: isToTimeError ? Colors.red : ColorUtils.textWhite.withValues(
//                                   alpha: controller.selectedToTime.value != null
//                                       ? 1.0
//                                       : 0.5,
//                                 ),
//                                 fontWeight: FontWeight.w400,
//                                 fontSize: 13.h,
//                               ),
//                             ),
//                             SizedBox(width: 5.h),
//                             SvgPicture.asset(
//                               'assets/images/manager_view/edit_att_time.svg',
//                               height: 17.h,
//                               colorFilter: ColorFilter.mode(
//                                 ColorUtils.textWhite.withValues(alpha: 0.5),
//                                 BlendMode.srcIn,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             }
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Flexible(
//               child: GetX<MyRequestController>(
//                   builder: (MyRequestController controller) {
//                     bool isError = controller.showValidation.value && controller.selectedFromTime.value == null;
//                     if(isError) {
//                       return Container(
//                         alignment: Alignment.centerLeft,
//                         padding: EdgeInsets.only(left: 15.h, top: 4.h),
//                         child: Text(
//                           "Check in time is required",
//                           style: GoogleFonts.inter(
//                             color: Colors.red,
//                             fontWeight: FontWeight.w400,
//                             fontSize: 11.h,
//                           ),
//                         ),
//                       );
//                     }
//                     return const SizedBox.shrink();
//                   }
//               ),
//             ),
//             SizedBox(width: 15.h),
//             Flexible(
//               child: GetX<MyRequestController>(
//                   builder: (MyRequestController controller) {
//                     bool isError = controller.showValidation.value && controller.selectedToTime.value == null;
//                     if(isError) {
//                       return Container(
//                         alignment: Alignment.centerLeft,
//                         padding: EdgeInsets.only(left: 15.h, top: 4.h),
//                         child: Text(
//                           "Check out time is required",
//                           style: GoogleFonts.inter(
//                             color: Colors.red,
//                             fontWeight: FontWeight.w400,
//                             fontSize: 11.h,
//                           ),
//                         ),
//                       );
//                     }
//                     return const SizedBox.shrink();
//                   }
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
//
// class ResignationRequest extends StatelessWidget {
//   const ResignationRequest({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         GetX<MyRequestController>(
//           builder: (controller) {
//             return Theme(
//               data: Theme.of(context).copyWith(
//                 splashColor: Colors.transparent,
//                 highlightColor: Colors.transparent,
//                 hoverColor: Colors.transparent,
//                 splashFactory: NoSplash.splashFactory,
//               ),
//               child: GestureDetector(
//                 onTap: () {
//                   if(controller.resignationReasons.value?.isEmpty ?? false) {
//                     AttendanceCommonWidgets().showSnackBar(
//                       context: context,
//                       backgroundColor: Colors.red,
//                       message: 'No reasons available',
//                     );
//                   }
//                 },
//                 child: DropdownButtonHideUnderline(
//                   child: DropdownButton2<String>(
//                     isExpanded: true,
//                     customButton: Container(
//                       width: ScreenUtil().screenWidth,
//                       height: 54.h,
//                       padding: EdgeInsets.only(left: 16.h, right: 10.h),
//                       decoration: BoxDecoration(
//                         color: ColorUtils.foregroundBlack,
//                         borderRadius: BorderRadius.circular(12).r,
//                         border: Border.all(
//                           color: controller.showValidation.value && (controller.selectedDropDown1.value?.trim().isEmpty ?? true)
//                               ? Colors.red
//                               : ColorUtils.workEntryHead.withValues(alpha: 0.1),
//                         ),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: Text(
//                               controller.selectedDropDown1.value ??
//                                   'Choose Reason *',
//                               overflow: TextOverflow.ellipsis,
//                               style: GoogleFonts.dmSans(
//                                 fontSize: 14.h,
//                                 color: controller.showValidation.value && (controller.selectedDropDown1.value?.trim().isEmpty ?? true)
//                                     ? Colors.red
//                                     : ColorUtils.textWhite.withValues(
//                                   alpha:
//                                   controller.selectedDropDown1.value == null
//                                       ? 0.5
//                                       : 1,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const Icon(
//                             Icons.keyboard_arrow_down,
//                             color: Color(0xFF9A9A9A),
//                           ),
//                         ],
//                       ),
//                     ),
//                     hint: Text(
//                       'Choose Reason',
//                       style: GoogleFonts.poppins(
//                         fontWeight: FontWeight.w400,
//                         fontSize: 14.h,
//                         color: ColorUtils.textWhite.withValues(alpha: 0.5),
//                       ),
//                     ),
//                     items: controller.resignationReasons.value
//                         .map(
//                           (option) => DropdownMenuItem<String>(
//                         value: option,
//                         child: Text(
//                           option ?? 'Choose Reason',
//                           overflow: TextOverflow.ellipsis,
//                           style: GoogleFonts.dmSans(
//                             fontSize: 14.h,
//                             color: ColorUtils.textWhite,
//                           ),
//                         ),
//                       ),
//                     )
//                         .toList(),
//                     value: controller.selectedDropDown1.value,
//                     onChanged: (value) {
//                       controller.selectedDropDown1.value = value;
//                     },
//                     dropdownStyleData: DropdownStyleData(
//                       decoration: BoxDecoration(
//                         color: ColorUtils.foregroundBlack,
//                         borderRadius: BorderRadius.circular(8).r,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//         GetX<MyRequestController>(
//             builder: (MyRequestController controller) {
//               bool isError = controller.showValidation.value && (controller.selectedDropDown1.value?.trim().isEmpty ?? true);
//               if(isError) {
//                 return Container(
//                   alignment: Alignment.centerLeft,
//                   padding: EdgeInsets.only(left: 15.h, top: 4.h),
//                   child: Text(
//                     "Description is required",
//                     style: GoogleFonts.inter(
//                       color: Colors.red,
//                       fontWeight: FontWeight.w400,
//                       fontSize: 11.h,
//                     ),
//                   ),
//                 );
//               }
//               return const SizedBox.shrink();
//             }
//         ),
//       ],
//     );
//   }
// }
//
// class SalaryAdvanceRequest extends StatelessWidget {
//   const SalaryAdvanceRequest({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         GetX<MyRequestController>(
//             builder: (MyRequestController controller) {
//               bool isError = controller.showValidation.value && (controller.selectedDropDown1.value?.trim().isEmpty ?? true);
//               return Container(
//                 width: ScreenUtil().screenWidth,
//                 height: 54.h,
//                 decoration: BoxDecoration(
//                   color: ColorUtils.foregroundBlack,
//                   borderRadius: BorderRadius.circular(12).r,
//                   border: Border.all(
//                     color: isError
//                         ? Colors.red
//                         : ColorUtils.workEntryHead.withValues(alpha: 0.1),
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Expanded(
//                       child: DropdownButtonHideUnderline(
//                         child: DropdownButton2<String>(
//                           isExpanded: true,
//                           hint: Text(
//                             'From Which Month *',
//                             style: GoogleFonts.poppins(
//                               fontWeight: FontWeight.w400,
//                               fontSize: 14.h,
//                               color: isError
//                                   ? Colors.red
//                                   : ColorUtils.textWhite.withValues(alpha: 0.5),
//                             ),
//                           ),
//                           selectedItemBuilder: (context) {
//                             return controller.monthString.map((option) {
//                               return Text(
//                                 option ?? 'From Which Month *',
//                                 overflow: TextOverflow.ellipsis,
//                                 style: GoogleFonts.dmSans(
//                                   fontWeight: FontWeight.w400,
//                                   fontSize: 14.h,
//                                   color: isError
//                                       ? Colors.red
//                                       : ColorUtils.textWhite.withValues(
//                                     alpha: option == 'From Which Month' ? 0.5 : 1.0,
//                                   ),
//                                 ),
//                               );
//                             }).toList();
//                           },
//                           items: controller.monthString
//                               .map(
//                                 (option) => DropdownMenuItem<String>(
//                               value: option,
//                               child: Text(
//                                 option ?? 'From Which Month',
//                                 overflow: TextOverflow.ellipsis,
//                                 style: GoogleFonts.dmSans(
//                                   fontWeight: FontWeight.w400,
//                                   fontSize: 14.h,
//                                   color: ColorUtils.textWhite.withValues(
//                                     alpha: option == 'From Which Month'
//                                         ? 0.5
//                                         : 1.0,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           )
//                               .toList(),
//                           value: controller.selectedDropDown1.value,
//                           onChanged: (selectedValue) {
//                             controller.selectedDropDown1.value = selectedValue;
//                           },
//                           iconStyleData: IconStyleData(icon: SizedBox.shrink()),
//                           buttonStyleData: ButtonStyleData(
//                             height: 20.h,
//                             padding: EdgeInsets.only(right: 16.h),
//                             overlayColor: WidgetStateProperty.all(Colors.transparent),
//                           ),
//                           dropdownStyleData: DropdownStyleData(
//                             decoration: BoxDecoration(
//                               color: ColorUtils.foregroundBlack,
//                               borderRadius: BorderRadius.circular(8).r,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const Icon(Icons.keyboard_arrow_down, color: Color(0xFF9A9A9A)),
//                     SizedBox(width: 10.h),
//                   ],
//                 ),
//               );
//             }
//         ),
//         GetX<MyRequestController>(
//             builder: (MyRequestController controller) {
//               bool isError = controller.showValidation.value && (controller.selectedDropDown1.value?.trim().isEmpty ?? true);
//               if(isError) {
//                 return Container(
//                   alignment: Alignment.centerLeft,
//                   padding: EdgeInsets.only(left: 15.h, top: 4.h),
//                   child: Text(
//                     "Month is required",
//                     style: GoogleFonts.inter(
//                       color: Colors.red,
//                       fontWeight: FontWeight.w400,
//                       fontSize: 11.h,
//                     ),
//                   ),
//                 );
//               }
//               return const SizedBox.shrink();
//             }
//         ),
//         SizedBox(height: 15.h),
//         GetX<MyRequestController>(
//             builder: (MyRequestController controller) {
//               bool isError = controller.showValidation.value && (controller.selectedText1.value?.trim().isEmpty ?? true);
//               return Container(
//                 width: ScreenUtil().screenWidth,
//                 height: 54.h,
//                 padding: EdgeInsets.symmetric(horizontal: 15.h),
//                 decoration: BoxDecoration(
//                   color: ColorUtils.foregroundBlack,
//                   borderRadius: BorderRadius.circular(12).r,
//                   border: Border.all(
//                     color: isError
//                         ? Colors.red
//                         : ColorUtils.workEntryHead.withValues(alpha: 0.1),
//                   ),
//                 ),
//                 child: TextField(
//                   keyboardType: TextInputType.number,
//                   onChanged: (value) {
//                     _myRequestController.selectedText1.value = value;
//                   },
//                   style: GoogleFonts.inter(
//                     color: ColorUtils.textWhite,
//                     fontWeight: FontWeight.w500,
//                     fontSize: 15.h,
//                   ),
//                   decoration: InputDecoration(
//                     hintText: "Enter Amount *",
//                     contentPadding: EdgeInsets.symmetric(vertical: 15.h),
//                     border: const OutlineInputBorder(borderSide: BorderSide.none),
//                     hintStyle: GoogleFonts.inter(
//                       color: isError ? Colors.red : const Color(0xFFAAAAAA).withValues(alpha: 0.7),
//                       fontWeight: FontWeight.w400,
//                       fontSize: 15.h,
//                       letterSpacing: -0.3,
//                     ),
//                   ),
//                   maxLines: 1,
//                 ),
//               );
//             }
//         ),
//         GetX<MyRequestController>(
//             builder: (MyRequestController controller) {
//               bool isError = controller.showValidation.value && (controller.selectedText1.value?.trim().isEmpty ?? true);
//               if(isError) {
//                 return Container(
//                   alignment: Alignment.centerLeft,
//                   padding: EdgeInsets.only(left: 15.h, top: 4.h),
//                   child: Text(
//                     "Amount is required",
//                     style: GoogleFonts.inter(
//                       color: Colors.red,
//                       fontWeight: FontWeight.w400,
//                       fontSize: 11.h,
//                     ),
//                   ),
//                 );
//               }
//               return const SizedBox.shrink();
//             }
//         ),
//       ],
//     );
//   }
// }
//
// class LoanRequest extends StatelessWidget {
//   const LoanRequest({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         GetX<MyRequestController>(
//           builder: (controller) {
//             return Theme(
//               data: Theme.of(context).copyWith(
//                 splashColor: Colors.transparent,
//                 highlightColor: Colors.transparent,
//                 hoverColor: Colors.transparent,
//                 splashFactory: NoSplash.splashFactory,
//               ),
//               child: GestureDetector(
//                 onTap: () {
//                   if(controller.loanPolicyNames.value?.isEmpty ?? false) {
//                     AttendanceCommonWidgets().showSnackBar(
//                       context: context,
//                       backgroundColor: Colors.red,
//                       message: 'No loan types fount',
//                     );
//                   }
//                 },
//                 child: DropdownButtonHideUnderline(
//                   child: DropdownButton2<String>(
//                     isExpanded: true,
//                     customButton: Container(
//                       width: ScreenUtil().screenWidth,
//                       height: 54.h,
//                       padding: EdgeInsets.only(left: 16.h, right: 10.h),
//                       decoration: BoxDecoration(
//                         color: ColorUtils.foregroundBlack,
//                         borderRadius: BorderRadius.circular(12).r,
//                         border: Border.all(
//                           color: controller.showValidation.value && (controller.selectedDropDown1.value?.trim().isEmpty ?? true)
//                               ? Colors.red
//                               : ColorUtils.workEntryHead.withValues(alpha: 0.1),
//                         ),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: Text(
//                               controller.selectedDropDown1.value ??
//                                   'Which Type of Loan *',
//                               overflow: TextOverflow.ellipsis,
//                               style: GoogleFonts.dmSans(
//                                 fontSize: 14.h,
//                                 color: controller.showValidation.value && (controller.selectedDropDown1.value?.trim().isEmpty ?? true)
//                                     ? Colors.red
//                                     : ColorUtils.textWhite.withValues(
//                                   alpha:
//                                   controller.selectedDropDown1.value == null
//                                       ? 0.5
//                                       : 1,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const Icon(
//                             Icons.keyboard_arrow_down,
//                             color: Color(0xFF9A9A9A),
//                           ),
//                         ],
//                       ),
//                     ),
//                     hint: Text(
//                       'Which Type of Loan',
//                       style: GoogleFonts.poppins(
//                         fontWeight: FontWeight.w400,
//                         fontSize: 14.h,
//                         color: ColorUtils.textWhite.withValues(alpha: 0.5),
//                       ),
//                     ),
//                     items: controller.loanPolicyNames.value
//                         .map(
//                           (option) => DropdownMenuItem<String>(
//                         value: option,
//                         child: Text(
//                           option ?? 'Which Type of Loan',
//                           overflow: TextOverflow.ellipsis,
//                           style: GoogleFonts.dmSans(
//                             fontSize: 14.h,
//                             color: ColorUtils.textWhite,
//                           ),
//                         ),
//                       ),
//                     )
//                         .toList(),
//                     value: controller.selectedDropDown1.value,
//                     onChanged: (value) {
//                       controller.selectedDropDown1.value = value;
//                       if(value == null) return;
//                       controller.selectPolicy(value: value);
//                     },
//                     dropdownStyleData: DropdownStyleData(
//                       decoration: BoxDecoration(
//                         color: ColorUtils.foregroundBlack,
//                         borderRadius: BorderRadius.circular(8).r,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//         GetX<MyRequestController>(
//             builder: (MyRequestController controller) {
//               bool isError = controller.showValidation.value && (controller.selectedDropDown1.value?.trim().isEmpty ?? true);
//               if(isError) {
//                 return Container(
//                   alignment: Alignment.centerLeft,
//                   padding: EdgeInsets.only(left: 15.h, top: 4.h),
//                   child: Text(
//                     "Loan type is required",
//                     style: GoogleFonts.inter(
//                       color: Colors.red,
//                       fontWeight: FontWeight.w400,
//                       fontSize: 11.h,
//                     ),
//                   ),
//                 );
//               }
//               return const SizedBox.shrink();
//             }
//         ),
//         SizedBox(height: 15.h),
//         GetX<MyRequestController>(
//             builder: (MyRequestController controller) {
//               bool isError = controller.showValidation.value && (controller.selectedText1.value?.trim().isEmpty ?? true);
//               return Container(
//                 width: ScreenUtil().screenWidth,
//                 height: 54.h,
//                 padding: EdgeInsets.symmetric(horizontal: 15.h),
//                 decoration: BoxDecoration(
//                   color: ColorUtils.foregroundBlack,
//                   borderRadius: BorderRadius.circular(12).r,
//                   border: Border.all(
//                     color: isError
//                         ? Colors.red
//                         : ColorUtils.workEntryHead.withValues(alpha: 0.1),
//                   ),
//                 ),
//                 child: TextField(
//                   keyboardType: TextInputType.number,
//                   style: GoogleFonts.inter(
//                     color: ColorUtils.textWhite,
//                     fontWeight: FontWeight.w500,
//                     fontSize: 15.h,
//                   ),
//                   onChanged: (value) {
//                     _myRequestController.selectedText1.value = value;
//                   },
//                   decoration: InputDecoration(
//                     hintText: "Enter Amount *",
//                     contentPadding: EdgeInsets.symmetric(vertical: 15.h),
//                     border: const OutlineInputBorder(borderSide: BorderSide.none),
//                     hintStyle: GoogleFonts.inter(
//                       color: isError ? Colors.red : const Color(0xFFAAAAAA).withValues(alpha: 0.7),
//                       fontWeight: FontWeight.w400,
//                       fontSize: 15.h,
//                       letterSpacing: -0.3,
//                     ),
//                   ),
//                   maxLines: 1,
//                 ),
//               );
//             }
//         ),
//         GetX<MyRequestController>(
//             builder: (MyRequestController controller) {
//               bool isError = controller.showValidation.value && (controller.selectedText1.value?.trim().isEmpty ?? true);
//               if(isError) {
//                 return Container(
//                   alignment: Alignment.centerLeft,
//                   padding: EdgeInsets.only(left: 15.h, top: 4.h),
//                   child: Text(
//                     "Amount is required",
//                     style: GoogleFonts.inter(
//                       color: Colors.red,
//                       fontWeight: FontWeight.w400,
//                       fontSize: 11.h,
//                     ),
//                   ),
//                 );
//               }
//               return const SizedBox.shrink();
//             }
//         ),
//         SizedBox(height: 15.h),
//         GetX<MyRequestController>(
//           builder: (controller) {
//             bool isError = controller.showValidation.value && (controller.selectedDropDown2.value?.trim().isEmpty ?? true);
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Theme(
//                   data: Theme.of(context).copyWith(
//                     splashColor: Colors.transparent,
//                     highlightColor: Colors.transparent,
//                     hoverColor: Colors.transparent,
//                     splashFactory: NoSplash.splashFactory,
//                   ),
//                   child: DropdownButtonHideUnderline(
//                     child: DropdownButton2<String>(
//                       isExpanded: true,
//                       customButton: Container(
//                         width: ScreenUtil().screenWidth,
//                         height: 54.h,
//                         padding: EdgeInsets.only(left: 16.h, right: 10.h),
//                         decoration: BoxDecoration(
//                           color: ColorUtils.foregroundBlack,
//                           borderRadius: BorderRadius.circular(12).r,
//                           border: Border.all(
//                             color: isError
//                                 ? Colors.red
//                                 : ColorUtils.workEntryHead.withValues(alpha: 0.1),
//                           ),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Expanded(
//                               child: Text(
//                                 controller.selectedDropDown2.value ??
//                                     'Tenure *',
//                                 overflow: TextOverflow.ellipsis,
//                                 style: GoogleFonts.dmSans(
//                                   fontSize: 14.h,
//                                   color: isError
//                                       ? Colors.red
//                                       : ColorUtils.textWhite.withValues(
//                                     alpha:
//                                     controller.selectedDropDown2.value == null
//                                         ? 0.5
//                                         : 1,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             const Icon(
//                               Icons.keyboard_arrow_down,
//                               color: Color(0xFF9A9A9A),
//                             ),
//                           ],
//                         ),
//                       ),
//                       hint: Text(
//                         'Tenure',
//                         style: GoogleFonts.poppins(
//                           fontWeight: FontWeight.w400,
//                           fontSize: 14.h,
//                           color: ColorUtils.textWhite.withValues(alpha: 0.5),
//                         ),
//                       ),
//                       items: controller.tenureMonths.value
//                           .map(
//                             (option) => DropdownMenuItem<String>(
//                           value: option,
//                           child: Text(
//                             option ?? 'Tenure',
//                             overflow: TextOverflow.ellipsis,
//                             style: GoogleFonts.dmSans(
//                               fontSize: 14.h,
//                               color: ColorUtils.textWhite,
//                             ),
//                           ),
//                         ),
//                       )
//                           .toList(),
//                       value: controller.selectedDropDown2.value,
//                       onChanged: (value) {
//                         controller.selectedDropDown2.value = value;
//                       },
//                       dropdownStyleData: DropdownStyleData(
//                         decoration: BoxDecoration(
//                           color: ColorUtils.foregroundBlack,
//                           borderRadius: BorderRadius.circular(8).r,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 if (isError)
//                   Padding(
//                     padding: EdgeInsets.only(left: 15.h, top: 4.h),
//                     child: Text(
//                       "Tenure is required",
//                       style: GoogleFonts.inter(
//                         color: Colors.red,
//                         fontWeight: FontWeight.w400,
//                         fontSize: 11.h,
//                       ),
//                     ),
//                   ),
//               ],
//             );
//           },
//         ),
//       ],
//     );
//   }
// }
//
// class ItRequest extends StatelessWidget {
//   const ItRequest({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         GetX<MyRequestController>(
//           builder: (controller) {
//             return Theme(
//               data: Theme.of(context).copyWith(
//                 splashColor: Colors.transparent,
//                 highlightColor: Colors.transparent,
//                 hoverColor: Colors.transparent,
//                 splashFactory: NoSplash.splashFactory,
//               ),
//               child: GestureDetector(
//                 onTap: () {
//                   if(controller.itRequestTypes.value?.isEmpty ?? false) {
//                     AttendanceCommonWidgets().showSnackBar(
//                       context: context,
//                       backgroundColor: Colors.red,
//                       message: 'Request types not available',
//                     );
//                   }
//                 },
//                 child: DropdownButtonHideUnderline(
//                   child: DropdownButton2<String>(
//                     isExpanded: true,
//                     customButton: Container(
//                       width: ScreenUtil().screenWidth,
//                       height: 54.h,
//                       padding: EdgeInsets.only(left: 16.h, right: 10.h),
//                       decoration: BoxDecoration(
//                         color: ColorUtils.foregroundBlack,
//                         borderRadius: BorderRadius.circular(12).r,
//                         border: Border.all(
//                           color: controller.showValidation.value && (controller.selectedDropDown1.value?.trim().isEmpty ?? true)
//                               ? Colors.red
//                               : ColorUtils.workEntryHead.withValues(alpha: 0.1),
//                         ),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: Text(
//                               controller.selectedDropDown1.value ??
//                                   'Choose Types *',
//                               overflow: TextOverflow.ellipsis,
//                               style: GoogleFonts.dmSans(
//                                 fontSize: 14.h,
//                                 color: controller.showValidation.value && (controller.selectedDropDown1.value?.trim().isEmpty ?? true)
//                                     ? Colors.red
//                                     : ColorUtils.textWhite.withValues(
//                                   alpha:
//                                   controller.selectedDropDown1.value == null
//                                       ? 0.5
//                                       : 1,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const Icon(
//                             Icons.keyboard_arrow_down,
//                             color: Color(0xFF9A9A9A),
//                           ),
//                         ],
//                       ),
//                     ),
//                     hint: Text(
//                       'Choose Types',
//                       style: GoogleFonts.poppins(
//                         fontWeight: FontWeight.w400,
//                         fontSize: 14.h,
//                         color: ColorUtils.textWhite.withValues(alpha: 0.5),
//                       ),
//                     ),
//                     items: controller.itRequestTypes.value
//                         .map(
//                           (option) => DropdownMenuItem<String>(
//                         value: option,
//                         child: Text(
//                           option ?? 'Choose Types',
//                           overflow: TextOverflow.ellipsis,
//                           style: GoogleFonts.dmSans(
//                             fontSize: 14.h,
//                             color: ColorUtils.textWhite,
//                           ),
//                         ),
//                       ),
//                     )
//                         .toList(),
//                     value: controller.selectedDropDown1.value,
//                     onChanged: (value) {
//                       controller.selectedDropDown1.value = value;
//                     },
//                     dropdownStyleData: DropdownStyleData(
//                       decoration: BoxDecoration(
//                         color: ColorUtils.foregroundBlack,
//                         borderRadius: BorderRadius.circular(8).r,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//         GetX<MyRequestController>(
//             builder: (MyRequestController controller) {
//               bool isError = controller.showValidation.value && (controller.selectedDropDown1.value?.trim().isEmpty ?? true);
//               if(isError) {
//                 return Container(
//                   alignment: Alignment.centerLeft,
//                   padding: EdgeInsets.only(left: 15.h, top: 4.h),
//                   child: Text(
//                     "Type is required",
//                     style: GoogleFonts.inter(
//                       color: Colors.red,
//                       fontWeight: FontWeight.w400,
//                       fontSize: 11.h,
//                     ),
//                   ),
//                 );
//               }
//               return const SizedBox.shrink();
//             }
//         ),
//         SizedBox(height: 15.h),
//         GetX<MyRequestController>(
//             builder: (MyRequestController controller) {
//               bool isError = controller.showValidation.value && (controller.selectedText1.value?.trim().isEmpty ?? true);
//               return Container(
//                 width: ScreenUtil().screenWidth,
//                 height: 54.h,
//                 padding: EdgeInsets.symmetric(horizontal: 15.h),
//                 decoration: BoxDecoration(
//                   color: ColorUtils.foregroundBlack,
//                   borderRadius: BorderRadius.circular(12).r,
//                   border: Border.all(
//                     color: isError
//                         ? Colors.red
//                         : ColorUtils.workEntryHead.withValues(alpha: 0.1),
//                   ),
//                 ),
//                 child: TextField(
//                   style: GoogleFonts.inter(
//                     color: ColorUtils.textWhite,
//                     fontWeight: FontWeight.w500,
//                     fontSize: 15.h,
//                   ),
//                   onChanged: (value) {
//                     _myRequestController.selectedText1.value = value;
//                   },
//                   decoration: InputDecoration(
//                     hintText: "Location or Entity *",
//                     contentPadding: EdgeInsets.symmetric(vertical: 15.h),
//                     border: const OutlineInputBorder(borderSide: BorderSide.none),
//                     hintStyle: GoogleFonts.inter(
//                       color: isError ? Colors.red : const Color(0xFFAAAAAA).withValues(alpha: 0.7),
//                       fontWeight: FontWeight.w400,
//                       fontSize: 15.h,
//                       letterSpacing: -0.3,
//                     ),
//                   ),
//                   maxLines: 5,
//                 ),
//               );
//             }
//         ),
//         GetX<MyRequestController>(
//             builder: (MyRequestController controller) {
//               bool isError = controller.showValidation.value && (controller.selectedText1.value?.trim().isEmpty ?? true);
//               if(isError) {
//                 return Container(
//                   alignment: Alignment.centerLeft,
//                   padding: EdgeInsets.only(left: 15.h, top: 4.h),
//                   child: Text(
//                     "Location or Entity is required",
//                     style: GoogleFonts.inter(
//                       color: Colors.red,
//                       fontWeight: FontWeight.w400,
//                       fontSize: 11.h,
//                     ),
//                   ),
//                 );
//               }
//               return const SizedBox.shrink();
//             }
//         ),
//         SizedBox(height: 15.h),
//         GetX<MyRequestController>(
//             builder: (MyRequestController controller) {
//               bool isError = controller.showValidation.value && (controller.selectedText2.value?.trim().isEmpty ?? true);
//               return Container(
//                 width: ScreenUtil().screenWidth,
//                 height: 54.h,
//                 padding: EdgeInsets.symmetric(horizontal: 15.h),
//                 decoration: BoxDecoration(
//                   color: ColorUtils.foregroundBlack,
//                   borderRadius: BorderRadius.circular(12).r,
//                   border: Border.all(
//                     color: isError
//                         ? Colors.red
//                         : ColorUtils.workEntryHead.withValues(alpha: 0.1),
//                   ),
//                 ),
//                 child: TextField(
//                   style: GoogleFonts.inter(
//                     color: ColorUtils.textWhite,
//                     fontWeight: FontWeight.w500,
//                     fontSize: 15.h,
//                   ),
//                   onChanged: (value) {
//                     _myRequestController.selectedText2.value = value;
//                   },
//                   decoration: InputDecoration(
//                     hintText: "Title *",
//                     contentPadding: EdgeInsets.symmetric(vertical: 15.h),
//                     border: const OutlineInputBorder(borderSide: BorderSide.none),
//                     hintStyle: GoogleFonts.inter(
//                       color: isError ? Colors.red : const Color(0xFFAAAAAA).withValues(alpha: 0.7),
//                       fontWeight: FontWeight.w400,
//                       fontSize: 15.h,
//                       letterSpacing: -0.3,
//                     ),
//                   ),
//                   maxLines: 5,
//                 ),
//               );
//             }
//         ),
//         GetX<MyRequestController>(
//             builder: (MyRequestController controller) {
//               bool isError = controller.showValidation.value && (controller.selectedText2.value?.trim().isEmpty ?? true);
//               if(isError) {
//                 return Container(
//                   alignment: Alignment.centerLeft,
//                   padding: EdgeInsets.only(left: 15.h, top: 4.h),
//                   child: Text(
//                     "Title is required",
//                     style: GoogleFonts.inter(
//                       color: Colors.red,
//                       fontWeight: FontWeight.w400,
//                       fontSize: 11.h,
//                     ),
//                   ),
//                 );
//               }
//               return const SizedBox.shrink();
//             }
//         ),
//         SizedBox(height: 15.h),
//         GetX<MyRequestController>(
//             builder: (MyRequestController controller) {
//               bool isError = controller.showValidation.value && (controller.reasonText.value?.trim().isEmpty ?? true);
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     height: 172.h,
//                     width: ScreenUtil().screenWidth,
//                     padding: const EdgeInsets.all(15).h,
//                     decoration: BoxDecoration(
//                       color: ColorUtils.foregroundBlack,
//                       borderRadius: BorderRadius.circular(15).r,
//                       border: Border.all(
//                         color: isError ? Colors.red : Colors.transparent,
//                         width: 1.h,
//                       ),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Description *",
//                           style: GoogleFonts.inter(
//                             color: isError ? Colors.red : const Color(0xFFAAAAAA).withValues(alpha: 0.7),
//                             fontWeight: FontWeight.w400,
//                             fontSize: 13.h,
//                           ),
//                         ),
//                         TextField(
//                           style: GoogleFonts.inter(
//                             color: ColorUtils.textWhite,
//                             fontWeight: FontWeight.w500,
//                             fontSize: 15.h,
//                           ),
//                           onChanged: (value) {
//                             _myRequestController.reasonText.value = value;
//                           },
//                           decoration: InputDecoration(
//                             hintText: "Type here...",
//                             contentPadding: EdgeInsets.zero,
//                             border: const OutlineInputBorder(borderSide: BorderSide.none),
//                             hintStyle: GoogleFonts.inter(
//                               color: isError ? Colors.red : const Color(0xFFAAAAAA).withValues(alpha: 0.7),
//                               fontWeight: FontWeight.w400,
//                               fontSize: 12.h,
//                               letterSpacing: -0.3,
//                             ),
//                           ),
//                           maxLines: 5,
//                         ),
//                       ],
//                     ),
//                   ),
//                   if (isError)
//                     Padding(
//                       padding: EdgeInsets.only(left: 15.h, top: 4.h),
//                       child: Text(
//                         "Description is required",
//                         style: GoogleFonts.inter(
//                           color: Colors.red,
//                           fontWeight: FontWeight.w400,
//                           fontSize: 11.h,
//                         ),
//                       ),
//                     ),
//                 ],
//               );
//             }
//         ),
//         SizedBox(height: 15.h),
//         Padding(
//           padding: EdgeInsets.all(10.h),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Attachments",
//                     style: GoogleFonts.inter(
//                       fontWeight: FontWeight.w400,
//                       fontSize: 13.h,
//                       color: const Color(0xFFAAAAAA),
//                     ),
//                   ),
//                   SizedBox(height: 4.h),
//                   Text(
//                     "Max 1 File (Optional)",
//                     style: GoogleFonts.inter(
//                       fontWeight: FontWeight.w400,
//                       fontSize: 13.h,
//                       color: const Color(0xFF414046),
//                     ),
//                   ),
//                 ],
//               ),
//               GestureDetector(
//                 onTap: () {
//                   attachBottomSheetShow(context, false);
//                 },
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 20,
//                     vertical: 8,
//                   ).h,
//                   decoration: BoxDecoration(
//                     color: ColorUtils.foregroundBlack,
//                     borderRadius: BorderRadius.circular(23).r,
//                   ),
//                   child: Row(
//                     children: [
//                       SvgPicture.asset(
//                         "assets/images/attach_icon.svg",
//                         height: 17.h,
//                       ),
//                       SizedBox(width: 12.h),
//                       Text(
//                         "Add",
//                         style: GoogleFonts.poppins(
//                           fontWeight: FontWeight.w500,
//                           fontSize: 12.h,
//                           color: ColorUtils.textWhite,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         SizedBox(height: 15.h),
//         GetX<MyRequestController>(
//             builder: (MyRequestController controller) {
//               return Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   for(int i = 0; i < controller.selectedFiles.value.length; i++)
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9).h,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8).h,
//                         decoration: BoxDecoration(
//                           color: ColorUtils.foregroundBlack,
//                           borderRadius: BorderRadius.circular(12).r,
//                         ),
//                         child: Row(
//                           // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 InkWell(
//                                   onTap: () {
//                                     controller.selectedFiles.value.removeAt(i);
//                                     controller.selectedFiles.refresh();
//                                   },
//                                   child: const Icon(
//                                     Icons.close,
//                                     color: ColorUtils.textWhite,
//                                   ),
//                                 ),
//                                 SizedBox(width: 10.h),
//                                 Image.file(
//                                   File(controller.selectedFiles[i]),
//                                   height: 60.h,
//                                   width: 80.h,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ],
//                             ),
//                             SizedBox(width: 10.h),
//                             SizedBox(
//                               width: 150.h,
//                               child: Text(
//                                 controller.selectedFiles[i].split("/").last,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: GoogleFonts.poppins(
//                                   fontWeight: FontWeight.w500,
//                                   fontSize: 12.h,
//                                   color: ColorUtils.textWhite,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                 ],
//               );
//             }
//         )
//       ],
//     );
//   }
// }
//
// class WorkPlaceRelatedRequest extends StatelessWidget {
//   const WorkPlaceRelatedRequest({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         GetX<MyRequestController>(
//           builder: (controller) {
//             bool isError = controller.showValidation.value && (controller.selectedDropDown1.value?.trim().isEmpty ?? true);
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Theme(
//                   data: Theme.of(context).copyWith(
//                     splashColor: Colors.transparent,
//                     highlightColor: Colors.transparent,
//                     hoverColor: Colors.transparent,
//                     splashFactory: NoSplash.splashFactory,
//                   ),
//                   child: GestureDetector(
//                     onTap: () {
//                       if(controller.workPlaceRequestTypes.value?.isEmpty ?? false) {
//                         AttendanceCommonWidgets().showSnackBar(
//                           context: context,
//                           backgroundColor: Colors.red,
//                           message: 'Request types not available',
//                         );
//                       }
//                     },
//                     child: DropdownButtonHideUnderline(
//                       child: DropdownButton2<String>(
//                         isExpanded: true,
//                         customButton: Container(
//                           width: ScreenUtil().screenWidth,
//                           height: 54.h,
//                           padding: EdgeInsets.only(left: 16.h, right: 10.h),
//                           decoration: BoxDecoration(
//                             color: ColorUtils.foregroundBlack,
//                             borderRadius: BorderRadius.circular(12).r,
//                             border: Border.all(
//                               color: isError
//                                   ? Colors.red
//                                   : ColorUtils.workEntryHead.withValues(alpha: 0.1),
//                             ),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   controller.selectedDropDown1.value ??
//                                       'Choose Types *',
//                                   overflow: TextOverflow.ellipsis,
//                                   style: GoogleFonts.dmSans(
//                                     fontSize: 14.h,
//                                     color: isError
//                                         ? Colors.red
//                                         : ColorUtils.textWhite.withValues(
//                                       alpha:
//                                       controller.selectedDropDown1.value == null
//                                           ? 0.5
//                                           : 1,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               const Icon(
//                                 Icons.keyboard_arrow_down,
//                                 color: Color(0xFF9A9A9A),
//                               ),
//                             ],
//                           ),
//                         ),
//                         hint: Text(
//                           'Choose Types',
//                           style: GoogleFonts.poppins(
//                             fontWeight: FontWeight.w400,
//                             fontSize: 14.h,
//                             color: ColorUtils.textWhite.withValues(alpha: 0.5),
//                           ),
//                         ),
//                         items: controller.workPlaceRequestTypes.value
//                             .map(
//                               (option) => DropdownMenuItem<String>(
//                             value: option,
//                             child: Text(
//                               option ?? 'Choose Types',
//                               overflow: TextOverflow.ellipsis,
//                               style: GoogleFonts.dmSans(
//                                 fontSize: 14.h,
//                                 color: ColorUtils.textWhite,
//                               ),
//                             ),
//                           ),
//                         )
//                             .toList(),
//                         value: controller.selectedDropDown1.value,
//                         onChanged: (value) {
//                           controller.selectedDropDown1.value = value;
//                         },
//                         dropdownStyleData: DropdownStyleData(
//                           decoration: BoxDecoration(
//                             color: ColorUtils.foregroundBlack,
//                             borderRadius: BorderRadius.circular(8).r,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 if (isError)
//                   Padding(
//                     padding: EdgeInsets.only(left: 15.h, top: 4.h),
//                     child: Text(
//                       "Type is required",
//                       style: GoogleFonts.inter(
//                         color: Colors.red,
//                         fontWeight: FontWeight.w400,
//                         fontSize: 11.h,
//                       ),
//                     ),
//                   ),
//               ],
//             );
//           },
//         ),
//         SizedBox(height: 15.h),
//         GetX<MyRequestController>(
//             builder: (MyRequestController controller) {
//               bool isError = controller.showValidation.value && (controller.selectedText1.value?.trim().isEmpty ?? true);
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     width: ScreenUtil().screenWidth,
//                     height: 54.h,
//                     padding: EdgeInsets.symmetric(horizontal: 15.h),
//                     decoration: BoxDecoration(
//                       color: ColorUtils.foregroundBlack,
//                       borderRadius: BorderRadius.circular(12).r,
//                       border: Border.all(
//                         color: isError
//                             ? Colors.red
//                             : ColorUtils.workEntryHead.withValues(alpha: 0.1),
//                       ),
//                     ),
//                     child: TextField(
//                       style: GoogleFonts.inter(
//                         color: ColorUtils.textWhite,
//                         fontWeight: FontWeight.w500,
//                         fontSize: 15.h,
//                       ),
//                       onChanged: (value) {
//                         _myRequestController.selectedText1.value = value;
//                       },
//                       decoration: InputDecoration(
//                         hintText: "Location *",
//                         contentPadding: EdgeInsets.symmetric(vertical: 15.h),
//                         border: const OutlineInputBorder(borderSide: BorderSide.none),
//                         hintStyle: GoogleFonts.inter(
//                           color: isError ? Colors.red : const Color(0xFFAAAAAA).withValues(alpha: 0.7),
//                           fontWeight: FontWeight.w400,
//                           fontSize: 15.h,
//                           letterSpacing: -0.3,
//                         ),
//                       ),
//                       maxLines: 5,
//                     ),
//                   ),
//                   if (isError)
//                     Padding(
//                       padding: EdgeInsets.only(left: 15.h, top: 4.h),
//                       child: Text(
//                         "Location is required",
//                         style: GoogleFonts.inter(
//                           color: Colors.red,
//                           fontWeight: FontWeight.w400,
//                           fontSize: 11.h,
//                         ),
//                       ),
//                     ),
//                 ],
//               );
//             }
//         ),
//         SizedBox(height: 15.h),
//         GetX<MyRequestController>(
//             builder: (MyRequestController controller) {
//               bool isError = controller.showValidation.value && (controller.reasonText.value?.trim().isEmpty ?? true);
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     height: 172.h,
//                     width: ScreenUtil().screenWidth,
//                     padding: const EdgeInsets.all(15).h,
//                     decoration: BoxDecoration(
//                       color: ColorUtils.foregroundBlack,
//                       borderRadius: BorderRadius.circular(15).r,
//                       border: Border.all(
//                         color: isError ? Colors.red : Colors.transparent,
//                         width: 1.h,
//                       ),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Description *",
//                           style: GoogleFonts.inter(
//                             color: isError ? Colors.red : const Color(0xFFAAAAAA).withValues(alpha: 0.7),
//                             fontWeight: FontWeight.w400,
//                             fontSize: 13.h,
//                           ),
//                         ),
//                         TextField(
//                           style: GoogleFonts.inter(
//                             color: ColorUtils.textWhite,
//                             fontWeight: FontWeight.w500,
//                             fontSize: 15.h,
//                           ),
//                           onChanged: (value) {
//                             _myRequestController.reasonText.value = value;
//                           },
//                           decoration: InputDecoration(
//                             hintText: "Type here...",
//                             contentPadding: EdgeInsets.zero,
//                             border: const OutlineInputBorder(borderSide: BorderSide.none),
//                             hintStyle: GoogleFonts.inter(
//                               color: isError ? Colors.red : const Color(0xFFAAAAAA).withValues(alpha: 0.7),
//                               fontWeight: FontWeight.w400,
//                               fontSize: 12.h,
//                               letterSpacing: -0.3,
//                             ),
//                           ),
//                           maxLines: 5,
//                         ),
//                       ],
//                     ),
//                   ),
//                   if (isError)
//                     Padding(
//                       padding: EdgeInsets.only(left: 15.h, top: 4.h),
//                       child: Text(
//                         "Description is required",
//                         style: GoogleFonts.inter(
//                           color: Colors.red,
//                           fontWeight: FontWeight.w400,
//                           fontSize: 11.h,
//                         ),
//                       ),
//                     ),
//                 ],
//               );
//             }
//         ),
//         SizedBox(height: 15.h),
//         Padding(
//           padding: EdgeInsets.all(10.h),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Attachments",
//                     style: GoogleFonts.inter(
//                       fontWeight: FontWeight.w400,
//                       fontSize: 13.h,
//                       color: const Color(0xFFAAAAAA),
//                     ),
//                   ),
//                   SizedBox(height: 4.h),
//                   Text(
//                     "Max 1 File (Optional)",
//                     style: GoogleFonts.inter(
//                       fontWeight: FontWeight.w400,
//                       fontSize: 13.h,
//                       color: const Color(0xFF414046),
//                     ),
//                   ),
//                 ],
//               ),
//               GestureDetector(
//                 onTap: () {
//                   attachBottomSheetShow(context, false);
//                 },
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 20,
//                     vertical: 8,
//                   ).h,
//                   decoration: BoxDecoration(
//                     color: ColorUtils.foregroundBlack,
//                     borderRadius: BorderRadius.circular(23).r,
//                   ),
//                   child: Row(
//                     children: [
//                       SvgPicture.asset(
//                         "assets/images/attach_icon.svg",
//                         height: 17.h,
//                       ),
//                       SizedBox(width: 12.h),
//                       Text(
//                         "Add",
//                         style: GoogleFonts.poppins(
//                           fontWeight: FontWeight.w500,
//                           fontSize: 12.h,
//                           color: ColorUtils.textWhite,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         SizedBox(height: 15.h),
//         GetX<MyRequestController>(
//             builder: (MyRequestController controller) {
//               return Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   for(int i = 0; i < controller.selectedFiles.value.length; i++)
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9).h,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8).h,
//                         decoration: BoxDecoration(
//                           color: ColorUtils.foregroundBlack,
//                           borderRadius: BorderRadius.circular(12).r,
//                         ),
//                         child: Row(
//                           // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 InkWell(
//                                   onTap: () {
//                                     controller.selectedFiles.value.removeAt(i);
//                                     controller.selectedFiles.refresh();
//                                   },
//                                   child: const Icon(
//                                     Icons.close,
//                                     color: ColorUtils.textWhite,
//                                   ),
//                                 ),
//                                 SizedBox(width: 10.h),
//                                 Image.file(
//                                   File(controller.selectedFiles[i]),
//                                   height: 60.h,
//                                   width: 80.h,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ],
//                             ),
//                             SizedBox(width: 10.h),
//                             SizedBox(
//                               width: 150.h,
//                               child: Text(
//                                 controller.selectedFiles[i].split("/").last,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: GoogleFonts.poppins(
//                                   fontWeight: FontWeight.w500,
//                                   fontSize: 12.h,
//                                   color: ColorUtils.textWhite,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                 ],
//               );
//             }
//         )
//       ],
//     );
//   }
// }
//
// class WorkExpenseRequest extends StatelessWidget {
//   const WorkExpenseRequest({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         InkWell(
//           borderRadius: BorderRadius.circular(10).r,
//           onTap: () {
//             showModalBottomSheet(
//               context: context,
//               backgroundColor: Colors.black,
//               barrierColor: ColorUtils.workEntryHead.withValues(alpha: 0.81),
//               isScrollControlled: true,
//               enableDrag: true,
//               useSafeArea: true,
//               builder: (BuildContext context) {
//                 return CategoryBottomSheet(
//                   selectedCategory: (categoryModel.Category category) {
//                     _myRequestController.selectedDropDown1.value = "${category.categoryName}<#>${category.categoryId}";
//                   },
//                 );
//               },
//             );
//           },
//           child: GetX<MyRequestController>(
//               builder: (MyRequestController controller) {
//                 List<String> category = controller.selectedDropDown1.value?.trim().split('<#>') ?? [];
//                 String c = category.isNotEmpty ? category.first : '';
//                 bool isError = controller.showValidation.value && c.isEmpty;
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       height: 54.h,
//                       alignment: Alignment.centerLeft,
//                       padding: const EdgeInsets.only(left: 13, right: 13).h,
//                       width: ScreenUtil().screenWidth,
//                       decoration: BoxDecoration(
//                         color: ColorUtils.foregroundBlack,
//                         borderRadius: BorderRadius.circular(10).r,
//                         border: Border.all(
//                           color: isError ? Colors.red : Colors.transparent,
//                           width: 1.h,
//                         ),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             category.isNotEmpty
//                                 ? category.first
//                                 : "Expense Category *",
//                             style: GoogleFonts.poppins(
//                               fontWeight: FontWeight.w500,
//                               fontSize: 13.h,
//                               color:
//                               category.isNotEmpty
//                                   ? ColorUtils.textWhite
//                                   : isError ? Colors.red : ColorUtils.textWhite.withValues(alpha: 0.5),
//                             ),
//                           ),
//                           Text(
//                             String.fromCharCode(Icons.keyboard_arrow_down_outlined.codePoint),
//                             style: TextStyle(
//                               fontSize: 18.h,
//                               fontWeight: FontWeight.w500,
//                               color: ColorUtils.textWhite.withValues(alpha: 0.5),
//                               fontFamily: Icons.arrow_forward_ios.fontFamily,
//                               package: Icons.arrow_forward_ios.fontPackage,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     if (isError)
//                       Padding(
//                         padding: EdgeInsets.only(left: 15.h, top: 4.h),
//                         child: Text(
//                           "Expense Category is required",
//                           style: GoogleFonts.inter(
//                             color: Colors.red,
//                             fontWeight: FontWeight.w400,
//                             fontSize: 11.h,
//                           ),
//                         ),
//                       ),
//                   ],
//                 );
//               }
//           ),
//         ),
//         SizedBox(height: 15.h),
//         GetX<MyRequestController>(
//             builder: (MyRequestController controller) {
//               bool isError = controller.showValidation.value && (controller.selectedText1.value?.trim().isEmpty ?? true);
//               return Container(
//                 width: ScreenUtil().screenWidth,
//                 height: 54.h,
//                 padding: EdgeInsets.symmetric(horizontal: 10.h),
//                 decoration: BoxDecoration(
//                   color: ColorUtils.foregroundBlack,
//                   borderRadius: BorderRadius.circular(12).r,
//                   border: Border.all(
//                     color: isError
//                         ? Colors.red
//                         : ColorUtils.workEntryHead.withValues(alpha: 0.1),
//                   ),
//                 ),
//                 child: TextField(
//                   keyboardType: TextInputType.text,
//                   textCapitalization: TextCapitalization.sentences,
//                   onChanged: (value) {
//                     _myRequestController.selectedText1.value = value;
//                   },
//                   style: GoogleFonts.inter(
//                     color: ColorUtils.textWhite,
//                     fontWeight: FontWeight.w500,
//                     fontSize: 15.h,
//                   ),
//                   decoration: InputDecoration(
//                     hintText: "Reference *",
//                     contentPadding: EdgeInsets.symmetric(vertical: 15.h),
//                     border: const OutlineInputBorder(borderSide: BorderSide.none),
//                     hintStyle: GoogleFonts.inter(
//                       color: isError ? Colors.red : const Color(0xFFAAAAAA).withValues(alpha: 0.7),
//                       fontWeight: FontWeight.w400,
//                       fontSize: 15.h,
//                       letterSpacing: -0.3,
//                     ),
//                   ),
//                   maxLines: 1,
//                 ),
//               );
//             }
//         ),
//         GetX<MyRequestController>(
//             builder: (MyRequestController controller) {
//               bool isError = controller.showValidation.value && (controller.selectedText1.value?.trim().isEmpty ?? true);
//               if(isError) {
//                 return Container(
//                   alignment: Alignment.centerLeft,
//                   padding: EdgeInsets.only(left: 15.h, top: 4.h),
//                   child: Text(
//                     "Reference is required",
//                     style: GoogleFonts.inter(
//                       color: Colors.red,
//                       fontWeight: FontWeight.w400,
//                       fontSize: 11.h,
//                     ),
//                   ),
//                 );
//               }
//               return const SizedBox.shrink();
//             }
//         ),
//         SizedBox(height: 15.h),
//         GetX<MyRequestController>(
//             builder: (MyRequestController controller) {
//               bool isError = controller.showValidation.value && (controller.selectedText2.value?.trim().isEmpty ?? true);
//               return Container(
//                 width: ScreenUtil().screenWidth,
//                 height: 54.h,
//                 padding: EdgeInsets.symmetric(horizontal: 10.h),
//                 decoration: BoxDecoration(
//                   color: ColorUtils.foregroundBlack,
//                   borderRadius: BorderRadius.circular(12).r,
//                   border: Border.all(
//                     color: isError
//                         ? Colors.red
//                         : ColorUtils.workEntryHead.withValues(alpha: 0.1),
//                   ),
//                 ),
//                 child: TextField(
//                   keyboardType: TextInputType.number,
//                   onChanged: (value) {
//                     _myRequestController.selectedText2.value = value;
//                   },
//                   style: GoogleFonts.inter(
//                     color: ColorUtils.textWhite,
//                     fontWeight: FontWeight.w500,
//                     fontSize: 15.h,
//                   ),
//                   decoration: InputDecoration(
//                     hintText: "Amount Spent *",
//                     contentPadding: EdgeInsets.symmetric(vertical: 15.h),
//                     border: const OutlineInputBorder(borderSide: BorderSide.none),
//                     hintStyle: GoogleFonts.inter(
//                       color: isError ? Colors.red : const Color(0xFFAAAAAA).withValues(alpha: 0.7),
//                       fontWeight: FontWeight.w400,
//                       fontSize: 15.h,
//                       letterSpacing: -0.3,
//                     ),
//                   ),
//                   maxLines: 1,
//                 ),
//               );
//             }
//         ),
//         GetX<MyRequestController>(
//             builder: (MyRequestController controller) {
//               bool isError = controller.showValidation.value && (controller.selectedText2.value?.trim().isEmpty ?? true);
//               if(isError) {
//                 return Container(
//                   alignment: Alignment.centerLeft,
//                   padding: EdgeInsets.only(left: 15.h, top: 4.h),
//                   child: Text(
//                     "Amount Spent is required",
//                     style: GoogleFonts.inter(
//                       color: Colors.red,
//                       fontWeight: FontWeight.w400,
//                       fontSize: 11.h,
//                     ),
//                   ),
//                 );
//               }
//               return const SizedBox.shrink();
//             }
//         ),
//         SizedBox(height: 15.h),
//         GetX<MyRequestController>(
//             builder: (MyRequestController controller) {
//               bool isError = controller.showValidation.value && controller.selectedFromDate.value == null;
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   InkWell(
//                     borderRadius: BorderRadius.circular(10).r,
//                     onTap: () {
//                       DateTime? fromDate;
//                       try {
//                         fromDate = DateTime.parse(_myRequestController.selectedFromDate.value!);
//                       } catch(e) {}
//                       Navigator.of(context).push(
//                         newSlideNavigation(ChooseRequestDatesSingle(
//                           showFutureDates: false,
//                           selectedDates: LeaveDates(
//                               startDate: fromDate
//                           ),
//                         )),
//                       ).then((value) {
//                         if (value != null && value is LeaveDates) {
//                           if (value.startDate != null) {
//                             _myRequestController.selectedFromDate.value =
//                                 DateFormat('yyyy-MM-dd').format(value.startDate!);
//                           }
//                         }
//                       });
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 15).h,
//                       height: 54.h,
//                       decoration: BoxDecoration(
//                         color: ColorUtils.foregroundBlack,
//                         borderRadius: BorderRadius.circular(10).r,
//                         border: Border.all(
//                           color: isError ? Colors.red : Colors.transparent,
//                           width: 1.h,
//                         ),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Flexible(
//                             child: Text(
//                               controller.selectedFromDate.value ?? 'Date of Spend *',
//                               overflow: TextOverflow.ellipsis,
//                               style: GoogleFonts.inter(
//                                 color: isError ? Colors.red : ColorUtils.textWhite.withValues(
//                                   alpha: controller.selectedFromDate.value != null
//                                       ? 1.0
//                                       : 0.5,
//                                 ),
//                                 fontWeight: FontWeight.w400,
//                                 fontSize: 13.h,
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: 5.h),
//                           Icon(
//                             Icons.calendar_today_outlined,
//                             color: const Color(0xFF9A9A9A).withValues(alpha: 0.6),
//                             size: 17.h,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   if (isError)
//                     Padding(
//                       padding: EdgeInsets.only(left: 15.h, top: 4.h),
//                       child: Text(
//                         "Date of Spend is required",
//                         style: GoogleFonts.inter(
//                           color: Colors.red,
//                           fontWeight: FontWeight.w400,
//                           fontSize: 11.h,
//                         ),
//                       ),
//                     ),
//                 ],
//               );
//             }
//         ),
//         SizedBox(height: 15.h),
//         GetX<MyRequestController>(
//             builder: (MyRequestController controller) {
//               bool isError = controller.showValidation.value && (controller.reasonText.value?.trim().isEmpty ?? true);
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     height: 172.h,
//                     width: ScreenUtil().screenWidth,
//                     padding: const EdgeInsets.all(15).h,
//                     decoration: BoxDecoration(
//                       color: ColorUtils.foregroundBlack,
//                       borderRadius: BorderRadius.circular(15).r,
//                       border: Border.all(
//                         color: isError ? Colors.red : Colors.transparent,
//                         width: 1.h,
//                       ),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Description *",
//                           style: GoogleFonts.inter(
//                             color: isError ? Colors.red : const Color(0xFFAAAAAA).withValues(alpha: 0.7),
//                             fontWeight: FontWeight.w400,
//                             fontSize: 13.h,
//                           ),
//                         ),
//                         TextField(
//                           style: GoogleFonts.inter(
//                             color: ColorUtils.textWhite,
//                             fontWeight: FontWeight.w500,
//                             fontSize: 15.h,
//                           ),
//                           onChanged: (value) {
//                             _myRequestController.reasonText.value = value;
//                           },
//                           decoration: InputDecoration(
//                             hintText: "Type here...",
//                             contentPadding: EdgeInsets.zero,
//                             border: const OutlineInputBorder(borderSide: BorderSide.none),
//                             hintStyle: GoogleFonts.inter(
//                               color: isError ? Colors.red : const Color(0xFFAAAAAA).withValues(alpha: 0.7),
//                               fontWeight: FontWeight.w400,
//                               fontSize: 12.h,
//                               letterSpacing: -0.3,
//                             ),
//                           ),
//                           maxLines: 5,
//                         ),
//                       ],
//                     ),
//                   ),
//                   if (isError)
//                     Padding(
//                       padding: EdgeInsets.only(left: 15.h, top: 4.h),
//                       child: Text(
//                         "Description is required",
//                         style: GoogleFonts.inter(
//                           color: Colors.red,
//                           fontWeight: FontWeight.w400,
//                           fontSize: 11.h,
//                         ),
//                       ),
//                     ),
//                 ],
//               );
//             }
//         ),
//         SizedBox(height: 15.h),
//         Padding(
//           padding: EdgeInsets.all(10.h),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Attachments",
//                     style: GoogleFonts.inter(
//                       fontWeight: FontWeight.w400,
//                       fontSize: 13.h,
//                       color: const Color(0xFFAAAAAA),
//                     ),
//                   ),
//                   SizedBox(height: 4.h),
//                   Text(
//                     "Max 5 File (Optional)",
//                     style: GoogleFonts.inter(
//                       fontWeight: FontWeight.w400,
//                       fontSize: 13.h,
//                       color: const Color(0xFF414046),
//                     ),
//                   ),
//                 ],
//               ),
//               GestureDetector(
//                 onTap: () {
//                   attachBottomSheetShow(context, true);
//                 },
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 20,
//                     vertical: 8,
//                   ).h,
//                   decoration: BoxDecoration(
//                     color: ColorUtils.foregroundBlack,
//                     borderRadius: BorderRadius.circular(23).r,
//                   ),
//                   child: Row(
//                     children: [
//                       SvgPicture.asset(
//                         "assets/images/attach_icon.svg",
//                         height: 17.h,
//                       ),
//                       SizedBox(width: 12.h),
//                       Text(
//                         "Add",
//                         style: GoogleFonts.poppins(
//                           fontWeight: FontWeight.w500,
//                           fontSize: 12.h,
//                           color: ColorUtils.textWhite,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         SizedBox(height: 15.h),
//         GetX<MyRequestController>(
//             builder: (MyRequestController controller) {
//               return Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   for(int i = 0; i < controller.selectedFiles.value.length; i++)
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9).h,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8).h,
//                         decoration: BoxDecoration(
//                           color: ColorUtils.foregroundBlack,
//                           borderRadius: BorderRadius.circular(12).r,
//                         ),
//                         child: Row(
//                           // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 InkWell(
//                                   onTap: () {
//                                     controller.selectedFiles.value.removeAt(i);
//                                     controller.selectedFiles.refresh();
//                                   },
//                                   child: const Icon(
//                                     Icons.close,
//                                     color: ColorUtils.textWhite,
//                                   ),
//                                 ),
//                                 SizedBox(width: 10.w),
//                                 if(controller.selectedFiles.value[i].split('.').last == 'pdf')
//                                   Image.asset(
//                                     "assets/images/manager_view/pdf_icon.png",
//                                     height: 35.h,
//                                   )
//                                 else
//                                   Image.file(
//                                     File(controller.selectedFiles.value[i]),
//                                     height: 60.h,
//                                     width: 80.h,
//                                     fit: BoxFit.cover,
//                                     errorBuilder: (context, error, stackTrace) {
//                                       return Transform.rotate(
//                                         angle: 180,
//                                         child: Icon(
//                                           Icons.attach_file,
//                                           size: 28.h,
//                                           color: Colors.blueGrey,
//                                         ),
//                                       );
//                                     },
//                                   ),
//                               ],
//                             ),
//                             SizedBox(width: 10.h),
//                             Flexible(
//                               child: Text(
//                                 controller.selectedFiles.value[i].split("/").last,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: GoogleFonts.poppins(
//                                   fontWeight: FontWeight.w500,
//                                   fontSize: 12.h,
//                                   color: ColorUtils.textWhite,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                 ],
//               );
//             }
//         )
//       ],
//     );
//   }
// }
//
// class OtherRequest extends StatelessWidget {
//   const OtherRequest({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         GetX<MyRequestController>(
//             builder: (MyRequestController controller) {
//               bool isError = controller.showValidation.value && (controller.selectedText1.value?.trim().isEmpty ?? true);
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     width: ScreenUtil().screenWidth,
//                     height: 54.h,
//                     padding: EdgeInsets.symmetric(horizontal: 15.h),
//                     decoration: BoxDecoration(
//                       color: ColorUtils.foregroundBlack,
//                       borderRadius: BorderRadius.circular(12).r,
//                       border: Border.all(
//                         color: isError
//                             ? Colors.red
//                             : ColorUtils.workEntryHead.withValues(alpha: 0.1),
//                       ),
//                     ),
//                     child: TextField(
//                       style: GoogleFonts.inter(
//                         color: ColorUtils.textWhite,
//                         fontWeight: FontWeight.w500,
//                         fontSize: 15.h,
//                       ),
//                       onChanged: (value) {
//                         _myRequestController.selectedText1.value = value;
//                       },
//                       decoration: InputDecoration(
//                         hintText: "Enter Category *",
//                         contentPadding: EdgeInsets.symmetric(vertical: 15.h),
//                         border: const OutlineInputBorder(borderSide: BorderSide.none),
//                         hintStyle: GoogleFonts.inter(
//                           color: isError ? Colors.red : const Color(0xFFAAAAAA).withValues(alpha: 0.7),
//                           fontWeight: FontWeight.w400,
//                           fontSize: 15.h,
//                           letterSpacing: -0.3,
//                         ),
//                       ),
//                       maxLines: 5,
//                     ),
//                   ),
//                   if (isError)
//                     Padding(
//                       padding: EdgeInsets.only(left: 15.h, top: 4.h),
//                       child: Text(
//                         "Category is required.",
//                         style: GoogleFonts.inter(
//                           color: Colors.red,
//                           fontWeight: FontWeight.w400,
//                           fontSize: 11.h,
//                         ),
//                       ),
//                     ),
//                 ],
//               );
//             }
//         ),
//         SizedBox(height: 15.h),
//         GetX<MyRequestController>(
//             builder: (MyRequestController controller) {
//               bool isError = controller.showValidation.value && (controller.reasonText.value?.trim().isEmpty ?? true);
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     height: 172.h,
//                     width: ScreenUtil().screenWidth,
//                     padding: const EdgeInsets.all(15).h,
//                     decoration: BoxDecoration(
//                       color: ColorUtils.foregroundBlack,
//                       borderRadius: BorderRadius.circular(15).r,
//                       border: Border.all(
//                         color: isError ? Colors.red : Colors.transparent,
//                         width: 1.h,
//                       ),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Description *",
//                           style: GoogleFonts.inter(
//                             color: isError ? Colors.red : const Color(0xFFAAAAAA).withValues(alpha: 0.7),
//                             fontWeight: FontWeight.w400,
//                             fontSize: 13.h,
//                           ),
//                         ),
//                         TextField(
//                           style: GoogleFonts.inter(
//                             color: ColorUtils.textWhite,
//                             fontWeight: FontWeight.w500,
//                             fontSize: 15.h,
//                           ),
//                           onChanged: (value) {
//                             _myRequestController.reasonText.value = value;
//                           },
//                           decoration: InputDecoration(
//                             hintText: "Type here...",
//                             contentPadding: EdgeInsets.zero,
//                             border: const OutlineInputBorder(borderSide: BorderSide.none),
//                             hintStyle: GoogleFonts.inter(
//                               color: isError ? Colors.red : const Color(0xFFAAAAAA).withValues(alpha: 0.7),
//                               fontWeight: FontWeight.w400,
//                               fontSize: 12.h,
//                               letterSpacing: -0.3,
//                             ),
//                           ),
//                           maxLines: 5,
//                         ),
//                       ],
//                     ),
//                   ),
//                   if (isError)
//                     Padding(
//                       padding: EdgeInsets.only(left: 15.h, top: 4.h),
//                       child: Text(
//                         "Description is required",
//                         style: GoogleFonts.inter(
//                           color: Colors.red,
//                           fontWeight: FontWeight.w400,
//                           fontSize: 11.h,
//                         ),
//                       ),
//                     ),
//                 ],
//               );
//             }
//         ),
//         SizedBox(height: 15.h),
//         Padding(
//           padding: EdgeInsets.all(10.h),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Attachments",
//                     style: GoogleFonts.inter(
//                       fontWeight: FontWeight.w400,
//                       fontSize: 13.h,
//                       color: const Color(0xFFAAAAAA),
//                     ),
//                   ),
//                   SizedBox(height: 4.h),
//                   Text(
//                     "Max 1 File (Optional)",
//                     style: GoogleFonts.inter(
//                       fontWeight: FontWeight.w400,
//                       fontSize: 13.h,
//                       color: const Color(0xFF414046),
//                     ),
//                   ),
//                 ],
//               ),
//               GestureDetector(
//                 onTap: () {
//                   attachBottomSheetShow(context, false);
//                 },
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 20,
//                     vertical: 8,
//                   ).h,
//                   decoration: BoxDecoration(
//                     color: ColorUtils.foregroundBlack,
//                     borderRadius: BorderRadius.circular(23).r,
//                   ),
//                   child: Row(
//                     children: [
//                       SvgPicture.asset(
//                         "assets/images/attach_icon.svg",
//                         height: 17.h,
//                       ),
//                       SizedBox(width: 12.h),
//                       Text(
//                         "Add",
//                         style: GoogleFonts.poppins(
//                           fontWeight: FontWeight.w500,
//                           fontSize: 12.h,
//                           color: ColorUtils.textWhite,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         SizedBox(height: 15.h),
//         GetX<MyRequestController>(
//             builder: (MyRequestController controller) {
//               return Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   for(int i = 0; i < controller.selectedFiles.value.length; i++)
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9).h,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8).h,
//                         decoration: BoxDecoration(
//                           color: ColorUtils.foregroundBlack,
//                           borderRadius: BorderRadius.circular(12).r,
//                         ),
//                         child: Row(
//                           // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 InkWell(
//                                   onTap: () {
//                                     controller.selectedFiles.value.removeAt(i);
//                                     controller.selectedFiles.refresh();
//                                   },
//                                   child: const Icon(
//                                     Icons.close,
//                                     color: ColorUtils.textWhite,
//                                   ),
//                                 ),
//                                 SizedBox(width: 10.h),
//                                 Image.file(
//                                   File(controller.selectedFiles[i]),
//                                   height: 60.h,
//                                   width: 80.h,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ],
//                             ),
//                             SizedBox(width: 10.h),
//                             SizedBox(
//                               width: 150.h,
//                               child: Text(
//                                 controller.selectedFiles[i].split("/").last,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: GoogleFonts.poppins(
//                                   fontWeight: FontWeight.w500,
//                                   fontSize: 12.h,
//                                   color: ColorUtils.textWhite,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                 ],
//               );
//             }
//         )
//       ],
//     );
//   }
// }
//
// attachBottomSheetShow(mainContext, isMultiple) {
//   showModalBottomSheet(
//     context: mainContext,
//     backgroundColor: Colors.black,
//     barrierColor: ColorUtils.workEntryHead.withValues(alpha: 0.81),
//     builder: (BuildContext context) {
//       return SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Container(
//             width: ScreenUtil().screenWidth,
//             height: 273.h,
//             decoration: BoxDecoration(
//               color: ColorUtils.backgroundBlack,
//               borderRadius: BorderRadius.circular(20).r,
//               border: Border.all(width: 1.h, color: const Color(0xFF404040)),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.only(
//                 top: 10.0,
//                 bottom: 10.0,
//                 left: 15.0,
//                 right: 15.0,
//               ).h,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Select Source",
//                     style: GoogleFonts.poppins(
//                       color: ColorUtils.textWhite,
//                       fontWeight: FontWeight.w600,
//                       fontSize: 17.h,
//                     ),
//                   ),
//                   const Spacer(),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.of(context).pop();
//                       Navigator.of(context).push(
//                         newSlideNavigation(const CameraViewLeave()),
//                       ).then((value) async {
//                         if (value == null) return;
//
//                         final file = File(value);
//                         final fileSizeInBytes = await file.length();
//                         final fileSizeInMB = fileSizeInBytes / (1024 * 1024);
//
//                         if (fileSizeInMB > 5) {
//                           ErrorDialog().showWarn(
//                             context: mainContext,
//                             title: "Error",
//                             subTitle: "File size should be less than 5 MB",
//                           );
//                           return;
//                         }
//
//                         List<String> selectedFiles = _myRequestController.selectedFiles.value;
//
//                         if(isMultiple) {
//                           if((selectedFiles.length + 1) <= 5) {
//                             selectedFiles.add(value);
//                           } else {
//                             ErrorDialog().showWarn(context: mainContext, title: "Error", subTitle: "Maximum 5 files allowed");
//                           }
//                         } else {
//                           if (selectedFiles.isEmpty) {
//                             selectedFiles.add(value);
//                           } else {
//                             ErrorDialog().showWarn(
//                               context: mainContext,
//                               title: "Error",
//                               subTitle: "Maximum 1 file allowed",
//                             );
//                           }
//                         }
//                         _myRequestController.selectedFiles.refresh();
//                       });
//                     },
//                     child: const AttachMenuCard(
//                       imageIcon: "assets/images/camera.webp",
//                       title: "Camera",
//                       subTitle: "Lorem ipsum dolor sit amet, consectetur elit.",
//                     ),
//                   ),
//                   const Spacer(),
//                   GestureDetector(
//                     onTap: () async {
//                       Navigator.of(context).pop();
//                       try {
//                         FilePickerResult? result = await FilePicker.platform.pickFiles(
//                           allowMultiple: isMultiple,
//                           type: FileType.custom,
//                           allowedExtensions: [
//                             'png',
//                             'jpg',
//                             'jpeg',
//                             'gif',
//                             'bmp',
//                             'tiff',
//                             'webp'
//                           ],
//                         );
//
//                         if (result == null || result.files.isEmpty) {
//                           return; // User cancelled
//                         }
//
//                         List<String> selectedFiles =
//                             _myRequestController.selectedFiles.value;
//
//                         if (!isMultiple && selectedFiles.isNotEmpty) {
//                           ErrorDialog().showWarn(
//                             context: mainContext,
//                             title: "Error",
//                             subTitle: "Maximum 1 file allowed",
//                           );
//                           return;
//                         }
//
//                         List<int> removeFiles = [];
//
//                         for (int i = 0; i < result.files.length; i++) {
//                           final fileSizeInBytes = result.files[i].size;
//                           final fileSizeInMB = fileSizeInBytes / (1024 * 1024);
//
//                           if (fileSizeInMB > 5) {
//                             removeFiles.add(i);
//                           }
//                         }
//
//                         if(removeFiles.length == 1) {
//                           Get.snackbar(
//                             "Message",
//                             "The file ${result.files[removeFiles.first].name} was removed because its size exceeds 5 MB.",
//                             snackPosition: SnackPosition.TOP,
//                             backgroundColor: Colors.red,
//                             colorText: Colors.white,
//                             margin: EdgeInsets.all(10.h),
//                           );
//                           result.files.removeAt(removeFiles.first);
//                         } else if(removeFiles.length > 1) {
//                           Get.snackbar(
//                             "Message",
//                             "${removeFiles.length} files were removed because they exceed the 5 MB size limit.",
//                             snackPosition: SnackPosition.TOP,
//                             backgroundColor: Colors.red,
//                             colorText: Colors.white,
//                             margin: EdgeInsets.all(10.h),
//                           );
//                           removeFiles.sort((a, b) => b.compareTo(a));
//
//                           for (final index in removeFiles) {
//                             result.files.removeAt(index);
//                           }
//                         }
//
//                         if (result.files.isEmpty) {
//                           return;
//                         }
//
//                         if(isMultiple) {
//                           if((selectedFiles.length + result.files.length) <= 5) {
//                             selectedFiles.addAll(result.files.map((e) => e.path ?? '').where((element) => element.isNotEmpty));
//                           } else {
//                             ErrorDialog().showWarn(context: mainContext, title: "Error", subTitle: "Maximum 5 files allowed");
//                           }
//                         } else {
//                           if(result.files.isEmpty) return;
//                           final filePath = result.files.single.path;
//
//                           if(filePath == null) {
//                             AttendanceCommonWidgets().showSnackBar(
//                               context: mainContext,
//                               backgroundColor: Colors.red,
//                               message: "File path not found",
//                             );
//                             return;
//                           }
//
//                           selectedFiles.add(filePath);
//                         }
//                         _myRequestController.selectedFiles.refresh();
//
//                       } catch (e) {
//                         AttendanceCommonWidgets()
//                             .printF("------error-------${e.toString()}");
//                       }
//                     },
//                     child: const AttachMenuCard(
//                       imageIcon: "assets/images/image-3d.webp",
//                       title: "Photos",
//                       subTitle: "Lorem ipsum dolor sit amet, consectetur elit.",
//                     ),
//                   ),
//                   const Spacer(),
//                   GestureDetector(
//                     onTap: () async {
//                       Navigator.of(context).pop();
//                       FilePickerResult? result = await FilePicker.platform.pickFiles(
//                         allowMultiple: isMultiple,
//                       );
//
//                       if (result != null) {
//                         List<String> selectedFiles = _myRequestController.selectedFiles.value;
//
//                         if (!isMultiple && selectedFiles.isNotEmpty) {
//                           ErrorDialog().showWarn(
//                             context: mainContext,
//                             title: "Error",
//                             subTitle: "Maximum 1 file allowed",
//                           );
//                           return;
//                         }
//
//                         List<int> removeFiles = [];
//
//                         for (int i = 0; i < result.files.length; i++) {
//                           final fileSizeInBytes = result.files[i].size;
//                           final fileSizeInMB = fileSizeInBytes / (1024 * 1024);
//
//                           if (fileSizeInMB > 5) {
//                             removeFiles.add(i);
//                           }
//                         }
//
//                         if(removeFiles.length == 1) {
//                           Get.snackbar(
//                             "Message",
//                             "The file ${result.files[removeFiles.first].name} was removed because its size exceeds 5 MB.",
//                             snackPosition: SnackPosition.TOP,
//                             backgroundColor: Colors.red,
//                             colorText: Colors.white,
//                             margin: EdgeInsets.all(10.h),
//                           );
//                           result.files.removeAt(removeFiles.first);
//                         } else if(removeFiles.length > 1) {
//                           Get.snackbar(
//                             "Message",
//                             "${removeFiles.length} files were removed because they exceed the 5 MB size limit.",
//                             snackPosition: SnackPosition.TOP,
//                             backgroundColor: Colors.red,
//                             colorText: Colors.white,
//                             margin: EdgeInsets.all(10.h),
//                           );
//                           removeFiles.sort((a, b) => b.compareTo(a));
//
//                           for (final index in removeFiles) {
//                             result.files.removeAt(index);
//                           }
//                         }
//
//                         if (result.files.isEmpty) {
//                           return;
//                         }
//
//                         if(isMultiple) {
//                           if((selectedFiles.length + result.files.length) <= 5) {
//                             selectedFiles.addAll(result.files.map((e) => e.path ?? '').where((element) => element.isNotEmpty));
//                           } else {
//                             ErrorDialog().showWarn(context: mainContext, title: "Error", subTitle: "Maximum 5 files allowed");
//                           }
//                         } else {
//                           if(result.files.isEmpty) return;
//                           final filePath = result.files.single.path;
//                           if(filePath == null) {
//                             AttendanceCommonWidgets().showSnackBar(
//                               context: mainContext,
//                               backgroundColor: Colors.red,
//                               message: "File path not found",
//                             );
//                             return;
//                           }
//
//                           selectedFiles.add(filePath);
//                         }
//                         _myRequestController.selectedFiles.refresh();
//                       } else {
//                         // User canceled the picker
//                       }
//                     },
//                     child: const AttachMenuCard(
//                       imageIcon: "assets/images/file-3d.webp",
//                       title: "Browse",
//                       subTitle: "Lorem ipsum dolor sit amet, consectetur elit.",
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       );
//     },
//   );
// }
//
// Future<void> _showTimePicker(BuildContext context, int index) async {
//   final now = DateTime.now();
//   final currentHour = now.hour;
//   final currentMinute = now.minute;
//   int selectedHour = currentHour;
//   int selectedMinute = currentMinute;
//
//   await showGeneralDialog(
//     context: context,
//     barrierDismissible: true,
//     barrierLabel: "Cancel",
//     barrierColor: ColorUtils.workEntryHead.withValues(alpha: 0.5),
//     pageBuilder: (ctx, a1, a2) {
//       return Container();
//     },
//     transitionDuration: const Duration(milliseconds: 300),
//     transitionBuilder: (ctx, a1, a2, child) {
//       var curve = Curves.easeInOut.transform(a1.value);
//       return Transform.scale(
//         scale: curve,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               height: 250.h,
//               width: 200.h,
//               decoration: BoxDecoration(
//                 color: ColorUtils.foregroundBlack,
//                 borderRadius: BorderRadius.circular(12).r,
//               ),
//               child: Column(
//                 children: [
//                   Expanded(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Expanded(
//                           child: CupertinoPicker(
//                             scrollController: FixedExtentScrollController(
//                               initialItem: currentHour,
//                             ),
//                             itemExtent: 40,
//                             onSelectedItemChanged: (int index) {
//                               selectedHour = index;
//                             },
//                             children: List.generate(24, (index) {
//                               return Center(
//                                 child: Text(
//                                   index.toString().padLeft(2, '0'),
//                                   style: TextStyle(
//                                     fontSize: 18.h,
//                                     color: ColorUtils.textWhite,
//                                   ),
//                                 ),
//                               );
//                             }),
//                           ),
//                         ),
//                         Expanded(
//                           child: CupertinoPicker(
//                             scrollController: FixedExtentScrollController(
//                               initialItem: currentMinute,
//                             ),
//                             itemExtent: 40,
//                             onSelectedItemChanged: (int index) {
//                               selectedMinute = index;
//                             },
//                             children: List.generate(60, (index) {
//                               return Center(
//                                 child: Text(
//                                   index.toString().padLeft(2, '0'),
//                                   style: TextStyle(
//                                     fontSize: 18.h,
//                                     color: ColorUtils.textWhite,
//                                   ),
//                                 ),
//                               );
//                             }),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Divider(
//                     color: Color(0xFF565656).withValues(alpha: 0.2),
//                     thickness: 0.5.h,
//                     height: 0,
//                   ),
//                   Material(
//                     color: ColorUtils.foregroundBlack,
//                     borderRadius: BorderRadius.circular(12).r,
//                     child: Container(
//                       padding: EdgeInsets.symmetric(
//                         vertical: 10.h,
//                         horizontal: 12.h,
//                       ),
//                       decoration: BoxDecoration(
//                         color: ColorUtils.foregroundBlack,
//                         borderRadius: BorderRadius.circular(12).r,
//                       ),
//                       child: Center(
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             InkWell(
//                               onTap: () {
//                                 Navigator.of(context).pop();
//                               },
//                               child: SizedBox(
//                                 width: 80.h,
//                                 height: 20.h,
//                                 child: Center(
//                                   child: Text(
//                                     "Cancel",
//                                     style: TextStyle(
//                                       fontSize: 14.h,
//                                       color: ColorUtils.textWhite,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Container(
//                               width: 0.5.h,
//                               height: 15.h,
//                               color: Color(0xFF565656).withValues(alpha: 0.2),
//                             ),
//                             InkWell(
//                               onTap: () {
//                                 if (index == 0) {
//                                   _myRequestController
//                                       .selectedFromTime
//                                       .value =
//                                   "${selectedHour.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')}";
//                                 }
//                                 if (index == 1) {
//                                   _myRequestController
//                                       .selectedToTime
//                                       .value =
//                                   "${selectedHour.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')}";
//                                 }
//
//                                 Navigator.of(context).pop();
//                               },
//                               child: SizedBox(
//                                 width: 80.h,
//                                 height: 20.h,
//                                 child: Center(
//                                   child: Text(
//                                     "Ok",
//                                     style: TextStyle(
//                                       fontSize: 14.h,
//                                       color: ColorUtils.textWhite,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }
