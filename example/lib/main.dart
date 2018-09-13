library flt_background_geolocation_example;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;

part 'map_view.dart';
part 'test_buttons.dart';
part 'home_view.dart';
part 'settings_view.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _enabled = false;
  bool _isMoving = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {



    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: Theme.of(context).copyWith(
        accentColor: Colors.black,
        primaryColor: Color.fromRGBO(254, 221, 30, 1.0),
        bottomAppBarColor: Color.fromRGBO(254, 221, 30, 1.0),
        primaryTextTheme: Theme.of(context).primaryTextTheme.apply(
            bodyColor: Colors.black,
        )
      ),
      home: HomeView()
    );
  }
}

