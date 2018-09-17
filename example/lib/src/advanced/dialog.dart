/// Util class for performing dialogs
///

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

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
      barrierDismissible: false,
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
      barrierDismissible: false,
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

  static Future<String> prompt(BuildContext context, {String title, String labelText, String hintText, String value}) {
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
            child: Column(
                children: <Widget>[
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
                              labelText: labelText, hintText: hintText,
                        ),
                      ))
                    ],
                  ),
                ]
            ),
          ),
          actions: <Widget>[
            new RaisedButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                }
            ),
            new RaisedButton(
                child: const Text('Submit'),
                onPressed: () {
                  Navigator.of(context).pop();
                  completer.complete(submittedValue);
                }
            )
          ],
        );
      },
    );
    return completer.future;
  }

  static Future<CircularProgressIndicator> showLoading(BuildContext context, String message) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CircularProgressIndicator();
      }
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