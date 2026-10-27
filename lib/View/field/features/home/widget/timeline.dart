import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loyaltri_minimal/View/CWidgets/cwidgets.dart';
import 'package:loyaltri_minimal/View/field/core/colour_utils.dart';
import 'package:loyaltri_minimal/View/field/features/home/controller/home_controller.dart';
import 'package:loyaltri_minimal/View/field/features/time_line/timeline_screen.dart';
import 'package:loyaltri_minimal/View/field/features/tracking/tracker_controller.dart';

class TimelineMap extends StatelessWidget {
  const TimelineMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
        color: ColourUtils.bgColour6,
        borderRadius: BorderRadius.circular(16.h),
        border: Border.all(color: ColourUtils.borderColour, width: 1.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Timeline Activity',
                style: GoogleFonts.inter(
                  color: ColourUtils.textMain,
                  fontSize: 16.h,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),

              InkWell(
                onTap: () {
                  Navigator.push(context, newSlideNavigation(TimelineScreen()));
                },
                child: Text(
                  'View More',
                  style: GoogleFonts.inter(
                    color: ColourUtils.fontColour1,
                    fontSize: 12.h,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          SizedBox(
            width: double.infinity,
            height: 150.h,
            child: Obx(() {
              TrackingController controller = Get.find<TrackingController>();
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
                          // print("ushuahudais --- ${currentPos}");
                          if (currentPos != null) {
                            mapCtrl.animateCamera(
                              CameraUpdate.newLatLng(currentPos),
                            );
                          }
                        },
                        // gestureRecognizers:
                        //     <Factory<OneSequenceGestureRecognizer>>{
                        //       Factory<OneSequenceGestureRecognizer>(
                        //         () => EagerGestureRecognizer(),
                        //       ),
                        //     },
                        polylines:
                            Get.find<FieldHomeController>().newPolylines.value,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        zoomControlsEnabled: false,
                        compassEnabled: true,
                        mapToolbarEnabled: false,
                        scrollGesturesEnabled: false,
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
            }),
          ),
        ],
      ),
    );
  }
}