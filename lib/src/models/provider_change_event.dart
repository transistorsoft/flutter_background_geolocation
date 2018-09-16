part of flt_background_geolocation;

class ProviderChangeEvent {
  bool enabled;
  int status;
  bool network;
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
