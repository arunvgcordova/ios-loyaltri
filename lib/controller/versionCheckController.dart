import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/controller/userAuthentication.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:sim_card_code/sim_card_code.dart';
import '../services/api_services.dart';
import '../services/flutter_secure_storage.dart';
import '../models/user_api_model.dart';

class VersionCheckController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool dataLoaded = false.obs;
  RxBool isError = false.obs;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  // RxString url = "".obs;

  void resetStatus() {
    isLoading.value = false;
    isError.value = false;
  }

  Future<dynamic> checkVersionUpdates() async {
    isLoading.value = true;
    dataLoaded.value = false;
    String? deviceId;
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor;
    }
    String? empId =
        Get.find<UserAuthController>().userData.value.userData?.employeeId;
    String? lastTime = DateTime.now().toString();
    String? fcmToken;
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      fcmToken = await messaging.getToken();
    } catch(e) {}
    try {
      final SecureStorageUtils prefs = SecureStorageUtils();
      String? logoutChecker = await prefs.getString('logoutChecker');
      Map<String, dynamic> resp = await ApiServices.versionCheck(
        empId: empId,
        deviceId: deviceId,
        fcmToken: fcmToken,
        lastTime: lastTime,
        logoutChecker: logoutChecker,
      );
      AttendanceCommonWidgets().printF("------version-resp--------$resp");
      if (resp['status'] == true) {
        if (resp['result']?['status'] == true) {
          Get.find<UserAuthController>().restrictRsInfo.value = bool.tryParse(resp['result']?['restrictRsInfo']?.toString() ?? 'true') ?? false;
          Get.find<UserAuthController>().postFeed.value = bool.tryParse(resp['result']?['postFeed']?.toString() ?? 'false') ?? false;
          Get.find<UserAuthController>().postFeedComment.value = bool.tryParse(resp['result']?['postFeedComment']?.toString() ?? 'false') ?? false;
          Get.find<UserAuthController>().allowUploadDocument.value = (bool.tryParse(resp['result']?['uploadDocument']?.toString() ?? 'false') ?? false) || (Get.find<UserAuthController>().userData.value.userData?.permissions?.contains(142) ?? false);

          // Dynamically check and update offlineMode from versionCheck API response
          if (resp['result']?['offlineMode'] != null) {
            final userAuthController = Get.find<UserAuthController>();
            final dynamic newOfflineModeRaw = resp['result']['offlineMode'];
            bool newOfflineMode = true;
            if (newOfflineModeRaw is bool) {
              newOfflineMode = newOfflineModeRaw;
            } else if (newOfflineModeRaw is int) {
              newOfflineMode = newOfflineModeRaw == 1;
            } else if (newOfflineModeRaw is String) {
              newOfflineMode = newOfflineModeRaw.toLowerCase() == 'true' || newOfflineModeRaw == '1';
            }

            final currentOfflineMode = userAuthController.userData.value.userData?.offlineMode;
            if (currentOfflineMode != newOfflineMode) {
              final Map<String, dynamic> userApiJson = userAuthController.userData.value.toJson();
              if (userApiJson['userData'] != null && userApiJson['userData'] is Map) {
                userApiJson['userData']['offlineMode'] = newOfflineMode;
              }

              // Update the observable state in-memory
              userAuthController.userData.value = UserAPI.fromJson(userApiJson);
              userAuthController.userData.refresh();

              // Write the updated login response json to local secure storage
              try {
                await prefs.setUserData(userApiJson);
              } catch (_) {}
            }
          }

          if(resp['result']?['isLogoutNeeded'] == true) {
            await prefs.remove('logoutChecker');
            return true;
          } else {
            await prefs.setString('logoutChecker', resp['result']?['logoutChecker']);
          }
          dataLoaded.value = true;
          // url.value = resp['result']['appUrl'];
        }
      }
      await requestPermission();
    } catch (e) {
      isError.value = true;
      AttendanceCommonWidgets().printF(
        "------version check error-------${e.toString()}",
      );
    } finally {
      resetStatus();
    }
  }

  Future<void> requestPermission() async {
    // Check for Android permissions
    if (Platform.isAndroid) {
      var status = await Permission.notification.status;

      if (status.isDenied) {
        // Request notification permission
        await Permission.notification.request();
      }
    }

    // Request permission for iOS
    if (Platform.isIOS) {
      NotificationSettings settings = await FirebaseMessaging.instance
          .requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        AttendanceCommonWidgets().printF('User granted permission');
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        AttendanceCommonWidgets().printF('User granted provisional permission');
      } else {
        AttendanceCommonWidgets().printF(
          'User declined or has not accepted permission',
        );
      }
    }
  }

  // For loyaltri field

  Future<void> sentDeviceInfo() async {
    final DeviceInfoPlugin info = DeviceInfoPlugin();

    String? deviceName;
    String? deviceId;

    try {
      if (Platform.isAndroid) {
        final AndroidDeviceInfo androidInfo = await info.androidInfo;
        // debugPrint('========== [DEBUG: androidInfo] ==========');
        // debugPrint('androidInfo.brand: ${androidInfo.brand}');
        // debugPrint('androidInfo.model: ${androidInfo.model}');
        // debugPrint('androidInfo.manufacturer: ${androidInfo.manufacturer}');
        // debugPrint('androidInfo.device: ${androidInfo.device}');
        // debugPrint('androidInfo.product: ${androidInfo.product}');
        // debugPrint('androidInfo.hardware: ${androidInfo.hardware}');
        // debugPrint('androidInfo.id: ${androidInfo.id}');
        // debugPrint('androidInfo.fingerprint: ${androidInfo.fingerprint}');
        // debugPrint('androidInfo.version.release: ${androidInfo.version.release}');
        // debugPrint('androidInfo.version.sdkInt: ${androidInfo.version.sdkInt}');
        // debugPrint('androidInfo.isPhysicalDevice: ${androidInfo.isPhysicalDevice}');
        // debugPrint('androidInfo.data: ${androidInfo.data}');

        final brand = androidInfo.brand;
        final model = androidInfo.model;
        deviceName = model.toLowerCase().startsWith(brand.toLowerCase())
            ? model
            : '$brand $model';
        deviceId = androidInfo.id;
      } else if (Platform.isIOS) {
        final IosDeviceInfo iosInfo = await info.iosInfo;
        // debugPrint('========== [DEBUG: iosInfo] ==========');
        // debugPrint('iosInfo.name: ${iosInfo.name}');
        // debugPrint('iosInfo.model: ${iosInfo.model}');
        // debugPrint('iosInfo.localizedModel: ${iosInfo.localizedModel}');
        // debugPrint('iosInfo.systemName: ${iosInfo.systemName}');
        // debugPrint('iosInfo.systemVersion: ${iosInfo.systemVersion}');
        // debugPrint('iosInfo.identifierForVendor: ${iosInfo.identifierForVendor}');
        // debugPrint('iosInfo.utsname.machine: ${iosInfo.utsname.machine}');
        // debugPrint('iosInfo.utsname.nodename: ${iosInfo.utsname.nodename}');
        // debugPrint('iosInfo.utsname.release: ${iosInfo.utsname.release}');
        // debugPrint('iosInfo.utsname.sysname: ${iosInfo.utsname.sysname}');
        // debugPrint('iosInfo.utsname.version: ${iosInfo.utsname.version}');
        // debugPrint('iosInfo.isPhysicalDevice: ${iosInfo.isPhysicalDevice}');
        // debugPrint('iosInfo.data: ${iosInfo.data}');

        // Prefer human-readable modelName from data (e.g. "iPhone XS", "iPhone 14 Pro")
        final modelName = (iosInfo.data['modelName'] as String?)?.trim();
        if (modelName != null && modelName.isNotEmpty && modelName != 'iPhone') {
          deviceName = modelName;
        } else if (iosInfo.name.isNotEmpty && iosInfo.name != 'iPhone') {
          deviceName = iosInfo.name;
        } else {
          deviceName = (modelName != null && modelName.isNotEmpty) ? modelName : iosInfo.name;
        }
        deviceId = iosInfo.identifierForVendor ?? iosInfo.utsname.machine;
      }
    } catch (e) {
      debugPrint('[DeviceInfo] Error reading device info: $e');
    }

    String carrierName = '';
    String networkType = '';

    bool isValid(String? val) {
      if (val == null) return false;
      final t = val.trim();
      return t.isNotEmpty && t != '--' && t != 'UNKNOWN' && t != 'null' && t != 'None';
    }

    String? resolveCellularGeneration(String? raw) {
      if (!isValid(raw)) return null;
      final upper = raw!.trim().toUpperCase();

      // 5G technologies
      if (upper == '5G' || upper == 'NR' || upper.contains('5G') || upper.contains('NR')) {
        return '5G';
      }

      // 4G / LTE technologies
      if (upper == 'LTE' || upper == '4G' || upper.contains('LTE') || upper.contains('4G')) {
        return '4G';
      }

      // 3G technologies (UMTS, HSPA, HSDPA, HSUPA, CDMA, EVDO)
      if (upper == '3G' ||
          upper == 'UMTS' ||
          upper == 'HSDPA' ||
          upper == 'HSUPA' ||
          upper == 'HSPA' ||
          upper == 'HSPAP' ||
          upper == 'CDMA' ||
          upper == 'EVDO_0' ||
          upper == 'EVDO_A' ||
          upper == 'EVDO_B' ||
          upper == 'EHRPD' ||
          upper.contains('3G') ||
          upper.contains('HSPA') ||
          upper.contains('UMTS')) {
        return '3G';
      }

      // 2G technologies (GPRS, EDGE, 1xRTT, GSM)
      if (upper == '2G' ||
          upper == 'GPRS' ||
          upper == 'EDGE' ||
          upper == '1XRTT' ||
          upper.contains('2G') ||
          upper.contains('EDGE') ||
          upper.contains('GPRS')) {
        return '2G';
      }

      return null;
    }

    try {
      // 1. Check active transport (WiFi, Mobile Data, VPN, etc.)
      final connectivityResults = await Connectivity().checkConnectivity();

      // 2. Fetch SIM & Telephony network info
      final net = await SimCardManager.networkInfo;
      // debugPrint('========== [DEBUG: net] ==========');
      // debugPrint('net.operatorName: ${net.operatorName}');
      // debugPrint('net.networkType: ${net.networkType}');
      // debugPrint('net.countryCode: ${net.countryCode}');
      // debugPrint('net.isRoaming: ${net.isRoaming}');

      // --- Resolve Carrier Name (with multi-tier fallback) ---
      if (isValid(net.operatorName)) {
        carrierName = net.operatorName!.trim();
      }

      // Fallback 1: Read operator name directly from SIM card memory (EF_SPN)
      if (!isValid(carrierName)) {
        final simOp = await SimCardManager.simOperatorName;
        // debugPrint('========== [DEBUG: simOp] ==========');
        // debugPrint('simOp: $simOp');

        if (isValid(simOp)) {
          carrierName = simOp!.trim();
        }
      }

      // Fallback 2: Check all available SIM slots (essential for Dual-SIM devices and iOS)
      if (!isValid(carrierName)) {
        final allSims = await SimCardManager.allSimInfo;
        // debugPrint('========== [DEBUG: allSims count: ${allSims.length}] ==========');
        for (final sim in allSims) {
          // debugPrint('========== [DEBUG: sim] ==========');
          // debugPrint('sim.carrierName: ${sim.carrierName}');
          // debugPrint('sim.displayName: ${sim.displayName}');
          // debugPrint('sim.operatorName: ${sim.operatorName}');
          // debugPrint('sim.countryCode: ${sim.countryCode}');
          // debugPrint('sim.operatorCode: ${sim.operatorCode}');
          // debugPrint('sim.serialNumber: ${sim.serialNumber}');
          // debugPrint('sim.slotIndex: ${sim.slotIndex}');
          // debugPrint('sim.subscriptionId: ${sim.subscriptionId}');
          // debugPrint('sim.isEsim: ${sim.isEsim}');
          // debugPrint('sim.isRoaming: ${sim.isRoaming}');
          // debugPrint('sim.simState: ${sim.simState}');
          // debugPrint('sim.toMap(): ${sim.toMap()}');

          final name = isValid(sim.carrierName)
              ? sim.carrierName
              : (isValid(sim.displayName) ? sim.displayName : sim.operatorName);
          if (isValid(name)) {
            carrierName = name!.trim();
            break;
          }
        }
      }

      // Fallback 3: Map known operator codes (MCC/MNC) if carrier name is still empty
      if (!isValid(carrierName)) {
        final code = await SimCardManager.simOperatorCode;
        if (isValid(code)) {
          if (code!.startsWith('404') || code.startsWith('405')) {
            if (code.startsWith('4058') || code.startsWith('4057')) {
              carrierName = 'Jio';
            } else if (code.startsWith('40445') || code.startsWith('40410')) {
              carrierName = 'Airtel';
            } else if (code.startsWith('40420') || code.startsWith('40446')) {
              carrierName = 'Vi';
            } else {
              carrierName = 'Cellular';
            }
          } else if (code.startsWith('42402')) {
            carrierName = 'Etisalat';
          } else if (code.startsWith('42403')) {
            carrierName = 'du';
          } else if (code.startsWith('42001')) {
            carrierName = 'STC';
          } else if (code.startsWith('42003')) {
            carrierName = 'Mobily';
          } else if (code.startsWith('42004')) {
            carrierName = 'Zain';
          }
        }
      }

      // Fallback 4: If still empty and device is on Wi-Fi or country is known
      if (!isValid(carrierName)) {
        if (connectivityResults.contains(ConnectivityResult.wifi)) {
          carrierName = 'Wi-Fi';
        } else if (isValid(net.countryCode)) {
          carrierName = 'Cellular (${net.countryCode})';
        } else {
          carrierName = '--';
        }
      }

      // --- Resolve Network Type (maps to 4G, 5G, 3G, 2G, WiFi) ---
      String? cellularGen = resolveCellularGeneration(net.networkType);

      // Check fallback from SimCardManager.networkType if unconfirmed
      if (cellularGen == null) {
        final rawType = await SimCardManager.networkType;
        cellularGen = resolveCellularGeneration(rawType);
      }

      // If carrier name contains 5G or 4G (e.g. "Jio True5G", "Airtel 5G Plus")
      if (cellularGen == null && isValid(carrierName)) {
        final upperCarrier = carrierName.toUpperCase();
        if (upperCarrier.contains('5G')) {
          cellularGen = '5G';
        } else if (upperCarrier.contains('4G') || upperCarrier.contains('LTE')) {
          cellularGen = '4G';
        }
      }

      if (cellularGen != null) {
        // Output clean generation: "5G", "4G", "3G", "2G"
        networkType = cellularGen;
      } else if (connectivityResults.contains(ConnectivityResult.wifi)) {
        // Wi-Fi is active and no cellular generation found
        networkType = 'WiFi';
      } else if (connectivityResults.contains(ConnectivityResult.mobile)) {
        // Mobile data is active
        networkType = 'Mobile';
      } else if (connectivityResults.contains(ConnectivityResult.none)) {
        networkType = 'No Connection';
      } else {
        networkType = '--';
      }
    } catch (e) {
      debugPrint('[DeviceInfo] Error fetching SIM/network info: $e');
    }

    if (!isValid(carrierName)) carrierName = '--';
    if (!isValid(networkType)) networkType = '--';

    final Map<String, dynamic> networkInfo = {
      "carrier_name": carrierName,
      "network_type": networkType,
    };

    try {
      final int empId =
          int.tryParse(
            Get.find<UserAuthController>()
                .userData
                .value
                .userData
                ?.employeeId ??
                '',
          ) ??
              0;

      final body = {
        "employee_id": empId,
        "device_info": [
          {
            "device_name": deviceName,
            "device_id": deviceId,
            "net_work_info": networkInfo,
          },
        ],
      };
      final resp = await ApiServices.sendDeviceInfo(body: body);
      AttendanceCommonWidgets().printF("dahsuidahdiudhiuisd ----- $body");
      if (resp['status'] == 201 || resp['status'] == 200) {
        AttendanceCommonWidgets().printF("dahsuidahdiudhiuisd ----- $resp");
      } else {
        // print("Error =============== ${resp["message"]}");
      }
    } catch (e) {
      debugPrint('sentDeviceInfo error: $e');
    }
  }
}