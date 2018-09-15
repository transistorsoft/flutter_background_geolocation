/// Util class for performing dialogs
///

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

const SOUND_MAP = {
  "ios": {
    "LONG_PRESS_ACTIVATE": 1113,
    "LONG_PRESS_CANCEL": 1075,
    "ADD_GEOFENCE": 1114,
    "BUTTON_CLICK": 1104,
    "MESSAGE_SENT": 1303,
    "ERROR": 1006,
    "OPEN": 1502,
    "CLOSE": 1503,
    "FLOURISH": 1509
  },
  "android": {
    "LONG_PRESS_ACTIVATE": 27,
    "LONG_PRESS_CANCEL": 94,
    "ADD_GEOFENCE": 28,
    "BUTTON_CLICK": 19,
    "MESSAGE_SENT": 90,
    "ERROR": 89,
    "OPEN": 37,
    "CLOSE": 94,
    "FLOURISH": 37
  }
};

class Dialog {
  static void confirm(BuildContext context, String title, String message, Function(bool) callback) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                callback(false);
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: new Text("Confirm"),
              onPressed: () {
                callback(true);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static void alert(BuildContext context, String title, String message, [Function callback]) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                if (callback != null) {
                  callback(true);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static int getSoundId(String key) {
    key = key.toUpperCase();
    int soundId = -1;
    Map<String, Object> soundMap;
    if (defaultTargetPlatform == TargetPlatform.android) {
      soundMap = SOUND_MAP["android"];
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      soundMap = SOUND_MAP["ios"];
    }
    if (soundMap != null && soundMap.containsKey(key)) {
        soundId = soundMap[key];
    }
    return soundId;
  }
}