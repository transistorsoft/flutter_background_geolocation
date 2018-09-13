# Android Installation

## `AndroidManifest`

Flutter seems to have a problem with 3rd-party Android libraries which merge their own `AndroidManifest.xml` into the application, particularly the `android:label` attribute.

:open_file_folder: `android/app/src/main/AndroidManifest.xml`:

```diff
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
+    xmlns:tools="http://schemas.android.com/tools"
    package="com.example.helloworld">

    <application 
+        tools:replace="android:label"
         android:name="io.flutter.app.FlutterApplication"
         android:label="flutter_background_geolocation_example"
         android:icon="@mipmap/ic_launcher">
</manifest>

```

:warning: Failure to perform the step above will result in a **build error**

```
Execution failed for task ':app:processDebugManifest'.
> Manifest merger failed : Attribute application@label value=(hello_world) from AndroidManifest.xml:17:9-36
    is also present at [tslocationmanager-2.13.3.aar] AndroidManifest.xml:24:18-50 value=(@string/app_name).
    Suggestion: add 'tools:replace="android:label"' to <application> element at AndroidManifest.xml:15:5-38:19 to override.
```

## `android/build.gradle`

As an app grows in complexity and imports a variety of 3rd-party modules, it helps to provide some key *"Global Gradle Configuration Properties"** which all modules can align their requested dependency versions to.  `flutter_background_geolocation` **is aware** of these variables and will align itself to them when detected.  One of the most common build errors comes from multiple 3rd-party modules importing different version of `play-services` or `com.android.support` libraries.

:open_file_folder: `android/build.gradle`:

```diff
buildscript {
    repositories {
        google()
        jcenter()
    }

    dependencies {
        classpath 'com.android.tools.build:gradle:3.0.1'
    }
}

allprojects {
    repositories {
        google()
        jcenter()
    }
}

+ext {
+    compileSdkVersion   = 27
+    targetSdkVersion    = 27
+    buildToolsVersion   = "27.0.3"
+    supportLibVersion   = "27.1.1"
+    playServicesVersion = "15.0.1"
+}
```

In addition, you should take advantage of the *Global Configuration Properties* **yourself**, replacing hard-coded values in your `android/app/build.gradle` with references to these variables:

:open_file_folder: `android/app/build.gradle`:

```diff
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



