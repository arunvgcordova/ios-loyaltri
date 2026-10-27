import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationAlwaysPermissionDialog extends StatelessWidget {
  final bool isPermanentlyDenied;
  final bool isWhileInUse;

  const LocationAlwaysPermissionDialog({
    super.key,
    this.isPermanentlyDenied = false,
    this.isWhileInUse = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // 🔹 Blurred backdrop
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(color: Colors.black.withValues(alpha: 0.5)),
          ),

          // 🔹 Center Dialog
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF212121).withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(32.r),
                  border: Border.all(
                    color: const Color(0xFF323232).withValues(alpha: 0.6),
                    width: 1,
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E).withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(28.r),
                    border: Border.all(
                      color: const Color(0xFF383838),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 🔹 Top Icon Badge
                      Container(
                        padding: EdgeInsets.all(1.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: const Color(0xFF424242).withValues(alpha: 0.6),
                            width: 1,
                          ),
                        ),
                        child: Container(
                          width: 64.w,
                          height: 64.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.r),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF6A4BFC),
                                Color(0xFF4338CA),
                                Color(0xFF1E1B4B),
                              ],
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.location_on_rounded,
                              color: Colors.white,
                              size: 32.sp,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 16.h),

                      // 🔹 Title
                      Text(
                        "Background Location Access",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: ColorUtils.textWhite,
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      SizedBox(height: 8.h),

                      // 🔹 Prominent Disclosure Subtitle
                      Text(
                        "Loyaltri collects location data to enable real-time field route tracking, client visit verification, and travel distance calculation even when the app is closed or not in use during your active work shifts.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: ColorUtils.textWhite.withValues(alpha: 0.65),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                        ),
                      ),

                      SizedBox(height: 16.h),

                      // 🔹 Feature List
                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.04),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.06),
                          ),
                        ),
                        child: Column(
                          children: [
                            _buildFeatureItem(
                              icon: Icons.alt_route_rounded,
                              iconColor: const Color(0xFF38BDF8),
                              title: "Live Route Tracking",
                              description:
                                  "Monitors GPS points continuously during active work shifts.",
                            ),
                            SizedBox(height: 10.h),
                            _buildFeatureItem(
                              icon: Icons.domain_verification_rounded,
                              iconColor: const Color(0xFFF472B6),
                              title: "Client Visit Verification",
                              description:
                                  "Automatically confirms arrivals and departures at customer sites.",
                            ),
                            SizedBox(height: 10.h),
                            _buildFeatureItem(
                              icon: Icons.straighten_rounded,
                              iconColor: const Color(0xFF34D399),
                              title: "Distance & Travel Logs",
                              description:
                                  "Calculates total distance traveled for transparent expense reports.",
                            ),
                            SizedBox(height: 10.h),
                            _buildFeatureItem(
                              icon: Icons.shield_outlined,
                              iconColor: const Color(0xFFA78BFA),
                              title: "Privacy Protected",
                              description:
                                  "Location is only recorded during on-duty shifts; never during off-hours.",
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 12.h),

                      // 🔹 Prominent Instruction Box
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6A4BFC).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: const Color(0xFF6A4BFC).withValues(alpha: 0.35),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              color: const Color(0xFFA78BFA),
                              size: 18.sp,
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                isWhileInUse || isPermanentlyDenied
                                    ? "Please change location permission to 'Allow all the time' in device settings."
                                    : "Please choose 'Allow all the time' when prompted to ensure uninterrupted tracking.",
                                style: GoogleFonts.poppins(
                                  color: const Color(0xFFD8B4FE),
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w400,
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // 🔹 Action Buttons
                      Row(
                        children: [
                          // Cancel Button
                          Expanded(
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).pop(false),
                              child: Container(
                                height: 42.h,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF272727),
                                  borderRadius: BorderRadius.circular(100.r),
                                  border: Border.all(
                                    color: const Color(0xFF3A3A3A),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  "Not Now",
                                  style: GoogleFonts.poppins(
                                    color: ColorUtils.textWhite.withValues(alpha: 0.7),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(width: 12.w),

                          // Continue / Settings Button
                          Expanded(
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).pop(true),
                              child: Container(
                                height: 42.h,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF6A4BFC),
                                      Color(0xFF5B39EE),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(100.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF6A4BFC).withValues(alpha: 0.4),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  (isPermanentlyDenied || isWhileInUse)
                                      ? "Change in Settings"
                                      : "Continue",
                                  style: GoogleFonts.poppins(
                                    color: ColorUtils.textWhite,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, color: iconColor, size: 16.sp),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  color: ColorUtils.textWhite,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                description,
                style: GoogleFonts.poppins(
                  color: ColorUtils.textWhite.withValues(alpha: 0.5),
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Helper to check and request 'Allow all the time' Location permission with prominent disclosure
class LocationAlwaysPermissionHelper {
  static bool _isDialogShowing = false;

  /// Checks if location permission is granted as 'Allow all the time'.
  static Future<bool> isLocationAllowedAllTime() async {
    try {
      final isAlwaysGranted = await Permission.locationAlways.isGranted;
      if (isAlwaysGranted) return true;

      final geoPerm = await Geolocator.checkPermission();
      return geoPerm == LocationPermission.always;
    } catch (_) {
      return false;
    }
  }

  /// Checks if location is allowed all the time.
  /// If not granted, displays the prominent disclosure dialog first,
  /// and upon user confirmation, requests system permission or opens settings.
  static Future<bool> checkAndRequestPermission({BuildContext? context}) async {
    try {
      if (await isLocationAllowedAllTime()) {
        return true;
      }

      if (_isDialogShowing) {
        return false;
      }

      final alwaysStatus = await Permission.locationAlways.status;
      final geoPerm = await Geolocator.checkPermission();
      final isWhileInUse = geoPerm == LocationPermission.whileInUse ||
          alwaysStatus.isDenied;
      final isPermanentlyDenied = alwaysStatus.isPermanentlyDenied ||
          geoPerm == LocationPermission.deniedForever;

      final targetContext = Get.overlayContext ?? Get.context ?? context;
      if (targetContext == null || !targetContext.mounted) {
        return false;
      }

      _isDialogShowing = true;

      final bool? proceed = await showGeneralDialog<bool>(
        context: targetContext,
        barrierDismissible: false,
        barrierLabel: "LocationAlwaysDisclosure",
        transitionDuration: const Duration(milliseconds: 250),
        pageBuilder: (ctx, anim1, anim2) {
          return PopScope(
            canPop: false,
            child: LocationAlwaysPermissionDialog(
              isPermanentlyDenied: isPermanentlyDenied,
              isWhileInUse: isWhileInUse,
            ),
          );
        },
        transitionBuilder: (ctx, anim1, anim2, child) {
          final curve = Curves.easeInOut.transform(anim1.value);
          return Transform.scale(scale: curve, child: child);
        },
      );

      _isDialogShowing = false;

      if (proceed != true) {
        return false;
      }

      // Step 1: Ensure basic / foreground location is granted first
      final locStatus = await Permission.location.status;
      if (!locStatus.isGranted) {
        final fgResult = await Permission.location.request();
        if (!fgResult.isGranted) {
          if (fgResult.isPermanentlyDenied) {
            await openAppSettings();
          }
          return false;
        }
      }

      // Step 2: Check if 'Allow all the time' is already satisfied
      if (await isLocationAllowedAllTime()) {
        return true;
      }

      // If permanently denied or user needs to change from 'While in use' to 'Always'
      if (isPermanentlyDenied) {
        await openAppSettings();
        return false;
      }

      // Request background location permission
      final reqResult = await Permission.locationAlways.request();
      if (reqResult.isGranted || await isLocationAllowedAllTime()) {
        return true;
      }

      // On Android 11+, if requesting didn't grant 'always', direct user to app settings
      if (!await isLocationAllowedAllTime()) {
        await openAppSettings();
      }

      return await isLocationAllowedAllTime();
    } catch (e) {
      _isDialogShowing = false;
      debugPrint('[LocationAlwaysPermissionHelper] Error: $e');
      return false;
    }
  }
}
