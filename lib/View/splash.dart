import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/CWidgets/cwidgets.dart';
import 'package:loyaltri_minimal/View/Login/Login_Screen.dart';
import 'package:loyaltri_minimal/View/menu_page.dart';
import 'package:loyaltri_minimal/controller/network_controller.dart';
import 'package:loyaltri_minimal/controller/ui_controller/page_controller.dart';
import 'package:loyaltri_minimal/utils/security_frida.dart';
import 'package:matomo_tracker/matomo_tracker.dart';
import '../controller/locationFetchController.dart';
import '../controller/ui_controller/home_controller.dart';
import '../controller/userAuthentication.dart';
import '../models/user_api_model.dart';
import '../services/flutter_secure_storage.dart';
import '../utils/api_constants.dart';
import '../utils/color_utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Future<void> _navigation() async {
    Get.find<NetworkController>().networkListener();
    UserAPI? user = await SecureStorageUtils().getUserData();
    await MatomoTracker.instance.initialize(
      siteId: ApiConstants.matomoSiteId,
      url: ApiConstants.matomoUrl,
    );

    if (user != null) {
      UserAuthController controller = Get.find<UserAuthController>();
      await controller.fetchUser(user: user).then((value) async {
        // HomeController homeController = Get.find<HomeController>();
        // await homeController.getHomeData();

        if (user.userData?.employeeId != null &&
            user.userData!.employeeId!.isNotEmpty) {
          MatomoTracker.instance.setVisitorUserId(user.userData!.employeeId!);
        }

        if (controller.userData.value.userData?.loginType == 1) {
          Get.find<UserPageController>().setPages(AppView.employee);
        }
        if (controller.userData.value.userData?.loginType == 2) {
          Get.find<UserPageController>().setPages(AppView.manager);
        }
        if (controller.dataLoaded.value) {
          Navigator.of(context).pushAndRemoveUntil(
            fadeNavigation(MenuPage()),
            (route) => false,
          );
        }
      });
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        fadeNavigation(LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  void initState() {
    Get.find<UserPageController>().setPages(AppView.employee);
    _navigation();
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      SecurityCheckFrida().checkSecurity();
    });
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorUtils.workEntryHead,
        extendBody: true,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Loyaltri",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 28.sp,
                  color: ColorUtils.textWhite,
                ),
              ),
              SizedBox(height: 20.w),
              SizedBox(
                width: 20.w,
                height: 20.w,
                child: const CircularProgressIndicator(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
