//
//  TSApplicationConfig.h
//  TSLocationManager
//
//  Created by Christopher Scott on 2025-09-05.
//  Copyright © 2025 Christopher Scott. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "TSConfigModuleBase.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Application lifecycle configuration module for app behavior and debugging.
 * Controls startup behavior, background execution, scheduling, and debug settings.
 */
@interface TSAppConfig : TSConfigModuleBase

#pragma mark - Application Lifecycle

/**
 * Stop tracking when application terminates.
 * When NO, tracking continues in background after app termination.
 * Default: YES
 */
@property (nonatomic) BOOL stopOnTerminate;

/**
 * Automatically start tracking when device boots.
 * Only works if stopOnTerminate is NO.
 * Default: NO
 */
@property (nonatomic) BOOL startOnBoot;

/**
 * Prevent iOS from suspending the app in background.
 * Uses more battery but ensures continuous operation.
 * Default: NO
 */
@property (nonatomic) BOOL preventSuspend;

/**
 * Interval in seconds for heartbeat events in background.
 * Helps keep app alive and monitor background execution.
 * Default: 60 seconds
 */
@property (nonatomic) NSTimeInterval heartbeatInterval;

#pragma mark - Scheduling

/**
 * Array of schedule objects for automated start/stop times.
 * Each schedule object should contain time and day information.
 * Default: [] (empty array)
 */
@property (nonatomic, copy) NSArray *schedule;

#pragma mark - Utility Methods

/**
 * Check if any schedule is configured.
 */
- (BOOL)hasSchedule;

/**
 * Check if background execution is configured.
 */
- (BOOL)isBackgroundExecutionEnabled;

@end

NS_ASSUME_NONNULL_END
