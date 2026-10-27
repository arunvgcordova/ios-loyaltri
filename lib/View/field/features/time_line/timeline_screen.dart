import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loyaltri_minimal/View/field/features/time_line/controller/timeline_controller.dart';
import 'package:loyaltri_minimal/View/field/features/time_line/timeline_format.dart';
import 'package:loyaltri_minimal/View/field/features/time_line/widget/activity_sheet.dart';
import 'package:loyaltri_minimal/View/field/features/time_line/widget/shift_history_sheet.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  late final TimelineController controller;
  Worker? _mapWorker;

  @override
  void initState() {
    super.initState();
    controller = Get.put(TimelineController());
    _mapWorker = ever(controller.mapRevision, (_) {
      if (mounted) setState(() {});
    });
    controller.openTimeline();
  }

  @override
  void dispose() {
    _mapWorker?.dispose();
    if (Get.isRegistered<TimelineController>()) {
      Get.delete<TimelineController>();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fallback = controller.fallbackLatLng.value ?? const LatLng(8.5241, 76.9366);
    return Scaffold(
      backgroundColor: const Color(0xFF0B0D12),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: fallback, zoom: 12),
            onMapCreated: (mapController) {
              controller.mapController = mapController;
              controller.fitRoute();
            },
            polylines: controller.newPolylines.value,
            markers: controller.markers.toSet(),
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            compassEnabled: false,
            mapToolbarEnabled: false,
            padding: EdgeInsets.only(
              top: MediaQuery.paddingOf(context).top + 72.h,
              bottom: MediaQuery.sizeOf(context).height * 0.34,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
              child: Row(
                children: [
                  _roundButton(
                    icon: Icons.arrow_back_rounded,
                    onTap: () => Navigator.of(context).maybePop(),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Obx(() {
                      final shift = controller.selectedShift;
                      final label = shift == null
                          ? 'Activity timeline'
                          : shiftPillLabel(shift);
                      return _pill(
                        label: label,
                        onTap: () {
                          final start = shift?.checkInAt?.toLocal();
                          showShiftHistory(
                            context,
                            controller,
                            onlyDay: start == null
                                ? null
                                : DateTime(start.year, start.month, start.day),
                          );
                        },
                      );
                    }),
                  ),
                  SizedBox(width: 10.w),
                  _roundButton(
                    icon: Icons.schedule_rounded,
                    onTap: () => showShiftHistory(context, controller),
                  ),
                ],
              ),
            ),
          ),
          ActivitySheet(controller: controller),
        ],
      ),
    );
  }

  Widget _roundButton({required IconData icon, required VoidCallback onTap}) {
    return Material(
      color: const Color(0xFF111111),
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 46.w,
          height: 46.w,
          child: Icon(icon, color: Colors.white, size: 22.sp),
        ),
      ),
    );
  }

  Widget _pill({required String label, required VoidCallback onTap}) {
    return Material(
      color: const Color(0xFF111111),
      borderRadius: BorderRadius.circular(28.r),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 20.sp),
            ],
          ),
        ),
      ),
    );
  }
}
