import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:shared_preferences/shared_preferences.dart';

class Test {
  /// My private test field-test config.
  /// @private DO NOT USE.
  ///
  static void applyTestConfig() async {
    List<dynamic> data = [{
      "identifier": "Jfk",
      "radius": 200.0,
      "latitude": 45.52193435702239,
      "longitude": -73.61602026242679,
      "notifyOnEntry": true,
      "notifyOnExit": true,
      "notifyOnDwell": false,
      "loiteringDelay": 0,
      "extras": {
        "radius": 200,
        "center": {
          "latitude": 45.52193435702239,
          "longitude": -73.61602026242679
        }
      }
    }, {
      "identifier": "Laj",
      "radius": 200.0,
      "latitude": 45.52011166353691,
      "longitude": -73.61188565687189,
      "notifyOnEntry": true,
      "notifyOnExit": true,
      "notifyOnDwell": false,
      "loiteringDelay": 0,
      "extras": {
        "radius": 200,
        "center": {
          "latitude": 45.52011166353691,
          "longitude": -73.61188565687189
        }
      }
    }, {
      "identifier": "Bernard",
      "radius": 200.0,
      "latitude": 45.51890341224348,
      "longitude": -73.60920346871359,
      "notifyOnEntry": true,
      "notifyOnExit": true,
      "notifyOnDwell": false,
      "loiteringDelay": 0,
      "extras": {
        "radius": 200,
        "center": {
          "latitude": 45.51890341224348,
          "longitude": -73.60920346871359
        }
      }
    }, {
      "identifier": "Park",
      "radius": 200.0,
      "latitude": 45.51793055832324,
      "longitude": -73.60288022069346,
      "notifyOnEntry": true,
      "notifyOnExit": true,
      "notifyOnDwell": false,
      "loiteringDelay": 0,
      "extras": {
        "radius": 200,
        "center": {
          "latitude": 45.51793055832324,
          "longitude": -73.60288022069346
        }
      }
    }, {
      "identifier": "Dollard",
      "radius": 200.0,
      "latitude": 45.51722612373795,
      "longitude": -73.61367125021673,
      "notifyOnEntry": true,
      "notifyOnExit": true,
      "notifyOnDwell": false,
      "loiteringDelay": 0,
      "extras": {
        "radius": 200,
        "center": {
          "latitude": 45.51722612373795,
          "longitude": -73.61367125021673
        }
      }
    }];

    List<bg.Geofence> geofences = [];

    data.forEach((dynamic item) {
      geofences.add(bg.Geofence(
          identifier: item['identifier'],
          latitude: item['latitude'],
          longitude: item['longitude'],
          radius: item['radius'],
          notifyOnDwell: item['notifyOnDwell'],
          notifyOnEntry: item['notifyOnEntry'],
          notifyOnExit: item['notifyOnExit'],
          extras: item['extras']
      ));
    });

    await bg.BackgroundGeolocation.removeGeofences();
    await bg.BackgroundGeolocation.addGeofences(geofences);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString("username");
    Map deviceParams = await bg.Config.deviceParams;

    bg.BackgroundGeolocation.setConfig(bg.Config(
        debug: true,
        logLevel: bg.Config.LOG_LEVEL_VERBOSE,
        desiredAccuracy: bg.Config.DESIRED_ACCURACY_NAVIGATION,
        distanceFilter: 50,
        locationUpdateInterval: 5000,
        fastestLocationUpdateInterval: -1,
        stopTimeout: 0,
        url: "http://tracker.transistorsoft.com/locations/$username",
        params: deviceParams,
        geofenceModeHighAccuracy: true,
        stopOnTerminate: false,
        startOnBoot: true,
        enableHeadless: true,
        heartbeatInterval: -1
    ));
  }
}