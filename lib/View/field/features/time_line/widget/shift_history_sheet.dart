import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/field/features/time_line/controller/timeline_controller.dart';
import 'package:loyaltri_minimal/View/field/features/time_line/model/track_v2.dart';
import 'package:loyaltri_minimal/View/field/features/time_line/timeline_format.dart';

Future<void> showShiftHistory(
  BuildContext context,
  TimelineController controller, {
  DateTime? onlyDay,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return _ShiftHistorySheet(controller: controller, onlyDay: onlyDay);
    },
  );
}

class _ShiftHistorySheet extends StatelessWidget {
  const _ShiftHistorySheet({required this.controller, this.onlyDay});

  final TimelineController controller;
  final DateTime? onlyDay;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 0.78;
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF101218),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      child: Column(
        children: [
          SizedBox(height: 10.h),
          Container(
            width: 42.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 16.h, 12.w, 8.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _title,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close_rounded, color: Colors.white, size: 26.sp),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              final groups = _groups();
              if (controller.isloading.value && controller.shifts.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }
              if (groups.isEmpty) {
                return Center(
                  child: Text(
                    'No shifts yet',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF9AA0AE),
                      fontSize: 14.sp,
                    ),
                  ),
                );
              }
              return ListView(
                padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 24.h),
                children: [
                  for (final group in groups) ...[
                    Padding(
                      padding: EdgeInsets.only(top: 12.h, bottom: 10.h),
                      child: Text(
                        historyDayLabel(group.key),
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    for (final shift in group.value)
                      _ShiftCard(
                        shift: shift,
                        selected: controller.selectedSessionId.value == shift.id,
                        onTap: () {
                          final id = shift.id;
                          if (id == null || id.isEmpty) return;
                          Navigator.pop(context);
                          controller.selectShift(id);
                        },
                      ),
                  ],
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  String get _title {
    if (onlyDay == null) return 'Shift History';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (onlyDay == today) return "Today's shifts";
    return DateFormat('d MMMM').format(onlyDay!);
  }

  List<MapEntry<DateTime, List<TrackV2Session>>> _groups() {
    final grouped = <DateTime, List<TrackV2Session>>{};
    for (final shift in controller.shifts) {
      final start = shift.checkInAt?.toLocal();
      if (start == null) continue;
      final day = DateTime(start.year, start.month, start.day);
      if (onlyDay != null && day != onlyDay) continue;
      grouped.putIfAbsent(day, () => []).add(shift);
    }
    final days = grouped.keys.toList()..sort((a, b) => b.compareTo(a));
    return [for (final day in days) MapEntry(day, grouped[day]!)];
  }
}

class _ShiftCard extends StatelessWidget {
  const _ShiftCard({
    required this.shift,
    required this.selected,
    required this.onTap,
  });

  final TrackV2Session shift;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Material(
        color: const Color(0xFF1A1D25),
        borderRadius: BorderRadius.circular(16.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: selected
                    ? const Color(0xFF3B82F6)
                    : Colors.white.withValues(alpha: 0.04),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2E38),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.alt_route_rounded,
                    color: Colors.white,
                    size: 18.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shiftRangeLabel(shift),
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '${formatDuration(shiftDuration(shift))} • ${formatDistance(shift.distance)}',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF9AA0AE),
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                if (shift.isActive)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF14532D),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      'Live',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF4ADE80),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
