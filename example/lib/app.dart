///
/// NOTE:  There's nothing particularly interesting in this class for BackgroundGeolocation.
/// This is just a bootstrap app for selecting app to run (Hello World App, Advanced App).
///
/// Go look at the source for those apps instead.
///

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;

import 'hello_world/app.dart';
import 'advanced/app.dart';
import 'package:flutter_background_geolocation_example/advanced/util/dialog.dart' as util;

const TRACKER_HOST = 'http://tracker.transistorsoft.com/locations/';

class HomeApp extends StatefulWidget {
  @override
  _HomeAppState createState() => new _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
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
        home: new _HomeView()
    );
  }
}

class _HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => new _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  static const USERNAME_REGEXP = r"^[a-zA-Z0-9_-]*$";

  String _usernameRaw;
  String _username;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  @override
  void initState() {
    super.initState();
    _usernameRaw = '';
    _username = '';
    _initPlatformState();
  }

  void _initPlatformState() async {
    // Reset selected app.
    final SharedPreferences prefs = await _prefs;
    prefs.setString("app", "");

    // Set username.
    String username = prefs.getString("username");
    if (_usernameIsValid(username)) {
      setState(() {
        _username = username;
      });
    }
  }

  void _showDialog() {
    TextEditingController controller = new TextEditingController(text: _username);
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: SizedBox(
              height: 200.0,
              child: Column(
                  children: <Widget>[
                    new Text('Please enter a unique identifier so that BackgroundGeolocation can post locations to the demo server:'),
                    new Text('tracker.transistorsoft.com'),
                    new Row(
                      children: <Widget>[
                        Expanded(
                          child: new TextField(
                            controller: controller,
                            onChanged: (String value) {
                              setState(() {
                                _usernameRaw = value;
                              });
                            },
                            autofocus: true,
                            decoration: new InputDecoration(
                              labelText: 'Username', hintText: 'eg. Github username'),
                          ),
                        )
                      ],
                    ),
                  ]
              ),
          ),
          actions: <Widget>[
            new RaisedButton(
                child: const Text('Save'),
                onPressed: _onSelectUsername
            )
          ],
        );
      },
    );
  }

  _onSelectUsername() async {

    if (_usernameIsValid(_usernameRaw)) {
      setState(() {
        _username = _usernameRaw;
      });
      final SharedPreferences prefs = await _prefs;
      prefs.setString("username", _username);

      Navigator.pop(context);
    }
  }

  bool _usernameIsValid(String username) {
    return (username != null) && new RegExp(USERNAME_REGEXP).hasMatch(username) && (username.length > 0);
  }

  @override
  Widget build (BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Background Geolocation'),
            backgroundColor: Colors.amberAccent,
            brightness: Brightness.light,
        ),
        body: Container(
            color: Colors.black87,
            padding: EdgeInsets.only(top: 20.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Center(
                    child: Text("Example Applications", style: TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                      child: Container(
                          padding: EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                _buildApplicationButton('Hello World App', onPressed: () { navigate("hello_world"); }),
                                _buildApplicationButton('Advanced App', onPressed: () { navigate("advanced"); })
                              ]
                          )
                      )
                  ),
                  Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(5.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.all(10.0),
                                child: Text("These apps will post locations to Transistor Software's demo server.  You can view your tracking in the browser by visiting:")
                            ),
                            Center(
                                child: Text("tracker.transistorsoft.com/$_username", style: TextStyle(fontWeight: FontWeight.bold))
                            ),
                            Container(
                                color: Colors.white,
                                margin: EdgeInsets.only(top: 10.0, left: 10.0),
                                child: new ListTile(
                                  leading: const Icon(Icons.account_box),
                                  title: const Text('Username'),
                                  subtitle: Text("$_username")
                                )
                            )
                          ]
                      )
                  )
                ]
            )
        ),
        bottomNavigationBar: BottomAppBar(
            color: Colors.white,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  RaisedButton(onPressed: () {
                    _showDialog();
                  }, child: Text('Edit Username'), color: Colors.redAccent, textColor: Colors.white),
                  RaisedButton(onPressed: () {}, child: Text('View Tracking'), color: Colors.blue, textColor: Colors.white),
                ]
            )
        )
    );
  }

  MaterialButton _buildApplicationButton(String text, {onPressed: Function}) {
    return MaterialButton(
        onPressed: onPressed,
        child: Text(text, style: TextStyle(fontSize: 18.0)),
        color: Colors.amber,
        height: 50.0);
  }

  void navigate(String appName) async {
    if (!_usernameIsValid(_username)) {
      _showDialog();
      return;
    }
    // Apply tracker url with username & device params for recognition by tracker server.
    Map<String, dynamic> deviceParams = await bg.Config.deviceParams;
    bg.BackgroundGeolocation.setConfig(bg.Config(
      url: TRACKER_HOST + _username,
      params: deviceParams
    ));

    final SharedPreferences prefs = await _prefs;
    prefs.setString("app", appName);

    Widget app;
    switch(appName) {
      case HelloWorldApp.NAME:
        app = new HelloWorldApp();
        break;
      case AdvancedApp.NAME:
        app = new AdvancedApp();
        break;
      default:
        return;
        break;
    }
    bg.BackgroundGeolocation.playSound(util.Dialog.getSoundId("OPEN"));
    runApp(app);
  }
}