import 'dart:developer' as developer;
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:loyaltri_minimal/controller/userAuthentication.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:loyaltri_minimal/View/field/features/time_line/model/track_v2.dart';
import 'package:loyaltri_minimal/View/field/features/tracking/services/database_services.dart';
import 'package:loyaltri_minimal/models/user_profile_api_model.dart';
import 'package:loyaltri_minimal/services/api_services.dart';
import 'package:loyaltri_minimal/services/flutter_secure_storage.dart';
import 'package:loyaltri_minimal/utils/api_constants.dart';
import 'package:uuid/uuid.dart';

/// Native upload into `POST /employee-live-track-v2/locations`.
///
/// The background-geolocation plugin posts its own queue. Each record must
/// carry `extras.sessionId` from the shift opened at check-in.
class TrackV2Uploader {
  static const _sessionKey = 'v2_session_id';
  static const _sessionEmployeeKey = 'v2_session_employee';
  static const _networkKey = 'v2_network_state';
  static const _appKey = 'v2_app_state';
  static const _locationKey = 'v2_location_state';
  static const _powerKey = 'v2_power_state';
  static Future<void> _writeChain = Future<void>.value();

  static Future<String?> sessionId() async {
    final stored = await DatabaseService.instance.getSyncState(_sessionKey);
    if (stored == null || stored.isEmpty) return null;
    final owner = await DatabaseService.instance.getSyncState(
      _sessionEmployeeKey,
    );
    final employeeId = await _employeeId();
    if (owner != null &&
        owner.isNotEmpty &&
        employeeId.isNotEmpty &&
        owner != employeeId) {
      return null;
    }
    return stored;
  }

  /// Opens a shift id when one is not already active, then applies the HTTP config.
  /// Returns true when this call created the shift.
  /// Logout keeps the local id. Login also adopts the server's open shift so the
  /// timeline and the uploader stay on the same route.
  static Future<bool> openShift() async {
    final local = await sessionId();
    final employeeId = await _employeeId();
    final server = employeeId.isEmpty ? null : await _activeServerSessionId();
    var id = local;
    var created = false;
    if (server != null && server.isNotEmpty) {
      id = server;
    } else if (id == null) {
      if (employeeId.isEmpty) return false;
      id = const Uuid().v4();
      created = true;
    }
    await _saveSession(id);
    await configure();
    await rememberPowerSave();
    return created;
  }

  static Future<void> _saveSession(String id) async {
    await DatabaseService.instance.setSyncState(_sessionKey, id);
    final employeeId = await _employeeId();
    if (employeeId.isNotEmpty) {
      await DatabaseService.instance.setSyncState(
        _sessionEmployeeKey,
        employeeId,
      );
    }
  }

  static Future<String> _employeeId() async {
    final profile = await SecureStorageUtils().getProfileData();
    final fromProfile = profile?.result.employeeId ?? '';
    if (fromProfile.isNotEmpty) return fromProfile;
    if (!Get.isRegistered<UserAuthController>()) return '';
    return Get.find<UserAuthController>().userData.value.userData?.employeeId ??
        '';
  }

  /// Newest active shift on the server, so a new login continues that route.
  static Future<String?> _activeServerSessionId() async {
    final employeeId = await _employeeId();
    if (employeeId.isEmpty) return null;
    try {
      final resp = await ApiServices.getTrackV2Sessions(employeeId: employeeId);
      final data = trackV2SessionItems(resp['data'] ?? resp['result']);
      if (data.isEmpty) return null;
      TrackV2Session? newest;
      for (final item in data) {
        if (item is! Map) continue;
        final shift = TrackV2Session.fromJson(Map<String, dynamic>.from(item));
        final id = shift.id;
        if (!shift.isActive || id == null || id.isEmpty) continue;
        final next = shift.checkInAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final current = newest?.checkInAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        if (newest == null || next.isAfter(current)) newest = shift;
      }
      return newest?.id;
    } catch (e) {
      developer.log('[TrackV2] active session lookup failed: $e');
      return null;
    }
  }

  static Future<void> clearSession() async {
    await DatabaseService.instance.setSyncState(_sessionKey, '');
    await DatabaseService.instance.setSyncState(_sessionEmployeeKey, '');
    await DatabaseService.instance.setSyncState(_networkKey, '');
    await DatabaseService.instance.setSyncState(_appKey, '');
    await DatabaseService.instance.setSyncState(_locationKey, '');
    await DatabaseService.instance.setSyncState(_powerKey, '');
  }

  static Future<bg.HttpConfig?> httpConfig() async {
    try {
      await _refreshToken();
    } catch (e) {
      developer.log('[TrackV2] token refresh failed: $e');
    }

    final profile = await SecureStorageUtils().getProfileData();
    final user = await SecureStorageUtils().getUserData();
    final employeeId = int.tryParse(profile?.result.employeeId ?? '') ?? 0;
    final companyId = int.tryParse(profile?.result.companyId ?? '') ?? 0;
    final token = user?.userData?.token ?? '';
    final shiftId = await sessionId();
    if (employeeId == 0 || companyId == 0 || token.isEmpty || shiftId == null) {
      return null;
    }

    return bg.HttpConfig(
      method: 'POST',
      url: '${ApiConstants().loyaltriField}${ApiConstants().syncTrackV2Locations}',
      autoSync: true,
      autoSyncThreshold: 1,
      batchSync: true,
      maxBatchSize: 50,
      rootProperty: 'location',
      timeout: 60000,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      params: {
        'employee_id': employeeId,
        'company_id': companyId,
      },
    );
  }

  static Future<void>? _unauthorizedRetry;
  static DateTime? _unauthorizedCooldown;

  static Future<bool> configure() async {
    final http = await httpConfig();
    final shiftId = await sessionId();
    if (http == null || shiftId == null) return false;

    await bg.BackgroundGeolocation.setConfig(
      bg.Config(
        http: http,
        persistence: bg.PersistenceConfig(
          extras: {'sessionId': shiftId},
        ),
      ),
    );
    return true;
  }

  /// The plugin keeps posting with the token from the last [configure].
  /// A 401 means that token was rejected, so refresh it and upload the queue again.
  /// [BackgroundGeolocation.sync] is only called after HTTP config is applied.
  static Future<void> refreshAfterUnauthorized() {
    final now = DateTime.now();
    if (_unauthorizedCooldown != null && now.isBefore(_unauthorizedCooldown!)) {
      return Future.value();
    }
    _unauthorizedCooldown = now.add(const Duration(seconds: 20));
    final inFlight = _unauthorizedRetry;
    if (inFlight != null) return inFlight;

    final run = _retryUnauthorizedUpload();
    _unauthorizedRetry = run;
    return run.whenComplete(() {
      if (identical(_unauthorizedRetry, run)) _unauthorizedRetry = null;
    });
  }

  static Future<void> _retryUnauthorizedUpload() async {
    final applied = await configure();
    if (!applied) {
      developer.log('[TrackV2] 401 refresh could not apply HTTP config');
      return;
    }
    try {
      await bg.BackgroundGeolocation.sync();
    } catch (e) {
      developer.log('[TrackV2] retry upload after 401 failed: $e');
    }
  }

  static Future<void> postCheckIn() async {
    double? latitude;
    double? longitude;
    var hasFix = false;
    try {
      final location = await bg.BackgroundGeolocation.getCurrentPosition(
        samples: 1,
        timeout: 12,
        maximumAge: 20000,
        persist: false,
      );
      latitude = location.coords.latitude;
      longitude = location.coords.longitude;
      hasFix = true;
    } catch (e) {
      developer.log('[TrackV2] check-in location unavailable: $e');
    }

    await postEvent(
      type: 'checkIn',
      latitude: latitude,
      longitude: longitude,
      data: {
        'platform': Platform.isAndroid ? 'android' : Platform.operatingSystem,
        'hasFix': hasFix,
        'device': await _deviceSnapshot(),
      },
    );
  }

  static Future<void> postCheckOut() async {
    double distance = 0;
    try {
      distance = await bg.BackgroundGeolocation.odometer;
    } catch (_) {}

    final fix = await _latestFix();
    await postEvent(
      type: 'checkOut',
      latitude: fix.latitude,
      longitude: fix.longitude,
      data: {
        'distance': distance,
        'hasFix': fix.hasFix,
      },
    );
  }

  static Future<void> postActivity(String activity, int confidence) async {
    final fix = await _latestFix();
    await postEvent(
      type: 'activityChange',
      latitude: fix.latitude,
      longitude: fix.longitude,
      data: {
        'activity': activity,
        'confidence': confidence,
      },
    );
  }

  /// Plugin connectivity: `true` when the device has a network connection.
  static Future<void> postConnectivity(bool connected) {
    return _serialized(() async {
      if (await sessionId() == null) return;
      final next = connected ? 'online' : 'offline';
      final last = await _state(_networkKey);
      if (last == next) return;
      final from = last == null ? !connected : last == 'online';
      await DatabaseService.instance.setSyncState(_networkKey, next);
      await postDeviceChange(signal: 'network', from: from, to: connected);
    });
  }

  /// Plugin provider change: `true` when device location services are on.
  /// The first reading of a shift is stored and does not create a chip.
  static Future<void> postLocationServices(bool enabled) {
    return _serialized(() async {
      if (await sessionId() == null) return;
      final next = enabled ? 'on' : 'off';
      final last = await _state(_locationKey);
      if (last == next) return;
      await DatabaseService.instance.setSyncState(_locationKey, next);
      if (last == null) return;
      await postDeviceChange(
        signal: 'locationServices',
        from: !enabled,
        to: enabled,
      );
    });
  }

  /// Stores the current battery-saver state at check-in.
  /// When saver is already on, posts a timeline chip for that shift.
  static Future<void> rememberPowerSave() {
    return _serialized(() async {
      if (await sessionId() == null) return;
      if (await _state(_powerKey) != null) return;
      try {
        final enabled = await bg.DeviceSettings.isPowerSaveMode;
        await DatabaseService.instance.setSyncState(
          _powerKey,
          enabled ? 'on' : 'off',
        );
        if (enabled) {
          await postDeviceChange(
            signal: 'powerSaveMode',
            from: false,
            to: true,
          );
        }
      } catch (e) {
        developer.log('[TrackV2] power-save state unavailable: $e');
      }
    });
  }

  /// Plugin power-save change. `true` means battery saver is on.
  static Future<void> postPowerSave(bool enabled) {
    return _serialized(() async {
      if (await sessionId() == null) return;
      final next = enabled ? 'on' : 'off';
      final last = await _state(_powerKey);
      if (last == next) return;
      await DatabaseService.instance.setSyncState(_powerKey, next);
      if (last == null) return;
      await postDeviceChange(
        signal: 'powerSaveMode',
        from: !enabled,
        to: enabled,
      );
    });
  }

  /// App process left the foreground, or the plugin reported termination.
  static Future<void> postAppClosed() {
    return _postApp(closed: true);
  }

  /// App returned to the foreground. The first open of a shift is not a chip.
  static Future<void> postAppOpened() {
    return _postApp(closed: false);
  }

  static Future<void> _postApp({required bool closed}) {
    return _serialized(() async {
      if (await sessionId() == null) return;
      final next = closed ? 'closed' : 'open';
      final last = await _state(_appKey);
      if (last == next) return;
      if (last == null && !closed) {
        await DatabaseService.instance.setSyncState(_appKey, 'open');
        return;
      }
      await DatabaseService.instance.setSyncState(_appKey, next);
      await postDeviceChange(
        signal: 'appTerminated',
        from: !closed,
        to: closed,
      );
    });
  }

  static Future<void> postDeviceChange({
    required String signal,
    required bool from,
    required bool to,
  }) async {
    final fix = await _latestFix();
    await postEvent(
      type: 'deviceChange',
      latitude: fix.latitude,
      longitude: fix.longitude,
      data: {
        'changes': [
          {'signal': signal, 'from': from, 'to': to},
        ],
      },
    );
  }

  static Future<({double? latitude, double? longitude, bool hasFix})>
  _latestFix() async {
    try {
      final location = await bg.BackgroundGeolocation.getCurrentPosition(
        samples: 1,
        timeout: 8,
        maximumAge: 120000,
        persist: false,
      );
      return (
        latitude: location.coords.latitude,
        longitude: location.coords.longitude,
        hasFix: true,
      );
    } catch (e) {
      developer.log('[TrackV2] latest fix unavailable: $e');
      return (latitude: null, longitude: null, hasFix: false);
    }
  }

  static Future<String?> _state(String key) async {
    final value = await DatabaseService.instance.getSyncState(key);
    if (value == null || value.isEmpty) return null;
    return value;
  }

  static Future<void> _serialized(Future<void> Function() action) {
    final run = _writeChain.then((_) => action());
    _writeChain = run.then<void>((_) {}, onError: (Object _, StackTrace __) {});
    return run;
  }

  static Future<void> postEvent({
    required String type,
    required Map<String, dynamic> data,
    double? latitude,
    double? longitude,
  }) async {
    final shiftId = await sessionId();
    if (shiftId == null) return;

    final record = <String, dynamic>{
      'timestamp': DateTime.now().toUtc().toIso8601String(),
      'event': type,
      'extras': {
        'sessionId': shiftId,
        'kind': 'event',
        'type': type,
        'data': data,
      },
    };
    if (latitude != null && longitude != null) {
      record['coords'] = {
        'latitude': latitude,
        'longitude': longitude,
        'accuracy': -1,
        'speed': -1,
        'heading': -1,
        'altitude': -1,
      };
    }

    try {
      await bg.BackgroundGeolocation.insertLocation(record);
    } catch (e) {
      developer.log('[TrackV2] insert $type failed: $e');
    }
  }

  static Future<Map<String, dynamic>> _deviceSnapshot() async {
    try {
      final info = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final android = await info.androidInfo;
        return {
          'model': android.model,
          'manufacturer': android.manufacturer,
          'platform': 'android',
          'osVersion': android.version.release,
        };
      }
      if (Platform.isIOS) {
        final ios = await info.iosInfo;
        return {
          'model': ios.utsname.machine,
          'manufacturer': 'Apple',
          'platform': 'ios',
          'osVersion': ios.systemVersion,
        };
      }
    } catch (e) {
      developer.log('[TrackV2] device info unavailable: $e');
    }
    return {'platform': Platform.operatingSystem};
  }

  static Future<void> _refreshToken() async {
    final userData = await SecureStorageUtils().getUserData();
    String? companyId;
    final UserProfileApiModel? profileData =
        await SecureStorageUtils().getProfileData();
    if (profileData != null) {
      companyId = profileData.result.companyId;
    }
    final initResp = await ApiServices.getTokenInBG(
      username: userData?.userData?.email,
      compId: companyId,
    );
    if (initResp?['result'] != null &&
        initResp?['result'] is String &&
        (initResp?['result'].toString().trim().isNotEmpty ?? false)) {
      userData?.userData?.token = initResp?['result'];
      await SecureStorageUtils().removeUserData();
      await SecureStorageUtils().setUserData(userData!.toJson());
    }
  }
}
