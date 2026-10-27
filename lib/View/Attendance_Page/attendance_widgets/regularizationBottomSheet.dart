
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loyaltri_minimal/View/CWidgets/loyaltri_blue_text_button.dart';
import 'package:loyaltri_minimal/controller/leaveTypeController.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';
import 'package:loyaltri_minimal/models/leave_type_api_model.dart';
import 'package:loyaltri_minimal/services/api_services.dart';
import 'package:shimmer/shimmer.dart';
import '../../../controller/attendanceListController.dart';
import '../../../controller/locationFetchController.dart';
import '../../../controller/userAuthentication.dart';
import '../../../models/attendance_details_api_model.dart';
import '../../../services/ui_model_services/regularization_submit_model.dart';
import '../../../utils/color_utils.dart';
import '../../CWidgets/error_dialog.dart';
import '../../ManagerView/Manager_Attendance/manager_attendance_controller/manager_attendance_controller.dart';

class RegularizationBottomSheet extends StatefulWidget {
  final RegularizationType regularizationType;
  final String? employeeDailyAttendanceId;
  final String? employeeId;
  final OverTimeData? overTimeData;
  final FocusNode reasonFocusNode;
  final TextEditingController reasonController;
  final bool isWhiteMode;

  const RegularizationBottomSheet({
    super.key,
    required this.regularizationType,
    required this.employeeDailyAttendanceId,
    required this.employeeId,
    this.overTimeData,
    required this.reasonController,
    required this.reasonFocusNode,
    this.isWhiteMode = false,
  });

  @override
  State<RegularizationBottomSheet> createState() => _RegularizationBottomSheetState();
}

class _RegularizationBottomSheetState extends State<RegularizationBottomSheet> {
  final ValueNotifier<bool> showReasonError = ValueNotifier<bool>(false);

  Deduction? deduction;
  bool hideButton = false;
  bool isOverTime = false;

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: KeyboardAvoider(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: SingleChildScrollView(
            child: Container(
              // height: MediaQuery.of(context).viewInsets.bottom + (isOverTime ? 285.w : (changeUi ? (hideButton ? 400.w : 450.w) : (hideButton ? 560.w : 530.w))),
              width: ScreenUtil().screenWidth,
              decoration: BoxDecoration(
                color: widget.isWhiteMode ? ColorUtils.textWhite : ColorUtils.backgroundBlack,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30).r,
                  topRight: Radius.circular(30).r,
                ),
                border: widget.isWhiteMode
                    ? Border.all(
                        color: ColorUtils.workEntryHead.withValues(alpha: 0.1),
                        width: 1.h,
                      )
                    : null,
              ),
              child: Padding(
                padding: const EdgeInsets.all(15).h,
                child: SingleChildScrollView(
                  child: GetX<AttendanceList>(
                    builder: (AttendanceList attendanceController) {
                      final deductionType = attendanceController.attendanceDeductionDetails.value?.deductionCalculationType;
                      final deductionTypeUi = formatCamelCase(deductionType ?? '');

                      if(!attendanceController.deductionLoading.value) {
                        deduction = attendanceController.attendanceDeductionDetails.value;
                      }

                      if(widget.regularizationType == RegularizationType.ot) {
                        hideButton = true;
                        isOverTime = true;
                      } else if(deduction?.regularizationStatus != null) {
                        hideButton = true;
                      }

                      if(hideButton) {
                        widget.reasonController.text = deduction?.excuseReason ?? "";
                      }

                      String? deductionAmount;
                      try {
                        if (deduction?.deductionAmount != null) {
                          deductionAmount = double.parse(deduction!.deductionAmount!).toStringAsFixed(2);
                        }
                      } catch(e) {
                        deductionAmount = deduction?.deductionAmount ?? '--';
                      }
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // const Spacer(),
                              GestureDetector(
                                onTap: () async {
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  height: 48.h,
                                  width: 48.h,
                                  decoration: BoxDecoration(
                                    color: widget.isWhiteMode ? ColorUtils.softPearl : ColorUtils.foregroundBlack,
                                    borderRadius: BorderRadius.circular(14).r,
                                    border: Border.all(
                                      width: 1.h,
                                      color: widget.isWhiteMode ? ColorUtils.lightSilver : const Color(0xFF3F4450),
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.close,
                                      size: 18.h,
                                      color: widget.isWhiteMode ? ColorUtils.workEntryHead : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    "assets/images/Hourglass-3d.webp",
                                    width: 40.h,
                                  ),
                                  Text(
                                    isOverTime ? "Over Time" : "Regularize",
                                    style: GoogleFonts.poppins(
                                      color: widget.isWhiteMode ? ColorUtils.workEntryHead : ColorUtils.textWhite,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.h,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                height: 48.h,
                                width: 48.h,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(14).r,
                                  border: Border.all(
                                    width: 1.h,
                                    color: Colors.transparent,
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 25.h),
                          if(attendanceController.deductionLoading.value)
                            loadingShimmer(width: ScreenUtil().screenWidth * 0.9, height: 60.h)
                          else
                            Container(
                            height: 60.h,
                            width: ScreenUtil().screenWidth * 0.9,
                            padding: const EdgeInsets.symmetric(horizontal: 25).h,
                            decoration: BoxDecoration(
                                color: widget.isWhiteMode ? ColorUtils.softPearl : ColorUtils.foregroundBlack,
                                borderRadius: BorderRadius.circular(15).r,
                                border: widget.isWhiteMode ? Border.all(color: ColorUtils.lightSilver, width: 1.h) : null,
                            ),
                            child: regularisationDetails(widget.regularizationType),
                          ),
                          SizedBox(height: 15.h),
                          if(!isOverTime && !Get.find<UserAuthController>().restrictRsInfo.value)
                            if(attendanceController.deductionLoading.value)
                              loadingShimmer(width: ScreenUtil().screenWidth * 0.9, height: 60.h)
                            else
                              Container(
                              height: 60.h,
                              width: ScreenUtil().screenWidth * 0.9,
                              padding: const EdgeInsets.symmetric(horizontal: 25).h,
                              decoration: BoxDecoration(
                                  color: widget.isWhiteMode ? ColorUtils.softPearl : ColorUtils.foregroundBlack,
                                  borderRadius: BorderRadius.circular(15).r,
                                  border: widget.isWhiteMode ? Border.all(color: ColorUtils.lightSilver, width: 1.h) : null,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "Deduction Amount:  ",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13.h,
                                      color: widget.isWhiteMode ? ColorUtils.workEntryHead : ColorUtils.textWhite,
                                    ),
                                  ),
                                  Text(
                                    deductionAmount ?? '--',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13.h,
                                      color: const Color(0xFFFF9900),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if(!isOverTime && !Get.find<UserAuthController>().restrictRsInfo.value)
                            SizedBox(height: 15.h),
                          if(deduction?.regularizationStatus?.isNotEmpty ?? false)
                            if(attendanceController.deductionLoading.value)
                              loadingShimmer(width: ScreenUtil().screenWidth * 0.9, height: 60.h)
                            else
                              Container(
                              height: 60.h,
                              width: ScreenUtil().screenWidth * 0.9,
                              padding: const EdgeInsets.symmetric(horizontal: 25).h,
                              decoration: BoxDecoration(
                                  color: widget.isWhiteMode ? ColorUtils.softPearl : ColorUtils.foregroundBlack,
                                  borderRadius: BorderRadius.circular(15).r,
                                  border: widget.isWhiteMode ? Border.all(color: ColorUtils.lightSilver, width: 1.h) : null,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "Status:  ",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13.h,
                                      color: widget.isWhiteMode ? ColorUtils.workEntryHead : ColorUtils.textWhite,
                                    ),
                                  ),
                                  // Container(
                                  //   width: 10.w,
                                  //   height: 10.w,
                                  //   decoration: BoxDecoration(
                                  //     borderRadius: BorderRadius.circular(50).w,
                                  //     color: statusColor(deduction?.regularizationStatus ?? ''),
                                  //   ),
                                  // ),
                                  // SizedBox(width: 5.w),
                                  Text(
                                    deduction?.regularizationStatus ?? '',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13.h,
                                      color: statusColor(deduction?.regularizationStatus ?? ''),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if(!hideButton && !isOverTime && attendanceController.attendanceDeductionDetails.value?.showLeaveType == 1)
                            if(attendanceController.deductionLoading.value)
                              loadingShimmer(width: ScreenUtil().screenWidth * 0.9, height: 60.h)
                            else
                              GetX<LeaveTypeController>(
                                builder: (LeaveTypeController leaveTypeController) {
                                  List<LeaveType> leaveList = leaveTypeController.regLeaveTypeList.value.where((leave) {
                                    bool leaveAvailable = false;

                                    if (leave.currBalance != null) {
                                      num balance = num.tryParse(leave.currBalance!) ?? -1;

                                      if (deductionType == 'fullDay') {
                                        balance -= 1;
                                      } else if (deductionType == 'halfDay') {
                                        balance -= 0.5;
                                      } else if (deductionType == 'quarterDay') {
                                        balance -= 0.25;
                                      }

                                      if (balance >= 0) {
                                        leaveAvailable = true;
                                      }
                                    }

                                    return leave.currBalance != '0' && leaveAvailable;
                                  }).toList();
                                  return Container(
                                  width: ScreenUtil().screenWidth * 0.9,
                                  padding: EdgeInsets.symmetric(
                                    vertical: 12.h,
                                    horizontal: 15.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: widget.isWhiteMode ? ColorUtils.softPearl : ColorUtils.textWhite.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(20).r,
                                    border: widget.isWhiteMode ? Border.all(color: ColorUtils.lightSilver, width: 1.h) : null,
                                  ),
                                  child: Column(
                                    children: [
                                      if(deductionTypeUi != null)
                                        Row(
                                        children: [
                                          Text(
                                            'Deduction Type :',
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12.h,
                                                color: widget.isWhiteMode ? ColorUtils.workEntryHead : ColorUtils.textWhite
                                            ),
                                          ),
                                          SizedBox(width: 5.h),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 4.h,
                                              horizontal: 12.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: widget.isWhiteMode ? ColorUtils.textWhite : const Color(0xFF1F1E22),
                                              borderRadius: BorderRadius.circular(30).r,
                                              border: widget.isWhiteMode ? Border.all(color: ColorUtils.lightSilver, width: 1.h) : null,
                                            ),
                                            child: Text(
                                              deductionTypeUi ?? '--',
                                              style: GoogleFonts.poppins(
                                                fontSize: 12.h,
                                                fontWeight: FontWeight.w500,
                                                color: widget.isWhiteMode ? ColorUtils.workEntryHead : ColorUtils.textWhite,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      if(deductionTypeUi != null)
                                        SizedBox(height: 8.h),
                                      Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              'Would you like to compensate this deduction from your leave balance?',
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12.h,
                                                color: widget.isWhiteMode ? ColorUtils.workEntryHead : ColorUtils.textWhite,
                                              ),
                                            ),
                                          ),
                                          AdvancedSwitch(
                                            height: 21.h,
                                            width: 39.h,
                                            activeColor: ColorUtils.lavenderIndigo,
                                            inactiveColor: ColorUtils.darkGrey,
                                            initialValue: attendanceController.deductionToggle.value,
                                            onChanged: (value) {
                                              attendanceController.deductionToggle.value = value;
                                            },
                                          ),
                                        ],
                                      ),
                                      if(attendanceController.deductionToggle.value)
                                        if(attendanceController.attendanceDeductionDetails.value?.showLeaveType == 0 || leaveList.isEmpty)
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: 13.h,
                                            ),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 8.h,
                                                vertical: 12.h,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Color(0xFFFFC3C3),
                                                borderRadius: BorderRadius.circular(8).r,
                                              ),
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                    'assets/images/alert_icon.png',
                                                    height: 29.h,
                                                  ),
                                                  SizedBox(width: 8.h),
                                                  Flexible(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          'No Leave balance available to deduct!',
                                                          style: GoogleFonts.inter(
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 12.h,
                                                            color: Color(0xFFBF2424),
                                                          ),
                                                        ),
                                                        Text(
                                                          'Fine will be applied & adjusted from salary.',
                                                          style: GoogleFonts.inter(
                                                            fontWeight: FontWeight.w400,
                                                            fontSize: 12.h,
                                                            color: ColorUtils.workEntryHead,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        else
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: 13.h,
                                            ),
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: ScreenUtil().screenWidth,
                                                  height: 48.h,
                                                  decoration: BoxDecoration(
                                                    color: widget.isWhiteMode ? ColorUtils.textWhite : const Color(0xFF1F1E22),
                                                    borderRadius: BorderRadius.circular(12).r,
                                                    border: widget.isWhiteMode ? Border.all(color: ColorUtils.lightSilver, width: 1.h) : null,
                                                  ),
                                                  child: Center(
                                                    child: DropdownButtonHideUnderline(
                                                      child: DropdownButton2<String>(
                                                        isExpanded: true,
                                                        hint: Text(
                                                          'Select Type',
                                                          style: GoogleFonts.dmSans(
                                                            fontWeight: FontWeight.w400,
                                                            fontSize: 13.h,
                                                            color: widget.isWhiteMode
                                                                ? ColorUtils.workEntryHead.withValues(alpha: 0.5)
                                                                : ColorUtils.textWhite.withValues(alpha: 0.5),
                                                          ),
                                                        ),
                                                        selectedItemBuilder: (context) {
                                                          return leaveList.map((option) {
                                                            return Align(
                                                              alignment: Alignment.centerLeft,
                                                              child: Text(
                                                                option.leaveType ?? '--',
                                                                overflow: TextOverflow.ellipsis,
                                                                style: GoogleFonts.dmSans(
                                                                  fontWeight: FontWeight.w400,
                                                                  fontSize: 13.h,
                                                                  color: widget.isWhiteMode ? ColorUtils.workEntryHead : ColorUtils.textWhite,
                                                                ),
                                                              ),
                                                            );
                                                          }).toList();
                                                        },
                                                        items: leaveList.map(
                                                              (option) => DropdownMenuItem<String>(
                                                            value: option.leaveType,
                                                            child: Align(
                                                              alignment: Alignment.centerLeft,
                                                              child: Text(
                                                                option.leaveType ?? '--',
                                                                overflow: TextOverflow.ellipsis,
                                                                style: GoogleFonts.dmSans(
                                                                  fontWeight: FontWeight.w400,
                                                                  fontSize: 13.h,
                                                                  color: widget.isWhiteMode ? ColorUtils.workEntryHead : ColorUtils.textWhite,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ).toList(),
                                                        value: attendanceController.selectedLeave.value?.leaveType,
                                                        onChanged:
                                                            (selectedValue) async {
                                                          List<LeaveType> selectedList = leaveList.where((leave) => leave.leaveType == selectedValue).toList();

                                                          if (selectedList.isNotEmpty) {
                                                            attendanceController.selectedLeave.value = selectedList.first;
                                                          }

                                                          LeaveType? leave = attendanceController.selectedLeave.value;

                                                          num? balance = num.tryParse(leave?.currBalance ?? '');

                                                          if (balance != null) {
                                                            if (deductionType == 'fullDay') {
                                                              balance -= 1;
                                                            } else if (deductionType == 'halfDay') {
                                                              balance -= 0.5;
                                                            } else if (deductionType == 'quarterDay') {
                                                              balance -= 0.25;
                                                            }

                                                            attendanceController.selectedLeave.value?.afterDeduction = balance.toString();
                                                          } else {
                                                            attendanceController.selectedLeave.value?.afterDeduction = null;
                                                          }
                                                        },
                                                        iconStyleData: IconStyleData(
                                                          icon: Icon(
                                                            Icons.keyboard_arrow_down,
                                                            color: widget.isWhiteMode ? ColorUtils.workEntryHead : ColorUtils.spanishGrey,
                                                          ),
                                                        ),
                                                        buttonStyleData: ButtonStyleData(
                                                          padding: EdgeInsets.only(right: 16.h),
                                                          overlayColor: WidgetStateProperty.all(Colors.transparent),
                                                        ),
                                                        dropdownStyleData: DropdownStyleData(
                                                          decoration: BoxDecoration(
                                                            color: widget.isWhiteMode ? ColorUtils.textWhite : const Color(0xFF1F1E22),
                                                            borderRadius: BorderRadius.circular(8).r,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                if(attendanceController.selectedLeave.value?.leaveType != null)
                                                  SizedBox(height: 13.h),
                                                if(attendanceController.selectedLeave.value?.leaveType != null)
                                                  Row(
                                                    children: [
                                                      Flexible(
                                                        child: Text.rich(
                                                          overflow: TextOverflow.ellipsis,
                                                          TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text: '${attendanceController.selectedLeave.value?.leaveType} balance: ',
                                                                style: GoogleFonts.inter(
                                                                  fontSize: 11.h,
                                                                  fontWeight: FontWeight.w400,
                                                                  color: widget.isWhiteMode ? ColorUtils.workEntryHead : ColorUtils.textWhite,
                                                                ),
                                                              ),
                                                              TextSpan(
                                                                text: '${attendanceController.selectedLeave.value?.currBalance} Days',
                                                                style: GoogleFonts.inter(
                                                                  fontSize: 11.h,
                                                                  fontWeight: FontWeight.w700,
                                                                  color: const Color(0xFFA18DFF),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                if(attendanceController.selectedLeave.value?.leaveType != null)
                                                  SizedBox(height: 6.h),
                                                if(attendanceController.selectedLeave.value?.leaveType != null)
                                                  Row(
                                                    children: [
                                                      SvgPicture.asset(
                                                        'assets/images/Info.svg',
                                                        height: 17.h,
                                                      ),
                                                      SizedBox(width: 5.h),
                                                      Flexible(
                                                        child: Text.rich(
                                                          overflow: TextOverflow.ellipsis,
                                                          TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text: 'After deduction balance would be ',
                                                                style: GoogleFonts.inter(
                                                                  fontSize: 11.h,
                                                                  fontWeight: FontWeight.w400,
                                                                  color: widget.isWhiteMode ? ColorUtils.workEntryHead.withValues(alpha: 0.7) : const Color(0xFFABA1B5),
                                                                  fontStyle: FontStyle.italic,
                                                                ),
                                                              ),
                                                              TextSpan(
                                                                text: '${attendanceController.selectedLeave.value?.afterDeduction} Days',
                                                                style: GoogleFonts.inter(
                                                                  fontSize: 11.h,
                                                                  fontWeight: FontWeight.w700,
                                                                  color: widget.isWhiteMode ? ColorUtils.workEntryHead : ColorUtils.textWhite,
                                                                  fontStyle: FontStyle.italic,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                              ],
                                            ),
                                          ),
                                    ],
                                  ),
                                  );
                                }
                              ),
                          if(!isOverTime && (attendanceController.attendanceDeductionDetails.value?.showLeaveType == 1 || (deduction?.regularizationStatus?.isNotEmpty ?? false)))
                            SizedBox(height: 15.h),
                          if(!isOverTime)
                            if(attendanceController.deductionLoading.value)
                              loadingShimmer(width: ScreenUtil().screenWidth * 0.9, height: 185.h)
                            else
                              ValueListenableBuilder<bool>(
                                valueListenable: showReasonError,
                                builder: (context, isError, child) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 185.h,
                                        width: ScreenUtil().screenWidth * 0.9,
                                        padding: const EdgeInsets.all(15).h,
                                        decoration: BoxDecoration(
                                          color: widget.isWhiteMode ? ColorUtils.softPearl : ColorUtils.foregroundBlack,
                                          borderRadius: BorderRadius.circular(15).r,
                                          border: Border.all(
                                            color: isError
                                                ? Colors.red
                                                : (widget.isWhiteMode ? ColorUtils.lightSilver : Colors.transparent),
                                            width: 1.h,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "Reason ",
                                                  style: GoogleFonts.inter(
                                                    color: widget.isWhiteMode ? ColorUtils.workEntryHead.withValues(alpha: 0.7) : const Color(0xFFAAAAAA),
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 13.h,
                                                  ),
                                                ),
                                                Text(
                                                  "*",
                                                  style: GoogleFonts.inter(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 13.h,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            TextField(
                                              controller: widget.reasonController,
                                              focusNode: widget.reasonFocusNode,
                                              readOnly: hideButton,
                                              onChanged: (val) {
                                                if (val.trim().isNotEmpty && showReasonError.value) {
                                                  showReasonError.value = false;
                                                }
                                              },
                                              style: GoogleFonts.inter(
                                                color: widget.isWhiteMode ? ColorUtils.workEntryHead : ColorUtils.textWhite,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15.h,
                                              ),
                                              decoration: InputDecoration(
                                                hintText: "Description",
                                                contentPadding: const EdgeInsets.all(0),
                                                border: const OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                ),
                                                hintStyle: GoogleFonts.inter(
                                                  color: widget.isWhiteMode
                                                      ? ColorUtils.workEntryHead.withOpacity(0.4)
                                                      : ColorUtils.textWhite.withOpacity(0.2),
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15.h,
                                                ),
                                              ),
                                              maxLines: 5,
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (isError) ...[
                                        SizedBox(height: 5.h),
                                        Padding(
                                          padding: EdgeInsets.only(left: 5.w),
                                          child: Text(
                                            "Reason is required",
                                            style: GoogleFonts.inter(
                                              color: Colors.red,
                                              fontSize: 12.h,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  );
                                },
                              ),
                          SizedBox(height: 15.h),
                          if(!hideButton && !attendanceController.deductionLoading.value)
                            InkWell(
                              splashColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              overlayColor: WidgetStateProperty.all(Colors.transparent),
                              onTap: () async {
                                if (widget.reasonController.text.trim().isEmpty) {
                                  showReasonError.value = true;
                                  return;
                                }
                                showReasonError.value = false;
                                context.loaderOverlay.show();
                                if(widget.reasonFocusNode.hasFocus) {
                                  widget.reasonFocusNode.unfocus();
                                }
                                String? status;
                                String? message;
                                try {
                                  final createdBy = Get.find<UserProfileController>().userData.value.result.employeeId?.toString() ?? '';
                                  String companyId = widget.isWhiteMode ? (Get.find<UserProfileController>().currentCompany.value?.companyId?.toString() ?? '') : (Get.find<UserProfileController>().userData.value.result.companyId ?? '');
                                  RegularizationSubmit regDetails = RegularizationSubmit(
                                    employeeId: widget.employeeId ?? '',
                                    createdBy: createdBy,
                                    deductionDetails: getDeductionText(widget.regularizationType),
                                    employeeCompanyId: companyId,
                                    employeeDailyAttendanceId: widget.employeeDailyAttendanceId ?? '',
                                    excuseReason: widget.reasonController.text == "" ? null : widget.reasonController.text,
                                    leaveTypeId: attendanceController.deductionToggle.value ? attendanceController.selectedLeave.value?.leaveTypeId : null,
                                    regularizationType: widget.regularizationType,
                                  );
                                  Map<String, dynamic> resp = await ApiServices.requestRegularization(regularizationDetails: regDetails);
                                  debugPrint('------resp------$resp');
                                  status = resp['status']?.toString();
                                  message = resp['message']?.toString();
                                } catch(e) {} finally {
                                  context.loaderOverlay.hide();
                                  if(status != null && status == '200') {
                                    showSuccessMessage(context: context, message: message);
                                    HapticFeedback.lightImpact();
                                    await Future.delayed(const Duration(seconds: 2));
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    if(widget.isWhiteMode) {
                                      ManagerAttendanceController managerAttendanceController = Get.find<ManagerAttendanceController>();
                                      String formated = DateFormat('yyyy-MM-dd').format(managerAttendanceController.dateList.value[managerAttendanceController.currentDateIndex.value]);

                                      Get.find<ManagerAttendanceController>().attDetailsShimmer.value = false;
                                      await Get.find<ManagerAttendanceController>().fetchManagerAttSummary(
                                        date: formated,
                                      );
                                      await Get.find<ManagerAttendanceController>().fetchManagerAttDetails(
                                        date: formated,
                                      );
                                    } else {
                                      await Get.find<AttendanceList>().fetchAttendanceList(
                                          empId: widget.employeeId ?? '',
                                          compId: Get.find<UserProfileController>().userData.value.result.companyId ?? ''
                                      );
                                    }
                                  } else {
                                    if(widget.isWhiteMode) {
                                      ErrorDialog().showWarnManager(context: context, title: "Submission Failed!", subTitle: message ?? "Something went wrong");
                                    } else {
                                      ErrorDialog().showWarn(context: context, title: "Submission Failed!", subTitle: message ?? "Something went wrong");
                                    }
                                  }
                                  attendanceController.selectedLeave.value = null;
                                  attendanceController.deductionToggle.value = false;
                                }
                              },
                              child: const LoyaltriBlueTextButton(text: "Apply for Excuse"),
                            ),
                          // SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                        ],
                      );
                    }
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget regularisationDetails(RegularizationType type) {
    String? date;
    String value;
    String? title;

    try {
      title = "${type == RegularizationType.ot ? (widget.overTimeData?.overTimeDetails ?? 'Over Time') : (deduction?.deductionDetails ?? '--')}:  ";
      if (type == RegularizationType.ot) {
        date = DateFormat("d MMM | EEE")
            .format(DateTime.parse(widget.overTimeData!.overTimeDate!));
        value = widget.overTimeData?.timeExtra ?? "--";
      } else {
        date = DateFormat("d MMM | EEE")
            .format(DateTime.parse(deduction!.deductionDate!));
        value = deduction?.timeDifference ?? "--";
      }
    } catch (e) {
      value = "--";
    }

    return Row(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title ?? '--',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 13.h,
                color: widget.isWhiteMode ? ColorUtils.workEntryHead : ColorUtils.textWhite,
              ),
            ),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 13.h,
                color: const Color(0xFFFF9900),
              ),
            ),
          ],
        ),
        const Spacer(),
        Text(
          date ?? "--",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 13.h,
            color: widget.isWhiteMode ? ColorUtils.workEntryHead : ColorUtils.textWhite,
          ),
        ),
      ],
    );
  }

  Future<bool?> showSuccessMessage({required BuildContext context, String? message}) async {
    return showGeneralDialog<bool>(
        context: context,
        barrierDismissible: false,
        barrierColor: widget.isWhiteMode ? Colors.black54 : Colors.black,
        pageBuilder: (ctx, a1, a2) {
          return Container();
        },
        transitionDuration: const Duration(milliseconds: 300),
        transitionBuilder: (ctx, a1, a2, child) {
          var curve = Curves.easeInOut.transform(a1.value);
          return Transform.scale(
            scale: curve,
            child: PopScope(
              canPop: false,
              child: AlertDialog(
                backgroundColor: widget.isWhiteMode ? ColorUtils.textWhite : ColorUtils.backgroundBlack,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(29.0).w,
                  side: BorderSide(
                    color: widget.isWhiteMode ? ColorUtils.lightSilver : const Color(0xFF666666),
                    width: 1.w,
                  ),
                ),
                title: Image.asset(
                  "assets/images/Success-icon3d.webp",
                  // width: 10.w,
                  height: 60.w,
                ),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      message ?? "Your excuse has been submitted successfully.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                        color: widget.isWhiteMode ? ColorUtils.workEntryHead : ColorUtils.textWhite,
                      ),
                    ),
                    SizedBox(height: 5.w),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/images/attendance-3d.webp",
                          width: 20.w,
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          DateFormat('hh:mm a').format(DateTime.now()),
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                            color: widget.isWhiteMode ? ColorUtils.workEntryHead : ColorUtils.textWhite,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.w),
                    GetX<LocationFetchController>(
                      builder: (LocationFetchController controller) {
                        if(controller.locName.value == null && controller.position.value?.latitude == null && controller.position.value?.longitude == null) {
                          return SizedBox();
                        } else {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                "assets/images/navigation-3d.webp",
                                width: 25.w,
                                fit: BoxFit.fitWidth,
                              ),
                              SizedBox(width: 5.w),
                              SizedBox(
                                width: ScreenUtil().screenWidth * 0.3,
                                child: Text(
                                  controller.locName.value != null ? "${controller.locName.value}" : "(${controller.position.value?.latitude}, ${controller.position.value?.longitude})",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    color: widget.isWhiteMode ? ColorUtils.workEntryHead : ColorUtils.textWhite,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      }
                    ),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }

  Color statusColor(String status) {
    switch(status.toLowerCase()) {
      case "pending": return const Color(0xFFF8A24E);
      case "pardon": return const Color(0xFF50BC61);
      case "approved": return const Color(0xFF50BC61);
      case "fine": return const Color(0xFFD40000);
      case "rejected": return const Color(0xFFD40000);
      default: return ColorUtils.textWhite;
    }
  }

  String formatCamelCase(String value) {
    if (value.isEmpty) return '';

    final result = value.replaceAllMapped(
      RegExp(r'([A-Z])'),
          (match) => ' ${match.group(1)}',
    );

    return result[0].toUpperCase() + result.substring(1);
  }

  String getDeductionText(RegularizationType type) {
    switch(type) {
      case RegularizationType.le: return "Late Entry";
      case RegularizationType.ot: return "Over Time";
      case RegularizationType.eb: return "Excess Break";
      case RegularizationType.ee: return "Early Exit";
      case RegularizationType.mp: return "Miss Punch";
      case RegularizationType.st: return "Short Time";
    }
  }

  Widget loadingShimmer({required double width, required double height}) {
    return Shimmer.fromColors(
      baseColor: widget.isWhiteMode ? Colors.grey[300]! : Colors.grey[800]!,
      highlightColor: widget.isWhiteMode ? Colors.grey[100]! : Colors.grey[700]!,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8).r,
          color: widget.isWhiteMode ? Colors.grey[200] : Colors.grey[850],
        ),
      ),
    );
  }
}
