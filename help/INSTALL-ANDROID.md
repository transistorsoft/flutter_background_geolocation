# Android Installation


## :open_file_folder: `android/build.gradle` (or `build.gradle.kts`)

> [!NOTE]
> At the root of your `/android` folder, your Flutter app will contain __one__ of the following files:
> - __`build.gradle`__
> - __`build.gradle.kts`__ (new Kotlin-based version)
>

### `build.gradle`

If your app contains an `android/build.gradle`, you can control the version of Google's `play-services:location` that this plugin will use:

```diff
+ext {
+    playServicesLocationVersion = "21.3.0"  // or higher / as desired
+}

<<<<<<< HEAD
=======
allprojects {  // <-- IMPORTANT:  allprojects
    repositories {
        google()
        mavenCentral()
+       // [required] flutter_background_geolocation
+       maven { url "${project(':flutter_background_geolocation').projectDir}/libs" }
+       // [required] background_fetch
+       maven { url "${project(':background_fetch').projectDir}/libs" }
    }
}
>>>>>>> master
```

### `build.gradle.kts`

OR if your app contains an `android/build.gradle.kts`:

```diff
allprojects {
+   ext {
+       set("playServicesLocationVersion", "21.3.0") // or higher / as desired
+   }
<<<<<<< HEAD
=======
    repositories {
        google()
        mavenCentral()
+       // [required] background_geolocation
+       maven(url = "${project(":flutter_background_geolocation").projectDir}/libs")
+       // [required] background_fetch
+       maven(url = "${project(":background_fetch").projectDir}/libs")
    }
>>>>>>> master
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

<<<<<<< HEAD
## `v5` Licensing.

Version `5.0.0` of `flutter_background_geolocation` requires a new license-key format (previous license are no longer accepted).  You can generate your new license in the customer dashboard.
=======
### Huawei Mobile Services (HMS) Support
:warning: Huawei HMS support ended in `v4.18.0` since they failed to release their SDKs with *Android 16KB page size* support.
<!--
If you've [purchased an *HMS Background Geolocation* License](https://shop.transistorsoft.com/collections/frontpage/products/huawei-background-geolocation) for installing the plugin on _Huawei_ devices without *Google Play Services* installed, add your *HMS Background Geolocation* license key:
-->
>>>>>>> master

These new license keys now have the ability to unlock any purshased add-on, without the need to add a separate license key for each:
- *Polygon Geofencing*
- *Huawei HMS Adapter*
- *Firebase Adapter*

## Legacy License Keys

<<<<<<< HEAD
For versions of `flutter_background_geolocation` `<v5.0.0`:


### Polygon Geofencing Add-on

If you've purchased a license for the [Polygon Geofencing add-on](https://shop.transistorsoft.com/products/polygon-geofencing), login to the customer dashboard and ensure you enable the *[x] Polygon Geofencing* entitlement to your license key.  Update your *Background Geolocation* license with the new key (as documented above).
=======
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
>>>>>>> master

## Android Headless Mode with `enableHeadless: true`

If you intend to respond to the BackgroundGeolocation SDK's events with your own `dart` callback while your **app is terminated**, that is *Headless*, See [Android Headless Mode](../../../wiki/Android-Headless-Mode) and perform those additional steps now.

```dart
BackgroundGeolocation.ready(Config(
  enableHeadless: true  // <--
));
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


