# Change Log

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
