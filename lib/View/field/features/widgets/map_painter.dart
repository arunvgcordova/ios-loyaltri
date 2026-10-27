import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loyaltri_minimal/View/field/features/tracking/tracker_controller.dart';
import '../../core/colour_utils.dart';

class MapPreviewWidget extends StatelessWidget {
  final bool showRoute;
  final bool showGeofence;
  final double height;

  const MapPreviewWidget({
    super.key,
    this.showRoute = false,
    this.showGeofence = false,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    final TrackingController controller = Get.put(TrackingController());
    return Stack(children: [_buildMapCard(controller)]);
  }
}

Widget _buildMapCard(TrackingController controller) {
  return Obx(() {
    final isTracking = controller.isTracking.value;
    final currentPos = controller.currentPosition.value;

    final CameraPosition initialPosition = CameraPosition(
      target: currentPos ?? const LatLng(0.0, 0.0),
      zoom: currentPos != null ? 16.0 : 2.0,
    );

    return Container(
      height: 210.h,
      decoration: BoxDecoration(
        color: const Color(0xFF14171A),
        borderRadius: BorderRadius.circular(12.h),
        border: Border.all(
          color: ColourUtils.textWhite.withValues(alpha: 0.1),
          width: 1.h,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6.0),
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: initialPosition,
              onMapCreated: (GoogleMapController mapCtrl) {
                controller.mapController = mapCtrl;
                if (currentPos != null) {
                  mapCtrl.animateCamera(CameraUpdate.newLatLng(currentPos));
                }
              },
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer(),
                ),
              },
              polylines: controller.polylines,
              markers: controller.markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: false,
              compassEnabled: true,
              mapToolbarEnabled: false,
            ),
            if (!isTracking && currentPos == null)
              Container(
                color: const Color(0xFF0F172A).withOpacity(0.85),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.map_outlined,
                        color: Color(0xFF64748B),
                        size: 40.0,
                      ),
                      const SizedBox(height: 8.0),
                      const Text(
                        'Map Track Inactive',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      const Text(
                        'Press Start Tracking to begin live mapping.',
                        style: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 11.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  });
}

class MapPainter extends CustomPainter {
  final bool showRoute;
  final bool showGeofence;

  MapPainter({required this.showRoute, required this.showGeofence});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Paints
    final gridPaint = Paint()
      ..color = const Color(0xFF1D2024)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final roadPaint = Paint()
      ..color = const Color(0xFF23272C)
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final roadCenterPaint = Paint()
      ..color = const Color(0xFF2C3138)
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Draw stylized background grids
    const double gridSize = 40.0;
    for (double i = 0; i < w; i += gridSize) {
      canvas.drawLine(Offset(i, 0), Offset(i, h), gridPaint);
    }
    for (double j = 0; j < h; j += gridSize) {
      canvas.drawLine(Offset(0, j), Offset(w, j), gridPaint);
    }

    // Draw Stylized Water Body/Park
    final waterPaint = Paint()
      ..color = const Color(0xFF152230)
      ..style = PaintingStyle.fill;
    final waterPath = Path()
      ..moveTo(0, h * 0.8)
      ..quadraticBezierTo(w * 0.4, h * 0.7, w * 0.6, h * 0.9)
      ..quadraticBezierTo(w * 0.8, h * 1.0, w, h * 0.85)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(waterPath, waterPaint);

    // Draw Stylized Roads
    final roadPath1 = Path()
      ..moveTo(-10, h * 0.3)
      ..lineTo(w * 0.4, h * 0.3)
      ..quadraticBezierTo(w * 0.5, h * 0.3, w * 0.5, h * 0.5)
      ..lineTo(w * 0.5, h + 10);

    final roadPath2 = Path()
      ..moveTo(w * 0.2, -10)
      ..lineTo(w * 0.2, h * 0.3)
      ..lineTo(w + 10, h * 0.3);

    final roadPath3 = Path()
      ..moveTo(w * 0.5, h * 0.6)
      ..lineTo(w + 10, h * 0.6);

    canvas.drawPath(roadPath1, roadPaint);
    canvas.drawPath(roadPath1, roadCenterPaint);

    canvas.drawPath(roadPath2, roadPaint);
    canvas.drawPath(roadPath2, roadCenterPaint);

    canvas.drawPath(roadPath3, roadPaint);
    canvas.drawPath(roadPath3, roadCenterPaint);

    // Draw Geofence circle
    if (showGeofence) {
      final center = Offset(w * 0.5, h * 0.45);
      final geofencePaint = Paint()
        ..color = ColourUtils.overdue.withOpacity(0.12)
        ..style = PaintingStyle.fill;

      final geofenceBorderPaint = Paint()
        ..color = ColourUtils.overdue
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      canvas.drawCircle(center, 45, geofencePaint);

      // Draw dashed stroke for geofence
      const double dashWidth = 5.0;
      const double dashSpace = 4.0;
      double startAngle = 0.0;
      while (startAngle < 360.0) {
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: 45),
          startAngle * 3.14159 / 180.0,
          dashWidth * 3.14159 / 180.0,
          false,
          geofenceBorderPaint,
        );
        startAngle += dashWidth + dashSpace;
      }
    }

    // Draw Route Path
    if (showRoute) {
      final routePaint = Paint()
        ..color = ColourUtils.primary
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;

      final routePath = Path()
        ..moveTo(w * 0.2, h * 0.2)
        ..lineTo(w * 0.2, h * 0.3)
        ..lineTo(w * 0.5, h * 0.3)
        ..lineTo(w * 0.5, h * 0.6)
        ..lineTo(w * 0.75, h * 0.6);

      canvas.drawPath(routePath, routePaint);

      // Draw start and end pin
      _drawPin(canvas, Offset(w * 0.2, h * 0.2), ColourUtils.completed);
      _drawPin(canvas, Offset(w * 0.75, h * 0.6), ColourUtils.primary);
    } else {
      // Draw single target pin in middle of geofence or screen
      _drawPin(canvas, Offset(w * 0.5, h * 0.45), ColourUtils.primary);
    }
  }

  void _drawPin(Canvas canvas, Offset position, Color color) {
    final pinPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final pinOutlinePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    // Draw shadow circle
    canvas.drawCircle(position + const Offset(0, 3), 5, shadowPaint);

    // Draw pin tear shape
    final path = Path()
      ..moveTo(position.dx, position.dy)
      ..quadraticBezierTo(
        position.dx - 8,
        position.dy - 10,
        position.dx - 8,
        position.dy - 16,
      )
      ..arcToPoint(
        Offset(position.dx + 8, position.dy - 16),
        radius: const Radius.circular(8),
      )
      ..quadraticBezierTo(
        position.dx + 8,
        position.dy - 10,
        position.dx,
        position.dy,
      )
      ..close();

    canvas.drawPath(path, pinPaint);
    canvas.drawPath(path, pinOutlinePaint);

    // Inner white dot
    canvas.drawCircle(
      Offset(position.dx, position.dy - 16),
      3,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}



