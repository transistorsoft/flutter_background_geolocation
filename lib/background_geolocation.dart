part of flt_background_geolocation;

const _PLUGIN_PATH = "com.transistorsoft/flutter_background_geolocation";
const _METHOD_CHANNEL_NAME = "$_PLUGIN_PATH/methods";

const _EVENT_CHANNEL_LOCATION = "$_PLUGIN_PATH/events/" + Event.LOCATION;
const _EVENT_CHANNEL_MOTIONCHANGE = "$_PLUGIN_PATH/events/" + Event.MOTIONCHANGE;
const _EVENT_CHANNEL_ACTIVITYCHANGE = "$_PLUGIN_PATH/events/" + Event.ACTIVITYCHANGE;
const _EVENT_CHANNEL_PROVIDERCHANGE = "$_PLUGIN_PATH/events/" + Event.PROVIDERCHANGE;
const _EVENT_CHANNEL_GEOFENCESCHANGE = "$_PLUGIN_PATH/events/" + Event.GEOFENCESCHANGE;
const _EVENT_CHANNEL_GEOFENCE = "$_PLUGIN_PATH/events/" + Event.GEOFENCE;
const _EVENT_CHANNEL_HEARTBEAT = "$_PLUGIN_PATH/events/" + Event.HEARTBEAT;
const _EVENT_CHANNEL_HTTP = "$_PLUGIN_PATH/events/" + Event.HTTP;
const _EVENT_CHANNEL_SCHEDULE = "$_PLUGIN_PATH/events/" + Event.SCHEDULE;
const _EVENT_CHANNEL_POWERSAVECHANGE = "$_PLUGIN_PATH/events/" + Event.POWERSAVECHANGE;
const _EVENT_CHANNEL_CONNECTIVITYCHANGE =
    "$_PLUGIN_PATH/events/" + Event.CONNECTIVITYCHANGE;
const _EVENT_CHANNEL_ENABLEDCHANGE = "$_PLUGIN_PATH/events/" + Event.ENABLEDCHANGE;


class _Subscription {
  final StreamSubscription<dynamic> subscription;
  final Function callback;

  _Subscription(this.subscription, this.callback);
}

/// Primary plugin API.
///
/// ## Events
/// 
/// [BackgroundGeolocation] is event-based.
/// 
/// | Method                 | Description                             |
/// |------------------------|-----------------------------------------|
/// | [onLocation]           | Fired with each recorded [Location]     |
/// | [onMotionChange]       | Fired when the plugin changes state between *moving* / *stationary* |
/// | [onHttp]               | Fired with each HTTP response from your server.  (see [Config.url]). |
/// | [onActivityChange]     | Fired with each change in device motion-activity.                    |
/// | [onProviderChange]     | Fired after changes to device location-services configuration.       |
/// | [onHeartbeat]          | Periodic timed events.  See [Config.heartbeatInterval].  iOS requires [Config.preventSuspend]. |
/// | [onGeofence]           | Fired with each [Geofence] transition event (`ENTER, EXIT, DWELL`).  |
/// | [onGeofencesChange]    | Fired when the list of actively-monitored geofences changed.  See [Config.geofenceProximityRadius]. |
/// | [onSchedule]           | Fired for [Config.schedule] events.                                  |
/// | [onConnectivityChange] | Fired when network-connectivity changes (connected / disconnected).  |
/// | [onPowerSaveChange]    | Fired when state of operating-system's "power-saving" feature is enabled / disabld. |
/// | [onEnabledChange]      | Fired when the plugin is enabled / disabled via its [start] / [stop] methods.        |
/// 
/// ## Example
///
///  **NOTE**: `import '...' as bg`
/// This is to namespace the plugin's classes, a number of which use common names,
/// such as `State`, `Config`, `Location`, etc.
///
/// ```dart
/// import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
///
/// class _MyHomePageState extends State<MyHomePage> {
///   @override
///   void initState() {
///     // 1.  Listen to events (See docs for all 12 available events).
///     //
///     // Fired whenever a location is recorded
///     bg.BackgroundGeolocation.onLocation((bg.Location location) {
///       print('[location] - $location');
///     });
///
///     // Fired whenever the plugin changes motion-state (stationary->moving and vice-versa)
///     bg.BackgroundGeolocation.onMotionChange((bg.Location location) {
///       print('[motionchange] - $location');
///     });
///
///     // Fired whenever the state of location-services changes.  Always fired at boot
///     bg.BackgroundGeolocation.onProviderChange((bg.ProviderChangeEvent event) {
///       print('[providerchange] - $event');
///     });
///
///     ////
///     // 2.  Configure the plugin
///     //
///     bg.BackgroundGeolocation.ready(bg.Config(
///         desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
///         distanceFilter: 10.0,
///         stopOnTerminate: false,
///         startOnBoot: true,
///         debug: true,
///         logLevel: bg.Config.LOG_LEVEL_VERBOSE,
///         reset: true
///     )).then((bg.State state) {
///       if (!state.enabled) {
///         ////
///         // 3.  Start the plugin.
///         //
///         bg.BackgroundGeolocation.start();
///       }
///     });
///   }
/// }
/// ```
///
class BackgroundGeolocation {
  // MethodChannel
  static const MethodChannel _methodChannel =
      const MethodChannel(_METHOD_CHANNEL_NAME);

  // EventChannels
  static const EventChannel _eventChannelMotionChange =
      const EventChannel(_EVENT_CHANNEL_MOTIONCHANGE);
  static const EventChannel _eventChannelLocation =
      const EventChannel(_EVENT_CHANNEL_LOCATION);
  static const EventChannel _eventChannelActivityChange =
      const EventChannel(_EVENT_CHANNEL_ACTIVITYCHANGE);
  static const EventChannel _eventChannelProviderChange =
      const EventChannel(_EVENT_CHANNEL_PROVIDERCHANGE);
  static const EventChannel _eventChannelGeofencesChange =
      const EventChannel(_EVENT_CHANNEL_GEOFENCESCHANGE);
  static const EventChannel _eventChannelGeofence =
      const EventChannel(_EVENT_CHANNEL_GEOFENCE);
  static const EventChannel _eventChannelHeartbeat =
      const EventChannel(_EVENT_CHANNEL_HEARTBEAT);
  static const EventChannel _eventChannelHttp =
      const EventChannel(_EVENT_CHANNEL_HTTP);
  static const EventChannel _eventChannelSchedule =
      const EventChannel(_EVENT_CHANNEL_SCHEDULE);
  static const EventChannel _eventChannelPowerSaveChange =
      const EventChannel(_EVENT_CHANNEL_POWERSAVECHANGE);
  static const EventChannel _eventChannelConnectivityChange =
      const EventChannel(_EVENT_CHANNEL_CONNECTIVITYCHANGE);
  static const EventChannel _eventChannelEnabledChange =
      const EventChannel(_EVENT_CHANNEL_ENABLEDCHANGE);

  // Event Subscriptions
  static List<_Subscription> _subscriptions = new List();
  // Stream Listeners
  static Stream<Location> _eventsLocation;
  static Stream<Location> _eventsMotionChange;
  static Stream<ActivityChangeEvent> _eventsActivityChange;
  static Stream<ProviderChangeEvent> _eventsProviderChange;
  static Stream<GeofencesChangeEvent> _eventsGeofencesChange;
  static Stream<GeofenceEvent> _eventsGeofence;
  static Stream<HeartbeatEvent> _eventsHeartbeat;
  static Stream<HttpEvent> _eventsHttp;
  static Stream<State> _eventsSchedule;
  static Stream<bool> _eventsPowerSaveChange;
  static Stream<ConnectivityChangeEvent> _eventsConnectivityChange;
  static Stream<bool> _eventsEnabledChange;

  /// Return the current [State] of the plugin, including all [Config] parameters.
  ///
  /// ```dart
  /// State state = await BackgroundGeolocation.state();
  ///
  static Future<State> get state async {
    Map state = await _methodChannel.invokeMethod('getState');
    return new State(state);
  }

  ///
  /// Signal to the plugin that your app is launched and ready, proving the default [Config].
  ///
  /// The supplied [Config] will be applied **only at first install** of your app — for every launch thereafter,
  /// the plugin will automatically load its last-known configuration from persisent storage.
  /// The plugin always remembers the configuration you apply to it.
  ///
  ///
  /// ```dart
  /// BackgroundGeolocation.ready(Config(
  ///   desiredAccuracy: Config.DESIRED_ACCURACY_HIGH,
  ///   distanceFilter: 10,
  ///   stopOnTerminate: false,
  ///   startOnBoot: true,
  ///   url: 'http://your.server.com',
  ///   headers: {
  ///     'my-auth-token': 'secret-token'
  ///   }
  /// )).then((State state) {
  ///   print('[ready] success: $state');
  /// });
  /// ```
  ///
  ///  **WARNING:** The **`#ready`** method only applies the supplied [Config] for the **first launch of the app** &mdash;
  /// Forever after, the plugin is going to remember **every configuration change** you apply at runtime (eg: [setConfig]) and reload that *same config* every time your app boots.
  ///
  /// ## The [reset] method.
  ///
  /// If you wish, you can use the [reset] method to reset all [Config] options to documented default-values (with optional overrides):
  ///
  /// ```dart
  ///
  /// BackgroundGeolocation.reset();
  /// // Reset to documented default-values with overrides
  /// bgGeo.reset(Config(
  ///   distanceFilter:  10
  /// ));
  /// ```
  ///
  /// ## [Config.reset]: true
  ///
  /// Optionally, you can set [Config.reset] to `true`  This is helpful during development.  This will esentially *force* the supplied [Config] to be applied with *each launch* of your application.
  ///
  /// ## Example
  ///
  // ```dart
  /// BackgroundGeolocation.ready(Config(
  ///   reset: true,  // <-- set true to ALWAYS apply supplied config; not just at first launch.
  ///   distanceFilter: 50
  /// }).then((State state) {
  ///   print('[ready] - $state')
  /// });
  ///
  static Future<State> ready(Config config) async {
    Map state = await _methodChannel.invokeMethod('ready', config.toMap());
    return new State(state);
  }

  ///
  /// Re-configure the plugin's [Config] parameters.
  ///
  /// The supplied [Config] will be appended to the current configuration and applied in realtime.
  ///
  /// ## Example
  ///
  /// ```dart
  /// BackgroundGeolocation.setConfig(Config(
  ///   desiredAccuracy: Config.DESIRED_ACCURACY_HIGH,
  ///   distanceFilter: 100.0,
  ///   stopOnTerminate: false,
  ///   startOnBoot: true
  /// )).then((State state) {
  ///   print('[setConfig] success: $state');
  /// })
  /// ```
  ///
  static Future<State> setConfig(Config config) async {
    Map state = await _methodChannel.invokeMethod('setConfig', config.toMap());
    return new State(state);
  }

  /// Resets the plugin configuration to documented default-values.
  ///
  /// If an optional [Config] is provided, it will be applied *after* the configuration reset.
  ///
  static Future<State> reset([Config config]) async {
    Map state = await _methodChannel.invokeMethod(
        'reset', (config != null) ? config.toMap() : null);
    return new State(state);
  }

  /// Enable location tracking.
  ///
  /// This is the plugin's power **ON** button.  The plugin will initially start into its **stationary** state, fetching an initial location before turning off location services.
  /// Android will be monitoring its **Activity Recognition System** while iOS will create a stationary geofence around the current location.  **NOTE** If you've configured a
  /// [Config.schedule], this method will override that schedule and engage tracking immediately.
  ///
  /// ## Example
  ///
  /// ```dart
  /// BackgroundGeolocation.start.then((State state) {
  ///   print('[start] success - $state');
  /// });
  /// ```
  /// For more information, see [Philosophy of Operation](https://github.com/transistorsoft/flutter_background_geolocation/wiki/Philosophy-of-Operation)
  ///
  static Future<State> start() async {
    Map state = await _methodChannel.invokeMethod('start');
    return new State(state);
  }

  /// Disable location tracking.
  ///
  /// ## Example
  ///
  /// ```dart
  /// BackgroundGeolocation.stop();
  /// ```
  ///
  ///  **WARNING:** If you've configured a [Config.schedule], **`#stop`** will **not** halt the Scheduler.  You must explicitly stop the Scheduler as well:
  ///
  /// ```dart
  /// // Later when you want to stop the Scheduler (eg: user logout)
  /// BackgroundGeolocation.stopSchedule();
  /// ```
  /// 
  static Future<State> stop() async {
    Map state = await _methodChannel.invokeMethod('stop');
    return new State(state);
  }

  /// Initiate the configure [Config.schedule].
  ///
  /// If a [Config.schedule] was configured, this method will initiate that schedule.  The plugin will automatically be started or stopped according to the configured [Config.schedule].
  ///
  /// ## Example
  ///
  /// ```dart
  /// BackgroundGeolocation.startSchedule.then((State state) {
  ///   print('[startSchedule] success: $state');
  /// })
  /// ```
  ///
  static Future<State> startSchedule() async {
    Map state = await _methodChannel.invokeMethod('startSchedule');
    return new State(state);
  }

  /// Halt scheduled tracking.
  ///
  /// ```dart
  /// BackgroundGeolocation.stopSchedule.then((State state) {
  ///   print('[stopSchedule] success: $state');
  /// })
  /// ```
  ///
  ///  **WARNING:** [stopSchedule] will **not** execute [stop] if the plugin is currently tracking.  You must explicitly execute [stop].
  ///
  /// ## Example
  ///
  /// ```dart
  /// // Later when you want to stop the Scheduler (eg: user logout)
  /// await BackgroundGeolocation.stopSchedule().then((State state) {
  ///   if (state.enabled) {
  ///     BackgroundGeolocation.stop();
  ///   }
  /// })
  /// ```
  ///
  static Future<State> stopSchedule() async {
    Map state = await _methodChannel.invokeMethod('stopSchedule');
    return new State(state);
  }

  ///
  /// Engages the geofences-only [State.trackingMode].
  ///
  /// In this mode, no active location-tracking will occur -- only geofences will be monitored.  To stop monitoring "geofences" `trackingMode`, simply use the usual [stop] method.
  ///
  /// ## Example
  ///
  /// ```dart
  /// // Add a geofence.
  /// BackgroundGeolocation.addGeofence(Geofence(
  ///   notifyOnExit: true,
  ///   radius: 200,
  ///   identifier: 'ZONE_OF_INTEREST',
  ///   latitude: 37.234232,
  ///   longitude: 42.234234
  /// ));
  ///
  /// // Listen to geofence events.
  /// BackgroundGeolocation.onGeofence((GeofenceEvent event) {
  ///   print('[onGeofence] - $event')
  /// });
  ///
  /// BackgroundGeolocation.ready(Config(
  ///   url: 'http://my.server.com',
  ///   autoSync: true
  /// ).then((State state) {
  ///   BackgroundGeolocation.startGeofences();
  /// });
  /// ```
  ///
  static Future<State> startGeofences() async {
    Map state = await _methodChannel.invokeMethod('startGeofences');
    return new State(state);
  }

  /// Sends a signal to iOS that you wish to perform a long-running task.
  ///
  /// iOS will not suspend your app until you signal completion with the [finish] method.  Your callback will be provided with a single parameter `taskId` which you will send to the [finish] method.
  ///
  /// ## Example
  ///
  /// ```dart
  /// BackgroundGeolocation.startBackgroundTask().then((int taskId) {
  ///   // Perform some long-running task (eg: HTTP request)
  ///   performLongRunningTask.then(() {
  ///     // When your long-running task is complete, signal completion of taskId.
  ///     BackgroundGeolocation.finish(taskId);
  ///   });
  /// });
  /// ```
  ///
  ///  **WARNING:** iOS provides **exactly** 180s of background-running time.  If your long-running task exceeds this time, the plugin has a fail-safe which will automatically [finish] your **`taskId`** to prevent the OS from force-killing your application.
  ///
  static Future<int> startBackgroundTask() async {
    return await _methodChannel.invokeMethod('startBackgroundTask');
  }

  /// Signal completion of [startBackgroundTask]
  ///
  /// Sends a signal to the native OS that your long-running task, addressed by `taskId` privided by [startBackgroundTask] is complete and the OS may proceed to suspend your application if applicable.
  ///
  static Future<int> finish(int taskId) async {
    return await _methodChannel.invokeMethod('finish', taskId);
  }

  /// Manually toggles the plugin's **motion state** between **stationary** and **moving**.
  ///
  /// When provided a value of  **`true`**, the plugin will engage location-services and begin aggressively tracking the device's location *immediately*, bypassing stationary monitoring.
  ///
  /// If you were making a "Jogging" application, this would be your **`[Start Workout]`** button to immediately begin location-tracking.  Send **`false`** to turn **off** location-services and return the plugin to the **stationary** state.
  ///
  /// ## Example
  ///
  /// ```dart
  /// BackgroundGeolocation.changePace(true);  // <-- Location-services ON ("moving" state)
  /// BackgroundGeolocation.changePace(false); // <-- Location-services OFF ("stationary" state)
  /// ```
  ///
  static Future<bool> changePace(bool isMoving) async {
    return await _methodChannel.invokeMethod('changePace', isMoving);
  }

  /// Retrieves the current [Location].
  ///
  /// This method instructs the native code to fetch exactly one location using maximum power & accuracy.  The native code will persist the fetched location to
  /// its SQLite database just as any other location in addition to POSTing to your configured [Config.url].
  /// If an error occurs while fetching the location, `catchError` will be provided with an **`Integer`** [Error Code](https://github.com/transistorsoft/flutter_background_geolocation/wiki/Location-Error-Codes).
  ///
  /// ## Options
  ///
  /// #### `@config {int seconds} timeout [30]` An optional location-timeout.  If the timeout expires before a [Location] is retrieved, an error will fire..
  ///
  /// #### `@config {int millis} maximumAge [0]` Accept the last-recorded-location if no older than supplied value in milliseconds.
  ///
  /// #### `@config {bool} persist [true]` Defaults to `true`.  Set `false` to disable persisting the retrieved [Location] in the plugin's SQLite database.
  ///
  /// #### `@config {int} samples [3]` Sets the maximum number of location-samples to fetch.  The plugin will return the [Location] having the best accuracy.  Defaults to `3`.  Only the final [Location] will be persisted.
  ///
  /// #### `@config {int} desiredAccuracy [Config.stationaryRadius]` Sets the desired accuracy of location you're attempting to fetch.  When a location having `accuracy <= desiredAccuracy` is retrieved, the plugin will stop sampling and immediately return that location.  Defaults to your configured [Config.stationaryRadius].
  ///
  /// #### `@config {Map} extras` Optional extra-data to attach to the location.  These `extras` will be merged to the configure [Config.extras] and persisted / POSTed to your server (if you've configured the HTTP Layer).
  ///
  ///
  /// ## Error Codes
  ///
  /// | Code  | Error                       |
  /// |-------|-----------------------------|
  /// | 0     | Location unknown            |
  /// | 1     | Location permission denied  |
  /// | 2     | Network error               |
  /// | 408   | Location timeout            |
  ///
  ///
  /// ## Example
  ///
  /// ```dart
  /// Location location = await BackgroundGeolocation.getCurrentPosition(
  ///   timeout: 30,          // 30 second timeout to fetch location
  ///   maximumAge: 5000,     // Accept the last-known-location if not older than 5000 ms.
  ///   desiredAccuracy: 10,  // Try to fetch a location with an accuracy of `10` meters.
  ///   samples: 3,           // How many location samples to attempt.
  ///   extras: {             // [Optional] Attach your own custom meta-data to this location.  This meta-data will be persisted to SQLite and POSTed to your server
  ///     "foo": "bar"
  ///   }
  /// });
  /// ```
  ///  **NOTE:** While [getCurrentPosition] will receive only **one** [Location], the plugin *does* request **multiple** location samples which will all be provided to the [onLocation] event-listener.  You can detect these samples via [Location.sample] `== true`.
  ///
  ///
  static Future<Location> getCurrentPosition(
      {int samples,
      int timeout,
      int maximumAge,
      bool persist,
      int desiredAccuracy,
      Map<String, dynamic> extras}) async {
    Map<String, dynamic> options = {};
    if (timeout != null) options['timeout'] = timeout;
    if (maximumAge != null) options['maximumAge'] = maximumAge;
    if (persist != null) options['persist'] = persist;
    if (desiredAccuracy != null) options['desiredAccuracy'] = desiredAccuracy;
    if (extras != null) options['extras'] = extras;

    Map data = await _methodChannel.invokeMethod('getCurrentPosition', options);

    return new Location(data);
  }

  /// Retrieve the current distance-travelled ("odometer").
  ///
  /// The plugin constantly tracks distance travelled, computing the distance between the current location and last and maintaining the sum.  To fetch the current **odometer** reading:
  ///
  /// ## Example
  ///
  /// ```dart
  /// double odometer = await BackgroundGeolocation.getOdometer();
  /// ```
  ///
  ///  **NOTE:** Also see [Config.desiredOdometerAccuracy] to set control the accuracy of locations being used in odometer calculations.
  ///
  ///  **WARNING:** Odometer calculations are dependant upon the accuracy of received locations.  If location accuracy is poor, this will necessarily introduce error into odometer calculations.
  ///
  static Future<double> get odometer async {
    return await _methodChannel.invokeMethod('getOdometer');
  }

  /// Initialize the `odometer` to *any* arbitrary value.
  ///
  ///  **NOTE:** `setOdometer` will internally perform a [getCurrentPosition] in order to record to exact location *where* odometer was set.
  ///
  /// ## Example
  ///
  /// ```dart
  /// BackgroundGeolocation.setOdometer(1234.56).then((Location location) {
  ///   // This is the location where odometer was set at.
  ///   print('[setOdometer] success: $location');
  /// });
  /// ```
  ///
  static Future<Location> setOdometer(double value) async {
    Map data = await _methodChannel.invokeMethod('setOdometer', value);
    return new Location(data);
  }

  /// Retrive a List of [Location] currently stored in the plugin's SQLite datbase.
  ///
  /// ## Example
  ///
  /// ```dart
  /// List locations = await BackgroundGeolocation.locations;
  /// ```
  ///
  static Future<List> get locations async {
    return await _methodChannel.invokeMethod('getLocations');
  }

  /// Retrive the count of all locations current stored in the plugin's SQLite datbase.
  ///
  /// ## Example
  ///
  /// ```dart
  /// int count = await BackgroundGeolocation.count;
  /// ```
  ///
  static Future<int> get count async {
    return await _methodChannel.invokeMethod('getCount');
  }

  /// Remove all records in plugin's SQLite database.
  ///
  /// ## Example
  ///
  /// ```dart
  /// bool success = BackgroundGeolocation.destroyLocations();
  /// ```
  ///
  static Future<bool> destroyLocations() async {
    return await _methodChannel.invokeMethod('destroyLocations');
  }

  /// TODO
  static Future<Location> insertLocation(Map<String, dynamic> params) async {
    return await _methodChannel.invokeMethod('insertLocation', params);
  }

  /// Manually execute upload configured [Config.url]
  ///
  /// If the plugin is configured for HTTP with an [Config.url] and [Config.autoSync] `false`, the [sync] method will initiate POSTing the locations currently stored in the native SQLite database to your configured [Config.url].
  /// When your HTTP server returns a response of `200 OK`, that record(s) in the database will be DELETED.
  ///
  /// If you configured [Config.batchSync] `true`, all the locations will be sent to your server in a single HTTP POST request, otherwise the plugin will execute an HTTP post for **each** [Location] in the database (REST-style).
  /// Your callback will be executed and provided with a `List` of all the locations from the SQLite database.  If you configured the plugin for HTTP (by configuring a [Config.url], your callback will be executed after all the HTTP request(s) have completed.
  /// If the plugin failed to sync to your server (possibly because of no network connection), the failure callback will be called with an error message.  If you are **not** using the HTTP features, [sync] will delete all records from its SQLite datbase.
  ///
  /// ## Example
  ///
  /// ```dart
  /// BackgroundGeolocation.sync((List records) {
  ///   print('[sync] success: $records');
  /// }).catchError((error) {
  ///   print('[sync] FAILURE: $error');
  /// });
  ///
  /// ```
  ///  __NOTE:__ For more information, see the __HTTP Guide__ at [HttpEvent].
  ///
  static Future<List> sync() async {
    return await _methodChannel.invokeMethod('sync');
  }

  ///
  /// Adds a [Geofence] to be monitored by the native Geofencing API.
  ///
  /// If a [Geofence] *already exists* with the configured [Geofence.identifier], the previous one will be **deleted** before the new one is inserted.
  ///
  /// See also [addGeofences] for adding multiple geofences.
  ///
  /// ## Example
  ///
  /// ```dart
  /// BackgroundGeolocation.addGeofence(Geofence(
  ///   identifier: "Home",
  ///   radius: 150,
  ///   latitude: 45.51921926,
  ///   longitude: -73.61678581,
  ///   notifyOnEntry: true,
  ///   notifyOnExit: false,
  ///   notifyOnDwell: true,
  ///   loiteringDelay: 30000,  // 30 seconds
  ///   extras: {               // Optional arbitrary meta-data
  ///     zone_id: 1234
  ///   }
  /// )).then((bool success) {
  ///   print('[addGeofence] success');
  /// }.catchError((error) {
  ///   print('[addGeofence] FAILURE: $error');
  //// });
  /// ```
  ///
  /// __Note:__
  /// - When adding a list-of-geofences, it's about **10 times faster** to use [addGeofences] instead.
  /// - See [GeofenceEvent] for more information.
  ///
  static Future<bool> addGeofence(Geofence geofence) async {
    return await _methodChannel.invokeMethod('addGeofence', geofence.toMap());
  }

  /// Adds a list of [Geofence] to be monitored by the native Geofencing API.
  ///
  /// If a geofence(s) *already* exists with the configured [Geofence.identifier], the previous one(s) will be **deleted** before the new one is inserted.
  ///
  /// ## Example
  ///
  /// ```dart
  /// List<Geofence> geofences = [
  ///   Geofence(
  ///     identifier: 'foo',
  ///     radius: 200,
  ///     latitude: 45.51921926,
  ///     longitude: -73.61678581,
  ///     notifyOnEntry: true,
  ///   ),
  ///   Geofence(
  ///     identifier: 'bar',
  ///     radius: 200,
  ///     latitude: 45.51921926,
  ///     longitude: -73.61678581,
  ///     notifyOnEntry: true,
  ///   )
  /// ];
  ///
  /// BackgroundGeolocation.addGeofences(geofences);
  /// ```
  ///
  static Future<bool> addGeofences(List<Geofence> geofences) async {
    List<Map<String, dynamic>> rs =
        geofences.map((Geofence geofence) => geofence.toMap());
    return await _methodChannel.invokeMethod('addGeofences', rs);
  }

  /// Removes a [Geofence] having the given [Geofence.identifier]`.
  ///
  /// ## Example
  ///
  /// ```dart
  /// BackgroundGeolocation.removeGeofence("Home").then((bool success) {
  ///   print('[removeGeofence] success');
  /// }).catchError((error) {
  ///   print('[removeGeofence] FAILURE: $error');
  /// });
  ///
  static Future<bool> removeGeofence(String identifier) async {
    return await _methodChannel.invokeMethod('removeGeofence', identifier);
  }

  /// Destroy all [Geofence].
  ///
  static Future<bool> removeGeofences() async {
    return await _methodChannel.invokeMethod('removeGeofences');
  }

  /// Retrieve all [Geofence].
  ///
  /// Fetch a list of all [Geofence].  If there are no geofences being monitored, you'll receive an empty `List`.
  ///
  /// ## Example
  ///
  /// ```dart
  /// List<Geofence> geofences = await BackgroundGeolocation.getGeofences();
  /// print('[getGeofences: $geofences');
  /// ```
  ///
  static Future<List<Geofence>> get geofences async {
    List<dynamic> geofences = await _methodChannel.invokeMethod('getGeofences');
    List<Geofence> rs = [];
    geofences.forEach((dynamic data) {
      dynamic loiteringDelay = data['loiteringDelay'];
      rs.add(new Geofence(
          identifier: data['identifier'],
          radius: data['radius'],
          latitude: data['latitude'],
          longitude: data['longitude'],
          notifyOnEntry: data['notifyOnEntry'],
          notifyOnExit: data['notifyOnExit'],
          notifyOnDwell: data['notifyOnDwell'],
          loiteringDelay: (loiteringDelay.runtimeType == double)
              ? loiteringDelay.round()
              : loiteringDelay,
          extras: data['extras'].cast<String, dynamic>()));
    });
    return rs;
  }

  /// Returns the entire contents of the log database.
  ///
  /// Depending on the configured [Config.logLevel], the plugin can store an *immense* amount of helpful logging information for debugging location-tracking problems.
  ///
  /// See also:
  /// - [Config.logMaxDays] (default `3` days)
  /// - [Config.logLevel]   (default [Config.LOG_LEVEL_OFF])
  /// - [emailLog]
  ///
  /// ## Example log data:
  ///
  ///```
  /// 09-19 11:12:18.716 ╔═════════════════════════════════════════════
  /// 09-19 11:12:18.716 ║ BackgroundGeolocation Service started
  /// 09-19 11:12:18.716 ╠═════════════════════════════════════════════
  /// 09-19 11:12:18.723 [c.t.l.BackgroundGeolocationService d]
  /// 09-19 11:12:18.723   ✅  Started in foreground
  /// 09-19 11:12:18.737 [c.t.l.ActivityRecognitionService a]
  /// 09-19 11:12:18.737   🎾  Start activity updates: 10000
  /// 09-19 11:12:18.761 [c.t.l.BackgroundGeolocationService k]
  /// 09-19 11:12:18.761   🔴  Stop heartbeat
  /// 09-19 11:12:18.768 [c.t.l.BackgroundGeolocationService a]
  /// 09-19 11:12:18.768   🎾  Start heartbeat (60)
  /// 09-19 11:12:18.778 [c.t.l.BackgroundGeolocationService a]
  /// 09-19 11:12:18.778   🔵  setPace: null → false
  /// 09-19 11:12:18.781 [c.t.l.adapter.TSConfig c] ℹ️   Persist config
  /// 09-19 11:12:18.794 [c.t.locationmanager.util.b a]
  /// 09-19 11:12:18.794   ℹ️  LocationAuthorization: Permission granted
  /// 09-19 11:12:18.842 [c.t.l.http.HttpService flush]
  /// 09-19 11:12:18.842 ╔═════════════════════════════════════════════
  /// 09-19 11:12:18.842 ║ HTTP Service
  /// 09-19 11:12:18.842 ╠═════════════════════════════════════════════
  /// 09-19 11:12:19.000 [c.t.l.BackgroundGeolocationService onActivityRecognitionResult] still (100%)
  /// 09-19 11:12:21.314 [c.t.l.l.SingleLocationRequest$2 onLocationResult]
  /// 09-19 11:12:21.314 ╔═════════════════════════════════════════════
  /// 09-19 11:12:21.314 ║ SingleLocationRequest: 1
  /// 09-19 11:12:21.314 ╠═════════════════════════════════════════════
  /// 09-19 11:12:21.314 ╟─ 📍  Location[fused 45.519239,-73.617058 hAcc=15]999923706055 vAcc=2 sAcc=??? bAcc=???
  /// 09-19 11:12:21.327 [c.t.l.l.TSLocationManager onSingleLocationResult]
  /// 09-19 11:12:21.327   🔵  Acquired motionchange position, isMoving: false
  /// 09-19 11:12:21.342 [c.t.l.l.TSLocationManager a] 15.243
  /// 09-19 11:12:21.405 [c.t.locationmanager.data.a.c persist]
  /// 09-19 11:12:21.405   ✅  INSERT: bca5acc8-e358-4d8f-827f-b8c0d556b7bb
  /// 09-19 11:12:21.423 [c.t.l.http.HttpService flush]
  /// 09-19 11:12:21.423 ╔═════════════════════════════════════════════
  /// 09-19 11:12:21.423 ║ HTTP Service
  /// 09-19 11:12:21.423 ╠═════════════════════════════════════════════
  /// 09-19 11:12:21.446 [c.t.locationmanager.data.a.c first]
  /// 09-19 11:12:21.446   ✅  Locked 1 records
  /// 09-19 11:12:21.454 [c.t.l.http.HttpService a]
  /// 09-19 11:12:21.454   🔵  HTTP POST: bca5acc8-e358-4d8f-827f-b8c0d556b7bb
  /// 09-19 11:12:22.083 [c.t.l.http.HttpService$a onResponse]
  /// 09-19 11:12:22.083   🔵  Response: 200
  /// 09-19 11:12:22.100 [c.t.locationmanager.data.a.c destroy]
  /// 09-19 11:12:22.100   ✅  DESTROY: bca5acc8-e358-4d8f-827f-b8c0d556b7bb
  /// 09-19 11:12:55.226 [c.t.l.BackgroundGeolocationService onActivityRecognitionResult] still (100%)
  ///```
  ///
  /// ## Example
  ///
  /// ```dart
  /// BackgroundGeolocation.log.then((String log) {
  ///   // Warning:  this string could be several megabytes.
  ///   print('[log] success: $log');
  /// });
  /// ```
  ///
  static Future<String> get log async {
    return await _methodChannel.invokeMethod('getLog');
  }

  /// Email the result of [log] using device's mail client.
  ///
  /// ## Example
  ///
  /// ```dart
  /// BackgroundGeolocation.emailLog('foo@bar.com').then((bool success) {
  ///   print('[emailLog] success');
  /// }).catchError((error) {
  ///   print('[emailLog] FAILURE: $error');
  /// });
  /// ```
  ///
  static Future<bool> emailLog(String email) async {
    return await _methodChannel.invokeMethod('emailLog', email);
  }

  /// Destory the entire contents of plugin's log database.
  ///
  /// ## Example
  ///
  /// ```dart
  /// BackgroundGeolocation.destroyLog();
  /// ```
  ///
  static Future<bool> destroyLog() async {
    return await _methodChannel.invokeMethod('destroyLog');
  }

  /// Fetches the state of the operating-system's "Power Saving" mode.
  ///
  /// Power Saving mode can throttle certain services in the background, such as HTTP requests or GPS.
  ///
  ///  **NOTE:** You can listen to changes in the state of "Power Saving" mode from the event [onPowerSaveChange].
  ///
  /// ## iOS
  ///
  /// iOS Power Saving mode can be engaged manually by the user in **Settings -> Battery** or from an automatic OS dialog.
  ///
  /// ![](https://dl.dropboxusercontent.com/s/lz3zl2jg4nzstg3/Screenshot%202017-09-19%2010.34.21.png?dl=1)
  ///
  /// ## Android
  ///
  /// Android Power Saving mode can be engaged manually by the user in **Settings -> Battery -> Battery Saver** or automatically with a user-specified "threshold" (eg: 15%).
  ///
  /// ![](https://dl.dropboxusercontent.com/s/raz8lagrqayowia/Screenshot%202017-09-19%2010.33.49.png?dl=1)
  ///
  /// ## Example
  ///
  /// ```dart
  /// bool isPowerSaveMode = await BackgroundGeolocation.isPowerSaveMode;
  /// ```
  ///
  static Future<bool> get isPowerSaveMode async {
    return await _methodChannel.invokeMethod('isPowerSaveMode');
  }

  /// Returns the presense of device sensors *accelerometer*, *gyroscope*, *magnetometer*
  ///
  /// These core [Sensors] are used by the motion activity-recognition system -- when any of these sensors are missing from a device (particularly on cheap Android devices),
  /// the performance of the motion activity-recognition system will be **severely** degraded and highly inaccurate.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Sensors sensors = await BackgroundGeolocation.sensors;
  /// print(sensors);
  ///
  static Future<Sensors> get sensors async {
    Completer completer = new Completer();

    _methodChannel.invokeMethod('getSensors').then((dynamic data) {
      completer.complete(new Sensors(data['platform'], data['accelerometer'],
          data['gyroscope'], data['magnetometer'], data['motion_hardware'], data['significant_motion']));
    }).catchError((e) {
      completer.completeError(e);
    });
    return completer.future;
  }

  static Future<bool> playSound(int soundId) async {
    return await _methodChannel.invokeMethod('playSound', soundId);
  }

  /// Remove all event-listeners registered with the plugin:
  ///
  /// - [onLocation]
  /// - [onMotionChange]
  /// - [onActivityChange]
  /// - [onProviderChange]
  /// - [onGeofencesChange]
  /// - [onGeofence]
  /// - [onHeartbeat]
  /// - [onHttp]
  /// - [onEnabledChange]
  /// - [onConnectivityChange]
  /// - [onPowerSaveChange]
  ///
  /// ## Example
  ///
  /// ```dart
  /// BackgroundGeolocation.removeListeners();
  /// ```
  ///
  static void removeListeners() {
    _subscriptions.forEach((_Subscription sub) => sub.subscription.cancel());
    _subscriptions.clear();
  }

  /// Removes a single event-listener.
  ///
  /// ## Example
  ///
  /// ```dart
  ///
  /// // Create a Location callback:
  /// Function(Location) callback = (Location location) {
  ///   print('[My location callback] $location');
  /// };
  /// // Listen to the event:
  /// BackgroundGeolocation.onLocation(callback);
  /// .
  /// .
  /// .
  /// // Later, use the original Function reference to remove the listener:
  /// BackgroundGeolocation.removeListener(callback);
  /// ```
  ///
  static bool removeListener(Function callback) {
    _Subscription found = _subscriptions.firstWhere(
        (_Subscription item) => item.callback == callback,
        orElse: () => null);
    if (found != null) {
      found.subscription.cancel();
      _subscriptions.remove(found);
      return true;
    } else {
      return false;
    }
  }

  /// Subscribe to motionchange events
  ///
  /// Your `callback` will be executed each time the device has changed-state between **MOVING** or **STATIONARY**.
  ///
  /// ## Example
  ///
  /// ```dart
  /// BackgroundGeolocation.onMotioncChange((Location location) {
  ///   if (location.isMoving) {
  ///      print('[onMotionChange] Device has just started MOVING $location');
  ///   } else {
  ///      print('[onMotionChange] Device has just STOPPED:  $location);
  ///   }
  /// });
  /// ```
  ///
  static void onMotionChange(Function(Location) callback) {
    if (_eventsMotionChange == null) {
      _eventsMotionChange = _eventChannelMotionChange
          .receiveBroadcastStream()
          .map((dynamic event) => new Location(event));
    }
    _registerSubscription(_eventsMotionChange.listen(callback), callback);
  }

  /// Subscribe to location events
  ///
  ///
  ///  **NOTE:** When performing a [onMotionChange] or [getCurrentPosition], the plugin requests **multiple** location *samples* in order to record the most accurate location possible.  These *samples* are **not** persisted to the database but they will be provided to your `callback`, for your convenience, since it can take some seconds for the best possible location to arrive.
  ///
  /// For example, you might use these samples to progressively update the user's position on a map.  You can detect these *samples* in your `callback` via `location.sample == true`.  If you're manually `POST`ing location to your server, you should ignore these locations.
  ///
  /// ## Example
  ///
  /// ```dart
  /// BackgroundGeolocation.onLocation', ((Location location) {
  ///   print('[onLocation] success: $location');
  /// }).catchError((error) {
  ///   print('[onLocation] ERROR: $error');
  /// });
  /// ```
  ///
  /// ## Error Codes
  ///
  /// | Code  | Error                       |
  /// |-------|-----------------------------|
  /// | 0     | Location unknown            |
  /// | 1     | Location permission denied  |
  /// | 2     | Network error               |
  /// | 408   | Location timeout            |
  ///
  static void onLocation(Function(Location) callback) {
    if (_eventsLocation == null) {
      _eventsLocation = _eventChannelLocation
          .receiveBroadcastStream()
          .map((dynamic event) => new Location(event));
    }
    _registerSubscription(_eventsLocation.listen(callback), callback);
  }

  /// Subscribe to changes in motion activity.
  ///
  /// Your `callback` will be executed each time the activity-recognition system receives an event (`still, on_foot, in_vehicle, on_bicycle, running`).
  ///
  /// ## Example
  ///
  /// ```dart
  /// BackgroundGeolocation.onActivityChange((ActivityChangeEvent event) {
  ///   print('[onActivityChange] $event');
  /// });
  /// ```
  ///
  static void onActivityChange(Function(ActivityChangeEvent) callback) {
    if (_eventsActivityChange == null) {
      _eventsActivityChange = _eventChannelActivityChange
          .receiveBroadcastStream()
          .map((dynamic event) {
        return new ActivityChangeEvent(event['activity'], event['confidence']);
      });
    }
    _registerSubscription(_eventsActivityChange.listen(callback), callback);
  }

  /// Subscribe to Geofence transition events.
  ///
  /// Your supplied `callback` will be called when any monitored geofence crossing occurs.
  ///
  /// ## Example
  ///
  /// BackgroundGeolocation.onGeofence((GeofenceEvent event) {
  ///   print('[onGeofence] $event');
  /// });
  /// ```
  static void onGeofence(Function(GeofenceEvent) callback) {
    if (_eventsGeofence == null) {
      _eventsGeofence = _eventChannelGeofence
          .receiveBroadcastStream()
          .map((dynamic event) => new GeofenceEvent(event));
    }
    _registerSubscription(_eventsGeofence.listen(callback), callback);
  }

  /// Subscribe to changes in actively monitored geofences.
  ///
  /// Fired when the list of monitored-geofences changed.  The BackgroundGeolocation SDK contains powerful geofencing features that allow you to monitor any number of circular geofences you wish (thousands even), in spite of limits imposed by the native platform APIs (**20 for iOS; 100 for Android**).
  ///
  /// The plugin achieves this by storing your geofences in its database, using a [geospatial query](https://en.wikipedia.org/wiki/Spatial_query) to determine those geofences in proximity (@see [Config.geofenceProximityRadius]), activating only those geofences closest to the device's current location (according to limit imposed by the corresponding platform).
  ///
  /// When the device is determined to be moving, the plugin periodically queries for geofences in proximity (eg. every minute) using the latest recorded location.  This geospatial query is **very fast**, even with tens-of-thousands geofences in the database.
  ///
  /// It's when this list of monitored geofences *changes*, that the plugin will fire the `onGeofencesChange` event.
  ///
  /// **Note:** For more information, see __Geofencing Guide__ at [GeofenceEvent].
  ///
  /// ## Example
  ///
  /// ```dart
  /// BackgroundGeolocation.onGeofencesChange((GeofencesChangeEvent event) {
  ///   List<String> on = event.on;     //<-- new geofences activiated.
  ///   List<Geofence> off = event.off; //<-- geofences that were just de-activated.
  ///
  ///   // Create map circles
  ///   on.forEach((Geofence geofence) {
  ///     createGeofenceMarker(geofence)
  ///   });
  ///
  ///   // Remove map circles
  ///   off.forEach((String identifier) {
  ///     removeGeofenceMarker(identifier);
  ///   }
  /// });
  /// ```
  ///
  /// The [GeofencesChangeEvent] provides only the *changed* geofences, those which just activated or de-activated.
  ///
  /// When **all** geofences have been removed, the [GeofencesChangeEvent] will provide empty lists for both [GeofencesChangeEvent.on] & [GeofencesChangeEvent.off].
  ///
  static void onGeofencesChange(Function(GeofencesChangeEvent) callback) {
    if (_eventsGeofencesChange == null) {
      _eventsGeofencesChange = _eventChannelGeofencesChange
          .receiveBroadcastStream()
          .map((dynamic event) =>
              new GeofencesChangeEvent(event['on'], event['off']));
    }
    _registerSubscription(_eventsGeofencesChange.listen(callback), callback);
  }

  /// Subscribe to periodic heartbeat events.
  ///
  /// Your `callback` will be executed for each [Config.heartbeatInterval] while the device is in **stationary** state (**iOS** requires [Config.preventSuspend]: true as well).
  ///
  ///  **NOTE:** The [Location] provided to the [HeartbeatEvent] is only the last-known location.  The *heartbeat* event does not actively engage location-services.  If you wish to get the current location in your `callback`, use [getCurrentPosition].
  ///
  /// ## Example:
  ///
  /// ```dart
  ///
  /// BackgroundGeolocation.ready(Config(
  ///   heartbeatInterval: 60
  /// ));
  ///
  /// BackgroundGeolocation.onHeartbeat((HeartbeatEvent event) {
  ///   print('[onHeartbeat] $event');
  ///
  ///   // You could request a new location if you wish.
  ///   BackgroundGeolocation.getCurrentPosition(
  ///     samples: 1,
  ///     persist: true
  ///   ).then((Location location) {
  ///     print('[getCurrentPosition] $location');
  ///   });
  /// })
  /// ```
  ///
  static void onHeartbeat(Function(HeartbeatEvent) callback) {
    if (_eventsHeartbeat == null) {
      _eventsHeartbeat = _eventChannelHeartbeat
          .receiveBroadcastStream()
          .map((dynamic event) => new HeartbeatEvent(event));
    }
    _registerSubscription(_eventsHeartbeat.listen(callback), callback);
  }

  /// Subscribe to HTTP events.
  ///
  ///
  /// ## Example:
  /// ```dart
  /// BackgroundGeolocation.onHttp((HttpEvent event) {
  ///   int status = response.status;
  ///   bool success = response.success;
  ///   String responseText = response.responseText;
  ///   print('[onHttp] status: $status, success? $success, responseText: $responseText');
  /// });
  /// ```
  ///
  static void onHttp(Function(HttpEvent) callback) {
    if (_eventsHttp == null) {
      _eventsHttp = _eventChannelHttp
          .receiveBroadcastStream()
          .map((dynamic event) => new HttpEvent(event));
    }
    _registerSubscription(_eventsHttp.listen(callback), callback);
  }

  /// Subscribe to [Config.schedule] events.
  ///
  /// Your `callback` will be executed each time a [Config.schedule] event fires.  Your `callback` will be provided with the current [State]:  **`state.enabled`** will reflect the state according to your [Config.schedule].
  ///
  /// ## Example
  ///
  /// ```dart
  /// BackgroundGeolocation.onSchedule((State state) {
  ///   if (state.enabled) {
  ///     print('[onSchedule] scheduled start tracking');
  ///   } else {
  ///     print('[onSchedule] scheduled stop tracking');
  ///   }
  /// });
  /// ```
  ///
  static void onSchedule(Function(dynamic) callback) {
    if (_eventsSchedule == null) {
      _eventsSchedule =
          _eventChannelSchedule.receiveBroadcastStream().map((dynamic event) {
        // TODO cast to BGState
        return event;
      });
    }
    _registerSubscription(_eventsSchedule.listen(callback), callback);
  }

  /// Subscribe to changes in device's location-services configuration / authorization.
  ///
  /// Your `callback` fill be executed whenever a change in the state of the device's **Location Services** has been detected.  eg: "GPS ON", "Wifi only".
  ///
  ///  **NOTE:** The plugin always force-fires an `onProviderChange` event whenever the app is launched (right after the [ready] method is executed), regardless of current state, so you can learn the the current state of location-services with each boot of your application.
  ///
  /// ## [ProviderChangeEvent.status]:
  /// | Name                                                      | Platform      |
  /// |-----------------------------------------------------------|---------------|
  /// | [ProviderChangeEvent.AUTHORIZATION_STATUS_NOT_DETERMINED] | iOS only      |
  /// | [ProviderChangeEvent.AUTHORIZATION_STATUS_RESTRICTED]     | iOS only      |
  /// | [ProviderChangeEvent.AUTHORIZATION_STATUS_DENIED]         | iOS & Android |
  /// | [ProviderChangeEvent.AUTHORIZATION_STATUS_ALWAYS]         | iOS & Android |
  /// | [ProviderChangeEvent.AUTHORIZATION_STATUS_WHEN_IN_USE]    | iOS only      |
  ///
  /// ---------------------------------------------------------------------------------
  ///
  ///  **NOTE:** When Android location permission is **granted**,
  ///
  /// [ProviderChangeEvent.status] == [ProviderChangeEvent.AUTHORIZATION_STATUS_ALWAYS],
  ///
  ///  otherwise, [ProviderChangeEvent.AUTHORIZATION_STATUS_DENIED].
  ///
  /// ## Example
  ///
  /// ```dart
  /// BackgroundGeolocation.onProviderChange((ProviderChangeEvent event) {
  ///   print('[onProviderChange: $event');
  ///
  ///   switch(provider.status) {
  ///     case ProviderChangeEvent.AUTHORIZATION_STATUS_DENIED:
  ///       // Android & iOS
  ///       print('- Location authorization denied');
  ///       break;
  ///     case ProviderChangeEvent.AUTHORIZATION_STATUS_ALWAYS:
  ///       // Android & iOS
  ///       console.log('- Location always granted');
  ///       break;
  ///     case ProviderChangeEvent.AUTHORIZATION_STATUS_WHEN_IN_USE:
  ///       // iOS only
  ///       console.log('- Location WhenInUse granted');
  ///       break;
  ///   }
  /// });
  /// ```
  ///
  static void onProviderChange(Function(ProviderChangeEvent) callback) {
    if (_eventsProviderChange == null) {
      _eventsProviderChange = _eventChannelProviderChange
          .receiveBroadcastStream()
          .map((dynamic event) {
        return new ProviderChangeEvent(
            event['enabled'], event['status'], event['network'], event['gps']);
      });
    }
    _registerSubscription(_eventsProviderChange.listen(callback), callback);
  }

  /// Subscribe to changes in network connectivity.
  ///
  /// Fired when the state of the device's network-connectivity changes (enabled -> disabled and vice-versa).  By default, the plugin will automatically fire a `connectivitychange` event with the current state network-connectivity whenever the [start] method is executed.
  ///
  /// ## Example
  /// ```dart
  /// BackgroundGeolocation.oConnectivityChange((ConnectivityChangeEvent event) {
  ///   print('[onConnectivityChange] $event');
  /// });
  /// ```
  ///
  static void onConnectivityChange(Function(ConnectivityChangeEvent) callback) {
    if (_eventsConnectivityChange == null) {
      _eventsConnectivityChange = _eventChannelConnectivityChange
          .receiveBroadcastStream()
          .map((dynamic event) {
        return new ConnectivityChangeEvent(event['connected']);
      });
    }
    _registerSubscription(_eventsConnectivityChange.listen(callback), callback);
  }

  /// Subscribe to changes in plugin [State.enabled].
  ///
  /// Fired when the plugin's [State.enabled] changes.  For example, executing [start] and [stop] will cause the `onEnabledChnage` event to fire.  This event is primarily desigend for use with the configuration option [Config.stopAfterElapsedMinutes], which automatically executes the plugin's [stop] method.
  ///
  /// ## Example
  ///
  /// ```dart
  /// BackgroundGeolocation.onEnabledChange'((bool isEnabled) {
  ///   print('[onEnabledChanged] isEnabled? $isEnabled');
  /// });
  /// ```
  ///
  static void onEnabledChange(Function(bool) callback) {
    if (_eventsEnabledChange == null) {
      _eventsEnabledChange = _eventChannelEnabledChange
          .receiveBroadcastStream()
          .map((dynamic enabled) => enabled as bool);
    }
    _registerSubscription(_eventsEnabledChange.listen(callback), callback);
  }

  /// Subsribe to state changes in OS power-saving system.
  ///
  /// Fired when the state of the operating-system's "Power Saving" mode changes.  Your `callback` will be provided with a `bool` showing whether "Power Saving" is **enabled** or **disabled**.  Power Saving mode can throttle certain services in the background, such as HTTP requests or GPS.
  ///
  ///  **NOTE:** You can manually request the current-state of "Power Saving" mode with the method [isPowerSaveMode].
  ///
  /// ## iOS
  ///
  /// iOS Power Saving mode can be engaged manually by the user in **Settings -> Battery** or from an automatic OS dialog.
  ///
  /// ![](https://dl.dropboxusercontent.com/s/lz3zl2jg4nzstg3/Screenshot%202017-09-19%2010.34.21.png?dl=1)
  ///
  /// ## Android
  ///
  /// Android Power Saving mode can be engaged manually by the user in **Settings -> Battery -> Battery Saver** or automatically with a user-specified "threshold" (eg: 15%).
  ///
  /// ![](https://dl.dropboxusercontent.com/s/raz8lagrqayowia/Screenshot%202017-09-19%2010.33.49.png?dl=1)
  ///
  /// ## Example
  ///
  /// ```dart
  /// BackgroundGeolocation.oPowerSaveChange((bool isPowerSaveMode) {
  ///   print('[onPowerSaveChange: $isPowerSaveMode');
  /// });
  /// ```
  ///
  static void onPowerSaveChange(Function(bool) callback) {
    if (_eventsPowerSaveChange == null) {
      _eventsPowerSaveChange = _eventChannelPowerSaveChange
          .receiveBroadcastStream()
          .map((dynamic isPowerSaveMode) => isPowerSaveMode as bool);
    }
    _registerSubscription(_eventsPowerSaveChange.listen(callback), callback);
  }

  /// Registers a function to receive events from __`BackgroundGeolocation`__ while in the *terminated* ("Headless") state.
  /// 
  /// __Note:__ Requires [Config.enableHeadless]:true.
  /// 
  /// In **`main.dart`**, create a global function beside `void main() {}` (**Must** be defined as a distinct function, not an anonymous callback).  This `function` will receive *all* events from `BackgroundGeolocation` in the headless state, and provided with a [HeadlessEvent] containing a [HeadlessEvent.name] and [HeadlessEvent.event].
  /// 
  /// After running your app with `runApp`, register your headless-task with [registerHeadlessTask].  Within your `callback`, you're free to interact with the complete `BackgroundGeolocation` API.
  /// 
  /// After completion of your headless-task, you must signal to the native-code with [HeadlessEvent.finish].  __WARNING__:  Failure to do so can cause the OS to punish your app for spending too much time in the background by throttling future events.
  /// 
  /// ## Example
  /// 
  /// __`main.dart`__
  /// ```dart
  /// 
  /// /// Receives all events from BackgroundGeolocation while app is terminated:
  /// void headlessTask(HeadlessEvent headlessEvent) async {
  ///   print('[HeadlessTask]: $headlessEvent');
  /// 
  ///   switch(headlessEvent.name) {
  ///     case Event.TERMINATE:
  ///       State state = headlessEvent.event;
  ///       break;
  ///     case Event.HEARTBEAT:
  ///       HeartbeatEvent event = headlessEvent.event;
  ///       Location location = await BackgroundGeolocation.getCurrentPosition(
  ///         samples:1
  ///       );
  ///       break;
  ///     case Event.LOCATION:
  ///       Location location = headlessEvent.event;
  ///       break;
  ///     case Event.MOTIONCHANGE:
  ///       Location location = headlessEvent.event;
  ///       break;
  ///     case Event.HEARTBEAT:
  ///       HttpEvent response = headlessEvent.event;
  ///       break;
  ///     case Event.SCHEDULE:
  ///       State state = headlessEvent.event;
  ///       break;
  ///     case Event.GEOFENCE:
  ///       GeofenceEvent event = headlessEvent.event;
  ///       break;
  ///     case Event.GEOFENCESCHANGE:
  ///       GeofencesChangeEvent event = headlessEvent.event;
  ///       break;
  ///     case Event.ACTIVITYCHANGE:
  ///       ActivityChangeEvent event = headlessEvent.event;
  ///       break;
  ///     case Event.CONNECTIVITYCHANGE:
  ///       ConnectivityChangeEvent event = headlessEvent.event;
  ///       break;
  ///     case Event.ENABLEDCHANGE:
  ///       bool enabled = headlessEvent.event;
  ///       break;
  ///     case Event.PROVIDERCHANGE:
  ///       ProviderChangeEvent event = headlessEvent.event;
  ///       break;
  ///   }
  ///   // IMPORTANT:  Signal completion of you HeadlessEvent:
  ///   headlessEvent.finish();  // <-- REQUIRED
  /// }
  /// 
  /// void main() {
  ///   runApp(HelloWorld());
  ///   
  ///   // Register your headlessTask:
  ///   BackgroundGeolocation.registerHeadlessTask(headlessTask);
  /// }
  /// ```
  /// 
  /// __Note__: The [HeadlessEvent.event] is of the same class as provided by `BackgroundGeolocation's` main event-listeners.  You can manually cast this instance as shown in the `switch` above.
  /// 
  /// - [onLocation]
  /// - [onMotionChange]
  /// - [onHttp]
  /// - [onActivityChange]
  /// - [onProviderChange]
  /// - [onHeartbeat]
  /// - [onGeofence]
  /// - [onGeofencesChange]
  /// - [onEnabledChange]
  /// - [onConnectivityChange]
  /// 
  /// __WARNING__:  
  /// 
  /// - Be sure to signal completion of your headless-task with [HeadlessEvent.finish].
  /// - You **cannot** register more than **one** headless-task.
  /// - You **cannot** reference your UI within your headless-task.  There is no UI.
  /// 
  /// - Do **not** register an inline `function` to [registerHeadlessTask] -- the Flutter framework will **fail** to address it:
  /// 
  /// ```dart
  /// // NO!  This will not work.
  /// BackgroundGeolocation.registerHeadlessTask((HeadlessEvent event) {
  ///   print('$event');
  /// });
  /// 
  /// // YES!
  /// void myHeadlessTask(HeadlessEvent headlessEvent) async {
  ///   print('$event');
  /// }
  /// 
  /// BackgroundGeolocation.registerHeadlessTask(myHeadlessTask);
  /// 
  /// ```
  /// 
  static Future<bool> registerHeadlessTask(void Function(HeadlessEvent) callback) async {
    Completer completer = new Completer<bool>();

    // Two callbacks:  the provided headless-task + _headlessRegistrationCallback
    List<int> args = [
      PluginUtilities.getCallbackHandle(_headlessCallbackDispatcher).toRawHandle(),
      PluginUtilities.getCallbackHandle(callback).toRawHandle()
    ];
    _methodChannel.invokeMethod('registerHeadlessTask', args).then((dynamic success) {
      completer.complete(true);
    }).catchError((error) {
      print('[BackgroundGeolocation registerHeadlessTask] ‼️ ${error.code}');
      completer.complete(false);
    });
    return completer.future;
  }

  static void _registerSubscription(
      StreamSubscription<dynamic> sub, Function callback) {
    _subscriptions.add(new _Subscription(sub, callback));
  }
}

/// Headless Callback Dispatcher
///
void _headlessCallbackDispatcher() {
  WidgetsFlutterBinding.ensureInitialized();
  const MethodChannel _headlessChannel = MethodChannel("$_PLUGIN_PATH/headless", JSONMethodCodec());

  _headlessChannel.setMethodCallHandler((MethodCall call) async {
    final args = call.arguments;

    // Run the headless-task.
    try {
      final Function callback = PluginUtilities.getCallbackFromHandle(CallbackHandle.fromRawHandle(args['callbackId']));
      if (callback == null) {
        print('[BackgroundGeolocation _headlessCallbackDispatcher] ERROR: Failed to get callback from handle: $args');
        return;
      }
      callback(new HeadlessEvent(args['event'], args['params'], args['taskId']));
    } catch (e, stacktrace) {
      print('[BackgroundGeolocation _headlessCallbackDispather] ‼️ Callback error: ' + e.toString());
      print(stacktrace);
    }
  });
  // Signal to native side that the client dispatcher is ready to receive events.
  _headlessChannel.invokeMethod('initialized');
}

