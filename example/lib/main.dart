library flt_background_geolocation_example;

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;

part 'home_view.dart';
part 'test_buttons.dart';
part 'constants.dart';

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
        primaryColor: COLOR_GOLD,
        bottomAppBarColor: COLOR_GOLD,
        primaryTextTheme: Theme.of(context).primaryTextTheme.apply(
            bodyColor: Colors.black,
        )
      ),
      home: HomeView()
    );
  }
}

