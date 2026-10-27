import 'dart:io';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loyaltri_minimal/View/CWidgets/cwidgets.dart';
import 'package:loyaltri_minimal/View/CWidgets/cwidgets.dart';
import 'package:loyaltri_minimal/View/field/features/tracking/services/background_services.dart';
import 'package:loyaltri_minimal/View/field/features/tracking/services/database_services.dart';
import 'package:loyaltri_minimal/View/splash.dart';
import 'package:loyaltri_minimal/controller/ui_controller/home_controller.dart';
import 'package:loyaltri_minimal/controller/ui_controller/page_controller.dart';
import 'package:loyaltri_minimal/services/controller_handling.dart';
import 'package:loyaltri_minimal/services/flutter_secure_storage.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';
import 'controller/network_controller.dart';
import 'firebase_options.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
as bg;

List<CameraDescription>? cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //------ loyaltri field -------//
  // Register Android background geolocation headless task
  bg.BackgroundGeolocation.registerHeadlessTask(headlessTask);
  // Spin up SQLite database setup
  await DatabaseService.instance.database;
  //------ loyaltri field -------//

  try {
    if (!Firebase.apps.any((app) => app.name == defaultFirebaseAppName)) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (e) {
    debugPrint('Firebase initializeApp notice: $e');
  }
  // await Upgrader.clearSavedSettings();
  final secureStorageUtil = SecureStorageUtils();
  await secureStorageUtil.initialize();
  
  HttpOverrides.global = MyHttpOverrides();
  cameras = await availableCameras();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]);
  // SystemChrome.setSystemUIOverlayStyle(
  //   systemUiOverlayStyleDark,
  // );
  runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      overlayWidgetBuilder: (_) {
        return Center(
          child: SpinKitThreeInOut(color: ColorUtils.primaryBlue, size: 28.w),
        );
      },
      child: ScreenUtilInit(
        designSize: const Size(375, 794),
        builder: (ctx, child) {
          return MediaQuery(
            data: MediaQuery.of(
              ctx,
            ).copyWith(textScaler: const TextScaler.linear(1.0)),
            child: GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Loyaltri',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              navigatorObservers: [],
              onInit: () {
                HandleControllers.createGetControllers();
              },
              builder: (context, widget) {
                final networkController = Get.find<NetworkController>();

                return ValueListenableBuilder(
                  valueListenable: uiNotifier,
                  builder: (context, value, child) {
                    return AnnotatedRegion<SystemUiOverlayStyle>(
                      value: value == AppView.employee ? systemUiOverlayStyleDark : systemUiOverlayStyleLight,
                      child: Overlay(
                        initialEntries: [
                          OverlayEntry(
                            builder: (context) => Obx(() => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                              padding: EdgeInsets.only(
                                bottom: networkController.showSnackBar.value ? 20.h : 0,
                              ),
                              child: MediaQuery(
                                data: MediaQuery.of(context).copyWith(
                                  textScaler: const TextScaler.linear(1.0),
                                ),
                                child: widget!,
                              ),
                            )),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              home: const SplashScreen(),
            ),
          );
        },
      ),
    );
  }
}
