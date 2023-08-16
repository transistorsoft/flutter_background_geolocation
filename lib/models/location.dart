part of flt_background_geolocation;

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

  /// [iOS] Altitude above sea-level in meters.
  /// [Android] The altitude of this location in meters above the WGS84 reference ellipsoid.
  /// - See [ellipsoidal_altitude]
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
    this.latitude = coords['latitude'] * 1.0;
    this.longitude = coords['longitude'] * 1.0;
    this.accuracy = coords['accuracy'] * 1.0;
    this.altitude = coords['altitude'] * 1.0;
    this.ellipsoidalAltitude = coords['ellipsoidal_altitude'] * 1.0;
    this.heading = coords['heading'] * 1.0;
    if (coords['heading_accuracy'] != null) {
      this.headingAccuracy = coords['heading_accuracy'] * 1.0;
    }
    this.speed = coords['speed'] * 1.0;
    if (coords['speed_accuracy'] != null) {
      this.speedAccuracy = coords['speed_accuracy'] * 1.0;
    }
    if (coords['altitude_accuracy'] != null) {
      this.altitudeAccuracy = coords['altitude_accuracy'] * 1.0;
    }
    this.floor = coords['floor'];
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
    this.isCharging = battery['is_charging'];
    this.level = battery['level'] * 1.0;
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
    this.type = activity['type'];
    this.confidence = activity['confidence'];
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

  /// Timestamp in __`ISO 8601` (UTC) format.
  ///
  /// Eg: `2018-01-01T12:00:01.123Z'.
  ///
  late String timestamp;

  /// The age of the location in milliseconds, relative to the Device system-time when the location was received.
  /// For example, if the reported `age` is `10000`, that location was recorded 10s ago, relative to the system-time.
  /// `location.timestamp` + `location.age` = Device system-time when location was recorded.
  late int age;

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

  /// Arbitrary extras object from configured [Config.extras].
  ///
  Map? extras;

  Location(dynamic params) {
    this.map = params;
    this.coords = new Coords(params['coords']);
    this.battery = new Battery(params['battery']);
    this.activity = new Activity(params['activity']);

    this.timestamp = params['timestamp'];
    this.age = params['age'];
    this.isMoving = params['is_moving'];
    this.uuid = params['uuid'];
    this.odometer = params['odometer'] * 1.0;

    this.sample = (params['sample'] != null) ? params['sample'] : false;
    this.event = (params['event'] != null) ? params['event'] : '';

    if (params['geofence'] != null) {
      this.geofence = new GeofenceEvent(params['geofence']);
    }
    this.mock = (params['mock'] != null) ? params['mock'] : false;

    if (params['extras'] != null) {
      this.extras = params['extras'];
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
