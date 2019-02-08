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
  ///
  int trackingMode;

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
            disableElasticity: data['disableElasticity'],
            elasticityMultiplier: (data['elasticityMultiplier'].runtimeType == int)
                ? data['elasticityMultiplier'] * 1.0
                : data['elasticityMultiplier'],
            stopAfterElapsedMinutes: (data['stopAfterElapsedMinutes'].runtimeType == double)
                ? data['stopAfterElapsedMinutes'].round()
                : data['stopAfterElapsedMinutes'],
            geofenceProximityRadius: (data['geofenceProximityRadius'].runtimeType == double)
                ? data['geofenceProximityRadius'].round()
                : data['geofenceProximityRadius'],
            geofenceInitialTriggerEntry: data['geofenceInitialTriggerEntry'],
            desiredOdometerAccuracy: (data['desiredOdometerAccuracy'].runtimeType == int)
                ? data['desiredOdometerAccuracy'] * 1.0
                : data['desiredOdometerAccuracy'],
            // ActivityRecognition
            isMoving: data['isMoving'],
            stopTimeout: (data['stopTimeout'].runtimeType == double)
                ? data['stopTimeout'].round()
                : data['stopTimeout'],
            activityRecognitionInterval: (data['activityRecognitionInterval'].runtimeType == double)
                ? data['activityRecognitionInterval'].round()
                : data['activityRecognitionInterval'],
            minimumActivityRecognitionConfidence:
                data['minimumActivityRecognitionConfidence'],
            disableStopDetection: data['disableStopDetection'],
            stopOnStationary: data['stopOnStationary'],
            // HTTP & Persistence
            url: data['url'],
            method: data['method'],
            httpRootProperty: data['httpRootProperty'],
            params: data['params'].cast<String, dynamic>(),
            headers: data['headers'].cast<String, dynamic>(),
            extras: data['extras'].cast<String, dynamic>(),
            autoSync: data['autoSync'],
            autoSyncThreshold: data['autoSyncThreshold'],
            batchSync: data['batchSync'],
            maxBatchSize: data['maxBatchSize'],
            locationTemplate: data['locationTemplate'],
            geofenceTemplate: data['geofenceTemplate'],
            maxDaysToPersist: data['maxDaysToPersist'],
            maxRecordsToPersist: data['maxRecordsToPersist'],
            locationsOrderDirection: data['locationsOrderDirection'],
            httpTimeout: data['httpTimeout'],
            // Application
            stopOnTerminate: data['stopOnTerminate'],
            startOnBoot: data['startOnBoot'],
            heartbeatInterval: (data['heartbeatInterval'].runtimeType == double)
                ? data['heartbeatInterval'].round()
                : data['heartbeatInterval'],
            schedule: data['schedule'].cast<String>(),
            // Logging & Debug
            debug: data['debug'],
            logLevel: data['logLevel'],
            logMaxDays: data['logMaxDays'],

            ////
            // iOS Options
            //

            // Geolocation Options
            useSignificantChangesOnly: data['useSignificantChangesOnly'],
            pausesLocationUpdatesAutomatically:
                data['pausesLocationUpdatesAutomatically'],
            locationAuthorizationRequest: data['locationAuthorizationRequest'],
            locationAuthorizationAlert: (data['locationAuthorizationAlert'] != null)
                ? data['locationAuthorizationAlert'].cast<String, dynamic>()
                : null,
            disableLocationAuthorizationAlert:
                data['disableLocationAuthorizationAlert'],
            // Activity Recognition Options
            activityType: data['activityType'],
            stopDetectionDelay: (data['stopDetectionDelay'].runtimeType == double)
                ? data['stopDetectionDelay'].round()
                : data['stopDetectionDelay'],
            disableMotionActivityUpdates: data['disableMotionActivityUpdates'],
            // Application Options
            preventSuspend: data['preventSuspend'],

            ////
            // Android Options
            //

            // Geolocation Options
            locationUpdateInterval: data['locationUpdateInterval'],
            fastestLocationUpdateInterval: data['fastestLocationUpdateInterval'],
            deferTime: data['deferTime'],
            allowIdenticalLocations: data['allowIdenticalLocations'],
            enableTimestampMeta: data['enableTimestampMeta'],
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
            notificationPriority: data['notificationPriority'],
            notificationTitle: data['notificationTitle'],
            notificationText: data['notificationText'],
            notificationColor: data['notificationColor'],
            notificationSmallIcon: data['notificationSmallIcon'],
            notificationLargeIcon: data['notificationLargeIcon'],
            notificationChannelName: data['notificationChannelName']) {
    enabled = data['enabled'];
    trackingMode = data['trackingMode'];
    schedulerEnabled = data['schedulerEnabled'];
    odometer = (data['odometer'].runtimeType == int)
        ? (data['odometer'] * 1.0)
        : data['odometer'];
    map = data;
  }

  String toString() {
    return '[State enabled: $enabled, isMoving: $isMoving, trackingMode: $trackingMode, desiredAccuracy: $desiredAccuracy, distanceFilter: $distanceFilter, odometer: $odometer, schedulerEnabled: $schedulerEnabled, foregroundService: $foregroundService]';
  }
}
