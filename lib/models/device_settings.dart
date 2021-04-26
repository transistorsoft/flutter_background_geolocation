part of flt_background_geolocation;

/// An object for redirecting a User to an Android device's settings screen from a [DeviceSettings] request.
///
/// This object contains meta-data about the device ([manufacturer], [model], [version]) in addition to a flag [seen] to let you know if you've
/// already shown some particular screen to the user.  [lastSeenAt] lets you know the `DateTime` you last showed a particular screen to the user.
///
class DeviceSettingsRequest {
  /// Device manufacturer.
  late String manufacturer;

  /// Device model
  late String model;

  /// OS version
  late String version;

  /// Flag showing whether you've already shown this screen to the user.
  late bool seen;

  /// The [DateTime] you last showed this screen to the user.
  DateTime? lastSeenAt;

  /// The settings screen to be shown (eg: [DeviceSettings.IGNORE_BATTERY_OPTIMIZATIONS], [DeviceSettings.POWER_MANAGER]).
  ///
  /// This property is set automatically.
  late String action;

  DeviceSettingsRequest(
      {required String action,
      required String manufacturer,
      required String model,
      required String version,
      required bool seen,
      required int lastSeenAt}) {
    this.action = action;
    this.manufacturer = manufacturer;
    this.model = model;
    this.version = version;
    this.seen = seen;
    this.lastSeenAt = (lastSeenAt > 0)
        ? DateTime.fromMillisecondsSinceEpoch(lastSeenAt)
        : null;
  }

  /// Return info as `Map`.
  Map toMap() {
    return {
      "manufacturer": manufacturer,
      "model": model,
      "version": version,
      "seen": seen,
      "lastSeenAt": lastSeenAt,
      "action": action
    };
  }
}

/// Device Settings API.
///
/// Provides an API to show Android & vendor-specific Battery / Power Management settings screens that can affect performance of the Background Geolocation SDK on various devices.
///
/// The site [Don't Kill My App](https://dontkillmyapp.com/) provides a comprehensive list of poor Android vendors which throttle background-services that this plugin relies upon.
///
/// This `DeviceSettings` API is an attempt to provide resources to direct the user to the appropriate vendor-specific settings screen to resolve issues with background operation.
///
/// ![](https://dl.dropboxusercontent.com/s/u7ljngfecxvibyh/huawei-settings-battery-launch.jpg?dl=1)
/// ![](https://dl.dropboxusercontent.com/s/hd6yxw58hgc7ef4/android-settings-battery-optimization.jpg?dl=1)
///
///
/// ## Example
///
/// ```dart
/// // Is Android device ignoring battery optimizations?
/// bool isIgnoring = await DeviceSettings.isIgnoringBatteryOptimizations;
/// if (!isIgnoring) {
///   DeviceSettings.showIgnoreBatteryOptimizations().then((DeviceSettingsRequest request) {
///     print("- Screen seen? ${request.seen} ${request.lastSeenAt}");
///     print("- Device: ${request.manufacturer} ${request.model} ${request.version}");
///
///     // If we've already shown this screen to the user, we don't want to annoy them.
///     if (request.seen) {
///       return;
///     }
///
///     // It's your responsibility to instruct the user what exactly
///     // to do here, perhaps with a Confirm Dialog:
///     showMyConfimDialog(
///       title: "Settings request",
///       text: "Please disable battery optimizations for your device"
///     ).then((bool confirmed) {
///       if (confirmed) {
///         // User clicked [Confirm] button.  Execute the redirect to settings screen:
///         DeviceSettings.show(request);
///       }
///     });
///   }).catchError((dynamic error) {
///     // Depending on Manufacturer/Model/OS Version, a Device may not implement
///     // a particular Settings screen.
///     print(error);
///   });
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
    return (await _methodChannel.invokeMethod<bool>('isPowerSaveMode'))
        as FutureOr<bool>;
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
    return (await _methodChannel.invokeMethod<bool>(
        'isIgnoringBatteryOptimizations')) as FutureOr<bool>;
  }

  /// Shows the Android *Ignore Battery Optimizations* settings screen.
  ///
  /// **Note:**  In most cases, the plugin **will perform normally** with battery optimizations.  You should only instruct the user to *Ignore Battery Optimizations* for your app as a last resort to resolve issues with background operation.
  ///
  /// ![](https://dl.dropboxusercontent.com/s/hd6yxw58hgc7ef4/android-settings-battery-optimization.jpg?dl=1)
  ///
  /// **WARNING:**  Ignoring battery optimizations *will* cause your app to consume **much** more power.
  ///
  /// `showIgnoreBatteryOptimizations` does **not** immediately redirect to the desired Device settings screen.  Instead, it first returns a [DeviceSettingsRequest], containing
  /// meta-data about the device (`manufacturer`, `model`, `version`), in addition to a flags `seen` and `lastSeenAt`, letting you know if and when you've already shown this screen to the user.
  ///
  ///
  /// In your success-callback, it's completely **up to you** to instruct the user what exactly to do on that screen.
  ///
  /// Based upon the manufacturer/model/os, a Device may not have this particular Settings screen implemented.  In this case, `catchError` will fire.
  ///
  /// ## Example
  ///
  /// ```dart
  /// // Is Android device ignoring battery optimizations?
  /// bool isIgnoring = await DeviceSettings.isIgnoringBatteryOptimizations;
  /// if (!isIgnoring) {
  ///   DeviceSettings.showIgnoreBatteryOptimizations().then((DeviceSettingsRequest request) {
  ///     print("- Screen seen? ${request.seen} ${request.lastSeenAt}");
  ///     print("- Device: ${request.manufacturer} ${request.model} ${request.version}");
  ///
  ///     // If we've already shown this screen to the user, we don't want to annoy them.
  ///     if (request.seen) {
  ///       return;
  ///     }
  ///
  ///     // It's your responsibility to instruct the user what exactly
  ///     // to do here, perhaps with a Confirm Dialog:
  ///     showMyConfirmDialog(
  ///       title: "Settings request",
  ///       text: "Please disable battery optimizations for your device"
  ///     ).then((bool confirmed) {
  ///       if (confirmed) {
  ///         // User clicked [Confirm] button.  Execute the redirect to settings screen:
  ///         DeviceSettings.show(request);
  ///       }
  ///     });
  ///   }).catchError((dynamic error) {
  ///     // Depending on Manufacturer/Model/OS Version, a Device may not implement
  ///     // a particular Settings screen.
  ///     print(error);
  ///   });
  /// }
  /// ```
  ///
  static Future<DeviceSettingsRequest> showIgnoreBatteryOptimizations() async {
    List<dynamic> args = [IGNORE_BATTERY_OPTIMIZATIONS];

    Map request =
        (await _methodChannel.invokeMapMethod('requestSettings', args))!;
    return new DeviceSettingsRequest(
        action: request['action'],
        manufacturer: request['manufacturer'],
        model: request['model'],
        version: request['version'],
        seen: request['seen'],
        lastSeenAt: request['lastSeenAt']);
  }

  /// Shows a vendor-specific "Power Management" screen.
  ///
  /// For example, a *Huawei* device will show the *Battery->Launch* screen:
  ///
  /// ![](https://dl.dropboxusercontent.com/s/u7ljngfecxvibyh/huawei-settings-battery-launch.jpg?dl=1)
  /// ![](https://dl.dropboxusercontent.com/s/cce6jxuvxmecv2z/huawei-settings-battery-launch-apply.jpg?dl=1)
  ///
  /// The site [Don't Kill My App](https://dontkillmyapp.com/) provides a comprehensive list of poor Android vendors which throttle background-services that this plugin relies upon.
  ///
  /// `showPowerManager` does **not** immediately redirect to the desired Device settings screen.  Instead, it first returns a [DeviceSettingsRequest], containing
  /// meta-data about the device (`manufacturer`, `model`, `version`), in addition to a flags `seen` and `lastSeenAt`, letting you know if and when you've already shown this screen to the user.
  ///
  /// Unfortunately, there's no possible way to determine if the user *actually* performs the desired action to "white list" your app on the shown settings-screen.
  /// For this reason, you'll have to evaluate the provided properties [DeviceSettingsRequest.seen]] &amp; [DeviceSettingsRequest.lastSeenAt] and determine for yourself whether to [DeviceSettings.show] this screen.
  ///
  /// In your success-callback, it's completely **up to you** to instruct the user what exactly to do on that screen, based upon the provided [DeviceSettingsRequest] properties `manufacturer`, `model` and `version`.
  ///
  /// **Note:**  Based upon the `manufacturer` / `model` / OS `version`, a Device **may not have** a particular Settings screen implemented (eg: Google Pixel).  In this case, the `Promise` will fire an exception.
  ///
  /// ## Example
  ///
  /// ```dart
  /// DeviceSettings.showPowerManager().then((DeviceSettingsRequest request) {
  ///   print("- Screen seen? ${request.seen} ${request.lastSeenAt}");
  ///   print("- Device: ${request.manufacturer} ${request.model} ${request.version}");
  ///
  ///   // If we've already shown this screen to the user, we don't want to annoy them.
  ///   if (request.seen) {
  ///     return;
  ///   }
  ///   // It's your responsibility to instruct the user what exactly
  ///   // to do here, perhaps with a Confirm Dialog:
  ///   showMyConfirmDialog(
  ///     title: "Device Power Management",
  ///     text: "Please white-list the app in your Device's Power Management settings by clicking this then selecting that."
  ///   ).then((bool confirmed) {
  ///     if (confirmed) {
  ///       // User clicked [Confirm] button.  Execute the redirect to settings screen:
  ///       DeviceSettings.show(request);
  ///     }
  ///   });
  /// }).catchError((dynamic error) {
  ///   // Depending on Manufacturer/Model/OS Version, a Device may not implement
  ///   // a particular Settings screen.
  ///   print(error);
  /// });
  /// ```
  ///
  /// ## Vendor Settings Screens
  ///
  /// The following Android Settings screen will be shown depending on Vendor / OS version:
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
  static Future<DeviceSettingsRequest> showPowerManager() async {
    List<dynamic> args = [POWER_MANAGER];
    Map request =
        (await _methodChannel.invokeMapMethod('requestSettings', args))!;
    return new DeviceSettingsRequest(
        action: request['action'],
        manufacturer: request['manufacturer'],
        model: request['model'],
        version: request['version'],
        seen: request['seen'],
        lastSeenAt: request['lastSeenAt']);
  }

  /// This method is designed to be executed from a [showPowerManager] or [showIgnoreBatteryOptimizations] callback.
  static Future<bool> show(DeviceSettingsRequest request) async {
    List<dynamic> args = [request.action];
    return (await _methodChannel.invokeMethod<bool>('showSettings', args))
        as FutureOr<bool>;
  }
}
