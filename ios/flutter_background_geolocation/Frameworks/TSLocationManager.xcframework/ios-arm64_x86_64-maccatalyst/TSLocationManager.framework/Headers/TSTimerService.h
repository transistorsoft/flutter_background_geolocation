//
//  TSTimerService.h
//  TSLocationManager
//
//  Created by Christopher Scott on 2025-08-05.
//  Copyright © 2025 Christopher Scott. All rights reserved.
//


// TSTimerService.h
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TSTimerService : NSObject

@property (nonatomic, readonly) BOOL isRepeating;
@property (nonatomic, readonly) BOOL isRunning;

/// Seconds until the next scheduled fire.
/// Returns DBL_MAX if the timer is not running or no fire date is scheduled.
/// Never negative: clamps to 0 if the scheduled fire time has passed.
- (NSTimeInterval)timeUntilFire;

- (instancetype)initWithLabel:(nullable NSString *)label;

- (void)startWithInterval:(NSTimeInterval)interval
                repeating:(BOOL)repeating
                 callback:(dispatch_block_t)callback;

- (void)stop;

- (BOOL)hasExpired;

@end

NS_ASSUME_NONNULL_END
