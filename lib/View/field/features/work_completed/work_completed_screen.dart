import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/field/core/utils.dart';
import '../../core/colour_utils.dart';

class WorkCompletedScreen extends StatefulWidget {
  const WorkCompletedScreen({super.key, required this.workid});
  final String workid;

  @override
  State<WorkCompletedScreen> createState() => _WorkCompletedScreenState();
}

class _WorkCompletedScreenState extends State<WorkCompletedScreen> {
  Timer? _autoCloseTimer;

  @override
  void initState() {
    super.initState();
    _autoCloseTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _autoCloseTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColourUtils.background,
      body: Stack(
        children: [
          // CONTENT
          SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // SUCCESS CHECKMARK
                    Container(
                      width: 90.h,
                      height: 90.h,
                      decoration: const BoxDecoration(
                        color: ColourUtils.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: svgWidget(
                          height: 40.h,
                          width: 40.h,
                          icon: 'circle_check',
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // SUCCESS MESSAGES
                    Text(
                      'Work Completed!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: ColourUtils.textMain,
                        fontSize: 18.h,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Your work has been submitted successfully',
                      style: GoogleFonts.inter(
                        color: ColourUtils.textWhite.withValues(alpha: 0.6),
                        fontSize: 14.h,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessCheckmark() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer glow
        Container(
          width: 120.r,
          height: 120.r,
          decoration: BoxDecoration(
            color: ColourUtils.primary.withOpacity(0.06),
            shape: BoxShape.circle,
          ),
        ),
        // Middle glow
        Container(
          width: 96.r,
          height: 96.r,
          decoration: BoxDecoration(
            color: ColourUtils.primary.withOpacity(0.12),
            shape: BoxShape.circle,
            border: Border.all(
              color: ColourUtils.primary.withOpacity(0.2),
              width: 1.5.w,
            ),
          ),
        ),
        // Inner circle
        Container(
          width: 72.r,
          height: 72.r,
          decoration: const BoxDecoration(
            color: ColourUtils.primary,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.check_rounded, color: Colors.white, size: 40.sp),
        ),
      ],
    );
  }

  Widget _buildNextWorkCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: ColourUtils.cardBackground,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: ColourUtils.border, width: 1.5.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 6.w,
                height: 6.w,
                decoration: const BoxDecoration(
                  color: ColourUtils.info,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                'UPCOMING WORK',
                style: GoogleFonts.outfit(
                  color: ColourUtils.textMuted,
                  fontSize: 10.h,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            'AC Installation - TechVista',
            style: GoogleFonts.outfit(
              color: ColourUtils.textMain,
              fontSize: 15.h,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'TechVista Solutions, Gurgaon',
            style: GoogleFonts.outfit(
              color: ColourUtils.textSecondary,
              fontSize: 12.h,
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            height: 40.h,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Checking in to TechVista Solutions... (Mocked)',
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: ColourUtils.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                elevation: 0,
              ),
              child: Text(
                'Check-In Now',
                style: GoogleFonts.outfit(
                  fontSize: 13.h,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ConfettiPainter extends CustomPainter {
  final List<_ConfettiParticle> particles = List.generate(
    40,
    (index) => _ConfettiParticle(),
  );

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    for (final p in particles) {
      final paint = Paint()
        ..color = p.color.withOpacity(0.4)
        ..style = PaintingStyle.fill;

      final x = p.xRatio * w;
      final y = p.yRatio * h;

      if (p.isCircle) {
        canvas.drawCircle(Offset(x, y), p.size, paint);
      } else {
        // Draw small rotated rectangle
        final path = Path()
          ..moveTo(x, y)
          ..lineTo(x + p.size, y + p.size * 0.5)
          ..lineTo(x + p.size * 0.5, y + p.size * 1.5)
          ..lineTo(x - p.size * 0.5, y + p.size)
          ..close();
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ConfettiParticle {
  late double xRatio;
  late double yRatio;
  late double size;
  late Color color;
  late bool isCircle;

  _ConfettiParticle() {
    final rand = Random();
    xRatio = rand.nextDouble();
    yRatio = rand.nextDouble() * 0.8; // mostly in upper/middle sections
    size = rand.nextDouble() * 8 + 4;
    isCircle = rand.nextBool();

    final colors = [
      ColourUtils.primary,
      ColourUtils.primaryLight,
      ColourUtils.info,
      ColourUtils.completed,
      ColourUtils.delayed,
    ];
    color = colors[rand.nextInt(colors.length)];
  }
}
