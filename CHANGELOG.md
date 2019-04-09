# CHANGELOG

## [1.0.1] - 2019-04-09
- [Fixed] iOS: Incorrect return type BOOL from native method stopBackgroundTask.  Should have been int.
- [Changed] Add Geofence test panel in example Settings screen.  Allows to add a series of test-geofences along the iOS simulator Freeway Drive route.

## [1.0.0] - 2019-04-05
- [RELEASE] Release 1.0.0

## [1.0.0-rc.4] - 2019-03-31
- [Fixed] Android: Another `NullPointerException` with `Bundle#getExtras`.

## [1.0.0-rc.3] - 2019-03-29

- [Fixed] Android `NullPointerException` with `Bundle#getExtras` (#674).
- [Fixed] Android not persisting `providerchange` location when location-services re-enabled.

## [1.0.0-rc.2] - 2019-03-27

- [Fixed] An Android foreground-service is launched on first install and fails to stop.

## [1.0.0-rc.1] - 2019-03-25

### Breaking Changes

- [Changed] The license format has changed.  New `1.0.0` licenses are now available for customers in the [product dashboard](https://www.transistorsoft.com/shop/customers).

### Fixes

- [Fixed] iOS missing native `destroyLog` implementation (thanks to @joserocha3)
- [Fixed] Missing Dart implementation for `requestPermission` method (thanks to @joserocha3)
- [Fixed] Logic bugs in MotionActivity triggering between *stationary* / *moving* states.
- [Fixed] List.map Bug in Dart api `addGeofences`.

### New Features

- [Added] Android implementation for `useSignificantChangesOnly` Config option.  Will request Android locations **without the persistent foreground service**.  You will receive location updates only a few times per hour:
`useSignificantChangesOnly: true`:
![](https://dl.dropboxusercontent.com/s/wdl9e156myv5b34/useSignificantChangesOnly.png?dl=1)

`useSignificantChangesOnly: false`:
![](https://dl.dropboxusercontent.com/s/hcxby3sujqanv9q/useSignificantChangesOnly-false.png?dl=1)

- [Added] Android now implements a "stationary geofence", just like iOS.  It currently acts as a secondary triggering mechanism along with the current motion-activity API.  You will hear the "zap" sound effect when it triggers.  This also has the fortunate consequence of allowing mock-location apps (eg: Lockito) of being able to trigger tracking automatically.

- [Added] The SDK detects mock locations and skips trigging the `stopTimeout` system, improving location simulation workflow.
- [Added] Android-only Config option `geofenceModeHighAccuracy` for more control over geofence triggering responsiveness.  Runs a foreground-service during geofences-only mode (`#startGeofences`).  This will, of course, consume more power.
```dart
await BackgroundGeolocation.ready(Config
  geofenceModeHighAccuracy: true,
  desiredAccuracy: Config.DESIRED_ACCURACY_MEDIUM,
  locationUpdateInterval: 5000,
  distanceFilter: 50
));

BackgroundGeolocation.startGeofences();
```

- [Added] Android implementation of `startBackgroundTask` / `stopBackgroundTask`.  This implementation uses a foreground-service.  I've tried using Android's `JobService` but these tasks are queued by the OS and run only periodically.
```dart
  // an Android foreground-service has just launched (in addition to its persistent notification).
  int taskId = await BackgroundGeolocation.startBackgroundTask();

  // Do any work you like -- it's guaranteed to run, regardless of background/terminated.
  // Your task has exactly 30s to do work before the service auto-stops itself.

  // Execute an HTTP request to test an async operation.
  String url = "http://tracker.transistorsoft.com/devices?company_token=$_username";
  String result = await http.read(url).then((String result) {
    print("[http test] success: $result");
    // Terminate the foreground-service.
    BackgroundGeolocation.stopBackgroundTask(taskId);
  }).catchError((dynamic error) {
    print("[http test] failed: $error");
    // Always be sure to stop your tasks, just like iOS.
    BackgroundGeolocation.stopBackgroundTask(taskId);
  });
```
Logging for background-tasks looks like this (when you see an hourglass, a foreground-service is active)
```
 [BackgroundTaskManager onStartJob] ⏳ startBackgroundTask: 6
 .
 .
 .
 [BackgroundTaskManager$Task stop] ⏳ stopBackgroundTask: 6
```
- [Added] New custom Android debug sound FX.  More documentation will be added to the docs but here's a basic description from the code:
```java
    public static final String LOCATION_RECORDED        = OOOOIII;
    public static final String LOCATION_SAMPLE          = CLICK_TAP_DONE;
    public static final String LOCATION_ERROR           = DIGI_WARN;

    public static final String MOTIONCHANGE_FALSE       = MARIMBA_DROP;
    public static final String MOTIONCHANGE_TRUE        = CHIME_SHORT_CHORD_UP;
    public static final String STATIONARY_GEOFENCE_EXIT = ZAP_FAST;

    public static final String STOP_TIMER_ON            = CHIME_BELL_CONFIRM;
    public static final String STOP_TIMER_OFF           = BELL_DING_POP;

    public static final String HEARTBEAT                = PEEP_NOTE;

    public static final String GEOFENCE_ENTER           = BEEP_TRIP_UP_DRY;
    public static final String GEOFENCE_DWELL           = BEEP_TRIP_UP_ECHO;
    public static final String GEOFENCE_EXIT            = BEEP_TRIP_DRY;

    public static final String WARNING                  = DIGI_WARN;
    public static final String ERROR                    = MUSIC_TIMPANI_ERROR;
```

:warning: These debug sound FX consume about **1.4MB** in the plugin's `tslocationmanager.aar`.  These assets can easily be stripped in your `release` builds by adding the following gradle task to your `app/build.gradle` (I'm working on an automated solution within the context of the plugin's `build.gradle`; so far, no luck).  [Big thanks](https://github.com/transistorsoft/react-native-background-geolocation-android/issues/667#issuecomment-475928108) to @mikehardy.
```gradle
/**
 * Purge flutter_background_geolocation debug sounds from release build.
 */
def purgeBackgroundGeolocationDebugResources(applicationVariants) {
    applicationVariants.all { variant ->
        if (variant.buildType.name == 'release') {
            variant.mergeResources.doLast {
                delete(fileTree(dir: variant.mergeResources.outputDir, includes: ['raw_tslocationmanager*']))

            }
        }
    }
}

android {
    //Remove debug sounds from background_geolocation plugin
    purgeBackgroundGeolocationDebugResources(applicationVariants)

    compileSdkVersion rootProject.ext.compileSdkVersion
    .
    .
    .
}
```

### Removed
- [Changed] Removed Android config option `activityRecognitionInterval`.  The Android SDK now uses the more modern [ActivityTransistionClient](https://medium.com/life360-engineering/beta-testing-googles-new-activity-transition-api-c9c418d4b553) API which is a higher level wrapper for the traditional [ActivityReconitionClient](https://developers.google.com/android/reference/com/google/android/gms/location/ActivityRecognitionClient).  `AcitvityTransitionClient` does not accept a polling `interval`, thus `actiivtyRecognitionInterval` is now unused.  Also, `ActivityTransitionClient` emits similar `on_foot`, `in_vehicle` events but no longer provides a `confidence`, thus `confidence` is now reported always as `100`.  If you've been implementing your own custom triggering logic based upon `confidence`, it's now pointless.  The `ActivityTransitionClient` will open doors for new features based upon transitions between activity states.
```
╔═════════════════════════════════════════════
║ Motion Transition Result
╠═════════════════════════════════════════════
╟─ 🔴  EXIT: walking
╟─ 🎾  ENTER: still
╚═════════════════════════════════════════════
```

### Maintenance
- [Changed] Update `android-permissions` dependency to `0.1.8`.
