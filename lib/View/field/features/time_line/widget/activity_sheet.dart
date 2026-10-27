import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/field/features/time_line/controller/timeline_controller.dart';
import 'package:loyaltri_minimal/View/field/features/time_line/model/track_v2.dart';
import 'package:loyaltri_minimal/View/field/features/time_line/timeline_format.dart';

class ActivitySheet extends StatelessWidget {
  const ActivitySheet({super.key, required this.controller});

  final TimelineController controller;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final topGap = MediaQuery.paddingOf(context).top + 78.h;
    final maxSize = ((screenHeight - topGap) / screenHeight).clamp(0.55, 0.92);

    return DraggableScrollableSheet(
      initialChildSize: 0.46,
      minChildSize: 0.22,
      maxChildSize: maxSize,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0C0F14),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x66000000),
                blurRadius: 24,
                offset: Offset(0, -6),
              ),
            ],
          ),
          child: RefreshIndicator(
            color: Colors.white,
            backgroundColor: const Color(0xFF1F2937),
            onRefresh: controller.refreshShifts,
            child: Obx(() {
              final detail = controller.sessionDetail.value;
              final shift = controller.selectedShift ?? detail?.session;
              final rows = detail == null ? <TimelineRow>[] : rowsForSession(detail);
              final loading = controller.isloading.value;
              final error = controller.timelineError.value;

              return ListView(
                controller: scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(18.w, 10.h, 18.w, 28.h),
                children: [
                  Center(
                    child: Container(
                      width: 42.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.22),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  if (shift == null && loading)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 48.h),
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    )
                  else if (shift == null)
                    _empty(error)
                  else ...[
                    _header(shift),
                    if (error.isNotEmpty) ...[
                      SizedBox(height: 8.h),
                      Text(
                        error,
                        style: GoogleFonts.inter(
                          color: const Color(0xFFFCA5A5),
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                    SizedBox(height: 14.h),
                    _stats(shift, detail, rows),
                    SizedBox(height: 18.h),
                    Text(
                      _updatedLabel(detail, shift),
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    if (rows.isEmpty)
                      Text(
                        'No timeline for this shift yet',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF9AA0AE),
                          fontSize: 13.sp,
                        ),
                      )
                    else
                      for (var i = 0, stayCount = 0; i < rows.length; i++)
                        _TimelineTile(
                          controller: controller,
                          row: rows[i],
                          isLast: i == rows.length - 1,
                          stopNumber: rows[i].entry.kind == 'stay'
                              ? (rows[i].entry.stopNumber ?? ++stayCount)
                              : null,
                        ),
                  ],
                ],
              );
            }),
          ),
        );
      },
    );
  }

  Widget _empty(String error) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 36.h),
      child: Column(
        children: [
          Icon(Icons.route_outlined, color: const Color(0xFF9AA0AE), size: 36.sp),
          SizedBox(height: 10.h),
          Text(
            error.isEmpty ? 'No shifts yet' : error,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Your route shows up here after check-in.',
            style: GoogleFonts.inter(
              color: const Color(0xFF9AA0AE),
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(TrackV2Session shift) {
    final start = shift.checkInAt?.toLocal();
    final title = start == null ? 'Shift' : relativeDay(start);
    final live = shift.isActive;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                shiftRangeLabel(shift),
                style: GoogleFonts.inter(
                  color: const Color(0xFF9AA0AE),
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: live ? const Color(0xFF14532D) : const Color(0xFF1F2937),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            live ? 'In Progress' : 'Completed',
            style: GoogleFonts.inter(
              color: live ? const Color(0xFF4ADE80) : const Color(0xFFE5E7EB),
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _stats(
    TrackV2Session shift,
    TrackV2SessionDetail? detail,
    List<TimelineRow> rows,
  ) {
    final stops = rows.where((row) => row.entry.kind == 'stay').length;
    final points = detail?.points.length ?? 0;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: const Color(0xFF171A21),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        children: [
          _stat(
            Icons.bolt_rounded,
            const Color(0xFFC084FC),
            'Duration',
            formatDuration(shiftDuration(shift)),
          ),
          _stat(
            Icons.route_rounded,
            const Color(0xFF4ADE80),
            'Distance',
            formatDistance(shift.distance),
          ),
          _stat(
            Icons.location_on_rounded,
            const Color(0xFFFBBF24),
            'Stops',
            '$stops',
          ),
          _stat(
            Icons.grain_rounded,
            const Color(0xFFF472B6),
            'Points',
            '$points',
          ),
        ],
      ),
    );
  }

  Widget _stat(IconData icon, Color color, String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 18.sp),
          SizedBox(height: 6.h),
          Text(
            label,
            style: GoogleFonts.inter(
              color: const Color(0xFF9AA0AE),
              fontSize: 11.sp,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            value,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  String _updatedLabel(TrackV2SessionDetail? detail, TrackV2Session shift) {
    DateTime? stamp;
    final points = detail?.points ?? const <TrackV2Point>[];
    for (final point in points) {
      final at = point.recordedAt;
      if (at != null && (stamp == null || at.isAfter(stamp))) stamp = at;
    }
    stamp ??= shift.checkOutAt ?? shift.lastPointAt ?? shift.checkInAt;
    if (stamp == null) return '';
    final local = stamp.toLocal();
    return '${relativeDay(local)}, ${formatClock(local)}';
  }
}

class _TimelineTile extends StatelessWidget {
  const _TimelineTile({
    required this.controller,
    required this.row,
    required this.isLast,
    this.stopNumber,
  });

  final TimelineController controller;
  final TimelineRow row;
  final bool isLast;
  final int? stopNumber;

  @override
  Widget build(BuildContext context) {
    final entry = row.entry;
    final visual = _visual(entry);
    final showMeta = entry.kind == 'move' || entry.kind == 'stay';
    final distance = entry.distance;
    final sdk = sdkLine(entry.sdkActivityCounts);
    final coords = entry.kind == 'checkIn' || entry.kind == 'checkOut'
        ? coordinatesLabel(entry.location)
        : '';

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 72.w,
            child: Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Text(
                formatClock(entry.start),
                style: GoogleFonts.inter(
                  color: const Color(0xFFB7BDC8),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 34.w,
            child: Column(
              children: [
                Container(
                  width: 28.w,
                  height: 28.w,
                  decoration: BoxDecoration(
                    color: visual.color,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(visual.icon, color: Colors.white, size: 16.sp),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(width: 2, color: const Color(0xFF2C313C)),
                  ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: 18.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          visual.title,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      if (showMeta)
                        Flexible(
                          child: Text(
                            entryRangeLabel(entry),
                            textAlign: TextAlign.right,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF9AA0AE),
                              fontSize: 11.sp,
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (distance != null && distance > 0 && entry.kind == 'move') ...[
                    SizedBox(height: 4.h),
                    Text(
                      formatDistance(distance),
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  if (coords.isNotEmpty) ...[
                    SizedBox(height: 4.h),
                    Text(
                      coords,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF9AA0AE),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                  SizedBox(height: 4.h),
                  FutureBuilder<String>(
                    future: controller.describeEntry(entry),
                    builder: (context, snapshot) {
                      final text = snapshot.data ?? '';
                      if (text.isEmpty) return const SizedBox.shrink();
                      return Text(
                        text,
                        style: GoogleFonts.inter(
                          color: const Color(0xFFC5CAD3),
                          fontSize: 13.sp,
                          height: 1.35,
                        ),
                      );
                    },
                  ),
                  if (_showDetail(entry)) ...[
                    SizedBox(height: 2.h),
                    Text(
                      entry.detail!.trim(),
                      style: GoogleFonts.inter(
                        color: const Color(0xFF9AA0AE),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                  if (sdk != null) ...[
                    SizedBox(height: 4.h),
                    Text(
                      sdk,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF9AA0AE),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                  for (final alert in row.alerts) ...[
                    SizedBox(height: 8.h),
                    _alertChip(alert),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _showDetail(TrackV2TimelineEntry entry) {
    final detail = entry.detail?.trim() ?? '';
    if (detail.isEmpty) return false;
    final message = entry.message?.trim() ?? '';
    return detail != message;
  }

  Widget _alertChip(TrackV2TimelineEntry alert) {
    final positive = alert.positive == true;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: positive ? const Color(0xFF166534) : const Color(0xFFB91C1C),
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Row(
        children: [
          Icon(alertIcon(alert), color: Colors.white, size: 16.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              '${formatClock(alert.start)} ${alertLabel(alert)}',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _EntryVisual _visual(TrackV2TimelineEntry entry) {
    switch (entry.kind) {
      case 'checkIn':
        return const _EntryVisual(
          'Checked In',
          Icons.login_rounded,
          Color(0xFF16A34A),
        );
      case 'checkOut':
        return const _EntryVisual(
          'Checked Out',
          Icons.logout_rounded,
          Color(0xFFDC2626),
        );
      case 'stay':
        return _EntryVisual(
          'Stop ${stopNumber ?? entry.stopNumber ?? 1}',
          Icons.location_on_rounded,
          const Color(0xFFF59E0B),
        );
      case 'alert':
        return _EntryVisual(
          alertLabel(entry),
          alertIcon(entry),
          entry.positive == true
              ? const Color(0xFF16A34A)
              : const Color(0xFFDC2626),
        );
      case 'move':
        final title = activityTitle(entry.activity);
        return _EntryVisual(title, activityIcon(title), activityColor(title));
      default:
        final title = entry.kind.isEmpty ? 'Update' : entry.kind;
        return _EntryVisual(
          title,
          Icons.info_outline_rounded,
          const Color(0xFF64748B),
        );
    }
  }
}

class _EntryVisual {
  const _EntryVisual(this.title, this.icon, this.color);

  final String title;
  final IconData icon;
  final Color color;
}
