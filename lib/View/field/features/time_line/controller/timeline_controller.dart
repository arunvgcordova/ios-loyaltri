import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loyaltri_minimal/View/field/features/time_line/model/track_v2.dart';
import 'package:loyaltri_minimal/View/field/features/time_line/timeline_format.dart';
import 'package:loyaltri_minimal/View/field/features/tracking/services/track_v2_uploader.dart';
import 'package:loyaltri_minimal/controller/userAuthentication.dart';
import 'package:loyaltri_minimal/services/api_services.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

class TimelineController extends GetxController {
  Rx<Set<Polyline>> newPolylines = Rx({});

  RxBool isloading = false.obs;
  final RxSet<Marker> markers = <Marker>{}.obs;
  final Map<String, BitmapDescriptor> _markerIconCache = {};
  GoogleMapController? mapController;

  Rxn<LatLng> fallbackLatLng = Rxn<LatLng>();

  final RxList<TrackV2Session> shifts = <TrackV2Session>[].obs;
  final Rxn<TrackV2SessionDetail> sessionDetail = Rxn<TrackV2SessionDetail>();
  final RxnString selectedSessionId = RxnString();
  final RxString timelineError = ''.obs;
  final RxInt mapRevision = 0.obs;
  final List<LatLng> routeLatLngs = [];
  final Map<String, String> _placeCache = {};
  final Map<String, Future<String>> _describeCache = {};
  int _v2Request = 0;

  @override
  void onInit() {
    super.onInit();
    _fetchFallbackLocation();

    // Listen to changes in fallbackLatLng and animate map camera if mapController is active
    ever(fallbackLatLng, (LatLng? newLocation) {
      if (newLocation != null && mapController != null && routeLatLngs.isEmpty) {
        mapController!.animateCamera(CameraUpdate.newLatLng(newLocation));
      }
    });
  }

  Future<void> _fetchFallbackLocation() async {
    try {
      final Position? lastKnown = await Geolocator.getLastKnownPosition();
      if (lastKnown != null) {
        fallbackLatLng.value = LatLng(lastKnown.latitude, lastKnown.longitude);
      }
      final Position current = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
        timeLimit: const Duration(seconds: 5),
      );
      fallbackLatLng.value = LatLng(current.latitude, current.longitude);
    } catch (_) {}
  }

  double _calculateDistance(LatLng p1, LatLng p2) {
    const earthRadius = 6371000.0; // meters
    final lat1 = p1.latitude * math.pi / 180.0;
    final lat2 = p2.latitude * math.pi / 180.0;
    final dLat = lat2 - lat1;
    final dLon = (p2.longitude - p1.longitude) * math.pi / 180.0;

    final a =
        math.sin(dLat / 2.0) * math.sin(dLat / 2.0) +
        math.cos(lat1) *
            math.cos(lat2) *
            math.sin(dLon / 2.0) *
            math.sin(dLon / 2.0);
    final c = 2.0 * math.atan2(math.sqrt(a), math.sqrt(1.0 - a));
    return earthRadius * c;
  }

  TrackV2Session? get selectedShift {
    final id = selectedSessionId.value;
    if (id == null) return sessionDetail.value?.session;
    for (final shift in shifts) {
      if (shift.id == id) return shift;
    }
    return sessionDetail.value?.session;
  }

  Future<void> openTimeline() async {
    await refreshShifts(keepSelection: false);
  }

  Future<void> refreshShifts({bool keepSelection = true}) async {
    final token = ++_v2Request;
    isloading.value = true;
    timelineError.value = '';
    try {
      final empId = _employeeId();
      if (empId.isEmpty) {
        timelineError.value = 'Employee not found';
        return;
      }
      final resp = await ApiServices.getTrackV2Sessions(employeeId: empId);
      if (token != _v2Request || isClosed) return;
      final list = _parseShifts(resp['data']);
      shifts.assignAll(list);
      if (list.isEmpty) {
        selectedSessionId.value = null;
        sessionDetail.value = null;
        _clearRoute();
        return;
      }
      var id = keepSelection ? selectedSessionId.value : null;
      final localId = await TrackV2Uploader.sessionId();
      final trackingThisShift =
          localId != null && list.any((shift) => shift.id == localId);
      if (!keepSelection && trackingThisShift) {
        id = localId;
      } else {
        final exists = id != null && list.any((shift) => shift.id == id);
        if (!keepSelection || !exists) {
          id = _preferredShiftId(list);
        }
      }
      if (id == null || id.isEmpty) return;
      await _fetchSession(id, token);
    } catch (e, stackTrace) {
      debugPrint('refreshShifts error: $e');
      debugPrintStack(stackTrace: stackTrace);
      if (token == _v2Request && !isClosed) {
        timelineError.value = 'Could not load shifts';
      }
    } finally {
      if (token == _v2Request && !isClosed) isloading.value = false;
    }
  }

  Future<void> selectShift(String id) {
    return _fetchSession(id, ++_v2Request);
  }

  Future<void> _fetchSession(String id, int token) async {
    isloading.value = true;
    timelineError.value = '';
    selectedSessionId.value = id;
    try {
      final empId = _employeeId();
      final resp = await ApiServices.getTrackV2SessionDetail(
        sessionId: id,
        employeeId: empId,
      );
      if (token != _v2Request || isClosed) return;
      final data = resp['data'];
      if (data is Map) {
        final detail = TrackV2SessionDetail.fromJson(
          Map<String, dynamic>.from(data),
        );
        _describeCache.clear();
        sessionDetail.value = detail;
        await _drawSessionRoute(detail);
      } else {
        sessionDetail.value = null;
        _clearRoute();
      }
    } catch (e, stackTrace) {
      debugPrint('loadSession error: $e');
      debugPrintStack(stackTrace: stackTrace);
      if (token == _v2Request && !isClosed) {
        timelineError.value = 'Could not load this shift';
      }
    } finally {
      if (token == _v2Request && !isClosed) isloading.value = false;
    }
  }

  String? _preferredShiftId(List<TrackV2Session> list) {
    final ranked = [...list]..sort((a, b) {
      final activeRank = (b.isActive ? 1 : 0) - (a.isActive ? 1 : 0);
      if (activeRank != 0) return activeRank;
      final aTime = a.checkInAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bTime = b.checkInAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bTime.compareTo(aTime);
    });
    return ranked.first.id;
  }

  List<TrackV2Session> _parseShifts(dynamic data) {
    final items = trackV2SessionItems(data);
    if (items.isEmpty) return [];
    final list = <TrackV2Session>[];
    for (final item in items) {
      if (item is Map) {
        list.add(TrackV2Session.fromJson(Map<String, dynamic>.from(item)));
      }
    }
    return list;
  }

  String _employeeId() {
    return Get.find<UserAuthController>().userData.value.userData?.employeeId ??
        '';
  }

  void _clearRoute() {
    routeLatLngs.clear();
    newPolylines.value = {};
    markers.clear();
    mapRevision.value++;
  }

  Future<void> _drawSessionRoute(TrackV2SessionDetail detail) async {
    final points = List<TrackV2Point>.from(detail.points)
      ..sort((a, b) {
        final aTime = a.recordedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bTime = b.recordedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return aTime.compareTo(bTime);
      });

    final latLngs = <LatLng>[];
    for (final point in points) {
      if (point.lat == 0 && point.lng == 0) continue;
      latLngs.add(LatLng(point.lat, point.lng));
    }
    if (latLngs.isEmpty) {
      for (final entry in detail.timeline) {
        for (final pair in entry.path) {
          latLngs.add(LatLng(pair[0], pair[1]));
        }
      }
    }

    routeLatLngs
      ..clear()
      ..addAll(_thinRoute(latLngs));

    const routeColor = Color(0xFFC5B4F3);
    final polylines = <Polyline>{};
    if (routeLatLngs.length > 1) {
      polylines.add(
        Polyline(
          polylineId: const PolylineId('shift_route'),
          points: List<LatLng>.from(routeLatLngs),
          color: routeColor,
          width: 4,
          geodesic: true,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          jointType: JointType.round,
        ),
      );
    }

    _markerIconCache['v2_bead'] ??= await _routeBead();
    _markerIconCache['v2_here'] ??= await _currentPositionMarker();
    if (_markerIconCache['v2_in'] == null || _markerIconCache['v2_out'] == null) {
      _markerIconCache['v2_in'] = await _circleMarker(
        Icons.login_rounded,
        const Color(0xFF16A34A),
      );
      _markerIconCache['v2_out'] = await _circleMarker(
        Icons.logout_rounded,
        const Color(0xFFDC2626),
      );
    }
    if (isClosed) return;

    final session = detail.session;
    final start = session?.checkInLocation;
    final end = session?.isActive == true ? null : session?.checkOutLocation;
    final startLatLng = start != null
        ? LatLng(start.lat, start.lng)
        : (routeLatLngs.isNotEmpty ? routeLatLngs.first : null);
    final endLatLng = end != null
        ? LatLng(end.lat, end.lng)
        : (session?.isActive == true
              ? null
              : (routeLatLngs.isNotEmpty ? routeLatLngs.last : null));
    final currentLatLng = session?.isActive == true && routeLatLngs.isNotEmpty
        ? routeLatLngs.last
        : null;

    final nextMarkers = <Marker>{};
    final beadIcon = _markerIconCache['v2_bead'];
    if (beadIcon != null) {
      final beads = _sampleRoute(routeLatLngs);
      for (var i = 0; i < beads.length; i++) {
        nextMarkers.add(
          Marker(
            markerId: MarkerId('route_bead_$i'),
            position: beads[i],
            anchor: const Offset(0.5, 0.5),
            zIndexInt: 1,
            icon: beadIcon,
            consumeTapEvents: true,
            onTap: () {},
          ),
        );
      }
    }

    final stays = detail.timeline.where((entry) => entry.kind == 'stay').toList()
      ..sort((a, b) {
        final aTime = a.start ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bTime = b.start ?? DateTime.fromMillisecondsSinceEpoch(0);
        return aTime.compareTo(bTime);
      });
    var autoStop = 0;
    for (final stay in stays) {
      autoStop++;
      final number = stay.stopNumber ?? autoStop;
      final position = _stayLatLng(stay);
      if (position == null) continue;
      if (currentLatLng != null && _calculateDistance(position, currentLatLng) < 25) {
        continue;
      }
      final key = 'v2_stop_$number';
      _markerIconCache[key] ??= await _stopNumberMarker(number);
      if (isClosed) return;
      nextMarkers.add(
        Marker(
          markerId: MarkerId('shift_stop_$number'),
          position: position,
          anchor: const Offset(0.5, 0.5),
          zIndexInt: 4,
          icon: _markerIconCache[key]!,
          infoWindow: InfoWindow(title: 'Stop $number'),
        ),
      );
    }

    if (startLatLng != null) {
      nextMarkers.add(
        Marker(
          markerId: const MarkerId('shift_check_in'),
          position: startLatLng,
          anchor: const Offset(0.5, 0.5),
          zIndexInt: 3,
          icon:
              _markerIconCache['v2_in'] ??
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: const InfoWindow(title: 'Checked in'),
        ),
      );
    }
    if (currentLatLng != null &&
        (startLatLng == null || _calculateDistance(startLatLng, currentLatLng) > 18)) {
      nextMarkers.add(
        Marker(
          markerId: const MarkerId('shift_current'),
          position: currentLatLng,
          anchor: const Offset(0.5, 0.5),
          zIndexInt: 6,
          icon:
              _markerIconCache['v2_here'] ??
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          infoWindow: const InfoWindow(title: 'Current position'),
        ),
      );
    } else if (endLatLng != null &&
        (startLatLng == null || _calculateDistance(startLatLng, endLatLng) > 12)) {
      nextMarkers.add(
        Marker(
          markerId: const MarkerId('shift_check_out'),
          position: endLatLng,
          anchor: const Offset(0.5, 0.5),
          zIndexInt: 5,
          icon:
              _markerIconCache['v2_out'] ??
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: const InfoWindow(title: 'Checked out'),
        ),
      );
    }

    newPolylines.value = polylines;
    markers.assignAll(nextMarkers);
    mapRevision.value++;
    fitRoute();
  }

  List<LatLng> _thinRoute(List<LatLng> points, {int max = 1500}) {
    if (points.length <= max) return points;
    final step = (points.length / max).ceil();
    final thinned = <LatLng>[];
    for (var i = 0; i < points.length; i += step) {
      thinned.add(points[i]);
    }
    if (thinned.isEmpty || thinned.last != points.last) {
      thinned.add(points.last);
    }
    return thinned;
  }

  void fitRoute() {
    final map = mapController;
    if (map == null) return;
    final boundsPoints = List<LatLng>.from(routeLatLngs);
    for (final marker in markers) {
      boundsPoints.add(marker.position);
    }
    if (boundsPoints.isEmpty) {
      final fallback = fallbackLatLng.value;
      if (fallback != null) {
        map.animateCamera(CameraUpdate.newLatLngZoom(fallback, 14));
      }
      return;
    }
    if (boundsPoints.length == 1) {
      map.animateCamera(CameraUpdate.newLatLngZoom(boundsPoints.first, 15));
      return;
    }
    var minLat = boundsPoints.first.latitude;
    var maxLat = boundsPoints.first.latitude;
    var minLng = boundsPoints.first.longitude;
    var maxLng = boundsPoints.first.longitude;
    for (final point in boundsPoints) {
      minLat = math.min(minLat, point.latitude);
      maxLat = math.max(maxLat, point.latitude);
      minLng = math.min(minLng, point.longitude);
      maxLng = math.max(maxLng, point.longitude);
    }
    if ((maxLat - minLat).abs() < 0.0004) {
      minLat -= 0.002;
      maxLat += 0.002;
    }
    if ((maxLng - minLng).abs() < 0.0004) {
      minLng -= 0.002;
      maxLng += 0.002;
    }
    map.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat, minLng),
          northeast: LatLng(maxLat, maxLng),
        ),
        72,
      ),
    );
  }

  List<LatLng> _sampleRoute(List<LatLng> points, {int max = 140}) {
    if (points.length < 2) return const <LatLng>[];
    var total = 0.0;
    for (var i = 1; i < points.length; i++) {
      total += _calculateDistance(points[i - 1], points[i]);
    }
    if (total < 8) return const <LatLng>[];
    final spacing = math.max(14.0, total / max);
    final sampled = <LatLng>[points.first];
    var carried = 0.0;
    for (var i = 1; i < points.length; i++) {
      carried += _calculateDistance(points[i - 1], points[i]);
      if (carried >= spacing) {
        sampled.add(points[i]);
        carried = 0;
      }
    }
    return sampled;
  }

  LatLng? _stayLatLng(TrackV2TimelineEntry stay) {
    final location = stay.location;
    if (location != null && !(location.lat == 0 && location.lng == 0)) {
      return LatLng(location.lat, location.lng);
    }
    if (stay.path.isEmpty) return null;
    final pair = stay.path[stay.path.length ~/ 2];
    if (pair[0] == 0 && pair[1] == 0) return null;
    return LatLng(pair[0], pair[1]);
  }

  Future<BitmapDescriptor> _routeBead() async {
    const size = 36.0;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const center = Offset(size / 2, size / 2);
    canvas.drawCircle(center, 11, Paint()..color = const Color(0xFFC5B4F3));
    canvas.drawCircle(center, 7.5, Paint()..color = Colors.white);
    final image = await recorder.endRecording().toImage(size.toInt(), size.toInt());
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.bytes(bytes!.buffer.asUint8List(), width: 22);
  }

  Future<BitmapDescriptor> _stopNumberMarker(int number) async {
    const size = 104.0;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const center = Offset(size / 2, size / 2);
    canvas.drawCircle(
      center,
      36,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.28)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );
    canvas.drawCircle(center, 30, Paint()..color = const Color(0xFFF6A623));
    final textPainter = TextPainter(textDirection: ui.TextDirection.ltr)
      ..text = TextSpan(
        text: '$number',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 34,
          fontWeight: FontWeight.w700,
        ),
      )
      ..layout();
    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2, center.dy - textPainter.height / 2),
    );
    final image = await recorder.endRecording().toImage(size.toInt(), size.toInt());
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.bytes(bytes!.buffer.asUint8List(), width: 40);
  }

  Future<BitmapDescriptor> _currentPositionMarker() async {
    const size = 148.0;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const center = Offset(size / 2, size / 2);
    const amber = Color(0xFFF5B429);
    canvas.drawCircle(
      center,
      52,
      Paint()..color = amber.withValues(alpha: 0.22),
    );
    canvas.drawCircle(center, 34, Paint()..color = Colors.white);
    canvas.drawCircle(center, 24, Paint()..color = amber);
    canvas.drawCircle(center, 8, Paint()..color = Colors.white);
    final image = await recorder.endRecording().toImage(size.toInt(), size.toInt());
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.bytes(bytes!.buffer.asUint8List(), width: 40);
  }

  Future<BitmapDescriptor> _circleMarker(IconData iconData, Color color) async {
    const size = 96;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const center = Offset(size / 2, size / 2);
    canvas.drawCircle(
      center,
      36,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.28)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
    canvas.drawCircle(center, 30, Paint()..color = color);
    canvas.drawCircle(
      center,
      30,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6,
    );
    final textPainter = TextPainter(textDirection: ui.TextDirection.ltr)
      ..text = TextSpan(
        text: String.fromCharCode(iconData.codePoint),
        style: TextStyle(
          fontSize: 32,
          fontFamily: iconData.fontFamily,
          package: iconData.fontPackage,
          color: Colors.white,
        ),
      )
      ..layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
    final image = await recorder.endRecording().toImage(size, size);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.bytes(bytes!.buffer.asUint8List(), width: 36);
  }

  Future<String> describeEntry(TrackV2TimelineEntry entry) {
    final key =
        '${entry.kind}|${entry.start?.toIso8601String()}|${entry.message}|${entry.activity}|${entry.stopNumber}|${entry.location?.lat}|${entry.location?.lng}';
    return _describeCache.putIfAbsent(key, () => _describeEntry(entry));
  }

  Future<String> _describeEntry(TrackV2TimelineEntry entry) async {
    final server = entry.message?.trim();
    if (server != null && server.isNotEmpty) return server;

    switch (entry.kind) {
      case 'checkIn':
        final place = await _placeName(entry.location?.lat, entry.location?.lng);
        return place.isEmpty
            ? 'Registered shift start'
            : 'Registered shift start at $place';
      case 'checkOut':
        final place = await _placeName(entry.location?.lat, entry.location?.lng);
        return place.isEmpty ? 'Checked out' : 'Checked out at $place';
      case 'stay':
        final place = await _placeName(entry.location?.lat, entry.location?.lng);
        return place.isEmpty ? 'Stopped' : 'Stopped at $place';
      case 'move':
        final title = activityTitle(entry.activity);
        if (title == 'Driving' && entry.path.length >= 2) {
          final from = await _placeName(entry.path.first[0], entry.path.first[1]);
          final to = await _placeName(entry.path.last[0], entry.path.last[1]);
          if (from.isNotEmpty && to.isNotEmpty && from != to) {
            return 'Drive started from $from to $to';
          }
          final place = from.isNotEmpty ? from : to;
          return place.isEmpty ? 'Driving' : 'Driving in $place';
        }
        final lat = entry.location?.lat ??
            (entry.path.isNotEmpty ? entry.path.first[0] : null);
        final lng = entry.location?.lng ??
            (entry.path.isNotEmpty ? entry.path.first[1] : null);
        final place = await _placeName(lat, lng);
        if (title == 'Walking') {
          return place.isEmpty ? 'Walking' : 'Walking in $place';
        }
        return place.isEmpty ? title : '$title near $place';
      default:
        return entry.detail?.trim() ?? '';
    }
  }

  Future<String> _placeName(double? lat, double? lng) async {
    if (lat == null || lng == null) return '';
    final key = '${lat.toStringAsFixed(3)},${lng.toStringAsFixed(3)}';
    final cached = _placeCache[key];
    if (cached != null) return cached;
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isEmpty) {
        _placeCache[key] = '';
        return '';
      }
      final place = placemarks.first;
      final parts = [
        place.subLocality,
        place.locality,
      ].whereType<String>().map((part) => part.trim()).where((part) => part.isNotEmpty);
      final name = parts.join(', ');
      _placeCache[key] = name;
      return name;
    } catch (_) {
      _placeCache[key] = '';
      return '';
    }
  }
}
