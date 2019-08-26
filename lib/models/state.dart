part of flt_background_geolocation;

/// Expresses the current state of the plugin, including all [Config] options.
///
class State extends Config {
  Map map;

  /// Whether the plugin is current stopped or started ([BackgroundGeolocation.stop] / [BackgroundGeolocation.start]).
  ///
  bool enabled;

  /// Whether the plugin's [Config.schedule] has been activated with [BackgroundGeolocation.startSchedule].
  ///
  bool schedulerEnabled;

  /// Current distance traveled.
  ///
  /// __See also:__
  /// - [BackgroundGeolocation.setOdometer].
  /// - [BackgroundGeolocation.odometer].
  ///
  double odometer;

  /// Whether the plugin is in the location-tracking mode ([BackgroundGeolocation.start] or geofences-only mode ([BackgroundGeolocation.startGeofences]).
  /// - `1` = Location + Geofence tracking (ie: [BackgroundGeolocation.start]).
  /// - `0` = Geofences-only tracking (ie: [BackgroundGeolocation.startGeofences]).
  ///
  int trackingMode;

  /// Indicates whether the iOS app was launched in the background.
  ///
  bool didLaunchInBackground;

  State(dynamic data)
      : super(
            // Common Options
            desiredAccuracy: (data['desiredAccuracy'].runtimeType == double)
                ? data['desiredAccuracy'].round()
                : data['desiredAccuracy'],
            distanceFilter: (data['distanceFilter'].runtimeType == int)
                ? data['distanceFilter'] * 1.0
                : data['distanceFilter'],
            stationaryRadius: (data['stationaryRadius'].runtimeType == int)
                ? data['stationaryRadius'] * 1.0
                : data['stationaryRadius'],
            locationTimeout: (data['locationTimeout'].runtimeType == double)
                ? data['locationTimeout'].round()
                : data['locationTimeout'],
            disableElasticity: (data['disableElasticity'].runtimeType == int)
                ? (data['disableElasticity'] != 0)
                : data['disableElasticity'],
            elasticityMultiplier: (data['elasticityMultiplier'].runtimeType == int)
                ? data['elasticityMultiplier'] * 1.0
                : data['elasticityMultiplier'],
            stopAfterElapsedMinutes: (data['stopAfterElapsedMinutes'].runtimeType == double)
                ? data['stopAfterElapsedMinutes'].round()
                : data['stopAfterElapsedMinutes'],
            geofenceProximityRadius: (data['geofenceProximityRadius'].runtimeType == double)
                ? data['geofenceProximityRadius'].round()
                : data['geofenceProximityRadius'],
            geofenceInitialTriggerEntry: (data['geofenceInitialTriggerEntry'].runtimeType == int)
                ? (data['geofenceInitialTriggerEntry'] != 0)
                : data['geofenceInitialTriggerEntry'],
            desiredOdometerAccuracy: (data['desiredOdometerAccuracy'].runtimeType == int)
                ? data['desiredOdometerAccuracy'] * 1.0
                : data['desiredOdometerAccuracy'],
            useSignificantChangesOnly: (data['useSignificantChangesOnly'].runtimeType == int)
                ? (data['useSignificantChangesOnly'] != 0)
                : data['useSignificantChangesOnly'],
            disableLocationAuthorizationAlert: (data['disableLocationAuthorizationAlert'].runtimeType == int)
                ? (data['disableLocationAuthorizationAlert'] != 0)
                : data['disableLocationAuthorizationAlert'],
            // Android Options
            geofenceModeHighAccuracy: data['geofenceModeHighAccuracy'],
            // ActivityRecognition
            isMoving: (data['isMoving'].runtimeType == int)
                ? (data['isMoving'] != 0)
                : data['isMoving'],
            stopTimeout: (data['stopTimeout'].runtimeType == double)
                ? data['stopTimeout'].round()
                : data['stopTimeout'],
            activityRecognitionInterval: (data['activityRecognitionInterval'].runtimeType == double)
                ? data['activityRecognitionInterval'].round()
                : data['activityRecognitionInterval'],
            minimumActivityRecognitionConfidence: data['minimumActivityRecognitionConfidence'],
            disableStopDetection: (data['disableStopDetection'].runtimeType == int) ? (data['disableStopDetection'] != 0) : data['disableStopDetection'],
            stopOnStationary: (data['stopOnStationary'].runtimeType == int) ? (data['stopOnStationary'] != 0) : data['stopOnStationary'],
            // HTTP & Persistence
            url: data['url'],
            persistMode: data['persistMode'],
            method: data['method'],
            httpRootProperty: data['httpRootProperty'],
            params: data['params'].cast<String, dynamic>(),
            headers: data['headers'].cast<String, dynamic>(),
            extras: data['extras'].cast<String, dynamic>(),
            autoSync: (data['autoSync'].runtimeType == int) ? (data['autoSync'] != 0) : data['autoSync'],
            autoSyncThreshold: data['autoSyncThreshold'],
            batchSync: (data['batchSync'].runtimeType == int) ? (data['batchSync'] != 0) : data['batchSync'],
            maxBatchSize: data['maxBatchSize'],
            locationTemplate: data['locationTemplate'],
            geofenceTemplate: data['geofenceTemplate'],
            maxDaysToPersist: data['maxDaysToPersist'],
            maxRecordsToPersist: data['maxRecordsToPersist'],
            locationsOrderDirection: data['locationsOrderDirection'],
            httpTimeout: data['httpTimeout'],
            // Application
            stopOnTerminate: (data['stopOnTerminate'].runtimeType == int) ? (data['stopOnTerminate'] != 0) : data['stopOnTerminate'],
            startOnBoot: (data['startOnBoot'].runtimeType == int) ? (data['startOnBoot'] != 0) : data['startOnBoot'],
            heartbeatInterval: (data['heartbeatInterval'].runtimeType == double) ? data['heartbeatInterval'].round() : data['heartbeatInterval'],
            schedule: data['schedule'].cast<String>(),
            // Logging & Debug
            debug: (data['debug'].runtimeType == int) ? (data['debug'] != 0) : data['debug'],
            logLevel: data['logLevel'],
            logMaxDays: data['logMaxDays'],
            ////
            // iOS Options
            //

            // Geolocation Options
            pausesLocationUpdatesAutomatically: (data['pausesLocationUpdatesAutomatically'].runtimeType == int) ? (data['pausesLocationUpdatesAutomatically'] != 0) : data['pausesLocationUpdatesAutomatically'],
            locationAuthorizationRequest: data['locationAuthorizationRequest'],
            locationAuthorizationAlert: (data['locationAuthorizationAlert'] != null) ? data['locationAuthorizationAlert'].cast<String, dynamic>() : null,
            // Activity Recognition Options
            activityType: data['activityType'],
            stopDetectionDelay: (data['stopDetectionDelay'].runtimeType == double) ? data['stopDetectionDelay'].round() : data['stopDetectionDelay'],
            disableMotionActivityUpdates: (data['disableMotionActivityUpdates'].runtimeType == int) ? (data['disableMotionActivityUpdates'] != 0) : data['disableMotionActivityUpdates'],
            // Application Options
            preventSuspend: (data['preventSuspend'].runtimeType == int) ? (data['preventSuspend'] != 0) : data['preventSuspend'],
            ////
            // Android Options
            //

            // Geolocation Options
            locationUpdateInterval: data['locationUpdateInterval'],
            fastestLocationUpdateInterval: data['fastestLocationUpdateInterval'],
            deferTime: data['deferTime'],
            allowIdenticalLocations: data['allowIdenticalLocations'],
            enableTimestampMeta: data['enableTimestampMeta'],
            speedJumpFilter: data['speedJumpFilter'],
            // Activity Recognition Options
            triggerActivities: data['triggerActivities'],
            // Application Options
            enableHeadless: data['enableHeadless'],
            foregroundService: data['foregroundService'],
            forceReloadOnLocationChange: data['forceReloadOnLocationChange'],
            forceReloadOnMotionChange: data['forceReloadOnMotionChange'],
            forceReloadOnGeofence: data['forceReloadOnGeofence'],
            forceReloadOnBoot: data['forceReloadOnBoot'],
            forceReloadOnHeartbeat: data['forceReloadOnHeartbeat'],
            forceReloadOnSchedule: data['forceReloadOnSchedule'],
            scheduleUseAlarmManager: (data['scheduleUseAlarmManager'] != null) ? data['scheduleUseAlarmManager'] : false,
            notification: (data['notification'] != null) ? Notification.fromMap(data['notification']) : null) {
    enabled = (data['enabled'].runtimeType == int)
        ? (data['enabled'] != 0)
        : data['enabled'];
    trackingMode = data['trackingMode'];
    schedulerEnabled = (data['schedulerEnabled'].runtimeType == int)
        ? (data['schedulerEnabled'] != 0)
        : data['schedulerEnabled'];
    odometer = (data['odometer'].runtimeType == int)
        ? (data['odometer'] * 1.0)
        : data['odometer'];
    didLaunchInBackground = (data['didLaunchInBackground'] != null)
        ? (data['didLaunchInBackground'].runtimeType == int)
            ? (data['didLaunchInBackground'] != 0)
            : data['didLaunchInBackground']
        : false;
    map = data;
  }

  String toString() {
    return '[State enabled: $enabled, isMoving: $isMoving, trackingMode: $trackingMode, desiredAccuracy: $desiredAccuracy, distanceFilter: $distanceFilter, odometer: $odometer, schedulerEnabled: $schedulerEnabled, foregroundService: $foregroundService]';
  }
}
