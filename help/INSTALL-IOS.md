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

![](https://dl.dropboxusercontent.com/s/wyoejgko6xq4pi4/iOS-permissions.png?dl=1)

### Background Fetch

The *Background Geolocation* SDK has internal handling for periodic *Background Fetch* events (if enabled).  It can use these periodic events to gather current state information (*is the device moving?*), evaluating the `schedule` (if you configured one) or checking if there are any location records in the queue, waiting to be uploaded to your configured `url`:

1.  Open your __`Info.plist`__ and add the key *"Permitted background task scheduler identifiers"*

![](https://dl.dropboxusercontent.com/s/t5xfgah2gghqtws/ios-setup-permitted-identifiers.png?dl=1)

2.  Add the **required identifier `com.transistorsoft.fetch`**.

![](https://dl.dropboxusercontent.com/s/kwdio2rr256d852/ios-setup-permitted-identifiers-add.png?dl=1)



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

## Privacy Manifest

Apple now requires apps provide a [Privacy Manifest for "sensitive" APIs](https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_use_of_required_reason_api?language=objc) which could be abused for "fingerprinting" a user for malicious marketing activity.

If your app does not yet have a *Privacy Manifest* (__`PrivacyInfo.xcprivacy`__), create one now:

<details>
    <summary>ℹ️ Click here for detailed instructions...</summary>

- In XCode, __`File -> New -> File...`__:

![](https://dl.dropboxusercontent.com/scl/fi/n28028i3fbrxd67u491w2/file-new-PrivacyInfo.png?rlkey=sc7s1lyy8fli2c1hz2cfa4cpm&dl=1)

- Be sure to enable your `Targets: [x] YourApp`:

![](https://dl.dropboxusercontent.com/scl/fi/pmbfn5jypvns6r5pyhnui/file-new-PrivacyInfo-targets.png?rlkey=epvjffar23bxgyi9xax9ys40i&dl=1)


</details>


It's best to edit this file's XML manually.
- :open_file_folder: `ios/PrivacyInfo.xcprivacy`
- Add the following __4 blocks__ within the `NSPrivacyAccessedAPITypes` `<array>` container:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">

<plist version="1.0">
<dict>
    <key>NSPrivacyAccessedAPITypes</key>
    <array>
        <!-- [1] background_fetch: UserDefaults -->
        <dict>
            <key>NSPrivacyAccessedAPIType</key>
            <string>NSPrivacyAccessedAPICategoryUserDefaults</string>

            <key>NSPrivacyAccessedAPITypeReasons</key>
            <array>
                <string>CA92.1</string>
            </array>
        </dict>

        <!-- [2] background_geolocation: UserDefaults -->
        <dict>
            <key>NSPrivacyAccessedAPIType</key>
            <string>NSPrivacyAccessedAPICategoryUserDefaults</string>

            <key>NSPrivacyAccessedAPITypeReasons</key>
            <array>
                <string>CA92.1</string>
                <string>1C8F.1</string>
            </array>
        </dict>
        <!-- [3] background_geolocation (CocoaLumberjack): FileTimestamp -->
        <dict>
            <key>NSPrivacyAccessedAPIType</key>
            <string>NSPrivacyAccessedAPICategoryFileTimestamp</string>
            <key>NSPrivacyAccessedAPITypeReasons</key>
            <array>
                <string>C617.1</string>
                <string>0A2A.1</string>
            </array>
        </dict>
        <!-- [4] background_geolocation (CocoaLumberjack): DiskSpace -->
        <dict>
            <key>NSPrivacyAccessedAPIType</key>
            <string>NSPrivacyAccessedAPICategoryDiskSpace</string>
            <key>NSPrivacyAccessedAPITypeReasons</key>
            <array>
                <string>E174.1</string>
            </array>
        </dict>
    </array>
</dict>
</plist>
```

## `background_fetch`

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
