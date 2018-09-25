# iOS Installation

### Permissions & Background Modes

#### Using XCode

Open the Xcode project `ios/Runner/Runner.xcworkspace`

- Enable the background modes:
    - [x] Location updates
    - [x] Background fetch
    - [x] Audio (**optional for debug-mode sound FX**)

![](https://dl.dropboxusercontent.com/s/kg8zowl8jscoioo/iOS-background-modes.png?dl=1)

- Add the following permissions to `Info.plist`:

| Key                                                                        | 
|----------------------------------------------------------------------------|
| Privacy - Location Always and When In Use Description                      |
| Privacy - Location When In Use Permission                                  |
| Privacy - Motion Usage Description                                         |

![](https://dl.dropboxusercontent.com/s/wyoejgko6xq4pi4/iOS-permissions.png?dl=1)

#### Or edit `Info.plist` directly

:open_file_folder: `ios/Runner/Info.plist`

```diff
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
</dict>
</plist>
```

