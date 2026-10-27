import 'dart:async';
import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:datetime_setting/datetime_setting.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:loyaltri_minimal/View/CWidgets/error_dialog.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/services/connectivity_service.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';
import 'package:loyaltri_minimal/utils/security_frida.dart';
import 'package:ntp/ntp.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:safe_device/safe_device.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/warning_message.dart';
import 'package:loyaltri_minimal/controller/userAuthentication.dart';
import 'package:loyaltri_minimal/controller/network_controller.dart';
import 'package:loader_overlay/loader_overlay.dart';

class LocationFetchController extends GetxController {
  Rx<bool> isLoading = false.obs;
  Rx<bool> dataLoaded = false.obs;
  Rx<bool> isError = false.obs;
  Rx<bool> showErrorPop = false.obs;
  Rx<bool> showingPermissionPopUp = false.obs;
  Rx<bool> requestedOnce = false.obs;
  Rx<String?> locName = Rx<String?>(null);
  Rx<Position?> position = Rx<Position?>(null);
  // Position? position;
  RxMap<dynamic, dynamic> location = {}.obs;

  void resetStatus() {
    isLoading.value = false;
    isError.value = false;
  }

  resetLoc() {
    position.value = null;
    locName.value = null;
  }

  // @override
  // void onInit() {
  //   initialize();
  //   // _initialize();
  //   super.onInit();
  // }

  // initialize() async {
  //   await _checkPermissions().then((noPermission) async {
  //     if (noPermission) {
  //       Get.to(() => const WarningMessage(isLocation: true));
  //       // await Navigator.of(context).push(MaterialPageRoute(
  //       //     builder: (context) => const WarningMessage(
  //       //       isLocation: true,
  //       //     )));
  //     } else {
  //       LocationSettings locationSettings = const LocationSettings(
  //         accuracy: LocationAccuracy.low,
  //         distanceFilter: 250,
  //       );
  //
  //       try {
  //         Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position newPosition) async {
  //           AttendanceCommonWidgets().printF("--------newPosition-----------$newPosition");
  //           position.value = newPosition;
  //           List<Placemark> placemarks = await placemarkFromCoordinates(position.value!.latitude, position.value!.longitude);
  //           locName.value = "${placemarks[0].name}, ${placemarks[0].locality}, ${placemarks[0].country} - ${placemarks[0].postalCode}";
  //         });
  //       } catch(e) {}
  //       dataLoaded.value = true;
  //       // await Future.delayed(const Duration(seconds: 1));
  //       // onInit();
  //     }
  //   });
  //
  //   await _timeZonePermission().then((noPermission) async {
  //     if (noPermission) {
  //       Get.to(() => const WarningMessage(isLocation: false));
  //       // await Navigator.of(context).push(MaterialPageRoute(
  //       //     builder: (context) => const WarningMessage(
  //       //       isLocation: false,
  //       //     )));
  //     }
  //   });
  // }

  StreamSubscription<Position>? _positionSubscription;

  initialize() async {
    if(Get.isDialogOpen ?? false) {
      Get.back();
      initialize();
      return;
    }
    requestedOnce.value = false;
    resetLoc();

    Platform.isIOS ? await _checkPermissionsIOS() : await _checkPermissions();
    await _timeZonePermission();

    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 10,
      // timeLimit: Duration(seconds: 3),
    );
    DateTime? lastGeocodeTime;

    try {
      if(_positionSubscription != null) {
        _positionSubscription?.cancel();
        _positionSubscription = null;
      }
      _positionSubscription = Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position? newPosition) async {
        AttendanceCommonWidgets().printF(
          "--------newPosition-----------$newPosition",
        );        // if(newPosition?.latitude == null || newPosition?.longitude == null) {
        //   Get.to(() => const WarningMessage(isLocation: true));
        // }
        position.value = newPosition;
        // List<Placemark> placemarks = await placemarkFromCoordinates(position.value!.latitude, position.value!.longitude);
        // locName.value = "${placemarks[0].name}, ${placemarks[0].locality}, ${placemarks[0].country} - ${placemarks[0].postalCode}";
        if (lastGeocodeTime == null || DateTime.now().difference(lastGeocodeTime!) > const Duration(seconds: 30)) {
          lastGeocodeTime = DateTime.now();
          if(position.value != null) {
            await fetchCurrentLocName(lat: position.value!.latitude.toString(), long: position.value!.longitude.toString());
          }
        }
      }, cancelOnError: true);
    } catch(e) {
      AttendanceCommonWidgets().printF("----------loc fetch error----------");
    }
    dataLoaded.value = true;
    // if(Platform.isAndroid) {
    periodicFetchPermission();
    // }
    // await Future.delayed(const Duration(seconds: 1));
    // onInit();
  }

  Future<Position?> fetchCurrentLocation() async {
    try {
      Position value = await Geolocator.getCurrentPosition();
      return value;
    } catch(e) {}
    return null;
  }

  Future<String?> fetchCurrentLocName({required String lat, required String long}) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        double.parse(lat),
        double.parse(long),
      );
      locName.value = "${placemarks[0].name}, ${placemarks[0].locality}, ${placemarks[0].country} - ${placemarks[0].postalCode}";
      AttendanceCommonWidgets().printF("Location Name : ${locName.value}");
    } catch (geocodingError) {
      AttendanceCommonWidgets().printF("Geocoding error: $geocodingError");
      locName.value = null;
      // Handle geocoding errors here (e.g., show a message to the user)
    }
    return locName.value;
  }

  Timer? timer;

  void periodicFetchPermission() {
    showingPermissionPopUp.value = false;
    timer?.cancel();
    bool loopFinished = true;
    bool isInternetWarningActive = false;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      // bool connection = await ConnectivityService().check();
      if(loopFinished) {
        loopFinished = false;

        // Dismiss popup and skip all validation checks when the user is logged out
        if (Get.find<UserAuthController>().userData.value.userData == null) {
          if (showingPermissionPopUp.value) {
            showingPermissionPopUp.value = false;
            if (Get.isDialogOpen ?? false) {
              Get.back();
            }
          }
          loopFinished = true;
          return;
        }

        // bool noPermission = Platform.isIOS ? await _checkPermissionsIOS() : await _checkPermissions();
        bool noPermission = !await Permission.location.isGranted && !await Permission.locationWhenInUse.isGranted;
        bool timeZonePermission = await _timeZonePermission();      // if(!connection) {
        bool mockLocation = await checkMockLocationOn();

        bool offlineMode = false;
        try {
          offlineMode = Get.find<UserAuthController>().offlineMode;
        } catch (_) {}

        bool hasInternet = true;
        if (!offlineMode) {
          bool hardwareConnection = await ConnectivityService().check();
          if (!hardwareConnection) {
            hasInternet = false;
          } else {
            hasInternet = await ConnectivityService.goodConnection();
          }
        }

        //   timer.cancel();
        //   Get.to(() => const InternetWarningMessage());
        // } else
        if(noPermission) {
          if(!showingPermissionPopUp.value) {
            showingPermissionPopUp.value = true;
            ErrorDialog().permissionDialogue(
                title: "WARNING",
                subTitle: "Please ensure Location Permission is enabled in settings and that Location is turned on in the quick settings panel.\n"
                    "\nThis app uses your location to provide core functionality such as attendance marking, work entry, work expence. Without location access, the app cannot function.",
                okFunction: () async {
                  await Geolocator.openAppSettings().whenComplete(() async {
                    // periodicFetchPermission();
                    await initialize();
                  });
                },
                cancelFunction: () async {
                  Get.back();
                  // periodicFetchPermission();
                  await initialize();
                }
            );
          }
          // Get.to(() => const WarningMessage(isLocation: true));
        } else if(timeZonePermission) {
          if(!showingPermissionPopUp.value) {
            showingPermissionPopUp.value = true;
            ErrorDialog().permissionDialogue(
                title: "WARNING",
                subTitle: 'Please Turn ON your Automatic set Date & Time',
                okFunction: () async {
                  if(Platform.isIOS) {
                    // periodicFetchPermission();
                    if(await _timeZonePermission()) {
                      await openTimeSettings().whenComplete(() {
                        Get.back();
                        Get.back();
                        periodicFetchPermission();
                      },);
                    } else {
                      Get.back();
                    }
                  } else {
                    await DatetimeSetting.openSetting().whenComplete(() {
                      Get.back();
                      periodicFetchPermission();
                    });
                  }
                },
                cancelFunction: () async {
                  exit(0);
                }
            );
          }
          // Get.to(() => const WarningMessage(isLocation: false));
        } else if (mockLocation) {
          if (!showingPermissionPopUp.value) {
            showingPermissionPopUp.value = true;
            ErrorDialog().permissionDialogue(
              title: "WARNING",
              subTitle: 'Please Turn OFF Mock Location',
              okFunction: () async {
                // await openAppSettings();
                AppSettings.openAppSettings(type: AppSettingsType.developer);
              },
              cancelFunction: () async {
                exit(0);
              },
            );
          }
        } else if (!offlineMode && !hasInternet) {
          if (!showingPermissionPopUp.value) {
            showingPermissionPopUp.value = true;
            isInternetWarningActive = true;
            ErrorDialog().permissionDialogue(
              title: "WARNING",
              subTitle: 'Please enable Internet Connection (Wi-Fi or Mobile Data) and ensure you have an active network connection to use the app.',
              okFunction: () async {
                await AppSettings.openAppSettings(type: AppSettingsType.wifi).whenComplete(() {
                  Get.back();
                  periodicFetchPermission();
                });
              },
              cancelFunction: () async {
                exit(0);
              },
            );
          }
        } else {
          if (showingPermissionPopUp.value) {
            showingPermissionPopUp.value = false;
            if (Get.isDialogOpen ?? false) {
              Get.back();
            }
            if (isInternetWarningActive) {
              isInternetWarningActive = false;
              try {
                await Get.find<NetworkController>().refreshData();
              } catch (_) {}
            }
          }
        }

        loopFinished = true;
      }
    });
  }

  Future<void> openTimeSettings() async {
    final Uri url = Uri.parse('app-settings:');

    if (await canLaunchUrl(url)) {
      await launchUrl(url);

      // Show GetX dialog
      Get.dialog(
        AlertDialog(
          backgroundColor: ColorUtils.workEntryHead,
          title: Text('Enable Automatic Time', style: TextStyle(color: Colors.white)),
          content: Text(
              'Please go to Settings → General → Date & Time → Turn on "Set Automatically".', style: TextStyle(color: Colors.white)),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text('OK'),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    } else {
      AttendanceCommonWidgets().showGetSnackBar(
        title: 'Error',
        message: 'Could not open Settings',
        backgroundColor: Colors.red,
      );
    }
  }

  Future<bool> _checkPermissions() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      if (!requestedOnce.value) {
        requestedOnce.value = true;
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied) {
        return true;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return true;
    }

    if (await Permission.locationWhenInUse.serviceStatus.isDisabled) {
      try {
        if(!requestedOnce.value) {
          requestedOnce.value = true;
          Position loc = await Geolocator.getCurrentPosition();
          position.value = loc;
        }
      } catch (e) {
        AttendanceCommonWidgets().printF(e.toString());
      } finally {
        resetStatus();
      }
      return true;
    }
    return false;
  }

  Future<bool> _checkPermissionsIOS() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      if(!requestedOnce.value || Platform.isIOS) {
        requestedOnce.value = true;
        permission = await Geolocator.requestPermission();
      }
    }

    try {
      if(!requestedOnce.value || Platform.isIOS) {
        requestedOnce.value = true;
        Position loc = await Geolocator.getCurrentPosition();
        position.value = loc;
        if(loc.latitude != null) {
          return false;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        AttendanceCommonWidgets().printF(e.toString());
      }
    } finally {
      resetStatus();
    }
    return true;
  }

  Future<bool> _timeZonePermission() async {
    try {
      if(Platform.isIOS) {
        bool hasConnection = await ConnectivityService().check();
        if(hasConnection) {
          DateTime networkTime = await NTP.now();
          // AttendanceCommonWidgets().printF("Network Date time  --- $networkTime");

          DateTime deviceTime = DateTime.now();

          Duration difference = networkTime.difference(deviceTime).abs();

          if (difference.inMinutes > 1) {
            return true; // Time is tampered or significantly off
          }
        } else {
          return false;
        }
      } else {
        if(Platform.isAndroid) {
          bool timeAuto = await DatetimeSetting.timeIsAuto();
          bool timezoneAuto = await DatetimeSetting.timeZoneIsAuto();

          if (!timezoneAuto || !timeAuto) {
            return true;
          }
        }
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  Future<bool> checkMockLocationOn() async {
    bool isMockLocation = false;
    bool isNativeMockLocation = false;

    try {
      // Check via SafeDevice (may be false negative)
      isMockLocation = await SafeDevice.isMockLocation;

      // Native check via platform channel (Kotlin)
      // if (Platform.isAndroid) {
      //   isNativeMockLocation = await SecurityCheckFrida.isMockLocationEnabled();
      // }

      // Runtime check using geolocator (most accurate)
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        await Geolocator.requestPermission();
      }

      final position = await Geolocator.getCurrentPosition();
      if (position.isMocked) {
        isMockLocation = true;
      }

      // AttendanceCommonWidgets().printF(
      //   "Mock Location (SafeDevice): $isMockLocation",
      // );
      // AttendanceCommonWidgets().printF(
      //   "Mock Location (Native): $isNativeMockLocation",
      // );
      // AttendanceCommonWidgets().printF(
      //   "Mock Location (Geolocator): ${position.isMocked}",
      // );
    } catch (e) {
      AttendanceCommonWidgets().printF("Error checking mock location: $e");
    }

    return isMockLocation || isNativeMockLocation;
  }

  // Future<bool> checkMockLocationOn() async {
  //   bool isNatitiveMockLocation = false;

  //   bool isMockLocation = await SafeDevice.isMockLocation;

  //   if (Platform.isAndroid) {
  //     isNatitiveMockLocation = await SecurityCheckFrida.isMockLocationEnabled();
  //   }

  //   AttendanceCommonWidgets().printF(
  //     "mock location 1---------- $isMockLocation ",
  //   );
  //   // if (!isMockLocation) {
  //   //   final position = await fetchCurrentLocation();

  //   //   if (position != null) {
  //   //     isMockLocation = position.isMocked;
  //   //     AttendanceCommonWidgets().printF(
  //   //       "mock location 2---------- $isMockLocation ",
  //   //     );
  //   //   }
  //   // }
  //   // AttendanceCommonWidgets().printF(
  //   //   "mock location ---------- $isMockLocation ",
  //   // );
  //   return isMockLocation || isNatitiveMockLocation;
  // }

  Future<dynamic> fetchLocationData() async {
    if (Platform.isIOS) {
      bool noPermission =
      Platform.isIOS
          ? await _checkPermissionsIOS()
          : await _checkPermissions();
      if (noPermission) {
        await ErrorDialog().permissionDialogue(
          title: "WARNING",
          subTitle: "Please ensure Location Permission is enabled in settings and that Location is turned on in the quick settings panel.\n"
              "\nThis app uses your location to provide core functionality such as attendance marking, work entry, work expence. Without location access, the app cannot function.",
          okFunction: () async {
            await Geolocator.openAppSettings().whenComplete(() {
              periodicFetchPermission();
            });
          },
          cancelFunction: () async {
            Get.back();
            Get.find<LocationFetchController>().periodicFetchPermission();
          },
        );
      } else {
        isLoading.value = true;
        try {
          position.value = await Geolocator.getCurrentPosition();
          List<Placemark> placemarks = await placemarkFromCoordinates(position.value!.latitude, position.value!.longitude);
          locName.value = "${placemarks[0].name}, ${placemarks[0].locality}, ${placemarks[0].country} - ${placemarks[0].postalCode}";
          dataLoaded.value = true;
        } catch(e) {
          isError.value = true;
        } finally {
          resetStatus();
        }
      }
    } else {
      isLoading.value = true;
      try {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            showErrorPop.value = true;
            return Future.error('Location Permission Denied.');
          }
        }

        if (permission == LocationPermission.deniedForever) {
          // showErrorPop.value = true;
          // showPermissionDialogue(mainContext: context, title: "App need to access device location.", subTitle: "Please enable location permission.");
          return Future.error('Please enable location to continue');
        }

        position.value = await Geolocator.getCurrentPosition();
        List<Placemark> placemarks = await placemarkFromCoordinates(position.value!.latitude, position.value!.longitude);
        locName.value = "${placemarks[0].name}, ${placemarks[0].locality}, ${placemarks[0].country} - ${placemarks[0].postalCode}";
        dataLoaded.value = true;
        // return await Geolocator.getCurrentPosition();
      } catch(e) {
        isError.value = true;
      } finally {
        resetStatus();
      }
    }
  }

  double? originalBrightness;
  bool isBrightnessIncreased = false;

  Future<void> increaseBrightnessTemporarily() async {
    originalBrightness = await ScreenBrightness().system;
    await ScreenBrightness().setApplicationScreenBrightness(1.0);
    isBrightnessIncreased = true;
  }

  Future<void> restoreBrightness() async {
    if (originalBrightness != null) {
      await ScreenBrightness().setApplicationScreenBrightness(originalBrightness!);
    }
    isBrightnessIncreased = false;
  }
}