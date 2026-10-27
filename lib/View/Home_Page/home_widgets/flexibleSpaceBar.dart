import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/Home_Page/home_widgets/break_button.dart';
import 'package:loyaltri_minimal/View/Home_Page/home_widgets/checkButtonHome.dart';
import 'package:loyaltri_minimal/View/Home_Page/home_widgets/checkInButtonHome.dart';
import 'package:loyaltri_minimal/View/Home_Page/home_widgets/timerRow.dart';
import 'package:loyaltri_minimal/View/Home_Page/home_widgets/totalBreakHour.dart';
import 'package:loyaltri_minimal/controller/checkInController.dart';
import 'package:loyaltri_minimal/controller/punchTypeController.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';
import 'package:loyaltri_minimal/models/user_profile_api_model.dart';
import '../../../utils/color_utils.dart';

class FlexibleSpaceBarHome extends StatelessWidget {
  final String punchTime;
  const FlexibleSpaceBarHome({super.key, required this.punchTime});

  @override
  Widget build(BuildContext context) {
    CheckInController checkInController = Get.find<CheckInController>();
    String? checkInTime;
    try {
      // checkInTime = DateFormat('hh:mm a').format(DateTime.parse(checkInController.checkInData.value.result.checkInTime!));
      checkInTime = checkInController.checkInData.value.result.checkInTime;
    } catch(e) {}
    return Padding(
      padding: const EdgeInsets.only(top: 70, left: 20, right: 20).w,
      child: Column(
        children: [
          Divider(
            thickness: 1.w,
            color: ColorUtils.textWhite.withOpacity(0.21),
          ),
          const Spacer(flex: 10),
          GetX<UserProfileController>(
            builder: (UserProfileController controller) {
              List<ShiftData>? shift = controller.userData.value.result.employeeShift;
              if(shift != null) {
                return Row(
                  children: [
                    Text(
                      shift.isNotEmpty ? shift.first.shift : "No Shift",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                        color: ColorUtils.textWhite.withOpacity(0.6),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    if(shift.isNotEmpty && shift.first.shiftTimeRemarks != null)
                      Container(
                        // height: 22.w,
                        decoration: BoxDecoration(
                            color: ColorUtils.textWhite.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(38).w),
                        padding:
                        const EdgeInsets.only(left: 8, right: 8, top: 3, bottom: 3)
                            .w,
                        child: Text(
                          shift.isNotEmpty
                              ? shift.first.shiftTimeRemarks ?? "----"
                              : "----",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                            color: ColorUtils.textWhite,
                          ),
                        ),
                      ),
                  ],
                );
              } else {
                return Container();
              }
            },
          ),
          const Spacer(flex: 10),
          Row(
            children: [
              Image.asset(
                "assets/images/calendar2-3d.webp",
                width: 20.w,
              ),
              SizedBox(width: 5.w),
              Text(
                DateFormat('dd').format(DateTime.now()),
                style: GoogleFonts.poppins(
                  color: ColorUtils.textWhite,
                  fontWeight: FontWeight.w700,
                  fontSize: 12.sp,
                ),
              ),
              Text(
                " ${DateFormat('MMM yyyy').format(DateTime.now())}",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: 12.sp,
                  color: ColorUtils.textWhite,
                ),
              ),
              SizedBox(width: 10.w),
              if (punchTime != "")
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "assets/images/attendance-3d.webp",
                      width: 20.w,
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      "Last Check In",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                        color: ColorUtils.textWhite.withOpacity(0.6),
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      checkInTime?.toAmPm() ?? '',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                        color: ColorUtils.textWhite,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const Spacer(flex: 15),
          if(checkInController.breakTimeDuration.value != "")
            TotalBreakHour(breakDuration: checkInController.breakTimeDuration.value),
          if(checkInController.breakTimeDuration.value != "")
            const Spacer(flex: 15),
          // GetX<CheckInController>(
          //   builder: (CheckInController controller) {
          //     if(controller.breakTimeDuration.value != "") {
          //       return Column(
          //         mainAxisSize: MainAxisSize.min,
          //         children: [
          //           TotalBreakHour(breakDuration: controller.breakTimeDuration.value),
          //           const Spacer(flex: 15),
          //         ],
          //       );
          //     } else {
          //       return Container();
          //     }
          //   },
          // ),
          if (punchTime != "") TimerRow(punchTime: punchTime),
          if (punchTime == "")
            Row(
              children: [
                StreamBuilder<DateTime>(
                  stream: Stream<DateTime>.periodic(
                      const Duration(seconds: 1), (_) => DateTime.now()),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      DateTime currentTime = snapshot.data!;
                      String formattedTime =
                          DateFormat('hh:mm a').format(currentTime);
                      return Text(
                        formattedTime,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 28.sp,
                          color: ColorUtils.textWhite,
                        ),
                      );
                    } else {
                      return Container(
                          height: 40.h); // Placeholder while waiting for data
                    }
                  },
                ),
              ],
            ),
          const Spacer(flex: 20),
          GetX<PunchTypeController>(
            builder: (PunchTypeController controller) {
              bool isPunchMethodsEmpty = controller.checkInMethods.value.isEmpty || controller.checkOutMethods.value.isEmpty;
              return Row(
                children: [
                  if(punchTime != "")
                    if(Get.find<UserProfileController>().userData.value.result.breakAccess == "1")
                      BreakButtonHome(isPunchMethodsEmpty: isPunchMethodsEmpty)
                    else
                      Container()
                  else
                    CheckInButtonHome(isChecked: punchTime != "", isPunchMethodsEmpty: isPunchMethodsEmpty),
                  if(!checkInController.breakTimeRunning.value)
                    if(punchTime != "")
                      if(Get.find<UserProfileController>().userData.value.result.breakAccess == "1")
                        SizedBox(width: 10.w),
                  if(!checkInController.breakTimeRunning.value)
                    if(punchTime != "")
                      CheckButtonHome(isChecked: punchTime != "", isPunchMethodsEmpty: isPunchMethodsEmpty),
                ],
              );
            }
          ),
          const Spacer(flex: 30),
        ],
      ),
    );
  }
}
