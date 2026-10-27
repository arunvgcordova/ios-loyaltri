import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

import '../../../../utils/color_utils.dart';

class AttendanceCommonWidgets {
  AttendanceCommonWidgets._privateConstructor();

  static final AttendanceCommonWidgets _instance =
      AttendanceCommonWidgets._privateConstructor();

  factory AttendanceCommonWidgets() {
    return _instance;
  }

  Widget workedHours(String hour) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "Worked Hours",
          style: GoogleFonts.poppins(
            fontSize: 11.h,
            fontWeight: FontWeight.w400,
            color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
          ),
        ),
        Text(
          hour,
          style: GoogleFonts.poppins(
            fontSize: 11.h,
            fontWeight: FontWeight.w500,
            color: ColorUtils.workEntryHead.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }

  Widget dateView(String date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Date :",
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(
            fontSize: 11.h,
            fontWeight: FontWeight.w400,
            color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
          ),
        ),
        Text(
          date,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(
            fontSize: 11.h,
            fontWeight: FontWeight.w400,
            color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }

  Widget checkOutTime(String time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Check out",
          style: GoogleFonts.poppins(
            fontSize: 11.h,
            fontWeight: FontWeight.w400,
            color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
          ),
        ),
        Text(
          time,
          style: GoogleFonts.poppins(
            fontSize: 11.h,
            fontWeight: FontWeight.w500,
            color: ColorUtils.workEntryHead.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }

  Widget checkOutTimeStart(String time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Check out",
          style: GoogleFonts.poppins(
            fontSize: 11.h,
            fontWeight: FontWeight.w400,
            color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
          ),
        ),
        Text(
          time,
          style: GoogleFonts.poppins(
            fontSize: 11.h,
            fontWeight: FontWeight.w500,
            color: ColorUtils.workEntryHead.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }

  Widget checkInTime(String time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Check in",
          style: GoogleFonts.poppins(
            fontSize: 11.h,
            fontWeight: FontWeight.w400,
            color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
          ),
        ),
        Text(
          time,
          style: GoogleFonts.poppins(
            fontSize: 11.h,
            fontWeight: FontWeight.w500,
            color: ColorUtils.workEntryHead.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }

  Widget nameWithDesignation({
    required String name,
    required String designation,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(
            fontSize: 11.h,
            fontWeight: FontWeight.w500,
            color: ColorUtils.workEntryHead.withValues(alpha: 0.9),
          ),
        ),
        Text(
          designation,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(
            fontSize: 11.h,
            fontWeight: FontWeight.w400,
            color: ColorUtils.workEntryHead.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }

  Widget cachedNetworkImage(String profilePictureUrl, {double? height, Color? color}) {
    return Container(
      padding: EdgeInsets.all(1).h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color ?? ColorUtils.lightSilver,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(1000).r,
        child: CachedNetworkImage(
          imageUrl: profilePictureUrl,
          height: height ?? 30.h,
          width: height ?? 30.h,
          alignment: Alignment.center,
          placeholder: (context, url) {
            return _defaultPlaceholder(height: height);
          },
          errorWidget: (context, url, error) {
            return _defaultPlaceholder(height: height);
          },
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget cachedNetworkImageWithoutBoarder(
    String profilePictureUrl, {
    double? height,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(1000).r,
      child: CachedNetworkImage(
        imageUrl: profilePictureUrl,
        height: height ?? 30.h,
        width: height ?? 30.h,
        alignment: Alignment.center,
        placeholder: (context, url) {
          return _defaultPlaceholder(height: height);
        },
        errorWidget: (context, url, error) {
          return _defaultPlaceholder(height: height);
        },
        fit: BoxFit.cover,
      ),
    );
  }

  Widget cachedNetworkImageSquare(String profilePictureUrl, {double? height}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4).r,
      child: CachedNetworkImage(
        imageUrl: profilePictureUrl,
        height: height ?? 30.h,
        placeholder: (context, url) {
          return _defaultPlaceholderSquare(height: height);
        },
        errorWidget: (context, url, error) {
          return _defaultPlaceholderSquare(height: height);
        },
        fit: BoxFit.fitHeight,
      ),
    );
  }

  Widget _defaultPlaceholder({double? height}) {
    return Container(
      width: height ?? 30.h,
      height: height ?? 30.h,
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
      child: Center(child: Icon(Icons.person, color: Colors.grey, size: 18.h)),
    );
  }

  Widget _defaultPlaceholderSquare({double? height}) {
    return Container(
      padding: EdgeInsets.all(1).h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4).r,
        color: ColorUtils.lightSilver,
      ),
      child: Container(
        width: height ?? 29.h,
        height: height ?? 29.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4).r,
          color: Colors.white,
          // border: Border.all(
          //   color: Colors.grey,
          //   width: 1.h,
          // ),
        ),
        child: Center(
          child: Icon(Icons.person, color: Colors.grey, size: 23.h),
        ),
      ),
    );
  }

  void showSnackBar({
    required BuildContext context,
    required Color backgroundColor,
    required String message,
  }) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
        behavior: SnackBarBehavior.floating,
        content: Text(message, style: GoogleFonts.inter(color: Colors.white)),
        backgroundColor: backgroundColor,
      ),
    );
  }

  Color? hexToColor(String? hexColor) {
    if (hexColor == null) return null;
    try {
      hexColor = hexColor.replaceAll("#", "");
      if (hexColor.length == 6) {
        hexColor = "FF$hexColor";
      }
      return Color(int.parse("0x$hexColor"));
    } catch (e) {}
    return null;
  }

  String? capitalizeFirstLetter(String? text) =>
      (text != null && text.isNotEmpty)
          ? '${text[0].toUpperCase()}${text.substring(1).toLowerCase()}'
          : null;

  void printF(Object? message) {
    // message = "";
    if (kDebugMode) {
      print(message);
    }
  }

  String formatCount(dynamic rawCount) {
    if (rawCount == null) return '0';
    int count = 0;
    if (rawCount is int) {
      count = rawCount;
    } else if (rawCount is num) {
      count = rawCount.toInt();
    } else {
      count = int.tryParse(rawCount.toString()) ?? 0;
    }

    if (count < 1000) {
      return count.toString();
    } else if (count < 1000000) {
      double k = count / 1000;
      return k % 1 == 0 ? '${k.toInt()}k' : '${k.toStringAsFixed(1)}k';
    } else if (count < 1000000000) {
      double m = count / 1000000;
      return m % 1 == 0 ? '${m.toInt()}M' : '${m.toStringAsFixed(1)}M';
    } else {
      double b = count / 1000000000;
      return b % 1 == 0 ? '${b.toInt()}B' : '${b.toStringAsFixed(1)}B';
    }
  }

  void showGetSnackBar({
    required String title,
    required String message,
    Color? backgroundColor,
    Color? colorText,
    SnackPosition snackPosition = SnackPosition.BOTTOM,
    EdgeInsets? margin,
  }) {
    Get.closeAllSnackbars();
    Get.snackbar(
      title,
      message,
      snackPosition: snackPosition,
      backgroundColor: backgroundColor ?? Colors.green,
      colorText: colorText ?? Colors.white,
      margin: margin ?? EdgeInsets.only(bottom: 10.h, left: 10.h, right: 10.h),
      duration: const Duration(seconds: 3),
    );
  }
}
