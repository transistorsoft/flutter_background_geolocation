part of flt_background_geolocation;

/// Event object provided to [BackgroundGeolocation.onConnectivityChange].
///
class ConnectivityChangeEvent {
  final bool connected;

  ConnectivityChangeEvent(this.connected);

  String toString() {
    return '[ConnectivityChangeEvent connected: ' + connected.toString() + ']';
  }
}
