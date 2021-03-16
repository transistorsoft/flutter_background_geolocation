part of flt_background_geolocation;

/// Event object provided to [BackgroundGeolocation.onGeofencesChange].
///
/// Expresses a change in the list of actively monitored geofences by the native geofencing API.
///
class GeofencesChangeEvent {
  /// List of [Geofence.identifier] which stopped being monitored.
  ///
  /// The plugin ceases active-monitoring upon those [Geofence] whose center coordinate lies outside of [Config.geofenceProximityRadius].  `off` is a list of those [Geofence.identifier].
  ///
  List<String>? off;

  /// List of [Geofence] which the plugin has just begun active-monitoring upon.
  ///
  /// The plugin active-monitors only those [Geofence] whose center coordinate lies within [Config.geofenceProximityRadius].  `on` is a list of those [Geofence].
  ///
  late List<Geofence> on;

  GeofencesChangeEvent(List on, List off) {
    this.off = off.cast<String>();
    this.on = [];

    on.forEach((dynamic data) {
      dynamic loiteringDelay = data['loiteringDelay'];
      if (loiteringDelay.runtimeType == double) {
        loiteringDelay = loiteringDelay.toInt();
      }
      this.on.add(new Geofence(
          identifier: data['identifier'],
          radius: data['radius'] * 1.0,
          latitude: data['latitude'] * 1.0,
          longitude: data['longitude'] * 1.0,
          extras: (data['extras'] != null)
              ? data['extras'].cast<String, dynamic>()
              : {},
          notifyOnEntry: data['notifyOnEntry'],
          notifyOnExit: data['notifyOnExit'],
          notifyOnDwell: data['notifyOnDwell'],
          loiteringDelay: loiteringDelay));
    });
  }

  /// String representation of `GeofencesChangeEvent` for `print` to logs.
  String toString({compact: bool}) {
    if (compact == true) {
      List<String?> identifiersOn = [];
      on.forEach((Geofence geofence) => identifiersOn.add(geofence.identifier));
      return 'on: $identifiersOn, off: $off';
    } else {
      return '[GeofencesChangeEvent off: $off, on: $on]';
    }
  }
}
