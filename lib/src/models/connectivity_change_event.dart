part of flt_background_geolocation;

class ConnectivityChangeEvent {
  bool connected;

  ConnectivityChangeEvent(this.connected);

  String toString() {
    return '[ConnectivityChangeEvent connected: ' + connected.toString() + ']';
  }
}