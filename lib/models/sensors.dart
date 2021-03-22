part of flt_background_geolocation;

/// Expresses the presence of detected motion-related sensors of the device.
///
/// See [BackgroundGeolocation.sensors].
///
class Sensors {
  /// Device platform `ios | android`.
  late String platform;

  /// `true` if this device has an accelerometer.
  late bool accelerometer;

  /// `true` if this device has a gyroscope.
  late bool gyroscope;

  /// `true` if this device has a magnetometer (compass).
  late bool magentometer;

  /// __`[iOS only]`__ `true` if this iOS device has an **M7** co-processor (iPhone 5S+).
  bool? motionHardware;

  /// __`[Android only]`__ `true` if this Android device has a "significant motion" sensor.
  bool? significantMotion;

  Sensors(Map data) {
    this.platform = data["platform"];
    this.accelerometer = data["accelerometer"];
    this.gyroscope = data["gyroscope"];
    this.magentometer = data["magnetometer"];
    if (data["motion_hardware"] != null) {
      this.motionHardware = data["motion_hardware"];
    }
    if (data["significant_motion"] != null) {
      this.significantMotion = data["significant_motion"];
    }
  }

  String toString() {
    return '[Sensors platform: $platform, accelerometer: $accelerometer, gyroscope: $gyroscope, magnetometer: $magentometer]';
  }
}
