import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/View/field/features/home/model/home_response.dart';
import 'package:loyaltri_minimal/View/field/features/home/widget/work_overview.dart';
import 'package:loyaltri_minimal/View/field/features/time_line/model/timeLine_response.dart';
import 'package:loyaltri_minimal/View/field/features/work_details/model/inprogress_work_response.dart';
import 'package:loyaltri_minimal/controller/userAuthentication.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';
import 'package:loyaltri_minimal/services/api_services.dart';
import 'package:sim_card_code/sim_card_code.dart';

class FieldHomeController extends GetxController {
  RxBool isloading = false.obs;

  Rx<HomeResponse?> homeData = Rx(null);
  Rx<FilterType> frequency =
      FilterType.today.obs; // today, this_week, this_month, custom //
  String startDate = "";
  String endDate = "";

  final runningTime = "00:00:00".obs;
  Timer? _timer;

  Rx<Set<Polyline>> newPolylines = Rx({});

  Rx<TimelineResponse?> timelineData = Rx(null);

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  String getKey(FilterType value) {
    switch (value) {
      case FilterType.today:
        return 'today';
      case FilterType.thisWeek:
        return 'this_week';
      case FilterType.thisMonth:
        return 'this_month';
      case FilterType.custom:
        return 'custom';
    }
  }

  Future<void> fetchHomeDetail() async {
    isloading.value = true;

    try {
      final authController = Get.find<UserAuthController>();

      final String empId =
          authController.userData.value.userData?.employeeId ?? '';

      final resp = await ApiServices.fetchHomeDetail(
        employeeId: empId,
        frequency: getKey(frequency.value),
        startDate: startDate,
        endDate: endDate,
      );

      if (resp['status']?.toString() == '200') {
        homeData.value = HomeResponse.fromJson(resp);
        if (homeData.value?.data?.highlights?.hasNoWork != true) {
          startTimer(
            actualStartTime: homeData
                .value
                ?.data
                ?.highlights
                ?.inProgressWork
                ?.actualStartTime,
            plannedStartTime: homeData
                .value
                ?.data
                ?.highlights
                ?.nextUpcomingWork
                ?.plannedStartTime,
            isProgress:
                homeData.value?.data?.highlights?.inProgressWork != null,
          );
        }
        getTimeLineDetail();
      } else {
        homeData.value = null;
      }
    } catch (e, stackTrace) {
      homeData.value = null;

      debugPrint('fetchWorkLogList error: $e');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      isloading.value = false;
    }
  }

  void startTimer({
    bool isProgress = false,
    String? actualStartTime,
    String? plannedStartTime,
  }) {
    _timer?.cancel();

    // ==========================
    // IN PROGRESS
    // ==========================
    if (isProgress) {
      if (actualStartTime == null || actualStartTime.isEmpty) {
        runningTime.value = "00:00:00";
        return;
      }

      DateTime start;

      try {
        start = DateTime.parse(actualStartTime).toLocal();
      } catch (_) {
        runningTime.value = "00:00:00";
        return;
      }

      void update() {
        final duration = DateTime.now().difference(start);

        if (duration.isNegative) {
          runningTime.value = "00:00:00";
          return;
        }

        runningTime.value = _formatDuration(duration);
      }

      update();

      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        update();
      });

      return;
    }

    // ==========================
    // BEFORE START
    // ==========================
    if (plannedStartTime == null || plannedStartTime.isEmpty) {
      runningTime.value = "--";
      return;
    }

    void update() {
      try {
        final now = DateTime.now();
        final parsed = DateFormat("HH:mm:ss").parse(plannedStartTime);

        final start = DateTime(
          now.year,
          now.month,
          now.day,
          parsed.hour,
          parsed.minute,
          parsed.second,
        );

        final difference = start.difference(now);

        if (difference.isNegative) {
          runningTime.value = "Not yet started";
          _timer?.cancel(); // Stop updating once start time has passed
          return;
        }

        final hours = difference.inHours;
        final minutes = difference.inMinutes.remainder(60);
        final seconds = difference.inSeconds.remainder(60);

        if (hours > 0) {
          runningTime.value = "Starts in ${hours}hr ${minutes}min ${seconds}s";
        } else {
          runningTime.value = "Starts in ${minutes}min ${seconds}s";
        }
      } catch (_) {
        runningTime.value = "--";
        _timer?.cancel();
      }
    }

    update();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      update();
    });
  }

  String _formatDuration(Duration duration) {
    if (duration.isNegative) {
      return "00:00:00";
    }

    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return "$hours:$minutes:$seconds";
  }

  Future<void> getTimeLineDetail() async {
    try {
      //  if (_markerIconCache.isEmpty) {
      //   await _initMarkerIcons();
      // }
      final authController = Get.find<UserAuthController>();
      final String empId =
          authController.userData.value.userData?.employeeId ?? '';

      final resp = await ApiServices.getTimeLineDetail(
        employeeId: empId,
        date: formatDate(DateTime.now()),
      );

      if (resp['status']?.toString() == '200') {
        timelineData.value = TimelineResponse.fromJson(resp);
        drawPolyline(timelineData.value?.data?.routePoints);
      } else {
        timelineData.value = null;
      }
    } catch (e, stackTrace) {
      timelineData.value = null;

      debugPrint('fetchWorkLogList error: $e');
      debugPrintStack(stackTrace: stackTrace);
    } finally {}
  }

  void drawPolyline(List<RoutePoints>? routePoints) {
    if (routePoints == null || routePoints.isEmpty) {
      newPolylines.value = {};
      return;
    }

    const double maxGapDistance = 5000.0; // meters

    final Set<Polyline> polylines = {};
    List<LatLng> currentSegment = [];

    for (final point in routePoints) {
      if (point.latitude == null || point.longitude == null) continue;

      final current = LatLng(point.latitude!, point.longitude!);

      if (currentSegment.isEmpty) {
        currentSegment.add(current);
        continue;
      }

      final previous = currentSegment.last;
      final distance = _calculateDistance(previous, current);

      // If the distance is too large, finish the current polyline
      // and start a new one, leaving a blank gap.
      if (distance > maxGapDistance) {
        if (currentSegment.length > 1) {
          polylines.add(
            Polyline(
              polylineId: PolylineId('route_${polylines.length}'),
              points: List.from(currentSegment),
              color: Colors.blue,
              width: 5,
              startCap: Cap.roundCap,
              endCap: Cap.roundCap,
              jointType: JointType.round,
            ),
          );
        }

        currentSegment = [current];
      } else {
        currentSegment.add(current);
      }
    }

    // Add the last segment
    if (currentSegment.length > 1) {
      polylines.add(
        Polyline(
          polylineId: PolylineId('route_${polylines.length}'),
          points: List.from(currentSegment),
          color: Colors.blue,
          width: 5,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          jointType: JointType.round,
        ),
      );
    }

    newPolylines.value = polylines;
  }

  String formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('yyyy-MM-dd').format(date);
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

  Future<bool> checkInprogressWork({required BuildContext context}) async {
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

      final body = {"company_id": compId, "employee_id": empId};

      AttendanceCommonWidgets().printF("checkInprogressWork----- $body");

      final resp = await ApiServices.checkWorkInprogress(body: body);

      AttendanceCommonWidgets().printF("checkInprogressWork ----- $resp");

      if (resp['status'] == 200 || resp['status'] == 400) {
        final data = InprogressWorkResponse.fromJson(resp);

        if (data.data?.hasInProgress == true) {
          final message =
              '''
You already have an active work assignment.

Work Name: ${data.data?.works?.first.work?.title ?? '-'}
Assigned Date: ${data.data?.works?.first.scheduledDate ?? '-'}

Please complete and submit your current work before starting a new one.
''';

          AttendanceCommonWidgets().showSnackBar(
            context: context,
            backgroundColor: Colors.green,
            message: message,
          );

          return true;
        }

        return false;
      }

      debugPrint("Error: ${resp["message"]}");
      return false;
    } catch (e) {
      debugPrint('checkInprogressWork error: $e');
      return false;
    }
  }
}
