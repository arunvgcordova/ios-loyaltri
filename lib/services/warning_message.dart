
import 'dart:io';
// import 'package:datetime_setting/datetime_setting.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/CWidgets/cwidgets.dart';
import 'package:loyaltri_minimal/View/splash.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import '../View/Login/Login_Screen.dart';
import '../controller/locationFetchController.dart';

// class WarningMessage extends StatefulWidget {
//   final bool? isLocation;
//   const WarningMessage({
//     super.key,
//     this.isLocation,
//   });

//   @override
//   State<WarningMessage> createState() => _WarningMessageState();
// }

// class _WarningMessageState extends State<WarningMessage> {

//   @override
//   void dispose() {
//     Get.find<LocationFetchController>().onInit();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     if (widget.isLocation!) {
//       getLoc();
//     }
//     super.initState();
//   }

//   getLoc() async {
//     if(mounted) {
//       await _checkPermissions().then((noPermission) async {
//         if (!noPermission) {
//           if (await Permission.locationWhenInUse.serviceStatus.isDisabled) {
//             try {
//               Position position = await Geolocator.getCurrentPosition();
//             } catch (e) {
//               if (kDebugMode) {
//                 print(e.toString());
//               }
//             }
//             getLoc();
//           } else {
//             Get.find<LocationFetchController>().periodicFetchPermission();
//             Get.back();
//           }
//         }
//       });
//     }
//   }

//   Future<bool> _checkPermissions() async {
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return true;
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       return true;
//     }
//     return false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: true,
//       onPopInvoked: (_) {
//         Get.find<LocationFetchController>().periodicFetchPermission();
//       },
//       child: Scaffold(
//         body: Container(
//           decoration: const BoxDecoration(
//             color: Colors.black
//               // image: DecorationImage(
//               //     image: AssetImage('assets/images/background.png'),
//               //     fit: BoxFit.cover),
//           ),
//           child: Stack(
//             alignment: Alignment.center,
//             children: [
//               Align(
//                 alignment: const Alignment(0, -0.6),
//                 child: Text(
//                   'WARNING',
//                   style: GoogleFonts.poppins(
//                       fontSize: 24,
//                       color: Colors.red,
//                       fontWeight: FontWeight.w700),
//                 ),
//               ),
//               const Image(image: AssetImage('assets/images/img2.png')),
//               Positioned(
//                 bottom: 200.h,
//                 child: SizedBox(
//                   width: 250,
//                   child: Center(
//                       child: Text(
//                     widget.isLocation!
//                         ? 'Please Allow Location Permission'
//                         : 'Please Turn ON your Automatic set Date & Time',
//                     textAlign: TextAlign.center,
//                     style: GoogleFonts.poppins(
//                         fontSize: 14,
//                         color: const Color(0xFF3392BE),
//                         fontWeight: FontWeight.w400),
//                   )),
//                 ),
//               ),
//               Positioned(
//                 bottom: 40.h,
//                 child: SizedBox(
//                   width: ScreenUtil().screenWidth * 0.9,
//                   child: ElevatedButton(
//                     onPressed: () async {
//                       if (widget.isLocation != null) {
//                         widget.isLocation!
//                             ? await Geolocator.openAppSettings()
//                             : await DatetimeSetting.openSetting();
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                         backgroundColor: ColorUtils.primaryBlue, elevation: 0),
//                     child: const Text('Open Settings', style: TextStyle(color: Colors.white),),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


class InternetWarningMessage extends StatelessWidget {
  const InternetWarningMessage({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        canPop: false,
        child: Container(
          decoration: const BoxDecoration(
              color: Colors.black
            // image: DecorationImage(
            //     image: AssetImage('assets/images/background.png'),
            //     fit: BoxFit.cover),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: const Alignment(0, -0.6),
                child: Text(
                  'WARNING',
                  style: GoogleFonts.poppins(
                      fontSize: 24,
                      color: Colors.red,
                      fontWeight: FontWeight.w700),
                ),
              ),
              // const Image(image: AssetImage('assets/images/img2.png')),
              Icon(Icons.warning_amber, color: Colors.white, size: 300.h),
              Positioned(
                bottom: 200.h,
                child: SizedBox(
                  width: 250,
                  child: Center(
                      child: Text(
                        "No Internet Connection",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                      )),
                ),
              ),
              Positioned(
                bottom: 100.h,
                child: SizedBox(
                  width: ScreenUtil().screenWidth * 0.9,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(newSlideNavigation(const SplashScreen()), (route) => false);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ColorUtils.primaryBlue, elevation: 0),
                    child: const Text('Try Again...', style: TextStyle(color: Colors.white),),
                  ),
                ),
              ),
              Positioned(
                bottom: 30.h,
                child: SizedBox(
                  width: ScreenUtil().screenWidth * 0.9,
                  child: ElevatedButton(
                    onPressed: () {
                      exit(0);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ColorUtils.primaryBlue, elevation: 0),
                    child: const Text('Close App', style: TextStyle(color: Colors.white),),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
