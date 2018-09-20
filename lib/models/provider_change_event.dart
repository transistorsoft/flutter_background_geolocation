part of flt_background_geolocation;

/// Event object provided to [BackgroundGeolocation.onProviderChange]
/// 
/// Expresses a change in the configuration of native location-services (eg: disabled, GPS off, etc).
/// 
/// | Name | Value | Platform |
/// |------|-------|----------|
/// | [AUTHORIZATION_STATUS_NOT_DETERMINED] | `0` | iOS only |
/// | [AUTHORIZATION_STATUS_RESTRICTED] | `1` | iOS only |
/// | [AUTHORIZATION_STATUS_DENIED] | `2` | iOS & Android |
/// | [AUTHORIZATION_STATUS_ALWAYS] | `3` | iOS & Android |
/// | [AUTHORIZATION_STATUS_WHEN_IN_USE] | `4` | iOS only |
/// 
class ProviderChangeEvent {
  static const AUTHORIZATION_STATUS_NOT_DETERMINED = 0;
  static const AUTHORIZATION_STATUS_RESTRICTED = 1;
  static const AUTHORIZATION_STATUS_DENIED = 2;
  static const AUTHORIZATION_STATUS_ALWAYS = 3;
  static const AUTHORIZATION_STATUS_WHEN_IN_USE = 4;

  bool enabled;
  int  status;
  bool  network;
  bool  gps;

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
