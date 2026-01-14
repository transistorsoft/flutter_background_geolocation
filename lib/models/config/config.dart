part of '../../flutter_background_geolocation.dart';

// ignore_for_file: deprecated_member_use_from_same_package

/// Configuration API.
///
/// The `Config` class defines all SDK options, grouped into compound configuration objects:
/// - [GeoConfig] — Geolocation and filtering options
/// - [AppConfig] — Application lifecycle options
/// - [HttpConfig] — Networking and HTTP sync options
/// - [PersistenceConfig] — Data persistence and database options
/// - [LoggerConfig] — Logging and debugging options
/// - [ActivityConfig] — Motion and activity-recognition options
///
/// Instances of `Config` are consumed by [BackgroundGeolocation.ready] and [BackgroundGeolocation.setConfig].
///
/// # Example
///
/// ```dart
/// import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
///
/// void main() async {
///   // Configure the SDK with compound configuration objects.
///   bg.Config config = bg.Config(
///     geolocation: bg.GeoConfig(
///       desiredAccuracy: bg.GeoConfig.DESIRED_ACCURACY_HIGH,
///       distanceFilter: 20.0,
///       stopTimeout: 5,
///       stationaryRadius: 150.0,
///     ),
///     activity: bg.ActivityConfig(
///       activityRecognitionInterval: 10000,
///       minimumActivityRecognitionConfidence: 75,
///       disableStopDetection: false,
///       motionTriggerDelay: 30000,
///     ),
///     http: bg.HttpConfig(
///       url: 'https://my.server.com/api/locations',
///       method: 'POST',
///       autoSync: true,
///       headers: {
///         'Authorization': 'Bearer secret-token'
///       },
///       params: {
///         'user_id': 123
///       },
///     ),
///     persistence: bg.PersistenceConfig(
///       persistMode: bg.PersistenceConfig.PERSIST_MODE_ALL,
///       maxDaysToPersist: 14,
///       extras: {'appVersion': '1.0.0'},
///     ),
///     app: bg.AppConfig(
///       stopOnTerminate: false,
///       startOnBoot: true,
///       enableHeadless: true,
///       heartbeatInterval: 60,
///     ),
///     logger: bg.LoggerConfig(
///       debug: true,
///       logLevel: bg.LoggerConfig.LOG_LEVEL_VERBOSE,
///       logMaxDays: 3,
///     ),
///   );
///
///   // Apply the configuration.
///   bg.BackgroundGeolocation.ready(config).then((bg.State state) {
///     print('[ready] BackgroundGeolocation is configured and ready to use');
///
///     if (!state.enabled) {
///       bg.BackgroundGeolocation.start();
///     }
///   });
///
///   // To modify configuration after initialization, use [setConfig].
///   bg.BackgroundGeolocation.setConfig(bg.Config(
///     http: bg.HttpConfig(
///       headers: {
///         'Authorization': 'Bearer new-token'
///       }
///     ),
///     logger: bg.LoggerConfig(
///       logLevel: bg.Config.LOG_LEVEL_INFO
///     ),
///   )).then((bg.State state) {
///     bg.BackgroundGeolocation.sync();
///   });
/// }
/// ```
///
class Config {
  static const int LOG_LEVEL_OFF = 0;
  static const int LOG_LEVEL_ERROR = 1;
  static const int LOG_LEVEL_WARNING = 2;
  static const int LOG_LEVEL_INFO = 3;
  static const int LOG_LEVEL_DEBUG = 4;
  static const int LOG_LEVEL_VERBOSE = 5;

  static const int DESIRED_ACCURACY_NAVIGATION = -2;
  static const int DESIRED_ACCURACY_HIGH = -1;
  static const int DESIRED_ACCURACY_MEDIUM = 10;
  static const int DESIRED_ACCURACY_LOW = 100;
  static const int DESIRED_ACCURACY_VERY_LOW = 1000;
  static const int DESIRED_ACCURACY_LOWEST = 3000;

  static const int AUTHORIZATION_STATUS_NOT_DETERMINED = 0;
  static const int AUTHORIZATION_STATUS_RESTRICTED = 1;
  static const int AUTHORIZATION_STATUS_DENIED = 2;
  static const int AUTHORIZATION_STATUS_ALWAYS = 3;
  static const int AUTHORIZATION_STATUS_WHEN_IN_USE = 4;

  static const int NOTIFICATION_PRIORITY_DEFAULT = 0;
  static const int NOTIFICATION_PRIORITY_HIGH = 1;
  static const int NOTIFICATION_PRIORITY_LOW = -1;
  static const int NOTIFICATION_PRIORITY_MAX = 2;
  static const int NOTIFICATION_PRIORITY_MIN = -2;

  // === Compound configuration groups (public API) ===

  /// {@macro config.geolocation}
  final GeoConfig? geolocation;

  /// {@macro config.application}
  final AppConfig? app;

  /// {@macro config.http}
  final HttpConfig? http;

  /// {@macro config.persistence}
  final PersistenceConfig? persistence;

  /// {@macro config.logger}
  final LoggerConfig? logger;

  /// {@macro config.activity}
  final ActivityConfig? activity;

  // For iOS #activityType
  static const int ACTIVITY_TYPE_OTHER = 1;
  static const int ACTIVITY_TYPE_AUTOMOTIVE_NAVIGATION = 2;
  static const int ACTIVITY_TYPE_FITNESS = 3;
  static const int ACTIVITY_TYPE_OTHER_NAVIGATION = 4;
  static const int ACTIVITY_TYPE_AIRBORNE = 5;

  // #persistMode
  static const int PERSIST_MODE_ALL = 2;
  static const int PERSIST_MODE_LOCATION = 1;
  static const int PERSIST_MODE_GEOFENCE = -1;
  static const int PERSIST_MODE_NONE = 0;

  Map? _map;

  /// {@macro config.authorization}
  Authorization? authorization;

  /// Determines whether to reset the existing Config to defaults before appying new config (default true)
  bool? reset;

  ///
  /// Geolocation Config
  ///

  /// **Deprecated:** Use [GeoConfig.desiredAccuracy] via [Config.geolocation].
  @Deprecated('Use geolocation.desiredAccuracy (GeoConfig)')
  int? desiredAccuracy;

  /// **Deprecated:** Use [GeoConfig.distanceFilter] via [Config.geolocation].
  @Deprecated('Use geolocation.distanceFilter (GeoConfig)')
  double? distanceFilter;

  /// **Deprecated:** Use [GeoConfig.stationaryRadius] via [Config.geolocation].
  @Deprecated('Use geolocation.stationaryRadius (GeoConfig)')
  double? stationaryRadius;

  /// **Deprecated:** Use [GeoConfig.locationTimeout] via [Config.geolocation].
  @Deprecated('Use geolocation.locationTimeout (GeoConfig)')
  int? locationTimeout;

  /// **Deprecated:** Use [GeoConfig.disableElasticity] via [Config.geolocation].
  @Deprecated('Use geolocation.disableElasticity (GeoConfig)')
  bool? disableElasticity;

  /// **Deprecated:** Use [GeoConfig.elasticityMultiplier] via [Config.geolocation].
  @Deprecated('Use geolocation.elasticityMultiplier (GeoConfig)')
  double? elasticityMultiplier;

  /// **Deprecated:** Use [GeoConfig.useSignificantChangesOnly] via [Config.geolocation].
  @Deprecated('Use geolocation.useSignificantChangesOnly (GeoConfig)')
  bool? useSignificantChangesOnly;

  /// **Deprecated:** Use [GeoConfig.stopAfterElapsedMinutes] via [Config.geolocation].
  @Deprecated('Use geolocation.stopAfterElapsedMinutes (GeoConfig)')
  int? stopAfterElapsedMinutes;

  /// **Deprecated:** Use [GeoConfig.geofenceProximityRadius] via [Config.geolocation].
  @Deprecated('Use geolocation.geofenceProximityRadius (GeoConfig)')
  int? geofenceProximityRadius;

  /// **Deprecated:** Use [GeoConfig.maxMonitoredGeofences] via [Config.geolocation].
  @Deprecated('Use geolocation.maxMonitoredGeofences (GeoConfig)')
  int? maxMonitoredGeofences;

  /// **Deprecated:** Use [GeoConfig.geofenceInitialTriggerEntry] via [Config.geolocation].
  @Deprecated('Use geolocation.geofenceInitialTriggerEntry (GeoConfig)')
  bool? geofenceInitialTriggerEntry;

  /// **Deprecated:** Use [GeoConfig.geofenceModeHighAccuracy] via [Config.geolocation].
  @Deprecated('Use geolocation.geofenceModeHighAccuracy (GeoConfig)')
  bool? geofenceModeHighAccuracy;

  /// **Deprecated:** Use [LocationFilter.odometerAccuracyThreshold] via `Config.geolocation.filter`.
  @Deprecated(
      'Use geolocation.filter.odometerAccuracyThreshold (LocationFilter)')
  double? desiredOdometerAccuracy;

  /// **Deprecated:** Use [GeoConfig.stopTimeout] via [Config.geolocation].
  @Deprecated('Use geolocation.stopTimeout (GeoConfig)')
  int? stopTimeout;

  /// **Deprecated:** Use [GeoConfig.locationUpdateInterval] via [Config.geolocation].
  @Deprecated('Use geolocation.locationUpdateInterval (GeoConfig)')
  int? locationUpdateInterval;

  /// **Deprecated:** Use [GeoConfig.fastestLocationUpdateInterval] via [Config.geolocation].
  @Deprecated('Use geolocation.fastestLocationUpdateInterval (GeoConfig)')
  int? fastestLocationUpdateInterval;

  /// **Deprecated:** Use [GeoConfig.deferTime] via [Config.geolocation].
  @Deprecated('Use geolocation.deferTime (GeoConfig)')
  int? deferTime;

  /// **Deprecated:** Use [GeoConfig.allowIdenticalLocations] via [Config.geolocation].
  @Deprecated('Use geolocation.allowIdenticalLocations (GeoConfig)')
  bool? allowIdenticalLocations;

  /// **Deprecated:** Use [GeoConfig.enableTimestampMeta] via [Config.geolocation].
  @Deprecated('Use geolocation.enableTimestampMeta (GeoConfig)')
  bool? enableTimestampMeta;

  // ============================ iOS-specific ===============================

  /// **Deprecated:** Use [AppConfig.preventSuspend] via [Config.app].
  @Deprecated('Use app.preventSuspend (AppConfig)')
  bool? preventSuspend;

  /// **Deprecated:** Use [GeoConfig.pausesLocationUpdatesAutomatically] via [Config.geolocation].
  @Deprecated('Use geolocation.pausesLocationUpdatesAutomatically (GeoConfig)')
  bool? pausesLocationUpdatesAutomatically;

  /// **Deprecated:** Use [GeoConfig.locationAuthorizationRequest] via [Config.geolocation].
  @Deprecated('Use geolocation.locationAuthorizationRequest (GeoConfig)')
  String? locationAuthorizationRequest;

  /// **Deprecated:** Use [GeoConfig.locationAuthorizationAlert] via [Config.geolocation].
  @Deprecated('Use geolocation.locationAuthorizationAlert (GeoConfig)')
  Map<String, dynamic>? locationAuthorizationAlert;

  /// **Deprecated:** Use [GeoConfig.disableLocationAuthorizationAlert] via [Config.geolocation].
  @Deprecated('Use geolocation.disableLocationAuthorizationAlert (GeoConfig)')
  bool? disableLocationAuthorizationAlert;

  /// **Deprecated:** Use [GeoConfig.showsBackgroundLocationIndicator] via [Config.geolocation].
  @Deprecated('Use geolocation.showsBackgroundLocationIndicator (GeoConfig)')
  bool? showsBackgroundLocationIndicator;

  /// **Deprecated:** Use [GeoConfig.activityType] via [Config.geolocation].
  @Deprecated('Use geolocation.activityType (GeoConfig)')
  int? activityType;

  /// **Deprecated:** Use [ActivityConfig.stopDetectionDelay] via [Config.activity].
  @Deprecated('Use activity.stopDetectionDelay (ActivityConfig)')
  int? stopDetectionDelay;

  // ============================ Android-specific ======================================

  /// **Deprecated:** Use [GeoConfig.filter] settings via [Config.geolocation].
  @Deprecated('Use geolocation.filter.maxImpliedSpeed (GeoConfig)')
  int? speedJumpFilter;

  /// Activity-recognition Config

  /// Configure the SDK's initial state to tracking with location-services ON.
  bool? isMoving;

  /// **Deprecated:** Use [ActivityConfig.activityRecognitionInterval] via [Config.activity].
  @Deprecated('Use activity.activityRecognitionInterval (ActivityConfig)')
  int? activityRecognitionInterval;

  /// **Deprecated:** Use [ActivityConfig.minimumActivityRecognitionConfidence] via [Config.activity].
  @Deprecated(
      'Use activity.minimumActivityRecognitionConfidence (ActivityConfig)')
  int? minimumActivityRecognitionConfidence;

  /// **Deprecated:** Use [ActivityConfig.disableStopDetection] via [Config.activity].
  @Deprecated('Use activity.disableStopDetection (ActivityConfig)')
  bool? disableStopDetection;

  /// **Deprecated:** Use [ActivityConfig.stopOnStationary] via [Config.activity].
  @Deprecated('Use activity.stopOnStationary (ActivityConfig)')
  bool? stopOnStationary;

  /// **Deprecated:** Use [ActivityConfig.triggerActivities] via [Config.activity].
  @Deprecated('Use activity.triggerActivities (ActivityConfig)')
  String? triggerActivities;

  /// **Deprecated:** Use [ActivityConfig.motionTriggerDelay] via [Config.activity].
  @Deprecated('Use activity.motionTriggerDelay (ActivityConfig)')
  int? motionTriggerDelay;

  /// **Deprecated:** Use [ActivityConfig.disableMotionActivityUpdates] via [Config.activity].
  @Deprecated('Use activity.disableMotionActivityUpdates (ActivityConfig)')
  bool? disableMotionActivityUpdates;

  /// HTTP Config

  /// **Deprecated:** Use [HttpConfig.url] via [Config.http].
  @Deprecated('Use http.url (HttpConfig)')
  String? url;

  /// **Deprecated:** Use [HttpConfig.method] via [Config.http].
  @Deprecated('Use http.method (HttpConfig)')
  String? method;

  /// **Deprecated:** Use [HttpConfig.rootProperty] via [Config.http].
  @Deprecated('Use http.rootProperty (HttpConfig)')
  String? httpRootProperty;

  /// **Deprecated:** Use [HttpConfig.params] via [Config.http].
  @Deprecated('Use http.params (HttpConfig)')
  Map<String, dynamic>? params;

  /// **Deprecated:** Use [HttpConfig.headers] via [Config.http].
  @Deprecated('Use http.headers (HttpConfig)')
  Map<String, dynamic>? headers;

  /// **Deprecated:** Use [HttpConfig.autoSync] via [Config.http].
  @Deprecated('Use http.autoSync (HttpConfig)')
  bool? autoSync;

  /// **Deprecated:** Use [HttpConfig.autoSyncThreshold] via [Config.http].
  @Deprecated('Use http.autoSyncThreshold (HttpConfig)')
  int? autoSyncThreshold;

  /// **Deprecated:** Use [HttpConfig.batchSync] via [Config.http].
  @Deprecated('Use http.batchSync (HttpConfig)')
  bool? batchSync;

  /// **Deprecated:** Use [HttpConfig.maxBatchSize] via [Config.http].
  @Deprecated('Use http.maxBatchSize (HttpConfig)')
  int? maxBatchSize;

  /// **Deprecated:** Use [HttpConfig.timeout] via [Config.http].
  @Deprecated('Use http.timeout (HttpConfig)')
  int? httpTimeout;

  /// **Deprecated:** Use [HttpConfig.disableAutoSyncOnCellular] via [Config.http].
  @Deprecated('Use http.disableAutoSyncOnCellular (HttpConfig)')
  bool? disableAutoSyncOnCellular;

  /// Persistence Config

  /// **Deprecated:** Use [PersistenceConfig.persistMode] via [Config.persistence].
  @Deprecated('Use persistence.persistMode (PersistenceConfig)')
  int? persistMode;

  /// **Deprecated:** Use [PersistenceConfig.extras] via [Config.persistence].
  @Deprecated('Use persistence.extras (PersistenceConfig)')
  Map<String, dynamic>? extras;

  /// **Deprecated:** Use [PersistenceConfig.locationTemplate] via [Config.persistence].
  @Deprecated('Use persistence.locationTemplate (PersistenceConfig)')
  String? locationTemplate;

  /// **Deprecated:** Use [PersistenceConfig.geofenceTemplate] via [Config.persistence].
  @Deprecated('Use persistence.geofenceTemplate (PersistenceConfig)')
  String? geofenceTemplate;

  /// **Deprecated:** Use [PersistenceConfig.maxDaysToPersist] via [Config.persistence].
  @Deprecated('Use persistence.maxDaysToPersist (PersistenceConfig)')
  int? maxDaysToPersist;

  /// **Deprecated:** Use [PersistenceConfig.maxRecordsToPersist] via [Config.persistence].
  @Deprecated('Use persistence.maxRecordsToPersist (PersistenceConfig)')
  int? maxRecordsToPersist;

  /// **Deprecated:** Use [PersistenceConfig.locationsOrderDirection] via [Config.persistence].
  @Deprecated('Use persistence.locationsOrderDirection (PersistenceConfig)')
  String? locationsOrderDirection;

  /// **Deprecated:** Use [PersistenceConfig.disableProviderChangeRecord] via [Config.persistence].
  @Deprecated('Use persistence.disableProviderChangeRecord (PersistenceConfig)')
  bool? disableProviderChangeRecord;

  /// Application Config

  /// **Deprecated:** Use [AppConfig.stopOnTerminate] via [Config.app].
  @Deprecated('Use app.stopOnTerminate (AppConfig)')
  bool? stopOnTerminate;

  /// **Deprecated:** Use [AppConfig.startOnBoot] via [Config.app].
  @Deprecated('Use app.startOnBoot (AppConfig)')
  bool? startOnBoot;

  /// **Deprecated:** Use [AppConfig.heartbeatInterval] via [Config.app].
  @Deprecated('Use app.heartbeatInterval (AppConfig)')
  int? heartbeatInterval;

  /// **Deprecated:** Use [AppConfig.schedule] via [Config.app].
  @Deprecated('Use app.schedule (AppConfig)')
  List<String>? schedule;

  /// **Deprecated:** Use [AppConfig.scheduleUseAlarmManager] via [Config.app].
  @Deprecated('Use app.scheduleUseAlarmManager (AppConfig)')
  bool? scheduleUseAlarmManager;

  /// **Deprecated:** Use [AppConfig.enableHeadless] via [Config.app].
  @Deprecated('Use app.enableHeadless (AppConfig)')
  bool? enableHeadless;

  /// **Deprecated:** No longer used; always `true`.
  @Deprecated('No longer used; always true')
  bool? foregroundService;

  /// **Deprecated:** Use [AppConfig.backgroundPermissionRationale] via [Config.app].
  @Deprecated('Use app.backgroundPermissionRationale (AppConfig)')
  PermissionRationale? backgroundPermissionRationale;

  /// **Deprecated:** Use [AppConfig.notification] via [Config.app].
  @Deprecated('Use app.notification (AppConfig)')
  Notification? notification;

  /// Logger Config

  /// **Deprecated:** Use [LoggerConfig.debug] via [Config.logger].
  @Deprecated('Use logger.debug (LoggerConfig)')
  bool? debug;

  /// **Deprecated:** Use [LoggerConfig.logLevel] via [Config.logger].
  @Deprecated('Use logger.logLevel (LoggerConfig)')
  int? logLevel;

  /// **Deprecated:** Use [LoggerConfig.logMaxDays] via [Config.logger].
  @Deprecated('Use logger.logMaxDays (LoggerConfig)')
  int? logMaxDays;

  /// *Convenience* option to automatically configures the SDK to upload locations to the Transistor Software demo server at http://tracker.transistorsoft.com (or your own local instance of [background-geolocation-console](https://github.com/transistorsoft/background-geolocation-console))
  ///
  /// See [TransistorAuthorizationToken].  This option will **automatically configure** [HttpConfig.url] to point at the Demo server as well as well as the required [Authorization] configuration.
  ///
  ///
  /// ## Example
  /// ```dart
  /// TransistorAuthorizationToken token = await
  ///   TransistorAuthorizationToken.findOrCreate('my-company-name', 'my-username');
  ///
  /// BackgroundGeolocation.ready(Config(
  ///   transistorAuthorizationToken: token
  /// ));
  /// ```
  ///
  /// This *convenience* option merely performs the following [Authorization] configuration *automatically* for you:
  ///
  /// ```dart
  /// // Base url to Transistor Demo Server.
  /// const String url = 'http://tracker.transistorsoft.com';
  ///
  /// // Register for an authorization token from server.
  /// TransistorAuthorizationToken token = await
  ///   TransistorAuthorizationToken.findOrCreate('my-company-name', 'my-username');
  ///
  /// BackgroundGeolocation.ready(Config(
  ///   /// This convenience option sets [HttpConfig.url] to the Demo server and configures [Authorization].
  ///   url: "$url/api/locations",
  ///   authorization: Authorization(
  ///     strategy: "JWT",
  ///     accessToken: token.accessToken,
  ///     refreshToken: token.refreshToken,
  ///     refreshUrl: "$url/api/refresh_token",
  ///     refreshPayload: {
  ///       "refresh_token": "{refreshToken}"
  ///     },
  ///     expires: token.expires
  ///   )
  /// ));
  /// ```
  ///
  TransistorAuthorizationToken? transistorAuthorizationToken;

  Config(
      {
      // [New] Compound Config objects
      this.geolocation,
      this.app,
      this.http,
      this.persistence,
      this.logger,
      this.activity,
      this.authorization,
      // [Deprecated] flat config options
      // Geolocation Options
      this.desiredAccuracy,
      this.distanceFilter,
      this.stationaryRadius,
      this.locationTimeout,
      this.disableElasticity,
      this.elasticityMultiplier,
      this.stopAfterElapsedMinutes,
      this.geofenceProximityRadius,
      this.maxMonitoredGeofences,
      this.geofenceInitialTriggerEntry,
      this.desiredOdometerAccuracy,
      this.useSignificantChangesOnly,
      this.locationAuthorizationRequest,
      // ActivityRecognition
      this.isMoving,
      this.stopTimeout,
      this.activityRecognitionInterval,
      this.minimumActivityRecognitionConfidence,
      this.disableStopDetection,
      this.stopOnStationary,
      // HTTP & Persistence
      this.url,
      this.persistMode,
      this.method,
      this.httpRootProperty,
      this.params,
      this.headers,
      this.extras,
      this.autoSync,
      this.disableAutoSyncOnCellular,
      this.disableProviderChangeRecord,
      this.autoSyncThreshold,
      this.batchSync,
      this.maxBatchSize,
      this.locationTemplate,
      this.geofenceTemplate,
      this.maxDaysToPersist,
      this.maxRecordsToPersist,
      this.locationsOrderDirection,
      this.httpTimeout,

      // Application
      this.stopOnTerminate,
      this.startOnBoot,
      this.heartbeatInterval,
      this.schedule,
      this.scheduleUseAlarmManager,
      // Logging & Debug
      this.debug,
      this.logLevel,
      this.logMaxDays,
      this.reset,

      ////
      // iOS Options
      //

      // Geolocation Options
      this.pausesLocationUpdatesAutomatically,
      this.locationAuthorizationAlert,
      this.disableLocationAuthorizationAlert,
      this.showsBackgroundLocationIndicator,
      // Activity Recognition Options
      this.activityType,
      this.stopDetectionDelay,
      this.disableMotionActivityUpdates,
      // Application Options
      this.preventSuspend,

      ////
      // Android Options
      //

      // Geolocation Options
      this.locationUpdateInterval,
      this.fastestLocationUpdateInterval,
      this.deferTime,
      this.allowIdenticalLocations,
      this.enableTimestampMeta,
      this.speedJumpFilter,
      this.geofenceModeHighAccuracy,
      // Activity Recognition Options
      this.triggerActivities,
      this.motionTriggerDelay,
      // Application Options
      this.enableHeadless,
      this.foregroundService,
      this.notification,
      this.backgroundPermissionRationale,
      this.transistorAuthorizationToken});

  Config set(String key, dynamic value) {
    if (_map == null) {
      _map = new Map<String, dynamic>();
    }
    _map![key] = value;
    return this;
  }

  /// Returns only the compound config groups as a Map suitable for marshalling.
  Map<String, dynamic> compoundToMap() {
    return <String, dynamic>{
      if (geolocation != null) 'geolocation': geolocation!.toMap(),
      if (app != null) 'app': app!.toMap(),
      if (http != null) 'http': http!.toMap(),
      if (activity != null) 'activity': activity!.toMap(),
      if (persistence != null) 'persistence': persistence!.toMap(),
      if (logger != null) 'logger': logger!.toMap(),
    };
  }

  Map? toMap() {
    if (_map != null) {
      return _map;
    }

    Map config = {};

    // 1) Add compound groups first.
    final _compound = compoundToMap();
    if (_compound.isNotEmpty) {
      config.addAll(_compound);

      // Flat mirrors for legacy consumers.
      final app = _compound['app'] as Map<String, dynamic>?;
      if (app != null) {
        final notif = app['notification'];
        if (notif != null) config['notification'] = notif;

        final rationale = app['backgroundPermissionRationale'];
        if (rationale != null) {
          config['backgroundPermissionRationale'] = rationale;
        }
      }
    }

    // Were we provided a Transistor token?  Auto-config the url and authorization.
    if (transistorAuthorizationToken != null) {
      if (http != null) {
        http!.url = transistorAuthorizationToken!.locationsUrl;
      } else {
        url = transistorAuthorizationToken!.locationsUrl;
      }
      authorization = transistorAuthorizationToken!.authorizationConfig;
    }

    // Geolocation Options
    if (desiredAccuracy != null) config['desiredAccuracy'] = desiredAccuracy;
    if (distanceFilter != null) config['distanceFilter'] = distanceFilter;
    if (stationaryRadius != null) config['stationaryRadius'] = stationaryRadius;
    if (locationTimeout != null) config['locationTimeout'] = locationTimeout;
    if (disableElasticity != null) {
      config['disableElasticity'] = disableElasticity;
    }
    if (elasticityMultiplier != null) {
      config['elasticityMultiplier'] = elasticityMultiplier;
    }
    if (stopAfterElapsedMinutes != null) {
      config['stopAfterElapsedMinutes'] = stopAfterElapsedMinutes;
    }
    if (geofenceProximityRadius != null) {
      config['geofenceProximityRadius'] = geofenceProximityRadius;
    }
    if (maxMonitoredGeofences != null) {
      config['maxMonitoredGeofences'] = maxMonitoredGeofences;
    }
    if (geofenceInitialTriggerEntry != null) {
      config['geofenceInitialTriggerEntry'] = geofenceInitialTriggerEntry;
    }
    if (desiredOdometerAccuracy != null) {
      config['desiredOdometerAccuracy'] = desiredOdometerAccuracy;
    }
    if (useSignificantChangesOnly != null) {
      config['useSignificantChangesOnly'] = useSignificantChangesOnly;
    }
    // ActivityRecognition
    if (isMoving != null) {
      config['isMoving'] = isMoving;
    }
    if (stopTimeout != null) {
      config['stopTimeout'] = stopTimeout;
    }
    if (activityRecognitionInterval != null) {
      config['activityRecognitionInterval'] = activityRecognitionInterval;
    }
    if (minimumActivityRecognitionConfidence != null) {
      config['minimumActivityRecognitionConfidence'] =
          minimumActivityRecognitionConfidence;
    }
    if (disableStopDetection != null) {
      config['disableStopDetection'] = disableStopDetection;
    }
    if (stopOnStationary != null) {
      config['stopOnStationary'] = stopOnStationary;
    }
    // HTTP & Persistence
    if (url != null) {
      config['url'] = url;
    }
    if (persistMode != null) {
      config['persistMode'] = persistMode;
    }
    if (method != null) {
      config['method'] = method;
    }
    if (httpRootProperty != null) {
      config['httpRootProperty'] = httpRootProperty;
    }
    if (params != null) {
      config['params'] = params;
    }
    if (headers != null) {
      config['headers'] = headers;
    }
    if (extras != null) {
      config['extras'] = extras;
    }
    if (autoSync != null) {
      config['autoSync'] = autoSync;
    }
    if (disableAutoSyncOnCellular != null) {
      config['disableAutoSyncOnCellular'] = disableAutoSyncOnCellular;
    }
    if (disableProviderChangeRecord != null) {
      config['disableProviderChangeRecord'] = disableProviderChangeRecord;
    }
    if (autoSyncThreshold != null) {
      config['autoSyncThreshold'] = autoSyncThreshold;
    }
    if (batchSync != null) {
      config['batchSync'] = batchSync;
    }
    if (maxBatchSize != null) {
      config['maxBatchSize'] = maxBatchSize;
    }
    if (locationTemplate != null) {
      config['locationTemplate'] = locationTemplate;
    }
    if (geofenceTemplate != null) {
      config['geofenceTemplate'] = geofenceTemplate;
    }
    if (maxDaysToPersist != null) {
      config['maxDaysToPersist'] = maxDaysToPersist;
    }
    if (maxRecordsToPersist != null) {
      config['maxRecordsToPersist'] = maxRecordsToPersist;
    }
    if (locationsOrderDirection != null) {
      config['locationsOrderDirection'] = locationsOrderDirection;
    }
    if (httpTimeout != null) {
      config['httpTimeout'] = httpTimeout;
    }
    if (authorization != null) {
      config['authorization'] = authorization!.toMap();
    }
    // Application
    if (stopOnTerminate != null) {
      config['stopOnTerminate'] = stopOnTerminate;
    }
    if (startOnBoot != null) {
      config['startOnBoot'] = startOnBoot;
    }
    if (heartbeatInterval != null) {
      config['heartbeatInterval'] = heartbeatInterval;
    }
    if (schedule != null) {
      config['schedule'] = schedule;
    }
    if (scheduleUseAlarmManager != null) {
      config['scheduleUseAlarmManager'] = scheduleUseAlarmManager;
    }
    // Logging & Debug
    if (debug != null) {
      config['debug'] = debug;
    }
    if (logLevel != null) {
      config['logLevel'] = logLevel;
    }
    if (logMaxDays != null) {
      config['logMaxDays'] = logMaxDays;
    }
    if (reset != null) {
      config['reset'] = reset;
    }
    ////
    // iOS Options
    //

    // Geolocation Options
    if (pausesLocationUpdatesAutomatically != null) {
      config['pausesLocationUpdatesAutomatically'] =
          pausesLocationUpdatesAutomatically;
    }
    if (locationAuthorizationRequest != null) {
      config['locationAuthorizationRequest'] = locationAuthorizationRequest;
    }
    if (locationAuthorizationAlert != null) {
      config['locationAuthorizationAlert'] = locationAuthorizationAlert;
    }
    if (disableLocationAuthorizationAlert != null) {
      config['disableLocationAuthorizationAlert'] =
          disableLocationAuthorizationAlert;
    }
    if (showsBackgroundLocationIndicator != null) {
      config['showsBackgroundLocationIndicator'] =
          showsBackgroundLocationIndicator;
    }
    // Activity Recognition Options
    if (activityType != null) {
      config['activityType'] = activityType;
    }
    if (stopDetectionDelay != null) {
      config['stopDetectionDelay'] = stopDetectionDelay;
    }
    if (disableMotionActivityUpdates != null) {
      config['disableMotionActivityUpdates'] = disableMotionActivityUpdates;
    }
    // Application Options
    if (preventSuspend != null) {
      config['preventSuspend'] = preventSuspend;
    }
    ////
    // Android Options
    //

    // Geolocation Options
    if (locationUpdateInterval != null) {
      config['locationUpdateInterval'] = locationUpdateInterval;
    }
    if (fastestLocationUpdateInterval != null) {
      config['fastestLocationUpdateInterval'] = fastestLocationUpdateInterval;
    }
    if (deferTime != null) {
      config['deferTime'] = deferTime;
    }
    if (allowIdenticalLocations != null) {
      config['allowIdenticalLocations'] = allowIdenticalLocations;
    }
    if (enableTimestampMeta != null) {
      config['enableTimestampMeta'] = enableTimestampMeta;
    }
    if (speedJumpFilter != null) {
      config['speedJumpFilter'] = speedJumpFilter;
    }
    // Activity Recognition Options
    if (triggerActivities != null) {
      config['triggerActivities'] = triggerActivities;
    }
    if (motionTriggerDelay != null) {
      config['motionTriggerDelay'] = motionTriggerDelay;
    }
    if (geofenceModeHighAccuracy != null) {
      config['geofenceModeHighAccuracy'] = geofenceModeHighAccuracy;
    }
    // Application Options
    if (enableHeadless != null) {
      config['enableHeadless'] = enableHeadless;
    }

    if (backgroundPermissionRationale != null) {
      config['backgroundPermissionRationale'] =
          backgroundPermissionRationale!.toMap();
    }
    if (notification != null) {
      config['notification'] = notification!.toMap();
    }
    return config;
  }

  /// __@deprecated__: Use [transistorAuthorizationToken]
  ///
  static Future<Map<String, dynamic>> get deviceParams async {
    DeviceInfo deviceInfo = await DeviceInfo.getInstance();
    Map map = deviceInfo.toMap();
    RegExp re = new RegExp(r"[\s\.,]");
    String uuid =
        '${deviceInfo.model}-${deviceInfo.version}'.replaceAll(re, '-');
    map['uuid'] = uuid;
    map['framework'] = 'flutter';
    return map as FutureOr<Map<String, dynamic>>;
  }
}
