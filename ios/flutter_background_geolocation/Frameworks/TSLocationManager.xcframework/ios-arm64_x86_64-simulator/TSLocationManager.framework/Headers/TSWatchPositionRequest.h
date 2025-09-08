//
//  TSWatchPositionRequest.h
//  TSLocationManager
//
//  Created by Christopher Scott on 2018-02-12.
//  Copyright © 2018 Transistor Software. All rights reserved.
//
#import "TSLocationEvent.h"
#import "TSLocationStreamEvent.h"

NS_ASSUME_NONNULL_BEGIN

/// A proxy object used by SDK consumers to configure a continuous
/// position stream ("watchPosition"). This will internally drive
/// TSLocationRequestService with kCLDistanceFilterNone.
@interface TSWatchPositionRequest : NSObject

/// Desired horizontal accuracy is fixed to Best for watch mode.
@property (nonatomic, assign) CLLocationAccuracy desiredAccuracy; // kCLLocationAccuracyBest

/// Interval between emitted location events (milliseconds). Minimum enforced.
@property (nonatomic, assign) double interval;

/// Whether each emitted TSLocationEvent should be persisted.
@property (nonatomic, assign) BOOL persist;

/// User-defined metadata to merge into each emitted payload.
@property (nonatomic, copy, nullable) NSDictionary *extras;

/// Hard timeout for the watch session (seconds). 0 = no timeout.
@property (nonatomic, assign) NSTimeInterval timeout;

/// Success callback for each emitted TSLocationEvent.
@property (nonatomic, copy, nullable) void (^success)(TSLocationStreamEvent *event);

/// Failure callback for terminal errors.
@property (nonatomic, copy, nullable) void (^failure)(NSError *error);

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/// Convenience constructor with callbacks. Uses defaults for interval, persist, timeout.
+ (instancetype)requestWithSuccess:(nullable void (^)(TSLocationStreamEvent *event))success
                           failure:(nullable void (^)(NSError *error))failure
NS_SWIFT_NAME(make(success:failure:));

/// Convenience constructor specifying interval (ms) and callbacks.
+ (instancetype)requestWithInterval:(double)interval
                            success:(nullable void (^)(TSLocationStreamEvent *event))success
                            failure:(nullable void (^)(NSError *error))failure
NS_SWIFT_NAME(make(interval:success:failure:));

/// Designated initializer mirroring configurable fields. Parameter order
/// aligns with TSCurrentPositionRequest style (timing first, then flags, then metadata, then callbacks).
- (instancetype)initWithInterval:(double)interval
                          timeout:(NSTimeInterval)timeout
                           persist:(BOOL)persist
                            extras:(nullable NSDictionary *)extras
                           success:(nullable void (^)(TSLocationStreamEvent *event))success
                           failure:(nullable void (^)(NSError *error))failure NS_DESIGNATED_INITIALIZER
NS_SWIFT_NAME(make(interval:timeout:persist:extras:success:failure:));


@end

NS_ASSUME_NONNULL_END
