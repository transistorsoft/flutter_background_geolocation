import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:background_fetch/background_fetch.dart';
import 'package:http/http.dart' as http;

import '../app.dart';
import '../config/ENV.dart';
import 'map_view.dart';
import 'event_list.dart';
import './util/dialog.dart' as util;
import './util/test.dart';

import 'shared_events.dart';

// For pretty-printing location JSON
JsonEncoder encoder = new JsonEncoder.withIndent("     ");

/// The main home-screen of the AdvancedApp.  Builds the Scaffold of the App.
///
class HomeView extends StatefulWidget {
  @override
  State createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> with TickerProviderStateMixin<HomeView>, WidgetsBindingObserver {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  TabController _tabController;

  bool _isMoving;
  bool _enabled;
  String _motionActivity;
  String _odometer;

  DateTime _lastRequestedTemporaryFullAccuracy;

  /// My private test mode.  IGNORE.
  int _testModeClicks;
  Timer _testModeTimer;

  List<Event> events = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _isMoving = false;
    _enabled = false;
    _motionActivity = 'UNKNOWN';
    _odometer = '0';
    _testModeClicks = 0;

    _tabController = TabController(
        length: 2,
        initialIndex: 0,
        vsync: this
    );
    _tabController.addListener(_handleTabChange);

    initPlatformState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("[home_view didChangeAppLifecycleState] : $state");
    if (state == AppLifecycleState.paused) {

    } else if (state == AppLifecycleState.resumed) {
      if (!_enabled) return;

      DateTime now = DateTime.now();
      if (_lastRequestedTemporaryFullAccuracy != null) {
        Duration dt = _lastRequestedTemporaryFullAccuracy.difference(now);
        if (dt.inSeconds < 10) return;
      }
      _lastRequestedTemporaryFullAccuracy = now;
      bg.BackgroundGeolocation.requestTemporaryFullAccuracy("DemoPurpose");

    }
  }

  void initPlatformState() async {
    SharedPreferences prefs = await _prefs;
    String orgname = prefs.getString("orgname");
    String username = prefs.getString("username");

    // Sanity check orgname & username:  if invalid, go back to HomeApp to re-register device.
    if (orgname == null || username == null) {
      return runApp(HomeApp());
    }

    _configureBackgroundGeolocation(orgname, username);
    _configureBackgroundFetch();
  }

  void _configureBackgroundGeolocation(orgname, username) async {
    // 1.  Listen to events (See docs for all 13 available events).
    bg.BackgroundGeolocation.onLocation(_onLocation, _onLocationError);
    bg.BackgroundGeolocation.onMotionChange(_onMotionChange);
    bg.BackgroundGeolocation.onActivityChange(_onActivityChange);
    bg.BackgroundGeolocation.onProviderChange(_onProviderChange);
    bg.BackgroundGeolocation.onHttp(_onHttp);
    bg.BackgroundGeolocation.onConnectivityChange(_onConnectivityChange);
    bg.BackgroundGeolocation.onHeartbeat(_onHeartbeat);
    bg.BackgroundGeolocation.onGeofence(_onGeofence);
    bg.BackgroundGeolocation.onSchedule(_onSchedule);
    bg.BackgroundGeolocation.onPowerSaveChange(_onPowerSaveChange);
    bg.BackgroundGeolocation.onEnabledChange(_onEnabledChange);
    bg.BackgroundGeolocation.onNotificationAction(_onNotificationAction);

    bg.TransistorAuthorizationToken token = await bg.TransistorAuthorizationToken.findOrCreate(orgname, username, ENV.TRACKER_HOST);

    // 2.  Configure the plugin
    bg.BackgroundGeolocation.ready(bg.Config(
        reset: false,  // <-- lets the Settings screen drive the config rather than re-applying each boot.
        // Convenience option to automatically configure the SDK to post to Transistor Demo server.
        transistorAuthorizationToken: token,
        // Logging & Debug
        debug: true,
        logLevel: bg.Config.LOG_LEVEL_VERBOSE,
        // Geolocation options
        desiredAccuracy: bg.Config.DESIRED_ACCURACY_NAVIGATION,
        distanceFilter: 10.0,
        // Activity recognition options
        stopTimeout: 5,
        // HTTP & Persistence
        autoSync: true,
        // Application options
        stopOnTerminate: false,
        locationAuthorizationRequest: 'Always',
        startOnBoot: true,
        enableHeadless: true,
        heartbeatInterval: 60
    )).then((bg.State state) async {
      print('[ready] ${state.toMap()}');

      if (state.schedule.isNotEmpty) {
        bg.BackgroundGeolocation.startSchedule();
      }

      setState(() {
        _enabled = state.enabled;
        _isMoving = state.isMoving;
      });
    }).catchError((error) {
      print('[ready] ERROR: $error');
    });

    // Fetch currently selected tab.
    SharedPreferences prefs = await _prefs;
    int tabIndex = prefs.getInt("tabIndex");

    // Which tab to view?  MapView || EventList.   Must wait until after build before switching tab or bad things happen.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (tabIndex != null) {
        _tabController.animateTo(tabIndex);
      }
    });
  }

  // Configure BackgroundFetch (not required by BackgroundGeolocation).
  void _configureBackgroundFetch() async {
    BackgroundFetch.configure(BackgroundFetchConfig(
        minimumFetchInterval: 15,
        startOnBoot: true,
        stopOnTerminate: false,
        enableHeadless: true,
        requiresStorageNotLow: false,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresDeviceIdle: false,
        requiredNetworkType: NetworkType.NONE
    ), (String taskId) async {
      print("[BackgroundFetch] received event $taskId");

      SharedPreferences prefs = await SharedPreferences.getInstance();
      int count = 0;
      if (prefs.get("fetch-count") != null) {
        count = prefs.getInt("fetch-count");
      }
      prefs.setInt("fetch-count", ++count);
      print('[BackgroundFetch] count: $count');

      if (taskId == 'flutter_background_fetch') {
        // Test scheduling a custom-task in fetch event.
        BackgroundFetch.scheduleTask(TaskConfig(
            taskId: "com.transistorsoft.customtask",
            delay: 5000,
            periodic: false,
            forceAlarmManager: true,
            stopOnTerminate: false,
            enableHeadless: true
        ));
      }
      BackgroundFetch.finish(taskId);
    });

  }

  void _onClickEnable(enabled) async {
    bg.BackgroundGeolocation.playSound(util.Dialog.getSoundId("BUTTON_CLICK"));
    if (enabled) {
      dynamic callback = (bg.State state) async {
        print('[start] success: $state');
        setState(() {
          _enabled = state.enabled;
          _isMoving = state.isMoving;
        });
      };
      bg.State state = await bg.BackgroundGeolocation.state;
      if (state.trackingMode == 1) {
        bg.BackgroundGeolocation.start().then(callback);
      } else {
        bg.BackgroundGeolocation.startGeofences().then(callback);
      }
    } else {
      dynamic callback = (bg.State state) {
        print('[stop] success: $state');
        setState(() {
          _enabled = state.enabled;
          _isMoving = state.isMoving;
        });
      };
      bg.BackgroundGeolocation.stop().then(callback);
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

    if (!_isMoving) {
    }
  }

  // Manually fetch the current position.
  void _onClickGetCurrentPosition() async {
    bg.BackgroundGeolocation.playSound(util.Dialog.getSoundId("BUTTON_CLICK"));

    bg.BackgroundGeolocation.getCurrentPosition(
        //persist: true,       // <-- do not persist this location
        desiredAccuracy: 40, // <-- desire an accuracy of 40 meters or less
        maximumAge: 10000,   // <-- Up to 10s old is fine.
        timeout: 30,         // <-- wait 30s before giving up.
        samples: 3,           // <-- sample just 1 location
        extras: {"getCurrentPosition": true}
    ).then((bg.Location location) {
      print('[getCurrentPosition] - $location');
    }).catchError((error) {
      print('[getCurrentPosition] ERROR: $error');
    });
  }

  // Go back to HomeApp
  void _onClickHome() {
    bg.BackgroundGeolocation.playSound(util.Dialog.getSoundId("CLOSE"));
    bg.BackgroundGeolocation.stop();
    bg.BackgroundGeolocation.removeListeners();
    runApp(HomeApp());
  }

  ////
  // Event handlers
  //

  void _onLocation(bg.Location location) {
    print('[${bg.Event.LOCATION}] - $location');

    setState(() {
      events.insert(0, Event(bg.Event.LOCATION, location, location.toString(compact: true)));
      _odometer = (location.odometer / 1000.0).toStringAsFixed(1);
    });
  }

  void _onLocationError(bg.LocationError error) {
    print('[${bg.Event.LOCATION}] ERROR - $error');
    setState(() {
      events.insert(0, Event(bg.Event.LOCATION + " error", error, error.toString()));
    });
  }

  void _onMotionChange(bg.Location location) {
    print('[${bg.Event.MOTIONCHANGE}] - $location');
    setState(() {
      events.insert(0, Event(bg.Event.MOTIONCHANGE, location, location.toString(compact:true)));
      _isMoving = location.isMoving;
    });
  }

  void _onActivityChange(bg.ActivityChangeEvent event) {
    print('[${bg.Event.ACTIVITYCHANGE}] - $event');
    setState(() {
      events.insert(0, Event(bg.Event.ACTIVITYCHANGE, event, event.toString()));
      _motionActivity = event.activity;
    });
  }

  void _onProviderChange(bg.ProviderChangeEvent event) async {
    print('[${bg.Event.PROVIDERCHANGE}] - $event');
    if (event.accuracyAuthorization == bg.ProviderChangeEvent.ACCURACY_AUTHORIZATION_REDUCED) {
      // Supply "Purpose" key from Info.plist as 1st argument.
      bg.BackgroundGeolocation.requestTemporaryFullAccuracy("DemoPurpose").then((int accuracyAuthorization) {
        if (accuracyAuthorization == bg.ProviderChangeEvent.ACCURACY_AUTHORIZATION_FULL) {
          print("[requestTemporaryFullAccuracy] GRANTED:  $accuracyAuthorization");
        } else {
          print("[requestTemporaryFullAccuracy] DENIED:  $accuracyAuthorization");
        }
      }).catchError((error) {
        print("[requestTemporaryFullAccuracy] FAILED TO SHOW DIALOG: $error");
      });
    }
    setState(() {
      events.insert(0, Event(bg.Event.PROVIDERCHANGE, event, event.toString()));
    });
  }

  void _onHttp(bg.HttpEvent event) async {
    print('[${bg.Event.HTTP}] - $event');

    setState(() {
      events.insert(0, Event(bg.Event.HTTP, event, event.toString()));
    });
  }

  void _onConnectivityChange(bg.ConnectivityChangeEvent event) {
    print('[${bg.Event.CONNECTIVITYCHANGE}] - $event');
    setState(() {
      events.insert(0, Event(bg.Event.CONNECTIVITYCHANGE, event, event.toString()));
    });
  }

  void _onHeartbeat(bg.HeartbeatEvent event) {
    print('[${bg.Event.HEARTBEAT}] - $event');
    setState(() {
      events.insert(0, Event(bg.Event.HEARTBEAT, event, event.toString()));
    });
  }

  void _onGeofence(bg.GeofenceEvent event) async {
    print('[${bg.Event.GEOFENCE}] - $event');

    bg.BackgroundGeolocation.startBackgroundTask().then((int taskId) async {
      // Execute an HTTP request to test an async operation completes.
      String url = "${ENV.TRACKER_HOST}/api/devices";
      bg.State state = await bg.BackgroundGeolocation.state;
      http.read(url, headers: {
        "Authorization": "Bearer ${state.authorization.accessToken}"
      }).then((String result) {
        print("[http test] success: $result");
        bg.BackgroundGeolocation.playSound(util.Dialog.getSoundId("TEST_MODE_CLICK"));
        bg.BackgroundGeolocation.stopBackgroundTask(taskId);
      }).catchError((dynamic error) {
        print("[http test] failed: $error");
        bg.BackgroundGeolocation.stopBackgroundTask(taskId);
      });
    });

    setState(() {
      events.insert(0, Event(bg.Event.GEOFENCE, event, event.toString(compact: false)));
    });
  }

  void _onSchedule(bg.State state) {
    print('[${bg.Event.SCHEDULE}] - $state');
    setState(() {
      events.insert(0, Event(bg.Event.SCHEDULE, state, "enabled: ${state.enabled}"));
    });
  }

  void _onEnabledChange(bool enabled) {
    print('[${bg.Event.ENABLEDCHANGE}] - $enabled');
    setState(() {
      _enabled = enabled;
      events.clear();
      events.insert(0, Event(bg.Event.ENABLEDCHANGE, enabled, '[EnabledChangeEvent enabled: $enabled]'));
    });
  }

  void _onNotificationAction(String action) {
    print('[onNotificationAction] $action');
    switch(action) {
      case 'notificationButtonFoo':
        bg.BackgroundGeolocation.changePace(false);
        break;
      case 'notificationButtonBar':
        break;
    }
  }

  void _onPowerSaveChange(bool enabled) {
    print('[${bg.Event.POWERSAVECHANGE}] - $enabled');
    setState(() {
      events.insert(0, Event(bg.Event.POWERSAVECHANGE, enabled, 'Power-saving enabled: $enabled'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('BG Geo'),
          centerTitle: true,
          leading: IconButton(onPressed: _onClickHome, icon: Icon(Icons.home, color: Colors.black)),
          backgroundColor: Theme.of(context).bottomAppBarColor,
          brightness: Brightness.light,
          actions: <Widget>[
            Switch(value: _enabled, onChanged: _onClickEnable
            ),
          ],
          bottom: TabBar(
              controller: _tabController,
              indicatorColor: Colors.red,
              tabs: [
                Tab(icon: Icon(Icons.map)),
                Tab(icon: Icon(Icons.list))
              ]
          )
      ),
      //body: body,
      body: SharedEvents(
          events: events,
          child: TabBarView(
              controller: _tabController,
              children: [
                MapView(),
                EventList()
              ],
              physics: new NeverScrollableScrollPhysics()
          )
      ),
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
                    FlatButton(
                        child: Text('$_motionActivity · $_odometer km'),
                        onPressed: _onClickTestMode,
                    ),
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

  /// My private field-test setup.
  /// @private IGNORE.
  void _onClickTestMode() {
    _testModeClicks++;

    bg.BackgroundGeolocation.playSound(util.Dialog.getSoundId("TEST_MODE_CLICK"));
    if (_testModeClicks == 10) {
      bg.BackgroundGeolocation.playSound(util.Dialog.getSoundId("TEST_MODE_SUCCESS"));
      Test.applyTestConfig();
    }
    if (_testModeTimer != null) {
      _testModeTimer.cancel();
    }
    _testModeTimer = new Timer(Duration(seconds: 2), () {
      _testModeClicks = 0;
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() async {
    if (!_tabController.indexIsChanging) { return; }
    final SharedPreferences prefs = await _prefs;
    prefs.setInt("tabIndex", _tabController.index);
  }
}
