import 'package:flutter/material.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;

class TestButtons extends StatefulWidget {
  @override
  State createState() => TestButtonsState();
}

class TestButtonsState extends State<TestButtons> {
  bool _isMoving;

  @override
  void initState() {
    super.initState();
    bg.BackgroundGeolocation.getState().then((bg.State state) {
      _isMoving = state.isMoving;
    });

  }
  void _onClickChangePace() {
    print("- onClickChangePace");

    bg.BackgroundGeolocation.changePace(_isMoving).then((bool isMoving) {
      print('[changePace] success $isMoving');
    }).catchError((e) {
      print('[changePace] ERROR: ' + e.code.toString());
    });

    setState(() {
      _isMoving = !_isMoving;
    });
  }

  void _onClickGetCurrentPosition() {

    bg.BackgroundGeolocation.getCurrentPosition(
        persist: true,
        desiredAccuracy: 0,
        timeout: 10000,
        samples: 3
    ).then((bg.Location location) {
      print('[getCurrentPosition] - ' + location.toString());
    }).catchError((error) {
      print('[getCurrentPosition] ERROR: ' + error.code);
    });
  }

  void _onClickGetOdometer() async {
    double odometer = await bg.BackgroundGeolocation.getOdometer() / 1000;
    print ('[getOdometer] $odometer km');
  }

  void _onClickResetOdometer() async {
    bg.Location location = await bg.BackgroundGeolocation.setOdometer(0.0);
    print('[resetOdometer] - $location');
    _onClickGetOdometer();
  }

  void _onClickSetConfig() {
    bg.Config config = new bg.Config(
        distanceFilter: 100.0,
        stopTimeout: 1,
        debug: true,
        logLevel: 5,
        geofenceProximityRadius: 1001
    );
    bg.BackgroundGeolocation.setConfig(config).then((bg.State state) {
      print('[setConfig] success: ' + state.distanceFilter.toString());
    }).catchError((error) {

      print('[setConfig] ERROR: ' + error.toString());
    });
  }

  void _onClickReset() {
    bg.BackgroundGeolocation.reset().then((bg.State state) {
      print('[reset] success - distanceFilter: ' + state.distanceFilter.toString());
    }).catchError((error) {
      print('[reset] ERROR 1: ' + error.toString());
    });

    bg.BackgroundGeolocation.reset(new bg.Config(
        desiredAccuracy: bg.Config.DESIRED_ACCURACY_NAVIGATION,
        distanceFilter:1.0,
        logLevel: bg.Config.LOG_LEVEL_VERBOSE,
        debug:true
    )).then((bg.State state) {
      print('[reset] success - distanceFilter: ' + state.distanceFilter.toString());
    }).catchError((error) {
      print('[reset] ERROR 2: ' + error.toString());
    });
  }

  void _onClickGetState() async {
    bg.State state = await bg.BackgroundGeolocation.getState();
    print('[getState] ' + state.map.toString());
  }
  void _onClickGetCount() {
    bg.BackgroundGeolocation.getCount().then((int count) {
      print('[getCount] - ' + count.toString());
    });
  }

  void _onClickGetLocations() {
    bg.BackgroundGeolocation.getLocations().then((List<dynamic> rs) {
      rs.forEach((dynamic item) {
        var coords = item['coords'];
        print('- location: ' + coords.toString());
      });
      print("************ getLocations: " + rs.toString());
    });
  }

  void _onClickDestroyLocations() {
    bg.BackgroundGeolocation.destroyLocations().then((success) {
      print('[destroyLocations] - ' + success.toString());
    });
  }

  void _onClickAddGeofence() {
    bg.BackgroundGeolocation.getCurrentPosition(samples:1, persist: false).then((bg.Location l) {
      bg.Geofence geofence = new bg.Geofence(
          identifier: "foo",
          latitude: l.coords.latitude,
          longitude: l.coords.longitude,
          radius: 200.0,
          notifyOnEntry: true,
          notifyOnExit: true,
          extras: {"foo":"bar"}
      );
      bg.BackgroundGeolocation.addGeofence(geofence).then((bool success) {
        print("*********** addGeofence: " + success.toString());
      }).catchError((error) {
        print('************ error: $error.code');
      });
    });
  }

  void _onClickRemoveGeofence() {
    bg.BackgroundGeolocation.removeGeofence("foo").then((bool success) {
      print('********* removeGeofence; $success');
    }).catchError((error) {
      print('********** removeGeofence error: $error.code');
    });
  }

  void _onClickRemoveGeofences() {
    bg.BackgroundGeolocation.removeGeofences().then((bool success) {
      print('*********** removeGeofences: $success');
    }).catchError((error) {
      print('*********** removeGeofences error: $error.code');
    });
  }
  @override
  Widget build(BuildContext context) {
    return new Column(
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
    );
  }
}