part of flt_background_geolocation;

/// Event object provided to [BackgroundGeolocation.onHeartbeat].
///
class HeartbeatEvent {
  /// Last known position of the device.
  ///
  /// __Note:__ [BackgroundGeolocation] does not actively request the current position during each [BackgroundGeolocation.onHeartbeat] event.  This is only the last known position.
  ///
  /// If you wish for the current position, you can choose to request in your [BackgroundGeolocation.onHeartbeat] callback.
  ///
  /// ## Example
  ///
  /// ```dart
  /// BackgroundGeolocation.onHeartbeat((HeartbeatEvent event) {
  ///   Location location = BackgroundGeolocation.getCurrentPosition(
  ///     samples: 1,
  ///     extras: {
  ///       "foo": "bar"
  ///     }
  ///   );
  /// });
  Location? location;

  HeartbeatEvent(dynamic event) {
    if (event['location'] != null) {
      try {
        this.location = new Location(event['location']);
      } catch (e) {
        print(e.toString());
      }
    }
  }

  /// String representation of `HeartbeatEvent` for `print` to logs.
  String toString() {
    return '[HeartbeatEvent location:$location]';
  }
}
