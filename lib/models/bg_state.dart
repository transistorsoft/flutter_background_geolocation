part of flt_background_geolocation;

class BGConfig {
  // Geolocation
  double distanceFilter;
  double stationaryRadius;
  double locationTimeout;
  bool useSignificantChangesOnly;
  bool pausesLocationUpdatesAutomatically;
  bool disableElasticity;
  double elasticityMultiplier;
  double stopAfterElapsedMinutes;
  String locationAuthorizationRequest;
  Map<String,dynamic> locationAuthorizationAlert;
  bool disableLocationAuthorizationAlert;
  double geofenceProximityRadius;
  bool geofenceInitialTriggerEntry;
  double desiredOdometerAccuracy;
  // ActivityRecognition
  int activityType;
  double stopDetectionDelay;
  double stopTimeout;
  double activityRecognitionInterval;
  int minimumActivityRecognitionConfidence;
  bool disableMotionActivityUpdates;
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
  bool preventSuspend;
  double heartbeatInterval;
  List<String> schedule;
  // Logging & Debug
  bool debug;
  int logLevel;
  int logMaxDays;

  bool reset;

  // Android
  bool foregroundService;

  BGConfig({
    this.distanceFilter,
    this.stationaryRadius,
    this.locationTimeout,
    this.useSignificantChangesOnly,
    this.pausesLocationUpdatesAutomatically,
    this.disableElasticity,
    this.elasticityMultiplier,
    this.stopAfterElapsedMinutes,
    this.locationAuthorizationRequest,
    this.locationAuthorizationAlert,
    this.disableLocationAuthorizationAlert,
    this.geofenceProximityRadius,
    this.geofenceInitialTriggerEntry,
    this.desiredOdometerAccuracy,
    // ActivityRecognition
    this.activityType,
    this.stopDetectionDelay,
    this.stopTimeout,
    this.activityRecognitionInterval,
    this.minimumActivityRecognitionConfidence,
    this.disableMotionActivityUpdates,
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
    this.preventSuspend,
    this.heartbeatInterval,
    this.schedule,
    // Logging & Debug
    this.debug,
    this.logLevel,
    this.logMaxDays,
    this.reset,
    // Android
    this.foregroundService
  });

  Map toMap() {
    Map config = {};
    if(this.distanceFilter != null) config['distanceFilter'] = distanceFilter;
    if(this.stationaryRadius != null) config['stationaryRadius'] = stationaryRadius;
    if(this.locationTimeout != null) config['locationTimeout'] = locationTimeout;
    if(this.useSignificantChangesOnly != null) config['useSignificantChangesOnly'] = useSignificantChangesOnly;
    if(this.pausesLocationUpdatesAutomatically != null) config['pausesLocationUpdatesAutomatically'] = pausesLocationUpdatesAutomatically;
    if(this.disableElasticity != null) config['disableElasticity'] = disableElasticity;
    if(this.elasticityMultiplier != null) config['elasticityMultiplier'] = elasticityMultiplier;
    if(this.stopAfterElapsedMinutes != null) config['stopAfterElapsedMinutes'] = stopAfterElapsedMinutes;
    if(this.locationAuthorizationRequest != null) config['locationAuthorizationRequest'] = locationAuthorizationRequest;
    if(this.locationAuthorizationAlert != null) config['locationAuthorizationAlert'] = locationAuthorizationAlert;
    if(this.disableLocationAuthorizationAlert != null) config['disableLocationAuthorizationAlert'] = disableLocationAuthorizationAlert;
    if(this.geofenceProximityRadius != null) config['geofenceProximityRadius'] = geofenceProximityRadius;
    if(this.geofenceInitialTriggerEntry != null) config['geofenceInitialTriggerEntry'] = geofenceInitialTriggerEntry;
    if(this.desiredOdometerAccuracy != null) config['desiredOdometerAccuracy'] = desiredOdometerAccuracy;
    // ActivityRecognition
    if(this.activityType != null) config['activityType'] = activityType;
    if(this.stopDetectionDelay != null) config['stopDetectionDelay'] = stopDetectionDelay;
    if(this.stopTimeout != null) config['stopTimeout'] = stopTimeout;
    if(this.activityRecognitionInterval != null) config['activityRecognitionInterval'] = activityRecognitionInterval;
    if(this.minimumActivityRecognitionConfidence != null) config['minimumActivityRecognitionConfidence'] = minimumActivityRecognitionConfidence;
    if(this.disableMotionActivityUpdates != null) config['disableMotionActivityUpdates'] = disableMotionActivityUpdates;
    if(this.disableStopDetection != null) config['disableStopDetection'] = disableStopDetection;
    if(this.stopOnStationary != null) config['stopOnStationary'] = stopOnStationary;
    // HTTP & Persistence
    if(this.url != null) config['url'] = url;
    if(this.method != null) config['method'] = method;
    if(this.httpRootProperty != null) config['httpRootProperty'] = httpRootProperty;
    if(this.params != null) config['params'] = params;
    if(this.headers != null) config['headers'] = headers;
    if(this.extras != null) config['extras'] = extras;
    if(this.autoSync != null) config['autoSync'] = autoSync;
    if(this.autoSyncThreshold != null) config['autoSyncThreshold'] = autoSyncThreshold;
    if(this.batchSync != null) config['batchSync'] = batchSync;
    if(this.maxBatchSize != null) config['maxBatchSize'] = maxBatchSize;
    if(this.locationTemplate != null) config['locationTemplate'] = locationTemplate;
    if(this.geofenceTemplate != null) config['geofenceTemplate'] = geofenceTemplate;
    if(this.maxDaysToPersist != null) config['maxDaysToPersist'] = maxDaysToPersist;
    if(this.maxRecordsToPersist != null) config['maxRecordsToPersist'] = maxRecordsToPersist;
    if(this.locationsOrderDirection != null) config['locationsOrderDirection'] = locationsOrderDirection;
    if(this.httpTimeout != null) config['httpTimeout'] = httpTimeout;
    // Application
    if(this.stopOnTerminate != null) config['stopOnTerminate'] = stopOnTerminate;
    if(this.startOnBoot != null) config['startOnBoot'] = startOnBoot;
    if(this.preventSuspend != null) config['preventSuspend'] = preventSuspend;
    if(this.heartbeatInterval != null) config['heartbeatInterval'] = heartbeatInterval;
    if(this.schedule != null) config['schedule'] = schedule;
    // Logging & Debug
    if(this.debug != null) config['debug'] = debug;
    if(this.logLevel != null) config['logLevel'] = logLevel;
    if(this.logMaxDays != null) config['logMaxDays'] = logMaxDays;
    if(this.reset != null) config['reset'] = reset;
    // Android
    if(this.foregroundService != null) config['foregroundService'] = foregroundService;

    return config;
  }
}

class BGState extends BGConfig {
  Map map;
  // State
  bool enabled;
  bool schedulerEnabled;
  double odometer;
  int trackingMode;
  bool isMoving;

  BGState(dynamic data):super(
    distanceFilter: data['distanceFilter'],
    stationaryRadius: data['stationaryRadius'],
    locationTimeout: data['locationTimeout'],
    useSignificantChangesOnly: data['useSignificantChangesOnly'],
    pausesLocationUpdatesAutomatically: data['pausesLocationUpdatesAutomatically'],
    disableElasticity: data['disableElasticity'],
    elasticityMultiplier: data['elasticityMultiplier'],
    stopAfterElapsedMinutes: data['stopAfterElapsedMinutes'],
    locationAuthorizationRequest: data['locationAuthorizationRequest'],
    locationAuthorizationAlert: data['locationAuthorizationAlert'].cast<String,dynamic>(),
    disableLocationAuthorizationAlert: data['disableLocationAuthorizationAlert'],
    geofenceProximityRadius: data['geofenceProximityRadius'],
    geofenceInitialTriggerEntry: data['geofenceInitialTriggerEntry'],
    desiredOdometerAccuracy: data['desiredOdometerAccuracy'],
    // ActivityRecognition
    activityType: data['activityType'],
    stopDetectionDelay: data['stopDetectionDelay'],
    stopTimeout: data['stopTimeout'],
    activityRecognitionInterval: data['activityRecognitionInter'],
    minimumActivityRecognitionConfidence: data['minimumActivityRecognitionConfidence'],
    disableMotionActivityUpdates: data['disableMotionActivityUpdates'],
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
    preventSuspend: data['preventSuspend'],
    heartbeatInterval: data['heartbeatInterval'],
    schedule: data['schedule'].cast<String>(),
    // Logging & Debug
    debug: data['debug'],
    logLevel: data['logLevel'],
    logMaxDays: data['logMaxDays'],
  ) {
    enabled = data['enabled'];
    isMoving = data['isMoving'];
    trackingMode = data['trackingMode'];
    schedulerEnabled = data['schedulerEnabled'];
    odometer = data['odometer'];

    map = data;

    // Android
    if (data['foregroundService'] != null) foregroundService = data['foregroundService'].cast<bool>();
  }

  String toString() {
    return '[BGState enabled: $enabled, isMoving: $isMoving, trackingMode: $trackingMode, odometer: $odometer, schedulerEnabled: $schedulerEnabled], foregroundService: $foregroundService';
  }
}