import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:unicorndial/unicorndial.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'settings_view.dart';
import 'dialog.dart' as util;

class MainMenuButton extends StatelessWidget {
  BuildContext _context;

  void _onClickMenu() async {
    bg.BackgroundGeolocation.playSound(util.Dialog.getSoundId("OPEN"));
  }

  void _onClickSettings() {
    bg.BackgroundGeolocation.playSound(util.Dialog.getSoundId("OPEN"));
    Navigator.of(_context).push(MaterialPageRoute<Null>(fullscreenDialog: true, builder: (BuildContext context) {
      return SettingsView();
    }));
  }

  void _onClickResetOdometer() {
    bg.BackgroundGeolocation.setOdometer(0.0);
  }

  /// TODO wrap emailLog and/or fetching email from SharedPreferences into a static Util class.
  /// There's a similar function in SettingsView.
  void _onClickEmailLog() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString("email");
    if (email == null) {
      email = "";
    }
    email = await util.Dialog.prompt(_context, title: "Email log", labelText: 'Email', value: email);
    if (email.length > 0) {
      prefs.setString("email", email);
      bg.BackgroundGeolocation.emailLog(email).then((bool success) {
        print('[emailLog] success');
      }).catchError((error) {
        util.Dialog.alert(_context, 'Email log Error', error.toString());
      });
    }
  }

  void _onClickSync() async {
    int count = await bg.BackgroundGeolocation.count;
    if (count == 0) {
      util.Dialog.alert(_context, "Sync", "Database is empty");
      return;
    }

    util.Dialog.confirm(_context, "Confirm", "Upload $count locations?", (bool confirm) {
      if (!confirm) { return; }
      // TODO show spinner.
      bg.BackgroundGeolocation.sync().then((List records) {
        // TODO hide spinner.
        bg.BackgroundGeolocation.playSound(util.Dialog.getSoundId("MESSAGE_SENT"));
      });
    });
  }

  void _onClickDestroyLocations() async {
    int count = await bg.BackgroundGeolocation.count;
    util.Dialog.confirm(_context, "Confirm", "Destroy $count locations?", (bool confirm) {
      // TODO show spinner
      if (!confirm) { return; }
      bg.BackgroundGeolocation.destroyLocations().then((bool success) {
        // TODO hide spinner.
        bg.BackgroundGeolocation.playSound(util.Dialog.getSoundId((success) ? "MESSAGE_SENT" : "ERROR"));
      });
    });
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
              onPressed: _onClickDestroyLocations)
      ),
      UnicornButton(
          hasLabel: true,
          labelText: "Email log",
          currentButton: FloatingActionButton(
              heroTag: "email log",
              backgroundColor: bgColor,
              foregroundColor: Colors.black,
              mini: true,
              child: Icon(Icons.email),
              onPressed: _onClickEmailLog)
      ),
      UnicornButton(
          hasLabel: true,
          labelText: "Upload locations",
          currentButton: FloatingActionButton(
              heroTag: "upload",
              backgroundColor: bgColor,
              foregroundColor: Colors.black,
              mini: true,
              child: Icon(Icons.cloud_upload),
              onPressed: _onClickSync)
      ),
      UnicornButton(
          hasLabel: true,
          labelText: "Reset odometer",
          currentButton: FloatingActionButton(
              heroTag: "reset odometer",
              backgroundColor: bgColor,
              foregroundColor: Colors.black,
              mini: true,
              child: Icon(Icons.av_timer),
              onPressed: _onClickResetOdometer)
      ),
      UnicornButton(
          hasLabel: true,
          labelText: "Settings",
          currentButton: FloatingActionButton(
              heroTag: "settings",
              backgroundColor: bgColor,
              foregroundColor: Colors.black,
              mini: true,
              child: Icon(Icons.settings),
              onPressed: _onClickSettings)
      )
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