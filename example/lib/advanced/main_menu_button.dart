import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:unicorndial/unicorndial.dart';

import 'actions.dart' as actions;
import 'settings_view.dart';
import 'package:flutter_background_geolocation_example/advanced/util/dialog.dart'
    as util;

class MainMenuButton extends StatefulWidget {
  @override
  State createState() => MainMenuButtonState();
}

class MainMenuButtonState extends State<MainMenuButton> {
  BuildContext _context;

  void _onClickMenu() async {}

  void _onClickSettings() {
    bg.BackgroundGeolocation.playSound(util.Dialog.getSoundId("OPEN"));
    Navigator.of(_context).push(MaterialPageRoute<Null>(
        fullscreenDialog: true,
        builder: (BuildContext context) {
          return SettingsView();
        }));
  }

  void _onClickResetOdometer() {
    bg.BackgroundGeolocation.setOdometer(0.0);
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
            FlatButton(
              child: Text('WhenInUse'),
              onPressed: () async {
                _requestPermission('WhenInUse');
              },
            ),
            FlatButton(
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
    await bg.BackgroundGeolocation.setConfig(bg.Config(locationAuthorizationRequest: request));
    int status = await bg.BackgroundGeolocation.requestPermission();
    print("[requestPermission] status: $status");
    util.Dialog.alert(context, "Request Permission", "Authorization status: $status");
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
      child: UnicornDialer(
          onMainButtonPressed: _onClickMenu,
          hasBackground: false,
          parentButtonBackground: Colors.black,
          orientation: UnicornOrientation.VERTICAL,
          parentButton: Icon(Icons.add, color: Colors.black),
          childButtons: _buildMenuItems(context)),
    );
  }

  List<UnicornButton> _buildMenuItems(BuildContext context) {
    Color bgColor = Theme.of(context).bottomAppBarColor;

    return <UnicornButton>[
      UnicornButton(
          hasLabel: true,
          labelText: "Destroy locations",
          currentButton: FloatingActionButton(
              heroTag: "destroy locations",
              backgroundColor: bgColor,
              foregroundColor: Colors.black,
              mini: true,
              child: Icon(Icons.delete),
              onPressed: _onClickDestroyLocations)),
      UnicornButton(
          hasLabel: true,
          labelText: "Email log",
          currentButton: FloatingActionButton(
              heroTag: "email log",
              backgroundColor: bgColor,
              foregroundColor: Colors.black,
              mini: true,
              child: Icon(Icons.email),
              onPressed: _onClickEmailLog)),
      UnicornButton(
          hasLabel: true,
          labelText: "Upload locations",
          currentButton: FloatingActionButton(
              heroTag: "upload",
              backgroundColor: bgColor,
              foregroundColor: Colors.black,
              mini: true,
              child: Icon(Icons.cloud_upload),
              onPressed: _onClickSync)),
      UnicornButton(
          hasLabel: true,
          labelText: "Reset odometer",
          currentButton: FloatingActionButton(
              heroTag: "reset odometer",
              backgroundColor: bgColor,
              foregroundColor: Colors.black,
              mini: true,
              child: Icon(Icons.av_timer),
              onPressed: _onClickResetOdometer)),
      UnicornButton(
        hasLabel: true,
        labelText: "Request Permission",
        currentButton: FloatingActionButton(
            heroTag: "request permission",
            backgroundColor: bgColor,
            foregroundColor: Colors.black,
            mini: true,
            child: Icon(Icons.lock_open),
            onPressed: _onClickRequestPermission)),
      UnicornButton(
          hasLabel: true,
          labelText: "Settings",
          currentButton: FloatingActionButton(
              heroTag: "settings",
              backgroundColor: bgColor,
              foregroundColor: Colors.black,
              mini: true,
              child: Icon(Icons.settings),
              onPressed: _onClickSettings))
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
