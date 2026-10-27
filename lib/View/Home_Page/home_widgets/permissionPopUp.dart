import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';

class PermissionPopup extends StatelessWidget {
  const PermissionPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // 🔹 Blurred background
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(color: Colors.black.withValues(alpha: 0.4)),
          ),

          // 🔹 Center Dialog
          Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: const Color(0xFF212121).withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: Color(0xFF323232).withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF212121).withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(
                      color: Color(0xFF323232).withValues(alpha: 0.5),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 26,
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 🔹 Top Icon
                      Container(
                        padding: EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Color(0xFF313131).withValues(alpha: 0.5),
                            width: 1,
                          ),
                        ),
                        child: Container(
                          width: 60,
                          height: 60,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFF3E3E3E),
                                Color(0xFF303132),
                                Color(0xFF25262B),
                              ],
                            ),
                          ),
                          child: Image.asset(
                            'assets/images/camera_permission_icon.png',
                            width: 30,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 🔹 Title
                      Text(
                        "Camera permission required",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: ColorUtils.textWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // 🔹 Subtitle
                      Text(
                        "To take photos, the camera permission must "
                            "be enabled. Please allow camera access for the "
                            "app in your device settings.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: ColorUtils.textWhite.withValues(alpha: 0.5),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 🔹 Step-by-step Guide
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Step-by-step guide",
                              style: GoogleFonts.poppins(
                                color: ColorUtils.textWhite,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "1. Open your device Settings\n"
                                  "2. Go to Apps / App Info (Android) or App Settings (iOS)\n"
                                  "3. Select Loyaltri\n"
                                  "4. Tap Permissions\n"
                                  "5. Enable Camera",
                              style: GoogleFonts.poppins(
                                color: ColorUtils.textWhite.withValues(alpha: 0.5),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // 🔹 Buttons Row
                      Row(
                        children: [
                          // Cancel Button
                          Expanded(
                            child: GestureDetector(
                              onTap: () => Navigator.pop(context, false),
                              child: Container(
                                height: 42,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Color(0xFF272727),
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                    color: Color(0xFF363636),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  "Cancel",
                                  style: GoogleFonts.poppins(
                                    color: ColorUtils.textWhite.withValues(alpha: 0.7),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Allow Button (Purple)
                          Expanded(
                            child: GestureDetector(
                              onTap: () => Navigator.pop(context, true),
                              child: Container(
                                height: 42,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: ColorUtils.secondaryBlue,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Text(
                                  "Settings",
                                  style: GoogleFonts.poppins(
                                    color: ColorUtils.textWhite,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
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
}
