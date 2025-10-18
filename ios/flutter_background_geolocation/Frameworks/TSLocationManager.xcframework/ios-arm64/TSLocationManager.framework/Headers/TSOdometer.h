//
//  TSOdometer.h
//  TSLocationManager
//
//  Created by Christopher Scott on 2025-08-30.
//  Copyright © 2025 Christopher Scott. All rights reserved.
//
/*
TSOdometer + TSKalmanFilter — Data Flow (high level)

 ┌─────────────────────────────────────────────────────────────────────┐
 │                            TSOdometer                               │
 └─────────────────────────────────────────────────────────────────────┘
              updateWithLocation(CLLocation loc, distanceFilter df)
                                      │
                                      ▼
                         ┌─────────────────────────┐
                         │ Guard rails / early-out │
                         │ • config.enabled?       │
                         │ • loc.accuracy >= 0?    │
                         │ • desiredOdometerAccuracy ok?
                         │ • have lastLocation?    │
                         └─────────────┬───────────┘
                                       │
                                       ▼
                         ┌─────────────────────────┐
                         │  Compute deltas         │
                         │  raw = dist(loc, last)  │
                         │  err = √(acc₁²+acc₀²)   │
                         │  eff = raw - err        │
                         └─────────────┬───────────┘
                                       │
                                       ▼
                         ┌─────────────────────────┐
                         │  Hybrid selection       │
                         │  if loc.accuracy ≤ 10m  │
                         │     delta = raw         │
                         │  else                   │
                         │     delta = eff         │
                         └─────────────┬───────────┘
                                       │
                     ┌─────────────────┴─────────────────┐
                     │                                   │
                     ▼                                   ▼
        ┌────────────────────────────┐        ┌──────────────────────────────┐
        │ if useKalmanFilter == NO   │        │ if useKalmanFilter == YES    │
        │ filtered = delta           │        │ • ensure filter exists       │
        │                            │        │ • filter.configure(          │
        │                            │        │     speed=loc.speed,         │
        │                            │        │     accuracy=loc.accuracy,   │
        │                            │        │     distanceFilter=df )      │
        │                            │        │ • filtered = filter.process( │
        │                            │        │     delta, accuracy )        │
        └───────────────┬────────────┘        └───────────────┬──────────────┘
                        │                                     │
                        └───────────────┬─────────────────────┘
                                        ▼
                         ┌─────────────────────────┐
                         │  Rolling average (N=5)  │
                         │  avg = mean(recent)     │
                         │  Outlier reject if      │
                         │    filtered > 3×avg OR  │
                         │    filtered > 3×df      │
                         └─────────────┬───────────┘
                                       │
                                       ▼
                         ┌─────────────────────────┐
                         │  Accumulate             │
                         │  config.increment(filtered)
                         │  lastLocation = loc     │
                         │  odometerError = √Σ(acc²)
                         │  persist lastLocation   │
                         └─────────────────────────┘


 ┌─────────────────────────────────────────────────────────────────────┐
 │                           TSKalmanFilter                            │
 └─────────────────────────────────────────────────────────────────────┘
     configureForSpeed(speed, accuracy, df)
       • R ← clamp(accuracy², 4 … 10,000)              (measurement noise var)
       • Q ← clamp(max(0.3·df, baseBySpeed)², 0.1 … 400) (process noise var)

     process(measurement=delta, accuracy)
       • Rm = (accuracy > 0) ? accuracy² : R
       • residual r = measurement − estimate
       • S = P + Rm
       • gain K = P / S
       • estimate ← estimate + K·r
       • P ← (1−K)·P + Q
       • Adaptive R (NIS): nis = r² / max(S, ε)
           if nis > 1.2 → R *= (1+α)
           if nis < 0.8 → R *= (1−α)         (α≈0.02)
       • record diagnostics (measurement, accuracy, gain, Q, R, r, S, nis)
       • return estimate   // used as filtered delta in TSOdometer
*/

// Note: TSOdometer is the source-of-truth for odometer value and error,
// persisting lastLocation, odometer, and odometerError.

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "TSLocationTypes.h"

#import "TSTrackingMode.h"

@class TSCurrentPositionRequest;
@class TSLocationFilterResult;
@class TSLocationMetrics;
@class TSConfig;

NS_ASSUME_NONNULL_BEGIN

@interface TSOdometer : NSObject

@property (nonatomic, assign) BOOL useKalmanFilter;
@property (nonatomic, assign) BOOL debug;
@property (nonatomic, assign, readonly) CLLocationDistance odometer;
@property (nonatomic, assign, readonly) CLLocationDistance odometerError;
@property (nonatomic, strong, readonly) CLLocation* lastLocation;

+ (instancetype)sharedInstance;

- (void)configure:(TSConfig*)config;
- (void)start:(TSTrackingMode)mode;
- (void)reset;

- (void)setOdometer:(CLLocationDistance)odometer
            request:(TSCurrentPositionRequest*)request;

- (TSLocationFilterResult*)evaluateLocation:(CLLocation*)location
                    type:(TSLocationType)type
             withMetrics:(TSLocationMetrics *)metrics;

- (void)onMotionChange:(BOOL)isMoving;
                       
- (void)persist;
- (void)exportDiagnosticsToCSV:(NSString *)filename;

@end

NS_ASSUME_NONNULL_END

