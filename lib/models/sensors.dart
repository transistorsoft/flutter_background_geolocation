part of flt_background_geolocation;

/// Expresses the presence of detected motion-related sensors of the device.
///
/// See [BackgroundGeolocation.sensors].
///
class Sensors {
  String platform;
  bool accelerometer;
  bool gyroscope;
  bool magentometer;
  bool motionHardware;
  Sensors(this.platform, this.accelerometer, this.gyroscope, this.magentometer,
      this.motionHardware);
}
