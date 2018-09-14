import 'dart:async';
import 'package:flutter/material.dart';
import 'src/app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/advanced/app.dart';
import 'src/hello_world/app.dart';

void main() async {

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String appName = prefs.getString("app");

  Widget app;

  switch(appName) {
    case 'advanced':
      app = new AdvancedApp();
      break;
    case 'hello_world':
      app = new HelloWorldApp();
      break;
    default:
      app = HomeApp();
      break;
  }
  runApp(app);
}
