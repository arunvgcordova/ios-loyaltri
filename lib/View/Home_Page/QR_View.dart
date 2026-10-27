
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/CWidgets/cwidgets.dart';
import 'package:loyaltri_minimal/View/field/features/tracking/tracker_controller.dart';
import 'package:loyaltri_minimal/View/menu_page.dart';
import 'package:loyaltri_minimal/controller/locationFetchController.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/attendanceUploadController.dart';
import '../../controller/ui_controller/home_controller.dart';
import '../../controller/userAuthentication.dart';
import '../../models/checkIn_model.dart';
import '../../services/connectivity_service.dart';
import '../../services/flutter_secure_storage.dart';
import '../CWidgets/error_dialog.dart';
import '../Work_Entry/work_entry_widgets/alert_dialogue.dart';

class QRCheckInView extends StatefulWidget {
  final String whichCheck;
  final bool isCheckIn;
  const QRCheckInView({super.key, required this.whichCheck, required this.isCheckIn});

  @override
  State<QRCheckInView> createState() => _QRCheckInViewState();
}

class _QRCheckInViewState extends State<QRCheckInView> {
  AttendanceUploadController attendanceUploadController = Get.find<AttendanceUploadController>();
  UserAuthController userAuthController = Get.find<UserAuthController>();
  LocationFetchController locationFetchController = Get.find<LocationFetchController>();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  ValueNotifier<bool> flashState = ValueNotifier(false);
  Barcode? result;
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: <Widget>[
            SizedBox(
              height: ScreenUtil().screenHeight,
              child: QRView(
                key: qrKey,
                onQRViewCreated: (QRViewController controller) {
                  this.controller = controller;
                  controller.scannedDataStream.listen((scanData) async {
                    setState(() {
                      result = scanData;
                    });
                    if (result != null) {
                      controller.dispose();
                      DateTime punchDate = DateTime.now();
                      final SecureStorageUtils prefs = SecureStorageUtils();
                      // await locationFetchController.fetchLocationData();
                      // bool connection = await ConnectivityService().check();
                      // if(!connection) {
                      //   Navigator.of(context).pop();
                      //   await ErrorDialog().internetWarn(
                      //     context: context,
                      //     title: "No Internet Connection",
                      //     subTitle: "Please check if your connection is stable.",
                      //   );
                      // } else {
                        String? latitude = locationFetchController.position.value?.latitude.toString();
                        String? longitude = locationFetchController.position.value?.longitude.toString();
                        String? locName = locationFetchController.locName.value;

                        try {
                          if((latitude == null || latitude == 'null') && (longitude == null || longitude == 'null')) {
                            Position? position = await locationFetchController.fetchCurrentLocation();
                            latitude = position?.latitude.toString();
                            longitude = position?.longitude.toString();
                          }

                          if(locName == null) {
                            String? locationName = await locationFetchController.fetchCurrentLocName(lat: latitude!, long: longitude!);
                            locName = locationName;
                          }
                        } catch(e) {}

                        // await locationFetch.fetchLocationData();
                        if(latitude != null && longitude != null) {
                          String? punchTime = await prefs.getString("punch");
                          AttendanceCheckModel attData = AttendanceCheckModel(
                            employeeId: userAuthController.userData.value.userData?.employeeId ?? '--',
                            companyId: Get.find<UserProfileController>().userData.value.result.companyId?.toString() ?? '',
                            punchDate: DateFormat('yyyy-MM-dd').format(punchDate),
                            punchTime: DateFormat('HH:mm:ss').format(punchDate),
                            latitude: latitude,
                            longitude: longitude,
                            locationName: locName,
                            punchState: widget.isCheckIn ? "punchIn" : "punchOut",
                          );
                          await attendanceUploadController.sendAttendance(attendance: attData);
                           final trackingCtr = Get.isRegistered<TrackingController>()
                                                        ? Get.find<TrackingController>()
                                                         : Get.put(TrackingController());
                                          final workStatus =await  trackingCtr.checkEmployeWorkStatus();
                                          if(workStatus){
                                            return;
                                          }
                          if(attendanceUploadController.errorMsg.value == null) {
                            // await Get.find<HomeController>().getHomeData();
                            if (punchTime != null) {
                              await prefs.remove('punch');
                              // await prefs.remove("punch");
                              await HapticFeedback.lightImpact();
                              if (!mounted) return;
                              ShowWarnDialog().showWarn(context: context, whichCheck: widget.whichCheck);
                              Timer.periodic(const Duration(seconds: 3), (timer) {
                                timer.cancel();
                                Navigator.of(context).pushAndRemoveUntil(
                                  newSlideNavigation(const MenuPage(afterCheck: true)), (route) => false);
                              });
                            } else {
                              // await prefs.setString("punch", "$punchDate");
                              await HapticFeedback.lightImpact();
                              if (!mounted) return;
                              ShowWarnDialog().showWarn(context: context, whichCheck: widget.whichCheck);
                              Timer.periodic(const Duration(seconds: 3), (timer) {
                                timer.cancel();
                                Navigator.of(context).pushAndRemoveUntil(
                                  newSlideNavigation(const MenuPage(afterCheck: true)), (route) => false);
                              });
                            }
                          } else {
                            await HapticFeedback.lightImpact();
                            String? msg = Get.find<AttendanceUploadController>().errorMsg.value == 'msg' ? "${punchTime == null ? 'Check in' : 'Check out'} is not allowed within 3 minutes after ${punchTime == null ? 'checkout' : 'check in'}. Please try again later." : null;
                            if (!mounted) return;
                            ErrorDialog().showWarn(context: context, title: punchTime == null ? "Check In Failed!" : "Check Out Failed!", subTitle: msg ?? "Something went wrong");
                            // Timer.periodic(const Duration(seconds: 3), (timer) {
                            //   timer.cancel();
                            //   Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const MenuPage()), (route) => false);
                            // });
                          }
                        } else {
                          ErrorDialog().showWarn(context: context, title: "Failed", subTitle: "Location data not fetched.");
                          await locationFetchController.initialize();
                        }
                      // }
                    }
                  });
                },
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 200.w,
                height: 200.w,
                child: CustomPaint(
                  painter: SquareBoxCamera(),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                  onPressed: () async {
                    await controller!.toggleFlash();
                    flashState.value = await controller!.getFlashStatus() ?? false;
                  },
                  icon: ValueListenableBuilder(
                    valueListenable: flashState,
                    builder: (BuildContext context, value, Widget? child) {
                      return Icon(
                        value ? Icons.flash_on : Icons.flash_off,
                        color: ColorUtils.textWhite,
                      );
                    },
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
class SquareBoxCamera extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.w;

    final path1 = Path()
      ..moveTo(size.width * 0.9, size.height * 0.0)
      ..lineTo(size.width * 0.95, size.height * 0.0)
      ..arcToPoint(Offset(size.width * 1, size.height * 0.05), radius: Radius.circular(10.sp), clockwise: true)
      ..lineTo(size.width * 1, size.height * 0.1);

    final path2 = Path()
      ..moveTo(size.width * 1, size.height * 0.9)
      ..lineTo(size.width * 1, size.height * 0.95)
      ..arcToPoint(Offset(size.width * 0.95, size.height * 1), radius: Radius.circular(10.sp), clockwise: true)
      ..lineTo(size.width * 0.9, size.height * 1);

    final path3 = Path()
      ..moveTo(size.width * 0.1, size.height * 1)
      ..lineTo(size.width * 0.05, size.height * 1)
      ..arcToPoint(Offset(size.width * 0.0, size.height * 0.95), radius: Radius.circular(10.sp), clockwise: true)
      ..lineTo(size.width * 0.0, size.height * 0.9);

    final path4 = Path()
      ..moveTo(size.width * 0.0, size.height * 0.1)
      ..lineTo(size.width * 0.0, size.height * 0.05)
      ..arcToPoint(Offset(size.width * 0.05, size.height * 0.0), radius: Radius.circular(10.sp), clockwise: true)
      ..lineTo(size.width * 0.1, size.height * 0.0);

    canvas.drawPath(path1, paint1);
    canvas.drawPath(path2, paint1);
    canvas.drawPath(path3, paint1);
    canvas.drawPath(path4, paint1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
