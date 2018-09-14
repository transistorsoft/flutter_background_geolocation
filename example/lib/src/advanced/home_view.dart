import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;

import '../app.dart';
import 'map_view.dart';

// For pretty-printing location JSON
JsonEncoder encoder = new JsonEncoder.withIndent("     ");

class HomeView extends StatefulWidget {
  @override
  State createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _isMoving;
  bool _enabled;
  String _motionActivity;
  String _odometer;
  String _content;

  @override
  void initState() {
    super.initState();
    _isMoving = false;
    _enabled = false;
    _content = '';
    _motionActivity = 'UNKNOWN';
    _odometer = '0';

    initPlatformState();
  }

  Future<Null> initPlatformState() async {
    final SharedPreferences prefs = await _prefs;
    String username = prefs.getString("username");

    Map deviceParams = await bg.Config.deviceParams;


    // 1.  Listen to events (See docs for all 12 available events).
    bg.BackgroundGeolocation.onLocation(_onLocation);
    bg.BackgroundGeolocation.onMotionChange(_onMotionChange);
    bg.BackgroundGeolocation.onActivityChange(_onActivityChange);
    bg.BackgroundGeolocation.onProviderChange(_onProviderChange);
    bg.BackgroundGeolocation.onConnectivityChange(_onConnectivityChange);

    // 2.  Configure the plugin
    bg.BackgroundGeolocation.ready(bg.Config(
        desiredAccuracy: bg.Config.DESIRED_ACCURACY_NAVIGATION,
        distanceFilter: 10.0,
        stopOnTerminate: false,
        startOnBoot: true,
        foregroundService: true,
        stopTimeout: 1,
        debug: true,
        autoSync: true,
        url: 'http://tracker.transistorsoft.com/locations/$username',
        params: deviceParams,
        logLevel: bg.Config.LOG_LEVEL_VERBOSE
    )).then((bg.State state) {
      setState(() {
        _enabled = state.enabled;
        _isMoving = state.isMoving;
      });
    });
  }

  void _onClickEnable(enabled) {
    if (enabled) {
      bg.BackgroundGeolocation.start().then((bg.State state) {
        print('[start] success $state');
        setState(() {
          _enabled = state.enabled;
          _isMoving = state.isMoving;
        });
      });
    } else {
      bg.BackgroundGeolocation.setOdometer(0.0);
      bg.BackgroundGeolocation.stop().then((bg.State state) {
        print('[stop] success: $state');
        // Reset odometer.
        setState(() {
          _odometer = '0.0';
          _enabled = state.enabled;
          _isMoving = state.isMoving;
        });
      });
    }
  }

  // Manually toggle the tracking state:  moving vs stationary
  void _onClickChangePace() {
    setState(() {
      _isMoving = !_isMoving;
    });
    print("[onClickChangePace] -> $_isMoving");

    bg.BackgroundGeolocation.changePace(_isMoving).then((bool isMoving) {
      print('[changePace] success $isMoving');
    }).catchError((e) {
      print('[changePace] ERROR: ' + e.code.toString());
    });
  }

  // Manually fetch the current position.
  void _onClickGetCurrentPosition() {
    bg.BackgroundGeolocation.getCurrentPosition(
        persist: false,     // <-- do not persist this location
        desiredAccuracy: 0, // <-- desire best possible accuracy
        timeout: 30000,     // <-- wait 30s before giving up.
        samples: 3          // <-- sample 3 location before selecting best.
    ).then((bg.Location location) {
      print('[getCurrentPosition] - $location');
    }).catchError((error) {
      print('[getCurrentPosition] ERROR: $error');
    });
  }

  // Go back to HomeApp
  void _onClickHome() {
    bg.BackgroundGeolocation.stop();
    bg.BackgroundGeolocation.removeListeners();
    runApp(HomeApp());
  }

  ////
  // Event handlers
  //

  void _onLocation(bg.Location location) {
    print('[location] - $location');

    String odometerKM = (location.odometer / 1000.0).toStringAsFixed(1);

    setState(() {
      _content = encoder.convert(location.toMap());
      _odometer = odometerKM;
    });
  }

  void _onMotionChange(bg.Location location) {
    print('[motionchange] - $location');
  }

  void _onActivityChange(bg.ActivityChangeEvent event) {
    print('[activitychange] - $event');
    setState(() {
      _motionActivity = event.activity;
    });
  }

  void _onProviderChange(bg.ProviderChangeEvent event) {
    print('$event');

    setState(() {
      _content = encoder.convert(event.toMap());
    });
  }

  void _onConnectivityChange(bg.ConnectivityChangeEvent event) {
    print('$event');
  }

  @override
  Widget build(BuildContext context) {

    Widget body;
    // iOS doesn't yet support maps.
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      body = SingleChildScrollView(child: Text('$_content'));
    } else {
      body = new MapView();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Background Geolocation'),
        leading: IconButton(onPressed: _onClickHome, icon: Icon(Icons.home, color: Colors.black)),
        backgroundColor: Theme.of(context).bottomAppBarColor,
        actions: <Widget>[
          Switch(value: _enabled, onChanged: _onClickEnable
          ),
        ]
      ),
      body: body,
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.gps_fixed),
                onPressed: _onClickGetCurrentPosition,
              ),
              Text('$_motionActivity · $_odometer km'),
              MaterialButton(
                minWidth: 50.0,
                child: Icon((_isMoving) ? Icons.pause : Icons.play_arrow, color: Colors.white),
                color: (_isMoving) ? Colors.red : Colors.green,
                onPressed: _onClickChangePace
              )
            ]
          )
        )
      ),
    );
  }


}