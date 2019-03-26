# Change Log

## [1.0.0-rc.1] - 2019-03-20

### Breaking Changes
- [Changed] The license format has changed.  New `1.0.0` licenses are now available for customers in the [product dashboard](https://www.transistorsoft.com/shop/customers).

### Fixes
- [Fixed] iOS missing native `destroyLog` implementation (thanks to @joserocha3)
- [Fixed] Missing Dart implementation for `requestPermission` method (thanks to @joserocha3)
- [Fixed] Logic bugs in MotionActivity triggering between *stationary* / *moving* states.
- [Fixed] List.map Bug in Dart api `addGeofences`.

### New Features

- [Added] Android implementation for `useSignificantChangesOnly` Config option.  Will request Android locations **without the persistent foreground service**.  You will receive location updates only a few times per hour.
- [Added] Android now implements a "stationary geofence", just like iOS.  It currently acts as a secondary triggering mechanism along with the current motion-activity API.  You will hear the "zap" sound effect when it triggers.  This also
- [Added] The SDK detects mock locations and skips trigging the `stopTimeout` system, improving location simulation workflow.
has the fortunate consequence of allowing mock-location apps (eg: Lockito) of being able to trigger tracking automatically.
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


## [1.0.0-beta.5] - 2019-03-02
- [Changed] Implement AndroidX support.

## [1.0.0-beta.4] - 2019-03-02
- [Fixed] Android bug in Config dirty-fields mechanism.

## [1.0.0-beta.3] - 2019-03-02
- [Changed] Improve trackingMode state-changes between location -> geofences-only.
- [Changed] Improvements to geofences-only tracking.
- [Changed] Improvements to stationary-geofence monitoring, detecting mock locations to prevent stopTimeout triggering.

## [1.0.0-beta.2] - 2019-02-28
- [Changed] Adding intelligence for detecting bad android vendors (eg: Huawei) and forcing stopTimeout when device is stationary for long time and motion activity API hasn't responded.
- [Changed] Tweak stationary region monitoring.

## [1.0.0-beta.1] - 2019-02-27
- [Changed] Major refactor of Android Service architecture.  The SDK no longer requires a foreground-service active at all times.  The foreground-service (and cooresponding persistent notification) will only be active while the SDK is in the *moving* state.  No breaking dart api changes.
- [Changed] Improved Android debug notifications.

## [0.3.4] - 2019-02-12
- [Changed] Update Gradle install docs.
- [Changed] Refactor Headless setup docs.
- [Added] New `Config` `persistMode`.  Allows one to determine exactly which events get persisted (geofences, locations, all or none).

## [0.3.3] - 2019-02-08
- [Fixed] Fixed bug in Android Headless event `BOOT` not receiving `State` data.
- [Changed] Changed the mechanism of storing Android Headless callback IDs to put them into `SharedPreferences` rather than relying upon existence as static class vars.
- [Fixed] Incorrect event-data provided to Headless `motionchange` event.
- [Fixed] Spell-check docs.

## [0.3.2] - 2019-01-31
- [Changed] Changed new Android DeviceSettings API to first send a request to native API, offering the developer a chance to show a Dialog to the user with instructions.

## [0.3.1] - 2019-01-30
- [Fixed] Constrain `device_info` dependency version.

## [0.3.0] - 2019-01-30
- [Added] New `schedule` feature for specifying "location+geofence" tracking or "geofence-only" in any schedule period.  See docs for Config.schedule.
- [Added] New `DeviceSettings` API for querying if Android app is ignoring battery optimization, in addition to methods for redirecting to "Ignore Battery Optimziations" settings screen.  Also introduces a method `DeviceSettings.showPowerManager` method for showing vendor-specific "Power Management" screen (eg: Huawei Settings->Battery->Launch).
```dart
bool isIgnoring = await DeviceSettings.isIgnoringBatteryOptimizations;
if (!isIgnoring) {
  // Show Android "Ignore Battery Optimizations" settings screen.
  DeviceSettings.showIgnoreBatteryOptimizations();
}

// Show Android vendor-specific "Power Manager" device settings screen (eg: Huawei)
DeviceSettings.showPowerManager();

```

- [Changed] Loosen `device_info` dependency version to allow `>=2.0.0`.

## [0.2.4] - 2019-01-12
- [Changed] Update `device_info` dependency -> `0.3.0`.
- [Changed] Android Service: Return `START_STICKY` instead of `START_REDELIVER_INTENT`.
- [Changed] Android: `setShowBadge(false)` on Android `NotificationChannel`.  Some users reporting that Android shows a badge-count on app icon when service is started / stopped.
- [Fixed] Android NPE in `watchPosition`
- [Added] Added method `getProviderState` for querying current state of location-services.
- [Added] Added method `requestPermission` for manually requesting location-permission (`#start`, `#getCurrentPosition`, `#watchPosition` etc, will already automatically request permission.

## [0.2.3]
- [Changed] Upgrade Android logger dependency to latest version (`logback`).
- [Fixed] Prevent Android foreground-service from auto-starting when location permission is revoked via Settings screen.
- [Fixed] NPE in Android HTTP Service when manual sync is called.  Probably a threading issue with multiple sync operations executed simultaneously.

## [0.2.2] - 2018-11-21
- [Fixed] Android headless callback ids can be of Class Long vs Integer when assemble for release vs debug.  Very odd, but added class-detection code.

## [0.2.1] - 2018-11-21
- [Fixed] Android headless configuration was setting incorrect headlessJobService class name.
- [Fixed] Android onActivityTerminate listener was incorrectly sending a signal to the native library when location permission activity was closed, incorrectly sending a signal that the app was terminated.  This would remove all event-listeners.
- [Added] Android SDK 28 requires new permission to use foreground-service.
- [Fixed] Do not calculate odometer with geofence events.  Android geofence event's location timestamp does not correspond with the actual time the geofence fires since Android is performing some heuristics in the background to ensure the potential geofence event is not a false positive.  The actual geofence event can fire some minutes in the future (ie: the location timestamp will be some minutues in the past).  Using geofence location in odometer calculations will corrupt the odometer value.
- [Fixed] Android could not dynamically update the `locationTemplate` / `geofenceTemplate` without `#stop` and application restart.
- [Fixed] Android `startGeofences` after revoking & re-granting permission would fail to launch the plugin's Service.

## [0.2.0] - 2018-11-12
- [Changed] Include `background_fetch` as an external dependency rather than including iOS TSBackgroundFetch.framework directly (this was always the plan).
- [Changed] In example, import flutter_map (Leaflet) instead of google_map (too buggy and not ready).

## [0.1.7] - 2018-10-17
- [Fixed] Issue #8.  Could not modify button-text of `locationAuthorizationAlert` after `#ready`.

## [0.1.6] - 2018-10-01
- [Changed] Refactor Android Headless mechanism.  Got rid of Android `JobScheduler` mechanism with more direct `EventBus`.  `JobScheduler` events were subject to Android time-slicing, causing headless events to arrive late.

## [0.1.5] - 2018-09-25
- [Fixed] warnings reported by Flutter publisher.

## [0.1.4] - 2018-09-25
- [Added] Android Headless mode.  See docs for `enableHeadless`.
- [Added] an "event list" screen to "AdvancedApp" example.
- [Added] `error` callback for `BackgroundGeolocation.onLocation`.
- [Fixed] Issue #5 podspec property `s.static_framework = true` to allow the plugin to work in apps where `use_frameworks!` directive is applied in `Podfile` (Thanks to @vova-beloded).

## [0.1.3] - 2018-09-20
- Implementing Dart-style docs with `dartdoc`
- Re-organize `/lib` dir; remove `/src` folder (hides classes from `dartdoc`).

## [0.1.2] - 2018-09-17
- Implementing advanced example app.
- Fix missing `removeListener` methods for `enabledchange`, `connectivitychange`
- Implement `destroyLog`
- Implement instrumented testing in `example/test_driver`.  See `examples/scripts/test.sh`
- Fix warnings.

## [0.1.1] - 2018-09-15
- Implementing advanced example app.
- Fix bug in `getGeofences`

## [0.1.0] - 2018-09-13
- First working beta release.

## [0.0.1] - 2018-07-07
- Reserve namespace.  Plugin not yet implemented.
