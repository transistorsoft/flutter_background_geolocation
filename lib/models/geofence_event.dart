part of flt_background_geolocation;

/// Event-object provided to [BackgroundGeolocation.onGeofence].
///
/// ## Example
///
/// ```dart
/// BackgroundGeolocation.onGeofence((GeofenceEvent event) {
///   print('[geofence] ${event.identifier}, ${event.action}');
/// });
/// ```
///
/// # Geofencing Guide
/// ---------------------------------------------------------------------------------------------------------
///
/// The Background Geolocation SDK implements the native iOS and Android Geofencing APIs.
///
/// __ℹ️ Note:__
/// - Native iOS & Android API support only *circular* geofences, however the plugin does implement a custom mechanism for handling *Polygon Geofences*; see [Geofence.vertices].
/// - The minimum reliable [Geofence.radius] is `200` meters.
/// - The native geofencing API for both iOS and Android *require* the user authorize [Config.locationAuthorizationRequest] **`Always`** &mdash; **`When in Use`** will **not** work.
///
/// ## Adding Geofences
/// ---------------------------------------------------------------------------------------------------------
///
/// Adding a single geofence with [BackgroundGeolocation.addGeofence].
///
/// ### Example
///
/// ```dart
/// BackgroundGeolocation.addGeofence(Geofence(
///   identifier: "Home",
///   radius: 200,
///   latitude: 45.51921926,
///   longitude: -73.61678581,
///   notifyOnEntry: true,
///   notifyOnExit: true,
///   extras: {
///     "route_id": 1234
///   }
/// )).then((bool success) {
///   print('[addGeofence] success');
/// }).catchError((dynamic error) {
///   print('[addGeofence] FAILURE: $error');
/// });
/// ```
///
/// Adding multiple geofences with [BackgroundGeolocation.addGeofences].
///
/// ### Example
/// ```dart
/// await BackgroundGeolocation.addGeofences([Geofence(
///   identifier: "Home",
///   radius: 200,
///   latitude: 45.51921926,
///   longitude: -73.61678581,
///   notifyOnEntry: true,
/// ), Geofence(
///   identifier: "Work",
///   radius: 200,
///   latitude: 45.61921927,
///   longitude: -73.71678582,
///   notifyOnEntry: true
/// )]);
/// print('[addGeofences] success');
/// ```
///
/// __ℹ️ Note:__ Adding a geofence having an [Geofence.identifier] which already exists within the SDK's geofence database will cause the previous record to be destroyed and the new one inserted.
///
/// ## Listening for Geofence Events
///
/// Listen to geofence events with [BackgroundGeolocation.onGeofence].
///
/// ### Example
///
/// ```dart
/// // Listen for geofence events.
/// BackgroundGeolocation.onGeofence((GeofenceEvent event) {
///   print('[geofence] ${event.identifier}, ${event.action}');
/// });
/// ```
///
/// # Polygon Geofencing
///
/// The Background Geolocation SDK supports *Polygon Geofences* (Geofences of any shape).  See API docs [Geofence.vertices].
/// ℹ️ __*Polygon Geofencing*__ is [sold as a separate add-on](https://shop.transistorsoft.com/products/polygon-geofencing) (fully functional in *DEBUG* builds).
///
///
/// ![](https://dl.dropbox.com/scl/fi/sboshfvar0h41azmb4tyv/polygon-geofencing-parc-outremont-400.png?rlkey=d2s0n3zbzu72e7s2gch9kxd4a&dl=1)
/// ![](https://dl.dropbox.com/scl/fi/xz48myvjnpp8ko0l2tufg/polygon-geofencing-parc-lafontaine-400.png?rlkey=sf20ns959uj0a0fq0atmj55bz&dl=1)
///
/// # Infinite Geofencing
///
/// The Background Geolocation SDK contains unique and powerful Geofencing features that allow you to monitor any number of circular geofences you wish (thousands even), in spite of limits imposed by the native platform APIs (**20 for iOS; 100 for Android**).
///
/// The SDK achieves this by storing your geofences in its database, using a [geospatial query](https://en.wikipedia.org/wiki/Spatial_query) to determine those geofences in proximity ([Config.geofenceProximityRadius]), activating only those geofences closest to the device's current location (according the limit imposed by the corresponding platform).
///
/// ![](https://www.transistorsoft.com/shop/products/assets/images/background-geolocation-infinite-geofencing.gif)
///
/// - When the device is determined to be moving, the plugin periodically queries for geofences within the [Config.geofenceProximityRadius] (eg. every minute) using the latest recorded location.  This geospatial query is **very fast**, even with tens-of-thousands geofences in the database.
/// - The SDK **enforces** a *minimum* [Config.geofenceProximityRadius] of `1000` meters.
/// - In the following image, the *green* geofences within [Config.geofenceProximityRadius] are *actively* monitored.  The *grey* geofences outside [Config.geofenceProximityRadius] still exist within the SDK's database but are *not* actively being monitored.
///
/// ![](https://dl.dropboxusercontent.com/s/7sggka4vcbrokwt/geofenceProximityRadius_iphone6_spacegrey_portrait.png?dl=1)
///
/// ## Listening for changes in the actively-monitored set-of-geofences.
///
/// As the SDK periodically queries for geofences within the [Config.geofenceProximityRadius], you can listen for changes in the actively-monitored geofences using the event [BackgroundGeolocation.onGeofencesChange].  This event will let you know those geofences which have *begun* to be *actively monitored* ([GeofencesChangeEvent.on]) in addition to those which just *ceased* to be actively monitored ([GeofencesChangeEvent.off]).
///
/// ### Example
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
///   });
/// });
/// ```
///
/// ### ⚠️ Note:
/// - When **all** geofences have been removed, the [GeofencesChangeEvent] will provide empty lists for both [GeofencesChangeEvent.on] & [GeofencesChangeEvent.off].
///
/// ## Removing Geofences
///
/// Once a geofence has been inserted into the SDK's database using [BackgroundGeolocation.addGeofence] or [BackgroundGeolocation.addGeofences], they will be monitored *forever* (as long as the plugin remains `State.enabled == true`).  If you've configured [Config.stopOnTerminate] __`false`__ and [Config.startOnBoot] __`true`__, geofences will continue to be monitored even if the application is terminated or device rebooted.
/// To cease monitoring a geofence or *geofences*, you must *remove* them from the SDK's database (or call [BackgroundGeolocation.stop]).
///
/// ### Removing a single geofence by [Geofence.identifier]:
///
/// ```dart
/// BackgroundGeolocation.removeGeofence('HOME').then((bool success) {
///   print('[removeGeofence] success');
/// });
/// ```
///
/// ### Removing *all* geofences with [BackgroundGeolocation.removeGeofences]:
///
/// ```dart
/// BackgroundGeolocation.removeGeofences().then((bool success) {
///   print('[removeGeofences] all geofences have been destroyed');
/// });
/// ```
///
/// # Querying Geofences
///
/// Use the method [BackgroundGeolocation.geofences] property to retrieve the entire Array of [Geofence] stored in the SDK's database:
///
/// ```dart
/// List<Geofence> geofences = await BackgroundGeolocation.geofences;
/// print('[getGeofences: $geofences');
/// ```
///
/// Or fetch a single geofence by [Geofence.identifier] with [BackgroundGeolocation.getGeofence] :
///
/// ```dart
/// Geofence geofence = await BackgroundGeolocation.getGeofence("home");
/// print('[getGeofence] $geofence');
/// ```
///
/// # Monitoring *only* geofences
///
/// The BackgroundGeolocation SDK allows you to optionally monitor *only* geofences without constant location-tracking.  To engage *geofences-only* mode, use the method [BackgroundGeolocation.startGeofences] instead of [BackgroundGeolocation.start].
///
/// Use option [Config.geofenceModeHighAccuracy]:true to improve the responsiveness of geofence events.
///
/// ```dart
/// BackgroundGeolocation.onGeofence((GeofenceEvent event) {
///   print('[geofence]: ' + event.toString());
/// });
///
/// BackgroundGeolocation.ready(Config(
///   url: 'http://your.server.com/geofences',
///   autoSync: true,
///   geofenceModeHighAccuracy: true   // <-- consumes more power; default is false.
/// )).then((State state) {
///   // engage geofences-only mode:
///   BackgroundGeolocation.startGeofences();
/// });
/// ```
///
/// #  Toggling between tracking-modes [BackgroundGeolocation.start] and [BackgroundGeolocation.startGeofences]:
///
/// The SDK can easily be toggled between [State.trackingMode] simply by executing the corresponding [BackgroundGeolocation.start] or [BackgroundGeolocation.startGeofences] methods.
///
/// ```dart
/// // Listen to geofence events
/// BackgroundGeolocation.onGeofence((GeofenceEvent event) {
///   print('[geofence] ' + event.toString());
///   if (event.identifier == 'DANGER_ZONE') {
///     if (event.action == 'ENTER') {
///       // Entering the danger-zone, we want to aggressively track location.
///       BackgroundGeolocation.start();
///     } else if (event.action == 'EXIT') {
///       // Exiting the danger-zone, we resume geofences-only tracking.
///       BackgroundGeolocation.startGeofences();
///     }
///   }
/// });
///
/// // Add a geofence.
/// BackgroundGeolocation.addGeofence(Geofence(
///   identifier: "DANGER_ZONE",
///   radius: 1000,
///   latitude: 45.51921926,
///   longitude: -73.61678581,
///   notifyOnEntry: true,
///   notifyOnExit: true,
/// ));
///
/// // Ready the plugin.
/// BackgroundGeolocation.ready(Config(
///   desiredAccuracy: BackgroundGeolocation.DESIRED_ACCURACY_HIGH,
///   distanceFilter: 10,
///   url: 'http://your.server.com/locations',
///   autoSync: true
/// )).then((State state) {
///   BackgroundGeolocation.startGeofences();
/// });
/// ```
///
class GeofenceEvent {
  /// [Geofence.identifier] of the [Geofence] which fired.
  late String identifier;

  /// The transition event that caused the geofence to fire (ENTER | EXIT | DWELL).
  late String action;

  /// The [Location] where this geofence triggered.
  late Location location;

  /// The device system time when the Geofence event was received by the OS.  __Note__: this can differ from the timestamp of the triggering location responsible for the geofence (the triggering location can be from the past).
  late String timestamp;

  /// Optional [Geofence.extras]
  Map? extras;

  GeofenceEvent(Map params) {
    // Remove geofence from location to prevent recursive creation of GeofenceEvent.
    Map locationData = params['location'];
    locationData.remove("geofence");

    this.identifier = params['identifier'];
    this.action = params['action'];
    this.timestamp = params['timestamp'];
    this.location = new Location(locationData);
    this.extras = params['extras'];
  }

  /// String representation of `GeofenceEvent` for `print` to logs.
  String toString() {
    return '[GeofenceEvent identifier: $identifier, action: $action, timestamp: $timestamp]';
  }
}
