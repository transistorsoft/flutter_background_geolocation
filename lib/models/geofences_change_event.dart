part of '../flutter_background_geolocation.dart';

/// Event object provided to [BackgroundGeolocation.onGeofencesChange].
///
/// Expresses a change in the list of actively monitored geofences by the native geofencing API.
///
class GeofencesChangeEvent {
  /// List of [Geofence.identifier] which stopped being monitored.
  ///
  /// The plugin ceases active-monitoring upon those [Geofence] whose center coordinate lies outside of [GeoConfig.geofenceProximityRadius].  `off` is a list of those [Geofence.identifier].
  ///
  late List<String> off;

  /// List of [Geofence] which the plugin has just begun active-monitoring upon.
  ///
  /// The plugin active-monitors only those [Geofence] whose center coordinate lies within [GeoConfig.geofenceProximityRadius].  `on` is a list of those [Geofence].
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
      // check for polygon geofence.
      List<List<double>> vertices = [];
      if (data['vertices'] != null) {
        (data['vertices'] as List<Object?>).forEach((vertex) {
          List<double> v = List.from(vertex as List);
          vertices.add(v);
        });
      }

      final geofence = Geofence(
          identifier: data['identifier'],
          radius: data['radius'] * 1.0,
          latitude: data['latitude'] * 1.0,
          longitude: data['longitude'] * 1.0,
          vertices: vertices,
          extras: (data['extras'] != null)
              ? data['extras'].cast<String, dynamic>()
              : {},
          notifyOnEntry: data['notifyOnEntry'],
          notifyOnExit: data['notifyOnExit'],
          notifyOnDwell: data['notifyOnDwell'],
          loiteringDelay: loiteringDelay);

      // 🔹 NEW: hydrate readonly runtime fields from native payload.
      if (data['hits'] != null) {
        geofence.hits = (data['hits'] as num).toInt();
      }
      if (data['entryState'] != null) {
        geofence.entryState = (data['entryState'] as num).toInt();
      }
      if (data['stateUpdatedAt'] != null) {
        geofence.stateUpdatedAt = (data['stateUpdatedAt'] as num).toDouble();
      }
      this.on.add(geofence);
    });
  }

  /// String representation of `GeofencesChangeEvent` for `print` to logs.
  String toString() {
    return '[GeofencesChangeEvent off: $off, on: $on]';
  }
}
