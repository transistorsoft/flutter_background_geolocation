import 'package:flutter_driver/driver_extension.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;

class TestApp extends StatefulWidget {
  @override
  _TestAppState createState() => new _TestAppState();
}

class _TestAppState extends State<TestApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        theme: Theme.of(context).copyWith(
            accentColor: Colors.black,
            primaryTextTheme: Theme.of(context).primaryTextTheme.apply(
              bodyColor: Colors.black,
            )
        ),
        home: new Text('TestApp')
    );
  }
}

void main() {
  bg.BackgroundGeolocation.ready(bg.Config(
    debug: true,
    logLevel: bg.Config.LOG_LEVEL_VERBOSE
  ));

  enableFlutterDriverExtension(handler: (String command) async {
    print("FlutterDriverExtendsion Rx: $command");

    switch(command) {
      case 'getState':
        bg.State state = await bg.BackgroundGeolocation.getState();
        return state.toString();
        break;
      case 'getCurrentPosition':
        bg.Location location = await bg.BackgroundGeolocation.getCurrentPosition(samples: 1);
        return location.toString();
        break;
      case 'addGeofence':
        Completer completer = new Completer<String>();

        bg.BackgroundGeolocation.onGeofence((bg.GeofenceEvent event) {
          completer.complete(event.toString());
        });

        bg.Location location = await bg.BackgroundGeolocation.getCurrentPosition(samples: 1);
        bg.Geofence geofence = bg.Geofence(
          identifier: 'test',
          radius: 200.0,
          latitude: location.coords.latitude,
          longitude: location.coords.longitude,
          notifyOnEntry: true
        );
        bg.BackgroundGeolocation.addGeofence(geofence);
        bg.BackgroundGeolocation.start();

        return await completer.future;
        break;
      case 'getGeofences':
        List<bg.Geofence> geofences = await bg.BackgroundGeolocation.getGeofences();
        return geofences.toString();
        break;
      default:
        return "404";
    }
  });

  runApp(TestApp());
}

