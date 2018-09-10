import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart';

const COLOR_GOLD = Color.fromRGBO(254, 221, 30, 1.0);
const COLOR_GREEN = Color.fromRGBO(17, 183, 0, 1.0);

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _state = "UNDEFINED";

  bool _enabled = false;
  bool _isMoving = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    String state;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await BackgroundGeolocation.platformVersion();
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    BackgroundGeolocation.onMotionChange((Location location) {
      print("*********** [motionchange 1 ] *************" + location.toString());
    });

    BackgroundGeolocation.onMotionChange((Location location) {
      print("*********** [motionchange 2] *************" + location.toString());
      print(location.toString());
    });

    BackgroundGeolocation.onLocation((Location location) {
      print("*********** [location 1] *************" + location.toString());
      print(location.toString());
    });

    Function(Location) myCallback = (Location location) {
      print("*********** [location 2] *************" + location.toString());
      print(location.toString());
    };
    BackgroundGeolocation.onLocation(myCallback);

    BackgroundGeolocation.onActivityChange((ActivityChangeEvent event) {
      print('******** [activitychange] $event');
    });

    BackgroundGeolocation.onGeofence((GeofenceEvent event) {
      print('********* [geofenceevent] $event');
    });

    BackgroundGeolocation.onGeofencesChange((GeofencesChangeEvent event) {
      print('******** [geofenceschange] $event');
    });

    BackgroundGeolocation.onHeartbeat((HeartbeatEvent event) {
      print('******** [heartbeatevent] $event');
    });

    BackgroundGeolocation.onProviderChange((ProviderChangeEvent event) {
      print('******** [providerchange] $event');
    });

    BackgroundGeolocation.onConnectivityChange((ConnectivityChangeEvent event) {
      print('******** [connectivitychange] $event');
    });

    BackgroundGeolocation.onEnabledChange((bool enabled) {
      print('*********[enabledchange] ' + enabled.toString());
    });

    BackgroundGeolocation.onPowerSaveChange((bool enabled) {
      print('********* [powersavechange] enabled? ' + enabled.toString());
    });
    
    //BackgroundGeolocation.removeListener(myCallback);
    //BackgroundGeolocation.removeListeners();

    BGConfig config = new BGConfig(
        reset: true,
        distanceFilter: 10.0,
        stopOnTerminate: false,
        startOnBoot: true,
        debug: true,
        logLevel: 5
    );
    BackgroundGeolocation.ready(config).then((BGState state) {
      print("*********** ready success: " + state.toString());

      BackgroundGeolocation.getState().then((BGState state) {
        print("**************** getState: " + state.toString());
        print("** Map: " + state.map.toString());
      });

      setState(() {
        _enabled = state.enabled;
        _isMoving = state.isMoving;
      });
    });

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  void _onClickEnable(bool enabled) {
    print("- onClickEnable: " + enabled.toString());
    setState(() {
      _enabled = enabled;
    });
    if (enabled) {
      BackgroundGeolocation.start();
    } else {
      BackgroundGeolocation.stop();
    }
  }
  void _onClickMenu() {
    print("- onClickMenu");
  }

  void _onClickStart() {
    print("- onClickStart");
  }

  void _onClickStop() {
    print("- onClickStop");
  }

  void _onClickChangePace() {
    print("- onClickChangePace");

    BackgroundGeolocation.changePace(_isMoving).then((bool isMoving) {
      print('[changePace] success $isMoving');
    }).catchError((e) {
      print('[changePace] ERROR: ' + e.code.toString());
    });

    setState(() {
      _isMoving = !_isMoving;
    });
  }

  void _onClickGetCurrentPosition() {

    BackgroundGeolocation.getCurrentPosition(
      persist: true,
      desiredAccuracy: 0,
      timeout: 10000,
      samples: 3
    ).then((Location location) {
      print('[getCurrentPosition] - ' + location.toString());
    }).catchError((error) {
      print('[getCurrentPosition] ERROR: ' + error.code);
    });
  }

  void _onClickGetOdometer() async {
    double odometer = await BackgroundGeolocation.getOdometer() / 1000;
    print ('[getOdometer] $odometer km');
  }

  void _onClickResetOdometer() async {
    Location location = await BackgroundGeolocation.setOdometer(0.0);
    print('[resetOdometer] - $location');
    _onClickGetOdometer()
  }

  void _onClickSetConfig() {
    BGConfig config = new BGConfig(
        distanceFilter: 100.0,
        stopTimeout: 1,
        debug: true,
        logLevel: 5,
        geofenceProximityRadius: 1001
    );
    BackgroundGeolocation.setConfig(config).then((BGState state) {
      print('[setConfig] success: ' + state.distanceFilter.toString());
    }).catchError((error) {

      print('[setConfig] ERROR: ' + error.toString());
    });
  }

  void _onClickReset() {
    BackgroundGeolocation.reset().then((BGState state) {
      print('[reset] success - distanceFilter: ' + state.distanceFilter.toString());
    }).catchError((error) {
      print('[reset] ERROR 1: ' + error.toString());
    });

    BackgroundGeolocation.reset(new BGConfig(
      desiredAccuracy: BGConfig.DESIRED_ACCURACY_NAVIGATION,
      distanceFilter:1.0,
      logLevel: BGConfig.LOG_LEVEL_VERBOSE,
      debug:true
    )).then((BGState state) {
      print('[reset] success - distanceFilter: ' + state.distanceFilter.toString());
    }).catchError((error) {
      print('[reset] ERROR 2: ' + error.toString());
    });
  }

  void _onClickGetState() async {
    BGState state = await BackgroundGeolocation.getState();
    print('[getState] ' + state.map.toString());
  }
  void _onClickGetCount() {
    BackgroundGeolocation.getCount().then((int count) {
      print('[getCount] - ' + count.toString());
    });
  }

  void _onClickGetLocations() {
    BackgroundGeolocation.getLocations().then((List<dynamic> rs) {
      rs.forEach((dynamic item) {
        var coords = item['coords'];
        print('- location: ' + coords.toString());
      });
      print("************ getLocations: " + rs.toString());
    });
  }

  void _onClickDestroyLocations() {
    BackgroundGeolocation.destroyLocations().then((success) {
      print('[destroyLocations] - ' + success.toString());
    });
  }

  void _onClickAddGeofence() {
    BackgroundGeolocation.getCurrentPosition(samples:1, persist: false).then((Location l) {
      Geofence geofence = new Geofence(
        identifier: "foo",
        latitude: l.coords.latitude,
        longitude: l.coords.longitude,
        radius: 200.0,
        notifyOnEntry: true,
        notifyOnExit: true,
        extras: {"foo":"bar"}
      );
      BackgroundGeolocation.addGeofence(geofence).then((bool success) {
        print("*********** addGeofence: " + success.toString());
      }).catchError((error) {
        print('************ error: $error.code');
      });
    });
  }

  void _onClickRemoveGeofence() {
    BackgroundGeolocation.removeGeofence("foo").then((bool success) {
      print('********* removeGeofence; $success');
    }).catchError((error) {
      print('********** removeGeofence error: $error.code');
    });
  }

  void _onClickRemoveGeofences() {
    BackgroundGeolocation.removeGeofences().then((bool success) {
      print('*********** removeGeofences: $success');
    }).catchError((error) {
      print('*********** removeGeofences error: $error.code');
    });
  }
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: Theme.of(context).copyWith(
        accentColor: Colors.black,
        primaryColor: COLOR_GOLD,
        primaryTextTheme: Theme.of(context).primaryTextTheme.apply(bodyColor: Colors.black)
      ),
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Background Geolocation'),
          actions: <Widget>[
            new Switch(
                value: _enabled,
                onChanged: _onClickEnable,
                activeColor: COLOR_GREEN,
            ),

          ]
        ),

        body: new Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                new RaisedButton(
                  onPressed: _onClickChangePace,
                  child: new Icon((_isMoving) ? Icons.pause : Icons.play_arrow),
                ),
                new RaisedButton(
                  onPressed: _onClickGetCurrentPosition,
                  child: new Icon(Icons.gps_fixed)
                ),
              ],
            ),
            new Row(
              children: <Widget>[
                new RaisedButton(onPressed: _onClickGetOdometer, child: new Text('getOdometer')),
                new RaisedButton(onPressed: _onClickResetOdometer, child: new Text('resetOdometer'))
              ]
            ),
            new Row(
              children: <Widget>[
                new RaisedButton(
                  onPressed: _onClickSetConfig,
                  child: new Text('setConfig')
                ),
                new RaisedButton(
                  onPressed: _onClickReset,
                  child: new Text('reset')
                ),
                new RaisedButton(
                  onPressed: this._onClickGetState,
                  child: new Text('getState')
                )
              ]
            ),
            new Row(
              children: <Widget>[
                new RaisedButton(
                  onPressed: _onClickGetCount,
                  child: new Text('getCount')
                ),
                new RaisedButton(
                  onPressed: _onClickGetLocations,
                  child: new Text('getLocations')
                ),
                new RaisedButton(
                  onPressed: _onClickDestroyLocations,
                  child: new Text('destroy')
                )
              ],
            ),
            new Text('Geofences'),
            new Row(
                children: <Widget>[
                  new RaisedButton(
                      onPressed: _onClickAddGeofence,
                      child: new Text('add')
                  ),
                  new RaisedButton(
                      onPressed: _onClickRemoveGeofence,
                      child: new Text('remove')
                  ),
                  new RaisedButton(
                      onPressed: _onClickRemoveGeofences,
                      child: new Text('remove all')
                  )
                ]
            )
          ],
        ),
        floatingActionButton: new FloatingActionButton(
          onPressed: _onClickMenu,
          tooltip: 'Menu',
          child: new Icon(Icons.add),
        ),
      ),
    );
  }
}

/*
new Center(
//child: new Text('Running on: $_platformVersion, state: $_state\n'),
child: new Column(
mainAxisAlignment: MainAxisAlignment.center,
children: <Widget>[
new FloatingActionButton(
onPressed: _onClickMenu,
child: new Icon(Icons.add),
),
new Row(
mainAxisAlignment: MainAxisAlignment.center,
children: <Widget>[
new RaisedButton(
onPressed: _onClickStart,
child: new Text("Start")
),
new RaisedButton(
onPressed: _onClickStop,
child: new Text("Stop")
),

)
]
),

new Text("Platform Version: $_platformVersion"),
new Text("TEXT 1"),
new Text(
'You have pushed the button this many times:',
),
new Text(
'TEXT 2',
style: Theme.of(context).textTheme.display1,
),
],

)
*/