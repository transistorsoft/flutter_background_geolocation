part of '../../flutter_background_geolocation.dart';

/// Represents the desired location accuracy level for [GeoConfig.desiredAccuracy].
///
/// Each value maps to the legacy integer that the native layer understands.
enum DesiredAccuracy {
  /// (**iOS only**) Highest possible accuracy for turn‑by‑turn navigation.
  navigation(Config.DESIRED_ACCURACY_NAVIGATION),

  /// High accuracy using GPS + Wi‑Fi + cellular.
  high(Config.DESIRED_ACCURACY_HIGH),

  /// Medium accuracy using Wi‑Fi + cellular.
  medium(Config.DESIRED_ACCURACY_MEDIUM),

  /// Low accuracy using low‑power Wi‑Fi + cellular.
  low(Config.DESIRED_ACCURACY_LOW),

  /// Very low accuracy, primarily using cellular.
  veryLow(Config.DESIRED_ACCURACY_VERY_LOW),

  /// (**iOS only**) Lowest possible accuracy; minimum power use.
  lowest(Config.DESIRED_ACCURACY_LOWEST);

  final int id;
  const DesiredAccuracy(this.id);

  /// Convert a dynamic incoming value into [DesiredAccuracy].
  /// Accepts enum, int id, or string case-name (e.g., "high").
  static DesiredAccuracy from(dynamic v) {
    if (v is DesiredAccuracy) return v;
    if (v is int) {
      return DesiredAccuracy.values.firstWhere(
            (e) => e.id == v,
        orElse: () => DesiredAccuracy.high,
      );
    }
    if (v is String) {
      switch (v) {
        case 'navigation': return DesiredAccuracy.navigation;
        case 'high': return DesiredAccuracy.high;
        case 'medium': return DesiredAccuracy.medium;
        case 'low': return DesiredAccuracy.low;
        case 'veryLow': return DesiredAccuracy.veryLow;
        case 'lowest': return DesiredAccuracy.lowest;
      }
    }
    return DesiredAccuracy.high;
  }
}

/// Represents iOS-specific activity types used by CoreLocation’s `activityType`.
///
/// Each value maps to the legacy integer understood by the native layer.
///
/// ## Example
/// ```dart
/// BackgroundGeolocation.ready(Config(
///   geolocation: GeoConfig(
///     activityType: ActivityType.other,
///   ),
/// ));
/// ```
enum ActivityType {
  /// Default activity type for general use.
  other(Config.ACTIVITY_TYPE_OTHER),
  /// Intended for automotive navigation.
  automotiveNavigation(Config.ACTIVITY_TYPE_AUTOMOTIVE_NAVIGATION),
  /// Intended for fitness activities.
  fitness(Config.ACTIVITY_TYPE_FITNESS),
  /// Intended for navigation other than automotive.
  otherNavigation(Config.ACTIVITY_TYPE_OTHER_NAVIGATION),
  /// Intended for airborne activities.
  airborne(Config.ACTIVITY_TYPE_AIRBORNE);

  final int id;
  const ActivityType(this.id);

  /// Convert a dynamic incoming value into [ActivityType].
  /// Accepts enum, int id, or string case-name (e.g., "fitness").
  /// Defaults to [ActivityType.other].
  static ActivityType from(dynamic v) {
    if (v is ActivityType) return v;
    if (v is int) {
      return ActivityType.values.firstWhere(
            (e) => e.id == v,
        orElse: () => ActivityType.other,
      );
    }
    if (v is String) {
      switch (v) {
        case 'other': return ActivityType.other;
        case 'automotiveNavigation': return ActivityType.automotiveNavigation;
        case 'fitness': return ActivityType.fitness;
        case 'otherNavigation': return ActivityType.otherNavigation;
        case 'airborne': return ActivityType.airborne;
      }
    }
    return ActivityType.other;
  }
}

/// {@macro config.geolocation}
class GeoConfig {
  /// {@macro config.distance_filter}
  final double? distanceFilter; // float -> double

  /// {@macro config.desired_accuracy}
  final DesiredAccuracy? desiredAccuracy; // enum

  /// {@macro config.location_update_interval}
  final int? locationUpdateInterval; // long -> int

  /// {@macro config.fastest_location_update_interval}
  final int? fastestLocationUpdateInterval; // long -> int

  /// {@macro config.location_timeout}
  final int? locationTimeout; // int

  /// {@macro config.defer_time}
  final int? deferTime; // long -> int

  /// {@macro config.disable_elasticity}
  final bool? disableElasticity; // boolean

  /// {@macro config.elasticity_multiplier}
  final double? elasticityMultiplier; // float -> double

  /// {@macro config.allow_identical_locations}
  final bool? allowIdenticalLocations; // boolean

  /// {@macro config.enable_timestamp_meta}
  final bool? enableTimestampMeta; // boolean

  /// {@macro config.use_significant_changes_only}
  final bool? useSignificantChangesOnly; // boolean

  /// {@macro config.disable_location_authorization_alert}
  final bool? disableLocationAuthorizationAlert; // boolean

  /// {@macro config.location_authorization_request}
  final String? locationAuthorizationRequest; // String

  /// {@macro config.stationary_radius}
  final int? stationaryRadius; // int

  /// {@macro config.stop_timeout}
  final int? stopTimeout; // long -> int

  /// {@macro config.stop_after_elapsed_minutes}
  final int? stopAfterElapsedMinutes; // long -> int

  /// {@macro config.geofence_proximity_radius}
  final int? geofenceProximityRadius; // long -> int

  /// {@macro config.geofence_initial_trigger_entry}
  final bool? geofenceInitialTriggerEntry; // boolean

  /// {@macro config.geofence_mode_high_accuracy}
  final bool? geofenceModeHighAccuracy; // boolean

  /// {@macro config.filter}
  final LocationFilter? filter; // compound object

  /// {@macro config.pauses_location_updates_automatically}
  final bool? pausesLocationUpdatesAutomatically; // iOS only

  /// {@macro config.shows_background_location_indicator}
  final bool? showsBackgroundLocationIndicator; // iOS only

  /// {@macro config.activity_type}
  final ActivityType? activityType; // iOS only

  /// {@macro config.location_authorization_alert}
  final Map<String, dynamic>? locationAuthorizationAlert; // iOS only

  /// {@macro config.max_monitored_geofences}
  final int? maxMonitoredGeofences; // Android only

  const GeoConfig({
    this.distanceFilter,
    this.desiredAccuracy,
    this.locationUpdateInterval,
    this.fastestLocationUpdateInterval,
    this.locationTimeout,
    this.deferTime,
    this.disableElasticity,
    this.elasticityMultiplier,
    this.allowIdenticalLocations,
    this.enableTimestampMeta,
    this.useSignificantChangesOnly,
    this.disableLocationAuthorizationAlert,
    this.locationAuthorizationRequest,
    this.stationaryRadius,
    this.stopTimeout,
    this.stopAfterElapsedMinutes,
    this.geofenceProximityRadius,
    this.geofenceInitialTriggerEntry,
    this.geofenceModeHighAccuracy,
    this.filter,
    this.pausesLocationUpdatesAutomatically,
    this.showsBackgroundLocationIndicator,
    this.activityType,
    this.locationAuthorizationAlert,
    this.maxMonitoredGeofences,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
    if (distanceFilter != null) 'distanceFilter': distanceFilter,
    if (desiredAccuracy != null) 'desiredAccuracy': desiredAccuracy!.id,
    if (locationUpdateInterval != null)
      'locationUpdateInterval': locationUpdateInterval,
    if (fastestLocationUpdateInterval != null)
      'fastestLocationUpdateInterval': fastestLocationUpdateInterval,
    if (locationTimeout != null) 'locationTimeout': locationTimeout,
    if (deferTime != null) 'deferTime': deferTime,
    if (disableElasticity != null) 'disableElasticity': disableElasticity,
    if (elasticityMultiplier != null)
      'elasticityMultiplier': elasticityMultiplier,
    if (allowIdenticalLocations != null)
      'allowIdenticalLocations': allowIdenticalLocations,
    if (enableTimestampMeta != null)
      'enableTimestampMeta': enableTimestampMeta,
    if (useSignificantChangesOnly != null)
      'useSignificantChangesOnly': useSignificantChangesOnly,
    if (disableLocationAuthorizationAlert != null)
      'disableLocationAuthorizationAlert':
      disableLocationAuthorizationAlert,
    if (locationAuthorizationRequest != null)
      'locationAuthorizationRequest': locationAuthorizationRequest,
    if (stationaryRadius != null) 'stationaryRadius': stationaryRadius,
    if (stopTimeout != null) 'stopTimeout': stopTimeout,
    if (stopAfterElapsedMinutes != null)
      'stopAfterElapsedMinutes': stopAfterElapsedMinutes,
    if (geofenceProximityRadius != null)
      'geofenceProximityRadius': geofenceProximityRadius,
    if (geofenceInitialTriggerEntry != null)
      'geofenceInitialTriggerEntry': geofenceInitialTriggerEntry,
    if (geofenceModeHighAccuracy != null)
      'geofenceModeHighAccuracy': geofenceModeHighAccuracy,
    if (filter != null) 'filter': filter!.toMap(),
    if (pausesLocationUpdatesAutomatically != null)
      'pausesLocationUpdatesAutomatically': pausesLocationUpdatesAutomatically,
    if (showsBackgroundLocationIndicator != null)
      'showsBackgroundLocationIndicator': showsBackgroundLocationIndicator,
    if (activityType != null) 'activityType': activityType!.id,
    if (locationAuthorizationAlert != null)
      'locationAuthorizationAlert': locationAuthorizationAlert,
    if (maxMonitoredGeofences != null)
      'maxMonitoredGeofences': maxMonitoredGeofences,
  };

  factory GeoConfig.fromMap(Map<String, dynamic> m) => GeoConfig(
    distanceFilter: _ensureDouble(m['distanceFilter']),
    desiredAccuracy: (m['desiredAccuracy'] != null)
        ? DesiredAccuracy.from(m['desiredAccuracy'])
        : null,
    locationUpdateInterval: _ensureInt(m['locationUpdateInterval'] ?? m['interval']),
    fastestLocationUpdateInterval: _ensureInt(m['fastestLocationUpdateInterval'] ?? m['fastestInterval']),
    locationTimeout: _ensureInt(m['locationTimeout']),
    deferTime: _ensureInt(m['deferTime']),
    disableElasticity: _ensureBool(m['disableElasticity']),
    elasticityMultiplier: _ensureDouble(m['elasticityMultiplier']),
    allowIdenticalLocations: _ensureBool(m['allowIdenticalLocations']),
    enableTimestampMeta: _ensureBool(m['enableTimestampMeta']),
    useSignificantChangesOnly: _ensureBool(m['useSignificantChangesOnly']),
    disableLocationAuthorizationAlert: _ensureBool(m['disableLocationAuthorizationAlert']),
    stationaryRadius: _ensureInt(m['stationaryRadius']),
    stopTimeout: _ensureInt(m['stopTimeout']),
    stopAfterElapsedMinutes: _ensureInt(m['stopAfterElapsedMinutes']),
    geofenceProximityRadius: _ensureInt(m['geofenceProximityRadius']),
    geofenceInitialTriggerEntry: _ensureBool(m['geofenceInitialTriggerEntry']),
    geofenceModeHighAccuracy: _ensureBool(m['geofenceModeHighAccuracy']),
    filter: (m['filter'] is Map)
        ? LocationFilter.fromMap((m['filter'] as Map).cast<String, dynamic>())
        : null,
    pausesLocationUpdatesAutomatically: _ensureBool(m['pausesLocationUpdatesAutomatically']),
    showsBackgroundLocationIndicator: _ensureBool(m['showsBackgroundLocationIndicator']),
    activityType: (m['activityType'] != null)
        ? ActivityType.from(m['activityType'])
        : null,
    locationAuthorizationAlert: (m['locationAuthorizationAlert'] is Map)
        ? (m['locationAuthorizationAlert'] as Map).cast<String, dynamic>()
        : null,
    maxMonitoredGeofences: _ensureInt(m['maxMonitoredGeofences']),
  );
}

/// {@macro location_filter.kalman_profile}
enum KalmanProfile {
  /// Balanced for general-purpose movement (**default**).
  ///
  /// This is the default value if no profile is specified.
  defaultProfile(0),

  /// Aggressive: responds faster to motion, with less smoothing.
  aggressive(1),

  /// Conservative: maximum smoothing, slower to react to sudden changes.
  conservative(2);

  final int id;
  const KalmanProfile(this.id);

  /// Converts an integer ID (from native) to a [KalmanProfile].
  static KalmanProfile fromId(int id) =>
      KalmanProfile.values.firstWhere((p) => p.id == id,
          orElse: () => KalmanProfile.defaultProfile);
}

/// {@macro location_filter.policy}
enum LocationFilterPolicy {
  /// No filtering — accept all samples (useful for debugging or raw capture).
  passThrough,

  /// Balanced (default) — applies moderate filtering to reject noisy samples.
  /// Dynamically adjusts acceptance thresholds for incoming location samples,
  /// *not* the raw coordinates themselves.
  ///
  /// When using `adjust` (the default), the SDK computes motion metrics such as
  /// distance deltas, implied speed, accuracy variance, and heading stability.
  /// It then applies adaptive gating rules to decide whether each sample should
  /// be accepted, ignored, or rejected as noise.
  ///
  /// **No changes are made to latitude or longitude values.**
  ///
  /// In effect, this policy “adjusts” the *criteria* for inclusion, not the
  /// *positions* themselves. When [LocationFilter.useKalman] is enabled, samples may be
  /// smoothed for noise reduction, but their physical coordinates remain
  /// untouched. 
  adjust,

  /// Aggressive — filters heavily to remove noise, preferring stability.
  conservative,
}

/// {@macro config.filter}
class LocationFilter {
  /// {@macro location_filter.policy}
  final LocationFilterPolicy? policy;

  /// Enables the Kalman filter to smooth incoming location speed and position.
  ///
  /// When `true`, a Kalman filter is applied to remove noise and stabilize
  /// velocity and distance calculations. Defaults to `true`.
  final bool? useKalman;

  /// Enables verbose Kalman debug output in logs.
  ///
  /// When `true`, additional diagnostic data about the Kalman filter’s
  /// internal state (e.g., variance, innovation) will be logged for each sample.
  final bool? kalmanDebug;

  /// {@macro location_filter.kalman_profile}
  final KalmanProfile? kalmanProfile;

  /// Number of samples in the rolling window used for burst averaging.
  ///
  /// Higher values increase smoothing but add latency. Default: `5`.
  final int? rollingWindow;

  /// Duration (in seconds) of each burst window used for averaging samples.
  ///
  /// The plugin groups locations received within this window into a single
  /// averaged point. Default: `10` seconds.
  final double? burstWindow;

  /// Maximum distance (in meters) between samples considered part of the same burst.
  ///
  /// Prevents merging widely separated samples into a single average.
  /// Default: `300`.
  final double? maxBurstDistance;

  /// Minimum acceptable accuracy (in meters) for a sample to be used in tracking.
  ///
  /// Locations less accurate than this threshold will be ignored.
  /// Default: `100`.
  final double? trackingAccuracyThreshold;

  /// Maximum implied speed (in m/s) allowed before rejecting a location.
  ///
  /// Samples that would imply a speed greater than this value are ignored
  /// as unrealistic outliers. Default: `60` (~216 km/h).
  final double? maxImpliedSpeed;

  /// Enables verbose debug logging for the filtering engine.
  ///
  /// When `true`, detailed “ACCEPTED / REJECTED / IGNORED” decisions will
  /// appear in logs.
  final bool? filterDebug;

  /// Applies a Kalman filter **only to odometer calculations**, independent of [useKalman].
  ///
  /// When `true`, the odometer’s distance accumulation logic smooths incoming
  /// samples to reduce jitter and eliminate noise, without affecting recorded
  /// track points. This is useful when you want smoother odometer readings
  /// but wish to preserve the raw location stream for analysis or mapping.
  ///
  /// If both [useKalman] and [odometerUseKalmanFilter] are `true`, each
  /// subsystem (tracking and odometer) maintains its own Kalman instance.
  ///
  /// Default: `false`.
  final bool? odometerUseKalmanFilter;

  /// Maximum horizontal accuracy (in meters) allowed to affect the odometer.
  ///
  /// Samples with `accuracy > odometerAccuracyThreshold` are ignored for
  /// odometer updates. Default: `100`.
  final double? odometerAccuracyThreshold;

  const LocationFilter({
    this.policy = LocationFilterPolicy.adjust,
    this.useKalman,
    this.kalmanDebug,
    this.kalmanProfile,
    this.rollingWindow,
    this.burstWindow,
    this.maxBurstDistance,
    this.trackingAccuracyThreshold,
    this.maxImpliedSpeed,
    this.filterDebug,
    this.odometerUseKalmanFilter,
    this.odometerAccuracyThreshold,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
    if (policy != null) 'policy': policy!.index,
    if (useKalman != null) 'useKalman': useKalman,
    if (kalmanDebug != null) 'kalmanDebug': kalmanDebug,
    if (kalmanProfile != null) 'kalmanProfile': kalmanProfile!.id,
    if (rollingWindow != null) 'rollingWindow': rollingWindow,
    if (burstWindow != null) 'burstWindow': burstWindow,
    if (maxBurstDistance != null) 'maxBurstDistance': maxBurstDistance,
    if (trackingAccuracyThreshold != null)
      'trackingAccuracyThreshold': trackingAccuracyThreshold,
    if (maxImpliedSpeed != null) 'maxImpliedSpeed': maxImpliedSpeed,
    if (filterDebug != null) 'filterDebug': filterDebug,
    if (odometerUseKalmanFilter != null)
      'odometerUseKalmanFilter': odometerUseKalmanFilter,
    if (odometerAccuracyThreshold != null)
      'odometerAccuracyThreshold': odometerAccuracyThreshold,
  };

  factory LocationFilter.fromMap(Map<String, dynamic> m) => LocationFilter(
    policy: (m['policy'] != null)
        ? LocationFilterPolicy.values[m['policy']]
        : null,
    useKalman: _ensureBool(m['useKalman']),
    kalmanDebug: _ensureBool(m['kalmanDebug']),
    kalmanProfile: (m['kalmanProfile'] != null)
        ? KalmanProfile.fromId(_ensureInt(m['kalmanProfile'])!)
        : null,
    rollingWindow: _ensureInt(m['rollingWindow']),
    burstWindow: _ensureDouble(m['burstWindow']),
    maxBurstDistance: _ensureDouble(m['maxBurstDistance']),
    // Accept legacy iOS key `accuracyThreshold` as alias
    trackingAccuracyThreshold: _ensureDouble(
        m['trackingAccuracyThreshold'] ?? m['accuracyThreshold']
    ),
    maxImpliedSpeed: _ensureDouble(m['maxImpliedSpeed']),
    filterDebug: _ensureBool(m['filterDebug']),
    odometerUseKalmanFilter: _ensureBool(m['odometerUseKalmanFilter']),
    odometerAccuracyThreshold: _ensureDouble(m['odometerAccuracyThreshold']),
  );
}