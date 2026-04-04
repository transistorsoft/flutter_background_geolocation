# Example App

This directory contains an example application demonstrating different levels of
usage of the [flutter_background_geolocation](https://github.com/transistorsoft/flutter_background_geolocation) SDK.

---

## Examples

### Advanced Demo

**Path:** `lib/advanced/`

A full-featured demonstration app showcasing advanced capabilities of the SDK, including:

- Live map visualization
- Real-time configuration editing
- Circular geofences
- Motion state management
- Demo server registration and tracking

### HelloWorld Demo

**Path:** `lib/hello_world/`

A minimal, stripped-down demo focused on core SDK concepts, including:

- Starting and stopping tracking
- Requesting the current location
- Displaying basic tracking and event state

No map view, no configuration UI — ideal for first-time users.

---

## Which Should I Use?

- Start with **HelloWorld** if you want to understand the basics quickly.
- Use **Advanced** if you want to explore the SDK's full capabilities and UI patterns.

---

## Demo Server

When the app launches it will ask you to register an **organization** and **username**. The example app posts your tracking data to Transistor Software's demo server at:

**[https://tracker.transistorsoft.com](https://tracker.transistorsoft.com)**

View your results live on a map by navigating to:

```
https://tracker.transistorsoft.com/<your-organization>
```

> [!NOTE]
> The demo server is for testing purposes only. Use any organization name — it acts as a namespace to group your devices.

![](https://raw.githubusercontent.com/transistorsoft/assets/master/images/tracker.transistorsoft.com.png)

---

## Setup

### Prerequisites

- [Flutter](https://docs.flutter.dev/get-started/install) (3.27+)
- Android SDK and/or Xcode

### Clone and run

```bash
git clone https://github.com/transistorsoft/flutter_background_geolocation.git
cd flutter_background_geolocation/example

flutter pub get

# Android
flutter run

# iOS
cd ios && pod install && cd ..
flutter run
```

---

## Learn More

- [Documentation](https://docs.transistorsoft.com/flutter/setup/)
- [API Reference](https://docs.transistorsoft.com/flutter/BackgroundGeolocation/)
- [GitHub repository](https://github.com/transistorsoft/flutter_background_geolocation)
