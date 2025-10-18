# iOS Installation

## Cocoapods

If you're not using *Swift Package Manager*, you **must** adjust the `use_frameworks!` declaration to add the following property in your `ios/Podfile`:

`use_frameworks!` should already exist &mdash; just append `:linkage => :static`:

```ruby
target 'Runner' do
  use_frameworks! :linkage => :static   # <-- append :linkage => :static
  .
  .
  .
end
```

:warning: If you *don't* add the above line, you're going to get the following error when running `flutter build ios`

```console
-> Installing flutter_background_geolocation (5.0.0)
      - Running pre install hooks
    [!] The 'Pods-Runner' target has transitive dependencies that include statically linked binaries:
    (/ios/Pods/TSBackgroundGeolocation/TSBackgroundGeolocation.xcframework)
```

## Permissions & Background Modes

Open the Xcode project `ios/Runner/Runner.xcworkspace`

- Enable the background modes:
    - [x] Location updates
    - [x] Background fetch
    - [x] Audio (**optional for debug-mode sound FX**)

![](https://dl.dropboxusercontent.com/scl/fi/muwq6wwor83acl64w4214/setup-ios-background-modes.png?rlkey=cbbuz0pg5j3ql1z4sttxpufyl&dl=1)

- Add the following permissions to `Info.plist`:

| Key | Type | Value |
|-----|-------|-------------|
| *Privacy - Location Always and When in Use Usage Description* | `String` | *CHANGEME: Location required in background* |
| *Privacy - Location When in Use Usage Description* | `String` | *CHANGEME: Location required when app is in use* |
| *Privacy - Motion Usage Description* | `String` | *CHANGEME: Motion permission helps detect when device in in-motion* |

### Or edit `Info.plist` directly

:open_file_folder: `ios/Runner/Info.plist`

```diff
<plist>
<dict>
+    <key>NSMotionUsageDescription</key>
+    <string>Motion usage description</string>
+    <key>NSLocationWhenInUseUsageDescription</key>
+    <string>When in use description</string>
+    <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
+    <string>Always/When in use description</string>

+    <key>UIBackgroundModes</key>
+    <array>
+        <string>fetch</string>
+        <string>location</string>
+    </array>

+    <key>BGTaskSchedulerPermittedIdentifiers</key>
+    <array>
+        <string>com.transistorsoft.fetch</string>
+    </array>
</dict>
</plist>
```

![](https://dl.dropboxusercontent.com/s/wyoejgko6xq4pi4/iOS-permissions.png?dl=1)

### Background Fetch

The *Background Geolocation* SDK has internal handling for periodic *Background Fetch* events (if enabled).  It can use these periodic events to gather current state information (*is the device moving?*), evaluating the `schedule` (if you configured one) or checking if there are any location records in the queue, waiting to be uploaded to your configured `url`:

1.  Open your __`Info.plist`__ and add the key *"Permitted background task scheduler identifiers"*

![](https://dl.dropboxusercontent.com/s/t5xfgah2gghqtws/ios-setup-permitted-identifiers.png?dl=1)

2.  Add the **required identifier `com.transistorsoft.fetch`**.

![](https://dl.dropboxusercontent.com/s/kwdio2rr256d852/ios-setup-permitted-identifiers-add.png?dl=1)


[Transistor Software](https://www.transistorsoft.com) manages a helpful free plugin you can optionally add to your app named [`background_fetch`](https://pub.dev/packages/background_fetch).

> [!TIP]
> `background_fetch` is helpful for executing a periodic task (eg: every 15 minutes).  You could use `background_fetch` to periodically request the current location:

```dart
// Execute a task about every 15 minutes:
BackgroundFetch.configure(BackgroundFetchConfig(
  minimumFetchInterval: 15
), (String taskId) async { // <-- This is your periodic-task callback
  var location = await BackgroundGeolocation.getCurrentPosition(
    samples: 3,
    extras: {   // <-- your own arbitrary meta-data
      "event": "getCurrentPosition"
    }
  );
  print('[getCurrentPosition] $location');
  BackgroundFetch.finish(taskId);   // <-- signal that your task is complete
})
```







