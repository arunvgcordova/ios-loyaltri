class TrackV2LatLng {
  final double lat;
  final double lng;

  const TrackV2LatLng({required this.lat, required this.lng});
}

class TrackV2Session {
  final String? id;
  final int? employeeId;
  final String? status;
  final DateTime? checkInAt;
  final DateTime? checkOutAt;
  final TrackV2LatLng? checkInLocation;
  final TrackV2LatLng? checkOutLocation;
  final double distance;
  final DateTime? lastPointAt;

  const TrackV2Session({
    this.id,
    this.employeeId,
    this.status,
    this.checkInAt,
    this.checkOutAt,
    this.checkInLocation,
    this.checkOutLocation,
    this.distance = 0,
    this.lastPointAt,
  });

  bool get isActive {
    final state = status?.toLowerCase().trim() ?? '';
    if (state == 'closed' ||
        state == 'completed' ||
        state == 'inactive' ||
        state == 'checked_out' ||
        state == 'ended') {
      return false;
    }
    if (checkOutAt != null) return false;
    return state == 'active' ||
        state == 'open' ||
        state == 'live' ||
        state == 'ongoing' ||
        state == 'in_progress' ||
        state.isEmpty;
  }

  factory TrackV2Session.fromJson(Map<String, dynamic> json) {
    return TrackV2Session(
      id: json['id']?.toString() ??
          json['session_id']?.toString() ??
          json['sessionId']?.toString(),
      employeeId: _asInt(json['employee_id']),
      status: json['status']?.toString() ?? json['session_status']?.toString(),
      checkInAt: _asDate(json['check_in_at'] ?? json['checkInAt']),
      checkOutAt: _asDate(json['check_out_at'] ?? json['checkOutAt']),
      checkInLocation: _asLatLng(json['check_in_location']),
      checkOutLocation: _asLatLng(json['check_out_location']),
      distance: _asDouble(json['distance']) ?? 0,
      lastPointAt: _asDate(json['last_point_at']),
    );
  }
}

class TrackV2Point {
  final double lat;
  final double lng;
  final DateTime? recordedAt;

  const TrackV2Point({required this.lat, required this.lng, this.recordedAt});

  factory TrackV2Point.fromJson(Map<String, dynamic> json) {
    return TrackV2Point(
      lat: _asDouble(json['lat']) ?? 0,
      lng: _asDouble(json['lng']) ?? 0,
      recordedAt: _asDate(json['recorded_at']),
    );
  }
}

class TrackV2Event {
  final String? id;
  final String? type;
  final DateTime? at;
  final double? lat;
  final double? lng;
  final Map<String, dynamic> data;

  const TrackV2Event({
    this.id,
    this.type,
    this.at,
    this.lat,
    this.lng,
    this.data = const {},
  });

  factory TrackV2Event.fromJson(Map<String, dynamic> json) {
    final raw = json['data'];
    return TrackV2Event(
      id: json['id']?.toString(),
      type: json['type']?.toString(),
      at: _asDate(json['at']),
      lat: _asDouble(json['lat']),
      lng: _asDouble(json['lng']),
      data: raw is Map ? Map<String, dynamic>.from(raw) : const {},
    );
  }
}

class TrackV2TimelineEntry {
  final String kind;
  final DateTime? start;
  final DateTime? end;
  final TrackV2LatLng? location;
  final List<List<double>> path;
  final double? distance;
  final String? activity;
  final String? sdkActivity;
  final Map<String, int>? sdkActivityCounts;
  final String? message;
  final String? detail;
  final String? signal;
  final bool? positive;
  final bool ongoing;
  final int? stopNumber;

  const TrackV2TimelineEntry({
    required this.kind,
    this.start,
    this.end,
    this.location,
    this.path = const [],
    this.distance,
    this.activity,
    this.sdkActivity,
    this.sdkActivityCounts,
    this.message,
    this.detail,
    this.signal,
    this.positive,
    this.ongoing = false,
    this.stopNumber,
  });

  factory TrackV2TimelineEntry.fromJson(Map<String, dynamic> json) {
    final path = <List<double>>[];
    final rawPath = json['path'];
    if (rawPath is List) {
      for (final pair in rawPath) {
        if (pair is List && pair.length >= 2) {
          final lat = _asDouble(pair[0]);
          final lng = _asDouble(pair[1]);
          if (lat != null && lng != null) path.add([lat, lng]);
        }
      }
    }

    Map<String, int>? counts;
    final rawCounts = json['sdk_activity_counts'];
    if (rawCounts is Map) {
      counts = {};
      rawCounts.forEach((key, value) {
        final n = _asInt(value);
        if (n != null) counts![key.toString()] = n;
      });
    }

    return TrackV2TimelineEntry(
      kind: json['kind']?.toString() ?? '',
      start: _asDate(json['start']),
      end: _asDate(json['end']),
      location: _asLatLng(json['location']),
      path: path,
      distance: _asDouble(json['distance']),
      activity: json['activity']?.toString(),
      sdkActivity: json['sdk_activity']?.toString(),
      sdkActivityCounts: counts,
      message: json['message']?.toString(),
      detail: json['detail']?.toString(),
      signal: json['signal']?.toString(),
      positive: _asBool(json['positive']),
      ongoing: _asBool(json['ongoing']) ?? false,
      stopNumber: _asInt(json['stop_number']),
    );
  }
}

class TrackV2SessionDetail {
  final TrackV2Session? session;
  final List<TrackV2Point> points;
  final List<TrackV2TimelineEntry> timeline;
  final List<TrackV2Event> events;

  const TrackV2SessionDetail({
    this.session,
    this.points = const [],
    this.timeline = const [],
    this.events = const [],
  });

  factory TrackV2SessionDetail.fromJson(Map<String, dynamic> json) {
    return TrackV2SessionDetail(
      session: json['session'] is Map
          ? TrackV2Session.fromJson(
              Map<String, dynamic>.from(json['session'] as Map),
            )
          : null,
      points: _mapList(json['points'], TrackV2Point.fromJson),
      timeline: _mapList(json['timeline'], TrackV2TimelineEntry.fromJson),
      events: _mapList(json['events'], TrackV2Event.fromJson),
    );
  }
}

class TimelineRow {
  final TrackV2TimelineEntry entry;
  final List<TrackV2TimelineEntry> alerts;

  TimelineRow(this.entry) : alerts = [];
}

List<TimelineRow> rowsForSession(TrackV2SessionDetail detail) {
  final entries = List<TrackV2TimelineEntry>.from(detail.timeline);
  if (entries.isEmpty && detail.session != null) {
    final session = detail.session!;
    if (session.checkInAt != null) {
      entries.add(
        TrackV2TimelineEntry(
          kind: 'checkIn',
          start: session.checkInAt,
          location: session.checkInLocation,
        ),
      );
    }
    if (session.checkOutAt != null) {
      entries.add(
        TrackV2TimelineEntry(
          kind: 'checkOut',
          start: session.checkOutAt,
          location: session.checkOutLocation,
        ),
      );
    }
  }

  final synthesized = _alertsFromEvents(detail.events);
  for (final alert in synthesized) {
    final duplicate = entries.any((entry) {
      if (entry.kind != 'alert') return false;
      if (normalizeSignal(entry.signal) != normalizeSignal(alert.signal)) {
        return false;
      }
      final existingAt = entry.start;
      final incomingAt = alert.start;
      if (existingAt == null || incomingAt == null) return false;
      return existingAt.difference(incomingAt).inSeconds.abs() < 90;
    });
    if (!duplicate) entries.add(alert);
  }

  final alerts = entries.where((entry) => entry.kind == 'alert').toList();
  final main = entries.where((entry) => entry.kind != 'alert').toList()
    ..sort(_byStart);
  final rows = main.map(TimelineRow.new).toList();

  for (final alert in alerts) {
    TimelineRow? host;
    Duration? tightest;
    final at = alert.start;
    if (at != null) {
      for (final row in rows) {
        if (row.entry.kind != 'move' && row.entry.kind != 'stay') continue;
        final start = row.entry.start;
        if (start == null) continue;
        final end = row.entry.end ?? DateTime.now().toUtc();
        final startsOk = !at.isBefore(start);
        final endsOk = !at.isAfter(end.add(const Duration(seconds: 5)));
        if (!startsOk || !endsOk) continue;
        final span = end.difference(start);
        if (tightest == null || span < tightest) {
          tightest = span;
          host = row;
        }
      }
    }
    if (host != null) {
      host.alerts.add(alert);
    } else {
      rows.add(TimelineRow(alert));
    }
  }

  for (final row in rows) {
    row.alerts.sort(_byStart);
  }
  rows.sort((a, b) => _byStart(a.entry, b.entry));
  return rows;
}

List<TrackV2TimelineEntry> _alertsFromEvents(List<TrackV2Event> events) {
  final alerts = <TrackV2TimelineEntry>[];
  for (final event in events) {
    if (event.type != 'deviceChange') continue;
    final changes = event.data['changes'];
    if (changes is! List) continue;
    for (final change in changes) {
      if (change is! Map) continue;
      final signal = normalizeSignal(change['signal']?.toString());
      if (signal.isEmpty) continue;
      alerts.add(
        TrackV2TimelineEntry(
          kind: 'alert',
          start: event.at,
          signal: signal,
          positive: positiveDeviceChange(signal, change['to']),
          location: event.lat != null && event.lng != null
              ? TrackV2LatLng(lat: event.lat!, lng: event.lng!)
              : null,
        ),
      );
    }
  }
  return alerts;
}

String normalizeSignal(String? raw) {
  switch (raw) {
    case 'power_save_mode':
    case 'powerSave':
      return 'powerSaveMode';
    case 'airplane_mode':
    case 'flightMode':
      return 'airplaneMode';
    case 'app_terminated':
    case 'appClosed':
      return 'appTerminated';
    case 'location_services':
      return 'locationServices';
    case 'location_permission':
      return 'locationPermission';
    case 'precise_location':
      return 'preciseLocation';
    case 'motion_permission':
      return 'motionPermission';
    case 'mock_location':
      return 'mockLocation';
    case 'device_rebooted':
      return 'deviceRebooted';
    case 'signal_gap':
      return 'signalGap';
    default:
      return raw ?? '';
  }
}

bool positiveDeviceChange(String signal, dynamic to) {
  final text = to?.toString().toLowerCase() ?? '';
  final enabled =
      to == true ||
      text == 'true' ||
      text == '1' ||
      text == 'on' ||
      text == 'granted' ||
      text == 'always' ||
      text == 'wheninuse';
  switch (signal) {
    case 'network':
    case 'locationServices':
    case 'preciseLocation':
      return enabled;
    case 'locationPermission':
    case 'motionPermission':
      return text == 'always' ||
          text == 'granted' ||
          text == 'wheninuse' ||
          text == 'whenInUse';
    case 'powerSaveMode':
    case 'airplaneMode':
    case 'appTerminated':
    case 'mockLocation':
    case 'deviceRebooted':
      return !enabled && text.isNotEmpty;
    default:
      return false;
  }
}

int _byStart(TrackV2TimelineEntry a, TrackV2TimelineEntry b) {
  final aTime = a.start ?? DateTime.fromMillisecondsSinceEpoch(0);
  final bTime = b.start ?? DateTime.fromMillisecondsSinceEpoch(0);
  return aTime.compareTo(bTime);
}

List<T> _mapList<T>(
  dynamic raw,
  T Function(Map<String, dynamic> json) parse,
) {
  if (raw is! List) return [];
  final items = <T>[];
  for (final entry in raw) {
    if (entry is Map) {
      items.add(parse(Map<String, dynamic>.from(entry)));
    }
  }
  return items;
}

DateTime? _asDate(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}

int? _asInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}

double? _asDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

bool? _asBool(dynamic value) {
  if (value == null) return null;
  if (value is bool) return value;
  if (value is num) return value != 0;
  final text = value.toString().toLowerCase();
  if (text == 'true' || text == '1') return true;
  if (text == 'false' || text == '0') return false;
  return null;
}

List<dynamic> trackV2SessionItems(dynamic data) {
  if (data is List) return data;
  if (data is Map) {
    for (final key in ['sessions', 'items', 'records', 'rows', 'data']) {
      final value = data[key];
      if (value is List) return value;
    }
    if (data['id'] != null || data['session_id'] != null) return [data];
  }
  return const [];
}

TrackV2LatLng? _asLatLng(dynamic value) {
  if (value is! Map) return null;
  final lat = _asDouble(value['lat']);
  final lng = _asDouble(value['lng']);
  if (lat == null || lng == null) return null;
  return TrackV2LatLng(lat: lat, lng: lng);
}
