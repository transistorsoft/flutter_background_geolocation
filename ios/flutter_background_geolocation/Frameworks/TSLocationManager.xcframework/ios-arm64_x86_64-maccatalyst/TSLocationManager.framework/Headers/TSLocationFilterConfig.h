//
//  TSLocationFilterConfig.h
//  TSLocationManager
//
//  Created by Christopher Scott on 2025-09-10.
//  Copyright © 2025 Christopher Scott. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "TSConfigModuleBase.h"
#import "TSKalmanProfile.h"       // TSKalmanProfile
#import "TSLocationFilterPolicy.h"     // TSLocationFilterPolicy
#import <CoreLocation/CoreLocation.h>   // CLLocationAccuracy

NS_ASSUME_NONNULL_BEGIN

/**
 TSFilterConfig
 --------------
 A dedicated configuration module for the SDK’s on-device *pre-filter* of CLLocation
 samples. The filter’s goal is to reduce “spiky” GPS noise, cap implausible jumps,
 and optionally smooth distance/odometer deltas with a lightweight Kalman filter.

 Where it fits
 • This module is nested under `geolocation.filter` (see `TSGeolocationConfig`).
 • It affects distance deltas used by odometer/tracking, not raw CLLocation delivery.
 • All thresholds are enforced before the Kalman smoother (when enabled) and again
   via conservative policy rules to prevent implausible bursts.

 Quick start
 • Leave defaults for most apps.
 • If you see jittery odometer: set `useKalman=YES` and keep `policy=Adjust`.
 • If you see rare huge jumps: lower `maxBurstDistance` or switch `policy=Conservative`.
 • For aggressive motion apps (e.g., bikes), raise `maxImpliedSpeed`.

 Diagrams used below
  distance jump (Δd) vs time (t)
      Δd
      │           . spike
      │        .´
      │     .´
      │  .´
      └────────────────── t →
         ^ df (distanceFilter)
 The filter caps large spikes (relative to df & moving averages) and can smooth deltas.
 */
@interface TSLocationFilterConfig : TSConfigModuleBase

/**
 Enables the Kalman smoother for distance deltas.

 What it does
 • When `YES`, the filter passes each per-sample delta through a 1‑D Kalman filter
   tuned by current speed, accuracy, and the active `distanceFilter`. This reduces
   small oscillations and softens noisy segments.

 Defaults / Range
 • Default: YES
 • Type: BOOL

 Interactions
 • Tuning is further controlled by `kalmanProfile`.
 • Policy rules (e.g., conservative caps) are still applied after smoothing.

 Example
 • Pedestrian app with jittery odometer:
     set `useKalman=YES` → odometer growth is steadier, fewer tiny oscillations.

 Diagnostics
 • Enable `kalmanDebug` to export internal Kalman metrics (gain, Q/R, NIS trends).
 */
@property (nonatomic, assign) BOOL useKalman;

/**
 Selects a preset for Kalman tuning.

 What it does
 • Chooses process/measurement noise presets appropriate for activity regimes.
 • Profiles are defined by `TSKalmanProfile` (e.g., Default / Aggressive / Conservative).

 Defaults / Range
 • Default: `TSKalmanProfileDefault`
 • Type: `TSKalmanProfile`

 Interactions
 • Effective only if `useKalman=YES`.
 • Higher-aggressiveness increases smoothing but adds lag to real motion changes.

 Example
 • Scooter app at urban speeds:
     `kalmanProfile=TSKalmanProfileAggressive` → smooths stop‑and‑go jitter more.

 Support tip
 • If movements feel “laggy”, try `TSKalmanProfileDefault` with `useKalman=YES`.
 */
@property (nonatomic, assign) TSKalmanProfile kalmanProfile;

/**
 High-level decision policy for handling dubious deltas.

 What it does
 • `PassThrough`   : never reject; compute stats only.
 • `Adjust`        : accept but cap overly large deltas (preferred default).
 • `Conservative`  : reject clearly implausible bursts and cap others.

 Defaults / Range
 • Default: `TSLocationFilterPolicyConservative`
 • Type: `TSLocationFilterPolicy`

 Diagram
   raw delta vs cap:
     Δd
     │      x  raw
     │     ─┬──────── cap
     │      │ capped → accepted/adjusted
     └─────────────── t →

 Examples
 • Fitness app prioritizing every meter:
     `policy=PassThrough`.
 • Fleet app avoiding spikes:
     `policy=Conservative`.

 Diagnostics
 • Inspect `TSFilterResult.decision` & `reason` when `filterDebug=YES`.
 */
@property (nonatomic, assign) TSLocationFilterPolicy policy;

/**
 Maximum allowed implied speed before treatment as an anomaly.

 Definition
 • Implied speed = delta distance / delta time between samples (m/s).

 Defaults / Range
 • Units: meters/second
 • Default: 60
 • Valid range: 1 … 200 (values are clamped internally)

 Behavior
 • If `impliedSpeed &gt; maxImpliedSpeed`, the delta is pre-capped (and possibly rejected
   in `Conservative` policy). This primarily protects against timestamp gaps or GPS jumps.

 Diagram
   Δd/Δt (speed) threshold
     speed
       │       ▲ anomaly
       │       │
       │───────┘ threshold (= maxImpliedSpeed)
       └───────────────── t →

 Example
 • High‑speed vehicle tracking:
     set `maxImpliedSpeed=90` (m/s ≈ 324 km/h) for race telemetry.

 Tip
 • If you log frequent anomalies with realistic travel, raise this value.
 */
@property (nonatomic, assign) double maxImpliedSpeed;

/**
 Cap for a single-step “burst” distance over a short window.

 Definition
 • If a single delta exceeds `maxBurstDistance` **and** occurs within `burstWindow`
   seconds, it is treated as a burst and capped/possibly rejected by policy.

 Defaults / Range
 • Units: meters
 • Default: 300
 • Valid range: 5 … 2000

 Diagram
   raw distance vs burst cap within window (w = burstWindow)
     Δd
     │         x spike  (Δt ≤ w)
     │        /
     │  cap ─┼──────────────
     └─────────────────── t →

 Example
 • Urban driving amid multipath reflections:
     reduce to `200` to curb rare building-reflection jumps.

 Interaction
 • Works alongside `maxImpliedSpeed`; whichever flags first applies.
 */
@property (nonatomic, assign) double maxBurstDistance;

/**
 Time window paired with `maxBurstDistance` for detecting bursts.

 Defaults / Range
 • Units: seconds
 • Default: 10
 • Valid range: 0.2 … 120  (values are clamped internally)

 Example
 • If you receive samples at ~1 Hz and occasionally see 1000 m spikes appearing
   in &lt; 2 seconds, set `burstWindow=3` so `maxBurstDistance` rules catch them.

 Notes
 • Very small windows may let longer bursts pass; very large windows may cap
   legitimate travel when reports are infrequent.
 */
@property (nonatomic, assign) double burstWindow;

/**
 Rolling window size used by the adaptive cap and smoothing helpers.

 What it does
 • Maintains a short history of recent (already filtered) deltas to estimate a
   “typical” step size; the cap scales with this rolling average.

 Defaults / Range
 • Units: count of recent samples
 • Default: 5
 • Valid range: 3 … 20

 Diagram
   rolling mean (avg of last N deltas)
     Δd
     │   • • • • •   &lt;— N = rollingWindow
     └───────────── t →

 Example
 • If your sampling rate is high and motion is smooth, raising to `7–9` makes
   the cap a bit more stable; for bursty motion, keep `5`.
 */
@property (nonatomic, assign) NSInteger rollingWindow;

/**
 Use a Kalman filter for the odometer integrator (independent of per-step smoothing).

 What it does
 • When `YES`, the odometer accumulation itself uses a Kalman-smoothed signal,
   further reducing long-term drift.

 Defaults / Range
 • Default: YES
 • Type: BOOL

 Interactions
 • Works well with `useKalman=YES` for per-step deltas, but can also be used alone.

 Example
 • Long hikes with moderate GPS variation:
     `odometerUseKalmanFilter=YES` → odometer totals fluctuate less over hours.
 */
@property (nonatomic, assign) BOOL odometerUseKalmanFilter;

/**
 Accuracy threshold applied by the odometer filter.

 What it does
 • Deltas whose horizontalAccuracy exceeds this value may be down‑weighted or
   rejected by the odometer’s TSLocationFilter (depending on policy).

 Defaults / Range
 • Units: meters (CLLocationAccuracy)
 • Default: 20
 • Valid range: 0 … 500 (values are clamped internally)
 */
@property (nonatomic, assign) CLLocationAccuracy odometerAccuracyThreshold;

/**
 Accuracy threshold applied by the breadcrumb/tracking filter.

 What it does
 • Deltas whose horizontalAccuracy exceeds this value may be down‑weighted or
   rejected by the tracking TSLocationFilter (depending on policy).

 Defaults / Range
 • Units: meters (CLLocationAccuracy)
 • Default: 100
 • Valid range: 0 … 500 (values are clamped internally)
 */
@property (nonatomic, assign) CLLocationAccuracy accuracyThreshold;

/**
 Enables verbose logging for the filter state machine.

 What it logs
 • Per-sample metrics (raw/effective/selected/caps), decisions (accept/adjust/reject),
   and reasons (accuracy, implied speed, kinematic/distanceFilter caps).

 Defaults / Range
 • Default: NO
 • Type: BOOL

 Example
 • Set `filterDebug=YES` during field trials to capture why deltas were capped.

 Tip
 • Combine with app-level logging controls (`TSLogLevel`) to surface these lines.
 */
@property (nonatomic, assign) BOOL filterDebug;

/**
 Enables debug output and diagnostics for the Kalman smoother.

 What it logs
 • Internal Kalman parameters (Q/R), gain, residuals, and NIS stability.
 • Can export CSV via `TSKalmanFilter exportDiagnosticsToCSV:` for offline analysis.

 Defaults / Range
 • Default: NO
 • Type: BOOL

 Example
 • To tune `kalmanProfile` for a new vehicle class:
     set `useKalman=YES`, `kalmanDebug=YES`, collect a route, export CSV and inspect.
 */
@property (nonatomic, assign) BOOL kalmanDebug;
@end

NS_ASSUME_NONNULL_END
