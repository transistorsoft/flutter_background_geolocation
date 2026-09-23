part of '../flutter_background_geolocation.dart';

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
  late bool magnetometer;

  /// @deprecated Misspelled.  Use [magnetometer].
  ///
  /// (WO-035) The field was `magentometer` until now — it read the correctly spelled native key
  /// and stored it under a typo.  Kept as an alias so existing code compiles; it will go in a
  /// future major.
  @Deprecated('Use magnetometer — this was a typo')
  bool get magentometer => magnetometer;

  /// __`[iOS only]`__ `true` if this iOS device has an **M7** co-processor (iPhone 5S+).
  bool? motionHardware;

  /// __`[Android only]`__ `true` if this Android device has a "significant motion" sensor.
  bool? significantMotion;

  Sensors(Map data) {
    this.platform = data["platform"];
    this.accelerometer = data["accelerometer"];
    this.gyroscope = data["gyroscope"];
    this.magnetometer = data["magnetometer"];
    if (data["motion_hardware"] != null) {
      this.motionHardware = data["motion_hardware"];
    }
    if (data["significant_motion"] != null) {
      this.significantMotion = data["significant_motion"];
    }
  }

  String toString() {
    return '[Sensors platform: $platform, accelerometer: $accelerometer, gyroscope: $gyroscope, magnetometer: $magnetometer]';
  }
}
