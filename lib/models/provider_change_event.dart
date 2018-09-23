part of flt_background_geolocation;

/// Event object provided to [BackgroundGeolocation.onProviderChange]
///
class ProviderChangeEvent {
  static const AUTHORIZATION_STATUS_NOT_DETERMINED = 0;
  static const AUTHORIZATION_STATUS_RESTRICTED = 1;
  static const AUTHORIZATION_STATUS_DENIED = 2;
  static const AUTHORIZATION_STATUS_ALWAYS = 3;
  static const AUTHORIZATION_STATUS_WHEN_IN_USE = 4;

  /// `true` when device location-services is enabled.
  bool enabled;

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
  /// | [AUTHORIZATION_STATUS_WHEN_IN_USE]    | iOS only      |
  ///
  int status;

  /// `true` if network location provider is enabled.
  bool network;

  /// `true` if GPS location provider is enabled.
  bool gps;

  ProviderChangeEvent(this.enabled, this.status, this.network, this.gps);

  String toString() {
    return '[ProviderChangeEvent enabled:$enabled, status: $status, network: $network, gps: $gps]';
  }

  Map<String, dynamic> toMap() {
    return {
      'enabled': enabled,
      'status': status,
      'network': network,
      'gps': gps
    };
  }
}
