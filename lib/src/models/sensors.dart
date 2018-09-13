part of flt_background_geolocation;

class Sensors {
  String platform;
  bool accelerometer;
  bool gyroscope;
  bool magentometer;
  bool motionHardware;
  Sensors(this.platform, this.accelerometer, this.gyroscope, this.magentometer, this.motionHardware);
}