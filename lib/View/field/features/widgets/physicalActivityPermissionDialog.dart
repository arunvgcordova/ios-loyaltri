import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';
import 'package:permission_handler/permission_handler.dart';

class PhysicalActivityPermissionDialog extends StatelessWidget {
  final bool isPermanentlyDenied;

  const PhysicalActivityPermissionDialog({
    super.key,
    this.isPermanentlyDenied = false,
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.directions_walk_rounded,
                                color: Colors.white,
                                size: 24.sp,
                              ),
                              SizedBox(width: 2.w),
                              Icon(
                                Icons.directions_car_rounded,
                                color: Colors.white,
                                size: 22.sp,
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 16.h),

                      // 🔹 Title
                      Text(
                        "Physical Activity Access",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: ColorUtils.textWhite,
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      SizedBox(height: 8.h),

                      // 🔹 Subtitle
                      Text(
                        "Loyaltri requires access to your physical activity to detect whether you are walking or driving during your active work shifts.",
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
                              icon: Icons.directions_walk_rounded,
                              iconColor: const Color(0xFF38BDF8),
                              title: "Walking Detection",
                              description:
                                  "Accurately logs on-foot movement and client visits.",
                            ),
                            SizedBox(height: 10.h),
                            _buildFeatureItem(
                              icon: Icons.directions_car_rounded,
                              iconColor: const Color(0xFFF472B6),
                              title: "Driving Detection",
                              description:
                                  "Records travel routes and distance covered while driving.",
                            ),
                            SizedBox(height: 10.h),
                            _buildFeatureItem(
                              icon: Icons.battery_charging_full_rounded,
                              iconColor: const Color(0xFF34D399),
                              title: "Battery Optimization",
                              description:
                                  "Pauses GPS queries when stationary to conserve battery life.",
                            ),
                            SizedBox(height: 10.h),
                            _buildFeatureItem(
                              icon: Icons.verified_user_rounded,
                              iconColor: const Color(0xFFA78BFA),
                              title: "Privacy Protected",
                              description:
                                  "Used strictly for work route tracking; never for fitness profiling or ads.",
                            ),
                          ],
                        ),
                      ),

                      if (isPermanentlyDenied) ...[
                        SizedBox(height: 12.h),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: Colors.amber.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: Colors.amber.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline, color: Colors.amber, size: 18.sp),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  "Physical activity permission is currently disabled. Please enable it in your device settings.",
                                  style: GoogleFonts.poppins(
                                    color: Colors.amber.shade200,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

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
                                  isPermanentlyDenied ? "Open Settings" : "Continue",
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

/// Helper to check and request Physical Activity permission with prominent disclosure
class ActivityPermissionHelper {
  static bool _isDialogShowing = false;

  /// Checks if Physical Activity permission is granted.
  /// If not granted, displays the prominent disclosure dialog first,
  /// and only upon the user tapping 'Continue' requests the system permission.
  static Future<bool> checkAndRequestPermission({BuildContext? context}) async {
    try {
            final permission = Platform.isIOS
          ? Permission.sensors
          : Permission.activityRecognition;
      final status = await permission.status;
      if (status.isGranted) {
        return true;
      }

      if (_isDialogShowing) {
        return false;
      }

      final targetContext = Get.overlayContext ?? Get.context ?? context;
      if (targetContext == null || !targetContext.mounted) {
        return false;
      }

      _isDialogShowing = true;

      final isPermanentlyDenied = status.isPermanentlyDenied;
      final bool? proceed = await showGeneralDialog<bool>(
        context: targetContext,
        barrierDismissible: false,
        barrierLabel: "PhysicalActivityDisclosure",
        transitionDuration: const Duration(milliseconds: 250),
        pageBuilder: (ctx, anim1, anim2) {
          return PopScope(
            canPop: false,
            child: PhysicalActivityPermissionDialog(
              isPermanentlyDenied: isPermanentlyDenied,
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

      if (isPermanentlyDenied) {
        await openAppSettings();
        return false;
      }

      // User confirmed via disclosure -> Now request native OS permission
      final reqStatus = await permission.request();
      return reqStatus.isGranted;
    } catch (e) {
      _isDialogShowing = false;
      debugPrint('[ActivityPermissionHelper] Error: $e');
      return false;
    }
  }
}
