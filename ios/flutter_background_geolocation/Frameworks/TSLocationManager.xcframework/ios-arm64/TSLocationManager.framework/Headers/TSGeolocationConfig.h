//
//  TSGeolocationConfig.h
//  TSLocationManager
//
//  Created by Christopher Scott on 2025-09-05.
//  Copyright © 2025 Christopher Scott. All rights reserved.
//


//
//  TSGeolocationConfig.h
//  TSLocationManager
//
//  Created by Christopher Scott on 2025-01-XX.
//  Copyright © 2025 Transistor Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "TSConfigModuleBase.h"
#import "TSLocationFilterConfig.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Geolocation configuration module for location tracking behavior.
 * Contains all properties related to GPS accuracy, location filtering,
 * authorization, and geofencing.
 */
@interface TSGeolocationConfig : TSConfigModuleBase

#pragma mark - CoreLocation Properties

/**
 * Desired location accuracy in meters.
 * GPS is only used when set to kCLLocationAccuracyBest or kCLLocationAccuracyBestForNavigation.
 * Default: kCLLocationAccuracyBest
 */
@property (nonatomic) CLLocationAccuracy desiredAccuracy;

/**
 * Minimum distance in meters that must be traveled before a location is recorded.
 * Default: 10 meters
 */
@property (nonatomic) CLLocationDistance distanceFilter;

/**
 * Use iOS Significant Location Changes instead of continuous GPS.
 * More battery efficient but less accurate. Typically 100-500m accuracy.
 * Default: NO
 */
@property (nonatomic) BOOL useSignificantChangesOnly;

/**
 * Allow iOS to automatically pause location updates when device is stationary.
 * Default: YES
 */
@property (nonatomic) BOOL pausesLocationUpdatesAutomatically;

/**
 * Show the iOS blue status bar indicator when using location in background.
 * Only applies when locationAuthorizationRequest is "Always".
 * Default: YES
 */
@property (nonatomic) BOOL showsBackgroundLocationIndicator;

/**
 * Type of activity the device is expected to be engaged in.
 * Optimizes location accuracy and battery usage for the activity type.
 * Default: CLActivityTypeOther
 */
@property (nonatomic) CLActivityType activityType;

/**
 * Maximum time in seconds to wait for a location before giving up.
 * Default: 60 seconds
 */
@property (nonatomic) NSTimeInterval locationTimeout;

#pragma mark - Elasticity & Motion Detection

/**
 * Time in minutes after device stops before entering stationary mode.
 * In stationary mode, GPS may be turned off to save battery.
 * Default: 5 minutes
 */
@property (nonatomic) NSTimeInterval stopTimeout;

/**
 * Radius in meters around the device's current position that defines "stationary".
 * When device is stationary, GPS may be turned off to save battery.
 * Default: 25 meters
 */
@property (nonatomic) CLLocationDistance stationaryRadius;

/**
 * Automatically stop location tracking after this many minutes.
 * Set to -1 to disable automatic stopping.
 * Default: -1 (disabled)
 */
@property (nonatomic) NSTimeInterval stopAfterElapsedMinutes;

/**
 * Disable the elasticity algorithm that adjusts accuracy based on device speed.
 * When NO, the SDK automatically increases accuracy when device is moving faster.
 * Default: NO
 */
@property (nonatomic) BOOL disableElasticity;

/**
 * Multiplier for the elasticity algorithm.
 * Higher values make the algorithm more aggressive in adjusting accuracy.
 * Default: 1.0
 */
@property (nonatomic) double elasticityMultiplier;

#pragma mark - Location Authorization

/**
 * Type of location authorization to request from iOS.
 * Valid values: "Always", "WhenInUse"
 * Default: "Always"
 */
@property (nonatomic, copy) NSString *locationAuthorizationRequest;

/**
 * Disable the location authorization alert dialog.
 * When YES, the SDK will not show permission prompts.
 * Default: NO
 */
@property (nonatomic) BOOL disableLocationAuthorizationAlert;

/**
 * Custom strings for the location authorization alert dialog.
 * Contains title, message, and button text for the authorization prompt.
 * Default: System-provided strings
 */
@property (nonatomic, copy) NSDictionary *locationAuthorizationAlert;

#pragma mark - Geofencing

/**
 * Radius in meters for geofence proximity detection.
 * The SDK will begin monitoring for geofence entry/exit when within this distance.
 * Default: 2000 meters
 */
@property (nonatomic) CLLocationDistance geofenceProximityRadius;

/**
 * Trigger geofence entry event when adding a geofence and device is already inside.
 * When YES, immediately fires entry event if device is already within geofence.
 * Default: YES
 */
@property (nonatomic) BOOL geofenceInitialTriggerEntry;

#pragma mark - Metadata

/**
 * Include timestamp metadata in location objects.
 * Adds additional timing information for debugging and analysis.
 * Default: NO
 */
@property (nonatomic) BOOL enableTimestampMeta;

/**
 * Nested TSLocationFilter TSConfigModule
 */
@property (nonatomic, strong, readonly) TSLocationFilterConfig *filter;


#pragma mark - Utility Methods

/**
 * Convert activity type to human-readable string.
 */
+ (NSString *)stringForActivityType:(CLActivityType)activityType;

/**
 * Convert string to CLActivityType enum value.
 */
+ (CLActivityType)activityTypeFromString:(NSString *)activityString;

/**
 * Get location authorization alert strings with interpolated values.
 * Replaces placeholders like {locationAuthorizationRequest} with actual values.
 * 
 * @return Dictionary with interpolated alert strings
 */
- (NSDictionary *)getLocationAuthorizationAlertStrings;

/**
 * Check if the current configuration requests "Always" authorization.
 * 
 * @return YES if locationAuthorizationRequest is "Always"
 */
- (BOOL)requestsAlwaysAuthorization;

/**
 * Check if the current configuration uses high accuracy GPS.
 * 
 * @return YES if desiredAccuracy requires GPS (Best or BestForNavigation)
 */
- (BOOL)usesHighAccuracyGPS;

/**
 * Get the CLLocationAccuracy value from a numeric accuracy setting.
 * Converts numeric values to appropriate CLLocationAccuracy constants.
 * 
 * @param accuracy Numeric accuracy value (e.g., -1, 10, 100, 1000)
 * @return Corresponding CLLocationAccuracy constant
 */
+ (CLLocationAccuracy)decodeDesiredAccuracy:(NSNumber *)accuracy;

/**
 * Validate that geofence proximity radius meets iOS requirements.
 * iOS requires geofence radius to be at least 100 meters.
 * 
 * @return YES if geofenceProximityRadius is valid for iOS
 */
- (BOOL)hasValidGeofenceProximityRadius;


@end

NS_ASSUME_NONNULL_END
