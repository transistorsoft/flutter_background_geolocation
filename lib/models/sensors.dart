part of flt_background_geolocation;

/// Expresses the presence of detected motion-related sensors of the device.
///
/// See [BackgroundGeolocation.sensors].
///
class Sensors {
  /// Device platform `ios | android`.
  String platform;
  /// `true` if this device has an accelerometer.
  bool accelerometer;
  /// `true` if this device has a gyroscope.
  bool gyroscope;
  /// `true` if this device has a magentometer (compass).
  bool magentometer;
  /// __`[iOS only]`__ `true` if this iOS device has an **M7** co-processor (iPhone 5S+).
  bool motionHardware;
  /// __`[Android only]`__ `true` if this Android device has a "significant motion" sensor.
  bool significantMotion;

  Sensors(this.platform, this.accelerometer, this.gyroscope, this.magentometer,
      this.motionHardware, this.significantMotion);
}
