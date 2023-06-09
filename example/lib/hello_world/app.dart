import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import '../app.dart';
import '../config/ENV.dart';

////
// For pretty-printing locations as JSON
// @see _onLocation
//
import 'dart:convert';

JsonEncoder encoder = new JsonEncoder.withIndent("     ");

class HelloWorldApp extends StatelessWidget {
  static const String NAME = 'hello_world';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData();
    return new MaterialApp(
      title: 'BackgroundGeolocation Demo',
      theme: theme.copyWith(
          bottomAppBarColor: Colors.amberAccent,
          colorScheme: theme.colorScheme.copyWith(secondary:Colors.black),
          primaryTextTheme: Theme.of(context).primaryTextTheme.apply(
                bodyColor: Colors.black,
              )),
      home: new HelloWorldPage(),
    );
  }
}

class HelloWorldPage extends StatefulWidget {
  HelloWorldPage({Key? key}) : super(key: key);

  @override
  _HelloWorldPageState createState() => new _HelloWorldPageState();
}

class _HelloWorldPageState extends State<HelloWorldPage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  late bool _isMoving;
  late bool _enabled;
  late String _motionActivity;
  late String _odometer;
  late String _content;

  @override
  void initState() {
    super.initState();
    _content = "    Enable the switch to begin tracking.";
    _isMoving = false;
    _enabled = false;
    _content = '';
    _motionActivity = 'UNKNOWN';
    _odometer = '0';
    _initPlatformState();
  }

  Future _initPlatformState() async {
    SharedPreferences prefs = await _prefs;
    String? orgname = prefs.getString("orgname");
    String? username = prefs.getString("username");

    // Sanity check orgname & username:  if invalid, go back to HomeApp to re-register device.
    if (orgname == null || username == null) {
      return runApp(HomeApp());
    }

    // Fetch a Transistor demo server Authorization token for tracker.transistorsoft.com.
    bg.TransistorAuthorizationToken token =
        await bg.TransistorAuthorizationToken.findOrCreate(
            orgname, username, ENV.TRACKER_HOST);

    // 1.  Listen to events (See docs for all 12 available events).
    bg.BackgroundGeolocation.onLocation(_onLocation, _onLocationError);
    bg.BackgroundGeolocation.onMotionChange(_onMotionChange);
    bg.BackgroundGeolocation.onActivityChange(_onActivityChange);
    bg.BackgroundGeolocation.onProviderChange(_onProviderChange);
    bg.BackgroundGeolocation.onConnectivityChange(_onConnectivityChange);
    bg.BackgroundGeolocation.onHttp(_onHttp);
    bg.BackgroundGeolocation.onAuthorization(_onAuthorization);

    // 2.  Configure the plugin
    bg.BackgroundGeolocation.ready(bg.Config(
            reset: true,
            debug: true,
            logLevel: bg.Config.LOG_LEVEL_VERBOSE,
            desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
            distanceFilter: 10.0,
            backgroundPermissionRationale: bg.PermissionRationale(
                title:
                    "Allow {applicationName} to access this device's location even when the app is closed or not in use.",
                message:
                    "This app collects location data to enable recording your trips to work and calculate distance-travelled.",
                positiveAction: 'Change to "{backgroundPermissionOptionLabel}"',
                negativeAction: 'Cancel'),
            url: "${ENV.TRACKER_HOST}/api/locations",
            authorization: bg.Authorization(
                // <-- demo server authenticates with JWT
                strategy: bg.Authorization.STRATEGY_JWT,
                accessToken: token.accessToken,
                refreshToken: token.refreshToken,
                refreshUrl: "${ENV.TRACKER_HOST}/api/refresh_token",
                refreshPayload: {'refresh_token': '{refreshToken}'}),
            stopOnTerminate: false,
            startOnBoot: true,
            enableHeadless: true))
        .then((bg.State state) {
      print("[ready] ${state.toMap()}");
      setState(() {
        _enabled = state.enabled;
        _isMoving = state.isMoving!;
      });
    }).catchError((error) {
      print('[ready] ERROR: $error');
    });
  }

  void _onClickEnable(enabled) {
    if (enabled) {
      // Reset odometer.
      bg.BackgroundGeolocation.start().then((bg.State state) {
        print('[start] success $state');
        setState(() {
          _enabled = state.enabled;
          _isMoving = state.isMoving!;
        });
      }).catchError((error) {
        print('[start] ERROR: $error');
      });
    } else {
      bg.BackgroundGeolocation.stop().then((bg.State state) {
        print('[stop] success: $state');

        setState(() {
          _enabled = state.enabled;
          _isMoving = state.isMoving!;
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
            persist: true, // <-- do persist this location
            desiredAccuracy: 0, // <-- desire best possible accuracy
            timeout: 30, // <-- wait 30s before giving up.
            samples: 3 // <-- sample 3 location before selecting best.
            )
        .then((bg.Location location) {
      print('[getCurrentPosition] - $location');
    }).catchError((error) {
      print('[getCurrentPosition] ERROR: $error');
    });
  }

  // Go back to HomeApp.
  void _onClickHome() {
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

  void _onLocationError(bg.LocationError error) {
    print('[location] ERROR - $error');
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

  void _onHttp(bg.HttpEvent event) async {
    print('[${bg.Event.HTTP}] - $event');
  }

  void _onAuthorization(bg.AuthorizationEvent event) async {
    print('[${bg.Event.AUTHORIZATION}] = $event');

    bg.BackgroundGeolocation.setConfig(
        bg.Config(url: ENV.TRACKER_HOST + '/api/locations'));
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.home, color: Colors.black),
            onPressed: _onClickHome),
        title: const Text('BG Geo'),
        foregroundColor: Colors.black,
        actions: <Widget>[
          Switch(value: _enabled, onChanged: _onClickEnable),
        ],
        backgroundColor: Theme.of(context).bottomAppBarColor,
      ),
      body: SingleChildScrollView(child: Text('$_content')),
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
                        child: Icon(
                            (_isMoving) ? Icons.pause : Icons.play_arrow,
                            color: Colors.white),
                        color: (_isMoving) ? Colors.red : Colors.green,
                        onPressed: _onClickChangePace)
                  ]))),
    );
  }
}
