
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loyaltri_minimal/controller/attendanceUploadController.dart';
import 'package:loyaltri_minimal/controller/locationFetchController.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';
import '../../controller/userAuthentication.dart';
import 'home_widgets/map_check-in_view.dart';

class MapCheckInView extends StatefulWidget {
  final String whichCheck;
  final bool isCheckIn;
  final bool geoSelfie;
  const MapCheckInView({super.key, required this.whichCheck, required this.isCheckIn, required this.geoSelfie});

  @override
  State<MapCheckInView> createState() => _MapCheckInViewState();
}

class _MapCheckInViewState extends State<MapCheckInView> {
  AttendanceUploadController attendanceUploadController =
  Get.find<AttendanceUploadController>();
  UserAuthController userAuthController = Get.find<UserAuthController>();
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _fetchLocationIfNeeded();
  }

  Future<void> _fetchLocationIfNeeded() async {
    final locationFetch = Get.find<LocationFetchController>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        context.loaderOverlay.show();
      }
      try {
        await locationFetch.fetchLocationData();
      } catch (_) {}
      if (mounted) {
        context.loaderOverlay.hide();
      }
    });
  }

  Future<void> _animateToPosition(Position position) async {
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 16,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // transparent status bar
        statusBarIconBrightness: Platform.isIOS ? Brightness.light : Brightness.dark, // dark icons
        statusBarBrightness: Platform.isIOS ? Brightness.light : Brightness.dark, // iOS
      ),
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: Colors.black,
          body: GetX<LocationFetchController>(
            builder: (LocationFetchController controller) {
              if(controller.position.value?.latitude != null && controller.position.value?.longitude != null) {
                if (_mapController != null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _animateToPosition(controller.position.value!);
                  });
                }
                return Stack(
                  children: [
                    GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(controller.position.value!.latitude, controller.position.value!.longitude),
                        zoom: 16,
                      ),
                      // myLocationEnabled: true,
                      markers: <Marker>{
                        Marker(
                          markerId: MarkerId('loc'),
                          position: LatLng(controller.position.value!.latitude, controller.position.value!.longitude,
                          ),
                        ),
                      },
                      zoomControlsEnabled: false,
                      onMapCreated: (GoogleMapController controller) {
                        _mapController = controller;
                      },
                    ),
                    Positioned(
                      bottom: 10.h,
                      left: 10.h,
                      right: 10.h,
                      child: MapCheckInWidget(whichCheck: widget.whichCheck, isCheckIn: widget.isCheckIn, position: controller.position.value, geoSelfie: widget.geoSelfie),
                    ),
                  ],
                );
              } else {
                return Center(
                    child: Padding(
                      padding: EdgeInsets.all(70.h),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8).r,
                        onTap: () async {
                          context.loaderOverlay.show();
                          await controller.fetchLocationData();
                          context.loaderOverlay.hide();
                          setState(() {});
                        },
                        child: Padding(
                          padding: EdgeInsets.all(8.0).h,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                    'Loading...',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    color: Colors.deepPurpleAccent,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15.h,
                                  ),
                                ),
                              ),
                              SizedBox(width: 3.h),
                              Icon(
                                  Icons.refresh,
                                  color: Colors.deepPurpleAccent,
                                size: 18.h,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                );
              }
            }
          ),
        ),
      ),
    );
  }
}
