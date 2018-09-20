import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:flutter_background_geolocation_example/app.dart';
import 'advanced/app.dart';
import 'hello_world/app.dart';

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

  /* TODO Android headless implementation
  bg.BackgroundGeolocation.registerHeadlessTask((String result) async {
    bg.Location location = await bg.BackgroundGeolocation.getCurrentPosition(samples: 1);
  });
  */

}
