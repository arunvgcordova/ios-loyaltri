import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/CWidgets/cwidgets.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Task/Manager_Task_Screen.dart';
import 'package:loyaltri_minimal/View/My_Request/My_request.dart';
import 'package:loyaltri_minimal/View/field/features/home/home_screen.dart';
// import '../OldMyRequest/My_request.dart';
import 'package:loyaltri_minimal/controller/ui_controller/home_controller.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';
import '../Air_Ticket/AirTicketHome.dart';
import '../Excuse_Page/Excuse_Page.dart';
import '../Growth/growth_home.dart';
import '../Leave_Page/Leave_Page.dart';
import '../My_Pay/My_Pay.dart';
import '../My_Request/controller/my_request_controller.dart';
// import '../OldMyRequest/controller/myRequestController.dart';
import '../My_Schedule/My_Schedule_Page.dart';
import '../Work_Entry/Work_Entry.dart';
import '../Work_Expenses/My_Work_Expenses.dart';

class Services extends StatefulWidget {
  const Services({super.key});

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(10.0).w,
        child: GetX<UserProfileController>(
          builder: (UserProfileController controller) {
            return GridView.builder(
              itemCount: controller.serviceActions.value.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, crossAxisSpacing: 19.w, mainAxisSpacing: 15.w),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if (controller.serviceActions.value[index].id == 1) {
                      Navigator.of(context).push(
                        newSlideNavigation(const LeavePage()),
                      );
                    }
                    if (controller.serviceActions.value[index].id == 2) {
                      Navigator.of(context).push(
                        newSlideNavigation(const WorkEntry(isQuickActionEnable: false)),
                      );
                    }
                    if (controller.serviceActions.value[index].id == 3) {
                      Navigator.of(context).push(
                          newSlideNavigation(const MyWorkExpenses(isQuickActionEnable: false)),
                      );
                    }
                    if (controller.serviceActions.value[index].id == 4) {
                      Navigator.of(context).push(
                        newSlideNavigation(const MyPay()),
                      );
                    }
                    if (controller.serviceActions.value[index].id == 5) {
                      Navigator.of(context).push(
                        newSlideNavigation(const MyExcuse()),
                      );
                    }
                    if (controller.serviceActions.value[index].id == 6) {
                      // Get.find<MyRequestFilterController>().resetFilter();
                      Get.find<MyRequestControllerNew>().resetFilter();
                      Get.find<MyRequestControllerNew>().resetFilter();
                      Navigator.of(context).push(
                          newSlideNavigation(const MyRequest()),
                      );
                    }
                    if (controller.serviceActions.value[index].id == 7) {
                      Navigator.of(context).push(
                        newSlideNavigation(const MySchedule())
                      );
                    }
                    if (controller.serviceActions.value[index].id == 8) {
                      Navigator.of(context).push(
                          newSlideNavigation(const AirTicketHome()),
                      );
                    }
                    if (controller.serviceActions.value[index].id == 9) {
                      Navigator.of(context).push(
                          newSlideNavigation(TaskScreen(fromEmployee: true)),
                      );
                    }
                    if (controller.serviceActions.value[index].id == 10) {
                      Navigator.of(context).push(
                        fadeNavigation(GrowthScreen())
                      );
                    }
                    if (controller.serviceActions.value[index].id == 11) {
                      Navigator.of(context).push(
                          fadeNavigation((FieldHomeScreen()))
                      ).then((_) {
                        if (Get.isRegistered<HomeController>()) {
                          Get.find<HomeController>().fetchWorkLogByDate();
                        }
                      });
                    }
                  },
                  child: Container(
                    width: 100.w,
                    height: 100.w,
                    decoration: BoxDecoration(
                        color: ColorUtils.foregroundBlack,
                        borderRadius: BorderRadius.circular(18).w),
                    child: Column(
                      children: [
                        Flexible(flex: 3, child: Container()),
                        Image.asset(
                          controller.serviceActions.value[index].svgIcon,
                          width: 30.w,
                        ),
                        Flexible(flex: 1, child: Container()),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10).w,
                          child: Text(
                            controller.serviceActions.value[index].title,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              color: ColorUtils.textWhite,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Flexible(flex: 3, child: Container()),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
