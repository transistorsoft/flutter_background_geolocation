part of flt_background_geolocation;

/// Circular Geofence class provided to [BackgroundGeolocation.addGeofence], [BackgroundGeolocation.addGeofences]
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

  /// Optional: a list of vertices (`[ [lat, lng],...]`) defining a Polygon geofence.  By default, geofences are circular.
  ///
  /// ℹ️ __*Polygon Geofencing*__ is [sold as a separate add-on](https://shop.transistorsoft.com/products/polygon-geofencing) (fully functional in *DEBUG* builds).
  ///
  ///
  /// When defining a polygon geofence, you do **not** provide [latitude], [longitude] or [radius] &mdash; those will be automatically calculated based upon the geometry of the polygon.
  ///
  /// The following image shows polygon geofences on a map:
  ///
  /// ![](https://dl.dropbox.com/scl/fi/xzf6yau5wcg1az8fy0lbm/geofencing-polygons-on-map.PNG?rlkey=e82h494msbgt8ngu4s2pjwemb&dl=1)
  ///
  /// The *blue polygons* represent the *actual* polygon geofences and the containing *green circles* are traditional circular geofences provided by the native *iOS/Android* Geofencing APIs.  The background-geolocation SDK automatically calculates the containing, native cirular geofence by solving the [*minimum enclosing circle*](https://en.wikipedia.org/wiki/Smallest-circle_problem) for the given [vertices].
  /// This is why you do not provide [latitude], [longitude] and [radius].
  ///
  /// - When the device *enters* the containing circular geofence, the SDK uses that as a signal that the device is approaching a polygon.  At this moment, the SDK begins aggressively monitoring the location to perform "hit-testing" upon the polygon using a fast algorithm implemented with C++ code.
  /// - When the device *exits* the containing circular geofence, that's the SDK's signal for it to *cease* monitoring that polygon.
  ///
  /// ## Example
  /// ```dart
  /// BackgroundGeolocation.addGeofence(Geofence(
  ///   identifier: 'Home',
  ///   notifyOnEntry: true,
  ///   notifyOnExit: true,
  ///   vertices: [
  ///     [45.518947279987714, -73.6049889209514],  // <-- [lat, lng]
  ///     [45.5182711292279, -73.60338649600598],
  ///     [45.517082240237634, -73.60432670908212],
  ///     [45.51774871402813, -73.60604928622278]
  ///   ]
  /// ));
  /// ```
  /// ![](https://dl.dropbox.com/scl/fi/ee85vo9ams6y3pmo2dw54/geofencing-add-polygon.PNG?rlkey=wordjd5hbiyiyc0y03qagou3b&dl=1)
  ///
  /// #### Entering / exiting a *cross-shaped* polygon geofence.:
  ///
  /// ![](https://dl.dropbox.com/scl/fi/iorrnrm0zno91jtg0ctse/polygon-geofencing-cross.PNG?rlkey=p4kufqhxgw9jrmuz4vkqisprw&dl=1)
  ///
  /// #### Entering / exiting a park:
  ///
  /// ![](https://dl.dropbox.com/scl/fi/qvg9n3s5iacje5szgcqfv/polygon-geofencing-parc-outremont.PNG?rlkey=c6iax7a19db2v6xdxf18k2a7k&dl=1)
  ///
  /// #### Entering / exiting a diamond-shaped polygon:
  ///
  /// ![](https://dl.dropbox.com/scl/fi/29m3xwb7tm0532mthgjfy/polygon-geofencing-diamond.PNG?rlkey=9ucc5hs7460ig7226iutas4cw&dl=1)
  ///
  /// #### Designing a polygon geofence around a park using the demo app:
  ///
  /// ![](https://dl.dropbox.com/scl/fi/806mxnz9cdfd4ely8uwfe/polygon-geofencing-parc-lafontaine.PNG?rlkey=yrlbfisx8o5itfz6h0d0inel1&dl=1)
  ///
  List<List<double>>? vertices;

  /// Arbitrary key/values appended to the recorded geofence record.
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
    if (radius != null) this.radius = radius * 1.0;
    if (latitude != null) this.latitude = latitude * 1.0;
    if (longitude != null) this.longitude = longitude * 1.0;

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
