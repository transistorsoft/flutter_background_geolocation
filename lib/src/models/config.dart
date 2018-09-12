part of flt_background_geolocation;

class Config {
  static const int LOG_LEVEL_OFF     =  0;
  static const int LOG_LEVEL_ERROR   =  1;
  static const int LOG_LEVEL_WARNING =  2;
  static const int LOG_LEVEL_INFO    =  3;
  static const int LOG_LEVEL_DEBUG   =  4;
  static const int LOG_LEVEL_VERBOSE =  5;

  static const int DESIRED_ACCURACY_NAVIGATION = -2;
  static const int DESIRED_ACCURACY_HIGH       = -1;
  static const int DESIRED_ACCURACY_MEDIUM     = 10;
  static const int DESIRED_ACCURACY_LOW        = 100;
  static const int DESIRED_ACCURACY_VERY_LOW   = 1000;
  static const int DESIRED_ACCURACY_LOWEST     = 3000;

  static const int AUTHORIZATION_STATUS_NOT_DETERMINED = 0;
  static const int AUTHORIZATION_STATUS_RESTRICTED     = 1;
  static const int AUTHORIZATION_STATUS_DENIED         = 2;
  static const int AUTHORIZATION_STATUS_ALWAYS         = 3;
  static const int AUTHORIZATION_STATUS_WHEN_IN_USE    = 4;

  static const int NOTIFICATION_PRIORITY_DEFAULT       = 0;
  static const int NOTIFICATION_PRIORITY_HIGH          = 1;
  static const int NOTIFICATION_PRIORITY_LOW           =-1;
  static const int NOTIFICATION_PRIORITY_MAX           = 2;
  static const int NOTIFICATION_PRIORITY_MIN           =-2;

  // For iOS #activityType
  static const int ACTIVITY_TYPE_OTHER                 = 1;
  static const int ACTIVITY_TYPE_AUTOMOTIVE_NAVIGATION = 2;
  static const int ACTIVITY_TYPE_FITNESS               = 3;
  static const int ACTIVITY_TYPE_OTHER_NAVIGATION      = 4;

  ////
  // Common Options
  //

  // Geolocation
  int desiredAccuracy;
  double distanceFilter;
  double stationaryRadius;
  int locationTimeout;
  bool disableElasticity;
  double elasticityMultiplier;
  int stopAfterElapsedMinutes;
  int geofenceProximityRadius;
  bool geofenceInitialTriggerEntry;
  double desiredOdometerAccuracy;
  // ActivityRecognition
  bool isMoving;
  int stopTimeout;
  int activityRecognitionInterval;
  int minimumActivityRecognitionConfidence;
  bool disableStopDetection;
  bool stopOnStationary;
  // HTTP & Persistence
  String url;
  String method;
  String httpRootProperty;
  Map<String,dynamic> params;
  Map<String,dynamic> headers;
  Map<String,dynamic> extras;
  bool autoSync;
  int autoSyncThreshold;
  bool batchSync;
  int maxBatchSize;
  String locationTemplate;
  String geofenceTemplate;
  int maxDaysToPersist;
  int maxRecordsToPersist;
  String locationsOrderDirection;
  int httpTimeout;
  // Application
  bool stopOnTerminate;
  bool startOnBoot;
  int heartbeatInterval;
  List<String> schedule;
  // Logging & Debug
  bool debug;
  int logLevel;
  int logMaxDays;

  bool reset;

  ////
  // iOS Options
  //

  // Geolocation Options
  bool useSignificantChangesOnly;
  bool pausesLocationUpdatesAutomatically;
  String locationAuthorizationRequest;
  Map<String,dynamic> locationAuthorizationAlert;
  bool disableLocationAuthorizationAlert;
  // Activity Recognition Options
  int activityType;
  int stopDetectionDelay;
  bool disableMotionActivityUpdates;
  // Application Options
  bool preventSuspend;

  ////
  // Android Options
  //

  // Geolocation Options
  int locationUpdateInterval;
  int fastestLocationUpdateInterval;
  int deferTime;
  bool allowIdenticalLocations;
  bool allowTimestampMeta;
  // Activity Recognition Options
  String triggerActivities;
  // Application Options
  bool enableHeadless;
  bool foregroundService;
  bool forceReloadOnLocationChange;
  bool forceReloadOnMotionChange;
  bool forceReloadOnGeofence;
  bool forceReloadOnBoot;
  bool forceReloadOnHeartbeat;
  bool forceReloadOnSchedule;
  int notificationPriority;
  String notificationTitle;
  String notificationText;
  String notificationColor;
  String notificationSmallIcon;
  String notificationLargeIcon;
  String notificationChannelName;

  Config({
    // Geolocation Options
    this.desiredAccuracy,
    this.distanceFilter,
    this.stationaryRadius,
    this.locationTimeout,
    this.disableElasticity,
    this.elasticityMultiplier,
    this.stopAfterElapsedMinutes,
    this.geofenceProximityRadius,
    this.geofenceInitialTriggerEntry,
    this.desiredOdometerAccuracy,
    // ActivityRecognition
    this.isMoving,
    this.stopTimeout,
    this.activityRecognitionInterval,
    this.minimumActivityRecognitionConfidence,
    this.disableStopDetection,
    this.stopOnStationary,
    // HTTP & Persistence
    this.url,
    this.method,
    this.httpRootProperty,
    this.params,
    this.headers,
    this.extras,
    this.autoSync,
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
    // Logging & Debug
    this.debug,
    this.logLevel,
    this.logMaxDays,
    this.reset,

    ////
    // iOS Options
    //

    // Geolocation Options
    this.useSignificantChangesOnly,
    this.pausesLocationUpdatesAutomatically,
    this.locationAuthorizationRequest,
    this.locationAuthorizationAlert,
    this.disableLocationAuthorizationAlert,
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
    this.allowTimestampMeta,
    // Activity Recognition Options
    this.triggerActivities,
    // Application Options
    this.enableHeadless,
    this.foregroundService,
    this.forceReloadOnLocationChange,
    this.forceReloadOnMotionChange,
    this.forceReloadOnGeofence,
    this.forceReloadOnBoot,
    this.forceReloadOnHeartbeat,
    this.forceReloadOnSchedule,
    this.notificationPriority,
    this.notificationTitle,
    this.notificationText,
    this.notificationColor,
    this.notificationSmallIcon,
    this.notificationLargeIcon,
    this.notificationChannelName
  });

  Map toMap() {
    Map config = {};
    // Geolocation Options
    if(desiredAccuracy != null) config['desiredAccuracy'] = desiredAccuracy;
    if(distanceFilter != null) config['distanceFilter'] = distanceFilter;
    if(stationaryRadius != null) config['stationaryRadius'] = stationaryRadius;
    if(locationTimeout != null) config['locationTimeout'] = locationTimeout;
    if(disableElasticity != null) config['disableElasticity'] = disableElasticity;
    if(elasticityMultiplier != null) config['elasticityMultiplier'] = elasticityMultiplier;
    if(stopAfterElapsedMinutes != null) config['stopAfterElapsedMinutes'] = stopAfterElapsedMinutes;
    if(geofenceProximityRadius != null) config['geofenceProximityRadius'] = geofenceProximityRadius;
    if(geofenceInitialTriggerEntry != null) config['geofenceInitialTriggerEntry'] = geofenceInitialTriggerEntry;
    if(desiredOdometerAccuracy != null) config['desiredOdometerAccuracy'] = desiredOdometerAccuracy;
    // ActivityRecognition
    if(isMoving != null) config['isMoving'] = isMoving;
    if(stopTimeout != null) config['stopTimeout'] = stopTimeout;
    if(activityRecognitionInterval != null) config['activityRecognitionInterval'] = activityRecognitionInterval;
    if(minimumActivityRecognitionConfidence != null) config['minimumActivityRecognitionConfidence'] = minimumActivityRecognitionConfidence;
    if(disableStopDetection != null) config['disableStopDetection'] = disableStopDetection;
    if(stopOnStationary != null) config['stopOnStationary'] = stopOnStationary;
    // HTTP & Persistence
    if(url != null) config['url'] = url;
    if(method != null) config['method'] = method;
    if(httpRootProperty != null) config['httpRootProperty'] = httpRootProperty;
    if(params != null) config['params'] = params;
    if(headers != null) config['headers'] = headers;
    if(extras != null) config['extras'] = extras;
    if(autoSync != null) config['autoSync'] = autoSync;
    if(autoSyncThreshold != null) config['autoSyncThreshold'] = autoSyncThreshold;
    if(batchSync != null) config['batchSync'] = batchSync;
    if(maxBatchSize != null) config['maxBatchSize'] = maxBatchSize;
    if(locationTemplate != null) config['locationTemplate'] = locationTemplate;
    if(geofenceTemplate != null) config['geofenceTemplate'] = geofenceTemplate;
    if(maxDaysToPersist != null) config['maxDaysToPersist'] = maxDaysToPersist;
    if(maxRecordsToPersist != null) config['maxRecordsToPersist'] = maxRecordsToPersist;
    if(locationsOrderDirection != null) config['locationsOrderDirection'] = locationsOrderDirection;
    if(httpTimeout != null) config['httpTimeout'] = httpTimeout;
    // Application
    if(stopOnTerminate != null) config['stopOnTerminate'] = stopOnTerminate;
    if(startOnBoot != null) config['startOnBoot'] = startOnBoot;
    if(heartbeatInterval != null) config['heartbeatInterval'] = heartbeatInterval;
    if(schedule != null) config['schedule'] = schedule;
    // Logging & Debug
    if(debug != null) config['debug'] = debug;
    if(logLevel != null) config['logLevel'] = logLevel;
    if(logMaxDays != null) config['logMaxDays'] = logMaxDays;
    if(reset != null) config['reset'] = reset;

    ////
    // iOS Options
    //

    // Geolocation Options
    if(useSignificantChangesOnly != null) config['useSignificantChangesOnly'] = useSignificantChangesOnly;
    if(pausesLocationUpdatesAutomatically != null) config['pausesLocationUpdatesAutomatically'] = pausesLocationUpdatesAutomatically;
    if(locationAuthorizationRequest != null) config['locationAuthorizationRequest'] = locationAuthorizationRequest;
    if(locationAuthorizationAlert != null) config['locationAuthorizationAlert'] = locationAuthorizationAlert;
    if(disableLocationAuthorizationAlert != null) config['disableLocationAuthorizationAlert'] = disableLocationAuthorizationAlert;
    // Activity Recognition Options
    if(activityType != null) config['activityType'] = activityType;
    if(stopDetectionDelay != null) config['stopDetectionDelay'] = stopDetectionDelay;
    if(disableMotionActivityUpdates != null) config['disableMotionActivityUpdates'] = disableMotionActivityUpdates;
    // Application Options
    if(preventSuspend != null) config['preventSuspend'] = preventSuspend;

    ////
    // Android Options
    //

    // Geolocation Options
    if (locationUpdateInterval != null) config['locationUpdateInterval'] = locationUpdateInterval;
    if (fastestLocationUpdateInterval != null) config['fastestLocationUpdateInterval'] = fastestLocationUpdateInterval;
    if (deferTime != null) config['deferTime'] = deferTime;
    if (allowIdenticalLocations != null) config['allowIdenticalLocations'] = allowIdenticalLocations;
    if (allowTimestampMeta != null) config['allowTimestampMeta'] = allowTimestampMeta;
    // Activity Recognition Options
    if (triggerActivities != null) config['triggerActivities'] = triggerActivities;
    // Application Options
    if (enableHeadless != null) config['enableHeadless'] = enableHeadless;
    if (foregroundService != null) config['foregroundService'] = foregroundService;
    if (forceReloadOnLocationChange != null) config['forceReloadOnLocationChange'] = forceReloadOnLocationChange;
    if (forceReloadOnMotionChange != null) config['forceReloadOnMotionChange'] = forceReloadOnMotionChange;
    if (forceReloadOnGeofence != null) config['forceReloadOnGeofence'] = forceReloadOnGeofence;
    if (forceReloadOnBoot != null) config['forceReloadOnBoot'] = forceReloadOnBoot;
    if (forceReloadOnHeartbeat != null) config['forceReloadOnHeartbeat'] = forceReloadOnHeartbeat;
    if (forceReloadOnSchedule != null) config['forceReloadOnSchedule'] = forceReloadOnSchedule;
    if (notificationPriority != null) config['notificationPriority'] = notificationPriority;
    if (notificationTitle != null) config['notificationTitle'] = notificationTitle;
    if (notificationText != null) config['notificationText'] = notificationText;
    if (notificationColor != null) config['notificationColor'] = notificationColor;
    if (notificationSmallIcon != null) config['notificationSmallIcon'] = notificationSmallIcon;
    if (notificationLargeIcon != null) config['notificationLargeIcon'] = notificationLargeIcon;
    if (notificationChannelName != null) config['notificationChannelName'] = notificationChannelName;

    return config;
  }

  static final DeviceInfoPlugin deviceInfo = new DeviceInfoPlugin();
  
  // Returns a Map suitable for attaching to #params and posting to tracker.transistorsoft.com
  static Future<Map<String,dynamic>> get deviceParams async {
    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        AndroidDeviceInfo info = await deviceInfo.androidInfo;
        return {
          'device': {
            'uuid': info.id,
            'model': info.model,
            'platform': 'Android',
            'manufacturer': info.manufacturer,
            'version': info.version.release,
            'framework': 'Flutter'
          }
        };
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        IosDeviceInfo info = await deviceInfo.iosInfo;
        return {
          'device': {
            'uuid': info.identifierForVendor,
            'model': info.model,
            'platform': 'iOS',
            'manufacturer': 'Apple',
            'version': info.systemVersion,
            'framework': 'Flutter'
          }
        };
      }
    } on PlatformException {
      return {
        'Error:': 'Failed to get platform version.'
      };
    }
  }
}

class State extends Config {
  Map map;
  // State
  bool enabled;
  bool schedulerEnabled;
  double odometer;
  int trackingMode;

  State(dynamic data):super(
    // Common Options
    desiredAccuracy: (data['desiredAccuracy'].runtimeType == double) ? data['desiredAccuracy'].round() : data['desiredAccuracy'],
    distanceFilter: data['distanceFilter'],
    stationaryRadius: (data['stationaryRadius'].runtimeType == int) ? data['stationaryRadius']*1.0 : data['stationaryRadius'],
    locationTimeout: (data['locationTimeout'].runtimeType == double) ? data['locationTimeout'].round() : data['locationTimeout'],
    disableElasticity: data['disableElasticity'],
    elasticityMultiplier: data['elasticityMultiplier'],
    stopAfterElapsedMinutes: (data['stopAfterElapsedMinutes'].runtimeType == double) ? data['stopAfterElapsedMinutes'].round() : data['stopAfterElapsedMinutes'],
    geofenceProximityRadius: (data['geofenceProximityRadius'].runtimeType == double) ? data['geofenceProximityRadius'].round() : data['geofenceProximityRadius'],
    geofenceInitialTriggerEntry: data['geofenceInitialTriggerEntry'],
    desiredOdometerAccuracy: data['desiredOdometerAccuracy'],
    // ActivityRecognition
    isMoving: data['isMoving'],
    stopTimeout: (data['stopTimeout'].runtimeType == double) ? data['stopTimeout'].round() : data['stopTimeout'],
    activityRecognitionInterval: (data['activityRecognitionInterval'].runtimeType == double) ? data['activityRecognitionInterval'].round() : data['activityRecognitionInterval'],
    minimumActivityRecognitionConfidence: data['minimumActivityRecognitionConfidence'],
    disableStopDetection: data['disableStopDetection'],
    stopOnStationary: data['stopOnStationary'],
    // HTTP & Persistence
    url: data['url'],
    method: data['method'],
    httpRootProperty: data['httpRootProperty'],
    params: data['params'].cast<String,dynamic>(),
    headers: data['headers'].cast<String,dynamic>(),
    extras: data['extras'].cast<String,dynamic>(),
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
    heartbeatInterval: ( data['heartbeatInterval'].runtimeType == double) ?  data['heartbeatInterval'].round() : data['heartbeatInterval'],
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
    pausesLocationUpdatesAutomatically: data['pausesLocationUpdatesAutomatically'],
    locationAuthorizationRequest: data['locationAuthorizationRequest'],
    locationAuthorizationAlert: (data['locationAuthorizationAlert'] != null) ? data['locationAuthorizationAlert'].cast<String,dynamic>() : null,
    disableLocationAuthorizationAlert: data['disableLocationAuthorizationAlert'],
    // Activity Recognition Options
    activityType: data['activityType'],
    stopDetectionDelay: (data['stopDetectionDelay'].runtimeType == double) ? data['stopDetectionDelay'].round() : data['stopDetectionDelay'],
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
    allowTimestampMeta: data['allowTimestampMeta'],
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
    notificationChannelName: data['notificationChannelName']
  ) {
    enabled = data['enabled'];
    trackingMode = data['trackingMode'];
    schedulerEnabled = data['schedulerEnabled'];
    odometer = data['odometer'];
    map = data;
  }

  String toString() {
    return '[BGState enabled: $enabled, isMoving: $isMoving, trackingMode: $trackingMode, odometer: $odometer, schedulerEnabled: $schedulerEnabled], foregroundService: $foregroundService';
  }
}