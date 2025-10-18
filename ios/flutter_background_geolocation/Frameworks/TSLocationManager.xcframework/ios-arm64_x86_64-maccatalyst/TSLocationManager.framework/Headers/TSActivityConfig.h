//
//  TSActivityConfig.h
//  TSLocationManager
//
//  Created by Christopher Scott on 2025-09-05.
//  Copyright © 2025 Christopher Scott. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "TSConfigModuleBase.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Activity recognition configuration module for motion detection and activity-based behavior.
 * Controls how the SDK detects device motion, stops, and responds to different activity types.
 */
@interface TSActivityConfig : TSConfigModuleBase

#pragma mark - Activity Recognition

/**
 * Delay in seconds before detecting that device has stopped moving.
 * Helps filter out brief stops (traffic lights, etc.).
 * Default: 0 seconds
 */
@property (nonatomic) NSTimeInterval stopDetectionDelay;

/**
 * Interval in milliseconds for activity recognition updates.
 * How often the SDK checks device motion state.
 * Default: 10000 (10 seconds)
 */
@property (nonatomic) NSTimeInterval activityRecognitionInterval;

/**
 * Minimum confidence level (0-100) required for activity recognition.
 * Higher values require more certainty but may miss some activities.
 * Default: 70
 */
@property (nonatomic) NSInteger minimumActivityRecognitionConfidence;

#pragma mark - Motion Detection Controls

/**
 * Disable iOS Core Motion activity updates entirely.
 * When YES, the SDK won't use accelerometer/gyroscope data.
 * Default: NO
 */
@property (nonatomic) BOOL disableMotionActivityUpdates;

/**
 * Disable automatic stop detection based on motion.
 * When YES, the SDK won't automatically detect when device stops.
 * Default: NO
 */
@property (nonatomic) BOOL disableStopDetection;

/**
 * Automatically stop location tracking when device becomes stationary.
 * More aggressive battery saving but may miss movement resumption.
 * Default: NO
 */
@property (nonatomic) BOOL stopOnStationary;

/**
 * Comma-separated list of activity types that trigger location tracking.
 * e.g., "walking,running,automotive"
 * Default: "" (empty string - all activities)
 */
@property (nonatomic, copy) NSString *triggerActivities;

#pragma mark - Utility Methods

/**
 * Check if current configuration uses motion detection.
 */
- (BOOL)usesMotionDetection;

/**
 * Check if current configuration has aggressive battery saving enabled.
 */
- (BOOL)hasAggressiveBatterySaving;

- (BOOL)hasTriggerActivities;

@end

NS_ASSUME_NONNULL_END

