part of flt_background_geolocation;

const _EVENT_CHANNEL_LOCATION = "$_PLUGIN_PATH/events/" + Event.LOCATION;
const _EVENT_CHANNEL_MOTIONCHANGE =
    "$_PLUGIN_PATH/events/" + Event.MOTIONCHANGE;
const _EVENT_CHANNEL_ACTIVITYCHANGE =
    "$_PLUGIN_PATH/events/" + Event.ACTIVITYCHANGE;
const _EVENT_CHANNEL_PROVIDERCHANGE =
    "$_PLUGIN_PATH/events/" + Event.PROVIDERCHANGE;
const _EVENT_CHANNEL_GEOFENCESCHANGE =
    "$_PLUGIN_PATH/events/" + Event.GEOFENCESCHANGE;
const _EVENT_CHANNEL_GEOFENCE = "$_PLUGIN_PATH/events/" + Event.GEOFENCE;
const _EVENT_CHANNEL_HEARTBEAT = "$_PLUGIN_PATH/events/" + Event.HEARTBEAT;
const _EVENT_CHANNEL_HTTP = "$_PLUGIN_PATH/events/" + Event.HTTP;
const _EVENT_CHANNEL_SCHEDULE = "$_PLUGIN_PATH/events/" + Event.SCHEDULE;
const _EVENT_CHANNEL_POWERSAVECHANGE =
    "$_PLUGIN_PATH/events/" + Event.POWERSAVECHANGE;
const _EVENT_CHANNEL_CONNECTIVITYCHANGE =
    "$_PLUGIN_PATH/events/" + Event.CONNECTIVITYCHANGE;
const _EVENT_CHANNEL_ENABLEDCHANGE =
    "$_PLUGIN_PATH/events/" + Event.ENABLEDCHANGE;
const _EVENT_CHANNEL_NOTIFICATIONACTION =
    "$_PLUGIN_PATH/events/" + Event.NOTIFICATIONACTION;
const _EVENT_CHANNEL_AUTHORIZATION =
    "$_PLUGIN_PATH/events/" + Event.AUTHORIZATION;

class _Subscription {
  final StreamSubscription<dynamic> subscription;
  final Function callback;

  _Subscription(this.subscription, this.callback);
}

/// Primary plugin API.
///
/// ## Events
///
/// [BackgroundGeolocation] is event-based and highly configurable through the [Config] API.
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
/// | [onPowerSaveChange]    | Fired when state of operating-system's "power-saving" feature is enabled / disabled. |
/// | [onEnabledChange]      | Fired when the plugin is enabled / disabled via its [start] / [stop] methods.        |
/// | [onNotificationAction] | __(Android only)__ Fired when a [Notification.actions] button is clicked upon a custom [Notification.layout] |
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
///       print('[location] - ${location}');
///     });
///
///     // Fired whenever the plugin changes motion-state (stationary->moving and vice-versa)
///     bg.BackgroundGeolocation.onMotionChange((bg.Location location) {
///       print('[motionchange] - ${location}');
///     });
///
///     // Fired whenever the state of location-services changes.  Always fired at boot
///     bg.BackgroundGeolocation.onProviderChange((bg.ProviderChangeEvent event) {
///       print('[providerchange] - ${event}');
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
///         logLevel: bg.Config.LOG_LEVEL_VERBOSE
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
  static const EventChannel _eventChannelNotificationAction =
      const EventChannel(_EVENT_CHANNEL_NOTIFICATIONACTION);
  static const EventChannel _eventChannelAuthorization =
      const EventChannel(_EVENT_CHANNEL_AUTHORIZATION);

  // Event Subscriptions
  static List<_Subscription> _subscriptions = [];

  // Stream Listeners
  static Stream<Location>? _eventsLocation;
  static Stream<Location>? _eventsMotionChange;
  static Stream<ActivityChangeEvent>? _eventsActivityChange;
  static Stream<ProviderChangeEvent>? _eventsProviderChange;
  static Stream<GeofencesChangeEvent>? _eventsGeofencesChange;
  static Stream<GeofenceEvent>? _eventsGeofence;
  static Stream<HeartbeatEvent>? _eventsHeartbeat;
  static Stream<HttpEvent>? _eventsHttp;
  static Stream<State>? _eventsSchedule;
  static Stream<bool>? _eventsPowerSaveChange;
  static Stream<ConnectivityChangeEvent>? _eventsConnectivityChange;
  static Stream<bool>? _eventsEnabledChange;
  static Stream<String>? _eventsNotificationAction;
  static Stream<AuthorizationEvent>? _eventsAuthorization;

  /// Return the current [State] of the plugin, including all [Config] parameters.
  ///
  /// ```dart
  /// State state = await BackgroundGeolocation.state();
  ///
  static Future<State> get state async {
    Map state = (await _methodChannel.invokeMapMethod('getState'))!;
    return State(state);
  }

  ///
  /// Signal to the plugin that your app is launched and ready, proving the default [Config].
  ///
  /// The supplied [Config] will be applied **only at first install** of your app — for every launch thereafter,
  /// the plugin will automatically load its last-known configuration from persistent storage.
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
  ///   print('[ready] success: ${state}');
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
  /// BackgroundGeolocation.reset(Config(
  ///   distanceFilter:  10
  /// ));
  /// ```
  ///
  /// ## [Config.reset]: true
  ///
  /// Optionally, you can set [Config.reset] to `true`  This is helpful during development.  This will essentially *force* the supplied [Config] to be applied with *each launch* of your application.
  ///
  /// ## Example
  ///
  /// ```dart
  /// BackgroundGeolocation.ready(Config(
  ///   distanceFilter: 50
  /// )).then((State state) {
  ///   print('[ready] - ${state}')
  /// });
  /// ```
  static Future<State> ready(Config config) async {
    Map state =
        (await _methodChannel.invokeMapMethod('ready', config.toMap()))!;
    return State(state);
  }

  ///
  /// Re-configure the plugin's [Config] parameters.
  ///
  /// The supplied [Config] will be appended to the current configuration and applied in real-time.
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
  ///   print('[setConfig] success: ${state}');
  /// })
  /// ```
  ///
  static Future<State> setConfig(Config config) async {
    Map state =
        (await _methodChannel.invokeMapMethod('setConfig', config.toMap()))!;
    return State(state);
  }

  /// Resets the plugin configuration to documented default-values.
  ///
  /// If an optional [Config] is provided, it will be applied *after* the configuration reset.
  ///
  static Future<State> reset([Config? config]) async {
    Map state = (await _methodChannel.invokeMapMethod(
        'reset', (config != null) ? config.toMap() : null))!;
    return State(state);
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
  /// BackgroundGeolocation.start().then((State state) {
  ///   print('[start] success - ${state}');
  /// });
  /// ```
  /// For more information, see [Philosophy of Operation](https://github.com/transistorsoft/flutter_background_geolocation/wiki/Philosophy-of-Operation)
  ///
  static Future<State> start() async {
    Map state = (await _methodChannel.invokeMapMethod('start'))!;
    return State(state);
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
    Map state = (await _methodChannel.invokeMapMethod('stop'))!;
    return State(state);
  }

  /// Initiate the configure [Config.schedule].
  ///
  /// If a [Config.schedule] was configured, this method will initiate that schedule.  The plugin will automatically be started or stopped according to the configured [Config.schedule].
  ///
  /// ## Example
  ///
  /// ```dart
  /// BackgroundGeolocation.startSchedule.then((State state) {
  ///   print('[startSchedule] success: ${state}');
  /// })
  /// ```
  ///
  static Future<State> startSchedule() async {
    Map state = (await _methodChannel.invokeMapMethod('startSchedule'))!;
    return State(state);
  }

  /// Halt scheduled tracking.
  ///
  /// ```dart
  /// BackgroundGeolocation.stopSchedule.then((State state) {
  ///   print('[stopSchedule] success: ${state}');
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
    Map state = (await _methodChannel.invokeMapMethod('stopSchedule'))!;
    return State(state);
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
  ///   print('[onGeofence] - ${event}')
  /// });
  ///
  /// BackgroundGeolocation.ready(Config(
  ///   url: 'http://my.server.com',
  ///   autoSync: true
  /// )).then((State state) {
  ///   BackgroundGeolocation.startGeofences();
  /// });
  /// ```
  ///
  static Future<State> startGeofences() async {
    Map state = (await _methodChannel.invokeMapMethod('startGeofences'))!;
    return State(state);
  }

  /// Sends a signal to OS that you wish to perform a long-running task.
  ///
  /// The OS will keep your running in the background and not suspend it until you signal completion with the [stopBackgroundTask] method.  Your callback will be provided with a single parameter `taskId`
  /// which you will send to the [stopBackgroundTask] method.
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
  /// ### iOS
  /// The iOS implementation uses [beginBackgroundTaskWithExpirationHandler](https://developer.apple.com/documentation/uikit/uiapplication/1623031-beginbackgroundtaskwithexpiratio)
  ///
  /// ⚠️ iOS provides **exactly** 180s of background-running time.  If your long-running task exceeds this time, the plugin has a fail-safe which will
  /// automatically [[stopBackgroundTask]] your **`taskId`** to prevent the OS from force-killing your application.
  ///
  /// Logging of iOS background tasks looks like this:
  /// ```
  /// ✅-[BackgroundTaskManager createBackgroundTask] 1
  /// .
  /// .
  /// .
  ///
  /// ✅-[BackgroundTaskManager stopBackgroundTask:]_block_invoke 1 OF (
  ///     1
  /// )
  /// ```
  /// ### Android
  ///
  /// The Android implementation launches a [`WorkManager`](https://developer.android.com/topic/libraries/architecture/workmanager) task.
  ///
  /// ⚠️ The Android plugin imposes a limit of **3 minutes** for your background-task before it automatically `FORCE KILL`s it.
  ///
  ///
  /// Logging for Android background-tasks looks like this (when you see an hourglass ⏳ icon, a foreground-service is active)
  /// ```
  ///  I TSLocationManager: [c.t.l.u.BackgroundTaskManager onStartJob] ⏳ startBackgroundTask: 6
  ///  .
  ///  .
  ///  .
  ///  I TSLocationManager: [c.t.l.u.BackgroundTaskManager$Task stop] ⏳ stopBackgroundTask: 6
  /// ```
  ///
  static Future<int> startBackgroundTask() async {
    return (await _methodChannel.invokeMethod<int>('startBackgroundTask'))
        as FutureOr<int>;
  }

  /// Signal completion of [startBackgroundTask]
  ///
  /// Sends a signal to the native OS that your long-running task, addressed by `taskId` provided by [startBackgroundTask] is complete and the OS may proceed to suspend your application if applicable.
  ///
  static Future<int> stopBackgroundTask(int taskId) async {
    return (await _methodChannel.invokeMethod<int>('finish', taskId))
        as FutureOr<int>;
  }

  /// __@deprecated__.  Renamed to [stopBackgroundTask]
  ///
  @Deprecated('Use `BackgroundGeolocation.stopBackgroundTask` instead')
  static Future<int> finish(int taskId) async {
    return stopBackgroundTask(taskId);
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
    try {
      return (await _methodChannel.invokeMethod<bool>('changePace', isMoving))
          as FutureOr<bool>;
    } on PlatformException catch (e) {
      throw Error(e);
    }
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
      {int? samples,
      int? timeout,
      int? maximumAge,
      bool? persist,
      int? desiredAccuracy,
      Map<String, dynamic>? extras}) async {
    Map<String, dynamic> options = {};
    if (samples != null) options['samples'] = samples;
    if (timeout != null) options['timeout'] = timeout;
    if (maximumAge != null) options['maximumAge'] = maximumAge;
    if (persist != null) options['persist'] = persist;
    if (desiredAccuracy != null) options['desiredAccuracy'] = desiredAccuracy;
    if (extras != null) options['extras'] = extras;

    Completer completer = Completer<Location>();

    _methodChannel
        .invokeMapMethod('getCurrentPosition', options)
        .then((Map? data) {
      completer.complete(Location(data!));
    }).catchError((error) {
      completer.completeError(LocationError(error));
    });
    return completer.future as FutureOr<Location>;
  }

  /// Retrieve the current distance-traveled ("odometer").
  ///
  /// The plugin constantly tracks distance traveled, computing the distance between the current location and last and maintaining the sum.  To fetch the current **odometer** reading:
  ///
  /// ## Example
  ///
  /// ```dart
  /// double odometer = await BackgroundGeolocation.getOdometer();
  /// ```
  ///
  ///  **NOTE:** Also see [Config.desiredOdometerAccuracy] to set control the accuracy of locations being used in odometer calculations.
  ///
  ///  **WARNING:** Odometer calculations are dependent upon the accuracy of received locations.  If location accuracy is poor, this will necessarily introduce error into odometer calculations.
  ///
  static Future<double> get odometer async {
    return (await _methodChannel.invokeMethod<double>('getOdometer'))
        as FutureOr<double>;
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
  ///   print('[setOdometer] success: ${location}');
  /// });
  /// ```
  ///
  static Future<Location> setOdometer(double value) async {
    Map data = (await _methodChannel.invokeMapMethod('setOdometer', value))!;
    return Location(data);
  }

  /// Retrive a List of [Location] currently stored in the plugin's SQLite database.
  ///
  /// ## Example
  ///
  /// ```dart
  /// List locations = await BackgroundGeolocation.locations;
  /// ```
  ///
  static Future<List> get locations async {
    return (await _methodChannel.invokeListMethod('getLocations'))!;
  }

  /// Retrive the count of all locations current stored in the plugin's SQLite database.
  ///
  /// ## Example
  ///
  /// ```dart
  /// int count = await BackgroundGeolocation.count;
  /// ```
  ///
  static Future<int> get count async {
    return (await _methodChannel.invokeMethod<int>('getCount'))
        as FutureOr<int>;
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
    return (await _methodChannel.invokeMethod<bool>('destroyLocations'))
        as FutureOr<bool>;
  }

  /// Destory a single location by [Location.uuid].
  ///
  /// ## Example
  /// ```dart
  /// try {
  ///   await BackgroundGeolocation.destroyLocation(location.uuid);
  /// } catch(error) {
  ///   print("[destroyLocation] failed: $error");
  /// }
  /// ```
  static Future<bool> destroyLocation(String uuid) async {
    return (await _methodChannel.invokeMethod<bool>('destroyLocation', uuid))
        as FutureOr<bool>;
  }

  /// TODO
  static Future<String> insertLocation(Map<dynamic, dynamic> params) async {
    return (await _methodChannel.invokeMethod<String>('insertLocation', params))
        as FutureOr<String>;
  }

  /// Manually execute upload configured [Config.url]
  ///
  /// If the plugin is configured for HTTP with an [Config.url] and [Config.autoSync] `false`, the [sync] method will initiate POSTing the locations currently stored in the native SQLite database to your configured [Config.url].
  /// When your HTTP server returns a response of `200 OK`, that record(s) in the database will be DELETED.
  ///
  /// If you configured [Config.batchSync] `true`, all the locations will be sent to your server in a single HTTP POST request, otherwise the plugin will execute an HTTP post for **each** [Location] in the database (REST-style).
  /// Your callback will be executed and provided with a `List` of all the locations from the SQLite database.  If you configured the plugin for HTTP (by configuring a [Config.url], your callback will be executed after all the HTTP request(s) have completed.
  /// If the plugin failed to sync to your server (possibly because of no network connection), the failure callback will be called with an error message.  If you are **not** using the HTTP features, [sync] will delete all records from its SQLite database.
  ///
  /// ## Example
  ///
  /// ```dart
  /// BackgroundGeolocation.sync((List records) {
  ///   print('[sync] success: ${records}');
  /// }).catchError((error) {
  ///   print('[sync] FAILURE: ${error}');
  /// });
  ///
  /// ```
  ///  __NOTE:__ For more information, see the __HTTP Guide__ at [HttpEvent].
  ///
  static Future<List> sync() async {
    return (await _methodChannel.invokeListMethod('sync')) as FutureOr<List>;
  }

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
  ///   print('[addGeofence] FAILURE: ${error}');
  /// });
  /// ```
  ///
  /// __Note:__
  /// - When adding a list-of-geofences, it's about **10 times faster** to use [addGeofences] instead.
  /// - See [GeofenceEvent] for more information.
  ///
  static Future<bool> addGeofence(Geofence geofence) async {
    return (await _methodChannel.invokeMethod<bool>(
        'addGeofence', geofence.toMap())) as FutureOr<bool>;
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
        geofences.map((Geofence geofence) => geofence.toMap()).toList();
    return (await _methodChannel.invokeMethod<bool>('addGeofences', rs))
        as FutureOr<bool>;
  }

  /// Returns `true` if the SDK already contains the [Geofence] in its database.
  ///
  /// ## Example
  /// ```dart
  /// BackgroundGeolocation.geofenceExists('HOME').then((bool exists) {
  ///   if (!exists) {
  ///     BackgroundGeolocation.addGeofence(Geofence(
  ///       identifier: 'HOME',
  ///       latitude: location.latitude,
  ///       longitude location.longitude,
  ///       radius: 200.0,
  ///       notifyOnEntry: true
  ///     ));
  ///   }
  /// });
  ///
  static Future<bool> geofenceExists(String identifier) async {
    return (await _methodChannel.invokeMethod<bool>(
        'geofenceExists', identifier)) as FutureOr<bool>;
  }

  /// Removes a [Geofence] having the given [Geofence.identifier]`.
  ///
  /// ## Example
  ///
  /// ```dart
  /// BackgroundGeolocation.removeGeofence("Home").then((bool success) {
  ///   print('[removeGeofence] success');
  /// }).catchError((error) {
  ///   print('[removeGeofence] FAILURE: ${error}');
  /// });
  ///
  static Future<bool> removeGeofence(String identifier) async {
    return (await _methodChannel.invokeMethod<bool>(
        'removeGeofence', identifier)) as FutureOr<bool>;
  }

  /// Destroy all [Geofence].
  ///
  static Future<bool> removeGeofences() async {
    return (await _methodChannel.invokeMethod<bool>('removeGeofences'))
        as FutureOr<bool>;
  }

  /// Retrieve all [Geofence].
  ///
  /// Fetch a list of all [Geofence].  If there are no geofences being monitored, you'll receive an empty `List`.
  ///
  /// ## Example
  ///
  /// ```dart
  /// List<Geofence> geofences = await BackgroundGeolocation.geofences;
  /// print('[getGeofences: ${geofences}');
  /// ```
  ///
  static Future<List<Geofence>> get geofences async {
    List<dynamic> geofences =
        (await _methodChannel.invokeListMethod('getGeofences')) ?? [];
    List<Geofence> rs = [];
    geofences.forEach((dynamic data) {
      dynamic loiteringDelay = data['loiteringDelay'];
      List<List<double>> vertices = [];
      if (data['vertices'] != null) {
        List<Object?> tmp = data['vertices'];
        tmp.forEach((vertex) {
          List<double> v = List.from(vertex as List);
          vertices.add(v);
        });
      }

      rs.add(Geofence(
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
          vertices: vertices,
          extras: (data['extras'] != null)
              ? data['extras'].cast<String, dynamic>()
              : {}));
    });
    return rs;
  }

  /// Retrieve all a single [Geofence] by identifier.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Geofence geofence = await BackgroundGeolocation.getGeofence("HOME");
  /// print('[getGeofence HOME: ${geofence}');
  /// ```
  ///
  static Future<Geofence?> getGeofence(String identifier) async {
    try {
      Map data =
          (await _methodChannel.invokeMapMethod('getGeofence', identifier))!;
      dynamic loiteringDelay = data['loiteringDelay'];
      List<List<double>> vertices = [];
      if (data['vertices'] != null) {
        List<Object?> tmp = data['vertices'];
        tmp.forEach((vertex) {
          List<double> v = List.from(vertex as List);
          vertices.add(v);
        });
      }
      return Geofence(
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
          vertices: vertices,
          extras: (data['extras'] != null)
              ? data['extras'].cast<String, dynamic>()
              : {});
    } on PlatformException catch (e) {
      if (e.code == "404") {
        return null;
      } else {
        throw Error(e);
      }
    }
  }

  /// __@deprecated__ Use [Logger] instead.
  ///
  @Deprecated('Use `Logger.getLog` instead')
  static Future<String> get log async {
    print('[⚠️  deprecated] BackgroundGeolocation.log.  Use Logger.getLog');
    return Logger.getLog();
  }

  /// __@deprecated__ Use [Logger] instead.
  ///
  @Deprecated('Use `Logger.emailLog` instead')
  static Future<bool> emailLog(String email) async {
    print(
        '[⚠️  deprecated] BackgroundGeolocation.emailLog.  Use Logger.emailLog');
    return Logger.emailLog(email);
  }

  /// __@deprecated__ Use [Logger] instead.
  ///
  @Deprecated('Use `Logger.destroyLog` instead')
  static Future<bool> destroyLog() async {
    print(
        '[⚠️  deprecated] BackgroundGeolocation.destroyLog.  Use Logger.destroyLog');
    return Logger.destroyLog();
  }

  /// Returns the presence of device sensors *accelerometer*, *gyroscope*, *magnetometer*
  ///
  /// These core [Sensors] are used by the motion activity-recognition system -- when any of these sensors are missing from a device (particularly on cheap Android devices),
  /// the performance of the motion activity-recognition system will be **severely** degraded and highly inaccurate.
  ///
  /// ## Example
  ///
  /// ```dart
  /// Sensors sensors = await BackgroundGeolocation.sensors;
  /// print(sensors);
  /// ```
  ///
  static Future<Sensors> get sensors async {
    Map data = (await _methodChannel.invokeMapMethod('getSensors'))!;
    return Sensors(data);
  }

  /// Manually request location permission from the user with the configured [Config.locationAuthorizationRequest].
  ///
  /// The method will resolve successful if *either* __`WhenInUse`__ or __`Always`__ is authorized, regardless of [Config.locationAuthorizationRequest].  Otherwise an error will be returned (eg: user denies location permission).
  ///
  /// If the user has already provided authorization for location-services, the method will resolve successfully immediately.
  ///
  /// If iOS has *already* presented the location authorization dialog and the user has not currently authorized your desired [Config.locationAuthorizationRequest], the SDK will present an error dialog offering to direct the user to your app's Settings screen.
  /// - To disable this behaviour, see [Config.disableLocationAuthorizationAlert].
  /// - To customize the text on this dialog, see [Config.locationAuthorizationAlert].
  ///
  /// ### ⚠️ Note:
  /// - The SDK will **already request permission** from the user when you execute [start], [startGeofences], [getCurrentPosition], etc.  You **do not need to explicitly execute this method** with typical use-cases.
  ///
  /// ## Example
  /// ```dart
  /// initPlatformState async {
  ///   // Listen to onProviderChange to be notified when location authorization changes occur.
  ///   BackgroundGeolocation.onProviderChange((event) {
  ///     print("[providerchange] $event");
  ///   });
  ///
  ///   // First ready the plugin with your configuration.
  ///   let State = await BackgroundGeolocation.ready(Config(
  ///     locationAuthorizationRequest: 'Always'
  ///   ));
  ///
  ///   // Manually request permission with configured locationAuthorizationRequest.
  ///   try {
  ///     int status = await BackgroundGeolocation.requestPermission();
  ///     if (status == ProviderChangeEvent.AUTHORIZATION_STATUS_ALWAYS) {
  ///       print("[requestPermission] Authorized Always $status");
  ///     } else if (status == ProviderChangeEvent.AUTHORIZATION_STATUS_WHEN_IN_USE) {
  ///       print("[requestPermission] Authorized WhenInUse: $status");
  ///     }
  ///   } catch(error) {
  ///     print("[requestPermission] DENIED: $error");
  ///   }
  /// }
  /// ```
  ///
  /// ### ℹ️ See also:
  /// - [Config.locationAuthorizationRequest]
  /// - [Config.disableLocationAuthorizationAlert]
  /// - [Config.locationAuthorizationAlert]
  /// - [requestTemporaryFullAccuracy] (_iOS 14+_)
  /// - [Config.backgroundPermissionRationale] (_Android 11+_)
  ///
  static Future<int> requestPermission() async {
    // For future, we will accept an optional String of a specific permission to request (NOT YET IMPLEMENTED)
    // eg: "LOCATION_WHEN_IN_USE", "LOCATION_ALWAYS", "ACTIVITY_RECOGNITION"
    // @see BackgroundGeolocationModule:
    //    private void requestPermission(final String permission, final MethodChannel.Result result)
    const permission = null;
    return (await _methodChannel.invokeMethod<int>(
        'requestPermission', permission))!;
  }

  /// __`[iOS 14+]`__ iOS 14 has introduced a new __`[Precise: On]`__ switch on the location authorization dialog allowing users to disable high-accuracy location.
  ///
  /// The method [`requestTemporaryFullAccuracy` (Apple docs)](https://developer.apple.com/documentation/corelocation/cllocationmanager/3600217-requesttemporaryfullaccuracyauth?language=objc) will allow you to present a dialog to the user requesting temporary *full accuracy* for the lifetime of this application run (until terminate).
  ///
  /// ![](https://dl.dropbox.com/s/dj93xpg51vspqk0/ios-14-precise-on.png?dl=1)
  ///
  /// ## Configuration &mdash; `Info.plist`
  ///
  /// In order to use this method, you must configure your __`Info.plist`__ with the `Dictionary` key:
  /// __`Privacy - Location Temporary Usage Description Dictionary`__
  ///
  /// ![](https://dl.dropbox.com/s/52f5lnjc4d9g8w7/ios-14-Privacy-Location-Temporary-Usage-Description-Dictionary.png?dl=1)
  ///
  /// The keys of this `Dictionary` (eg: `Delivery`) are supplied as the first argument to the method.  The `value` will be printed on the dialog shown to the user, explaing the purpose of your request for full accuracy.
  ///
  /// If the dialog fails to be presented, an error will be thrown:
  /// - The Info.plist file doesn’t have an entry for the given purposeKey value.
  /// - The app is already authorized for full accuracy.
  /// - The app is in the background.
  ///
  /// ![](https://dl.dropbox.com/s/8cc0sniv3pvpetl/ios-14-requestTemporaryFullAccuracy.png?dl=1)
  ///
  /// ## Example
  ///
  /// ```dart
  /// BackgroundGeolocation.onProviderChange((ProviderChangeEvent event) {
  ///   if (event.accuracyAuthorization == ProviderChangeEvent.ACCURACY_AUTHORIZATION_REDUCED) {
  ///     // Supply "Purpose" key from Info.plist as 1st argument.
  ///     BackgroundGeolocation.requestTemporaryFullAccuracy("Delivery").then((int accuracyAuthorization) {
  ///       if (accuracyAuthorization == ProviderChangeEvent.ACCURACY_AUTHORIZATION_FULL) {
  ///         print("[requestTemporaryFullAccuracy] GRANTED:  $accuracyAuthorization");
  ///       } else {
  ///         print("[requestTemporaryFullAccuracy] DENIED:  $accuracyAuthorization");
  ///       }
  ///     }).catchError((error) {
  ///       print("[requestTemporaryFullAccuracy] FAILED TO SHOW DIALOG: $error");
  ///     });
  ///   }
  /// });
  /// ```
  ///
  /// __See also:__
  /// - [ProviderChangeEvent.accuracyAuthorization].
  /// - [What's new in iOS 14 `CoreLocation`](https://levelup.gitconnected.com/whats-new-with-corelocation-in-ios-14-bd28421c95c4)
  ///
  static Future<int> requestTemporaryFullAccuracy(String purpose) async {
    return (await _methodChannel.invokeMethod<int>(
        'requestTemporaryFullAccuracy', purpose))!;
  }

  /// Get current state of location-services, including authorization status.
  ///
  /// See [ProviderChangeEvent]
  ///
  static Future<ProviderChangeEvent> get providerState async {
    Completer completer = Completer<ProviderChangeEvent>();

    _methodChannel.invokeMapMethod('getProviderState').then((Map? data) {
      completer.complete(ProviderChangeEvent(data!));
    }).catchError((e) {
      completer.completeError(Error(e));
    });

    return completer.future as FutureOr<ProviderChangeEvent>;
  }

  /// Register with the Transistor Software demo server
  ///

  /// Do not use.
  static Future<bool> playSound(dynamic soundId) async {
    return (await _methodChannel.invokeMethod<bool>('playSound', soundId))
        as FutureOr<bool>;
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
  /// - [onNotificationAction]
  /// - [onAuthorization]
  ///
  /// ## Example
  ///
  /// ```dart
  /// BackgroundGeolocation.removeListeners();
  /// ```
  ///
  static Future<bool> removeListeners() async {
    await Future.wait(_subscriptions.map((sub) => sub.subscription.cancel()));
    _subscriptions.clear();
    return true;
  }

  /// Removes a single event-listener.
  ///
  /// ## Example
  ///
  /// ```dart
  ///
  /// // Create a Location callback:
  /// Function(Location) callback = (Location location) {
  ///   print('[My location callback] ${location}');
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
    _Subscription? found = _subscriptions
        .firstWhereOrNull((_Subscription item) => item.callback == callback);
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
  /// BackgroundGeolocation.onMotionChange((Location location) {
  ///   if (location.isMoving) {
  ///      print('[onMotionChange] Device has just started MOVING ${location}');
  ///   } else {
  ///      print('[onMotionChange] Device has just STOPPED:  ${location});
  ///   }
  /// });
  /// ```
  ///
  static void onMotionChange(Function(Location) callback) {
    if (_eventsMotionChange == null) {
      _eventsMotionChange = _eventChannelMotionChange
          .receiveBroadcastStream()
          .map((dynamic event) => Location(event));
    }
    _registerSubscription(_eventsMotionChange!.listen(callback), callback);
  }

  /// Subscribe to location events
  ///
  ///  **NOTE:** When performing a [onMotionChange] or [getCurrentPosition], the plugin requests **multiple** location *samples* in order to record the most accurate location possible.  These *samples* are **not** persisted to the database but they will be provided to your `callback`, for your convenience, since it can take some seconds for the best possible location to arrive.
  ///
  /// For example, you might use these samples to progressively update the user's position on a map.  You can detect these *samples* in your `callback` via `location.sample == true`.  If you're manually `POST`ing location to your server, you should ignore these locations.
  ///
  /// ## Example
  ///
  /// ```dart
  /// BackgroundGeolocation.onLocation((Location location) {
  ///   print('[onLocation] success: ${location}');
  /// }, (LocationError error) {
  ///   print('[onLocation] ERROR: ${error}');
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
  static void onLocation(Function(Location) success,
      [Function(LocationError)? failure]) {
    if (_eventsLocation == null) {
      _eventsLocation = _eventChannelLocation
          .receiveBroadcastStream()
          .map((dynamic event) => Location(event));
    }
    _registerSubscription(
        _eventsLocation!.listen(success, onError: (dynamic error) {
          if (failure != null) {
            failure(LocationError(error));
          } else {
            _onLocationError(LocationError(error));
          }
        }),
        success);
  }

  static void _onLocationError(LocationError error) {
    print(
        '[BackgroundGeolocation onLocation] ‼️ Unhandled location error: $error.\nYou should provide a failure callback as 2nd argument to BackgroundGeolocation.onLocation.\nEg:  BackgroundGeolocation.onLocation(_onLocation, (LocationError error) {\n\t// Handle LocationError here.\n\tprint("[onLocation] ERROR: \$error");\n});');
  }

  /// Subscribe to changes in motion activity.
  ///
  /// Your `callback` will be executed each time the activity-recognition system receives an event (`still, on_foot, in_vehicle, on_bicycle, running`).
  ///
  /// ## Example
  ///
  /// ```dart
  /// BackgroundGeolocation.onActivityChange((ActivityChangeEvent event) {
  ///   print('[onActivityChange] ${event}');
  /// });
  /// ```
  ///
  static void onActivityChange(Function(ActivityChangeEvent) callback) {
    if (_eventsActivityChange == null) {
      _eventsActivityChange = _eventChannelActivityChange
          .receiveBroadcastStream()
          .map((dynamic event) {
        return ActivityChangeEvent(event['activity'], event['confidence']);
      });
    }
    _registerSubscription(_eventsActivityChange!.listen(callback), callback);
  }

  /// Subscribe to Geofence transition events.
  ///
  /// Your supplied `callback` will be called when any monitored geofence crossing occurs.
  ///
  /// ## Example
  ///
  /// BackgroundGeolocation.onGeofence((GeofenceEvent event) {
  ///   print('[onGeofence] ${event}');
  /// });
  /// ```
  static void onGeofence(Function(GeofenceEvent) callback) {
    if (_eventsGeofence == null) {
      _eventsGeofence = _eventChannelGeofence
          .receiveBroadcastStream()
          .map((dynamic event) => GeofenceEvent(event));
    }
    _registerSubscription(_eventsGeofence!.listen(callback), callback);
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
  ///   List<String> on = event.on;     //<-- new geofences activated.
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
              GeofencesChangeEvent(event['on'], event['off']));
    }
    _registerSubscription(_eventsGeofencesChange!.listen(callback), callback);
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
  ///   print('[onHeartbeat] ${event}');
  ///
  ///   // You could request a new location if you wish.
  ///   BackgroundGeolocation.getCurrentPosition(
  ///     samples: 1,
  ///     persist: true
  ///   ).then((Location location) {
  ///     print('[getCurrentPosition] ${location}');
  ///   });
  /// })
  /// ```
  ///
  static void onHeartbeat(Function(HeartbeatEvent) callback) {
    if (_eventsHeartbeat == null) {
      _eventsHeartbeat = _eventChannelHeartbeat
          .receiveBroadcastStream()
          .map((dynamic event) => HeartbeatEvent(event));
    }
    _registerSubscription(_eventsHeartbeat!.listen(callback), callback);
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
  ///   print('[onHttp] status: ${status}, success? ${success}, responseText: ${responseText}');
  /// });
  /// ```
  ///
  static void onHttp(Function(HttpEvent) callback) {
    if (_eventsHttp == null) {
      _eventsHttp = _eventChannelHttp
          .receiveBroadcastStream()
          .map((dynamic event) => HttpEvent(event));
    }
    _registerSubscription(_eventsHttp!.listen(callback), callback);
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
  static void onSchedule(Function(State) callback) {
    if (_eventsSchedule == null) {
      _eventsSchedule = _eventChannelSchedule
          .receiveBroadcastStream()
          .map((dynamic event) => State(event));
    }
    _registerSubscription(_eventsSchedule!.listen(callback), callback);
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
  ///   print('[onProviderChange: ${event}');
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
        return ProviderChangeEvent(event);
      });
    }
    _registerSubscription(_eventsProviderChange!.listen(callback), callback);
  }

  /// Subscribe to changes in network connectivity.
  ///
  /// Fired when the state of the device's network-connectivity changes (enabled -> disabled and vice-versa).  By default, the plugin will automatically fire a `connectivitychange` event with the current state network-connectivity whenever the [start] method is executed.
  ///
  /// ## Example
  /// ```dart
  /// BackgroundGeolocation.oConnectivityChange((ConnectivityChangeEvent event) {
  ///   print('[onConnectivityChange] ${event}');
  /// });
  /// ```
  ///
  static void onConnectivityChange(Function(ConnectivityChangeEvent) callback) {
    if (_eventsConnectivityChange == null) {
      _eventsConnectivityChange = _eventChannelConnectivityChange
          .receiveBroadcastStream()
          .map((dynamic event) {
        return ConnectivityChangeEvent(event['connected']);
      });
    }
    _registerSubscription(
        _eventsConnectivityChange!.listen(callback), callback);
  }

  /// Subscribe to changes in plugin [State.enabled].
  ///
  /// Fired when the plugin's [State.enabled] changes.  For example, executing [start] and [stop] will cause the `onEnabledChnage` event to fire.  This event is primarily designed for use with the configuration option [Config.stopAfterElapsedMinutes], which automatically executes the plugin's [stop] method.
  ///
  /// ## Example
  ///
  /// ```dart
  /// BackgroundGeolocation.onEnabledChange'((bool isEnabled) {
  ///   print('[onEnabledChanged] isEnabled? ${isEnabled}');
  /// });
  /// ```
  ///
  static void onEnabledChange(Function(bool) callback) {
    if (_eventsEnabledChange == null) {
      _eventsEnabledChange = _eventChannelEnabledChange
          .receiveBroadcastStream()
          .map((dynamic enabled) => enabled as bool);
    }
    _registerSubscription(_eventsEnabledChange!.listen(callback), callback);
  }

  /// Subscribe to state changes in OS power-saving system.
  ///
  /// Fired when the state of the operating-system's "Power Saving" mode changes.  Your `callback` will be provided with a `bool` showing whether "Power Saving" is **enabled** or **disabled**.  Power Saving mode can throttle certain services in the background, such as HTTP requests or GPS.
  ///
  ///  **NOTE:** You can manually request the current-state of "Power Saving" mode with the method [DeviceSettings.isPowerSaveMode].
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
  /// BackgroundGeolocation.onPowerSaveChange((bool isPowerSaveMode) {
  ///   print('[onPowerSaveChange: ${isPowerSaveMode}');
  /// });
  /// ```
  ///
  static void onPowerSaveChange(Function(bool) callback) {
    if (_eventsPowerSaveChange == null) {
      _eventsPowerSaveChange = _eventChannelPowerSaveChange
          .receiveBroadcastStream()
          .map((dynamic isPowerSaveMode) => isPowerSaveMode as bool);
    }
    _registerSubscription(_eventsPowerSaveChange!.listen(callback), callback);
  }

  /// Listen to [Authorization] events from [Authorization.refreshUrl].
  ///
  /// If you've configured [Config.authorization], this event will be fired when your [Authorization.refreshUrl] returns a response,
  /// either successfully or not.
  ///
  /// ```dart
  /// BackgroundGeolocation.onAuthorization((Authorization event) {
  ///   print("[authorization] $event");
  ///
  ///   if (event.success) {
  ///     print("- Authorization response: ${event.response}");
  ///   } else {
  ///     print("- Authorization error: ${event.message}");
  ///   }
  /// });
  /// ```
  ///
  static void onAuthorization(Function(AuthorizationEvent) callback) {
    if (_eventsAuthorization == null) {
      _eventsAuthorization = _eventChannelAuthorization
          .receiveBroadcastStream()
          .map((dynamic event) => AuthorizationEvent(event));
    }
    _registerSubscription(_eventsAuthorization!.listen(callback), callback);
  }

  /// __(Android only)__ Registers a button-click listener on a [Custom Notification Layout](https://github.com/transistorsoft/flutter_background_geolocation/wiki/Android-Custom-Notification-Layout)
  ///
  /// ![](https://dl.dropbox.com/s/whcb6q1gxxdk9t1/android-foreground-notification-transistor.png?dl=1)
  ///
  /// ℹ️ See also:
  /// - [Android Custom Notification Layout](https://github.com/transistorsoft/flutter_background_geolocation/wiki/Android-Custom-Notification-Layout)
  /// - [Notification.actions]
  /// - [Notification.layout]
  ///
  /// ```dart
  /// BackgroundGeolocation.ready(Config(
  ///   notification: Notification(
  ///     actions: [  // <-- register button listeners
  ///       "notificationButtonFoo",
  ///       "notificationButtonBar"
  ///     ]
  ///   )
  /// ));
  ///
  /// // Listen to custom button clicks:
  /// BackgroundGeolocation.onNotificationAction((String buttonId) {
  ///   print("[onNotificationAction] - ${buttonId}");
  ///   switch(buttonId) {
  ///     case 'notificationButtonFoo':
  ///       break;
  ///     case 'notificationButtonBar':
  ///       break;
  ///   }
  /// });
  /// ```
  ///
  static void onNotificationAction(Function(String) callback) {
    if (_eventsNotificationAction == null) {
      _eventsNotificationAction = _eventChannelNotificationAction
          .receiveBroadcastStream()
          .map((dynamic action) => action as String);
    }
    _registerSubscription(
        _eventsNotificationAction!.listen(callback), callback);
  }

  /// Registers a function to receive events from __`BackgroundGeolocation`__ while in the *terminated* ("Headless") state.
  ///
  /// __Note:__ Requires [Config.enableHeadless]:true.  See the [Android Headless Mode Guide](https://github.com/transistorsoft/flutter_background_geolocation/wiki/Android-Headless-Mode).
  ///
  /// In **`main.dart`**, create a global function beside `void main() {}` (**Must** be defined as a distinct function, not an anonymous callback).  This `function` will receive *all* events from `BackgroundGeolocation` in the headless state, and provided with a [HeadlessEvent] containing a [HeadlessEvent.name] and [HeadlessEvent.event].
  ///
  /// After running your app with `runApp`, register your headless-task with [registerHeadlessTask].  Within your `callback`, you're free to interact with the complete `BackgroundGeolocation` API.
  ///
  /// __WARNING:__ You **must** `registerHeadlessTask` in your `main.dart`.  Do **not** place it in your application components.
  ///
  /// ## Example
  ///
  /// __`main.dart`__
  /// ```dart
  /// import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
  ///
  /// /// Receives all events from BackgroundGeolocation while app is terminated:
  /// void headlessTask(HeadlessEvent headlessEvent) async {
  ///   print('[HeadlessTask]: ${headlessEvent}');
  ///
  ///   // Implement a 'case' for only those events you're interested in.
  ///   switch(headlessEvent.name) {
  ///     case Event.TERMINATE:
  ///       State state = headlessEvent.event;
  ///       print('- State: ${state}');
  ///       break;
  ///     case Event.HEARTBEAT:
  ///       HeartbeatEvent event = headlessEvent.event;
  ///       print('- HeartbeatEvent: ${event}');
  ///       break;
  ///     case Event.LOCATION:
  ///       Location location = headlessEvent.event;
  ///       print('- Location: ${location}');
  ///       break;
  ///     case Event.MOTIONCHANGE:
  ///       Location location = headlessEvent.event;
  ///       print('- Location: ${location}');
  ///       break;
  ///     case Event.GEOFENCE:
  ///       GeofenceEvent geofenceEvent = headlessEvent.event;
  ///       print('- GeofenceEvent: ${geofenceEvent}');
  ///       break;
  ///     case Event.GEOFENCESCHANGE:
  ///       GeofencesChangeEvent event = headlessEvent.event;
  ///       print('- GeofencesChangeEvent: ${event}');
  ///       break;
  ///     case Event.SCHEDULE:
  ///       State state = headlessEvent.event;
  ///       print('- State: ${state}');
  ///       break;
  ///     case Event.ACTIVITYCHANGE:
  ///       ActivityChangeEvent event = headlessEvent.event;
  ///       print('ActivityChangeEvent: ${event}');
  ///       break;
  ///     case Event.HTTP:
  ///       HttpEvent response = headlessEvent.event;
  ///       print('HttpEvent: ${response}');
  ///       break;
  ///     case Event.POWERSAVECHANGE:
  ///       bool enabled = headlessEvent.event;
  ///       print('ProviderChangeEvent: ${enabled}');
  ///       break;
  ///     case Event.CONNECTIVITYCHANGE:
  ///       ConnectivityChangeEvent event = headlessEvent.event;
  ///       print('ConnectivityChangeEvent: ${event}');
  ///       break;
  ///     case Event.ENABLEDCHANGE:
  ///       bool enabled = headlessEvent.event;
  ///       print('EnabledChangeEvent: ${enabled}');
  ///       break;
  ///   }
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
  /// - [onNotificationAction]
  ///
  /// __WARNING__:
  ///
  /// - You **cannot** register more than **one** headless-task.
  /// - You **cannot** reference your UI within your headless-task.  There is no UI.
  ///
  /// - Do **not** register an inline `function` to [registerHeadlessTask] -- the Flutter framework will **fail** to address it:
  ///
  /// ```dart
  /// // NO!  This will not work.
  /// BackgroundGeolocation.registerHeadlessTask((HeadlessEvent event) {
  ///   print('${event}');
  /// });
  ///
  /// // YES!
  /// void myHeadlessTask(HeadlessEvent headlessEvent) async {
  ///   print('${event}');
  /// }
  ///
  /// BackgroundGeolocation.registerHeadlessTask(myHeadlessTask);
  ///
  /// ```
  ///
  static Future<bool> registerHeadlessTask(
      void Function(HeadlessEvent) callback) async {
    Completer completer = Completer<bool>();

    // Two callbacks:  the provided headless-task + _headlessRegistrationCallback
    List<int> args = [
      PluginUtilities.getCallbackHandle(_headlessCallbackDispatcher)!
          .toRawHandle(),
      PluginUtilities.getCallbackHandle(callback)!.toRawHandle()
    ];
    _methodChannel
        .invokeMethod<bool>('registerHeadlessTask', args)
        .then((bool? success) {
      completer.complete(true);
    }).catchError((error) {
      print('[BackgroundGeolocation registerHeadlessTask] ‼️ $error');
      completer.complete(false);
    });
    return completer.future as FutureOr<bool>;
  }

  static void _registerSubscription(
      StreamSubscription<dynamic> sub, Function callback) {
    _subscriptions.add(_Subscription(sub, callback));
  }

// Initiate a constant stream of location-updates
// DISABLED:  can't execute callback more than once with Flutter.  Will have to use an EventChannel.
//  static Future<Location> watchPosition(
//      {int timeout,
//        int interval,
//        bool persist,
//        int desiredAccuracy,
//        Map<String, dynamic> extras}) async {
//    Map<String, dynamic> options = {};
//    if (timeout != null) options['timeout'] = timeout;
//    if (interval != null) options['interval'] = interval;
//    if (persist != null) options['persist'] = persist;
//    if (desiredAccuracy != null) options['desiredAccuracy'] = desiredAccuracy;
//    if (extras != null) options['extras'] = extras;
//
//    Completer completer =  Completer<Location>();
//
//    _methodChannel
//        .invokeMethod('watchPosition', options)
//        .then((dynamic data) {
//      completer.complete(Location(data));
//    }).catchError((error) {
//      completer.completeError(LocationError(error));
//    });
//    return completer.future;
//  }
// Halt watchPosition
//
//  static Future<bool> stopWatchPosition() async {
//    return await _methodChannel.invokeMethod('stopWatchPosition');
//  }
}

/// Headless Callback Dispatcher
///
@pragma('vm:entry-point')
void _headlessCallbackDispatcher() {
  WidgetsFlutterBinding.ensureInitialized();
  const MethodChannel _headlessChannel =
      MethodChannel("$_PLUGIN_PATH/headless", JSONMethodCodec());

  _headlessChannel.setMethodCallHandler((MethodCall call) async {
    final args = call.arguments;

    // Run the headless-task.
    try {
      final Function? callback = PluginUtilities.getCallbackFromHandle(
          CallbackHandle.fromRawHandle(args['callbackId']));
      if (callback == null) {
        print(
            '[BackgroundGeolocation _headlessCallbackDispatcher] ERROR: Failed to get callback from handle: $args');
        return;
      }
      callback(HeadlessEvent(args['event'], args['params']));
    } catch (e, stacktrace) {
      print(
          '[BackgroundGeolocation _headlessCallbackDispather] ‼️ Callback error: ' +
              e.toString());
      print(stacktrace);
    }
  });
  // Signal to native side that the client dispatcher is ready to receive events.
  _headlessChannel.invokeMethod('initialized');
}
