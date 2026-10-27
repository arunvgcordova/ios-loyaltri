import 'package:intl/intl.dart';

class DateHelper {
  /// Formats an ISO 8601 string to local time, e.g., "10:00 AM"
  static String formatTime(String? isoString) {
    if (isoString == null || isoString.isEmpty) return '--:--';
    try {
      final dateTime = DateTime.parse(isoString).toLocal();
      return DateFormat('hh:mm a').format(dateTime);
    } catch (_) {
      return '--:--';
    }
  }

  /// Formats an ISO 8601 string to a readable date, e.g., "May 26, 2026"
  static String formatDate(String? isoString) {
    if (isoString == null || isoString.isEmpty) return '';
    try {
      final dateTime = DateTime.parse(isoString).toLocal();
      return DateFormat('MMM dd, yyyy').format(dateTime);
    } catch (_) {
      return '';
    }
  }

  /// Formats duration in seconds to a premium human-readable format,
  /// e.g. "2 min 10 sec", "1 hr 20 min", or "45 sec".
  static String formatDuration(int? totalSeconds) {
    if (totalSeconds == null || totalSeconds < 0) return '0 sec';
    
    final duration = Duration(seconds: totalSeconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    final List<String> parts = [];
    if (hours > 0) {
      parts.add('$hours hr');
    }
    if (minutes > 0) {
      parts.add('$minutes min');
    }
    if (seconds > 0 || parts.isEmpty) {
      parts.add('$seconds sec');
    }

    // Standard requirement: "2 min 10 sec" or "1 hr 20 min" (take up to 2 parts)
    return parts.take(2).join(' ');
  }
}
