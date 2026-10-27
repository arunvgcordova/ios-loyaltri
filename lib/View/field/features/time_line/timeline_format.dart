import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/field/features/time_line/model/track_v2.dart';

String activityTitle(String? activity) {
  switch ((activity ?? '').toLowerCase()) {
    case 'walking':
    case 'on_foot':
      return 'Walking';
    case 'running':
      return 'Running';
    case 'on_bicycle':
    case 'cycling':
      return 'Cycling';
    case 'in_vehicle':
    case 'driving':
      return 'Driving';
    case 'still':
      return 'Still';
    default:
      final raw = (activity ?? '').replaceAll('_', ' ').trim();
      if (raw.isEmpty) return 'Moving';
      return raw[0].toUpperCase() + raw.substring(1);
  }
}

String formatClock(DateTime? dateTime) {
  if (dateTime == null) return '--';
  return DateFormat('h:mm a').format(dateTime.toLocal());
}

String formatCompactClock(DateTime? dateTime) {
  if (dateTime == null) return '--';
  return DateFormat('h:mm a').format(dateTime.toLocal()).replaceAll(' ', '');
}

String formatDuration(Duration duration) {
  var safe = duration;
  if (safe.isNegative) safe = Duration.zero;
  final hours = safe.inHours;
  final minutes = safe.inMinutes.remainder(60);
  if (hours > 0 && minutes > 0) return '${hours}h ${minutes}m';
  if (hours > 0) return '${hours}h';
  return '${minutes}m';
}

String formatDistance(num? meters) {
  final value = (meters ?? 0).toDouble();
  if (value < 1000) return '${value.round()} m';
  final km = value / 1000;
  final digits = km >= 100 ? 0 : 1;
  return '${km.toStringAsFixed(digits)} Km';
}

String relativeDay(DateTime dateTime) {
  final local = dateTime.toLocal();
  final day = DateTime(local.year, local.month, local.day);
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  if (day == today) return 'Today';
  if (day == today.subtract(const Duration(days: 1))) return 'Yesterday';
  return DateFormat('d MMM').format(local);
}

String historyDayLabel(DateTime day) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final date = DateTime(day.year, day.month, day.day);
  if (date == today) return 'Today';
  if (date == today.subtract(const Duration(days: 1))) return 'Yesterday';
  return DateFormat('d MMMM yy, EEEE').format(day);
}

bool isSameDay(DateTime? dateTime, DateTime day) {
  if (dateTime == null) return false;
  final local = dateTime.toLocal();
  return local.year == day.year && local.month == day.month && local.day == day.day;
}

String shiftPillLabel(TrackV2Session shift) {
  final start = shift.checkInAt;
  final day = start == null ? 'Shift' : relativeDay(start);
  final from = formatCompactClock(start);
  final to = shift.isActive ? 'Now (Live)' : formatCompactClock(shift.checkOutAt);
  return '$day, $from - $to';
}

String shiftRangeLabel(TrackV2Session shift) {
  final from = formatClock(shift.checkInAt);
  final to = shift.isActive ? 'Now' : formatClock(shift.checkOutAt);
  return '$from - $to';
}

Duration shiftDuration(TrackV2Session shift) {
  final start = shift.checkInAt;
  if (start == null) return Duration.zero;
  final end = shift.isActive ? DateTime.now() : (shift.checkOutAt ?? DateTime.now());
  return end.difference(start);
}

String entryRangeLabel(TrackV2TimelineEntry entry) {
  final start = entry.start;
  if (start == null) return '';
  final end = entry.ongoing || entry.end == null ? null : entry.end;
  final duration = formatDuration((end ?? DateTime.now()).difference(start));
  final from = formatClock(start);
  final to = end == null ? 'Now' : formatClock(end);
  return '$duration • $from–$to';
}

String coordinatesLabel(TrackV2LatLng? location) {
  if (location == null) return '';
  return '${location.lat.toStringAsFixed(5)}, ${location.lng.toStringAsFixed(5)}';
}

String? sdkLine(Map<String, int>? counts) {
  if (counts == null || counts.isEmpty) return null;
  final parts = counts.entries.map((entry) {
    final raw = entry.key.replaceAll('_', ' ').trim();
    if (raw.isEmpty) return 'x${entry.value}';
    final label = raw[0].toUpperCase() + raw.substring(1);
    return '$label x${entry.value}';
  }).join(' • ');
  return 'SDK: $parts';
}

String alertLabel(TrackV2TimelineEntry entry) {
  final message = entry.message?.trim();
  if (message != null && message.isNotEmpty) return message;
  final problem = entry.positive != true;
  switch (normalizeSignal(entry.signal)) {
    case 'network':
      return problem ? 'Network disconnected' : 'Network connected';
    case 'powerSaveMode':
      return problem ? 'Battery saver turned on' : 'Battery saver turned off';
    case 'airplaneMode':
      return problem ? 'Flight Mode On' : 'Flight Mode Off';
    case 'appTerminated':
      return problem ? 'App closed by user' : 'App reopened';
    case 'locationServices':
      return problem ? 'Location services turned off' : 'Location services turned on';
    case 'locationPermission':
      return problem ? 'Location Permission Denied' : 'Location Permission Granted';
    case 'preciseLocation':
      return problem ? 'Precise Location Off' : 'Precise Location On';
    case 'motionPermission':
      return problem ? 'Motion Permission Denied' : 'Motion Permission Granted';
    case 'deviceRebooted':
      return 'Device Rebooted';
    case 'mockLocation':
      return 'Mock Location Detected';
    case 'signalGap':
      return 'Signal Gap';
    default:
      final signal = entry.signal?.trim() ?? '';
      return signal.isEmpty ? 'Device alert' : signal;
  }
}

IconData alertIcon(TrackV2TimelineEntry entry) {
  final positive = entry.positive == true;
  switch (normalizeSignal(entry.signal)) {
    case 'network':
      return positive ? Icons.wifi_rounded : Icons.wifi_off_rounded;
    case 'powerSaveMode':
      return positive ? Icons.battery_full_rounded : Icons.battery_saver_rounded;
    case 'airplaneMode':
      return Icons.airplanemode_active_rounded;
    case 'appTerminated':
      return positive ? Icons.check_box_rounded : Icons.disabled_by_default_rounded;
    case 'locationServices':
      return positive ? Icons.location_on_rounded : Icons.location_off_rounded;
    case 'preciseLocation':
    case 'locationPermission':
      return positive ? Icons.location_on_rounded : Icons.location_off_rounded;
    case 'mockLocation':
      return Icons.gps_off_rounded;
    case 'signalGap':
      return Icons.signal_cellular_connected_no_internet_4_bar_rounded;
    case 'deviceRebooted':
      return Icons.restart_alt_rounded;
    default:
      return positive ? Icons.check_circle_rounded : Icons.bolt_rounded;
  }
}

IconData activityIcon(String title) {
  switch (title) {
    case 'Walking':
      return Icons.directions_walk_rounded;
    case 'Running':
      return Icons.directions_run_rounded;
    case 'Cycling':
      return Icons.directions_bike_rounded;
    case 'Driving':
      return Icons.directions_car_rounded;
    case 'Still':
      return Icons.accessibility_new_rounded;
    default:
      return Icons.route_rounded;
  }
}

Color activityColor(String title) {
  switch (title) {
    case 'Walking':
    case 'Running':
      return const Color(0xFFA855F7);
    case 'Cycling':
    case 'Driving':
      return const Color(0xFF3B82F6);
    case 'Still':
      return const Color(0xFF94A3B8);
    default:
      return const Color(0xFF38BDF8);
  }
}
