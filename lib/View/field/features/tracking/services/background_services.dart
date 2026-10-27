import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:loyaltri_minimal/View/field/features/tracking/services/track_v2_uploader.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

@pragma('vm:entry-point')
void headlessTask(bg.HeadlessEvent headlessEvent) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  print('[BackgroundGeolocation HeadlessTask] ${headlessEvent.name}');

  if (headlessEvent.name == bg.Event.CONNECTIVITYCHANGE) {
    final event = headlessEvent.event;
    final connected = event is bg.ConnectivityChangeEvent
        ? event.connected
        : false;
    await TrackV2Uploader.postConnectivity(connected);
  } else if (headlessEvent.name == bg.Event.PROVIDERCHANGE) {
    final event = headlessEvent.event;
    if (event is bg.ProviderChangeEvent) {
      await TrackV2Uploader.postLocationServices(event.enabled);
    }
  } else if (headlessEvent.name == bg.Event.POWERSAVECHANGE) {
    final event = headlessEvent.event;
    if (event is bool) {
      await TrackV2Uploader.postPowerSave(event);
    }
  } else if (headlessEvent.name == bg.Event.TERMINATE) {
    await TrackV2Uploader.postAppClosed();
  } else if (headlessEvent.name == bg.Event.HTTP) {
    final event = headlessEvent.event;
    if (event is bg.HttpEvent && event.status == 401) {
      await TrackV2Uploader.refreshAfterUnauthorized();
    }
  } else if (headlessEvent.name == bg.Event.ACTIVITYCHANGE) {
    bg.ActivityChangeEvent event = headlessEvent.event;
    await TrackV2Uploader.postActivity(event.activity, event.confidence);
  }
}
