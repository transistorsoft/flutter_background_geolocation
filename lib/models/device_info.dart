part of flt_background_geolocation;

/// Returns basic device information, including [model], [manufacturer], [version] & [platform]`.
///
/// ## Example
///
/// ```dart
/// DeviceInfo deviceInfo = await DeviceInfo.getInstance();
/// print('- DeviceInfo: Manufacturer: ${deviceInfo.manufacturer}, Model: ${deviceInfo.model}, Version: ${deviceInfo.version}, Platform: ${deviceInfo.platform}');
/// ```
///
class DeviceInfo {
  String model;
  String manufacturer;
  String version;
  String platform;
  String framework;

  static DeviceInfo _instance;

  static Future<DeviceInfo> getInstance() async {
    Completer completer = new Completer<DeviceInfo>();
    if (_instance == null) {
      Map map = await _methodChannel.invokeMethod('getDeviceInfo');
      _instance = new DeviceInfo(
          model: map['model'],
          manufacturer: map['manufacturer'],
          version: map['version'],
          platform: map['platform'],
          framework: map['framework']);
    }
    completer.complete(_instance);
    return completer.future;
  }

  DeviceInfo(
      {this.model,
      this.manufacturer,
      this.version,
      this.platform,
      this.framework});

  Map<String, dynamic> toMap() {
    return {
      "model": model,
      "manufacturer": manufacturer,
      "version": version,
      "platform": platform,
      "framework": framework
    };
  }
}
