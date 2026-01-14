# flutter_background_geolocation

 
See the **[Migration Guide to 5.0.0](./MIGRATION-GUIDE-5.0.0.md)** for details about new config APIs (e.g., `LocationFilter`) and how to migrate from flat to compound config (legacy config is still supported).

Be sure to see updated [Setup Guides](#-setup-guides)

---------------------------------------------------------

[![](https://dl.dropboxusercontent.com/s/nm4s5ltlug63vv8/logo-150-print.png?dl=1)](https://www.transistorsoft.com)

-------------------------------------------------------------------------------

The *most* sophisticated background **location-tracking & geofencing** module with battery-conscious motion-detection intelligence for **iOS** and **Android**.

The plugin's [Philosophy of Operation](https://github.com/transistorsoft/flutter_background_geolocation/wiki/Philosophy-of-Operation) is to use **motion-detection** APIs (using accelerometer, gyroscope and magnetometer) to detect when the device is *moving* and *stationary*.

- When the device is detected to be **moving**, the plugin will *automatically* start recording a location according to the configured `distanceFilter` (meters).

- When the device is detected be **stationary**, the plugin will automatically turn off location-services to conserve energy.

Also available for [Cordova](https://github.com/transistorsoft/cordova-background-geolocation-lt), [React Native](https://github.com/transistorsoft/react-native-background-geolocation), [NativeScript](https://github.com/transistorsoft/nativescript-background-geolocation-lt) and [pure native](https://github.com/transistorsoft/background-geolocation-lt) apps.


> [!NOTE]  
>The **[Android module](https://www.transistorsoft.com/shop/products/flutter-background-geolocation)** requires [purchasing a license](https://www.transistorsoft.com/shop/products/flutter-background-geolocation).  However, it *will* work for **DEBUG** builds.  It will **not** work with **RELEASE** builds [without purchasing a license](https://www.transistorsoft.com/shop/products/flutter-background-geolocation).  This plugin is supported **full-time** and field-tested **daily** since 2013.

----------------------------------------------------------------------------

[![Google Play](https://dl.dropboxusercontent.com/s/80rf906x0fheb26/google-play-icon.png?dl=1)](https://play.google.com/store/apps/details?id=com.transistorsoft.flutterbackgroundgeolocationexample)

![Home](https://dl.dropboxusercontent.com/s/wa43w1n3xhkjn0i/home-framed-350.png?dl=1)
![Settings](https://dl.dropboxusercontent.com/s/8oad228siog49kt/settings-framed-350.png?dl=1)

# Contents
- ### 📚 [API Documentation](https://pub.dev/documentation/flutter_background_geolocation/5.0.0-beta.2/flt_background_geolocation/)
- ### [Installing the Plugin](#-installing-the-plugin)
- ### [Setup Guides](#-setup-guides)
- ### [Using the plugin](#-using-the-plugin)
- ### [v5 Migration Guide](help/MIGRATION-GUIDE-5.0.0.md)
- ### [Example](#l-example)
- ### [Debugging](https://github.com/transistorsoft/flutter_background_geolocation/wiki/Debugging)
- ### [Demo Application](#-demo-application)
- ### [Testing Server](#-simple-testing-server)


## 🔷 Installing the Plugin

📂 **`pubspec.yaml`**:

**Note:** See [Versions](https://pub.dartlang.org/packages/flutter_background_geolocation/#-versions-tab-) for latest available version.

```yaml
dependencies:
  flutter_background_geolocation: '^5.0.0'
```

### Or latest from Git:

```yaml
dependencies:
  flutter_background_geolocation:
    git:
      url: https://github.com/transistorsoft/flutter_background_geolocation.git
```

## 🔷 Setup Guides

- [iOS](help/INSTALL-IOS.md)
- [Android](help/INSTALL-ANDROID.md)


## 🔷 Using the plugin ##

```dart
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
```

> [!WARNING]
> Note `as bg` in the `import`.  This is important to namespace the plugin's classes, which often use common class-names such as `Location`, `Config`, `State`.  You will access every `flutter_background_geolocation` class with the prefix `bg` (ie: "**b**ackground **g**eolocation").

## 🔷 Example
[Full Example](https://gist.github.com/christocracy/a0464846de8a9c27c7e9de5616082878)

There are three main steps to using `BackgroundGeolocation`:

1. Wire up event-listeners.
2. Configure the plugin with `#ready`.
3. `#start` the plugin.

> [!WARNING]
> Do not execute *any* API method which will require accessing location-services until the **[`.ready(config)`](https://pub.dev/documentation/flutter_background_geolocation/latest/flt_background_geolocation/BackgroundGeolocation/ready.html)** method resolves ([Read its API docs](https://pub.dev/documentation/flutter_background_geolocation/latest/flt_background_geolocation/BackgroundGeolocation/ready.html)), For example: 
>- `.getCurrentPosition` 
>- `.start`


```dart

import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();

    ////
    // 1.  Listen to events (See docs for all 12 available events).
    //

    // Fired whenever a location is recorded
    bg.BackgroundGeolocation.onLocation((bg.Location location) {
      print('[location] - $location');
    });

    // Fired whenever the plugin changes motion-state (stationary->moving and vice-versa)
    bg.BackgroundGeolocation.onMotionChange((bg.Location location) {
      print('[motionchange] - $location');
    });

    // Fired whenever the state of location-services changes.  Always fired at boot
    bg.BackgroundGeolocation.onProviderChange((bg.ProviderChangeEvent event) {
      print('[providerchange] - $event');
    });

    ////
    // 2.  Configure the plugin (See API docs for dozens of available options)
    //
    bg.BackgroundGeolocation.ready(bg.Config(
        geolocation: bg.GeoConfig(
          desiredAccuracy: bg.DesiredAccuracy.high
          distanceFilter: 10.0,
        ),
        app: bg.AppConfig(
          stopOnTerminate: false,
          startOnBoot: true
        ),
        logger: bg.LoggerConfig(
          debug: true,  // <-- Emit debug soundFX during development
          logLevel: bg.LogLevel.verbose // <-- Emit verbose logs for development / debugging
        )
    )).then((bg.State state) {
      // The SDK persists its enabled state between app restarts / device reboots.
      if (!state.enabled) { 
        ////
        // 3.  Start the plugin (like the power switch of an electronic device)
        //
        bg.BackgroundGeolocation.start();
      }
    });
  }
}

```

## 🔷 Demo Application

A fully-featured Demo App is available in the repo in the [`/example`](./example) folder.

[![Google Play](https://dl.dropboxusercontent.com/s/80rf906x0fheb26/google-play-icon.png?dl=1)](https://play.google.com/store/apps/details?id=com.transistorsoft.flutterbackgroundgeolocationexample)

![Home](https://dl.dropboxusercontent.com/s/wa43w1n3xhkjn0i/home-framed-350.png?dl=1)
![Settings](https://dl.dropboxusercontent.com/s/8oad228siog49kt/settings-framed-350.png?dl=1)

## 🔷 [Simple Testing Server](https://github.com/transistorsoft/background-geolocation-console)

A simple Node-based [web-application](https://github.com/transistorsoft/background-geolocation-console) with SQLite database is available for field-testing and performance analysis.  If you're familiar with Node, you can have this server up-and-running in about **one minute**.

![](https://dl.dropboxusercontent.com/s/px5rzz7wybkv8fs/background-geolocation-console-map.png?dl=1)

![](https://dl.dropboxusercontent.com/s/tiy5b2oivt0np2y/background-geolocation-console-grid.png?dl=1)

# License

The MIT License (MIT)

Copyright (c) 2018 Chris Scott, Transistor Software

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

