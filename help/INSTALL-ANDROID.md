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
+       appCompatVersion    = "1.4.2"           // or higher
+       playServicesLocationVersion = "20.0.0"  // or higher
+   }
}

allprojects {
    repositories {
        google()
        mavenCentral()
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
[www.transistorsoft.com/shop/customers](http://www.transistorsoft.com/shop/customers)
![](https://gallery.mailchimp.com/e932ea68a1cb31b9ce2608656/images/b2696718-a77e-4f50-96a8-0b61d8019bac.png)

2. Add your license-key to `android/app/src/main/AndroidManifest.xml`:

```diff
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.your.package.id">

  <application>
    <!-- flutter_background_geolocation licence -->
+     <meta-data android:name="com.transistorsoft.locationmanager.license" android:value="YOUR_LICENCE_KEY_HERE" />
    .
    .
    .
  </application>
</manifest>
```

## Android Headless Mode with `enableHeadless: true`

If you intend to respond to the BackgroundGeolocation SDK's events with your own `dart` callback while your **app is terminated**, that is *Headless*, See [Android Headless Mode](../../../wiki/Android-Headless-Mode) and perform those additional steps now.

```dart
BackgroundGeolocation.ready(Config(
  enableHeadless: true  // <--
));
```

## `background_fetch`

`flutter_background_geolocation` installs a dependency `background_fetch` (also created by [Transistor Software](https://www.transistorsoft.com)).  You can optionally perform the [Android Setup](https://github.com/transistorsoft/flutter_background_fetch/blob/master/help/INSTALL-ANDROID.md) for it as well.

