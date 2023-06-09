import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

/// Simple Map of iOS / Android sound ID compatible with [BackgroundGeolocation.playSound].
///
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
    "FLOURISH": 1509,
    "TEST_MODE_CLICK": 1130,
    "TEST_MODE_SUCCESS": 1114
  },
  "android": {
    "LONG_PRESS_ACTIVATE": "DOT_START",
    "LONG_PRESS_CANCEL": "DOT_STOP",
    "ADD_GEOFENCE": "DOT_SUCCESS",
    "BUTTON_CLICK": "BUTTON_CLICK",
    "MESSAGE_SENT": "WHOO_SEND_SHARE",
    "ERROR": "ERROR",
    "OPEN": "OPEN",
    "CLOSE": "CLOSE",
    "FLOURISH": "POP",
    "TEST_MODE_CLICK": "POP",
    "TEST_MODE_SUCCESS": "BEEP_ON"
  }
};

/// Util class for launching dialogs.
/// - [confim]
/// - [alert]
/// - [prompt]
/// - [showLoading]
///
class Dialog {
  static void confirm(BuildContext context, String title, String message,
      Function(bool) callback) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                callback(false);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirm'),
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

  static void alert(BuildContext context, String title, String message,
      [Function? callback]) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("Ok"),
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

  static Future prompt(BuildContext context,
      {required String title, required String labelText, required String hintText, required String value}) {
    TextEditingController controller = new TextEditingController(text: value);

    Completer completer = new Completer<String>();

    String submittedValue = value;

    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: Text(title),
          contentPadding: const EdgeInsets.all(16.0),
          content: SizedBox(
            height: 100.0,
            child: Column(children: <Widget>[
              //new Text(''),  TODO could add some paragrah here before text-field.
              new Row(
                children: <Widget>[
                  Expanded(
                      child: new TextField(
                    controller: controller,
                    onChanged: (String value) {
                      submittedValue = value;
                    },
                    autofocus: true,
                    decoration: new InputDecoration(
                      labelText: labelText,
                      hintText: hintText,
                    ),
                  ))
                ],
              ),
            ]),
          ),
          actions: <Widget>[
            new TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            new TextButton(
                child: Text('Submit'),
                onPressed: () {
                  Navigator.of(context).pop();
                  completer.complete(submittedValue);
                })
          ],
        );
      },
    );
    return completer.future;
  }

  static Future showLoading(
      BuildContext context, String message) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CircularProgressIndicator();
        });
  }

  // TODO return dynamic until iOS supports String sound ids.
  static dynamic getSoundId(String key) {
    key = key.toUpperCase();
    dynamic soundId = -1;
    Map<String, Object>? soundMap;
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
