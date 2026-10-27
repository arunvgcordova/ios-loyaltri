import 'package:flutter/material.dart';

class AttendanceDailyActivity {
  final String title;
  final Color color;
  final String date;
  final String? checkInTime;
  final String? checkOutTime;
  const AttendanceDailyActivity(
      {required this.date,
      required this.color,
      required this.checkInTime,
      required this.checkOutTime,
      required this.title});
}
