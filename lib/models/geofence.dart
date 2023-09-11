part of flt_background_geolocation;

/// Circular Geofence class provided to [BackgroundGeolocation.addGeofence] and [BackgroundGeolocation.addGeofences].
///
class Geofence {
  /// Unique identifier.
  late String identifier;

  /// Circular geofence radius.
  double? radius;

  /// Latitude of the Geofence center.
  double? latitude;

  /// Longitude of the Geofence center.
  double? longitude;

  /// Set `true` to fire on entering the geofence.
  bool? notifyOnEntry;

  /// Set `true` fire on exiting the geofence.
  bool? notifyOnExit;

  /// Set `true` to fire only after remaining withing geofence for [loiteringDelay] milliseconds.
  bool? notifyOnDwell;

  /// The number of milliseconds the device must remain within geofence before firing [notifyOnDwell] event.
  int? loiteringDelay;

  /// __:warning: NOT YET IMPLEMENTED__
  /// Optional: a list of vertices composing the Polygon geofence.  By default, geofences are circular.
  List<List<double>>? vertices;

  /// Arbitrary key/values to append to the recorded geofence record.
  Map<String, dynamic>? extras;

  Geofence(
      {required String identifier,
      double? radius,
      double? latitude,
      double? longitude,
      bool? notifyOnEntry,
      bool? notifyOnExit,
      bool? notifyOnDwell,
      int? loiteringDelay,
      Map<String, dynamic>? extras,
      List<List<double>>? vertices}) {
    
    if (vertices == null) {
      // Circular Geofence
      if (radius == null || latitude == null || longitude == null) {
        throw ArgumentError("Geofence requires radius, latitude and longitude");
      }
    } else {
      // Polygon Geofence
      this.vertices = vertices;
    }
    if (radius != null) this.radius = radius! * 1.0;
    if (latitude != null) this.latitude = latitude! * 1.0;
    if (longitude != null) this.longitude = longitude! * 1.0;
    
    this.identifier = identifier;
    this.notifyOnEntry = notifyOnEntry;
    this.notifyOnExit = notifyOnExit;
    this.notifyOnDwell = notifyOnDwell;
    this.loiteringDelay = loiteringDelay;
    this.extras = extras;
  }

  /// Return `Geofence` as `Map`.
  Map<String, dynamic> toMap() {
    Map<String, dynamic> params = {};
    params['identifier'] = this.identifier;
    params['radius'] = this.radius;
    params['latitude'] = this.latitude;
    params['longitude'] = this.longitude;
    if (this.notifyOnEntry != null) {
      params['notifyOnEntry'] = this.notifyOnEntry;
    }
    if (this.notifyOnExit != null) {
      params['notifyOnExit'] = this.notifyOnExit;
    }
    if (this.notifyOnDwell != null) {
      params['notifyOnDwell'] = this.notifyOnDwell;
    }
    if (this.loiteringDelay != null) {
      params['loiteringDelay'] = this.loiteringDelay;
    }
    if (this.extras != null) {
      params['extras'] = this.extras;
    }
    if (this.vertices != null) {
      params['vertices'] = this.vertices;
    }
    return params;
  }

  /// String representation of `Geofence` for `print` to log.
  String toString() {
    return '[Geofence identifier: $identifier, radius: $radius, $latitude / $longitude, notifyOnEntry:$notifyOnEntry, notifyOnExit:$notifyOnExit, notifyOnDwell: $notifyOnDwell, vertices: $vertices"]';
  }
}
