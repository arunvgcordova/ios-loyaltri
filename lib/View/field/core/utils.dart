import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/View/field/core/asset_utils.dart';
import 'package:url_launcher/url_launcher.dart';

Widget svgWidget({
  required String icon,
  double? height,
  double? width,
  Color? color,
}) => SizedBox(
  height: height,
  width: width,
  child: SvgPicture.asset(AssetUtils.svg(icon), color: color),
);
Widget pngWidget({required String icon, double? height, double? width}) =>
    SizedBox(
      height: height,
      width: width,
      child: Image.asset(AssetUtils.png(icon)),
    );

Future<void> makePhoneCall(String? phoneNumber) async {
  if (phoneNumber == null || phoneNumber.trim().isEmpty) return;

  final Uri uri = Uri(scheme: 'tel', path: phoneNumber.trim());

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw Exception('Could not launch $phoneNumber');
  }
}

Future<void> openGoogleMaps({
  required double? latitude,
  required double? longitude,
  required BuildContext context
}) async {
  AttendanceCommonWidgets().printF("-------------- Lat = $latitude and Lng = $longitude");
  if (latitude == null || longitude == null || latitude == 0.0 || longitude == 0.0) {
    // Get.snackbar('Map', 'Location is not available.');
    AttendanceCommonWidgets().showSnackBar(
      context: context,
      backgroundColor: Colors.red,
      message: 'Location is not available.',
    );
    return;
  }

  final Uri googleMapsUrl = Uri.parse(
    'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
  );

  if (await canLaunchUrl(googleMapsUrl)) {
    await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
  } else {
    // Get.snackbar(
    //   'Map',
    //   'Could not open Google Maps.',
    // );
    AttendanceCommonWidgets().showSnackBar(
      context: context,
      backgroundColor: Colors.red,
      message: 'Could not open Google Maps.',
    );
  }
}

// Future<void> openGoogleMaps({
//   required double latitude,
//   required double longitude,
// }) async {
//   final Uri googleMapsUrl = Uri.parse(
//     'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
//   );

//   if (await canLaunchUrl(googleMapsUrl)) {
//     await launchUrl(
//       googleMapsUrl,
//       mode: LaunchMode.externalApplication,
//     );
//   } else {
//     throw Exception('Could not open Google Maps');
//   }
// }

Future<void> openAttachment(String? url) async {
  if (url == null || url.trim().isEmpty) return;

  final uri = Uri.parse(url);

  final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);

  if (!launched) {
    throw Exception('Could not launch $url');
  }
}

String formatDuration(int? seconds) {
  if (seconds == null) return '00:00:00';

  final duration = Duration(seconds: seconds);

  final hours = duration.inHours.toString().padLeft(2, '0');
  final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
  final secs = (duration.inSeconds % 60).toString().padLeft(2, '0');

  return '$hours:$minutes:$secs';
}
