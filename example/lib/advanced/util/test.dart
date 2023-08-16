import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/ENV.dart';

class Test {
  /// My private test field-test config.
  /// @private DO NOT USE.
  ///
  static void applyTestConfig() async {
    List<dynamic> data = [
      {
        "identifier": "[Flutter] Home",
        "radius": 200.0,
        "latitude": 45.51872221233045,
        "longitude": -73.60041976465013,
        "notifyOnEntry": true,
        "notifyOnExit": true,
        "notifyOnDwell": true,
        "loiteringDelay": 60000,
        "extras": {
          "radius": 200,
          "center": {
            "latitude": 45.51872221233045,
            "longitude": -73.60041976465013,
          }
        }
      },
      {
        "identifier": "[Flutter] Parc Outremont",
        "radius": 200.0,
        "latitude": 45.51791915253888,
        "longitude": -73.60480434117284,
        "notifyOnEntry": true,
        "notifyOnExit": true,
        "notifyOnDwell": true,
        "loiteringDelay": 60000,
        "extras": {
          "radius": 200,
          "center": {
            "latitude": 45.51791915253888,
            "longitude": -73.60480434117284,
          }
        }
      },
      {
        "identifier": "[Flutter] 5 Saison",
        "radius": 200.0,
        "latitude": 45.52193435702239,
        "longitude": -73.60793815706307,
        "notifyOnEntry": true,
        "notifyOnExit": true,
        "notifyOnDwell": true,
        "loiteringDelay": 0,
        "extras": {
          "radius": 200,
          "center": {
            "latitude": 45.52193435702239,
            "longitude": -73.60793815706307,
          }
        }
      },
      {
        "identifier": "[Flutter] Laj",
        "radius": 200.0,
        "latitude": 45.52011166353691,
        "longitude": -73.61188565687189,
        "notifyOnEntry": true,
        "notifyOnExit": true,
        "notifyOnDwell": true,
        "loiteringDelay": 0,
        "extras": {
          "radius": 200,
          "center": {
            "latitude": 45.52011166353691,
            "longitude": -73.61188565687189
          }
        }
      },
      {
        "identifier": "[Flutter] Park Beaubien",
        "radius": 200.0,
        "latitude": 45.51536622906458,
        "longitude": -73.60916110960558,
        "notifyOnEntry": true,
        "notifyOnExit": true,
        "notifyOnDwell": false,
        "loiteringDelay": 0,
        "extras": {
          "radius": 200,
          "center": {
            "latitude": 45.51536622906458,
            "longitude": -73.60916110960558
          }
        }
      },
      {
        "identifier": "[Flutter] Parc & Fairmount",
        "radius": 200.0,
        "latitude": 45.5204308608878,
        "longitude": -73.59730225310089,
        "notifyOnEntry": true,
        "notifyOnExit": true,
        "notifyOnDwell": true,
        "loiteringDelay": 60000,
        "extras": {
          "radius": 200,
          "center": {
            "latitude": 45.5204308608878,
            "longitude": -73.59730225310089
          }
        }
      },
      {
        "identifier": "[Flutter] Parc Couches Tard",
        "radius": 200.0,
        "latitude": 45.51744539760233,
        "longitude": -73.5908963928221,
        "notifyOnEntry": true,
        "notifyOnExit": true,
        "notifyOnDwell": false,
        "loiteringDelay": 0,
        "extras": {
          "radius": 200,
          "center": {
            "latitude": 45.51744539760233,
            "longitude": -73.5908963928221
          }
        }
      },
      {
        "identifier": "[Flutter] Laurier & Côtes Saint Catherines",
        "radius": 200.0,
        "latitude": 45.51602235252262,
        "longitude": -73.59890979915006,
        "notifyOnEntry": true,
        "notifyOnExit": true,
        "notifyOnDwell": false,
        "loiteringDelay": 60000,
        "extras": {
          "radius": 200,
          "center": {
            "latitude": 45.51602235252262,
            "longitude": -73.59890979915006,
          }
        }
      },
      {
        "identifier": "[Flutter] Mountain 1",
        "radius": 200.0,
        "latitude": 45.51339446482965,
        "longitude": -73.5890430151955,
        "notifyOnEntry": true,
        "notifyOnExit": true,
        "notifyOnDwell": false,
        "loiteringDelay": 60000,
        "extras": {
          "radius": 200,
          "center": {
            "latitude": 45.51339446482965,
            "longitude": -73.5890430151955
          }
        }
      },
      {
        "identifier": "[Flutter] Mountain 2",
        "radius": 200.0,
        "latitude": 45.511936585973096,
        "longitude": -73.59662309075495,
        "notifyOnEntry": true,
        "notifyOnExit": true,
        "notifyOnDwell": false,
        "loiteringDelay": 60000,
        "extras": {
          "radius": 200,
          "center": {
            "latitude": 45.511936585973096,
            "longitude": -73.59662309075495
          }
        }
      },
      {
        "identifier": "[Flutter] Mountain 3",
        "radius": 200.0,
        "latitude": 45.50873361477508,
        "longitude": -73.59089814860727,
        "notifyOnEntry": true,
        "notifyOnExit": true,
        "notifyOnDwell": false,
        "loiteringDelay": 60000,
        "extras": {
          "radius": 200,
          "center": {
            "latitude": 45.50873361477508,
            "longitude": -73.59089814860727
          }
        }
      },
      {
        "identifier": "[Flutter] Mountain 4",
        "radius": 200.0,
        "latitude": 45.50414694296492,
        "longitude": -73.5916710539562,
        "notifyOnEntry": true,
        "notifyOnExit": true,
        "notifyOnDwell": false,
        "loiteringDelay": 60000,
        "extras": {
          "radius": 200,
          "center": {
            "latitude": 45.50414694296492,
            "longitude": -73.5916710539562
          }
        }
      },
      {
        "identifier": "[Flutter] Mountain 5",
        "radius": 200.0,
        "latitude": 45.50491473767328,
        "longitude": -73.58654527405864,
        "notifyOnEntry": true,
        "notifyOnExit": true,
        "notifyOnDwell": false,
        "loiteringDelay": 60000,
        "extras": {
          "radius": 200,
          "center": {
            "latitude": 45.50491473767328,
            "longitude": -73.58654527405864
          }
        }
      },
      {
        "identifier": "[Flutter] Mountain Lake",
        "radius": 200.0,
        "latitude": 45.49860916086097,
        "longitude": -73.59621565704647,
        "notifyOnEntry": true,
        "notifyOnExit": true,
        "notifyOnDwell": false,
        "loiteringDelay": 60000,
        "extras": {
          "radius": 200,
          "center": {
            "latitude": 45.49860916086097,
            "longitude": -73.59621565704647
          }
        }
      },
      {
        "identifier": "[Flutter] Park JFK",
        "radius": 200.0,
        "latitude": 45.52135522992923,
        "longitude": -73.61568446341691,
        "notifyOnEntry": true,
        "notifyOnExit": true,
        "notifyOnDwell": false,
        "loiteringDelay": 60000,
        "extras": {
          "radius": 200,
          "center": {
            "latitude": 45.52135522992923,
            "longitude": -73.61568446341691
          }
        }
      },
      {
        "identifier": "[Flutter] Rope Park",
        "radius": 200.0,
        "latitude": 45.51335215591131,
        "longitude": -73.58016477295465,
        "notifyOnEntry": true,
        "notifyOnExit": true,
        "notifyOnDwell": true,
        "loiteringDelay": 60000,
        "extras": {
          "radius": 200,
          "center": {
            "latitude": 45.51335215591131,
            "longitude": -73.58016477295465
          }
        }
      },
      {
        "identifier": "[Flutter] Cafe Union",
        "radius": 200.0,
        "latitude": 45.5332674993574,
        "longitude": -73.61939297593483,
        "notifyOnEntry": true,
        "notifyOnExit": true,
        "notifyOnDwell": true,
        "loiteringDelay": 60000,
        "extras": {
          "radius": 200,
          "center": {
            "latitude": 45.5332674993574,
            "longitude": -73.61939297593483
          }
        }
      },
      {
        "identifier": "[Flutter] Park Laurier",
        "radius": 200.0,
        "latitude": 45.53237479609443,
        "longitude": -73.58741778627864,
        "notifyOnEntry": true,
        "notifyOnExit": true,
        "notifyOnDwell": true,
        "loiteringDelay": 60000,
        "extras": {
          "radius": 200,
          "center": {
            "latitude": 45.53237479609443,
            "longitude": -73.58741778627864,
          }
        }
      }
    ];

    List<bg.Geofence> geofences = [];

    data.forEach((dynamic item) {
      geofences.add(bg.Geofence(
          identifier: item['identifier'],
          latitude: item['latitude'],
          longitude: item['longitude'],
          radius: item['radius'],
          loiteringDelay: 10000,
          notifyOnDwell: true,
          notifyOnEntry: true,
          notifyOnExit: true,
          extras: item['extras']));
    });

    /**
     * TEST:  Inflate geofences > 100 to engage infinite geofencing
     *
    for (int n=data.length;n<100;n++) {
      geofences.add(bg.Geofence(
        identifier: "BOGUS_$n",
        latitude: 0.0,
        longitude: 0.0,
        radius: 200,
        notifyOnEntry: true,
        notifyOnExit: true
      ));
    }
    */

    //await bg.BackgroundGeolocation.removeGeofences();
    await bg.BackgroundGeolocation.addGeofences(geofences);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString("username");
    String? orgname = prefs.getString("orgname");

    // Request a JWT from tracker.transistorsoft.com
    bg.TransistorAuthorizationToken token =
        await bg.TransistorAuthorizationToken.findOrCreate(
            orgname!, username!, ENV.TRACKER_HOST);

    List<String> schedule = [];
    bg.State state = await bg.BackgroundGeolocation.state;

    // If we're not enabled now, add a test scheulde:
    if (!state.enabled) {
      // Create a test schedule to start in 1 minute for duration 1 minute (with 1 min offset between each)
      DateTime now = DateTime.now();
      for (int n = 0; n < 120; n++) {
        DateTime start = now.add(Duration(minutes: (2 * n + 1)));
        DateTime end = start.add(Duration(minutes: 1));
        schedule
            .add("1-7 ${start.hour}:${start.minute}-${end.hour}:${end.minute} geofence");
      }
    }

    state = await bg.BackgroundGeolocation.reset(bg.Config(
        disableMotionActivityUpdates: false,
        debug: true,
        logLevel: bg.Config.LOG_LEVEL_VERBOSE,
        transistorAuthorizationToken: token,
        desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
        distanceFilter: 50,
        disableElasticity: false,
        locationUpdateInterval: 1000,
        locationAuthorizationRequest: "Always",
        fastestLocationUpdateInterval: -1,
        enableTimestampMeta: true,
        stopTimeout: 1,
        maxDaysToPersist: 14,
        backgroundPermissionRationale: bg.PermissionRationale(
            title:
                "Allow {applicationName} to access this device's location even when the app is closed or not in use.",
            message:
                "This app collects location data to enable recording your trips to work and calculate distance-travelled.",
            positiveAction: 'Change to "{backgroundPermissionOptionLabel}"',
            negativeAction: 'Cancel'),
        notification: bg.Notification(
            sticky: false,
            layout: 'notification_layout',
            channelId: 'my_channel_id',
            actions: ["notificationButtonFoo", "notificationButtonBar"]),
        schedule: schedule,

        scheduleUseAlarmManager: true,
        extras: {"foo": "bar"},
        autoSync: true,
        geofenceModeHighAccuracy: true,
        motionTriggerDelay: 30000,
        stopOnTerminate: false,
        startOnBoot: true,
        enableHeadless: true,
        heartbeatInterval: -1));

    try {
      await bg.BackgroundGeolocation.setOdometer(0.0);
    } catch (error) {
      print("[setOdometer] ERROR: $error");
    }

    // If provided a schedule, start the schedule.
    if (state.schedule!.isNotEmpty) {
      await bg.BackgroundGeolocation.startSchedule();
    } else {
      await bg.BackgroundGeolocation.stopSchedule();
    }
  }

  static List<bg.Geofence> getFreewayDriveGeofences(
      double radius,
      bool notifyOnEntry,
      bool notifyOnExit,
      bool notifyOnDwell,
      int loiteringDelay) {
    List<dynamic> data = [
      {"lat": 37.33527476, "lng": -122.03254703},
      {"lat": 37.33500926, "lng": -122.03272188},
      {"lat": 37.33467638, "lng": -122.03432425},
      {"lat": 37.33453849, "lng": -122.03695223},
      {"lat": 37.33447068, "lng": -122.04007348},
      {"lat": 37.33446146, "lng": -122.04380955},
      {"lat": 37.33426985, "lng": -122.04751058},
      {"lat": 37.33352458, "lng": -122.05100549},
      {"lat": 37.33275353, "lng": -122.05462472},
      {"lat": 37.33228724, "lng": -122.05833354},
      {"lat": 37.33307736, "lng": -122.06203541},
      {"lat": 37.33422447, "lng": -122.06562781},
      {"lat": 37.33435661, "lng": -122.06939204},
      {"lat": 37.33369775, "lng": -122.07309474},
      {"lat": 37.33368006, "lng": -122.07665613},
      {"lat": 37.33492184, "lng": -122.07997503},
      {"lat": 37.3370055, "lng": -122.0827595},
      {"lat": 37.33879885, "lng": -122.08577472},
      {"lat": 37.34046597, "lng": -122.08886286},
      {"lat": 37.34208941, "lng": -122.09195687},
      {"lat": 37.34415677, "lng": -122.09439031},
      {"lat": 37.34576798, "lng": -122.09727888},
      {"lat": 37.34719244, "lng": -122.1006624},
      {"lat": 37.34894824, "lng": -122.1036539},
      {"lat": 37.35145376, "lng": -122.10569934},
      {"lat": 37.35357644, "lng": -122.10818206},
      {"lat": 37.35478615, "lng": -122.11144128},
      {"lat": 37.35583234, "lng": -122.11484701},
      {"lat": 37.35772158, "lng": -122.11764607},
      {"lat": 37.36040727, "lng": -122.11952001},
      {"lat": 37.36303768, "lng": -122.12160442},
      {"lat": 37.36457081, "lng": -122.12476867},
      {"lat": 37.36489536, "lng": -122.12851823},
      {"lat": 37.36543834, "lng": -122.13217241},
      {"lat": 37.3664761, "lng": -122.13564763},
      {"lat": 37.36776176, "lng": -122.13898061},
      {"lat": 37.36994839, "lng": -122.1416339},
      {"lat": 37.37240005, "lng": -122.14386038},
      {"lat": 37.37481249, "lng": -122.14611939},
      {"lat": 37.37709618, "lng": -122.14869624},
      {"lat": 37.37961188, "lng": -122.15082139},
      {"lat": 37.3826398, "lng": -122.15178036},
      {"lat": 37.38560981, "lng": -122.15272559},
      {"lat": 37.38774539, "lng": -122.15510789},
      {"lat": 37.38869141, "lng": -122.15849049},
      {"lat": 37.38931302, "lng": -122.16207476},
      {"lat": 37.39081987, "lng": -122.1652427},
      {"lat": 37.39210109, "lng": -122.16863067},
      {"lat": 37.39242056, "lng": -122.17227965},
      {"lat": 37.39361482, "lng": -122.17556879},
      {"lat": 37.39578711, "lng": -122.17805511},
      {"lat": 37.39821434, "lng": -122.18044236},
      {"lat": 37.40071157, "lng": -122.18290622},
      {"lat": 37.40313012, "lng": -122.18535374},
      {"lat": 37.40549529, "lng": -122.18774837},
      {"lat": 37.40759705, "lng": -122.19035128},
      {"lat": 37.40890928, "lng": -122.19364872},
      {"lat": 37.41002813, "lng": -122.19717013},
      {"lat": 37.4111682, "lng": -122.20078524},
      {"lat": 37.41233794, "lng": -122.20442475},
      {"lat": 37.41363889, "lng": -122.20791833},
      {"lat": 37.41583072, "lng": -122.2106204},
      {"lat": 37.41782917, "lng": -122.21338064},
      {"lat": 37.41872658, "lng": -122.21683566},
      {"lat": 37.41935866, "lng": -122.22058933},
      {"lat": 37.4209964, "lng": -122.22388736},
      {"lat": 37.42303224, "lng": -122.22680837},
      {"lat": 37.42510651, "lng": -122.22979057},
      {"lat": 37.42738525, "lng": -122.23260102},
      {"lat": 37.42942843, "lng": -122.23549663},
      {"lat": 37.4313864, "lng": -122.23829728},
      {"lat": 37.43354365, "lng": -122.24095367},
      {"lat": 37.4357105, "lng": -122.24350931},
      {"lat": 37.4378918, "lng": -122.24613695},
      {"lat": 37.44000262, "lng": -122.24876996},
      {"lat": 37.44207177, "lng": -122.25146784},
      {"lat": 37.44364246, "lng": -122.25458952},
      {"lat": 37.44423451, "lng": -122.25815644},
      {"lat": 37.44401797, "lng": -122.26182293},
      {"lat": 37.44381697, "lng": -122.26544651},
      {"lat": 37.4444387, "lng": -122.26900388},
      {"lat": 37.44598499, "lng": -122.27225807},
      {"lat": 37.44805758, "lng": -122.27523289},
      {"lat": 37.45014137, "lng": -122.27827786},
      {"lat": 37.45213903, "lng": -122.28131706},
      {"lat": 37.45408782, "lng": -122.28428358},
      {"lat": 37.45607437, "lng": -122.28728422},
      {"lat": 37.45855399, "lng": -122.28964389},
      {"lat": 37.46150337, "lng": -122.29066665},
      {"lat": 37.46449927, "lng": -122.29080537},
      {"lat": 37.46741706, "lng": -122.29164222},
      {"lat": 37.47004943, "lng": -122.29347317},
      {"lat": 37.4724045, "lng": -122.29584441},
      {"lat": 37.47484795, "lng": -122.29807718},
      {"lat": 37.47775391, "lng": -122.29919189},
      {"lat": 37.48081016, "lng": -122.29901151},
      {"lat": 37.48386847, "lng": -122.29850608},
      {"lat": 37.4868127, "lng": -122.2981216},
      {"lat": 37.48974125, "lng": -122.29883038},
      {"lat": 37.49226793, "lng": -122.30073474},
      {"lat": 37.49413538, "lng": -122.3036213},
      {"lat": 37.4951695, "lng": -122.30711999},
      {"lat": 37.49605031, "lng": -122.31058583},
      {"lat": 37.49739544, "lng": -122.3138981},
      {"lat": 37.49913263, "lng": -122.31702405},
      {"lat": 37.50040366, "lng": -122.32036315},
      {"lat": 37.50083658, "lng": -122.32388539},
      {"lat": 37.50117039, "lng": -122.32749548},
      {"lat": 37.50237035, "lng": -122.33083005},
      {"lat": 37.50420426, "lng": -122.33381577},
      {"lat": 37.50606869, "lng": -122.33688933},
      {"lat": 37.50799594, "lng": -122.34003061},
      {"lat": 37.50988405, "lng": -122.34301482},
      {"lat": 37.51203087, "lng": -122.34564414},
      {"lat": 37.51425798, "lng": -122.34819157},
      {"lat": 37.51644813, "lng": -122.35068376},
      {"lat": 37.51869146, "lng": -122.35307638},
      {"lat": 37.52133683, "lng": -122.35490229},
      {"lat": 37.52404792, "lng": -122.35651279},
      {"lat": 37.52656144, "lng": -122.35869996},
      {"lat": 37.52949012, "lng": -122.36013184},
      {"lat": 37.53245962, "lng": -122.36139139},
      {"lat": 37.53535502, "lng": -122.36269562},
      {"lat": 37.53806531, "lng": -122.36427066},
      {"lat": 37.54071957, "lng": -122.36586045},
      {"lat": 37.54319399, "lng": -122.36775116},
      {"lat": 37.54551481, "lng": -122.37012089},
      {"lat": 37.54781925, "lng": -122.37250714},
      {"lat": 37.55009393, "lng": -122.37486312},
      {"lat": 37.55254949, "lng": -122.37717024},
      {"lat": 37.55541199, "lng": -122.37918458},
      {"lat": 37.55818716, "lng": -122.38106338},
      {"lat": 37.56068828, "lng": -122.38341593},
      {"lat": 37.56314841, "lng": -122.38588298},
      {"lat": 37.56541169, "lng": -122.38835698},
      {"lat": 37.56674169, "lng": -122.39169239},
      {"lat": 37.5685417, "lng": -122.39470024},
      {"lat": 37.57095669, "lng": -122.39698791},
      {"lat": 37.57337626, "lng": -122.39928572},
      {"lat": 37.57613294, "lng": -122.40094584},
      {"lat": 37.57901078, "lng": -122.4022173},
      {"lat": 37.58156135, "lng": -122.40405955},
      {"lat": 37.58410689, "lng": -122.40616551},
      {"lat": 37.58628103, "lng": -122.40888284},
      {"lat": 37.58845823, "lng": -122.41162422},
      {"lat": 37.59089234, "lng": -122.41402865},
      {"lat": 37.5933155, "lng": -122.41641054},
      {"lat": 37.59572459, "lng": -122.41875689},
      {"lat": 37.59795493, "lng": -122.42134262},
      {"lat": 37.60011457, "lng": -122.42399767},
      {"lat": 37.60240224, "lng": -122.4265399},
      {"lat": 37.60520008, "lng": -122.42789551},
      {"lat": 37.60813618, "lng": -122.42777573},
      {"lat": 37.61097345, "lng": -122.42659053},
      {"lat": 37.61359414, "lng": -122.42477627},
      {"lat": 37.61652164, "lng": -122.42409633},
      {"lat": 37.61941491, "lng": -122.42515597},
      {"lat": 37.62223282, "lng": -122.42696981},
      {"lat": 37.62499411, "lng": -122.42876044},
      {"lat": 37.62751237, "lng": -122.43105867},
      {"lat": 37.62961128, "lng": -122.43380726},
      {"lat": 37.63173002, "lng": -122.43652912},
      {"lat": 37.63434333, "lng": -122.43855737},
      {"lat": 37.63721702, "lng": -122.43994642},
      {"lat": 37.63973671, "lng": -122.44194609},
      {"lat": 37.64209642, "lng": -122.44410611},
      {"lat": 37.6439212, "lng": -122.44706014},
      {"lat": 37.64593185, "lng": -122.44975467},
      {"lat": 37.64856629, "lng": -122.45139107},
      {"lat": 37.65116761, "lng": -122.45299486},
      {"lat": 37.65334007, "lng": -122.45534515},
      {"lat": 37.65538199, "lng": -122.45796869},
      {"lat": 37.65749297, "lng": -122.4606685},
      {"lat": 37.6595944, "lng": -122.46334517},
      {"lat": 37.66213336, "lng": -122.46529514},
      {"lat": 37.66513186, "lng": -122.46553863},
      {"lat": 37.6681835, "lng": -122.46560385},
      {"lat": 37.67115958, "lng": -122.46650842},
      {"lat": 37.6737871, "lng": -122.46830709},
      {"lat": 37.67626076, "lng": -122.47032856},
      {"lat": 37.67888283, "lng": -122.47161778},
      {"lat": 37.681853, "lng": -122.47152482},
      {"lat": 37.6847816, "lng": -122.47134126},
      {"lat": 37.6876731, "lng": -122.47090381},
      {"lat": 37.69061264, "lng": -122.47027005},
      {"lat": 37.69348641, "lng": -122.47026259},
      {"lat": 37.69632218, "lng": -122.47076182},
      {"lat": 37.69914914, "lng": -122.47129566},
      {"lat": 37.70201202, "lng": -122.47133229},
      {"lat": 37.70486296, "lng": -122.47116624},
      {"lat": 37.70741441, "lng": -122.4695213},
      {"lat": 37.70957963, "lng": -122.46701645},
      {"lat": 37.71043642, "lng": -122.46355472},
      {"lat": 37.71046027, "lng": -122.45988294},
      {"lat": 37.71069928, "lng": -122.45637822},
      {"lat": 37.71224348, "lng": -122.45340591},
      {"lat": 37.71448702, "lng": -122.45078271},
      {"lat": 37.71693873, "lng": -122.44871305},
      {"lat": 37.71990228, "lng": -122.44822204},
      {"lat": 37.72291888, "lng": -122.44775048},
      {"lat": 37.72576768, "lng": -122.44632572},
      {"lat": 37.72805372, "lng": -122.44386563},
      {"lat": 37.72953195, "lng": -122.44070582},
      {"lat": 37.7307498, "lng": -122.43723772},
      {"lat": 37.73174796, "lng": -122.43356938},
      {"lat": 37.73216621, "lng": -122.42992443},
      {"lat": 37.73150681, "lng": -122.42617839},
      {"lat": 37.73152823, "lng": -122.42250586},
      {"lat": 37.73190474, "lng": -122.4188029},
      {"lat": 37.73208047, "lng": -122.4151556},
      {"lat": 37.73335846, "lng": -122.41185347},
      {"lat": 37.73467442, "lng": -122.40896246},
      {"lat": 37.7367644, "lng": -122.40753804},
      {"lat": 37.73918836, "lng": -122.40786326},
      {"lat": 37.74134411, "lng": -122.40745439},
      {"lat": 37.7433128, "lng": -122.40606023},
      {"lat": 37.7454038, "lng": -122.40480714},
      {"lat": 37.74791032, "lng": -122.40401446},
      {"lat": 37.75036492, "lng": -122.40324249},
      {"lat": 37.7530224, "lng": -122.40280453},
      {"lat": 37.75548823, "lng": -122.40305884},
      {"lat": 37.75750915, "lng": -122.40390315},
      {"lat": 37.75912761, "lng": -122.40587398},
      {"lat": 37.76147723, "lng": -122.40613148}
    ];

    List<bg.Geofence> geofences = [];
    int index = 0;
    data.forEach((dynamic geofence) {
      geofences.add(bg.Geofence(
          identifier: "freeway_drive_${++index}",
          latitude: geofence['lat'],
          longitude: geofence['lng'],
          radius: radius,
          notifyOnEntry: notifyOnEntry,
          notifyOnExit: notifyOnExit,
          notifyOnDwell: notifyOnDwell,
          loiteringDelay: loiteringDelay,
          extras: {
            "radius": radius,
            "center": {
              "latitude": geofence['lat'],
              "longitude": geofence['lng']
            }
          }));
    });
    return geofences;
  }
}
