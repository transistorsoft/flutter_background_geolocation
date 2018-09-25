import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:flutter_background_geolocation_example/app.dart';
import 'advanced/app.dart';
import 'hello_world/app.dart';

/// Receives events from BackgroundGeolocation in Headless state.
///
void headlessTask(bg.HeadlessEvent headlessEvent) async {
  print('📬 --> $headlessEvent');

  switch(headlessEvent.name) {
    case bg.Event.TERMINATE:
      try {
        bg.Location location = await bg.BackgroundGeolocation.getCurrentPosition(samples: 1);
        print('[getCurrentPosition] Headless: $location');
      } catch (error) {
        print('[getCurrentPosition] Headless ERROR: $error');
      }
      break;
    case bg.Event.HEARTBEAT:
      try {
        bg.Location location = await bg.BackgroundGeolocation.getCurrentPosition(samples: 1);
        print('[getCurrentPosition] Headless: $location');
      } catch (error) {
        print('[getCurrentPosition] Headless ERROR: $error');
      }
      break;
    case bg.Event.LOCATION:
      bg.Location location = headlessEvent.event;
      break;
    case bg.Event.MOTIONCHANGE:
      bg.Location location = headlessEvent.event;
      break;
    case bg.Event.GEOFENCE:
      bg.GeofenceEvent geofenceEvent = headlessEvent.event;
      break;
    case bg.Event.GEOFENCESCHANGE:
      bg.GeofencesChangeEvent event = headlessEvent.event;
      break;
    case bg.Event.SCHEDULE:
      bg.State state = headlessEvent.event;
      break;
    case bg.Event.ACTIVITYCHANGE:
      bg.ActivityChangeEvent event = headlessEvent.event;
      break;
    case bg.Event.HTTP:
      bg.HttpEvent response = headlessEvent.event;
      break;
    case bg.Event.POWERSAVECHANGE:
      bool enabled = headlessEvent.event;
      break;
    case bg.Event.CONNECTIVITYCHANGE:
      bg.ConnectivityChangeEvent event = headlessEvent.event;
      break;
    case bg.Event.ENABLEDCHANGE:
      bool enabled = headlessEvent.event;
      break;
  }
  // Important:  must signal completion of our headless task to native code.
  headlessEvent.finish();
}

void main() {
  /// Application selection:  Select the app to boot:
  /// - AdvancedApp
  /// - HelloWorldAp
  /// - HomeApp
  ///
  SharedPreferences.getInstance().then((SharedPreferences prefs) {
    String appName = prefs.getString("app");
    switch(appName) {
      case AdvancedApp.NAME:
        runApp(new AdvancedApp());
        break;
      case HelloWorldApp.NAME:
        runApp(new HelloWorldApp());
        break;
      default:
        // Default app.  Renders the application selector home page.
        runApp(new HomeApp());
    }
  });

  /// Register Headless Task.
  bg.BackgroundGeolocation.registerHeadlessTask(headlessTask);
}
