import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart' as date;
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/View/field/features/tracking/model/company_setting_model.dart';
import 'package:loyaltri_minimal/View/field/features/tracking/services/database_services.dart';
import 'package:loyaltri_minimal/View/field/features/time_line/controller/timeline_controller.dart';
import 'package:loyaltri_minimal/View/field/features/tracking/services/track_v2_uploader.dart';
import 'package:loyaltri_minimal/controller/userAuthentication.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';
import 'package:loyaltri_minimal/services/api_services.dart';
import 'package:loyaltri_minimal/services/flutter_secure_storage.dart';

class TrackingController extends GetxController with WidgetsBindingObserver {
  // int get employeeId => SyncManager.employeeId;
  final Rx<CompanySettingData?> companySettings = Rxn<CompanySettingData>();
  final RxBool isTracking = false.obs;
  final RxBool isWorking = false.obs;

  // Google Maps and route tracking state
  final RxSet<Polyline> polylines = <Polyline>{}.obs;
  final RxSet<Marker> markers = <Marker>{}.obs;
  final Rxn<LatLng> currentPosition = Rxn<LatLng>();
  GoogleMapController? mapController;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _asyncInit();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    mapController?.dispose();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        restoreRouteAndState();
        TrackV2Uploader.postAppOpened();
        break;
      case AppLifecycleState.paused ||
          AppLifecycleState.detached ||
          AppLifecycleState.hidden:
        TrackV2Uploader.postAppClosed();
        break;
      case AppLifecycleState.inactive:
        break;
    }
  }

  Future<void> _asyncInit() async {
    await _loadCachedCompanySettings();
    configureBackgroundGeolocation();
    fetchCompanySettings();
    await restoreRouteAndState();
    await checkServiceState();
  }

  Future<void> _loadCachedCompanySettings() async {
    try {
      final cachedJson = await DatabaseService.instance
          .getCachedCompanySettings();
      if (cachedJson != null && cachedJson.isNotEmpty) {
        final decoded = json.decode(cachedJson);
        companySettings.value = CompanySettingData.fromJson(decoded);
      }
    } catch (e) {
      // print('[TrackingController] Error loading cached settings: $e');
    }
  }

  Future<void> fetchCompanySettings({String? compId}) async {
    try {
      String resolvedCompanyId = compId ?? '';
      if (resolvedCompanyId.isEmpty &&
          Get.isRegistered<UserProfileController>()) {
        resolvedCompanyId =
            Get.find<UserProfileController>().userData.value.result.companyId
                ?.toString() ??
            '';
      }
      if (resolvedCompanyId.isEmpty) {
        final profileData = await SecureStorageUtils().getProfileData();
        resolvedCompanyId = profileData?.result.companyId?.toString() ?? '';
      }

      if (resolvedCompanyId.isEmpty || resolvedCompanyId == '0') {
        // print('[TrackingController] No valid company ID found to fetch settings.');
        return;
      }

      final resp = await ApiServices.getCompanySettings(
        companyId: resolvedCompanyId,
      );
      if (resp['status'] == 200 && resp['data'] != null) {
        final settingsData = CompanySettingData.fromJson(resp['data']);
        companySettings.value = settingsData;
        await DatabaseService.instance.saveCachedCompanySettings(
          json.encode(resp['data']),
        );
        await applyCompanySettingsToTracking(settingsData);
      }
    } catch (e) {
      // print('[TrackingController] Error fetching company settings: $e');
    }
  }

  Future<void> applyCompanySettingsToTracking(
    CompanySettingData? settings,
  ) async {
    if (settings == null) return;
    try {
      // final intervalMillis = settings.locationIntervalMillis;
      // final idleMins = settings.idleTimeMinutes;
      // final geofenceRadius = settings.geofencingRadiusMeters.toInt();

      // await bg.BackgroundGeolocation.setConfig(
      //   bg.Config(
      //     locationUpdateInterval: intervalMillis,
      //     fastestLocationUpdateInterval: intervalMillis,
      //     stopTimeout: idleMins,
      //     geofenceProximityRadius: geofenceRadius,
      //   ),
      // );
      // print(
      //   '[TrackingController] Applied dynamic tracking config: interval=${settings.locationInterval} (${intervalMillis}ms), idleTime=${settings.idleTime} (${idleMins}m), geofenceRadius=${geofenceRadius}m',
      // );
    } catch (e) {
      // print('[TrackingController] Error applying tracking config: $e');
    }
  }


  /// Sets up BackgroundGeolocation listeners and configuration
  void configureBackgroundGeolocation()async {
    bg.BackgroundGeolocation.onLocation((bg.Location location) async {
      print('[BackgroundGeolocation onLocation] $location');
      final pos = LatLng(location.coords.latitude, location.coords.longitude);
      currentPosition.value = pos;
      mapController?.animateCamera(CameraUpdate.newLatLng(pos));
    });

    bg.BackgroundGeolocation.onActivityChange((
      bg.ActivityChangeEvent event,
    ) async {
      print('[BackgroundGeolocation onActivityChange] $event');
      await TrackV2Uploader.postActivity(event.activity, event.confidence);
    });

    bg.BackgroundGeolocation.onConnectivityChange((
      bg.ConnectivityChangeEvent event,
    ) async {
      print('[BackgroundGeolocation onConnectivityChange] $event');
      await TrackV2Uploader.postConnectivity(event.connected);
    });

    bg.BackgroundGeolocation.onProviderChange((bg.ProviderChangeEvent event) async {
      print('[BackgroundGeolocation onProviderChange] $event');
      await TrackV2Uploader.postLocationServices(event.enabled);
    });

    await TrackV2Uploader.rememberPowerSave();
    bg.BackgroundGeolocation.onPowerSaveChange((bool enabled) async {
      print('[BackgroundGeolocation onPowerSaveChange] $enabled');
      await TrackV2Uploader.postPowerSave(enabled);
    });

    // final initialSettings = companySettings.value;
    // final int intervalMillis =
    //     initialSettings?.locationIntervalMillis ?? 300000;
    // final int idleMins = initialSettings?.idleTimeMinutes ?? 10;
    // final int geofenceRadius =
    //     initialSettings?.geofencingRadiusMeters.toInt() ?? 500;

        // Fetch a token from the server (the SDK caches it automatically).
        // final url = "https://tracker.transistorsoft.com";
        // final orgname = "cordova";
        // final username = "ios";

    // final token = await bg.BackgroundGeolocation.findOrCreateTransistorAuthorizationToken(
    //               orgname, username, url
    //               );
    // bg.TransistorAuthorizationToken token = await
    // bg.TransistorAuthorizationToken.findOrCreate(orgname, username);

    final http = await TrackV2Uploader.httpConfig();
    final shiftId = await TrackV2Uploader.sessionId();

    bg.BackgroundGeolocation.onHttp((bg.HttpEvent event) {
      print('[BackgroundGeolocation http] $event success=${event.success}');
      print('[BackgroundGeolocation http] ${event.status} success=${event.success}');
      if (event.status == 401) {
        TrackV2Uploader.refreshAfterUnauthorized();
      }
    });

    bg.BackgroundGeolocation.ready(
      bg.Config(
        isMoving: true,
        reset: true, // Forces updated configuration into native iOS/Android layer on launch

        // --- Stop-Detection & Continuous Shift Tracking ---
        activity: const bg.ActivityConfig(
          disableStopDetection: true,
          disableMotionActivityUpdates: false, // CRITICAL: Never shut off GPS when device stops at traffic lights/signals during shift
          stopOnStationary: false,
        ),

        // --- Geolocation Configuration ---
        geolocation: bg.GeoConfig(
          desiredAccuracy: bg.DesiredAccuracy.high,
          distanceFilter: 25.0,
          stationaryRadius: 50,
          activityType: bg.ActivityType.otherNavigation, // CRITICAL: Avoid automotiveNavigation pause heuristics on iOS
          geofenceModeHighAccuracy: true,
          locationAuthorizationRequest: 'Always',
          disableLocationAuthorizationAlert: false,
          pausesLocationUpdatesAutomatically: false, // CRITICAL FOR IOS: Never let iOS pause location updates
          showsBackgroundLocationIndicator: true,
          disableElasticity: false, // Allow distanceFilter to stay responsive
          stopTimeout: 15,
          filter: const bg.LocationFilter(
            policy: bg.LocationFilterPolicy.adjust, // 'adjust' prevents rejecting valid highway GPS points
            useKalman: true,
            kalmanProfile: bg.KalmanProfile.defaultProfile,
          ),
          locationAuthorizationAlert: {
            'titleWhenNotEnabled': 'location-services not enabled',
            'titleWhenOff': 'location-services OFF',
            'instructions':
                "Please enable 'Always' in Location Services settings so Loyaltri can record your work route.",
            'cancelButton': 'Cancel',
            'settingsButton': 'Settings',
          },
        ),

        stopOnTerminate: false,
        startOnBoot: true,
        enableHeadless: true,

        // --- App Lifecycle & Background Configuration ---
        app: const bg.AppConfig(
          stopOnTerminate: false, // Tells iOS to register stationary geofence on kill
          startOnBoot: true,      // Resume tracking after device reboot
          enableHeadless: true,   // Allow background execution
          preventSuspend: true,   // CRITICAL FOR IOS: Prevents iOS from suspending app when phone is locked
        ),

        // Plugin posts each fix itself. See HttpConfig autoSync.
        http: http,
        persistence: bg.PersistenceConfig(
          persistMode: bg.PersistMode.all,
          maxDaysToPersist: 1,
          extras: shiftId == null ? null : {'sessionId': shiftId},
        ),

        // --- Release & Logging Configuration ---
        logger: const bg.LoggerConfig(
          debug: false,
          logLevel: bg.LogLevel.off,
        ),

        backgroundPermissionRationale: bg.PermissionRationale(
          title:
              "Allow Loyaltri to access this device's location in the background?",
          message:
              "Loyaltri collects location data to enable real-time field route tracking, client visit verification, and travel distance calculation even when the app is closed or not in use during your active work shifts.",
          positiveAction: "Change to 'Allow all the time'",
          negativeAction: "Cancel",
        ),
        notification: bg.Notification(
          title: "Live Route Tracking Active",
          text: "Continuously monitoring GPS coordinates in the background...",
          channelName: "Live Tracking Channel",
          priority: bg.NotificationPriority.high,
          sticky: true,
        ),
      ),
    ).then((state) async {
      await TrackV2Uploader.configure();
      await TrackV2Uploader.postAppOpened();
      if (state.enabled) {
        isTracking.value = true;
      }
    });
  }

  /// Restores tracking state after the app returns to the foreground.
  Future<void> restoreRouteAndState() async {
    isWorking.value = await DatabaseService.instance.hasActiveWork();
    await TrackV2Uploader.configure();

    final state = await bg.BackgroundGeolocation.state;
    if (state.enabled) {
      isTracking.value = true;
    }
  }


  /// Checks whether live tracking is enabled.
  Future<void> checkServiceState() async {
    final state = await bg.BackgroundGeolocation.state;
    isTracking.value = state.enabled;
    isWorking.value = await DatabaseService.instance.hasActiveWork();
  }

  /// Starts the tracking process
  Future<void> startTracking() async {
    // Apply latest company tracking settings
    if (companySettings.value != null) {
      await applyCompanySettingsToTracking(companySettings.value);
    }

    final openedShift = await TrackV2Uploader.openShift();
    final state = await bg.BackgroundGeolocation.state;
    if (!state.enabled) {
      await bg.BackgroundGeolocation.start();
      await bg.BackgroundGeolocation.changePace(true);
    }
    if (openedShift) {
      await TrackV2Uploader.postCheckIn();
    }

    isTracking.value = true;
    await checkServiceState();
    if (Get.isRegistered<TimelineController>()) {
      Get.find<TimelineController>().refreshShifts(keepSelection: false);
    }
  }

  /// Ends the tracking process
  Future<void> endTracking() async {
    if (!isTracking.value) return;

    if (isWorking.value) {
      Get.snackbar(
        'Action Required',
        'Please end your work session before stopping tracking.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        borderRadius: 12.0,
        margin: const EdgeInsets.all(16.0),
      );
      return;
    }

    // Stop background location tracking after the check-out event is queued.
    await TrackV2Uploader.postCheckOut();
    await bg.BackgroundGeolocation.stop();

    isTracking.value = false;

    await TrackV2Uploader.clearSession();
  }

  Future<void> startWork({required workId}) async {
    if (!isTracking.value || isWorking.value) return;
    await DatabaseService.instance.setActiveWork(true);
    isWorking.value = true;
  }

  Future<void> endWork({required workId}) async {
    if (!isWorking.value) return;
    await DatabaseService.instance.setActiveWork(false);
    isWorking.value = false;
  }

  /// Wipes local tracking state. Called on logout.
  Future<void> clearLogs() async {
    await DatabaseService.instance.clearSyncState(keepShift: true);
    isWorking.value = false;
    polylines.clear();
    markers.clear();
    currentPosition.value = null;
    await checkServiceState();
  }

  Future<bool> checkEmployeWorkStatus() async {
    try {
      final int empId =
          int.tryParse(
            Get.find<UserAuthController>()
                    .userData
                    .value
                    .userData
                    ?.employeeId ??
                '',
          ) ??
          0;

      final int compId =
          int.tryParse(
            Get.find<UserProfileController>().userData.value.result.companyId ??
                '',
          ) ??
          0;

      final String todayDate = date.DateFormat(
        'yyyy-MM-dd',
      ).format(DateTime.now());

      final body = {
        "company_id": compId,
        "employee_id": empId,
        "date": todayDate,
      };

      final resp = await ApiServices.checkEmployeWorkStatus(body: body);

      AttendanceCommonWidgets().printF("Body ----- $body");
      AttendanceCommonWidgets().printF("Response ----- $resp");

      if (resp['status'] == 200) {
        return resp['data']?['in_work'] ?? false;
      }

      // print("Error =============== ${resp["message"]}");
      return false;
    } catch (e) {
      debugPrint('Employee work status error: $e');
      return false;
    }
  }

  // syncLocation() async {
  //   await SyncManager.checkAndSync(force: true);
  // }
}
