//
//  TSCurrentPositionRequest.h
//  TSLocationManager
//
//  Created by Christopher Scott on 2025-08-21.
//  Copyright © 2025 Christopher Scott.
//


#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "TSLocationEvent.h"
#import "TSLocationTypes.h"

NS_ASSUME_NONNULL_BEGIN

/// A public, minimal proxy for configuring a one-shot position request that
/// internally maps to an internal TSSingleLocationRequest.
/// Returns TSLocationEvent (not TSLocation) in callbacks.
@interface TSCurrentPositionRequest : NSObject

/// Location request type. Defaults to TSLocationTypeCurrent.
@property (nonatomic, assign) TSLocationType type;

/// Maximum acceptable age (in milliseconds) for a cached location. 0 = must be fresh.
@property (nonatomic, assign) NSInteger maximumAge;

/// Hard timeout (in seconds) for the request.
@property (nonatomic, assign) NSTimeInterval timeout;

/// Desired horizontal accuracy (in meters). Use kCLLocationAccuracy* constants or a numeric value.
@property (nonatomic, assign) CLLocationAccuracy desiredAccuracy;

/// Number of samples to consider before deciding success (>=1).
@property (nonatomic, assign) NSInteger samples;

/// Allow returning a stale cached fix (subject to maximumAge).
@property (nonatomic, assign) BOOL allowStale;

/// Whether to persist the resulting TSLocationEvent to storage.
@property (nonatomic, assign) BOOL persist;

/// Optional diagnostic label to tag the request.
@property (nonatomic, copy, nullable) NSString *label;

/// User-provided extras merged into the resulting payload.
@property (nonatomic, copy, nullable) NSDictionary<NSString *, id> *extras;

/// Success callback (non-null event).
@property (nonatomic, copy, nullable) void (^success)(TSLocationEvent * _Nonnull event);

/// Failure callback (non-null error).
@property (nonatomic, copy, nullable) void (^failure)(NSError * _Nonnull error);

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/// Convenience constructor with explicit type and callbacks.
/// Swift name: TSCurrentPositionRequest.make(type:success:failure:)
+ (instancetype)requestWithType:(TSLocationType)type
                        success:(nullable void (^)(TSLocationEvent * _Nonnull event))success
                        failure:(nullable void (^)(NSError * _Nonnull error))failure
NS_SWIFT_NAME(make(type:success:failure:));

/// Convenience constructor defaulting to TSLocationTypeCurrent.
/// Swift name: TSCurrentPositionRequest.make(success:failure:)
+ (instancetype)requestWithSuccess:(nullable void (^)(TSLocationEvent * _Nonnull event))success
                           failure:(nullable void (^)(NSError * _Nonnull error))failure
NS_SWIFT_NAME(make(success:failure:));

/// Full constructor mirroring the internal request’s configurable fields.
/// Swift name preserved for nice labels.
- (instancetype)initWithType:(TSLocationType)type
                  maximumAge:(NSInteger)maximumAge
                     timeout:(NSTimeInterval)timeout
             desiredAccuracy:(CLLocationAccuracy)desiredAccuracy
                  allowStale:(BOOL)allowStale
                     samples:(NSInteger)samples
                       label:(nullable NSString *)label
                     persist:(BOOL)persist
                      extras:(nullable NSDictionary<NSString *, id> *)extras
                     success:(nullable void (^)(TSLocationEvent * _Nonnull event))success
                     failure:(nullable void (^)(NSError * _Nonnull error))failure NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
