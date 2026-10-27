import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/controller/attendanceUploadController.dart';
import 'package:loyaltri_minimal/controller/punchTypeController.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';

import '../../../controller/checkInController.dart';
import '../../../controller/ui_controller/home_controller.dart';
import '../../../controller/userAuthentication.dart';
import '../../../models/checkIn_model.dart';
import '../../../services/api_services.dart';
import '../../../services/connectivity_service.dart';
import '../../../services/ui_model_services/api_request_model.dart';
import '../../../sqflite_db/punch_db.dart';
import '../../../utils/color_utils.dart';
import '../../CWidgets/error_dialog.dart';
import '../../Work_Entry/work_entry_widgets/alert_dialogue.dart';
import 'bottomSheet_chooseCheckType.dart';

class CheckButtonHome extends StatelessWidget {
  final bool isChecked;
  final bool isPunchMethodsEmpty;
  const CheckButtonHome({super.key, required this.isChecked, required this.isPunchMethodsEmpty});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Stack(
        children: [
          SizedBox(
            height: 50.w,
            // width: 157.w,
            child: FilledButton(
              onPressed: isPunchMethodsEmpty ? null : () async {
                String? msg = await Get.find<AttendanceUploadController>().checkInGuard();
                if(msg == null) {
                  chooseCheckTypeBottomSheet(
                    mainContext: context,
                    isIn: !isChecked,
                  );
                } else {
                  await HapticFeedback.lightImpact();
                  String? msg = "${!isChecked ? 'Check in' : 'Check out'} is not allowed within 3 minutes after ${!isChecked ? 'checkout' : 'check in'}. Please try again later.";
                  ErrorDialog().showWarn(
                      context: context,
                      title: "Message",
                      subTitle: msg);
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    return ColorUtils.textWhite;
                  },
                ),
              ),
              child: FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!isChecked)
                      SvgPicture.asset(
                        "assets/images/finger_print.svg",
                      ),
                    if (isChecked)
                      SvgPicture.asset(
                        "assets/images/material-symbols_fingerprint.svg",
                        width: 24.h,
                      ),
                    SizedBox(width: 8.w),
                    Text(
                      !isChecked ? "Check In" : "Check Out",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.h,
                        color: !isChecked
                            ? ColorUtils.checkInBlue
                            : ColorUtils.checkOutRed,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if(isPunchMethodsEmpty)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  AttendanceCommonWidgets().showSnackBar(
                      context: context,
                      backgroundColor: ColorUtils.foregroundBlack4,
                      message: "Action Not Allowed",
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class AppBarCheckButtonHome extends StatelessWidget {
  final bool isChecked;
  const AppBarCheckButtonHome({super.key, required this.isChecked});

  @override
  Widget build(BuildContext context) {
    return GetX<CheckInController>(
      builder: (CheckInController controller) {
        return Container(
          height: 38.w,
          width: 157.w,
          decoration: controller.breakTimeRunning.value
              ? BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      ColorUtils.breakGrad1,
                      ColorUtils.breakGrad2,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(40).r,
                )
              : null,
          child: Stack(
            children: [
              FilledButton(
                onPressed: () async {
                  PunchTypeController punchTypeController = Get.find<PunchTypeController>();
                  bool isPunchMethodsEmpty = punchTypeController.checkInMethods.value.isEmpty || punchTypeController.checkOutMethods.value.isEmpty;
                  if(!isPunchMethodsEmpty) {
                    if (controller.breakTimeRunning.value) {
                      await breakApply(controller: controller, context: context);
                    } else {
                      String? msg = await Get.find<AttendanceUploadController>().checkInGuard();
                      if(msg == null) {
                        chooseCheckTypeBottomSheet(
                          mainContext: context,
                          isIn: !isChecked,
                        );
                      } else {
                        await HapticFeedback.lightImpact();
                        String? msg = "${!isChecked ? 'Check in' : 'Check out'} is not allowed within 3 minutes after ${!isChecked ? 'checkout' : 'check in'}. Please try again later.";
                        ErrorDialog().showWarn(
                            context: context,
                            title: "Message",
                            subTitle: msg);
                      }
                    }
                  }
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                    (Set<WidgetState> states) {
                      return controller.breakTimeRunning.value
                          ? Colors.transparent
                          : ColorUtils.textWhite;
                    },
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (controller.breakTimeRunning.value)
                      SvgPicture.asset(
                        "assets/images/end-break.svg",
                        height: 20.h,
                      ),
                    if (!controller.breakTimeRunning.value)
                      if (!isChecked)
                        SvgPicture.asset(
                          "assets/images/finger_print.svg",
                          height: 20.h,
                        ),
                    if (!controller.breakTimeRunning.value)
                      if (isChecked)
                        SvgPicture.asset(
                          "assets/images/material-symbols_fingerprint.svg",
                          height: 20.h,
                        ),
                    SizedBox(width: 10.w),
                    Text(
                      controller.breakTimeRunning.value
                          ? "End Break"
                          : !isChecked
                              ? "Check In"
                              : "Check Out",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 11.sp,
                        color: controller.breakTimeRunning.value
                            ? ColorUtils.textWhite
                            : !isChecked
                                ? ColorUtils.checkInBlue
                                : ColorUtils.checkOutRed,
                      ),
                    ),
                  ],
                ),
              ),
              GetX<PunchTypeController>(
                  builder: (PunchTypeController punchTypeController) {
                    bool isPunchMethodsEmpty = punchTypeController.checkInMethods.value.isEmpty || punchTypeController.checkOutMethods.value.isEmpty;
                    if(isPunchMethodsEmpty) {
                      return Positioned.fill(
                        child: GestureDetector(
                          onTap: () {
                            AttendanceCommonWidgets().showSnackBar(
                              context: context,
                              backgroundColor: ColorUtils.foregroundBlack4,
                              message: "Action Not Allowed",
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: controller.breakTimeRunning.value ? 0.1 : 0.4),
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  }
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> breakApply(
      {required CheckInController controller,
      required BuildContext context}) async {
    context.loaderOverlay.show();
    // bool connection = await ConnectivityService().check();
    // if (connection) {
      String empId =
          Get.find<UserAuthController>().userData.value.userData?.employeeId ??
              '--';
      String compId = Get.find<UserProfileController>().userData.value.result.companyId?.toString() ?? '';
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd').format(now);
      String formattedTime = DateFormat('HH:mm:ss').format(now);
      BreakRequestModel breakRequestModel = BreakRequestModel(
        employeeId: empId,
        breakType: controller.breakTimeRunning.value
            ? BreakType.endBreak
            : BreakType.startBreak,
        date: formattedDate,
        time: formattedTime,
      );

      AttendanceCheckModel punch = AttendanceCheckModel(
        employeeId: empId,
        companyId: compId,
        punchDate: formattedDate,
        punchTime: formattedTime,
        latitude: '',
        longitude: '',
        punchState: breakRequestModel.breakType == BreakType.startBreak ? "breakIn" : "breakOut",
      );

      try {
        Map<String, dynamic> resp = await ApiServices
            .sendBreakDetails(breakRequest: breakRequestModel);
        AttendanceCommonWidgets().printF("-------break resp-----------$resp");
        if (resp['status'] == 200) {
          await PunchDatabase.instance.create(punch.copy(isSynced: 1));
          await controller.getCheckInData(compId: compId, empId: empId);
          await Get.find<HomeController>().getTimer();
          HapticFeedback.lightImpact();
          context.loaderOverlay.hide();
          UploadSuccessDialog().showWarn(
              context: context,
              message: controller.breakTimeRunning.value
                  ? "Break started"
                  : "Break ended");
        } else {
          HapticFeedback.lightImpact();
          context.loaderOverlay.hide();
          ErrorDialog().showWarn(
              context: context,
              title: controller.breakTimeRunning.value
                  ? "Failed to start break"
                  : "Failed to end break");
        }
      } catch (e) {
        await PunchDatabase.instance.create(punch.copy(isSynced: 0));
        await controller.getCheckInData(compId: compId, empId: empId);
        await Get.find<HomeController>().getTimer();
        HapticFeedback.lightImpact();
        context.loaderOverlay.hide();
        ErrorDialog().showWarn(
            context: context,
            title: "Failed",
            subTitle: "Something went wrong.");
      }
    // } else {
    //   HapticFeedback.lightImpact();
    //   context.loaderOverlay.hide();
    //   ErrorDialog().showWarn(
    //       context: context,
    //       title: "Failed",
    //       subTitle: "No internet connection.");
    // }
  }
}

class AppBarBreakButtonHome extends StatelessWidget {
  final bool isChecked;
  const AppBarBreakButtonHome({super.key, required this.isChecked});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GetX<CheckInController>(
        builder: (CheckInController controller) {
          return Container(
            height: 38.w,
            width: 157.w,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  ColorUtils.breakGrad1,
                  ColorUtils.breakGrad2,
                ],
              ),
              borderRadius: BorderRadius.circular(40).r,
            ),
            child: FilledButton(
              onPressed: () async {
                await breakApply(controller: controller, context: context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    return Colors.transparent;
                  },
                ),
              ),
              child: FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/images/end-break.svg",
                      width: 24.h,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      "End Break",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.h,
                        color: ColorUtils.textWhite,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> breakApply(
      {required CheckInController controller,
      required BuildContext context}) async {
    context.loaderOverlay.show();
    // bool connection = await ConnectivityService().check();
    // if (connection) {
      String empId =
          Get.find<UserAuthController>().userData.value.userData?.employeeId ??
              '--';
      String compId = Get.find<UserProfileController>().userData.value.result.companyId?.toString() ?? '';
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd').format(now);
      String formattedTime = DateFormat('HH:mm:ss').format(now);
      BreakRequestModel breakRequestModel = BreakRequestModel(
        employeeId: empId,
        breakType: controller.breakTimeRunning.value
            ? BreakType.endBreak
            : BreakType.startBreak,
        date: formattedDate,
        time: formattedTime,
      );

      AttendanceCheckModel punch = AttendanceCheckModel(
        employeeId: empId,
        companyId: compId,
        punchDate: formattedDate,
        punchTime: formattedTime,
        latitude: '',
        longitude: '',
        punchState: breakRequestModel.breakType == BreakType.startBreak ? "breakIn" : "breakOut",
      );

      try {
        Map<String, dynamic> resp = await ApiServices
            .sendBreakDetails(breakRequest: breakRequestModel);
        AttendanceCommonWidgets().printF("-------break resp-----------$resp");
        if (resp['status'] == 200) {
          await PunchDatabase.instance.create(punch.copy(isSynced: 1));
          await controller.getCheckInData(compId: compId, empId: empId);
          await Get.find<HomeController>().getTimer();
          HapticFeedback.lightImpact();
          context.loaderOverlay.hide();
          UploadSuccessDialog().showWarn(
              context: context,
              message: controller.breakTimeRunning.value
                  ? "Break started"
                  : "Break ended");
        } else {
          HapticFeedback.lightImpact();
          context.loaderOverlay.hide();
          ErrorDialog().showWarn(
              context: context,
              title: controller.breakTimeRunning.value
                  ? "Failed to start break"
                  : "Failed to end break");
        }
      } catch (e) {
        await PunchDatabase.instance.create(punch.copy(isSynced: 0));
        await controller.getCheckInData(compId: compId, empId: empId);
        await Get.find<HomeController>().getTimer();
        HapticFeedback.lightImpact();
        context.loaderOverlay.hide();
        ErrorDialog().showWarn(
            context: context,
            title: "Failed",
            subTitle: "Something went wrong.");
      }
    // } else {
    //   HapticFeedback.lightImpact();
    //   context.loaderOverlay.hide();
    //   ErrorDialog().showWarn(
    //       context: context,
    //       title: "Failed",
    //       subTitle: "No internet connection.");
    // }
  }
}
