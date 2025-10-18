part of '../flutter_background_geolocation.dart';

// Flattens compound TSConfig state (eg: application.notification) into legacy flat keys
// so existing Flutter models remain backward compatible.
Map _flattenCompoundState(Map input) {
  if (input.isEmpty) return input;
  // Start with a shallow copy to avoid mutating the caller's map.
  final Map out = Map.of(input);
  // Helper to merge a nested group onto the flat map.
  void mergeGroup(String groupKey) {
    final dynamic g = input[groupKey];
    if (g is Map) {
      g.forEach((k, v) {
        // Only copy if the flat key is missing to let explicit flat values win.
        if (!out.containsKey(k)) out[k] = v;
      });
    }
  }
  // Common TSConfig2 compound groups we want to alias into flat.
  // This keeps legacy Flutter fields working while SDK emits compound form.
  for (final group in const ['app', 'geolocation', 'http', 'activity', 'persistence', 'logger']) {
    mergeGroup(group);
  }
  // Special-case: application.notification → notification
  final dynamic app = input['app'];
  if (app is Map) {
    final dynamic notif = app['notification'];
    if (notif != null && !out.containsKey('notification')) {
      out['notification'] = notif;
    }
    final dynamic rationale = app['backgroundPermissionRationale'];
    if (rationale != null && !out.containsKey('backgroundPermissionRationale')) {
      out['backgroundPermissionRationale'] = rationale;
    }
  }
  return out;
}

/// Expresses the current state of the plugin, including all [Config] options.
/// Compound groups ([app], [geolocation], [http], [activity], [persistence], [logger])
/// are guaranteed non-null on [State] via default empty instances, so you can access them without `?`.
///
class State extends Config {
  late final Map map;

  // Non-null compound config accessors: State guarantees these groups exist.
  @override
  AppConfig get app => super.app ?? const AppConfig();

  @override
  GeoConfig get geolocation => super.geolocation ?? const GeoConfig();

  @override
  HttpConfig get http => super.http ?? HttpConfig();

  @override
  ActivityConfig get activity => super.activity ?? const ActivityConfig();

  @override
  PersistenceConfig get persistence => super.persistence ?? const PersistenceConfig();

  @override
  LoggerConfig get logger => super.logger ?? const LoggerConfig();

  /// Whether the plugin is current stopped or started ([BackgroundGeolocation.stop] / [BackgroundGeolocation.start]).
  ///
  late bool enabled;

  /// Whether the plugin's [Config.schedule] has been activated with [BackgroundGeolocation.startSchedule].
  ///
  late bool schedulerEnabled;

  /// Current distance traveled.
  ///
  /// __See also:__
  /// - [BackgroundGeolocation.setOdometer].
  /// - [BackgroundGeolocation.odometer].
  ///
  late double odometer;

  /// Whether the plugin is in the location-tracking mode ([BackgroundGeolocation.start] or geofences-only mode ([BackgroundGeolocation.startGeofences]).
  /// - `1` = Location + Geofence tracking (ie: [BackgroundGeolocation.start]).
  /// - `0` = Geofences-only tracking (ie: [BackgroundGeolocation.startGeofences]).
  ///
  late int trackingMode;

  /// Indicates whether the iOS app was launched in the background.
  ///
  late bool didLaunchInBackground;

  /// Indicates if this is the first launch of the app after initial install
  ///
  late bool isFirstBoot;

  /// Indicates if the app was launched after the device was rebooted.
  ///
  late bool didDeviceReboot;

  State(Map data)
      :
        // flatten compound state for backward compatibility
        super(
            geolocation: (data['geolocation'] is Map)
                ? GeoConfig.fromMap((data['geolocation'] as Map).cast<String, dynamic>())
                : null,
            app: (data['app'] is Map)
                ? AppConfig.fromMap((data['app'] as Map).cast<String, dynamic>())
                : null,
            http: (data['http'] is Map)
                ? HttpConfig.fromMap((data['http'] as Map).cast<String, dynamic>())
                : null,
            activity: (data['activity'] is Map)
                ? ActivityConfig.fromMap((data['activity'] as Map).cast<String, dynamic>())
                : null,
            persistence: (data['persistence'] is Map)
                ? PersistenceConfig.fromMap((data['persistence'] as Map).cast<String, dynamic>())
                : null,
            logger: (data['logger'] is Map)
                ? LoggerConfig.fromMap((data['logger'] as Map).cast<String, dynamic>())
                : null,
            desiredAccuracy: _ensureInt((_flattenCompoundState(data))['desiredAccuracy']),
            distanceFilter: _ensureDouble((_flattenCompoundState(data))['distanceFilter']),
            stationaryRadius: _ensureDouble((_flattenCompoundState(data))['stationaryRadius']),
            locationTimeout: _ensureInt((_flattenCompoundState(data))['locationTimeout']),
            disableElasticity: _ensureBool((_flattenCompoundState(data))['disableElasticity']),
            elasticityMultiplier: _ensureDouble((_flattenCompoundState(data))['elasticityMultiplier']),
            stopAfterElapsedMinutes:
                _ensureInt((_flattenCompoundState(data))['stopAfterElapsedMinutes']),
            geofenceProximityRadius:
                _ensureInt((_flattenCompoundState(data))['geofenceProximityRadius']),
            maxMonitoredGeofences: _ensureInt((_flattenCompoundState(data))['maxMonitoredGeofences']),
            geofenceInitialTriggerEntry:
                _ensureBool((_flattenCompoundState(data))['geofenceInitialTriggerEntry']),
            desiredOdometerAccuracy:
                _ensureDouble((_flattenCompoundState(data))['desiredOdometerAccuracy']),
            useSignificantChangesOnly:
                _ensureBool((_flattenCompoundState(data))['useSignificantChangesOnly']),
            disableLocationAuthorizationAlert:
                _ensureBool((_flattenCompoundState(data))['disableLocationAuthorizationAlert']),
            showsBackgroundLocationIndicator:
                _ensureBool((_flattenCompoundState(data))['showsBackgroundLocationIndicator']),
            enableTimestampMeta: _ensureBool((_flattenCompoundState(data))['enableTimestampMeta']),
            // Android Options
            geofenceModeHighAccuracy: (_flattenCompoundState(data))['geofenceModeHighAccuracy'],
            // ActivityRecognition
            isMoving: _ensureBool((_flattenCompoundState(data))['isMoving']),
            stopTimeout: _ensureInt((_flattenCompoundState(data))['stopTimeout']),
            activityRecognitionInterval:
                _ensureInt((_flattenCompoundState(data))['activityRecognitionInterval']),
            minimumActivityRecognitionConfidence:
                (_flattenCompoundState(data))['minimumActivityRecognitionConfidence'],
            disableStopDetection: _ensureBool((_flattenCompoundState(data))['disableStopDetection']),
            stopOnStationary: _ensureBool((_flattenCompoundState(data))['stopOnStationary']),
            // HTTP & Persistence
            url: (_flattenCompoundState(data))['url'],
            persistMode: (_flattenCompoundState(data))['persistMode'],
            method: (_flattenCompoundState(data))['method'],
            httpRootProperty: (_flattenCompoundState(data))['httpRootProperty'],
            params: (_flattenCompoundState(data))['params'].cast<String, dynamic>(),
            headers: (_flattenCompoundState(data))['headers'].cast<String, dynamic>(),
            extras: (_flattenCompoundState(data))['extras'].cast<String, dynamic>(),
            autoSync: _ensureBool((_flattenCompoundState(data))['autoSync']),
            autoSyncThreshold: (_flattenCompoundState(data))['autoSyncThreshold'],
            disableAutoSyncOnCellular:
                _ensureBool((_flattenCompoundState(data))['disableAutoSyncOnCellular']),
            disableProviderChangeRecord:
                _ensureBool((_flattenCompoundState(data))['disableProviderChangeRecord']),
            batchSync: _ensureBool((_flattenCompoundState(data))['batchSync']),
            maxBatchSize: (_flattenCompoundState(data))['maxBatchSize'],
            locationTemplate: (_flattenCompoundState(data))['locationTemplate'],
            geofenceTemplate: (_flattenCompoundState(data))['geofenceTemplate'],
            maxDaysToPersist: (_flattenCompoundState(data))['maxDaysToPersist'],
            maxRecordsToPersist: (_flattenCompoundState(data))['maxRecordsToPersist'],
            locationsOrderDirection: (_flattenCompoundState(data))['locationsOrderDirection'],
            httpTimeout: (_flattenCompoundState(data))['httpTimeout'],
            authorization: ((_flattenCompoundState(data))['authorization'] != null)
                ? Authorization.fromMap((_flattenCompoundState(data))['authorization'])
                : null,
            // Application
            stopOnTerminate: _ensureBool((_flattenCompoundState(data))['stopOnTerminate']),
            startOnBoot: _ensureBool((_flattenCompoundState(data))['startOnBoot']),
            heartbeatInterval: _ensureInt((_flattenCompoundState(data))['heartbeatInterval']),
            schedule: (_flattenCompoundState(data))['schedule'].cast<String>(),
            // Logging & Debug
            debug: _ensureBool((_flattenCompoundState(data))['debug']),
            logLevel: (_flattenCompoundState(data))['logLevel'],
            logMaxDays: (_flattenCompoundState(data))['logMaxDays'],
            ////
            // iOS Options
            //

            // Geolocation Options
            pausesLocationUpdatesAutomatically:
                _ensureBool((_flattenCompoundState(data))['pausesLocationUpdatesAutomatically']),
            locationAuthorizationRequest: (_flattenCompoundState(data))['locationAuthorizationRequest'],
            locationAuthorizationAlert:
                ((_flattenCompoundState(data))['locationAuthorizationAlert'] != null)
                    ? (_flattenCompoundState(data))['locationAuthorizationAlert'].cast<String, dynamic>()
                    : null,
            // Activity Recognition Options
            activityType: (_flattenCompoundState(data))['activityType'],
            stopDetectionDelay: _ensureInt((_flattenCompoundState(data))['stopDetectionDelay']),
            disableMotionActivityUpdates:
                _ensureBool((_flattenCompoundState(data))['disableMotionActivityUpdates']),
            // Application Options
            preventSuspend: _ensureBool((_flattenCompoundState(data))['preventSuspend']),
            ////
            // Android Options
            //

            // Geolocation Options
            locationUpdateInterval: (_flattenCompoundState(data))['locationUpdateInterval'],
            fastestLocationUpdateInterval:
                (_flattenCompoundState(data))['fastestLocationUpdateInterval'],
            deferTime: (_flattenCompoundState(data))['deferTime'],
            allowIdenticalLocations: (_flattenCompoundState(data))['allowIdenticalLocations'],
            speedJumpFilter: (_flattenCompoundState(data))['speedJumpFilter'],
            // Activity Recognition Options
            triggerActivities: (_flattenCompoundState(data))['triggerActivities'],
            motionTriggerDelay: (_flattenCompoundState(data))['motionTriggerDelay'],
            // Application Options
            enableHeadless: (_flattenCompoundState(data))['enableHeadless'],
            scheduleUseAlarmManager: ((_flattenCompoundState(data))['scheduleUseAlarmManager'] != null)
                ? (_flattenCompoundState(data))['scheduleUseAlarmManager']
                : false,
            backgroundPermissionRationale:
                ((_flattenCompoundState(data))['backgroundPermissionRationale'] != null)
                    ? PermissionRationale.fromMap(
                        (_flattenCompoundState(data))['backgroundPermissionRationale'])
                    : null,
            notification: ((_flattenCompoundState(data))['notification'] != null)
                ? Notification.fromMap((_flattenCompoundState(data))['notification'])
                : null
        )
  {
    final Map flat = _flattenCompoundState(data);
    enabled = _ensureBool(flat['enabled'])!;
    isFirstBoot = _ensureBool(flat['isFirstBoot'])!;
    trackingMode = flat['trackingMode'];
    schedulerEnabled = _ensureBool(flat['schedulerEnabled'])!;
    odometer = _ensureDouble(flat['odometer'])!;
    didLaunchInBackground = (flat['didLaunchInBackground'] != null)
        ? _ensureBool(flat['didLaunchInBackground'])!
        : false;
    didDeviceReboot = (flat['didDeviceReboot'] != null)
        ? _ensureBool(flat['didDeviceReboot'])!
        : false;
    map = flat;
  }

  /// Return String representation of `State` for `print` to log.
  String toString() {
    return '[State enabled: $enabled, isMoving: $isMoving, trackingMode: $trackingMode, desiredAccuracy: $desiredAccuracy, distanceFilter: $distanceFilter, odometer: $odometer, schedulerEnabled: $schedulerEnabled, foregroundService: $foregroundService]';
  }
}
