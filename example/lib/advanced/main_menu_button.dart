import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';

import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'actions.dart' as actions;
import 'settings_view.dart';
import 'package:flutter_background_geolocation_example/advanced/util/dialog.dart'
    as util;

class MainMenuButton extends StatefulWidget {
  const MainMenuButton({super.key});

  @override
  State createState() => MainMenuButtonState();
}

class MainMenuButtonState extends State<MainMenuButton> {
  late BuildContext _context;
  bg.Subscription? _watchPositionSubscription;

  void _onClickSettings() async {
    bg.BackgroundGeolocation.playSound(util.Dialog.getSoundId("OPEN"));
    Navigator.of(_context).push(MaterialPageRoute<Null>(
        fullscreenDialog: true,
        builder: (BuildContext context) {
          return SettingsView();
        }));
  }

  void _onClickResetOdometer() async {
    try {
      await bg.BackgroundGeolocation.setOdometer(0.0);
      await bg.BackgroundGeolocation.getCurrentPosition(
        persist: false,
        samples: 1,
        maximumAge: 30000
      );
    } catch (error) {
      print('[resetOdometer] ERROR: $error');
    }
  }

  void _onClickEmailLog() async {
    actions.Actions.emailLog(_context);
  }

  void _onClickSync() async {
    actions.Actions.sync(_context);
  }

  void _onClickDestroyLocations() async {
    actions.Actions.destroyLocations(_context);
  }

  void _onClickWatchPosition() async {
    if (_watchPositionSubscription != null) {
      await _watchPositionSubscription!.remove();
      setState(() {
        _watchPositionSubscription = null;
      });
      print('[watchPosition] OFF');
      return;
    }
    _watchPositionSubscription = await bg.BackgroundGeolocation.watchPosition(
      interval: 1000,
      persist: true,
      desiredAccuracy: 0,
      onLocation: (bg.Location location) {
        print('[watchPosition] - $location');
      },
    );
    setState(() {});
    print('[watchPosition] ON');
  }

  void _onClickRequestPermission() async {
    bg.ProviderChangeEvent providerState = await bg.BackgroundGeolocation.providerState;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Request Permission"),
          content: Text("Current Authorization status: ${providerState.status}"),
          actions: <Widget>[
            TextButton(
              child: Text('WhenInUse'),
              onPressed: () async {
                _requestPermission('WhenInUse');
              },
            ),
            TextButton(
              child: Text('Always'),
              onPressed: () async {
                _requestPermission('Always');
              },
            ),
          ],
        );
      },
    );
  }

  void _requestPermission(String request) async {
    Navigator.of(context).pop();

    await bg.BackgroundGeolocation.setConfig(bg.Config(
        geolocation: bg.GeoConfig(locationAuthorizationRequest: request)));

    // (WO-007) Two-step flow: location first, then motion, each awaited separately —
    // mirrors the native demo apps.  Compare against the one-shot storm by calling
    // bg.BackgroundGeolocation.requestPermission() with no argument instead.
    String locationResult;
    try {
      int status = await bg.BackgroundGeolocation.requestPermission(bg.Permission.location);
      print("[requestPermission] location: $status");
      locationResult = "$status";
    } catch (status) {
      print("[requestPermission] location DENIED: $status");
      locationResult = "denied ($status)";
    }

    String motionResult;
    try {
      int status = await bg.BackgroundGeolocation.requestPermission(bg.Permission.motion);
      print("[requestPermission] motion: $status");
      motionResult = "$status";
    } catch (status) {
      print("[requestPermission] motion DENIED: $status");
      motionResult = (status == bg.ProviderChangeEvent.AUTHORIZATION_STATUS_DENIED_ALWAYS)
          ? "denied always ($status) — only the Settings app can restore it"
          : "denied ($status)";
    }

    util.Dialog.alert(context, "Request Permission",
        "location: $locationResult\nmotion: $motionResult");

    bg.ProviderChangeEvent providerState = await bg.BackgroundGeolocation.providerState;
    if ((providerState.status == bg.ProviderChangeEvent.AUTHORIZATION_STATUS_ALWAYS) && (providerState.accuracyAuthorization == bg.ProviderChangeEvent.ACCURACY_AUTHORIZATION_REDUCED)) {
      // Request full accuracy.
      //int status = await bg.BackgroundGeolocation.requestTemporaryFullAccuracy("Demo Purpose");
      //util.Dialog.alert(context, "Request Full Accuracy", "Accuracy Authorization: ${status}");
    }
  }

  @override
  Widget build(BuildContext context) {
    double buttonBottomPadding = 50.0;
    var mediaQueryData = MediaQuery.of(context);
    if (_isIPhoneX(mediaQueryData)) {
      // fallback for all non iPhone X
      buttonBottomPadding += 30.0;
    }

    _context = context;
    return Container(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, buttonBottomPadding),
      margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
      child: SpeedDial(
          icon: Icons.add,
          activeIcon: Icons.close,
          renderOverlay: false,
          spacing: 10.0,
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          children: _buildMenuItems(context)),
    );
  }

  List<SpeedDialChild> _buildMenuItems(BuildContext context) {
    Color? bgColor = Colors.amberAccent;

    return <SpeedDialChild>[
      SpeedDialChild(
          label: "Settings",
          backgroundColor: bgColor,
          foregroundColor: Colors.black,
          child: Icon(Icons.settings),
          onTap: _onClickSettings),
      SpeedDialChild(
        label: "Email log",
        backgroundColor: bgColor,
        foregroundColor: Colors.black,
        child: Icon(Icons.email),
        onTap: _onClickEmailLog),
      SpeedDialChild(
          label: "Upload locations",
          backgroundColor: bgColor,
          foregroundColor: Colors.black,
          child: Icon(Icons.cloud_upload),
          onTap: _onClickSync),
      SpeedDialChild(
          label: "Reset odometer",
          backgroundColor: bgColor,
          foregroundColor: Colors.black,
          child: Icon(Icons.av_timer),
          onTap: _onClickResetOdometer),
      SpeedDialChild(
          label: "Request Permission",
          backgroundColor: bgColor,
          foregroundColor: Colors.black,
          child: Icon(Icons.lock_open),
          onTap: _onClickRequestPermission),
      SpeedDialChild(
          label: _watchPositionSubscription != null ? "Stop watch position" : "Watch position",
          backgroundColor: _watchPositionSubscription != null ? Colors.red : bgColor,
          foregroundColor: _watchPositionSubscription != null ? Colors.white : Colors.black,
          child: Icon(_watchPositionSubscription != null ? Icons.stop : Icons.navigation),
          onTap: _onClickWatchPosition),
      SpeedDialChild(
          label: "Destroy locations",
          backgroundColor: bgColor,
          foregroundColor: Colors.black,
          child: Icon(Icons.delete),
          onTap: _onClickDestroyLocations)

    ];
  }

  bool _isIPhoneX(MediaQueryData mediaQuery) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      var size = mediaQuery.size;
      if (size.height == 812.0 || size.width == 812.0) {
        return true;
      }
    }
    return false;
  }
}
