import 'package:flutter/widgets.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

import 'package:flutter_background_geolocation_example/advanced/util/dialog.dart'
    as util;

class Actions {
  static const String RESET_ODOMETER = "resetOdometer";
  static const String DESTROY_LOCATIONS = "destroyLocations";
  static const String SYNC = "sync";
  static const String EMAIL_LOG = "emailLog";
  static const String DESTROY_LOG = "destroyLog";
  static const String REMOVE_GEOFENCES = "removeGeofences";

  static void sync(BuildContext context) async {
    int count = await bg.BackgroundGeolocation.count;
    if (count == 0) {
      util.Dialog.alert(context, "Sync", "Database is empty");
      return;
    }

    util.Dialog.confirm(context, "Confirm", "Upload $count locations?",
        (bool confirm) {
      if (!confirm) {
        return;
      }
      // TODO show spinner.
      bg.BackgroundGeolocation.sync().then((List records) {
        // TODO hide spinner.
        print('[sync] success');
        bg.BackgroundGeolocation.playSound(
            util.Dialog.getSoundId("MESSAGE_SENT"));
      }).catchError((dynamic error) {
        util.Dialog.alert(context, "Sync", error.toString());
        print('[sync] ERROR: $error');
      });
    });
  }

  static void destroyLocations(BuildContext context) async {
    int count = await bg.BackgroundGeolocation.count;
    if (count == 0) {
      util.Dialog.alert(context, "Destroy Locations", "Database is empty.");
      return;
    }
    util.Dialog.confirm(context, "Confirm", "Destroy $count locations?",
        (bool confirm) {
      // TODO show spinner
      if (!confirm) {
        return;
      }
      bg.BackgroundGeolocation.destroyLocations().then((bool success) {
        // TODO hide spinner.
        bg.BackgroundGeolocation.playSound(
            util.Dialog.getSoundId((success) ? "MESSAGE_SENT" : "ERROR"));
      });
    });
  }

  static void emailLog(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? email = prefs.getString("email");
    if (email == null) {
      email = "";
    }
    email = await util.Dialog.prompt(context,
        title: "Email log", labelText: 'Email', value: email, hintText: '');
    if (email!.length > 0) {
      prefs.setString("email", email!);
      util.Dialog.alert(context, 'Email log',
          'The log will be processed in the background (it can take some time depending on the size of the log).  Your email client will launch when ready.');

      bg.Logger.emailLog(email).then((bool success) {
        print('[emailLog] success');
      }).catchError((error) {
        util.Dialog.alert(context, 'Email log Error', error.toString());
      });
    }
  }

  static void destroyLog(BuildContext context) {
    util.Dialog.confirm(context, "Confirm", "Destroy logs?", (bool confirm) {
      if (!confirm) {
        return;
      }
      bg.Logger.destroyLog().then((bool success) {
        print('destroyLog] success');
      }).catchError((error) {
        print("[destroyLog] ERROR: $error");
      });
    });
  }
}
