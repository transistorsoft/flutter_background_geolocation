# Android Installation

## `AndroidManifest`

Flutter seems to have a problem with 3rd-party Android libraries which merge their own `AndroidManifest.xml` into the application, particularly the `android:label` attribute.

##### :open_file_folder: `android/app/src/main/AndroidManifest.xml`:

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

##### :warning: Failure to perform the step above will result in a **build error**

```
Execution failed for task ':app:processDebugManifest'.
> Manifest merger failed : Attribute application@label value=(hello_world) from AndroidManifest.xml:17:9-36
    is also present at [tslocationmanager-2.13.3.aar] AndroidManifest.xml:24:18-50 value=(@string/app_name).
    Suggestion: add 'tools:replace="android:label"' to <application> element at AndroidManifest.xml:15:5-38:19 to override.
```


## `android/build.gradle`

As an app grows in complexity and imports a variety of 3rd-party modules, it helps to provide some key **"Global Gradle Configuration Properties"** which all modules can align their requested dependency versions to.  `flutter_background_geolocation` **is aware** of these variables and will align itself to them when detected.  One of the most common build errors comes from multiple 3rd-party modules importing different version of `play-services` or `support` libraries.

:open_file_folder: `android/build.gradle`:

```diff
buildscript {
    ext.kotlin_version = '1.3.0' // Must use 1.3.0 OR HIGHER
+   ext {
+       compileSdkVersion   = 31                // or higher
+       targetSdkVersion    = 31                // or higher
+       minSdkVersion       = 19                // Required minimum
+       appCompatVersion    = "1.4.2"           // or higher
+       playServicesLocationVersion = "20.0.0"  // or higher
+   }
}

allprojects {
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

## `android/app/build.gradle`

In addition, you should take advantage of the *Global Configuration Properties* **yourself**, replacing hard-coded values in your `android/app/build.gradle` with references to these variables:

:open_file_folder: `android/app/build.gradle`:

```diff
apply plugin: 'com.android.application'
apply from: "$flutterRoot/packages/flutter_tools/gradle/flutter.gradle"

// flutter_background_geolocation (must be placed after the lines above)
+Project background_geolocation = project(':flutter_background_geolocation')
+apply from: "${background_geolocation.projectDir}/background_geolocation.gradle"

android {
+   compileSdkVersion rootProject.ext.compileSdkVersion
    .
    .
    .
    defaultConfig {
        .
        .
        .
+       minSdkVersion rootProject.ext.minSdkVersion
+       targetSdkVersion rootProject.ext.targetSdkVersion
    }
    buildTypes {
        release {
            .
            .
            .
            minifyEnabled true
+           shrinkResources false
            // background_geolocation requires custom Proguard Rules with minifyEnabled
+           proguardFiles "${background_geolocation.projectDir}/proguard-rules.pro"
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
:warning: Huawei HMS support requires `flutter_background_geolocation >= 3.10.0`.


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
:warning: It has been announced that *Google Play Store* [has plans to impose greater scrutiny](https://support.google.com/googleplay/android-developer/answer/13161072?sjid=3640341614632608469-NA) over usage of this permission (which is why the plugin does not automatically add it).

## Android Headless Mode with `enableHeadless: true`

If you intend to respond to the BackgroundGeolocation SDK's events with your own `dart` callback while your **app is terminated**, that is *Headless*, See [Android Headless Mode](../../../wiki/Android-Headless-Mode) and perform those additional steps now.

```dart
BackgroundGeolocation.ready(Config(
  enableHeadless: true  // <--
));
```

## `background_fetch`

`flutter_background_geolocation` installs a dependency `background_fetch` (also created by [Transistor Software](https://www.transistorsoft.com)).  You can optionally perform the [Android Setup](https://github.com/transistorsoft/flutter_background_fetch/blob/master/help/INSTALL-ANDROID.md) for it as well.

