import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:background_fetch/background_fetch.dart';

import 'package:flutter_background_geolocation_example/app.dart';
import 'advanced/app.dart';
import 'hello_world/app.dart';

import 'config/transistor_auth.dart';
import 'config/ENV.dart';

/// Receive events from BackgroundGeolocation in Headless state.
void backgroundGeolocationHeadlessTask(bg.HeadlessEvent headlessEvent) async {
  print('📬 --> $headlessEvent');

  switch (headlessEvent.name) {
    case bg.Event.BOOT:
      bg.State state = await bg.BackgroundGeolocation.state;
      print("📬 didDeviceReboot: ${state.didDeviceReboot}");
      break;
    case bg.Event.TERMINATE:
      try {
        bg.Location location =
            await bg.BackgroundGeolocation.getCurrentPosition(samples: 1);
        print("[getCurrentPosition] Headless: $location");
      } catch (error) {
        print("[getCurrentPosition] Headless ERROR: $error");
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
      print(location);
      break;
    case bg.Event.MOTIONCHANGE:
      bg.Location location = headlessEvent.event;
      print(location);
      break;
    case bg.Event.GEOFENCE:
      bg.GeofenceEvent geofenceEvent = headlessEvent.event;
      print(geofenceEvent);
      break;
    case bg.Event.GEOFENCESCHANGE:
      bg.GeofencesChangeEvent event = headlessEvent.event;
      print(event);
      break;
    case bg.Event.SCHEDULE:
      bg.State state = headlessEvent.event;
      print(state);
      break;
    case bg.Event.ACTIVITYCHANGE:
      bg.ActivityChangeEvent event = headlessEvent.event;
      print(event);
      break;
    case bg.Event.HTTP:
      bg.HttpEvent response = headlessEvent.event;
      print(response);
      break;
    case bg.Event.POWERSAVECHANGE:
      bool enabled = headlessEvent.event;
      print(enabled);
      break;
    case bg.Event.CONNECTIVITYCHANGE:
      bg.ConnectivityChangeEvent event = headlessEvent.event;
      print(event);
      break;
    case bg.Event.ENABLEDCHANGE:
      bool enabled = headlessEvent.event;
      print(enabled);
      break;
    case bg.Event.AUTHORIZATION:
      bg.AuthorizationEvent event = headlessEvent.event;
      print(event);
      bg.BackgroundGeolocation.setConfig(
          bg.Config(url: "${ENV.TRACKER_HOST}/api/locations"));
      break;
  }
}

/// Receive events from BackgroundFetch in Headless state.
void backgroundFetchHeadlessTask(HeadlessTask task) async {
  String taskId = task.taskId;

  // Is this a background_fetch timeout event?  If so, simply #finish and bail-out.
  if (task.timeout) {
    print("[BackgroundFetch] HeadlessTask TIMEOUT: $taskId");
    BackgroundFetch.finish(taskId);
    return;
  }

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

  var channel = const MethodChannel(
      'com.transistorsoft.flutterbackgroundgeolocationexample/background_service');
  var callbackHandle = PluginUtilities.getCallbackHandle(backgroundMain);
  channel.invokeMethod('startService', callbackHandle.toRawHandle());

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

    switch (appName) {
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
  bg.BackgroundGeolocation.registerHeadlessTask(
      backgroundGeolocationHeadlessTask);

  /// Register BackgroundFetch headless-task.
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}

/// This method is executed as a standalone isolate, hosted by a foreground service.
void backgroundMain() async {
  WidgetsFlutterBinding.ensureInitialized();

  print("[BackgroundMain] Running");

  /// Requesting anything over the [MethodChannel] always works, because
  /// the MethodChannel is instantiated within `onAttachedToEngine`
  ///
  /// Running, Terminated, doesn't matter - I can request this here in the background
  final state = await bg.BackgroundGeolocation.state;
  print("[BackgroundMain] State: $state");

  // You can set config, start, stop, etc.
  await bg.BackgroundGeolocation.setConfig(bg.Config(autoSync: false));

  // Methods that require an activity (like requesting permissions)
  // should be handled in the UI isolate, and not here. The consuming application
  // can and should handle this.

  /// No [EventChannel]s work here, because they're tied to the activity lifecycle.
  /// However, they shouldn't need an activity, because the headless task isn't
  /// tied to an activity, correct?
  ///
  /// If you create the [EventChannel]s during `onAttachedToEngine`, they work.
  /// However, since listeners are cleaned up and event channels cleared based on
  /// the Activity lifecycle - they will quit working after terminate.
  bg.BackgroundGeolocation.onLocation(
      (p0) => print("[BackgroundMain] - Location - $p0"));

  /// Periodically request status from the plugin
  Timer.periodic(Duration(seconds: 5), (_) async {
    final count = await bg.BackgroundGeolocation.count;
    final locations = await bg.BackgroundGeolocation.locations;

    print("[BackgroundMain] =======================================");
    print("[BackgroundMain] Num pending locations: $count");
    print("[BackgroundMain] Pending locations - $locations");

    print("[BackgroundMain] =======================================");

    // If desired - you can thrash the enabled / disabled status while terminated
    // Simply uncomment the below.

    // final state = await bg.BackgroundGeolocation.state;
    // if (state.enabled) {
    //   await bg.BackgroundGeolocation.stop();
    // } else {
    //   await bg.BackgroundGeolocation.start();
    // }
  });
}
