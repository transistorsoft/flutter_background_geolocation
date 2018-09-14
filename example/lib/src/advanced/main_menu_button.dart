import 'package:flutter/material.dart';

import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:unicorndial/unicorndial.dart';

import 'settings_view.dart';
import '../app.dart';

class MainMenuButton extends StatelessWidget {

  void _onClickResetOdometer() {
    bg.BackgroundGeolocation.setOdometer(0.0);
  }

  void _onClickEmailLog() {
    bg.BackgroundGeolocation.emailLog('christocracy@gmail.com');
  }

  void _onClickSync() {
    bg.BackgroundGeolocation.sync();
  }

  void _onClickDestroyLocations() {
    bg.BackgroundGeolocation.destroyLocations();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 50.0),
      child: UnicornDialer(
          hasBackground: false,
          parentButtonBackground: Colors.black,
          orientation: UnicornOrientation.VERTICAL,
          parentButton: Icon(Icons.add),
          childButtons: _buildMenuItems(context)),
    );
  }

  List<UnicornButton> _buildMenuItems(BuildContext context) {
    Color bgColor = Theme.of(context).bottomAppBarColor;

    // Home-button click handler with context.
    Function onClickSettings = () {
      Navigator.of(context).push(MaterialPageRoute<Null>(fullscreenDialog: true, builder: (BuildContext context) {
        return SettingsView();
      }));
    };

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
          labelText: "Reset odometerrr",
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
              onPressed: onClickSettings)
      )
    ];
  }
}