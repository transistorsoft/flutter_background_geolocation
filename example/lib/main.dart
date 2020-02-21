import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:background_fetch/background_fetch.dart';

import 'package:flutter_background_geolocation_example/app.dart';
import 'advanced/app.dart';
import 'hello_world/app.dart';

import 'config/transistor_auth.dart';
import 'config/env.dart';

/// Receive events from BackgroundGeolocation in Headless state.
void backgroundGeolocationHeadlessTask(bg.HeadlessEvent headlessEvent) async {
  print('📬 --> $headlessEvent');

  switch(headlessEvent.name) {
    case bg.Event.TERMINATE:
      try {
        //bg.Location location = await bg.BackgroundGeolocation.getCurrentPosition(samples: 1);
        print('[getCurrentPosition] Headless: $headlessEvent');
      } catch (error) {
        print('[getCurrentPosition] Headless ERROR: $error');
      }
      break;
    case bg.Event.HEARTBEAT:
      /* DISABLED getCurrentPosition on heartbeat
      try {
        bg.Location location = await bg.BackgroundGeolocation.getCurrentPosition(samples: 1);
        print('[getCurrentPosition] Headless: $location');
      } catch (error) {
        print('[getCurrentPosition] Headless ERROR: $error');
      }
      */
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
    case bg.Event.AUTHORIZATION:
      bg.AuthorizationEvent event = headlessEvent.event;
      bg.BackgroundGeolocation.setConfig(bg.Config(
        url: "${ENV.TRACKER_HOST}/api/locations"
      ));
      break;
  }
}

/// Receive events from BackgroundFetch in Headless state.
void backgroundFetchHeadlessTask(String taskId) async {
  // Get current-position from BackgroundGeolocation in headless mode.
  //bg.Location location = await bg.BackgroundGeolocation.getCurrentPosition(samples: 1);
  print("[BackgroundFetch] HeadlessTask: $taskId");

  SharedPreferences prefs = await SharedPreferences.getInstance();
  int count = 0;
  if (prefs.get("fetch-count") != null) {
    count = prefs.getInt("fetch-count");
  }
  prefs.setInt("fetch-count", ++count);
  print('[BackgroundFetch] count: $count');

  BackgroundFetch.finish(taskId);
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  /// Application selection:  Select the app to boot:
  /// - AdvancedApp
  /// - HelloWorldAp
  /// - HomeApp
  ///
  SharedPreferences.getInstance().then((SharedPreferences prefs) {
    String appName = prefs.getString("app");

    // Sanitize old-style registration system that only required username.
    // If we find a valid username but null orgname, reverse them.
    String orgname = prefs.getString("orgname");
    String username = prefs.getString("username");

    if (orgname == null && username != null) {
      prefs.setString("orgname", username);
      prefs.remove("username");
    }

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
  TransistorAuth.registerErrorHandler();
  /// Register BackgroundGeolocation headless-task.
  bg.BackgroundGeolocation.registerHeadlessTask(backgroundGeolocationHeadlessTask);
  /// Register BackgroundFetch headless-task.
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}
