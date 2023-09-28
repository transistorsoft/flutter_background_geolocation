part of flt_background_geolocation;

/// Expresses the current state of the plugin, including all [Config] options.
///
class State extends Config {
  late Map map;

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
      : super(
            // Common Options
            desiredAccuracy: _ensureInt(data['desiredAccuracy']),
            distanceFilter: _ensureDouble(data['distanceFilter']),
            stationaryRadius: _ensureDouble(data['stationaryRadius']),
            locationTimeout: _ensureInt(data['locationTimeout']),
            disableElasticity: _ensureBool(data['disableElasticity']),
            elasticityMultiplier: _ensureDouble(data['elasticityMultiplier']),
            stopAfterElapsedMinutes:
                _ensureInt(data['stopAfterElapsedMinutes']),
            geofenceProximityRadius:
                _ensureInt(data['geofenceProximityRadius']),
            maxMonitoredGeofences: _ensureInt(data['maxMonitoredGeofences']),
            geofenceInitialTriggerEntry:
                _ensureBool(data['geofenceInitialTriggerEntry']),
            desiredOdometerAccuracy:
                _ensureDouble(data['desiredOdometerAccuracy']),
            useSignificantChangesOnly:
                _ensureBool(data['useSignificantChangesOnly']),
            disableLocationAuthorizationAlert:
                _ensureBool(data['disableLocationAuthorizationAlert']),
            showsBackgroundLocationIndicator:
                _ensureBool(data['showsBackgroundLocationIndicator']),
            enableTimestampMeta: _ensureBool(data['enableTimestampMeta']),
            // Android Options
            geofenceModeHighAccuracy: data['geofenceModeHighAccuracy'],
            // ActivityRecognition
            isMoving: _ensureBool(data['isMoving']),
            stopTimeout: _ensureInt(data['stopTimeout']),
            activityRecognitionInterval:
                _ensureInt(data['activityRecognitionInterval']),
            minimumActivityRecognitionConfidence:
                data['minimumActivityRecognitionConfidence'],
            disableStopDetection: _ensureBool(data['disableStopDetection']),
            stopOnStationary: _ensureBool(data['stopOnStationary']),
            // HTTP & Persistence
            url: data['url'],
            persistMode: data['persistMode'],
            method: data['method'],
            httpRootProperty: data['httpRootProperty'],
            params: data['params'].cast<String, dynamic>(),
            headers: data['headers'].cast<String, dynamic>(),
            extras: data['extras'].cast<String, dynamic>(),
            autoSync: _ensureBool(data['autoSync']),
            autoSyncThreshold: data['autoSyncThreshold'],
            disableAutoSyncOnCellular:
                _ensureBool(data['disableAutoSyncOnCellular']),
            disableProviderChangeRecord:
                _ensureBool(data['disableProviderChangeRecord']),
            batchSync: _ensureBool(data['batchSync']),
            maxBatchSize: data['maxBatchSize'],
            locationTemplate: data['locationTemplate'],
            geofenceTemplate: data['geofenceTemplate'],
            maxDaysToPersist: data['maxDaysToPersist'],
            maxRecordsToPersist: data['maxRecordsToPersist'],
            locationsOrderDirection: data['locationsOrderDirection'],
            httpTimeout: data['httpTimeout'],
            authorization: (data['authorization'] != null)
                ? Authorization.fromMap(data['authorization'])
                : null,
            // Application
            stopOnTerminate: _ensureBool(data['stopOnTerminate']),
            startOnBoot: _ensureBool(data['startOnBoot']),
            heartbeatInterval: _ensureInt(data['heartbeatInterval']),
            schedule: data['schedule'].cast<String>(),
            // Logging & Debug
            debug: _ensureBool(data['debug']),
            logLevel: data['logLevel'],
            logMaxDays: data['logMaxDays'],
            ////
            // iOS Options
            //

            // Geolocation Options
            pausesLocationUpdatesAutomatically:
                _ensureBool(data['pausesLocationUpdatesAutomatically']),
            locationAuthorizationRequest: data['locationAuthorizationRequest'],
            locationAuthorizationAlert:
                (data['locationAuthorizationAlert'] != null)
                    ? data['locationAuthorizationAlert'].cast<String, dynamic>()
                    : null,
            // Activity Recognition Options
            activityType: data['activityType'],
            stopDetectionDelay: _ensureInt(data['stopDetectionDelay']),
            disableMotionActivityUpdates:
                _ensureBool(data['disableMotionActivityUpdates']),
            // Application Options
            preventSuspend: _ensureBool(data['preventSuspend']),
            ////
            // Android Options
            //

            // Geolocation Options
            locationUpdateInterval: data['locationUpdateInterval'],
            fastestLocationUpdateInterval:
                data['fastestLocationUpdateInterval'],
            deferTime: data['deferTime'],
            allowIdenticalLocations: data['allowIdenticalLocations'],
            speedJumpFilter: data['speedJumpFilter'],
            // Activity Recognition Options
            triggerActivities: data['triggerActivities'],
            motionTriggerDelay: data['motionTriggerDelay'],
            // Application Options
            enableHeadless: data['enableHeadless'],
            foregroundService: data['foregroundService'],
            forceReloadOnLocationChange: data['forceReloadOnLocationChange'],
            forceReloadOnMotionChange: data['forceReloadOnMotionChange'],
            forceReloadOnGeofence: data['forceReloadOnGeofence'],
            forceReloadOnBoot: data['forceReloadOnBoot'],
            forceReloadOnHeartbeat: data['forceReloadOnHeartbeat'],
            forceReloadOnSchedule: data['forceReloadOnSchedule'],
            scheduleUseAlarmManager: (data['scheduleUseAlarmManager'] != null)
                ? data['scheduleUseAlarmManager']
                : false,
            backgroundPermissionRationale:
                (data['backgroundPermissionRationale'] != null)
                    ? PermissionRationale.fromMap(
                        data['backgroundPermissionRationale'])
                    : null,
            notification: (data['notification'] != null)
                ? Notification.fromMap(data['notification'])
                : null) {
    enabled = _ensureBool(data['enabled'])!;
    isFirstBoot = _ensureBool(data['isFirstBoot'])!;
    trackingMode = data['trackingMode'];
    schedulerEnabled = _ensureBool(data['schedulerEnabled'])!;
    odometer = _ensureDouble(data['odometer'])!;
    didLaunchInBackground = (data['didLaunchInBackground'] != null)
        ? _ensureBool(data['didLaunchInBackground'])!
        : false;
    didDeviceReboot = (data['didDeviceReboot'] != null)
        ? _ensureBool(data['didDeviceReboot'])!
        : false;
    map = data;
  }

  /// Return String representation of `State` for `print` to log.
  String toString() {
    return '[State enabled: $enabled, isMoving: $isMoving, trackingMode: $trackingMode, desiredAccuracy: $desiredAccuracy, distanceFilter: $distanceFilter, odometer: $odometer, schedulerEnabled: $schedulerEnabled, foregroundService: $foregroundService]';
  }
}
