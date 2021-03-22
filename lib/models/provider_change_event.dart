part of flt_background_geolocation;

/// Event object provided to [BackgroundGeolocation.onProviderChange]
///
class ProviderChangeEvent {
  static const AUTHORIZATION_STATUS_NOT_DETERMINED = 0;
  static const AUTHORIZATION_STATUS_RESTRICTED = 1;
  static const AUTHORIZATION_STATUS_DENIED = 2;
  static const AUTHORIZATION_STATUS_ALWAYS = 3;
  static const AUTHORIZATION_STATUS_WHEN_IN_USE = 4;

  static const ACCURACY_AUTHORIZATION_FULL = 0;
  static const ACCURACY_AUTHORIZATION_REDUCED = 1;

  /// `true` when device location-services is enabled.
  late bool enabled;

  /// `AUTORIZATION_STATUS`
  ///
  /// Expresses a change in the configuration of native location-services (eg: disabled, GPS off, etc).
  ///
  /// | Name                                  | Platform      |
  /// |---------------------------------------|---------------|
  /// | [AUTHORIZATION_STATUS_NOT_DETERMINED] | iOS only      |
  /// | [AUTHORIZATION_STATUS_RESTRICTED]     | iOS only      |
  /// | [AUTHORIZATION_STATUS_DENIED]         | iOS & Android |
  /// | [AUTHORIZATION_STATUS_ALWAYS]         | iOS & Android |
  /// | [AUTHORIZATION_STATUS_WHEN_IN_USE]    | iOS & Android 10+ |
  ///
  late int status;

  /// `true` if network location provider is enabled.
  late bool network;

  /// `true` if GPS location provider is enabled.
  late bool gps;

  /// __`[iOS 14+]`__ iOS 14 has introduced a new __`[Precise: On]`__ switch on the location authorization dialog allowing users to disable high-accuracy location.
  ///
  /// This attribute shows the state of that switch:
  /// - Enabled:  [ProviderChangeEvent.ACCURACY_AUTHORIZATION_FULL].
  /// - Disabled, [ProviderChangeEvent.ACCURACY_AUTHORIZATION_REDUCED].
  ///
  /// ![](https://dl.dropbox.com/s/dj93xpg51vspqk0/ios-14-precise-on.png?dl=1)
  ///
  /// ## Example
  ///
  /// ```dart
  /// BackgroundGeolocation.onProviderChange((ProviderChangeEvent event) {
  ///   int authorizationStatus = event.authorizationStatus;
  ///   if (authorizationStatus == ProviderChangeEvent.ACCURACY_AUTHORIZATION_REDUCED) {
  ///     BackgroundGeolocaiton.requestTemporaryFullAccuracy("MyPurposeString").then((int accuracyAuthorization) {
  ///       print("RESULT:  $accuracyAuthorization");
  ///     }).catchError((error) {
  ///       print("ERROR:  Failed to show dialog: $error");
  ///     });
  ///   }
  /// });
  /// ```
  ///
  /// __See also:__
  /// - [BackgroundGeolocation.requestTemporaryFullAccuracy]
  /// - [What's new in iOS 14 `CoreLocation`](https://levelup.gitconnected.com/whats-new-with-corelocation-in-ios-14-bd28421c95c4)
  ///
  late int accuracyAuthorization;

  // event['enabled'], event['status'], event['network'], event['gps']);
  ProviderChangeEvent(Map event) {
    this.enabled = event['enabled'];
    this.status = event['status'];
    this.network = event['network'];
    this.gps = event['gps'];

    if (event['accuracyAuthorization'] != null) {
      this.accuracyAuthorization = event['accuracyAuthorization'];
    } else {
      this.accuracyAuthorization = ACCURACY_AUTHORIZATION_FULL;
    }
  }

  /// Return String representation of `ProviderChangeEvent` for `print` to logs.
  String toString() {
    return '[ProviderChangeEvent enabled:$enabled, status: $status, network: $network, gps: $gps, accuracyAuthorization: $accuracyAuthorization]';
  }

  /// Return `Map` representaion of `ProviderChangeEvent`
  Map<String, dynamic> toMap() {
    return {
      'enabled': enabled,
      'status': status,
      'network': network,
      'gps': gps,
      'accuracyAuthorization': accuracyAuthorization
    };
  }
}
