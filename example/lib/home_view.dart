part of flt_background_geolocation_example;

class HomeView extends StatefulWidget {
  @override
  State createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  bool _isMoving;
  bool _enabled;
  double _odometer;

  @override
  void initState() {
    super.initState();

    bg.BackgroundGeolocation.onMotionChange((bg.Location location) {
      print("[motionchange] - " + location.toString());
      _isMoving = location.isMoving;
    });

    bg.BackgroundGeolocation.onLocation((bg.Location location) {
      print("[location] - " + location.toString());
      if (!location.sample) {
        _odometer = location.odometer;
      }
    });

    bg.BackgroundGeolocation.onActivityChange((bg.ActivityChangeEvent event) {
      print('$event');
    });

    bg.BackgroundGeolocation.onGeofence((bg.GeofenceEvent event) {
      print('$event');
    });

    bg.BackgroundGeolocation.onGeofencesChange((bg.GeofencesChangeEvent event) {
      print('$event');
    });

    bg.BackgroundGeolocation.onHeartbeat((bg.HeartbeatEvent event) {
      print('$event');
    });

    bg.BackgroundGeolocation.onProviderChange((bg.ProviderChangeEvent event) {
      print('$event');
    });

    bg.BackgroundGeolocation.onConnectivityChange((bg.ConnectivityChangeEvent event) {
      print('$event');
    });

    bg.BackgroundGeolocation.onEnabledChange((bool enabled) {
      print('[enabledchange] - ' + enabled.toString());
      _enabled = enabled;
    });

    bg.BackgroundGeolocation.onPowerSaveChange((bool enabled) {
      print('[powersavechange] - ' + enabled.toString());
    });

    bg.Config config = new bg.Config(
        reset: true,
        distanceFilter: 50.0,
        activityType: bg.Config.ACTIVITY_TYPE_OTHER,
        stopTimeout: 1,
        stopOnTerminate: false,
        startOnBoot: true,
        foregroundService: true,
        notificationChannelName: 'Background Geolocation',
        notificationTitle: 'Flutter Background Geolocation',
        debug: true,
        logLevel: bg.Config.LOG_LEVEL_VERBOSE
    );

    bg.BackgroundGeolocation.ready(config).then((bg.State state) {
      print("[ready] success -" + state.toString());

      setState(() {
        _enabled = state.enabled;
        _isMoving = state.isMoving;
      });
    });
  }

  void _onClickEnable(bool enabled) {
    print("- onClickEnable: " + enabled.toString());
    setState(() {
      _enabled = enabled;
    });
    if (enabled) {
      bg.BackgroundGeolocation.start();
    } else {
      bg.BackgroundGeolocation.stop();
    }
  }
  void _onClickMenu() {
    print("- onClickMenu");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsView())
    );
  }

  void _onClickChangePace() {
    print("- onClickChangePace -> !$_isMoving");

    setState(() {
      _isMoving = !_isMoving;
    });

    bg.BackgroundGeolocation.changePace(_isMoving).then((bool isMoving) {
      print('[changePace] success $isMoving');
    }).catchError((e) {
      print('[changePace] ERROR: ' + e.code.toString());
    });
  }

  void _onClickGetCurrentPosition() {

    bg.BackgroundGeolocation.getCurrentPosition(
        persist: true,
        desiredAccuracy: 0,
        timeout: 30000,
        samples: 3
    ).then((bg.Location location) {
      print('[getCurrentPosition] - ' + location.toString());
    }).catchError((error) {
      print('[getCurrentPosition] ERROR: ' + error.code);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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

      body: MapView(),
      bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).bottomAppBarColor,
          child: Container(
            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
            child: new Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.gps_fixed),
                    onPressed: _onClickGetCurrentPosition,
                  ),
                  MaterialButton(
                      minWidth: 50.0,
                      child: new Icon((_isMoving) ? Icons.pause : Icons.play_arrow, color: Colors.white),
                      color: (_isMoving) ? Colors.red : Colors.green,
                      onPressed: _onClickChangePace
                  )
                ]
            )
          )
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _onClickMenu,
        tooltip: 'Menu',
        child: new Icon(Icons.add),
      ),
    );
  }
}

/**
 * GoogleMap View
 */
class MapView extends StatefulWidget {
  @override
  State createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  static const double DEFAULT_ZOOM = 18.0;

  GoogleMapController _mapController;


  @override
  Widget build(BuildContext context) {
    bg.BackgroundGeolocation.onEnabledChange((enabled) {
      if (!enabled) { _removeMarkers(); }
    });

    bg.BackgroundGeolocation.onMotionChange((bg.Location location) {
      _setCenter(location, DEFAULT_ZOOM);
    });

    bg.BackgroundGeolocation.onLocation((bg.Location location) {
      if (!location.sample) {
        _addMarker(location);
      }
      _setCenter(location, DEFAULT_ZOOM);
    });

    return GoogleMap(
      onMapCreated: _onMapCreated,
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() { _mapController = controller; });
  }

  void _addMarker(bg.Location location) {
    _mapController.addMarker(MarkerOptions(
      position: LatLng(location.coords.latitude, location.coords.longitude
      ),
    ));
  }

  void _removeMarkers() {
    _mapController.markers.forEach((Marker marker) => _mapController.removeMarker(marker));
  }

  void _setCenter(bg.Location location, double zoom) {
    CameraPosition position;
    position = new CameraPosition(
        target: LatLng(location.coords.latitude, location.coords.longitude),
        zoom: zoom
    );

    _mapController.updateMapOptions(GoogleMapOptions(
        cameraPosition: position
    ));
  }
}


class SettingsView extends StatefulWidget {
  @override
  State createState() => SettingsViewState();
}

class SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Text('SettingsView')
    );
  }
}