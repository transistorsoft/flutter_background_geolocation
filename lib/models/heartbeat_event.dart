part of flt_background_geolocation;

/// Event object provided to [BackgroundGeolocation.onHeartbeat].
/// 
class HeartbeatEvent {
  Location location;

  HeartbeatEvent(dynamic event) {
    if (event['location'] != null) {
      try {
        this.location = new Location(event['location']);
      } catch (e) {
        print(e.toString());
      }
    }
  }

  String toString() {
    return '[HeartbeatEvent location:$location]';
  }
}
