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
        case 'navigation':
          return DesiredAccuracy.navigation;
        case 'high':
          return DesiredAccuracy.high;
        case 'medium':
          return DesiredAccuracy.medium;
        case 'low':
          return DesiredAccuracy.low;
        case 'veryLow':
          return DesiredAccuracy.veryLow;
        case 'lowest':
          return DesiredAccuracy.lowest;
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
        case 'other':
          return ActivityType.other;
        case 'automotiveNavigation':
          return ActivityType.automotiveNavigation;
        case 'fitness':
          return ActivityType.fitness;
        case 'otherNavigation':
          return ActivityType.otherNavigation;
        case 'airborne':
          return ActivityType.airborne;
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

  /// Defines how raw GPS samples are filtered, denoised, and smoothed before being
  /// recorded or used for odometer calculations.
  ///
  /// `LocationFilter` is supplied via [GeoConfig.filter] and provides
  /// fine-grained control over how the SDK handles noisy or inconsistent
  /// location data from the underlying platform.
  ///
  /// The native platform continuously produces raw `CLLocation` (iOS) or `Location`
  /// (Android) samples. The filter applies rolling-window averaging,
  /// and speed, distance, and accuracy constraints to produce smoother paths, reduce
  /// jitter, and improve odometer stability.
  ///
  /// ## Filtering flow
  ///
  /// ![](https://dl.dropbox.com/scl/fi/71rkzdo2tr3qm651ulou8/location-filter-flowchart.svg?rlkey=16zxs3lnqvlrw137974jbsoj7&dl=1)
  ///
  /// | Field | Description |
  /// |-------|-------------|
  /// | **[LocationFilter.policy]** | Selects which filtering policy to apply. See [LocationFilterPolicy]. |
  /// | **[LocationFilter.useKalman]** | Has no effect on delivered locations (default: `true`). |
  /// | **[LocationFilter.kalmanDebug]** | Logs the odometer filter's values for each location (default: `false`). |
  /// | **[LocationFilter.kalmanProfile]** | Selects how strongly the odometer smooths the path at slow speeds (see [KalmanProfile]). |
  /// | **[LocationFilter.rollingWindow]** | Number of samples for rolling burst averaging. Larger values increase smoothness but reduce responsiveness. |
  /// | **[LocationFilter.burstWindow]** | Duration of each averaging burst (seconds). Default: `10`. |
  /// | **[LocationFilter.maxBurstDistance]** | Maximum distance (meters) for samples to be included in the same burst window. Default: `300`. |
  /// | **[LocationFilter.trackingAccuracyThreshold]** | Maximum GPS horizontal accuracy (meters) required to accept a location. Default: `100`. |
  /// | **[LocationFilter.maxImpliedSpeed]** | Maximum implied speed (m/s) before rejecting a sample as unrealistic. Default: `60` (~216 km/h). |
  /// | **[LocationFilter.filterDebug]** | Enables verbose logging of filter decisions (`ACCEPTED`, `REJECTED`, etc). |
  /// | **[LocationFilter.odometerUseKalmanFilter]** | Switches the odometer's position filter (default: `true`). |
  /// | **[LocationFilter.odometerAccuracyThreshold]** | Maximum accuracy (meters) allowed for a sample to affect the odometer. Default: `20`. |
  ///
  /// ## Note
  /// - Distances are in **meters**.
  /// - Time fields are in **seconds** unless otherwise specified.
  /// - Filtering affects **recorded** locations only — it does not influence real-time motion detection.
  ///
  /// ## Example 1
  ///
  /// ```dart
  /// BackgroundGeolocation.ready(Config(
  ///   geolocation: GeoConfig(
  ///     filter: LocationFilter(
  ///       policy: LocationFilterPolicy.adjust,
  ///       useKalman: true,
  ///       kalmanProfile: KalmanProfile.defaultProfile,
  ///       trackingAccuracyThreshold: 100.0,
  ///       odometerAccuracyThreshold: 20.0
  ///     )
  ///   )
  /// ));
  /// ```
  ///
  /// ## Example 2
  ///
  /// ```dart
  /// BackgroundGeolocation.ready(Config(
  ///   geolocation: GeoConfig(
  ///     filter: LocationFilter(
  ///       policy: LocationFilterPolicy.passThrough,
  ///       useKalman: false
  ///     )
  ///   )
  /// ));
  /// ```
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
          'pausesLocationUpdatesAutomatically':
              pausesLocationUpdatesAutomatically,
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
        locationUpdateInterval:
            _ensureInt(m['locationUpdateInterval'] ?? m['interval']),
        fastestLocationUpdateInterval: _ensureInt(
            m['fastestLocationUpdateInterval'] ?? m['fastestInterval']),
        locationTimeout: _ensureInt(m['locationTimeout']),
        deferTime: _ensureInt(m['deferTime']),
        disableElasticity: _ensureBool(m['disableElasticity']),
        elasticityMultiplier: _ensureDouble(m['elasticityMultiplier']),
        allowIdenticalLocations: _ensureBool(m['allowIdenticalLocations']),
        enableTimestampMeta: _ensureBool(m['enableTimestampMeta']),
        useSignificantChangesOnly: _ensureBool(m['useSignificantChangesOnly']),
        disableLocationAuthorizationAlert:
            _ensureBool(m['disableLocationAuthorizationAlert']),
        stationaryRadius: _ensureInt(m['stationaryRadius']),
        stopTimeout: _ensureInt(m['stopTimeout']),
        stopAfterElapsedMinutes: _ensureInt(m['stopAfterElapsedMinutes']),
        geofenceProximityRadius: _ensureInt(m['geofenceProximityRadius']),
        geofenceInitialTriggerEntry:
            _ensureBool(m['geofenceInitialTriggerEntry']),
        geofenceModeHighAccuracy: _ensureBool(m['geofenceModeHighAccuracy']),
        filter: (m['filter'] is Map)
            ? LocationFilter.fromMap(
                (m['filter'] as Map).cast<String, dynamic>())
            : null,
        pausesLocationUpdatesAutomatically:
            _ensureBool(m['pausesLocationUpdatesAutomatically']),
        showsBackgroundLocationIndicator:
            _ensureBool(m['showsBackgroundLocationIndicator']),
        activityType: (m['activityType'] != null)
            ? ActivityType.from(m['activityType'])
            : null,
        locationAuthorizationAlert: (m['locationAuthorizationAlert'] is Map)
            ? (m['locationAuthorizationAlert'] as Map).cast<String, dynamic>()
            : null,
        maxMonitoredGeofences: _ensureInt(m['maxMonitoredGeofences']),
      );
}

/// How strongly the odometer smooths the path while the device moves slowly.
///
/// `aggressive` follows the fixes most, `conservative` smooths most and cuts the
/// most corners, `defaultProfile` sits between. At riding and driving speed the three
/// agree; they differ at walking pace, between about 1 and 3 m/s, mostly with
/// `distanceFilter: 0`. The profile applies only to the odometer.
///
/// If no profile is provided, `defaultProfile` is applied.
enum KalmanProfile {
  /// The SDK's default: between the other two, for most apps.
  defaultProfile(0),

  /// Follows the fixes most closely: the least smoothing, the most of a slow path
  /// kept, and the most GPS wander counted.
  aggressive(1),

  /// Smooths most: the steadiest total at riding and driving speed, the most
  /// corners cut at walking pace, and 20 to 50 % short on short back-and-forth
  /// paths.
  conservative(2);

  final int id;
  const KalmanProfile(this.id);

  /// Converts an integer ID (from native) to a [KalmanProfile].
  static KalmanProfile fromId(int id) =>
      KalmanProfile.values.firstWhere((p) => p.id == id,
          orElse: () => KalmanProfile.defaultProfile);
}

/// Defines the filtering policy applied to incoming raw GPS samples before they
/// are accepted, averaged, or rejected by the [LocationFilter].
///
/// The filtering policy determines how aggressively the plugin removes noisy,
/// inaccurate, or redundant location updates. It represents the *first stage*
/// in the SDK’s data-quality pipeline — before burst averaging,
/// or other denoising steps are applied.
///
/// Choosing the correct policy depends on your app’s tolerance for jitter versus
/// responsiveness:
///
/// - Fitness or vehicle-tracking apps often prefer stronger filtering.
/// - Survey or scientific apps may prefer capturing unmodified raw samples.
///
/// **Profiles**
///
/// | Policy | Description | Use Case |
/// |--------|-------------|----------|
/// | [LocationFilterPolicy.passThrough] | **No filtering.** Every received sample is recorded, even if noisy or identical to the previous one. | Debugging, diagnostics, scenarios requiring raw data. |
/// | [LocationFilterPolicy.adjust] | **Balanced filtering.** Smooths and rejects only clearly invalid samples. | Most use cases — walking, cycling, automotive tracking. |
/// | [LocationFilterPolicy.conservative] | **Strict filtering.** Strongly smooths data and rejects high-variance samples, prioritizing stability over responsiveness. *(Default)* | Analytics, long-term background logging, noise-sensitive applications. |
///
/// **Notes**
///
/// - This policy affects only the SDK’s *internal* filtering pipeline.
///   It does **not** modify the raw values returned to [BackgroundGeolocation.onLocation].
/// - For more granular tuning, see [LocationFilter.trackingAccuracyThreshold],
///   [LocationFilter.maxImpliedSpeed], and other [LocationFilter] fields.
///
/// **Examples**
///
/// ## Example 1
///
/// ```dart
/// BackgroundGeolocation.ready(Config(
///   geolocation: GeoConfig(
///     filter: LocationFilter(
///       policy: LocationFilterPolicy.adjust
///     )
///   )
/// ));
/// ```
///
/// ## Example 2
///
/// ```dart
/// BackgroundGeolocation.ready(Config(
///   geolocation: GeoConfig(
///     filter: LocationFilter(
///       policy: LocationFilterPolicy.passThrough
///     )
///   )
/// ));
/// ```
///
/// ## Example 3
///
/// ```dart
/// BackgroundGeolocation.ready(Config(
///   geolocation: GeoConfig(
///     filter: LocationFilter(
///       policy: LocationFilterPolicy.conservative
///     )
///   )
/// ));
/// ```
///
/// **See also**
/// - [GeoConfig.filter]
/// - [LocationFilter]
/// - [KalmanProfile]
enum LocationFilterPolicy {
  /// No filtering — accept all samples (useful for debugging or raw capture).
  passThrough,

  /// Balanced — applies moderate filtering to reject noisy samples.
  ///
  /// Dynamically adjusts acceptance thresholds for incoming samples, but **never**
  /// alters the raw latitude/longitude coordinates.
  ///
  /// When using [LocationFilterPolicy.adjust], the SDK computes
  /// motion metrics such as:
  ///
  /// - distance deltas
  /// - implied speed
  /// - accuracy variance
  /// - heading stability
  ///
  /// It then applies adaptive gating rules to decide whether each sample should be:
  ///
  /// - accepted
  /// - ignored
  /// - rejected as noise
  ///
  /// **Coordinates are never modified.** This policy adjusts *which* samples are
  /// included, not *how* they are positioned.
  ///
  /// [LocationFilter.useKalman] has no effect on delivered locations:
  /// the physical coordinates of each accepted sample remain untouched.
  adjust,

  /// Aggressive (default) — filters heavily to remove noise, preferring stability.
  /// This is the default policy when `policy` is not specified.
  conservative,
}

/// Filters, denoises, and smooths raw GPS samples before they are recorded or
/// used for odometer calculations.
///
/// `LocationFilter` is supplied via [GeoConfig.filter] and provides
/// fine-grained control over how the SDK handles noisy or inconsistent location
/// data from the underlying platform.
///
/// ## Contents
/// - [Overview](#overview)
/// - [Policy scope](#policy-scope)
/// - [Examples](#examples)
///
/// ---
///
/// ## Overview
///
/// The SDK applies several processing stages to each raw GPS sample before
/// recording it: an accuracy gate, rolling-window burst detection, and speed
/// and distance constraints; the odometer runs its own position filter on the
/// samples that pass. Coordinates are never modified.
///
/// ![](https://dl.dropbox.com/scl/fi/71rkzdo2tr3qm651ulou8/location-filter-flowchart.svg?rlkey=16zxs3lnqvlrw137974jbsoj7&dl=1)
///
/// | Field | Description |
/// |-------|-------------|
/// | [policy] | Selects which filtering policy to apply. See [LocationFilterPolicy]. |
/// | [useKalman] | Has no effect on delivered locations (default: `true`). |
/// | [kalmanDebug] | Logs the odometer filter's values for each location (default: `false`). |
/// | [kalmanProfile] | Selects how strongly the odometer smooths the path at slow speeds (see [KalmanProfile]). |
/// | [rollingWindow] | Number of samples for rolling burst averaging. Larger values increase smoothness but reduce responsiveness. Default: `5`. |
/// | [burstWindow] | Duration of each averaging burst (seconds). Default: `10`. |
/// | [maxBurstDistance] | Maximum distance (meters) for samples included in the same burst window. Default: `300`. |
/// | [trackingAccuracyThreshold] | Maximum GPS horizontal accuracy (meters) required to accept a location. Default: `100`. |
/// | [maxImpliedSpeed] | Maximum implied speed (m/s) before rejecting a sample as unrealistic. Default: `60` (≈ 216 km/h). |
/// | [filterDebug] | Enables verbose logging of filter decisions (default: `false`). |
/// | [odometerUseKalmanFilter] | Switches the odometer's position filter (default: `true`). |
/// | [odometerAccuracyThreshold] | Maximum accuracy (meters) allowed for a sample to affect the odometer. Default: `20`. |
/// | [odometerPolicy] | Filtering policy for odometer samples — use `conservative` to reject GPS teleports entirely. Default: `adjust`. |
///
/// - Distances are in **meters**.
/// - Time fields are in **seconds** unless noted otherwise.
/// - Filtering affects **recorded** locations only — it does not influence real-time motion detection.
///
/// ## Example
///
/// ```dart
/// BackgroundGeolocation.ready(Config(
///   geolocation: GeoConfig(
///     filter: LocationFilter(
///       policy: LocationFilterPolicy.adjust,
///       useKalman: true,
///       kalmanProfile: KalmanProfile.defaultProfile,
///       trackingAccuracyThreshold: 100.0,
///       odometerAccuracyThreshold: 20.0
///     )
///   )
/// ));
/// ```
///
/// ---
///
/// ## Policy scope
///
/// [policy] controls only the **decision phase** — how the filter responds
/// to a sample *after* its motion metrics are computed. Several fields apply
/// regardless of the chosen policy:
///
/// | Field | Governed by `policy`? | Behaviour |
/// |-------|:---------------------:|-----------|
/// | [trackingAccuracyThreshold] | No | Accuracy gate. A fix whose accuracy is worse than this is **rejected before** the policy runs — under *every* policy, including `passThrough`. Set to `0` to disable the gate. |
/// | [useKalman], [kalmanProfile] | — | Neither affects the tracking `policy`: `useKalman` has no effect on delivered locations, and `kalmanProfile` governs the odometer's filter. |
/// | [maxBurstDistance], [burstWindow] | Yes | Define a GPS "spike" (a large jump in a short window). `conservative` rejects it, `adjust` caps it, `passThrough` lets it through. |
/// | [maxImpliedSpeed] | Partly | Flags an implausible-speed spike (rejected only under `conservative`), and also applies a final per-step speed clamp under *every* policy. |
/// | [rollingWindow] | Yes | Feeds the kinematic / outlier cap used by `adjust` and `conservative`; `passThrough` ignores it. |
/// | [odometerPolicy], [odometerAccuracyThreshold], [odometerUseKalmanFilter] | — | Govern the separate **odometer** filter, not the tracking `policy`. |
///
/// Each policy differs only in how it treats anomalous or over-distance steps:
///
/// - **`passThrough`** — accept the sample as-is; no capping, no anomaly rejection.
/// - **`adjust`** — cap the step (to [GeoConfig.distanceFilter] or the
///   kinematic limit); never rejects.
/// - **`conservative`** — reject implausible-speed or outlier steps; otherwise cap.
///
/// ## ⚠️ Warning
///
/// `passThrough` does **not** disable [trackingAccuracyThreshold]. To record
/// every sample untouched, set `policy: LocationFilterPolicy.passThrough` **and**
/// `trackingAccuracyThreshold: 0` — otherwise low-accuracy fixes are still rejected
/// (and delivered to [BackgroundGeolocation.onLocationFilter]).
///
/// ## Examples
///
/// ```dart
/// BackgroundGeolocation.ready(Config(
///   geolocation: GeoConfig(
///     filter: LocationFilter(
///       policy: LocationFilterPolicy.passThrough,
///       useKalman: false
///     )
///   )
/// ));
/// ```
class LocationFilter {
  /// Selects the filtering policy applied to incoming raw GPS samples before they
  /// are accepted, averaged, or rejected. Defaults to
  /// `LocationFilterPolicy.conservative`.
  ///
  /// The filtering policy determines how aggressively the SDK removes noisy,
  /// inaccurate, or redundant location updates. It is the first stage in the
  /// data-quality pipeline — before burst averaging or other
  /// denoising steps are applied.
  ///
  /// | Policy | Description | Use case |
  /// |--------|-------------|----------|
  /// | [LocationFilterPolicy.passThrough] | **No filtering.** Every received sample is recorded, even if noisy or identical to the previous one. | Debugging, diagnostics, scenarios requiring raw data. |
  /// | [LocationFilterPolicy.adjust] | **Balanced filtering.** Smooths and caps only clearly invalid samples. | Most use cases — walking, cycling, automotive tracking. |
  /// | [LocationFilterPolicy.conservative] | **Strict filtering.** Strongly smooths data and rejects high-variance samples, prioritizing stability over responsiveness. *(Default)* | Analytics, long-term background logging, noise-sensitive applications. |
  ///
  /// Choosing the correct policy depends on your app's tolerance for jitter versus
  /// responsiveness:
  /// - Fitness or vehicle-tracking apps often prefer `adjust` for lower latency.
  /// - Survey or analytics apps may prefer `conservative` for maximum stability,
  ///   or `passThrough` to capture unmodified raw samples.
  ///
  /// ## Note
  /// This policy affects only the SDK's internal filtering pipeline. It does
  /// **not** modify the raw values returned to [BackgroundGeolocation.onLocation].
  /// For more granular tuning, see [LocationFilter.trackingAccuracyThreshold],
  /// [LocationFilter.maxImpliedSpeed], and other [LocationFilter] fields.
  ///
  /// **See also**
  /// - [GeoConfig.filter]
  /// - [LocationFilter]
  /// - [KalmanProfile]
  ///
  /// ## Example 1
  ///
  /// ```dart
  /// BackgroundGeolocation.ready(Config(
  ///   geolocation: GeoConfig(
  ///     filter: LocationFilter(
  ///       policy: LocationFilterPolicy.adjust
  ///     )
  ///   )
  /// ));
  /// ```
  ///
  /// ## Example 2
  ///
  /// ```dart
  /// BackgroundGeolocation.ready(Config(
  ///   geolocation: GeoConfig(
  ///     filter: LocationFilter(
  ///       policy: LocationFilterPolicy.passThrough
  ///     )
  ///   )
  /// ));
  /// ```
  ///
  /// ## Example 3
  ///
  /// ```dart
  /// BackgroundGeolocation.ready(Config(
  ///   geolocation: GeoConfig(
  ///     filter: LocationFilter(
  ///       policy: LocationFilterPolicy.conservative
  ///     )
  ///   )
  /// ));
  /// ```
  final LocationFilterPolicy? policy;

  /// Has no effect on delivered locations. Defaults to `true`.
  ///
  /// The SDK records and delivers every accepted location with its original
  /// coordinates. This flag switches a smoothing stage on the tracking path whose
  /// output changes neither the locations the SDK records nor the filter's
  /// decisions; it is kept so existing configurations stay valid. The odometer's
  /// own filter is switched by `odometerUseKalmanFilter`.
  final bool? useKalman;

  /// Logs the odometer filter's values for each location. Defaults to `false`.
  ///
  /// When enabled, each location the odometer sees adds one line to the SDK log at
  /// the [LogLevel.debug] level: the filter's status, the distance added, the profile and
  /// gain in force, the speed that set the gain, the prediction and update terms,
  /// the distance to the anchor and the hold radius, and the filtered position's
  /// own accuracy. Keep it off in production: it is one line per location.
  final bool? kalmanDebug;

  /// Selects how strongly the odometer smooths the path while the device moves
  /// slowly. Defaults to `KalmanProfile.defaultProfile`.
  ///
  /// The odometer integrates a filtered position rather than the raw fixes. The
  /// profile sets how closely that position follows each fix: `aggressive` follows
  /// the fixes most, `conservative` smooths most and cuts the most corners,
  /// `defaultProfile` sits between.
  ///
  /// - At riding and driving speed the three profiles agree. They differ at walking
  ///   pace, between about 1 and 3 m/s, mostly with `distanceFilter: 0`, where every
  ///   fix reaches the odometer. Below about 1 m/s the SDK's stationary detection
  ///   decides and the three read the same.
  /// - `conservative` can read 20 to 50 % short on short back-and-forth paths such
  ///   as store aisles and corridors.
  /// - How much a profile smooths depends on the accuracy each device reports, so
  ///   the same profile smooths two devices differently.
  /// - When parked, the profiles do not differ in the expected order:
  ///   `conservative` can add the most distance at a stop.
  /// - When the device reports no speed, the three read the same, and
  ///   back-and-forth movement within a few tens of meters (about 45 m at a
  ///   reported accuracy of 10 m) is not counted.
  /// - Under the default `distanceFilter` the difference between profiles is a
  ///   fraction of a percent.
  ///
  /// The profile applies only to the odometer. It changes neither which locations
  /// are recorded nor their coordinates.
  final KalmanProfile? kalmanProfile;

  /// Number of samples in the rolling window used for burst averaging.
  ///
  /// Higher values increase smoothing but add latency. Defaults to `5` when not specified.
  final int? rollingWindow;

  /// Duration (in seconds) of each burst window used for averaging samples.
  ///
  /// The plugin groups locations received within this window into a single
  /// averaged point. Defaults to `10` seconds when not specified.
  final double? burstWindow;

  /// Maximum distance (in meters) between samples considered part of the same burst.
  ///
  /// Prevents merging widely separated samples into a single average.
  /// Defaults to `300` when not specified.
  final double? maxBurstDistance;

  /// Minimum acceptable accuracy (in meters) for a sample to be used in tracking.
  ///
  /// Locations less accurate than this threshold will be ignored.
  /// Defaults to `100` when not specified.
  final double? trackingAccuracyThreshold;

  /// Maximum implied speed (in m/s) allowed before rejecting a location.
  ///
  /// Samples that would imply a speed greater than this value are ignored
  /// as unrealistic outliers. Defaults to `60` (~216 km/h) when not specified.
  final double? maxImpliedSpeed;

  /// Enables verbose debug logging for the filtering engine.
  ///
  /// When `true`, detailed “ACCEPTED / REJECTED / IGNORED” decisions will
  /// appear in logs.
  final bool? filterDebug;

  /// Switches the odometer's position filter. Defaults to `true`.
  ///
  /// `true`: the odometer integrates filtered positions. Every fix the tracking
  /// filter accepts goes through a position filter whose gain follows the fix's own
  /// speed, selected by `kalmanProfile`, and the odometer adds the distance between
  /// the positions it last added to. `false`: the odometer integrates the fixes
  /// themselves, with the same accuracy gate, gaps and stops.
  ///
  /// Neither setting changes the recorded locations, and neither reproduces the
  /// odometer of earlier versions. [LocationFilter.useKalman] is independent
  /// of this flag and has no effect on delivered locations.
  final bool? odometerUseKalmanFilter;

  /// Maximum horizontal accuracy (in meters) allowed to affect the odometer.
  ///
  /// Samples with `accuracy > odometerAccuracyThreshold` are ignored for
  /// odometer updates. Defaults to `20` when not specified.
  final double? odometerAccuracyThreshold;

  /// Filtering policy applied to odometer-relevant samples, independent of [policy].
  ///
  /// Controls how the odometer handles anomalous GPS samples (teleports,
  /// unrealistic speed jumps):
  ///
  /// - [LocationFilterPolicy.passThrough] — no filtering; every sample contributes.
  /// - [LocationFilterPolicy.adjust] — anomalous samples are capped but still
  ///   accumulated. *(Default)*
  /// - [LocationFilterPolicy.conservative] — anomalous samples are **rejected
  ///   entirely**, eliminating phantom distance from GPS teleports.
  ///
  /// On devices with poor GPS behaviour the default `adjust` policy can
  /// accumulate significant phantom distance from repeatedly capped anomalies.
  /// Use `conservative` when distance integrity matters more than capturing
  /// every meter of movement. Defaults to `adjust` when not specified.
  final LocationFilterPolicy? odometerPolicy;

  const LocationFilter({
    this.policy,
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
    this.odometerPolicy,
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
        if (odometerPolicy != null) 'odometerPolicy': odometerPolicy!.index,
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
            m['trackingAccuracyThreshold'] ?? m['accuracyThreshold']),
        maxImpliedSpeed: _ensureDouble(m['maxImpliedSpeed']),
        filterDebug: _ensureBool(m['filterDebug']),
        odometerUseKalmanFilter: _ensureBool(m['odometerUseKalmanFilter']),
        odometerAccuracyThreshold:
            _ensureDouble(m['odometerAccuracyThreshold']),
        odometerPolicy: (m['odometerPolicy'] != null)
            ? LocationFilterPolicy.values[m['odometerPolicy']]
            : null,
      );
}
