part of flt_background_geolocation;

/// Event object provided to [BackgroundGeolocation.onConnectivityChange].
///
class ConnectivityChangeEvent {
  /// `true` when the device has access to a network connection.
  ///
  final bool connected;

  ConnectivityChangeEvent(this.connected);

  String toString() {
    return '[ConnectivityChangeEvent connected: ' + connected.toString() + ']';
  }
}
