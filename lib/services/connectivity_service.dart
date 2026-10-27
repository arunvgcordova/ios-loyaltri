import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:network_info_plus/network_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';

class ConnectivityService {
  Future<bool> check() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return false;
    } else {
      return true;
    }
  }

  static Future<bool> goodConnection({Duration timeout = const Duration(seconds: 2)}) async {
    final hosts = ['google.com', 'cloudflare.com', 'example.com', 'amazon.com'];

    final checks = hosts.map((host) async {
      try {
        final result = await InternetAddress.lookup(host).timeout(timeout);
        return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      } catch (_) {
        return false;
      }
    });

    final results = await Future.wait(checks);
    return results.contains(true);
  }

  Future<String> connectionType() async {
    final connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.wifi)) {
      return "Connected to wifi";
    } else if (connectivityResult.contains(ConnectivityResult.mobile)) {
      return "Connected to mobile network";
    } else {
      return "User not connected to any network";
    }
  }

  // Future<String?> wifiName() async {
  //   final connectivityResult = await (Connectivity().checkConnectivity());
  //
  //   if (connectivityResult == ConnectivityResult.wifi) {
  //     String? wifiName = await NetworkInfo().getWifiName();
  //     return wifiName;
  //   } else {
  //     return null;
  //   }
  // }
}
