///
/// This file receives actions from the test-driver (@see #enableFlutterDriverExtension) and performs the actual API
/// actions upon BackgroundGeolocation.
///
/// In a sense,  the file is like a server receiving test-action requests from the FlutterDriver client in app_test.dart.
///
/// This file actually performs the requested test-action upon the BackgroundGeolocation API and returns String results
/// to the TestDriver for evalution.
///

import 'package:flutter_driver/driver_extension.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;

// Global ref to TestApp.  It's ugly but we're just testing.  This is so the function #testHandler can reference the TestApp.
TestApp? app;

///
/// - Boot the TestApp.
/// - Register #testHandler Function with #registerFlutterDriverExtension
///
void main() async {
  app = TestApp();

  Map<String,dynamic> deviceParams = await bg.Config.deviceParams;
  bg.BackgroundGeolocation.ready(bg.Config(
      reset: true,
      debug: true,
      logLevel: bg.Config.LOG_LEVEL_VERBOSE,
      autoSync: true,
      extras: {"foo": "bar"},
      url: "http://tracker.transistorsoft.com/locations/transistor-flutter-test",
      params: deviceParams
  ));

  // Register #testHanlder Function (@see below) to receive test-actions from app_test.dart
  enableFlutterDriverExtension(handler: testHandler);
  runApp(app as Widget);
}

///
/// This is where the test requests from TestDriver in app_test.dart are received
///
Future<String> testHandler(String? command) async {
    Action action = new Action(command: command!);

    print("FlutterDriverExtension Rx: $command");

    // Setup
    bg.BackgroundGeolocation.removeListeners();
    await bg.BackgroundGeolocation.removeGeofences();
    await bg.BackgroundGeolocation.stop();
    await bg.BackgroundGeolocation.reset(bg.Config(
        debug: true,
        logLevel: bg.Config.LOG_LEVEL_VERBOSE
    ));

    switch(command) {
      case 'getState':
        bg.State state = await bg.BackgroundGeolocation.state;
        action.result = state;
        app?.addAction(action);
        return state.toString();
        break;
      case 'getCurrentPosition':
        bg.Location location = await bg.BackgroundGeolocation.getCurrentPosition(samples: 1);
        action.result = location;
        app?.addAction(action);
        return location.toString();
        break;
      case 'getGeofences':
        bg.Geofence geofence = bg.Geofence(
            identifier: 'test',
            radius: 200.0,
            latitude: 1.0,
            longitude: 1.0,
            notifyOnEntry: true,
            extras: {"foo":"bar"}
        );
        await bg.BackgroundGeolocation.addGeofence(geofence);
        List<bg.Geofence> geofences = await bg.BackgroundGeolocation.geofences;
        List<Map> rs = [];
        geofences.forEach((bg.Geofence geofence) {
          rs.add(geofence.toMap());
        });
        action.result = rs;
        app?.addAction(action);
        return jsonEncode(rs);
        break;
      case 'start':
        bg.State state = await bg.BackgroundGeolocation.start();
        action.result = state;
        app?.addAction(action);
        return state.toString();
        break;
      case 'onLocation':
        Completer completer = new Completer<String>();
        bg.BackgroundGeolocation.onLocation((bg.Location location) {
          action.result = location;
          app?.addAction(action);
          completer.complete(location.toString());
        });
        bg.BackgroundGeolocation.start();
        return completer.future as String;
        break;
      case 'onMotionChange':
        Completer completer = new Completer<String>();
        bg.BackgroundGeolocation.onMotionChange((bg.Location location) {
          action.result = location;
          app?.addAction(action);
          completer.complete(location.toString());
        });
        bg.BackgroundGeolocation.start();
        return completer.future as String;
        break;
      case 'onGeofence':
        Completer completer = new Completer<String>();
        bg.BackgroundGeolocation.onGeofence((bg.GeofenceEvent event) {
          action.result = event;
          app?.addAction(action);
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
      case 'onEnabledChange:true':
        Completer completer = new Completer<String>();
        bg.BackgroundGeolocation.onEnabledChange((bool enabled) {
          action.result = enabled;
          app?.addAction(action);
          completer.complete(enabled.toString());
        });
        await bg.BackgroundGeolocation.start();
        return completer.future as String;
        break;
      case 'onEnabledChange:false':
        Completer completer = new Completer<String>();
        bg.BackgroundGeolocation.onEnabledChange((bool enabled) {
          if (enabled == false) {
            action.result = enabled;
            app?.addAction(action);
            completer.complete(enabled.toString());
          }
        });
        await bg.BackgroundGeolocation.start();
        await bg.BackgroundGeolocation.stop();
        return completer.future as String;
        break;
      case 'onHttp':
        Completer completer = new Completer<String>();

        Map<String,dynamic> deviceParams = await bg.Config.deviceParams;
        // Configure #url & #params
        await bg.BackgroundGeolocation.setConfig(bg.Config(
            autoSync: true,
            extras: {"foo": "bar"},
            url: "http://tracker.transistorsoft.com/locations/transistor-flutter-test",
            params: deviceParams
        ));
        // Clear database.
        await bg.BackgroundGeolocation.destroyLocations();

        bg.BackgroundGeolocation.onHttp((bg.HttpEvent event) {
          action.result = event;
          app?.addAction(action);
          completer.complete(event.toString());
        });
        bg.BackgroundGeolocation.start();
        return completer.future as String;
        break;
      case 'onHttp:404':
        Completer completer = new Completer<String>();

        Map<String,dynamic> deviceParams = await bg.Config.deviceParams;
        // Configure bogus 404 #url & #params
        await bg.BackgroundGeolocation.setConfig(bg.Config(
            autoSync: true,
            extras: {"foo": "bar"},
            url: "https://www.transistorsoft.com/test/error",
            params: deviceParams
        ));
        // Clear database.
        await bg.BackgroundGeolocation.destroyLocations();

        bg.BackgroundGeolocation.onHttp((bg.HttpEvent event) {
          action.result = event;
          app?.addAction(action);
          completer.complete(event.toString());
        });
        bg.BackgroundGeolocation.start();
        return completer.future as String;
        break;
      case 'getCount':
        await bg.BackgroundGeolocation.destroyLocations();
        await bg.BackgroundGeolocation.getCurrentPosition(samples: 1, persist: true);
        int count = await bg.BackgroundGeolocation.count;
        action.result = count;
        app?.addAction(action);
        return count.toString();
        break;
      case 'destroyLocations':
        await bg.BackgroundGeolocation.getCurrentPosition(samples: 1, persist: true);
        bool result = await bg.BackgroundGeolocation.destroyLocations();
        print("destroyLocations: " + result.toString());
        int count = await bg.BackgroundGeolocation.count;
        action.result = count;
        app?.addAction(action);
        return count.toString();
        break;
      default:
        return "404";
    }
}

///
/// class Action
/// We pass test-case results #testHandler to the TestApp via instances of this class.
/// TestApp then renders these instances into its ListView
/// @see TestApp#addAction
///
class Action {
  String command;
  dynamic result;
  Action({required this.command, this.result});
}

///
/// class TestApp
/// Layout a simple test-app to run the actions and render the results.
///
class TestApp extends StatefulWidget {
  late _TestAppState _state;

  @override

  _TestAppState createState() {
    _state = new _TestAppState();
    return _state;
  }

  void addAction(Action action) {
    _state.addAction(action);
  }
}

///
/// class _TestAppState
///
class _TestAppState extends State<TestApp> {
  late List<Action> _actions;

  void addAction(Action action) {
    setState(() {
      _actions.add(action);
    });
  }

  @override
  void initState() {
    _actions = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        theme: Theme.of(context).copyWith(
            //accentColor: Colors.black,
            primaryColor: Colors.black,
            //cursorColor: Colors.white,
            backgroundColor: Colors.black,
            primaryTextTheme: Theme.of(context).primaryTextTheme.apply(
                bodyColor: Colors.white
            )
        ),
        home: Scaffold(
            appBar: AppBar(
                leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[Text('Tests: ' + _actions.length.toString())]
                ),
                title: Text('BG Geo Tester'),
                actions: <Widget>[]
            ),
            body: Container(
              color: Colors.black,
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              child: new ListView.builder(
                  itemCount: _actions.length,
                  itemBuilder: (BuildContext context, int index) {
                    Action action = _actions[index];
                    return InputDecorator(
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0),
                            labelStyle: TextStyle(color: Colors.amberAccent, fontSize: 20.0),
                            labelText: action.command
                        ),
                        child: new Text(action.result.toString(), style: TextStyle(color: Colors.white))
                    );
                  }
              ),
              //Card(child: Text(_command)),
            )
        )
    );
  }
}
