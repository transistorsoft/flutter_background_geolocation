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
  /// Device model
  String model;

  /// Device manufacturer
  String manufacturer;

  /// Device version
  String version;

  /// Platform iOS | Android
  String platform;

  /// Framework `Flutter|ReactNative|Cordova`
  String framework;

  static DeviceInfo? _instance;

  /// Retreive an singleton instance of `DeviceInfo`.
  static Future<DeviceInfo> getInstance() async {
    Completer completer = new Completer<DeviceInfo>();
    if (_instance == null) {
      Map map = (await _methodChannel.invokeMapMethod('getDeviceInfo'))!;
      _instance = new DeviceInfo(
          model: map['model'],
          manufacturer: map['manufacturer'],
          version: map['version'],
          platform: map['platform'],
          framework: map['framework']);
    }
    completer.complete(_instance);
    return completer.future as FutureOr<DeviceInfo>;
  }

  DeviceInfo(
      {required this.model,
      required this.manufacturer,
      required this.version,
      required this.platform,
      required this.framework});

  /// Return as `Map`
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
