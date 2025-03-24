# Android Installation

## `AndroidManifest`

Flutter seems to have a problem with 3rd-party Android libraries which merge their own `AndroidManifest.xml` into the application, particularly the `android:label` attribute.

### :open_file_folder: `android/app/src/main/AndroidManifest.xml`:

```diff
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
+   xmlns:tools="http://schemas.android.com/tools"
    package="com.example.helloworld">

    <application
+        tools:replace="android:label"
         android:name="io.flutter.app.FlutterApplication"
         android:label="flutter_background_geolocation_example"
         android:icon="@mipmap/ic_launcher">
</manifest>

```

> [!WARNING]
> Failure to perform the step above will result in a **build error**: __`Manifest merger failed`__


## :open_file_folder: `android/build.gradle` (or `build.gradle.kts`)

> [!NOTE]
> At the root of your `/android` folder, your Flutter app will contain __one__ of the following files:
> - __`build.gradle`__
> - __`build.gradle.kts`__ (new Kotlin-based version)
>
> Add the following **required** `maven` repo url to **whichever file** your app has:

### `build.gradle`

If your app contains an `android/app/build.gradle`:

```diff
+ext {
+    appCompatVersion    = "1.4.2"           // or higher / as desired
+    playServicesLocationVersion = "21.3.0"  // or higher / as desired
+}

allprojects {  // <-- IMPORTANT:  allprojects
    repositories {
        google()
        mavenCentral()
+       // [required] flutter_background_geolocation
+       maven { url "${project(':flutter_background_geolocation').projectDir}/libs" }
+       maven { url 'https://developer.huawei.com/repo/' }
+       // [required] background_fetch
+       maven { url "${project(':background_fetch').projectDir}/libs" }
    }
}
```

### `build.gradle.kts`

OR if your app contains an `android/build.gradle.kts`:

```diff
allprojects {
+   ext {
+       set("appCompatVersion", "1.4.2")             // or higher / as desired
+       set("playServicesLocationVersion", "21.3.0") // or higher / as desired
+   }
    repositories {
        google()
        mavenCentral()
+       // [required] background_geolocation
+       maven(url = "${project(":flutter_background_geolocation").projectDir}/libs")
+       maven(url = "https://developer.huawei.com/repo/")
+       // [required] background_fetch
+       maven(url = "${project(":background_fetch").projectDir}/libs")
    }
}
```

## :open_file_folder: `android/app/build.gradle` (or `build.gradle.kts`)

### `build.gradle`

If your app contains an `android/app/build.gradle`:

```diff
// flutter_background_geolocation
+Project background_geolocation = project(':flutter_background_geolocation')
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
+           shrinkResources false   // <-- REQUIRED !!!
        }
    }
}
```

### `build.gradle.kts`

OR if your app contains an `android/app/build.gradle.kts`:

```diff
+val backgroundGeolocation = project(":flutter_background_geolocation")
+apply { from("${backgroundGeolocation.projectDir}/background_geolocation.gradle") }

android {
    .
    .
    .
    buildTypes {
        release {
            .
            .
            .
            isMinifyEnabled = true
+           isShrinkResources = false   // <-- REQUIRED !!!
        }
    }
}
```

## Configure your license

If you've not yet purchased a license to unlock Android, you can purchase one [here](https://www.transistorsoft.com/shop/products/flutter-background-geolocation).  Otherwise, ignore this step (Android is fully functional in **DEBUG** builds without a license key so you can evaluate the plugin).

1. Login to Customer Dashboard to generate an application key:

2. Add your license-key to __`android/app/src/main/AndroidManifest.xml`__:

```diff
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.your.package.id">

  <application>
    <!-- flutter_background_geolocation licence -->
+   <meta-data android:name="com.transistorsoft.locationmanager.license" android:value="YOUR_LICENCE_KEY_HERE" />
    .
    .
    .
  </application>
</manifest>
```

### Huawei Mobile Services (HMS) Support

If you've [purchased an *HMS Background Geolocation* License](https://shop.transistorsoft.com/collections/frontpage/products/huawei-background-geolocation) for installing the plugin on _Huawei_ devices without *Google Play Services* installed, add your *HMS Background Geolocation* license key:

```diff
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.your.package.id">

  <application>
    <!-- flutter_background_geolocation licence -->
    <meta-data android:name="com.transistorsoft.locationmanager.license" android:value="YOUR_LICENCE_KEY_HERE" />
    <!-- HMS Background Geolocation licence -->
+   <meta-data android:name="com.transistorsoft.locationmanager.hms.license" android:value="YOUR_HMS_LICENCE_KEY_HERE" />
    .
    .
    .
  </application>
</manifest>
```

> [!WARNING]
> Huawei HMS support requires __`flutter_background_geolocation >= 3.10.0`__.


### Polygon Geofencing Add-on

If you've purchased a license for the [Polygon Geofencing add-on](https://shop.transistorsoft.com/products/polygon-geofencing), add the following license key to your __`AndroidManifest`__ (Polygon Geofencing is fully functional in DEBUG builds so you can try before you buy):

```diff
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.your.package.id">

  <application>
    <!-- flutter_background_geolocation licence -->
    <meta-data android:name="com.transistorsoft.locationmanager.license" android:value="YOUR_LICENCE_KEY_HERE" />
    <!-- Background Geolocation Polygon Geofencing Licence -->
+   <meta-data android:name="com.transistorsoft.locationmanager.polygon.license" android:value="YOUR_POLYGON_LICENCE_KEY_HERE" />
    .
    .
    .
  </application>
</manifest>
```

## `AlarmManager` "Exact Alarms" (optional)

The plugin uses __`AlarmManager`__ "exact alarms" for precise scheduling of events (eg: __`Config.stopTimeout`__, __`Config.motionTriggerDelay`__, __`Config.schedule`__).  *Android 14 (SDK 34)*, has restricted usage of ["`AlarmManager` exact alarms"](https://developer.android.com/about/versions/14/changes/schedule-exact-alarms).  To continue using precise timing of events with *Android 14*, you can manually add this permission to your __`AndroidManifest`__.  Otherwise, the plugin will gracefully fall-back to "*in-exact* `AlarmManager` scheduling".  For more information about Android's __`AlarmManager`__, see the [Android API Docs](https://developer.android.com/training/scheduling/alarms).

:open_file_folder: In your __`AndroidManifest`__, add the following permission (**exactly as-shown**):

```xml
  <manifest>
      <uses-permission android:minSdkVersion="34" android:name="android.permission.USE_EXACT_ALARM" />
      .
      .
      .
  </manifest>
```
> [!WARNING]
> It has been announced that *Google Play Store* [has plans to impose greater scrutiny](https://support.google.com/googleplay/android-developer/answer/13161072?sjid=3640341614632608469-NA) over usage of this permission (which is why the plugin does not automatically add it).

## Android Headless Mode with `enableHeadless: true`

If you intend to respond to the BackgroundGeolocation SDK's events with your own `dart` callback while your **app is terminated**, that is *Headless*, See [Android Headless Mode](../../../wiki/Android-Headless-Mode) and perform those additional steps now.

```dart
BackgroundGeolocation.ready(Config(
  enableHeadless: true  // <--
));
```

## `background_fetch`

`flutter_background_geolocation` installs a dependency `background_fetch` (also created by [Transistor Software](https://www.transistorsoft.com)).  You can optionally perform the [Android Setup](https://github.com/transistorsoft/flutter_background_fetch/blob/master/help/INSTALL-ANDROID.md) for it as well.

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


