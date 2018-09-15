part of flt_background_geolocation;

const PLUGIN_PATH                         = "com.transistorsoft/flutter_background_geolocation";
const METHOD_CHANNEL_NAME                 = "$PLUGIN_PATH/methods";

const EVENT_CHANNEL_LOCATION              = "$PLUGIN_PATH/events/location";
const EVENT_CHANNEL_MOTIONCHANGE          = "$PLUGIN_PATH/events/motionchange";
const EVENT_CHANNEL_ACTIVITYCHANGE        = "$PLUGIN_PATH/events/activitychange";
const EVENT_CHANNEL_PROVIDERCHANGE        = "$PLUGIN_PATH/events/providerchange";
const EVENT_CHANNEL_GEOFENCESCHANGE       = "$PLUGIN_PATH/events/geofenceschange";
const EVENT_CHANNEL_GEOFENCE              = "$PLUGIN_PATH/events/geofence";
const EVENT_CHANNEL_HEARTBEAT             = "$PLUGIN_PATH/events/heartbeat";
const EVENT_CHANNEL_HTTP                  = "$PLUGIN_PATH/events/http";
const EVENT_CHANNEL_SCHEDULE              = "$PLUGIN_PATH/events/schedule";
const EVENT_CHANNEL_POWERSAVECHANGE       = "$PLUGIN_PATH/events/powersavechange";
const EVENT_CHANNEL_CONNECTIVITYCHANGE    = "$PLUGIN_PATH/events/connectivitychange";
const EVENT_CHANNEL_ENABLEDCHANGE         = "$PLUGIN_PATH/events/enabledchange";

class Subscription {
  final StreamSubscription<dynamic> subscription;
  final Function callback;

  Subscription(this.subscription, this.callback);
}

class BackgroundGeolocation {
  // MethodChannel
  static const MethodChannel _methodChannel = const MethodChannel(METHOD_CHANNEL_NAME);
  // EventChannels
  static const EventChannel _eventChannelMotionChange = const EventChannel(EVENT_CHANNEL_MOTIONCHANGE);
  static const EventChannel _eventChannelLocation = const EventChannel(EVENT_CHANNEL_LOCATION);
  static const EventChannel _eventChannelActivityChange = const EventChannel(EVENT_CHANNEL_ACTIVITYCHANGE);
  static const EventChannel _eventChannelProviderChange = const EventChannel(EVENT_CHANNEL_PROVIDERCHANGE);
  static const EventChannel _eventChannelGeofencesChange = const EventChannel(EVENT_CHANNEL_GEOFENCESCHANGE);
  static const EventChannel _eventChannelGeofence = const EventChannel(EVENT_CHANNEL_GEOFENCE);
  static const EventChannel _eventChannelHeartbeat = const EventChannel(EVENT_CHANNEL_HEARTBEAT);
  static const EventChannel _eventChannelHttp = const EventChannel(EVENT_CHANNEL_HTTP);
  static const EventChannel _eventChannelSchedule = const EventChannel(EVENT_CHANNEL_SCHEDULE);
  static const EventChannel _eventChannelPowerSaveChange = const EventChannel(EVENT_CHANNEL_POWERSAVECHANGE);
  static const EventChannel _eventChannelConnectivityChange = const EventChannel(EVENT_CHANNEL_CONNECTIVITYCHANGE);
  static const EventChannel _eventChannelEnabledChange = const EventChannel(EVENT_CHANNEL_ENABLEDCHANGE);
  // Event Subscriptions
  static List<Subscription> _subscriptions = new List();
  // Stream Listeners
  static Stream<Location>                 _eventsLocation;
  static Stream<Location>                 _eventsMotionChange;
  static Stream<ActivityChangeEvent>      _eventsActivityChange;
  static Stream<ProviderChangeEvent>      _eventsProviderChange;
  static Stream<GeofencesChangeEvent>     _eventsGeofencesChange;
  static Stream<GeofenceEvent>            _eventsGeofence;
  static Stream<HeartbeatEvent>           _eventsHeartbeat;
  static Stream<HttpEvent>                _eventsHttp;
  static Stream<State>                  _eventsSchedule;
  static Stream<bool>                     _eventsPowerSaveChange;
  static Stream<ConnectivityChangeEvent>  _eventsConnectivityChange;
  static Stream<bool>                     _eventsEnabledChange;

  static Future<State> getState() async {
    Map state = await _methodChannel.invokeMethod('getState');
    return new State(state);
  }

  static Future<State> ready(Config config) async {
    Map state = await _methodChannel.invokeMethod('ready',config.toMap());
    return new State(state);
  }

  static Future<State> setConfig(Config config) async {
    Map state = await _methodChannel.invokeMethod('setConfig', config.toMap());
    return new State(state);
  }

  static Future<State> reset([Config config]) async {
    Map state = await _methodChannel.invokeMethod('reset', (config != null) ? config.toMap() : null);
    return new State(state);
  }

  static Future<State> start() async {
    Map state = await _methodChannel.invokeMethod('start');
    return new State(state);
  }

  static Future<State> stop() async {
    Map state = await _methodChannel.invokeMethod('stop');
    return new State(state);
  }

  static Future<State> startSchedule() async {
    Map state = await _methodChannel.invokeMethod('startSchedule');
    return new State(state);
  }

  static Future<State> stopSchedule() async {
    Map state = await _methodChannel.invokeMethod('stopSchedule');
    return new State(state);
  }

  static Future<State> startGeofences() async {
    Map state = await _methodChannel.invokeMethod('startGeofences');
    return new State(state);
  }

  static Future<int> startBackgroundTask() async {
    return await _methodChannel.invokeMethod('startBackgroundTask');
  }

  static Future<int> finish(int taskId) async {
    return await _methodChannel.invokeMethod('finish', taskId);
  }

  static Future<bool> changePace(bool isMoving) async {
    return await _methodChannel.invokeMethod('changePace', isMoving);
  }

  static Future<Location> getCurrentPosition({
    int samples,
    int timeout,
    int maximumAge,
    bool persist,
    int desiredAccuracy,
    Map<String, dynamic> extras
  }) async {
    Map<String,dynamic> options = {};
    if (timeout != null)          options['timeout'] = timeout;
    if (maximumAge != null)       options['maximumAge'] = maximumAge;
    if (persist != null)          options['persist'] = persist;
    if (desiredAccuracy != null)  options['desiredAccuracy'] = desiredAccuracy;
    if (extras != null)           options['extras'] = extras;

    Map data = await _methodChannel.invokeMethod('getCurrentPosition', options);

    return new Location(data);
  }

  static Future<double> getOdometer() async {
    return await _methodChannel.invokeMethod('getOdometer');
  }

  static Future<Location> setOdometer(double value) async {
    Map data = await _methodChannel.invokeMethod('setOdometer', value);
    return new Location(data);
  }
  static Future<String> platformVersion() async {
    return await _methodChannel.invokeMethod('getPlatformVersion');
  }

  /**
   * HTTP & Persistence Methods
   */
  static Future<List> getLocations() async {
    return await _methodChannel.invokeMethod('getLocations');
  }

  static Future<int> getCount() async {
    return await _methodChannel.invokeMethod('getCount');
  }

  static Future<bool> destroyLocations() async {
    return await _methodChannel.invokeMethod('destroyLocations');
  }

  static Future<Location> insertLocation(Map<String, dynamic>params) async {
    return await _methodChannel.invokeMethod('insertLocation', params);
  }

  static Future<List> sync() async {
    return await _methodChannel.invokeMethod('sync');
  }

  /**
   * Geofencing Methods
   */
  static Future<bool> addGeofence(Geofence geofence) async {
    return await _methodChannel.invokeMethod('addGeofence', geofence.toMap());
  }

  static Future<bool> addGeofences(List<Geofence>geofences) async {
    List<Map<String,dynamic>> rs = geofences.map((Geofence geofence) => geofence.toMap());
    return await _methodChannel.invokeMethod('addGeofences', rs);
  }

  static Future<bool> removeGeofence(String identifier) async {
    return await _methodChannel.invokeMethod('removeGeofence', identifier);
  }

  static Future<bool> removeGeofences() async {
    return await _methodChannel.invokeMethod('removeGeofences');
  }

  static Future<List<Geofence>> getGeofences() async {
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
        loiteringDelay: (loiteringDelay.runtimeType == double) ? loiteringDelay.round() : loiteringDelay,
        extras: data['extras'].cast<String,dynamic>()
      ));
    });
    return rs;
  }

  /**
   * Logging & Debug Methods
   */
  static Future<String> getLog() async {
    return await _methodChannel.invokeMethod('getLog');
  }

  static Future<bool> emailLog(String email) async {
    return await _methodChannel.invokeMethod('emailLog', email);
  }

  static Future<bool> isPowerSaveMode() async {
    return await _methodChannel.invokeMethod('isPowerSaveMode');
  }

  static Future<Sensors> getSensors() async {
    Completer completer = new Completer();

    _methodChannel.invokeMethod('getSensors').then((dynamic data) {
      completer.complete(new Sensors(
          data['platform'],
          data['accelerometer'],
          data['gyroscope'],
          data['magnetometer'],
          data['motion_hardware']
      ));
    }).catchError((e) {
      completer.completeError(e);
    });
    return completer.future;
  }

  static Future<bool> playSound(int soundId) async {
    return await _methodChannel.invokeMethod('playSound', soundId);
  }

  /**
   * Event managment
   */
  static void removeListeners() {
    _subscriptions.forEach((Subscription sub) => sub.subscription.cancel());
    _subscriptions.clear();
  }

  static bool removeListener(Function callback) {
    Subscription found = _subscriptions.firstWhere((Subscription item) => item.callback == callback, orElse: () => null);
    if (found != null) {
      found.subscription.cancel();
      _subscriptions.remove(found);
      return true;
    } else {
      return false;
    }
  }

  static void onMotionChange(Function(Location) callback) {
    if (_eventsMotionChange == null) {
      _eventsMotionChange = _eventChannelMotionChange.receiveBroadcastStream().map((dynamic event) => new Location(event));
    }
    _registerSubscription(_eventsMotionChange.listen(callback), callback);
  }

  static void onLocation(Function(Location) callback) {
    if (_eventsLocation == null) {
      _eventsLocation = _eventChannelLocation.receiveBroadcastStream().map((dynamic event) => new Location(event));
    }
    _registerSubscription(_eventsLocation.listen(callback), callback);
  }

  static void onActivityChange(Function(ActivityChangeEvent) callback) {
    if (_eventsActivityChange == null) {
      _eventsActivityChange = _eventChannelActivityChange.receiveBroadcastStream().map((dynamic event) {
        return new ActivityChangeEvent(event['activity'], event['confidence']);
      });
    }
    _registerSubscription(_eventsActivityChange.listen(callback), callback);
  }

  static void onGeofence(Function(GeofenceEvent) callback) {
    if (_eventsGeofence == null) {
      _eventsGeofence = _eventChannelGeofence.receiveBroadcastStream().map((dynamic event) => new GeofenceEvent(event));
    }
    _registerSubscription(_eventsGeofence.listen(callback), callback);
  }

  static void onGeofencesChange(Function(GeofencesChangeEvent) callback) {
    if (_eventsGeofencesChange == null) {
      _eventsGeofencesChange = _eventChannelGeofencesChange.receiveBroadcastStream().map((dynamic event) => new GeofencesChangeEvent(event['on'], event['off']));
    }
    _registerSubscription(_eventsGeofencesChange.listen(callback), callback);
  }

  static void onHeartbeat(Function(HeartbeatEvent) callback) {
    if (_eventsHeartbeat == null) {
      _eventsHeartbeat = _eventChannelHeartbeat.receiveBroadcastStream().map((dynamic event) => new HeartbeatEvent(event));
    }
    _registerSubscription(_eventsHeartbeat.listen(callback), callback);
  }

  static void onHttp(Function(HttpEvent) callback) {
    if (_eventsHttp == null) {
      _eventsHttp = _eventChannelHttp.receiveBroadcastStream().map((dynamic event) => new HttpEvent(event));
    }
    _registerSubscription(_eventsHttp.listen(callback), callback);
  }

  static void onSchedule(Function(dynamic) callback) {
    if (_eventsSchedule == null) {
      _eventsSchedule = _eventChannelSchedule.receiveBroadcastStream().map((dynamic event) {
        // TODO cast to BGState
        return event;
      });
    }
    _registerSubscription(_eventsSchedule.listen(callback), callback);
  }

  static void onProviderChange(Function(ProviderChangeEvent) callback) {
    if (_eventsProviderChange == null) {
      _eventsProviderChange = _eventChannelProviderChange.receiveBroadcastStream().map((dynamic event) {
        return new ProviderChangeEvent(event['enabled'], event['status'], event['network'], event['gps']);
      });
    }
    _registerSubscription(_eventsProviderChange.listen(callback), callback);
  }

  static void onConnectivityChange(Function(ConnectivityChangeEvent) callback) {
    if (_eventsConnectivityChange == null) {
      _eventsConnectivityChange = _eventChannelConnectivityChange.receiveBroadcastStream().map((dynamic event) {
        return new ConnectivityChangeEvent(event['connected']);
      });
    }
    _registerSubscription(_eventsConnectivityChange.listen(callback), callback);
  }

  static void onEnabledChange(Function(bool) callback) {
    if (_eventsEnabledChange == null) {
      _eventsEnabledChange = _eventChannelEnabledChange.receiveBroadcastStream().map((dynamic enabled) => enabled as bool);
    }
    _registerSubscription(_eventsEnabledChange.listen(callback), callback);
  }

  static void onPowerSaveChange(Function(bool) callback) {
    if (_eventsPowerSaveChange == null) {
      _eventsPowerSaveChange = _eventChannelPowerSaveChange.receiveBroadcastStream().map((dynamic isPowerSaveMode) => isPowerSaveMode as bool);
    }
    _registerSubscription(_eventsPowerSaveChange.listen(callback), callback);
  }

  static void _registerSubscription(StreamSubscription<dynamic> sub, Function callback) {
    _subscriptions.add(new Subscription(sub, callback));
  }

  static String get foo {
    return "Foo";
  }

}