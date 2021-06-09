///[![](https://dl.dropboxusercontent.com/s/nm4s5ltlug63vv8/logo-150-print.png?dl=1)](https://www.transistorsoft.com)
/// -------------------------------------------------------------------------------
/// # [BackgroundGeolocation]
///
/// The primary APIs for the plugin are exposed through two classes:
/// - [BackgroundGeolocation]
/// - [Config]
///
/// ## 📚 Help
/// - 📘 [Philosophy of Operation](https://github.com/transistorsoft/flutter_background_geolocation/wiki/Philosophy-of-Operation)
/// - 📘 HTTP Guide: [HttpEvent].
/// - 📘 Geofencing Guide:  [GeofenceEvent].
/// - 📘 [Android Headless Mode](https://github.com/transistorsoft/flutter_background_geolocation/wiki/Android-Headless-Mode).
/// - 📘 [Android Custom Notification Layout](https://github.com/transistorsoft/flutter_background_geolocation/wiki/Android-Custom-Notification-Layout).
/// - 📘 [Debugging Guide](https://github.com/transistorsoft/flutter_background_geolocation/wiki/Debugging).
///
library flt_background_geolocation;

import 'dart:async';
import 'dart:ui';
import 'dart:convert';
import 'package:collection/collection.dart' show IterableExtension;

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

part 'models/background_geolocation.dart';
part 'models/device_settings.dart';
part 'models/logger.dart';
part 'models/event.dart';
part 'models/location.dart';
part 'models/geofence.dart';
part 'models/activity_change_event.dart';
part 'models/geofence_event.dart';
part 'models/geofences_change_event.dart';
part 'models/heartbeat_event.dart';
part 'models/http_event.dart';
part 'models/provider_change_event.dart';
part 'models/connectivity_change_event.dart';
part 'models/config.dart';
part 'models/state.dart';
part 'models/sensors.dart';
part 'models/headless_event.dart';
part 'models/notification.dart';
part 'models/sql_query.dart';
part 'models/authorization.dart';
part 'models/device_info.dart';
part 'models/transistor_authorization_token.dart';
part 'models/authorization_event.dart';
part 'models/permission_rationale.dart';
part 'models/error.dart';

const _PLUGIN_PATH = "com.transistorsoft/flutter_background_geolocation";

// MethodChannel
const MethodChannel _methodChannel =
    const MethodChannel("$_PLUGIN_PATH/methods");

// iOS 10 returns BOOL as 1/0 rather than true/false
bool? _ensureBool(dynamic value) {
  return (value.runtimeType == int) ? (value != 0) : value;
}

// Android & iOS sometimes differ on their Type; where one returns int, the other might return double.
int? _ensureInt(dynamic value) {
  return (value.runtimeType == double) ? value.round() : value;
}

// Android & iOS sometimes differ on their Type; where one returns int, the other might return double.
double? _ensureDouble(dynamic value) {
  return (value.runtimeType == int) ? value * 1.0 : value;
}
