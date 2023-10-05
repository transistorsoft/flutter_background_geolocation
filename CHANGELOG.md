# CHANGELOG

## 4.13.2 &mdash; 2023-10-05
* [Android] Fix error *Unhandled Exception: type 'Null' is not a subtype of type 'List<Object?>'* in `BackgroundGeolocation.geofences` / `getGeofence(uuid)`.
* [iOS] Rename iOS Obj-c classes, prefixing with `TS`.

## 4.13.1 &mdash; 2023-10-02
* [iOS] Fix "*Duplicate symbol error DummyPods_TSLocationManager*".

## 4.13.0 &mdash; 2023-09-28
* **Polygon Geofencing**:  The Background Geolocation SDK now supports *Polygon Geofences* (Geofences of any shape).  For more information, see API docs [`Geofence.vertices`](https://pub.dev/documentation/flutter_background_geolocation/latest/flt_background_geolocation/Geofence/vertices.html).  ℹ️ __*Polygon Geofencing*__ is [sold as a separate add-on](https://shop.transistorsoft.com/products/polygon-geofencing) (fully functional in *DEBUG* builds).

![](https://dl.dropbox.com/scl/fi/sboshfvar0h41azmb4tyv/polygon-geofencing-parc-outremont-400.png?rlkey=d2s0n3zbzu72e7s2gch9kxd4a&dl=1)
![](https://dl.dropbox.com/scl/fi/xz48myvjnpp8ko0l2tufg/polygon-geofencing-parc-lafontaine-400.png?rlkey=sf20ns959uj0a0fq0atmj55bz&dl=1)

* Remove `backup_rules.xml` from `AndroidManifest.xml` &mdash; it's causing conflicts with other plugins.
* [Android] Add proguard-rule for compilation of the android library to prevent from obfuscating the `BuildConfig` class to `a.a.class`, conflicting with other libraries.

## 4.12.3 &mdash; 2023-09-05
* [Android] Performance enhancements and error-checking.

## 4.12.2 &mdash; 2023-08-24

* [Android] Fix memory-leak in `.startBackgroundTask`:  If a `Task` timed-out and is "FORCE KILLED", it was never removed from a `List<Task>`.
* [Android] Fix `Exception NullPointerException:at com.transistorsoft.locationmanager.util.BackgroundTaskWorker.onStopped`

## 4.12.1 &mdash; 2023-08-23
* [iOS] Fix build failure "Use of '@import' when C++ modules are disabled"
* [Android] Modify Foreground-service management to use `stopSelfResult(startId)` instead of `stopSelf()`.  This could improve reports of Android ANR
`Context.startForeground`.
* [Android] Add sanity-check for invalid `Geofence` arguments (eg: invalid latitude/longitude).
* [Android] Add safety-checks in ForegroundService stop-handling.  There was a report of a *reproducible* crash while aggressively calling `.getCurrentPosition` in a `Timer` (eg: every second).
* [Android] Demote `HeartbeatService` from a Foreground Service to `AlarmManager` ONESHOT.  :warning: In your `onHeartbeat` event, if you intend to perform any kind of asynchronous function, you should wrap it inside `BackgroundGeolocation.startBackgroundTask` in order to prevents the OS from suspending your app before your task is complete:

```dart
BacckgroundGeolocation.onHeartbeat((event) async {
  print("[onHeartbeat] $event");
  // First register a background-task.
  var taskId = await BackgroundGeolocation.startBackgroundTask();
  try {
    // Now you're free to perform long-running tasks, such as getCurrentPosition()
    var location = await BackgroundGeolocation.getCurrentPosition(
      samples: 3,
      timeout: 30,
      extras: {
        "event": "heartbeat"
      }
    );
    print("[onHeartbeat] location: $location");
  } catch(error) {
    print("[getCurrentPosition] ERROR: $error");
  }
  // Be sure to singal completion of your background-task:
  BackgroundGeolocation.stopBackgroundTask(taskId);
});
```

* [Android] Fix NPE iterating a `List` in `AbstractService`. 
* [Android] If a `SingleLocationRequest` error occurs and at least one sample exits, prefer to resolve the request successfully rather than firing the error (eg: `getCurrentPosition`, `motionchange`, `providerchange` requests).

## 4.12.0 &mdash; 2023-08-16
* [Android] :warning: If you have the following elements defined in your __`AndroidManifest.xml`__, __DELETE__ them:
```diff
-       <service android:name="com.transistorsoft.locationmanager.service.TrackingService" android:foregroundServiceType="location" />
-       <service android:name="com.transistorsoft.locationmanager.service.LocationRequestService" android:foregroundServiceType="location" />
```
* [Android] Re-factor getCurrentPosition to prefer more recent location vs more accuracy (within limits)
* [Android] Android 14 (API 34) support:  Android 14 is more strict with scheduling `AlarmManager` "exact alarms" (which the plugin does take advantage of).  If you wish the plugin to use `AlarmManager` "exact alarms" in your app, you must now explicitly define that permission in your own `AndroidManifest`:
```xml
<manifest>
    <uses-permission android:minSdkVersion="34" android:name="android.permission.USE_EXACT_ALARM" />
</manifest>
```

* [Android] Android 14 (API 34) support:  Re-factor BackgroundTaskService to use `WorkManager` instead of a foreground-service.
* [Android] Android 14 (API 34) support: Due to new runtime permission requirements on `AlarmManager` exact alarms (`android.permission.SCHEDULE_EXACT_ALARM`), the plugin can no longer rely upon launching a foreground-service using an exact alarm.  Instead, the plugin will create a geofence around the current position (configured with `initialTriggerEntry`) to hopefully immediately launch a foreground-service to handle the fake geofence event, since Android allows foreground-service launches due to Geofencing events.
* [Android] Android 14 (API 34) support:  All foreground-services now require an `android:foregroundServiceType` in the plugin's `AndroidManifest` (handled automatically by the plugin).
* [Android] Android 14 (API 34) support: Fix error "*One of RECEIVER_EXPORTED or RECEIVER_NOT_EXPORTED should be specified*" in `DeviceSettings.startMonitoringPowerSaveChanges`. 

## 4.11.1 &mdash; 2023-06-09
* Fix nullsafety issue in `TransistorAuthorizationToken.destroy`.
* [Android] Log `ApiException.getStatusCode()` if native `addGeofence` method fails.
* Update /example app for full nullsafety.

## 4.11.0 &mdash; 2023-05-04
* [Android] Gradle v8 now requires `namespace` attribute in gradle files.
* [iOS] iOS 16.4 made a major change to location-services, exposed only when `Config.showsBackgroundLocationIndicator` is `false` (the default).  As a result of this change, `Config.showsBackgroundLocationIndicator` will now default to `true`.

## 4.10.3 &mdash; 2023-04-19
* [Android] Upgrade `logback-android` dependency to `3.0.0` (`org.slf4j-api` to `2.0.7).

## 4.10.2 &mdash; 2023-04-12
* [Android] Fix String concatenation issue on Turkish devices where method-name composed for use with reflection is incorrectly capitalized (ie: `isMoving -> `setIsMoving` is incorrectly capitalized with Turkish capital as `setİsMoving`.  Simply enforce `Locale.ENGLISH` when performing `String.toUpperCase(Locale.ENGLISH)`.

* [iOS] Fix bug in TSScheduler.  When schedule was cleared via .setConfig, only the State.schedulerEnabled property was set to false, but the TSScheduler singleton contained an internal 'enabled' property which was not reset to false.  Solution was to simply call stop() method upon TSScheduler singleton.

## 4.10.1 &mdash; 2023-03-30
* [Android] Bump default `hmsLocationVersion = 6.9.0.300`.  There are reports of Google rejecting apps due to older huawei HMS dependenc
ies.
* [Android] Fix `ClassCastException` related to Motion API error

## 4.10.0 &mdash; 2023-03-29
* [Android] Introduce __Huawei HMS Support__.  Requires a separate license key [purchased here](https://shop.transistorsoft.com/collections/frontpage/products/huawei-background-geolocation).
* [iOS] Fix for iOS 16.4.  iOS 16.4 introduces changes to CoreLocation behaviour when using Config.showsBackgroundLocationIndi
cator: false.
* [Android] Added extra logic in a location error-handler to mitigate against a possible edge-case where a location-error fetching the onMotionChange position could possibly result in an infinite loop, causing a stackoverflow exception:
```
at com.transistorsoft.locationmanager.service.TrackingService.changePace(TrackingService.java:264)
at com.transistorsoft.locationmanager.service.TrackingService$c.onError(TrackingService.java:69)
at com.transistorsoft.locationmanager.location.SingleLocationRequest.onError(SingleLocationRequest.java:18)
at com.transistorsoft.locationmanager.location.SingleLocationRequest.start(SingleLocationRequest.java:71)
at com.transistorsoft.locationmanager.location.TSLocationManager.getCurrentPosition(TSLocationManager.java:3)
at com.transistorsoft.locationmanager.service.TrackingService.changePace(TrackingService.java:321)
at com.transistorsoft.locationmanager.service.TrackingService$c.onError(TrackingService.java:69)
at com.transistorsoft.locationmanager.location.SingleLocationRequest.onError(SingleLocationRequest.java:18)
at com.transistorsoft.locationmanager.location.SingleLocationRequest.start(SingleLocationRequest.java:71)
at com.transistorsoft.locationmanager.location.TSLocationManager.getCurrentPosition(TSLocationManager.java:3)
at com.transistorsoft.locationmanager.service.TrackingService.changePace(TrackingService.java:321)
at com.transistorsoft.locationmanager.service.TrackingService$c.onError(TrackingService.java:69)
at com.transistorsoft.locationmanager.location.SingleLocationRequest.onError(SingleLocationRequest.java:18)
at com.transistorsoft.locationmanager.location.SingleLocationRequest.start(SingleLocationRequest.java:71)
.
.
.
```

## 4.9.0 &mdash; 2023-02-01
* [Fixed][Android] Implement support for `play-services-location v21` (`ext.playServicesLocationVersion` in your `android/build.gradle`).  The plugin can now work with either `<= v20` or `>= v21`.

## 4.8.7 &mdash; 2023-01-25
* [Fixed] Resolve minor dart static analysis warnings (mostly to do with curly braces).

## 4.8.6 &mdash; 2023-01-19
* [Changed] __Android__ Update `logback-android` version.

## 4.8.5 &mdash; 2022-12-12
* [Fixed] __Android__: Catch `Fatal Exception: java.lang.IllegalArgumentException: NetworkCallback was already unregistered`
* [Fixed] __Android__ It has been discovered that the Android logger `logback-android` has not been automatically clearing all expired records (`Config.logMaxDays`) from the log database.  The `logback-android` database consists of three tables and only *one* was being cleared (see https://github.com/tony19/logback-android/pull/214), resulting in a constantly growing database (where `logLevel > LOG_LEVEL_OFF`).  This version of the plugin will alter the `logback-android` database tables with `ON DELETE CASCADE` to ensure all log-data is properly removed.
* [Added] Added two new *HTTP RPC* commands `stopSchedule` and `startSchedule` (See API docs *HTTP Guide* for more information).

## 4.8.4 &mdash; 2022-11-03
* [Fixed] Fixed bug in `onLocation` error-handler.  If multiple onLocation event-handlers are registered, only the first registered error callback would be executed (once for each listener) when a LocationError occurs.

## 4.8.3 &mdash; 2022-10-27
* [Android] add `@pragma('vm:entry-point') to lib's `_headlessCallbackDispatcher`, required for *release* builds on Flutter >= 3.3.0.

## 4.8.2  &mdash; 2022-10-26
* [Android] Fix logic error with `getCurrentPosition` not respecting `timeout`.
* [Android] `play-services:location` has [introduced a breaking change](https://developers.google.com/android/guides/releases#october_13_2022) in `v21`, breaking the plugin.  `googlePlayServicesLocationVersion` will be capped with a maximum of `v20`.  The next major release (`4.10.0`) will set a minimum required version of `v21`.

## 4.8.1 &mdash; 2022-10-14
* [iOS] Rebuild `TSLocationManager.xcframework` with *XCode 13*.
* [Android] Remove obsolete steps from Android Setup instructions.

## 4.8.0 &mdash; 2022-09-29
* [iOS] Build `TSLocationManager.xcframework` with *XCode 14*.
* [Android] Add new Config Notification.channelId for custom customizing the NotificationChannel id.  Some use
rs have an existing foreground-service and NotificationChannel so wish to have the plugin's foreground-service
s share the same notification and channel.  This option should generally not be used.
* [Android] Add permission `android.permission.POST_NOTIFICATIONS` for Android 13 (targetSdkVersion 33).  Requ
ired to allow enabling notifications in Settings->Apps.
* [Android] Add new Config option `Authorization.refreshHeaders` for full control over HTTP headers sent to `Authorization.refreshUrl` when refreshing auth token.
* [Android] Add `null` check when executing `PowerManager.isPowerSaveMode()`
* [Android] Add new `Config.disableProviderChangeRecord (default false)` to allow disabling the automatical HTTP POST of the `onProviderChange` location record.  Some users do not want this automatically uploaded locatio
n whenever the state of location-services is changed (eg: Location-services disabled, Airplane mode, etc).
* [Android] Fix bug with `disableMotionActivityUpdates: true` and calling `.start()` followed immediately by `.changePace(true)`.  The SDK would fail to enter the moving state, entering the stationary state instead.

## 4.7.2 &mdash; 2022-09-06
* Add new iOS 15 `CLLocation` attribute `Location.ellipsoidal_altitude` *The altitude as a height above the World Geodetic System 1984 (WGS84) ellipsoid, measured in meters*.  Android `Location.altitude` has always returned *ellipsoidal altutude*, so both `Location.altitude` and `Location.ellipsoidal_altitude` will return the same value.

## 4.7.1 &mdash; 2022-08-08
* [Android] Fix `java.lang.IllegalArgumentException `TSProviderManager.handleProviderChangeEvent`.
* [Android] `startOnBoot: false` with `stopOnTerminate: false` could start-on-boot.
* [Android] `State.enabled` returned by calling `.stop()` returns `true` due to implementation running in a background-thread but `callback` executed immediately on the main-thread.  However, requesting `.state` immediately after calling `.stop` *would* return the correct value of `State.enabled`.
* [Android] Fix `notification.sticky` not being respected.


## 4.7.0 &mdash; 2022-06-21
* [Android] Fix bug in `onProviderChange` event:  not properly detecting when location-services disabled.
* [Android] __Android 12__:  Guard `Context.startForegroundService` with `try / catch`: the plugin will now catch exception `ForegroundServiceStartNotAllowedException` and automatically retry with an `AlarmManager` *oneShot* event.
* [Android] __Android 12__: Refactor foreground-service management for Android 12:  A way has been found to restore the traditional behaviour of foreground-services, allowing them to stop when no longer required (eg: where the plugin is in the stationary state).
* [Android] Refactor application life-cycle management.  Remove deprecated permission `android.permission.GET_TASKS` traditionally used for detecting when the app has been terminated.  The new life-cycle mgmt system can detect Android headless-mode in a much more elegant manner.
* [Android] Better handling for `WhenInUse` behaviour:  The plugin will not allow `.changePace(true)` to be executed when the app is in the background (since Android forbids location-services to initiated in the background with `WhenInUse`).
* [Android] Refactor `useSignificantChangesOnly` behaviour.  Will use a default `motionTriggerDelay` with minimum 60000ms, minimum `distanceFilter: 250` and enforced `stopTimeout: 20`.
* [iOS] iOS 15 has finally implemented *Mock Location Detection*.  `location.mock` will now be present for iOS when the location is mocked, just like Android.

## 4.6.3 &mdash; 2022-05-27
* [Android] Fix bug in Android 12 support for executing `.start()` in background while terminated.  Used `JobScheduler` ONESHOT instead of `AlarmManager`.
* [Android] Plugin could be placed into an infinite loop requesting motionchange position in some cases.
* [Android] Address `ConcurrentModificationException` in `onPermissionGranted`.

## 4.6.2 &mdash; 2022-05-11
* [Android] Fix issue device reboot behaviour related to change in `4.6.1` for Android 11.  Could produce multiple motionchange requests after airplane-mode togged off after reboot.
## 4.6.1 &mdash; 2022-05-11
* [Android] If on device reboot location-services fails to provide a location (eg: timeout, airplane mode), the plugin would rely on motion API events to try again.  This is a problem if the motion api is disabled.  Instead, the SDK will keep trying to retrieve a location.
* [Android] Android 12 support for `ForegroundServiceStartNotAllowedException`:  immediately launch the SDK's `TrackingService` as soon as `.start()` executes.  If a location-timeout occurs while fetching the onMotionChange position after device reboot with `startOnBoot: true`, the `ForegroundServiceStartNotAllowedException` could be raised.
* [Android] Add two new attributes `android:enabled` and `android:permission` to the SDK's built-in `BootReceiver`:
```xml
<receiver android:name="com.transistorsoft.locationmanager.BootReceiver" android:enabled="true" android:exported="false" android:permission="android.permission.RECEIVE_BOOT_COMPLETED">
```

## 4.6.0 &mdash; 2022-05-06
* [Android] Android 12 support for executing `.start()` and `.getCurrentPosition()` while the plugin is disabled and in the background.  This is a bypass of new Android 12 restrictions for starting foreground-services in the background by taking advantage of AlarmManager.

```
Fatal Exception: android.app.ForegroundServiceStartNotAllowedException: startForegroundService() not allowed due to mAllowStartForeground false: service
```

## 4.5.0 &mdash; 2022-04-29
* [Android] Add a few extra manufacturer-specific `Intent` for `DeviceSettings.showPowerManager()`.
* [Android] Minimum `compileSdkVersion 31` is now required.
* [Android] Now that a minimum `targetSdkVersion 29` is required to release an Android app to *Play Store*, the SDK's `AndroidManifest` now automatically applies `android:foregroundServiceType="location"` to all required `Service` declarations.  You no longer need to manually provide overrides in your own `AndroidManifest`, ie:
```diff
<manifest>
    <application>
-       <service android:name="com.transistorsoft.locationmanager.service.TrackingService" android:foregroundServiceType="location" />
-       <service android:name="com.transistorsoft.locationmanager.service.LocationRequestService" android:foregroundServiceType="location" />
    </application>
</manifest>
```

## 4.4.0 &mdash; 2022-03-30
* [Android] Upgrade `android-permissions` dependency from 0.1.8 -> 2.1.6.
* [iOS] Rebuild `TSLocationManager.xcframework` with XCode 13.3

## 4.3.5 &mdash; 2022-03-29
* Config.authorization:  append Config.headers with request to refreshUrl

## 4.3.4 &mdash; 2022-02-16
* [Android] While testing adding 20k geofences, the Logger can cause an `OutOfMemory` error.  Define a dedicated thread executor `Executors.newFixedThreadPool(2)` for posting log messages in background.
* [iOS] remote event-listeners in onAppTerminate to prevent onEnabledChange event being fired in a dying app configured for `stopOnTerminate: true`

## 4.3.3 &mdash; 2022-01-19
* [Fixed][iOS] Regression bug in iOS SAS authorization strategy
* [Fixed][Android] logLevel not defaulting to LOG_LEVEL_OFF on first install.
* [Fixed][Android] Some device report that locationAuthorizationAlert is not auto-hiding the invisible TSLocationManagerActivity in some cases.
* [Changed] Provide default values for Location parameters defined as `late` (Location.event, Location.mock).  Location.event will be empty-string when there is no corresponding event.

## 4.3.2 &mdash; 2021-11-24
* [Fixed][iOS} iOS Config.authorization did not allow http response status 201

## 4.3.1 &mdash; 2021-10-01
* [Fixed][Android] Android custom layout (`Config.notification.layout`) events not working in Headless mode.
* [Fixed] Fix to `reset:false` behaviour.  When `.ready()` was called a 2nd time, the plugin would apply the config anyway, bypassing `reset:false`.
* [Added] New `Authorization.strategy "SAS"` (alternative to default `JWT`).

## 4.3.0 &mdash; 2021-09-13

* [Added][Android] Implement new Android 12 "reduced accuracy" mechanism`requestTemporaryFullAccuracy`.

## [4.2.3] &mdash; 2021-07-02
* [Fixed][iOS] `Authorization.refreshPayload refreshToken` was not performing a String replace on the `{refreshToken}` template, instead over-writing the entire string.  Eg:  if provided with `'refresh_token': 'Bearer {refreshToken}`, `Bearer ` would be over-written and replaced with only the refresh-token.

## [4.2.2] &mdash; 2021-07-01
* [Fixed][Android] Fixed crash reported by Huawei device, where verticalAccuracy returns NaN.
* [Fixed][iOS] add config change listeners for `heartbeatInterval` and `preventSuspend` to dynamically update interval when changed with `setConfig`.

## [4.2.1] &mdash; 2021-08-03
* [Changed][Android] Revert default `okHttpVersion` back to `3.12.13`.  `4.x` requires `minSdkVersion 21` (*Android 5*).

## [4.2.0] &mdash; 2021-08-02
* [Changed][Android] Update Android default `okhttp` version to `4.9.1`.
* [Changed][Android] Update Android `eventbus` to `3.2.0`.
* [Changed][Android] Update Android `android-permissions` to import from *MavenCentral* instead of deprecated `jCenter`.
* [Changed][iOS] Re-compile iOS `TSLocationManager` using XCode 12.4 instead of `12.5.1`.
* [Fixed][Android] Fix an edge-case requesting motion permission.  If `getCurrentPosition()` is executed before `.start()`, the Android SDK fails to request motion permission.

## 4.0.2 &mdash; 2021-06-11
* [Fixed][iOS] Reports 2 reports of iOS crash `NSInvalidArgumentException (TSLocation.m line 178)` with iOS 14
.x.  Wrap JSON serialization in @try/@catch block.  iOS JSON serialization docs state the supplied NSError err
or ref should report problems but it seems this is only "sometimes" now.

## 4.0.1 &mdash; 2021-06-09
- Same as previous version.  Simply performed flutter format on dart code to satisfy dart analyzer on pub.dev

## 4.0.0 &mdash; 2021-06-09
* Release nullsafety version as 4.0.0.
* [Changed] Add extra logic block to isMainActivityActive to compare launchActivity with baseActivity className

## 4.0.0-nullsafety.7 &mdash; 2021-06-07
* [Changed] `Config.authorization` will perform regexp on the received response, searching for keys such as `accessToken`, `access_token`, `refreshToken`, `refresh_token`, rather than performing regexp on the data itself.

## 4.0.0-nullsafety.6 &mdash; 2021-04-26
* [Fixed] Nullsafety casting bug in `DeviceInfo`, `DeviceSettings`.

## 4.0.0-nullsafety.5 &mdash; 2021-04-22
* [Fixed][Android] Fix threading issue `ConcurrentMmodificationException` in `TSConfig`.

## 4.0.0-nullsafety.4 &mdash; 2021-04-20
* [Fixed][Android] Don't synchronize access to ThreadPool.  Addresses ANR issues
* [Fixed] `DeviceSettings` `_CastError (type 'Future<dynamic>' is not a subtype of type 'FutureOr<bool>' in type cast)`

## 4.0.0-nullsafety.3 &mdash; 2021-04-19

* [Fixed][Android] Implmementing State.didDeviceReboot in previous version introduced a source of ANR due time required to generate and persist JSON Config.  Solution is to simply perform in Background-thread.

## 4.0.0-nullsafety.2 &mdash; 2021-04-08

* [Added] New `State` param `State.didDeviceReboot`, signals if the device was rebooted.
* [Added] Added new `locationTemplate` property `timestampMeta`.

## 4.0.0-nullsafety.1 &mdash; 2021-04-01

* [Fixed][Android] Flutter 2 breaks Android Headless mode with null-pointer exception.

## 4.0.0-nullsafety.0 &mdash; 2021-03-22

* [Added] Dart nullsafety.

## 2.1.0 &mdash; 2021-06-07
- [Changed] `Config.authorization` will perform regexp on the received response, searching for keys such as `accessToken`, `access_token`, `refreshToken`, `refresh_token`.

## 2.0.5 &mdash; 2021-04-21
- [Fixed][Android] Fix threading issue `ConcurrentMmodificationException` in `TSConfig`

## 2.0.4 &mdash; 2021-04-20
* [Fixed][Android] Don't synchronize access to ThreadPool.  Addresses ANR issues.

## 2.0.3 &mdash; 2021-04-18
* [Fixed][Android] Implmementing State.didDeviceReboot in previous version introduced a source of ANR due time required to generate and persist JSON Config.  Solution is to simply perform in Background-thread.

## 2.0.2 &mdash; 2021-04-08

* [Added] New `State` param `State.didDeviceReboot`, signals if the device was rebooted.
* [Added] Added new `locationTemplate` property `timestampMeta`.

## 2.0.1 &mdash; 2021-03-29

* [Fixed][Android] Flutter 2 did something to break Headless registration.

## 2.0.0 &mdash; 2021-03-16

* [Changed][iOS] Migrate `TSLocationManager.framework` to new `.xcframework` for *MacCatalyst* support with new Apple silcon.

### :warning: Breaking Change:  Requires `cocoapods >= 1.10+`.

*iOS'* new `.xcframework` requires *cocoapods >= 1.10+*:

```console
$ pod --version
// if < 1.10.0
$ sudo gem install cocoapods
```

### :warning: Breaking Change: `background_fetch`.

- See [Breaking Changes with `background_fetch@0.7.0`](https://github.com/transistorsoft/flutter_background_fetch/blob/master/CHANGELOG.md#070---2021-02-11)

## 1.11.1 &mdash; 2021-02-17

- [Fixed][iOS] `startOnBoot: false` was not being respected.
- [Fixed][Android] If multiple simultaneous calls to `getCurrentPosition` are executed, the location permission handler could hang and not return, causing neither `getCurrentPosition` request to execute.

## 1.11.0 &mdash; 2021-01-26

- [Changed] Remove `Config.encrypt` feature.  This feature has always been flagging a Security Issue with Google Play Console and now the iOS `TSLocationManager` is being flagged for a virus by *Avast* *MacOS:Pirrit-CS[PUP]*.  This seems to be a false-positive due to importing [RNCryptor](https://github.com/RNCryptor/RNCryptor) package.
- [Fixed][Android] If `stopAfterElapsedMinutes` was configured with a value greater-than `stopTimeout`, the event would fail to fire.

## 1.10.3 &mdash; 2020-11-05

- [Fixed][iOS] Fix issue with iOS buffer-timer with requestPermission.  Could execute callback twice.

## 1.10.2 &mdash; 2020-11-03

- [Fixed][iOS] When requesting `WhenInUse` location permission, if user grants "Allow Once" then you attempt to upgrade to `Always`, iOS simply does nothing and the `requestPermission` callback would not be called.  Implemented a `500ms` buffer timer to detect if the iOS showed a system dialog (signalled by the firing of `WillResignActive` life-cycle notification).  If the app does *not* `WillResignActive`, the buffer timer will fire, causing the callback to `requestPermission` to fire.
- [Fixed][Android] Issue with `requestPermission` not showing `backgroundPermissionRationale` dialog on `targetSdkVersion 29` when using `locationAuthorizationRequest: 'WhenInUse'` followed by upgrade to `Always`.
- [Added] Added two new `Location.coords` attributes `speed_accuracy` and `heading_accuracy`.
- [Fixed][iOS] fix bug providing wrong Array of records to `sync` method when no HTTP service is configured.
- [Fixed][Android] Add extra logic for `isMainActivityActive` to detect when `TSLocationManagerActivity` is active.

## 1.10.1 &mdash; 2020-09-30

- [Fixed][Android] `isMainActivityActive` reported incorrect results for Android apps configured with "product flavors".  This would cause the SDK to fail to recognize app is in "headless" state and fail to transmit headless events.
- [Added][Android] `Location.coords.altitudeAccuracy` was not being returned.
- [Added][Android] Android 11 `targetSdkVersion 30` support for new Android background location permission with new `Config.backgroundLocationRationale`.  Android 11 has [changed location authorization](https://developer.android.com/preview/privacy/location) and no longer offers the __`[Allow all the time]`__ button on the location authorization dialog.  Instead, Android now offers a hook to present a custom dialog to the user where you will explain exactly why you require _"Allow all the time"_ location permission.  This dialog can forward the user directly to your application's __Location Permissions__ screen, where the user must *explicity* authorize __`[Allow all the time]`__.  The Background Geolocation SDK will present this dialog, which can be customized with `Config.backgroundPermissionRationale`.

![](https://dl.dropbox.com/s/343nbrzpaavfser/android11-location-authorization-rn.gif?dl=1)

```dart
BackgroundGeolocation.ready(Config(
  locationAuthorizationRequest: 'Always',
  backgroundPermissionRationale: PermissionRationale(
    title: "Allow access to this device's location in the background?",
    message: "In order to allow X, Y and Z in the background, please enable 'Allow all the time' permission",
    positiveAction: "Change to Allow all the time",
    negativeAction: "Cancel"
  )
));
```
- [Fixed][iOS] Add intelligence to iOS preventSuspend logic to determine distance from stationaryLocation using configured stationaryRadius rather than calculated based upon accuracy of stationaryLocation.  If a stationaryLocation were recorded having a poor accuracy (eg: 1000), the device would have to walk at least 1000 meters before preventSuspend would engage tracking-state.
- [Fixed][Android] Android LocationRequestService, used for getCurrentPosition and motionChange position, could remain running after entering stationary state if a LocationAvailability event was received before the service was shut down.
- [Fixed][iOS] Ignore didChangeAuthorizationStatus events when disabled and no requestPermissionCallback exists.  The plugin could possibly respond to 3rd-party permission plugin events.

## 1.10.0+1 &mdash; 2020-08-21
- [Docs] Improve docs for `Location` class; adding missing docs for `Coords`, `Battery`, `Activity`.

## 1.10.0 &mdash 2020-08-20

- [Added][iOS] iOS 14 introduces a new switch on the initial location authorization dialog, allowing the user to "disable precise location".  In support of this, a new method `BackgroundGeolocation.requestTemporaryFullAccuracy` has been added for requesting the user enable "temporary high accuracy" (until the next launch of your app), in addition to a new attribute `ProviderChangeEvent.accuracyAuthorization` for learning its state in the event `onProviderChange`:
![](https://dl.dropbox.com/s/dj93xpg51vspqk0/ios-14-precise-on.png?dl=1)

```dart
void _onProviderChange(bg.ProviderChangeEvent event) async {
  print("[providerchange] - $event");
  // Did the user disable precise locadtion in iOS 14+?
  if (event.accuracyAuthorization == bg.ProviderChangeEvent.ACCURACY_AUTHORIZATION_REDUCED) {
    // Supply "Purpose" key from Info.plist as 1st argument.
    bg.BackgroundGeolocation.requestTemporaryFullAccuracy("DemoPurpose").then((int accuracyAuthorization) {
      if (accuracyAuthorization == bg.ProviderChangeEvent.ACCURACY_AUTHORIZATION_FULL) {
        print("[requestTemporaryFullAccuracy] GRANTED:  $accuracyAuthorization");
      } else {
        print("[requestTemporaryFullAccuracy] DENIED:  $accuracyAuthorization");
      }
    }).catchError((error) {
      print("[requestTemporaryFullAccuracy] FAILED TO SHOW DIALOG: $error");
    });
  }
}
```
These changes are fully compatible with Android, which will always return `ProviderChange.ACCURACY_AUTHORIZATION_FULL`

- [Added][Android] Add `onChange` listener for `config.locationAuthorizationRequest` to request location-authorization.
- [Changed][iOS] If `locationAuthorizationRequest: 'WhenInUse'` and the user has granted the higher level of `Always` authorization, do not show `locationAuthorizationAlert`.
- [Added][iOS] Apple has changed the behaviour of location authorization &mdash; if an app initially requests `When In Use` location authorization then later requests `Always` authorization, iOS will *immediately* show the authorization upgrade dialog (`[Keep using When in Use`] / `[Change to Always allow]`).
- [Changed][iOS] When `locationAuthorizationRequest: 'Always'`, the SDK will now initially request `WhenInUse` followed immediately with another request for `Always`, rather than having to wait an unknown length of time for iOS to show the authorization upgrade dialog:

**Example**
```dart
await bg.BackgroundGeolocation.ready(bg.Config(
  locationAuthorizationRequest: 'WhenInUse'
));

//
// some time later -- could be immediately after, hours later, days later, etc.
//
// Simply update config to "Always" -- iOS will automatically show the authorization upgrade dialog.
await bg.BackgroundGeolocation.setConfig(bg.Config(
  locationAuthorizationRequest: 'Always'
));
```
![](https://dl.dropbox.com/s/0alq10i4pcm2o9q/ios-when-in-use-to-always-CHANGELOG.gif?dl=1)

- [Fixed][Android] Extras provided with a `List` of `Map` fail to recursively convert the Map to JSON, eg:
```dart
BackgroundGeolocation.ready(bg.Config(
  extras: {
    "foo": [{  // <-- List of Map won't be converted to JSON
        "foo": "bar"
    }]
  }
))
```

- [Fixed][iOS] when `getCurrentPosition` is provided with `extras`, those `extras` overwrite any configured `Config.extras` rather than merging.
- [Fixed][Android] When cancelling Alarms, use `FLAG_UPDATE_CURRENT` instead of `FLAG_CANCEL_CURRENT` -- there are [reports](https://stackoverflow.com/questions/29344971/java-lang-securityexception-too-many-alarms-500-registered-from-pid-10790-u) of older Samsung devices failing to garbadge-collect Alarms, causing the number of alarms to exceed maximum 500, generating an exception.

## 1.9.3 - 2020-07-16
- No changes from `1.9.2`.  This version is merely a bump to satisfy pub.dev penalty for placing http urls in README instead of https.

## 1.9.2 - 2020-07-08
- [Added][Android] New Config option `Notification.sticky` (default `false`) for allowing the Android foreground-service notification to be always shown.  The default behavior is the only show the notification when the SDK is in the *moving* state, but Some developers have expressed the need to provide full disclosure to their users when the SDK is enabled, regardless if the device is stationary with location-services OFF.
- [Added] Support for providing a native "beforeInsert" block in iOS `AppDelegate.m` and Android `Application.java` / `Application.kt`.  The returned object will be inserted into the SDK's SQLite database and uploaded to your `Config.url`.
__iOS__ `AppDelegate.m`
```obj-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GeneratedPluginRegistrant registerWithRegistry:self];

    // [OPTIONAL] This block is called before a location is inserted into the background_geolocation SQLite database.
    // - The returned NSDictionary will be inserted.
    // - If you return nil, no record will be inserted.
    TSLocationManager *bgGeo = [TSLocationManager sharedInstance];
    bgGeo.beforeInsertBlock = ^NSDictionary *(TSLocation *tsLocation) {
        CLLocation *location = tsLocation.location;

        NSLog(@"[beforeInsertBlock] %@: %@", tsLocation.uuid, location);

        // Return a custom schema or nil to cancel SQLite insert.
        return @{
            @"lat": @(location.coordinate.latitude),
            @"lng": @(location.coordinate.longitude),
            @"battery": @{
                @"level": tsLocation.batteryLevel,
                @"is_charging": @(tsLocation.batteryIsCharging)
            }
        };
    };

    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}
```
__Android__ `Application.java`
```java
public class Application  extends FlutterApplication {
    @Override
    public void onCreate() {
        super.onCreate();

        BackgroundGeolocation.getInstance(this).setBeforeInsertBlock(new TSBeforeInsertBlock() {
            @Override
            public JSONObject onBeforeInsert(TSLocation tsLocation) {
                Location location = tsLocation.getLocation();
                JSONObject json = new JSONObject();
                JSONObject battery = new JSONObject();
                try {
                    json.put("lat", location.getLatitude());
                    json.put("lng", location.getLongitude());

                    battery.put("level", tsLocation.getBatteryLevel());
                    battery.put("is_charging", tsLocation.getBatteryIsCharging());
                    json.put("battery", battery);
                    return json;
                } catch (JSONException e) {
                    e.printStackTrace();
                    return null;
                }
            }
        });
    }
}
```

## 1.9.1 - 2020-07-02

- [Fixed][iOS] Geofence `EXIT` sometimes not firing when using `notifyOnDwell`.
- [Changed][Android] Refactor geofencing-only mode to not initiate "Infinite Geofencing" when the total number of added geofences is `< 99` (the maximum number of simultaneous geofences that can be monitored on Android).  This prevents the SDK from periodically requesting location to query "geofences within `geofenceProximityRadius`".  iOS already has this behaviour (where its maximum simultaneous geofences is `19`).
- [Fixed][iOS] When using `#ready` with `reset: true` (the default), and `autoSync: false`, the SDK could initiate HTTP service if any records exist within plugin's SQLite database, since `reset: true` causes `autoSync: true` for a fraction of a millisecond, initiating the HTTP Service.

## 1.9.0 - 2020-06-15
- [Fixed][Android] `com.android.tools.build:gradle:4.0.0` no longer allows "*direct local aar dependencies*".  The Android Setup now requires a custom __`maven url`__ to be added to your app's root __`android/build.gradle`__:

A new step is required for *Android Setup*

:open_file_folder: `android/build.gradle`:

```diff

allprojects {
    repositories {
        google()
        jcenter()
+       maven {
+           // [required] flutter_background_geolocation
+           url "${project(':flutter_background_geolocation').projectDir}/libs"
+       }
+       maven {
+           // [required] background_fetch
+           url "${project(':background_fetch').projectDir}/libs"
+       }
    }
}
```

You might then clean your android project:

```sh
cd android
./gradlew clean
```

- [Fixed][Android] `onConnectivityChange` can report incorrect value for `enabled` when toggling between Wifi Off / Airplane mode.

## 1.8.0 - 2020-05-28
- [Fixed][Android] `onGeofence` event-handler fails to be fired when `maxRecordsToPersist: 0`.
- [Fixed][Android] `requestPermission` method was always returning `AUTHORIZATION_STATUS_ALWAYS` even when *When in Use* was selected.
- [Fixed] `insertLocation` exception (issue #220)
- [Fixed][iOS] When using `disableStopDetection: true` with `pausesLocationUpdatesAutomatically: true`, the `CLLocationManagerDelegate didPauseLocationUpdates` fired a `motionchange` with `isMoving: true` (should be `false`).
- [Fixed][Android] Fix `@UIThread` issue executing location error handler on background-thread.
- [Changed][Android] Gradle import `tslocationmanager` using `api` instead of `implementation` in order to allow overriding SDK's `AndroidManifest` elements (eg: `<service>` elements).
- [Fixed][iOS] When upgrading from a version previous `<1.4.0`, if any records exist within plugin's SQLite database, those records could fail to be properly migrated to new schema.
- [Added] New method `BackgroundGeolocation.destroyLocation(uuid)` for destroying a single location by `Location.uuid`.
- [Changed] Android library `tslocationmanager.aar` is now compiled using `androidx`.  For backwards-compatibility with those how haven't migrated to `androidX`, a *reverse-jetified* build is included.  Usage is detected automatically based upon `android.useAndroidX` in one's `gradle.properties`.
- [Fixed] Allow firebase-adapter to validate license flavors on same key (eg: .development, .staging).
- [Fixed][iOS] iOS geofence listeners on `onGeofence` method *could possibly* fail to be called when a geofence event causes iOS to re-launch the app in the background (this would **not** prevent the plugin posting the geofence event to your `Config.url`, only a failure of the dart `onGeofence` to be fired).

## 1.7.3 - 2020-04-14
- [Fixed] [iOS] Bug in Logger methods.  Args are received in native side with NSArray, not NSDictionary

## 1.7.2 - 2020-04-08
- [Added] [Android] Add new `Config.motionTriggerDelay (milliseconds)` for preventing false-positive triggering of location-tracking (while walking around one's house, for example).  If the motion API triggers back to `still` before `motionTriggerDelay` expires, triggering to the *moving* state will be cancelled.
- [Fixed] Address issue with rare reports of iOS crashing with error referencing `SOMotionDetector.m`.
- [Fixed] Odometer issue with Android/iOS:  Do not persist `lastOdometerLocation` when plugin is disabled.

## 1.7.1 - 2020-03-20
- [Added] [Android] Add an boolean extra `TSLocationManager: true` to the launch Intent of the foreground-notification, allowing application developers to determine when their app was launched due to a click on the foreground-notification.
- [Fixed] `Authorization` bug in refresh-url response-data recursive iterator.  Do not recurse into arrays in token-refresh response from server (`tokens` are not likely to be found there, anyway).
- [Added] iOS `Config.showsBackgroundLocationIndicator`, a Boolean indicating whether the status bar changes its appearance when an app uses location services in the background.

## 1.7.0 - 2020-02-21

- [Fixed] iOS bug related to significant-location-changes (SLC) API.  In a previous version, the plugin's geofence manager would stop monitoring SLC if the number of added geofences was < the maximum (20) (in order to not show the new iOS 13 dialog reporting background location usage when infinite-geofencing is not required).  The background-geolocation SDK uses several `CLLocationManager` instances and its `GeofenceManager` maintains its own instance.  However, it turns out that when *any* `CLLocationManager` instance stops monitoring the SLC API, then **ALL** instances stop monitoring SLC, which is highly unexpected and undocumented.  As a result, the plugin would lose its safety mechanism should the stationary geofence fail to trigger and iOS tracking could fail to start in some circumstances.
- [Fixed] `synchronize` methods in `TSLocationManager` to address Android NPE related to `buildTSLocation`.
- [Fixed] iOS:  Bug in `accessToken` RegExp in Authorization token-refresh handler.

### :warning: Breaking Change:  `background_fetch`:
- [Changed] Reference background_fetch dependency @ 0.5.3 with new iOS 13 BGTaskScheduler API.  See [Updated iOS Setup](https://github.com/transistorsoft/flutter_background_geolocation/blob/master/help/INSTALL-IOS.md#configure-background_fetch).



## 1.6.1 - 2020-01-17
- [Added] Implement four new RPC commands `addGeofence`, `removeGeofence`, `addGeofences`, `removeGeofences`.  Document available RPC commands in "HttpGuide".

## 1.6.0 - 2020-01-14
- [Changed] iOS: Prefix FMDB method-names `databasePool` -> `ts_databasePool` after reports of apps being falsely rejected by Apple for "private API usage".
- [Fixed] Android: Ensure that `location.hasSpeed()` before attempting to use it for distanceFilter elasticity calculations.  There was a report of a Device returning `Nan` for speed.
- [Fixed] Android:  Do not throttle http requests after http connect failure when configured with `maxRecordsToPersist`.
- [Fixed] Android: Respect `disableLocationAuthorizationAlert` for all cases, including `getCurrentPosition`.
- [Changed] Android: Modify behaviour of geofences-only mode to not periodically request location-updates.  Will use a stationary-geofence of radius geofenceProximityRadius/2 as a trigger to re-evaluate geofences in proximity.
- [Changed] Authorization refreshUrl will post as application/x-www-form-urlencoded instead of form/multipart
- [Changed] iOS geofencing mode will not engage Significant Location Changes API when total geofence count <= 18 in order to prevent new iOS 13 "Location summary" popup from showing frequent location access.
- [Fixed] Android:  Add hack for older devices to fix "GPS Week Rollover" bug where incorrect timestamp is recorded from GPS (typically where year is older by 20 years).
- [Fixed] When determining geofences within `geofenceProximityRadius`, add the `location.accuracy` as a buffer against low-accuracy locations.
- [Changed] Increase default `geofenceProximityRadius: 2000`.

## 1.5.0 - 2019-12-18
- [Changed] Upgrade to new Flutter "V2" Plugin API.  See [Upgrading pre 1.12 Android Projects](https://github.com/flutter/flutter/wiki/Upgrading-pre-1.12-Android-projects).  No extra steps required for "Android Headless Mode", it's all automatic now.
- [Changed] Modified Android Foreground Service intent to not restart activity on click.

## 1.4.5 - 2019-12-12
- [Changed] Upgrade iOS CocoaLumberjack dependency to ~>3.6.0 from ~>3.5.0.  It seems some other dependency out there is using CocaoLumberjack@3.6.0.
- [Changed] Fixed example app: flutter_map is messed up again.  Find another fork that works with lastest flutter api.

## 1.4.4 - 2019-12-12
- [Fixed] Previous Android version 1.4.3 was corrupted due to two copies of `tslocationmanager.aar` being deployed.

## 1.4.3 - 2019-12-09
- Rename folder docs -> help to satisfy dartdoc on pub.dev (API docs were missing).

## 1.4.2 - 2019-12-03
- [Fixed] iOS crash when launching first time `-[__NSDictionaryM setObject:forKey:]: object cannot be nil (key: authorization)'`
- [Changed] Remove Android warning `In order to enable encryption, you must provide the com.transistorsoft.locationmanager.ENCRYPTION_PASSWORD` when using `encrypt: false`.
- [Fixed] Added headless implementation for `geofenceschange` event.

## 1.4.1 - 2019-12-02
- [Fixed] Android bug rendering `Authorization.toJson` when no `Config.authorization` defined.

## 1.4.0 - 2019-12-02
- [Added] New `Config.authorization` option for automated authorization-token support.  If the SDK receives an HTTP response status `401 Unauthorized` and you've provided an `authorization` config, the plugin will automatically send a request to your configured `refreshUrl` to request a new token.  The SDK will take care of adding the required `Authorization` HTTP header with `Bearer accessToken`.  In the past, one would manage token-refresh by listening to the SDK's `onHttp` listener for HTTP `401`.  This can now all be managed by the SDK by providing a `Config.authorization`.
- [Added] Implemented strong encryption support via `Config.encrypt`.  When enabled, the SDK will encrypt location data in its SQLite datbase, as well as the payload in HTTP requests.  See API docs `Config.encrypt` for more information, including the configuration of encryption password.
- [Added] New JSON Web Token API for the Demo server at http://tracker.transistorsoft.com.  It's now easier than ever to configure the plugin to post to the demo server.  See API docs `Config.transistorAuthorizationToken`.  The old method using `Config.deviceParams` is now deprecated.
- [Added] New `DeviceInfo` module for providing simple device-info (`model`, `manufacturer`, `version`, `platform`).
- [Removed] The SDK no longer requires the dependency `device_info`.

## 1.3.3 - 2019-10-31
- [Added] New HTTP config `disableAutoSyncOnCellular`.  Set `true` to allow `autoSync` only when device is connected to Wifi.
- [Changed] Re-factor iOS HTTP Service to be more robust; Replace deprecated `NSURLConnection` with `NSURLSession`.

## 1.3.2 - 2019-10-24
- [Fixed] Resolve Dart analysis warnings related to `@deprecated`.

## 1.3.1 - 2019-10-23
- [Fixed] Android NPE
```
Caused by: java.lang.NullPointerException:
  at com.transistorsoft.locationmanager.service.TrackingService.b (TrackingService.java:172)
  at com.transistorsoft.locationmanager.service.TrackingService.onStartCommand (TrackingService.java:135)
```
- [Added] new `uploadLog` feature for uploading logs directly to a server.  This is an alternative to `emailLog`.
- [Changed] Migrated logging methods `getLog`, `destroyLog`, `emailLog` to new `Logger` module.  See docs for more information.  Existing log methods on `BackgroundGeolocation` are now `@deprecated`.
- [Changed] All logging methods (`getLog`, `emailLog` and `uploadLog`) now accept an optional `SQLQuery`.  Eg:
```dart
SQLQuery query = new SQLQuery(
  start: DateTime.parse('2019-10-23 09:00'),
  end: DateTime.parse('2019-10-23 19:00'),
  limit: 1000,
  order: SQLQuery.ORDER_ASC
);

String log = await Logger.getLog(query)
Logger.emailLog('foo@bar.com', query);
Logger.uploadLoad('http://your.server.com/logs', query);
```

## 1.3.0 - 2019-10-17
- [Fixed] Android: Fixed issue executing `#changePace` immediately after `#start`.
- [Fixed] Android:  Add guard against NPR in `calculateMedianAccuracy`
- [Added] Add new Geofencing methods: `#getGeofence(identifier)` and `#geofenceExists(identifier)`.
- [Fixed] iOS issue using `disableMotionActivityUpdates: false` with `useSignificantChangesOnly: true` and `reset: true`.  Plugin will accidentally ask for Motion Permission.
- [Fixed] Resolved a number of Android issues exposed by booting the app in [StrictMode](https://developer.android.com/reference/android/os/StrictMode).  This should definitely help alleviate ANR issues related to `Context.startForegroundService`.
- [Added] Android now supports `disableMotionActivityUpdates` for Android 10 which now requires run-time permission for "Physical Activity".  Setting to `true` will not ask user for this permission.  The plugin will fallback to using the "stationary geofence" triggering, like iOS.
- [Changed] Android:  Ensure all code that accesses the database is performed in background-threads, including all logging (addresses `Context.startForegroundService` ANR issue).
- [Changed] Android:  Ensure all geofence event-handling is performed in background-threads (addresses `Context.startForegroundService` ANR issue).
- [Added] Android: implement logic to handle operation without Motion API on Android 10.  v3 has always used a "stationary geofence" like iOS as a fail-safe, but this is now crucial for Android 10 which now requires run-time permission for "Physical Activity".  For those users who [Deny] this permission, Android will trigger tracking in a manner similar to iOS (ie: requiring movement of about 200 meters).  This also requires handling to detect when the device has become stationary.

## [1.2.4] - 2019-09-20
- [Fixed] flutter@1.9.1 deprecated a method `FlutterMain.findBundleAppPath(Context)`, replacing with a new signature the receives no `Context`.  Changing to the new signature breaks people using < flutter 1.9.1.  Will use old signature for now.
- [Fixed] Custom layouts were not working properly for older OS version < O.  Custom layout will use setBigContentLayout now.  The user will be able to expand the notification to reveal the custom layout.

## [1.2.3] - 2019-09-16
- [Changed] Bump background_fetch version to 0.3.0
- [Changed] Android:  move more location-handling code into background-threads to help mitigate against ANR referencing `Context.startForegroundService`
- [Changed] Android:  If BackgroundGeolocation adapter is instantiated headless and is enabled, force ActivityRecognitionService to start.
- [Added] Add `mock` to `locationTemplate` data.
- [Added] Android now adds 2 extra setup steps. (1) The plugin now hosts its own `proguard-rules.pro` which must be manually added to `app/build.gradle`.  (2)  The plugin now hosts its own custom gradle file which must also be manually `apply from` in your `app/build.gradle`.  This extra gradle file contains a simple method to strip the SDK's debug sound-effects from your release build (1.5M):

`android/app/build.gradle`

:open_file_folder: `android/app/build.gradle`:

```diff
// flutter_background_geolocation
+Project background_geolocation = project(':flutter_background_geolocation')
// 1.  Extra gradle file
+apply from: "${background_geolocation.projectDir}/background_geolocation.gradle"

android {
    .
    .
    .
    buildTypes {
        release {
            .
            .
            .
            minifyEnabled true
            // 2.  background_geolocation requires custom Proguard Rules when used with minifyEnabled
+           proguardFiles "${background_geolocation.projectDir}/proguard-rules.pro"
        }
    }
}
```

## [1.2.2] - 2019-09-05
- [Changed] Rebuild iOS `TSLocationManager.framework` with XCode 10 (previous build used XCode 11-beta6).  Replace `@available` macro with `SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO`.
- [Fixed] iOS 13 preventSuspend was not working with iOS 13.  iOS has once again decreased the max time for UIApplication beginBackgroundTask from 180s down to 30s.
- [Fixed] Android `Geofences.extras` not being provided to `#onGeofencesChange` event (issue #110).
- [Fixed] iOS 10 provides `bool` attributes as `int` in `State`.  Check `runtimeType == int`.  Issue #111.
- [Changed] Upgrade `android-logback` dependency to `2.0.0`
- [Changed] Android: move some plugin initialization into background-threads (eg: `performLogCleanup`) to help mitigate against ANR "`Context.startForegroundService` did not then call `Service.startForeground`".

## [1.2.1] - 2019-08-22
- [Fixed] Android Initial headless events can be missed when app booted due to motion transition event.
- [Fixed] Android crash with EventBus `Subscriber already registered error`.
- [Fixed] iOS `Crash: [TSHttpService postBatch:error:] + 6335064 (TSHttpService.m:253)`

## [1.2.0] - 2019-08-17
- [Added] iOS 13 support.

## [1.1.0] - 2019-08-07
- [Fixed] Android Geofence `DWELL` transition (`notifyOnDwell: true`) not firing.
- [Fixed] iOS `logMaxDays` was hard-coded to `7`; Config option not being respected.
- [Added] Android `Q` support (API 29) with new location permission model `When In Use`.  Android now supports the config option `locationAuthorizationRequest` which was traditionally iOS-only.  Also, Android Q now requires runtime permission from user for `ACTIVITY_RECOGNITION`.
- [Changed] Another Android tweak to mitigate against error `Context.startForegroundService() did not then call Service.startForeground()`.
- [Changed] Add new Android gradle config parameter `appCompatVersion` to replace `supportLibVersion` for better AndroidX compatibility.  If `appCompatVersion` is not found, the plugin's gradle file falls back to old `supportLibVersion`.

## [1.0.12] - 2019-07-23
- [Fixed] Found a few more cases where Android callbacks are being executed in background-thread.  References issue #70.

## [1.0.11] - 2019-07-10
- [Fixed] Android issue running enabledchange event in background-thread with flutter 1.7

## [1.0.10] - 2019-06-25
- [Fixed] iOS / Android issues with odometer and `getCurrentPosition` when used with `maximumAge` constraint.  Incorrect, old location was being returned instead of latest available.
- [Fixed] Some Android methods were executing the callback in background-thread, exposed when using flutter dev channel (`#insertLocation`, `#getLocations`, `#getGeofences`, `#sync`).
- [Fixed] Add `intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK)` to `DeviceSettings` request for Android 9 compatibility.
- [Changed] Tweaks to Android services code to help guard against error `Context.startForegroundService() did not then call Service.startForeground()`.
- [Fixed] iOS manual `sync` crash in simulator while executing callback when error response is returned from server.

## [1.0.9] - 2019-06-17
- [Fixed] Android bug with `getCurrentPosition` and `maximumAge`, Fixes #80.
- [Fixed] Odometer issues:  clear odometer reference location on `#stop`, `#startGeofences`.
- [Fixed] Odometer issues: Android must persist its odometer reference location since the foreground-service is no longer long-lived and the app may be terminated between motionchange events.
- [Fixed] Return `Service.START_REDELIVER_INTENT` from `HeartbeatService`.  Fixes #79 to prevent `null` Intent being delivered to `HeartbeatService`.
- [Added] Implement Android [LocationSettingsRequest](https://developer.android.com/training/location/change-location-settings#get-settings).  Determines if device settings is currently configured according to the plugin's desired-settings (eg: gps enabled, location-services enabled).  If the device settings differs, an automatic dialog will perform the required settings changes automatically when user clicks [OK].
- [Fixed] Android `triggerActivities` was not implemented refactor of `1.x`.

## [1.0.8] - 2019-06-04
- [Fixed] Android `destroyLocations` callback was being executed in background-thread.
- [Fixed] When Android geofence API receives a `GEOFENCE_NOT_AVAILABLE` error (can occur is Wifi is disabled), geofences must be re-registered.
- [Fixed] Android `Config.disableStopDetection` was not implemented.

## [1.0.7] - 2019-05-13
- [Fixed] Android issue with Firebase Adapter support not working when app is terminated.

## [1.0.6] - 2019-05-12
- [Added] New Android config `Config.scheduleUseAlarmManager` to force Android scheduler to use more precise `AlarmManager` instead of `JobScheduler`.
- [Added] Support for [background_geolocation_firebase](https://github.com/transistorsoft/flutter_background_geolocation_firebase) adapter.

## [1.0.5] - 2019-05-10
- [Changed] Rollback `android-permissions` version back to `0.1.8`.  It relies on `support-annotations@28`.  This isn't a problem if one simply upgrades their `targetSdkVersion` but the support calls aren't worth the hassle, since the latest version doesn't offer anything the plugin needs.

## [1.0.4] - 2019-05-09
- [Changed] Update docs.

## [1.0.3] - 2019-05-08
- [Fixed] Dart analysis warnings, re: initializing null values in new Notification class.

## [1.0.2] - 2019-05-08
- [Fixed] iOS: changing `pauseslocationUpdatesAutomatically` was not being applied.
- [Changed] `reset` parameter provided to `#ready` has now been default to `true`.  This causes too many support issues for people using the plugin the first time.
- [Fixed] Android threading issue where 2 distinct `SingleLocationRequest` were issued the same id.  This could result in the foreground service quickly starting/stopping until `locationTimeout` expired.
- [Fixed] Android issue where geofences could fail to query for new geofences-in-proximity after a restart.
- [Fixed] Android issues re-booting device with location-services disabled or location-authorization revoked.
- [Added] Implement support for [Custom Android Notification Layouts](/wiki/Android-Custom-Notification-Layout).
- [Fixed] Android bug where Service repeatedly stops / starts after rebooting device with plugin in *moving* state.
- [Fixed] Android scheduler bug.  When app is terminated & restarted during a scheduled ON period, tracking-service does not restart.
- [Fixed] Android headless `heartbeat` events were failing (incorrect `Context` was supplied to the event).

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
