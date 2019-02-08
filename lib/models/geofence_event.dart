part of flt_background_geolocation;

/// Geofence transition event provided to [BackgroundGeolocation.onGeofence]
///
/// ## Infinite Geofencing
///
/// The [BackgroundGeolocation] SDK contains powerful geofencing features that allow you to monitor any number of circular [Geofence] you wish (thousands even), in spite of limits imposed by the native platform APIs (**20 for iOS; 100 for Android**).
///
/// The plugin achieves this by storing your geofences in its database, using a [geospatial query](https://en.wikipedia.org/wiki/Spatial_query) to determine those geofences in proximity (see config [Config.geofenceProximityRadius]), activating only those geofences closest to the device's current location (according to limit imposed by the corresponding platform.
///
/// ![](https://dl.dropboxusercontent.com/s/7sggka4vcbrokwt/geofenceProximityRadius_iphone6_spacegrey_portrait.png?dl=1)
///
/// When the device is determined to be moving, the plugin periodically queries for geofences in proximity (eg. every minute) using the latest recorded location.  This geospatial query is **very fast**, even with tens-of-thousands geofences in the database.
///
/// ## Event: [BackgroundGeolocation.onGeofencesChange]
///
/// When a proximity-query detects a change in the list of monitored geofences, it will fire the [BackgroundGeolocation.onGeofencesChange] event, providing information about which geofences were activated as well as those which were de-activated.
///
/// The [GeofencesChangeEvent] provided to your `callback` contains properties [GeofencesChangeEvent.on] and [GeofencesChangeEvent.off] for determining those geofences which have started and stopped being actively monitored.
///
/// ```dart
/// BackgroundGeolocation.onGeofencesChange((GeofencesChangeEvent event) {
///   // Create map circles
///   event.on.forEach((Geofence geofence) {
///     createGeofenceMarker(geofence)
///   });
///
///   // Remove map circles
///   event.off.forEach((String identifier) {
///     removeGeofenceMarker(identifier);
///   }
/// });
/// ```
///
/// This [GeofencesChangeEvent] object provides only the *changed* geofences, those which were just activated or de-activated.
///
/// When **all** geofences have been removed, the event object will provide an empty List `[]` for both [GeofencesChangeEvent.on] and [GeofencesChangeEvent.off] properties.
///
///
/// ## [Config.geofenceProximityRadius]
///
/// Controls the circular area around the device's current position where geofences will be activated.  As the device moves, the plugin periodically queries for geofences in proximity of the last-recorded location (default once-per-minute).
///
/// You can change the [Config.geofenceProximityRadius] at any time -- the [BackgroundGeolocation.onGeofencesChange] event will immediately fire if the monitored list-of-geofences changed as a result:
///
/// ## Adding large lists of geofences
///
/// The plugin is perfectly capable of monitoring **large** lists of geofences (tested with tens-of-thousands).  However, when adding geofences, it's over **10* faster** to use the method [BackgroundGeolocation.addGeofences] (plural) rather than looping and executing [BackgroundGeolocation.addGeofence].
///
///
/// ## Initializing your Map with Geofences
///
/// If you render `Circle` markers on your map, you don't need to query your geofences with [BackgroundGeolocation.geofences].  This is particularly import when monitoring large lists of geofences.
///
/// Simply listen to the [BackgroundGeolocation.onGeofencesChange] event and render Map markers accordingly.
///
class GeofenceEvent {
  /// [Geofence.identifier] of the [Geofence] which fired.
  String identifier;

  /// The transition event that caused the geofence to fire (ENTER | EXIT | DWELL).
  String action;

  /// The [Location] where this geofence triggered.
  Location location;

  /// Optional [Geofence.extras]
  Map extras;

  GeofenceEvent(Map params) {
    // Remove geofence from location to prevent recursive creation of GeofenceEvent.
    Map locationData = params['location'];
    locationData.remove("geofence");

    this.identifier = params['identifier'];
    this.action = params['action'];
    this.location = new Location(locationData);
    this.extras = params['extras'];
  }

  String toString({compact: bool}) {
    return (compact == true)
        ? '$action: $identifier'
        : '[GeofenceEvent identifier: $identifier, action: $action]';
  }
}
