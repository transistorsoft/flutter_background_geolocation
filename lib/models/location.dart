part of '../flutter_background_geolocation.dart';

// -----------------------------------------------------------------------------
// Shared parsing helpers
// -----------------------------------------------------------------------------
Map _asMap(dynamic v) => (v is Map) ? v : const {};

num _parseNum(dynamic v, {num fallback = 0}) {
  if (v is num) return v;
  if (v is String) {
    final p = num.tryParse(v);
    if (p != null) return p;
  }
  return fallback;
}

double _parseDouble(dynamic v, {double fallback = 0.0}) {
  final n = _parseNum(v, fallback: fallback);
  return n.toDouble();
}

int? _parseInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is String) return int.tryParse(v);
  return null;
}

bool _parseBool(dynamic v, {bool fallback = false}) {
  if (v is bool) return v;
  if (v is num) return v != 0;
  if (v is String) {
    final s = v.toLowerCase();
    if (s == 'true' || s == '1' || s == 'yes') return true;
    if (s == 'false' || s == '0' || s == 'no') return false;
  }
  return fallback;
}

// Convenience wrappers for reading from a map.
double _mapDouble(Map c, String key, {double fallback = 0.0}) =>
    _parseDouble(c[key], fallback: fallback);
int? _mapInt(Map c, String key) => _parseInt(c[key]);
bool _mapBool(Map c, String key, {bool fallback = false}) =>
    _parseBool(c[key], fallback: fallback);

/// Location coordinates (eg: `latitude`, `longitude`, `accuracy`, `speed`, `heading`, etc.
///
/// ```dart
/// BackgroundGeolocation.onLocation((Location location) {
///   double accuracy = location.coords.accuracy;
///   double lat      = location.coords.latitude;
///   double lng      = location.coords.longitude;
///   double speed    = location.coords.speed;
///   double heading  = location.coords.heading;
///   double altitude = location.coords.altitude;
///
///   print("[onLocation] $location");
/// });
///
/// State state = await BackgroundGeolocation.ready(Config(
///   distanceFilter: 10.0
/// ));
///
/// Location location = await BackgroundGeolocation.getCurrentPosition();
/// print("[getCurrentPosition] location: $location");
/// ```
///
class Coords {
  /// __`[iOS Only]`__ The current floor within a building.
  /// Only works in an environment containing indoor-tracking hardware (eg: bluetooth beacons).
  int? floor;

  /// Latitude of the location.
  late double latitude;

  /// Longitude of the location.
  late double longitude;

  /// Accuracy in meters.
  late double accuracy;

  /// **iOS**: Altitude above sea-level in meters.
  /// **Android**: The altitude of this location in meters above the WGS84 reference ellipsoid.
  /// - See [ellipsoidalAltitude]
  late double altitude;

  /// The altitude of this location in meters above the WGS84 reference ellipsoid.
  late double ellipsoidalAltitude;

  /// Heading in degrees.
  /// ⚠️ Note:  Only present when location came from GPS.  `-1` otherwise.
  late double heading;

  /// Heading accuracy in degrees.
  /// ⚠️ Note:  Only present when location came from GPS.  `-1` otherwise.
  late double headingAccuracy;

  /// Speed in meters / second.
  /// ⚠️ Note:  Only present when location came from GPS.  `-1` otherwise.
  late double speed;

  /// Speed accuracy in meters / second
  /// ⚠️ Note:  Only present when location came from GPS.  `-1` otherwise.
  late double speedAccuracy;

  /// Altitude accuracy in meters.
  ///
  /// If this location does not have a `altitudeAccuracy`, then `-1` is returned.
  ///
  /// ## iOS
  ///
  /// When this property contains 0 or a positive number, the value in the altitude property is plus or minus the specified number of meters. When this property contains a negative number, the value in the altitude property is invalid.
  ///
  /// Determining the [altitudeAccuracy] requires a device with GPS capabilities. Thus, on some devices, this property always contains a negative value.
  ///
  /// ## Android
  ///
  /// We define vertical accuracy at 68% confidence. Specifically, as 1-side of the 2-sided range above and below the estimated altitude reported by [altitude], within which there is a 68% probability of finding the true altitude.
  ///
  /// In the case where the underlying distribution is assumed Gaussian normal, this would be considered 1 standard deviation.
  ///
  /// For example, if [altitude] returns `150`, and [altitudeAccuracy] returns `20` then there is a 68% probability of the true altitude being between `130` and `170` meters.
  ///
  late double altitudeAccuracy;

  Coords(dynamic coords) {
    // Coords should parse "real" locations normally, but must tolerate synthetic/dummy
    // payloads (eg when SDK is disabled or permissions/services are unavailable).
    final Map c = _asMap(coords);

    // Required fields (real locations always provide these).  For dummy payloads, default to 0.
    latitude = _mapDouble(c, 'latitude', fallback: 0.0);
    longitude = _mapDouble(c, 'longitude', fallback: 0.0);
    accuracy = _mapDouble(c, 'accuracy', fallback: 0.0);
    altitude = _mapDouble(c, 'altitude', fallback: 0.0);

    // Optional / platform-dependent fields.
    // iOS dummy payload can omit ellipsoidal_altitude; fall back to altitude.
    ellipsoidalAltitude =
        _mapDouble(c, 'ellipsoidal_altitude', fallback: altitude);

    // GPS-only fields can be missing.  Use -1 when absent.
    heading = _mapDouble(c, 'heading', fallback: -1.0);
    headingAccuracy = _mapDouble(c, 'heading_accuracy', fallback: -1.0);
    speed = _mapDouble(c, 'speed', fallback: -1.0);
    speedAccuracy = _mapDouble(c, 'speed_accuracy', fallback: -1.0);

    // May be absent on some devices.
    altitudeAccuracy = _mapDouble(c, 'altitude_accuracy', fallback: -1.0);

    // iOS-only.
    floor = _mapInt(c, 'floor');
  }
  String toString() {
    return 'coords: $latitude,$longitude, acy: $accuracy, spd: $speed';
  }
}

/// Device battery information.
///
/// ```dart
/// BackgroundGeolocation.onLocation((Location location) {
///   bool isCharging = location.battery.isCharging;
///   double level    = location.battery.level;
///
///   print("[onLocation] Battery state, isCharging: $isCharging, level: $level");
/// });
/// ```
///
class Battery {
  /// `true` when device is plugged in to power.
  late bool isCharging;

  /// Battery level.  `0.0` = empty; `1.0` = full charge.
  late double level;

  Battery(dynamic battery) {
    final Map b = _asMap(battery);
    // Dummy payloads (or older native versions) may omit battery fields.
    isCharging = _mapBool(b, 'is_charging', fallback: false);
    level = _mapDouble(b, 'level', fallback: -1.0);
  }
}

/// Device motion-activity when this `Location` was recorded.
///
/// ```dart
/// BackgroundGeolocation.onLocation((Location location) {
///   activityType = location.activity.type;
///   int confidence = location.activity.confidence;
///
///   print("[onLocation] Motion activity, type: $activityType, confidence: $confidence");
/// });
/// ```
///
class Activity {
  /// The reported device motion activity.
  ///
  /// | Activity Name  |
  /// |----------------|
  /// | `still`        |
  /// | `walking`      |
  /// | `on_foot`      |
  /// | `running`      |
  /// | `on_bicycle`   |
  /// | `in_vehicle`   |
  /// | 'unknown`      |
  late String type;

  /// Confidence of the reported device motion activity in %.
  late int confidence;

  Activity(dynamic activity) {
    final Map a = _asMap(activity);

    // Synthetic/dummy locations (eg when SDK disabled / no permission) may omit `activity`.
    // Real locations should provide these fields.
    final dynamic t = a['type'];
    type = (t is String && t.isNotEmpty) ? t : 'unknown';

    confidence = _parseInt(a['confidence']) ?? 0;
  }
}

/// Location object provided to:
/// - [BackgroundGeolocation.onLocation]
/// - [BackgroundGeolocation.onMotionChange],
/// - [BackgroundGeolocation.getCurrentPosition].
///
/// ```dart
/// BackgroundGeolocation.onLocation((Location location) {
///   double accuracy = location.coords.accuracy;
///   double lat      = location.coords.latitude;
///   double lng      = location.coords.longitude;
///   double speed    = location.coords.speed;
///   double heading  = location.coords.heading;
///   double altitude = location.coords.altitude;
///
///   print("[onLocation] $location");
/// });
///
/// BackgroundGeolocation.onMotionChange(Location location) {
///   print("[onMotionChange] $location");
/// });
///
/// State state = await BackgroundGeolocation.ready(Config(
///   distanceFilter: 10.0
/// ));
///
/// Location location = await BackgroundGeolocation.getCurrentPosition();
/// print("[getCurrentPosition] location: $location");
/// ```
///
class Location {
  /// Original `Map` data received from native code.
  late dynamic map;

  /// Timestamp provided by the native location API.
  ///
  /// - When `PersistenceConfig.timestampFormat` is `"iso"` (default): ISO-8601 UTC `String` (eg `"2018-01-01T12:00:01.123Z"`).
  /// - When `PersistenceConfig.timestampFormat` is `"epoch"`: epoch milliseconds `int`.
  ///
  late dynamic timestamp;

  /// Timestamp when the SDK received the location from the native API.
  ///
  /// - When `PersistenceConfig.timestampFormat` is `"iso"` (default): ISO-8601 UTC `String`.
  /// - When `PersistenceConfig.timestampFormat` is `"epoch"`: epoch milliseconds `int`.
  ///
  late dynamic recordedAt;

  /// The age of the location in milliseconds, relative to the Device system-time when the location was received.
  /// For example, if the reported `age` is `10000`, that location was recorded 10s ago, relative to the system-time.
  /// `location.timestamp` + `location.age` = Device system-time when location was recorded.
  late double age;

  /// Event which caused this location to be recorded.
  ///
  /// `motionchange | heartbeat | providerchange | geofence`
  ///
  late String event;

  /// __`[Android only]`__ `true` if the location was provided by a Mock location app.
  late bool mock;

  /// `true` if this Location is just 1 of several samples before settling upon a final location.
  ///
  /// Multiple samples are requested when using [BackgroundGeolocation.getCurrentPosition] or when the plugin is performing a [BackgroundGeolocation.onMotionChange].
  /// If you're manually uploading locations to your server, you should __ignore__ those with `location.sample == true`.
  ///
  late bool sample;

  /// The current distance traveled.
  ///
  /// __See also:__
  /// - [BackgroundGeolocation.setOdometer]
  /// - [BackgroundGeolocation.odometer]
  ///
  late double odometer;

  /// `true` if this `Location` was recored while the device was in-motion.
  ///
  late bool isMoving;

  /// Universally Unique Identifier.
  ///
  /// This property is helpful for debugging location issues.  It can be used to match locations recorded at your server with those within the plugin's [Logger.getLog].
  ///
  late String uuid;

  /// Location coordinates.
  ///
  /// See [Coords].
  ///
  /// ```dart
  /// BackgroundGeolocation.onLocation((Location location) {
  ///   double accuracy = location.coords.accuracy;
  ///   double lat      = location.coords.latitude;
  ///   double lng      = location.coords.longitude;
  ///   double speed    = location.coords.speed;
  ///   double heading  = location.coords.heading;
  ///   double altitude = location.coords.altitude;
  ///
  ///   print("[onLocation] $location");
  /// });
  /// ```
  ///
  late Coords coords;

  /// Corresponding [GeofenceEvent] if this location was recorded due to a [Geofence] transition.
  ///
  /// See [GeofenceEvent]
  ///
  GeofenceEvent? geofence;

  /// Device battery-level when this `Location` was recorded.
  ///
  /// See [Battery]
  ///
  /// ```dart
  /// BackgroundGeolocation.onLocation((Location location) {
  ///   bool isCharging = location.battery.isCharging;
  ///   double level    = location.battery.level;
  ///
  ///   print("[onLocation] Battery state, isCharging: $isCharging, level: $level");
  /// });
  /// ```
  ///
  late Battery battery;

  /// Device motion-activity when this `Location` was recorded.
  ///
  /// See [Activity]
  ///
  /// ```dart
  /// BackgroundGeolocation.onLocation((Location location) {
  ///   activityType = location.activity.type;
  ///   int confidence = location.activity.confidence;
  ///
  ///   print("[onLocation] Motion activity, type: $activityType, confidence: $confidence");
  /// });
  /// ```
  ///
  late Activity activity;

  /// Arbitrary extras object from configured [PersistenceConfig.extras].
  ///
  Map? extras;

  Location(dynamic params) {
    final Map p = _asMap(params);

    map = params;

    // Always present in both real + dummy payloads.
    coords = Coords(p['coords']);

    // Optional objects can be missing in dummy payloads.
    battery = Battery(p['battery']);
    activity = Activity(p['activity']);

    // timestamp: String (ISO-8601) or int (epoch ms) depending on timestampFormat.
    timestamp = p['timestamp'] ?? '';

    // recorded_at may be absent in dummy payloads.
    recordedAt = p['recorded_at'] ?? timestamp;

    // age may be absent.
    age = _mapDouble(p, 'age', fallback: 0.0);

    // is_moving may be bool or 0/1.
    isMoving = _mapBool(p, 'is_moving', fallback: false);

    // uuid may be absent in dummy payloads.
    final dynamic u = p['uuid'];
    uuid = (u is String) ? u : (u?.toString() ?? '');

    odometer = _mapDouble(p, 'odometer', fallback: 0.0);

    sample = _mapBool(p, 'sample', fallback: false);

    final dynamic e = p['event'];
    event = (e is String) ? e : (e?.toString() ?? '');

    if (p['geofence'] != null) {
      geofence = GeofenceEvent(p['geofence']);
    }

    mock = _mapBool(p, 'mock', fallback: false);

    if (p['extras'] != null && p['extras'] is Map) {
      extras = Map.from(p['extras']);
    }
  }

  /// String representation of `Location` for `print` to logs.
  String toString() {
    return '[Location ${map.toString()}]';
  }

  /// Return original `Map` recevied from native code.
  Map toMap() {
    return map;
  }
}

/// Location Error
///
/// ## Error Codes
///
/// | Code  | Error                       |
/// |-------|-----------------------------|
/// | 0     | Location unknown            |
/// | 1     | Location permission denied  |
/// | 2     | Network error               |
/// | 3     | Attempt to initiate location-services in background with WhenInUse authorization |
/// | 408   | Location timeout            |
/// | 499   | Location request cancelled  |
///
class LocationError {
  /// Error code
  late int code;

  /// Error message
  late String message;

  LocationError(PlatformException e) {
    code = int.parse(e.code);
    message = e.message ?? "";
  }

  /// String representation of `Location` for `print` to logs.
  String toString() {
    return '[LocationError code: $code, message: $message]';
  }
}
