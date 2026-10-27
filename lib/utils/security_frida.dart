import 'dart:io';

import 'package:flutter/services.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';

class SecurityCheckFrida {
  static const MethodChannel _channel = MethodChannel('app.security/checks');

  static Future<bool> isFridaDetected() async {
    return await _channel.invokeMethod<bool>('detectFrida') ?? false;
  }

  static Future<bool> isDebuggerConnected() async {
    return await _channel.invokeMethod<bool>('isDebuggerConnected') ?? false;
  }

  static Future<bool> isDeviceRooted() async {
    return await _channel.invokeMethod<bool>('isDeviceRooted') ?? false;
  }

  void checkSecurity() async {
    final frida = await isFridaDetected();
    final rooted = await isDeviceRooted();
    final debug = await isDebuggerConnected();

    if (frida || rooted || debug) {
      AttendanceCommonWidgets().printF("⚠️ Security issue detected!");
      // You can close the app or show warning
      exit(0);
    } else {
      AttendanceCommonWidgets().printF("✅ All checks passed.");
    }
  }

  static Future<bool> isMockLocationEnabled() async {
    // AttendanceCommonWidgets().printF("mock location 1---------- stage 1 ");
    return await _channel.invokeMethod<bool>('isMockLocationEnabled') ?? false;
  }
}
