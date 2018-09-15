import 'package:flutter/material.dart';

import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:unicorndial/unicorndial.dart';

import 'settings_view.dart';
import 'dialog.dart' as util;

class MainMenuButton extends StatelessWidget {
  BuildContext _context;

  void _onClickMenu() {
    bg.BackgroundGeolocation.playSound(util.Dialog.getSoundId("OPEN"));
  }

  void _onClickSettings() {
    Navigator.of(_context).push(MaterialPageRoute<Null>(fullscreenDialog: true, builder: (BuildContext context) {
      bg.BackgroundGeolocation.playSound(util.Dialog.getSoundId("OPEN"));
      return SettingsView();
    }));
  }

  void _onClickResetOdometer() {
    bg.BackgroundGeolocation.setOdometer(0.0);
  }

  void _onClickEmailLog() {
    bg.BackgroundGeolocation.emailLog('christocracy@gmail.com');
  }

  void _onClickSync() async {
    int count = await bg.BackgroundGeolocation.getCount();
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
    int count = await bg.BackgroundGeolocation.getCount();
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
    _context = context;
    return Container(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 50.0),
      child: UnicornDialer(
          onMainButtonPressed: _onClickMenu,
          hasBackground: false,
          parentButtonBackground: Colors.black,
          orientation: UnicornOrientation.VERTICAL,
          parentButton: Icon(Icons.add),
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
}