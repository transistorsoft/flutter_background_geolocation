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
import 'package:url_launcher/url_launcher.dart';

import 'config/ENV.dart';
import 'config/transistor_auth.dart';

import 'hello_world/app.dart';
import 'advanced/app.dart';
import 'package:flutter_background_geolocation_example/advanced/util/dialog.dart' as util;

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

  bg.DeviceInfo _deviceInfo;
  String _orgnameRaw;
  String _orgname;
  String _usernameRaw;
  String _username;
  String _deviceId;

  final _formKey = GlobalKey<FormState>();

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  @override
  void initState() {
    super.initState();
    _orgnameRaw = '';
    _orgname = '';
    _usernameRaw = '';
    _username = '';
    _deviceId = '';
    _initPlatformState();
  }

  void _initPlatformState() async {
    // Rendering Home page, stop everything and remove all listeners.
    bg.BackgroundGeolocation.stop();
    await bg.BackgroundGeolocation.removeListeners();
    TransistorAuth.registerErrorHandler();

    _deviceInfo = await bg.DeviceInfo.getInstance();
    
    // Reset selected app.
    final SharedPreferences prefs = await _prefs;
    prefs.setString("app", "");

    // Set username.
    String username = prefs.getString("username");
    String orgname = prefs.getString("orgname");

    if (_usernameIsValid(username) && (orgname == null)) {
      await prefs.remove('username');
      await prefs.setString('orgname', username);
      orgname = username;
      username = null;
    }

    setState(() {
      _orgname = (orgname != null) ? orgname : '';
      _username = (username != null) ? username : '';
      _deviceId = (username != null) ? "${_deviceInfo.model}-$_username" : _deviceInfo.model;
    });

    if (!_usernameIsValid(username) || !_usernameIsValid(orgname)) {
      _showDialog();
    }
  }

  void _showDialog() {

    _orgnameRaw = _orgname;
    _usernameRaw = _username;

    TextEditingController _usernameController = new TextEditingController(text: _usernameRaw);
    TextEditingController _orgnameController = new TextEditingController(text: _orgnameRaw);

    final re = new RegExp(r"\s+\b|\b\s");

    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          contentPadding: const EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))
          ),
          content: SizedBox(
              height: 200.0,
              child: Form(
                key: _formKey,
                child: Column(
                    children: <Widget>[
                      new Text('Device Registration', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0), textAlign: TextAlign.center),
                      new Text(''),
                      new Text('${_deviceInfo.manufacturer} ${_deviceInfo.model}', style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                      ///
                      /// this consumes too much vertical space on small devices
                      ///
                      ///
                      ///Spacer(),
                      ///new Text('Please provide an Organization and User identifier to register with the demo server:', style: TextStyle()),

                      ///
                      new Row(
                        children: <Widget>[
                          Expanded(
                              child: Column(
                                  children: <Widget>[
                                    new TextFormField(
                                      controller: _orgnameController,
                                      validator: (value) {
                                        if (!_usernameIsValid(value)) {
                                          return 'Invalid organization name.';
                                        } else {
                                          return null;
                                        }
                                      },
                                      onChanged: (String value) {
                                        setState(() {
                                          _orgnameRaw = value;
                                        });
                                      },
                                      autofocus: true,
                                      decoration: new InputDecoration(
                                          labelText: 'Organization name', hintText: 'eg. Company name'),
                                    ),
                                    new TextFormField(
                                      controller: _usernameController,
                                      validator: (value) {
                                        if (!_usernameIsValid(value)) {
                                          return 'Invalid username.';
                                        } else {
                                          return null;
                                        }
                                      },
                                      onChanged: (String value) {
                                        value = value.replaceAll(re, "");
                                        setState(() {
                                          _usernameRaw = value;
                                          _deviceId = "${_deviceInfo.model}-$value";
                                        });
                                      },
                                      autofocus: false,
                                      decoration: new InputDecoration(
                                          labelText: 'Username', hintText: 'eg. Github username or initials'),
                                    ),
                                  ]
                              )
                          ),
                        ],
                      ),
                    ]
                ),
              )

          ),
          actions: <Widget>[
            new FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              }
            ),
            new FlatButton(
                child: const Text('SAVE'),
                onPressed: _onClickSave
            )
          ],
        );
      },
    );
  }

  _onClickSave() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _orgname = _orgnameRaw;
        _username = _usernameRaw;
      });
      final SharedPreferences prefs = await _prefs;
      prefs.setString("orgname", _orgnameRaw);
      prefs.setString("username", _usernameRaw);

      await bg.TransistorAuthorizationToken.destroy(ENV.TRACKER_HOST);
      await bg.TransistorAuthorizationToken.findOrCreate(_orgname, _username, ENV.TRACKER_HOST);
      Navigator.pop(context);
    }
  }

  void _onClickNavigate(String appName) async {
    if (!_usernameIsValid(_username)) {
      _showDialog();
      return;
    }

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

  bool _usernameIsValid(String username) {
    return (username != null) && new RegExp(USERNAME_REGEXP).hasMatch(username) && (username.length > 0);
  }

  void _launchUrl() async {
    String url = '${ENV.TRACKER_HOST}/$_username';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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
                                _buildApplicationButton('Hello World App', onPressed: () { _onClickNavigate("hello_world"); }),
                                _buildApplicationButton('Advanced App', onPressed: () { _onClickNavigate("advanced"); })
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
                                child: Text("${ENV.TRACKER_HOST}/$_orgname", style: TextStyle(fontWeight: FontWeight.bold))
                            ),
                            Container(
                                color: Colors.white,
                                margin: EdgeInsets.all(0.0),
                                child: new ListTile(
                                  leading: const Icon(Icons.account_box),
                                  title: Text("Org: $_orgname"),
                                  subtitle: Text("Device ID: $_deviceId"),
                                  selected: true
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
                  FlatButton(onPressed: () {
                    _showDialog();
                  }, child: Text('Edit'), color: Colors.redAccent, textColor: Colors.white),
                  FlatButton(onPressed: () {
                    _launchUrl();
                  }, child: Text('View Tracking'), color: Colors.blue, textColor: Colors.white),
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
}