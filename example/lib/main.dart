import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:flutter_background_geolocation_example/app.dart';
import 'advanced/app.dart';
import 'hello_world/app.dart';

/// Receives events from BackgroundGeolocation in Headless state.
///
void headlessTask(bg.HeadlessEvent event) async {
  print('📬 --> $event');

  switch(event.name) {
    case bg.Event.TERMINATE:
      bg.Location location = await bg.BackgroundGeolocation.getCurrentPosition(samples: 1);
      print('[getCurrentPosition] Headless: $location');
      break;
    case bg.Event.HEARTBEAT:
      bg.Location location = await bg.BackgroundGeolocation.getCurrentPosition(samples: 1);
      print('[getCurrentPosition] Headless: $location');
      break;
  }
  event.finish();
}

void main() async {

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String appName = prefs.getString("app");

  Widget app;

  switch(appName) {
    case AdvancedApp.NAME:
      app = new AdvancedApp();
      break;
    case HelloWorldApp.NAME:
      app = new HelloWorldApp();
      break;
    default:
      app = HomeApp();
      break;
  }
  runApp(app);

  /// Register Headless Task.
  bg.BackgroundGeolocation.registerHeadlessTask(headlessTask);
}
