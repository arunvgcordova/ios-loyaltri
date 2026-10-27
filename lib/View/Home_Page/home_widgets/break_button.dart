
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/controller/checkInController.dart';
import 'package:loyaltri_minimal/controller/ui_controller/home_controller.dart';
import 'package:loyaltri_minimal/controller/userAuthentication.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';
import 'package:loyaltri_minimal/services/api_services.dart';
import 'package:loyaltri_minimal/services/connectivity_service.dart';
import '../../../models/checkIn_model.dart';
import '../../../services/ui_model_services/api_request_model.dart';
import '../../../sqflite_db/punch_db.dart';
import '../../../utils/color_utils.dart';
import '../../CWidgets/error_dialog.dart';
import '../../Work_Entry/work_entry_widgets/alert_dialogue.dart';

class BreakButtonHome extends StatelessWidget {
  final bool isPunchMethodsEmpty;
  const BreakButtonHome({super.key, required this.isPunchMethodsEmpty});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: GetX<CheckInController>(
        builder: (CheckInController controller) {
          return Container(
            height: 50.w,
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
                if(isPunchMethodsEmpty) {
                  AttendanceCommonWidgets().showSnackBar(
                    context: context,
                    backgroundColor: ColorUtils.foregroundBlack4,
                    message: "Action Not Allowed",
                  );
                } else {
                  await breakApply(controller: controller, context: context);
                }
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                      (Set<WidgetState> states) {
                    return Colors.transparent;
                  },
                ),
              ),
              child: FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (controller.breakTimeRunning.value)
                      SvgPicture.asset(
                        "assets/images/end-break.svg",
                        width: 24.h,
                      )
                    else
                      SvgPicture.asset(
                        "assets/images/mug-hot-break-white.svg",
                        width: 24.h,
                      ),
                    SizedBox(width: 8.w),
                    Text(
                      controller.breakTimeRunning.value ? "End Break" : "Start Break",
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

  Future<void> breakApply({required CheckInController controller, required BuildContext context}) async {
    context.loaderOverlay.show();
    // bool connection = await ConnectivityService().check();
    // if(connection) {
      String empId = Get.find<UserAuthController>().userData.value.userData?.employeeId ?? '--';
      String compId = Get.find<UserProfileController>().userData.value.result.companyId?.toString() ?? '';
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd').format(now);
      String formattedTime = DateFormat('HH:mm:ss').format(now);
      BreakRequestModel breakRequestModel = BreakRequestModel(
        employeeId: empId,
        breakType: controller.breakTimeRunning.value ? BreakType.endBreak : BreakType.startBreak,
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
        punchState: controller.breakTimeRunning.value ? "breakOut" : "breakIn",
      );

      try {
        Map<String, dynamic> resp = await ApiServices.sendBreakDetails(breakRequest: breakRequestModel);
        AttendanceCommonWidgets().printF("-------break resp-----------$resp");
        if(resp['status'] == 200) {
          await PunchDatabase.instance.create(punch.copy(isSynced: 1));
          await controller.getCheckInData(compId: compId, empId: empId);
          await Get.find<HomeController>().getTimer();
          HapticFeedback.lightImpact();
          context.loaderOverlay.hide();
          UploadSuccessDialog().showWarn(context: context, message: controller.breakTimeRunning.value ? "Break started" : "Break ended");
        } else {
          HapticFeedback.lightImpact();
          context.loaderOverlay.hide();
          ErrorDialog().showWarn(context: context, title: resp?['message']?.toString() ?? (controller.breakTimeRunning.value ? "Failed to end break" : "Failed to start break"));
        }
      } catch(e) {
        await PunchDatabase.instance.create(punch.copy(isSynced: 0));
        await controller.getCheckInData(compId: compId, empId: empId);
        await Get.find<HomeController>().getTimer();
        HapticFeedback.lightImpact();
        context.loaderOverlay.hide();
        UploadSuccessDialog().showWarn(context: context, message: controller.breakTimeRunning.value ? "Break started" : "Break ended");
        // ErrorDialog().showWarn(context: context, title: "Failed", subTitle: "Something went wrong.");
      }
    // } else {
    //   HapticFeedback.lightImpact();
    //   context.loaderOverlay.hide();
    //   ErrorDialog().showWarn(context: context, title: "Failed", subTitle: "No internet connection.");
    // }
  }
}
