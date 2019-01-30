part of flt_background_geolocation;

/// Device Settings API.
///
/// Provides an API to show Android & vendor-specific Battery / Power Management settings screens that can affect performance of the Background Geolocation SDK on various devices.
///
/// The site [Don't Kill My App](https://dontkillmyapp.com/) provides a comprehensive list of poor Android vendors which throttle background-services that this plugin relies upon.
///
/// This `DeviceSettings` API is an attempt to provide resources to direct the user to the appropriate vendor-specific settings screen to solve issues with background operation.
///
/// ![](https://dl.dropboxusercontent.com/s/u7ljngfecxvibyh/huawei-settings-battery-launch.jpg?dl=1)
/// ![](https://dl.dropboxusercontent.com/s/hd6yxw58hgc7ef4/android-settings-battery-optimization.jpg?dl=1)
///
///
/// ## Example
///
/// ```dart
/// // Is Android device ignoring power optimizations?
/// bool isIgnoring = await DeviceSettings.isIgnoringBatteryOptimizations;
/// if (isIgnoring) {
///   DeviceSettings.showIgnoreBatteryOptimizations();
/// }
///
/// // Is iOS/Android device in power-saving mode?
/// bool isPowerSaving = await DeviceSettings.isPowerSaveMode;
///
/// // Show Android vendor-specific "Power Manager" device settings screen (eg: Huawei)
/// DeviceSettings.showPowerManager();
/// ```
///
class DeviceSettings {
  static const String IGNORE_BATTERY_OPTIMIZATIONS =
      "IGNORE_BATTERY_OPTIMIZATIONS";
  static const String POWER_MANAGER = "POWER_MANAGER";

  /// Fetches the state of the operating-system's "Power Saving" mode.
  ///
  /// Power Saving mode can throttle certain services in the background, such as HTTP requests or GPS.
  ///
  ///  **NOTE:** You can listen to changes in the state of "Power Saving" mode from the event [BackgroundGeolocation.onPowerSaveChange].
  ///
  /// ## iOS
  ///
  /// iOS Power Saving mode can be engaged manually by the user in **Settings -> Battery** or from an automatic OS dialog.
  ///
  /// ![](https://dl.dropboxusercontent.com/s/lz3zl2jg4nzstg3/Screenshot%202017-09-19%2010.34.21.png?dl=1)
  ///
  /// ## Android
  ///
  /// Android Power Saving mode can be engaged manually by the user in **Settings -> Battery -> Battery Saver** or automatically with a user-specified "threshold" (eg: 15%).
  ///
  /// ![](https://dl.dropboxusercontent.com/s/raz8lagrqayowia/Screenshot%202017-09-19%2010.33.49.png?dl=1)
  ///
  /// ## Example
  ///
  /// ```dart
  /// bool isPowerSaveMode = await DeviceSettings.isPowerSaveMode;
  /// ```
  ///
  static Future<bool> get isPowerSaveMode async {
    return await _methodChannel.invokeMethod('isPowerSaveMode');
  }

  /// Returns `true` if device is ignoring battery optimizations for your app.
  ///
  /// In most cases, the Background Geolocation SDK **will perform normally** with battery optimizations.
  ///
  /// ![](https://dl.dropboxusercontent.com/s/hd6yxw58hgc7ef4/android-settings-battery-optimization.jpg?dl=1)
  ///
  ///
  /// ```dart
  /// bool isIgnoring = await DeviceSettings.isIgnoringBatteryOptimizations;
  /// ```
  ///
  static Future<bool> get isIgnoringBatteryOptimizations async {
    return await _methodChannel.invokeMethod('isIgnoringBatteryOptimizations');
  }

  /// Shows the Android *Ignore Battery Optimizations* settings screen.
  ///
  /// **Note:**  In most cases, the plugin **will perform normally** with battery optimizations.  You should only instruct the user to *Ignore Battery Optimizations* for your app as a last resort to solve issues with background operation.
  ///
  /// ![](https://dl.dropboxusercontent.com/s/hd6yxw58hgc7ef4/android-settings-battery-optimization.jpg?dl=1)
  ///
  /// **WARNING:**  Ignoring battery optimizations *will* cause your app to consume **much** more power.
  ///
  /// ```dart
  /// bool isIgnoring = await DeviceSettings.isIgnoringBatteryOptimizations;
  /// if (isIgnoring) {
  ///   DeviceSettings.showIgnoreBatteryOptimizations();
  /// }
  /// ```
  ///
  static Future<bool> showIgnoreBatteryOptimizations() async {
    List<dynamic> args = [IGNORE_BATTERY_OPTIMIZATIONS];
    return await _methodChannel.invokeMethod('showSettings', args);
  }

  /// Shows a vendor specific "Power Management" screen.
  ///
  /// ![](https://dl.dropboxusercontent.com/s/u7ljngfecxvibyh/huawei-settings-battery-launch.jpg?dl=1)
  /// ![](https://dl.dropboxusercontent.com/s/cce6jxuvxmecv2z/huawei-settings-battery-launch-apply.jpg?dl=1)
  ///
  /// The site [Don't Kill My App](https://dontkillmyapp.com/) provides a comprehensive list of poor Android vendors which throttle background-services that this plugin relies upon.
  ///
  /// Unfortunately, there's no possible way to determine if the user *actually* performs the desired action to "white list" your app on the shown settings-screen.
  /// For this reason, the SDK will show the screen only once, setting a flag to determine if shown already.
  ///
  /// ```dart
  /// DeviceSettings.showPowerManager();
  /// ```
  ///
  /// If you wish to ensure the screen is shown, provide the optional `bool force` param.
  ///
  /// ```dart
  /// DeviceSettings.showPowerManager(true);
  /// ```
  ///
  /// **NOTE:** Most devices have no vendor-specific "Power Management" screen (eg: Google Pixel).  Power Manager screens are available only for the following vendors:
  ///
  /// | Vendor                               | Settings Activity Name                                                 |
  /// |--------------------------------------|------------------------------------------------------------------------|
  /// | LeEco                                | `AutobootManageActivity`                                               |
  /// | Huawei                               | `StartupAppControlActivity`,`StartupAppControlActivity` (depends on OS version) |
  /// | Color OS                             | `StartupAppListActivity`                                               |
  /// | OPPO                                 | `StartupAppListActivity`                                               |
  /// | Vivo                                 | `BgStartUpManagerActivity`,`AddWhiteListActivity`,`BgStartUpManager` (depends on OS version)|
  /// | Samsung                              | `BatteryActivity`                                                      |
  /// | HTC                                  | `LandingPageActivity`                                                  |
  /// | Asus                                 | `AutobootManageActivity`                                               |
  /// | LeEco                                | `mobilemanager.MainActivity`                                           |
  ///
  static Future<bool> showPowerManager([bool force = false]) async {
    List<dynamic> args = [POWER_MANAGER, force];
    return await _methodChannel.invokeMethod('showSettings', args);
  }
}
