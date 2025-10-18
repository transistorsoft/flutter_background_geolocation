//
//  TSConfig.h
//  TSLocationManager
//
//  Created by Christopher Scott on 2025-09-05.
//  Copyright © 2025 Christopher Scott. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
//#import "TSAuthorization.h"


#import "TSLocationTypes.h"
#import "TSConfigModule.h"
#import "TSHttpConfig.h"
#import "TSAuthorizationConfig.h"
#import "TSGeolocationConfig.h"
#import "TSPersistenceConfig.h"
#import "TSActivityConfig.h"
#import "TSAppConfig.h"
#import "TSLoggerConfig.h"
#import "TSTrackingMode.h"

NS_ASSUME_NONNULL_BEGIN

/**
The SDK's Configuration API with modular architecture.

This class provides a clean, organized approach to configuration management while maintaining
complete backward compatibility for cross-platform frameworks (React Native, Flutter, Cordova, Capacitor).

## Modular Organization
Configuration is organized into focused modules:
- http: Network requests and sync behavior
- geolocation: Location tracking and GPS settings
- persistence: Data storage and sync policies
- activity: Motion detection and activity recognition
- application: App lifecycle and debug settings
- authorization: HTTP authentication credentials

## Usage Patterns
```objc
// Modular approach (preferred)
config.http.url = @"https://api.example.com";
config.geolocation.desiredAccuracy = kCLLocationAccuracyBest;

// Cross-platform dictionaries (backward compatible)
[config updateWithDictionary:@{
    @"url": @"https://api.example.com",           // Routed to http module
    @"desiredAccuracy": @(-1)                     // Routed to geolocation module
}];

// Nested modules (preferred for cross-platform)
[config updateWithDictionary:@{
    @"http": @{@"url": @"https://api.example.com"},
    @"geolocation": @{@"desiredAccuracy": @(-1)}
}];
```

## Event System
Supports both flat and hierarchical event listening:
```objc
[config addListener:@"url" callback:^(id value) { ... }];        // Flat (legacy)
[config addListener:@"http.url" callback:^(id value) { ... }];   // Hierarchical (preferred)
```
 */
@interface TSConfig : NSObject <NSCoding>

#pragma mark - Singleton
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

#if DEBUG
/// Reset the singleton so a fresh instance is created on next +sharedInstance (TESTS ONLY).
+ (void)resetSharedInstanceForTests;

/// Route persistence to a dedicated suite (TESTS ONLY). Pass nil to clear override.
+ (void)useUserDefaultsSuiteForTests:(NSString * _Nullable)suiteName;

/// Disable on-disk persistence entirely (TESTS ONLY).
+ (void)disablePersistenceForTests:(BOOL)disabled;
#endif

/// Returns the singleton instance.
+ (TSConfig *)sharedInstance;
+ (NSUserDefaults *)userDefaults;
+(TSConfig*) decodeConfig:(id)data;

/**
 `YES` when the SDK is in the *location + geofence* tracking mode.
 `NO` when the SDK is in *geofences-only* tracking mode.
 */
- (BOOL)isLocationTrackingMode;

/**
 `YES` when this is the first launch after initial installation.
 */
- (BOOL)isFirstBoot;

/**
 `YES` when the application was launched in the background.
 */
- (BOOL)didLaunchInBackground;

#pragma mark - Configuration Modules

/**
 HTTP configuration module containing networking and sync-related properties.
 
 Access properties like:
 - config.http.url
 - config.http.headers
 - config.http.method
 - config.http.timeout
 */
@property (nonatomic, strong, readonly) TSHttpConfig *http;

/**
 Authorization configuration module containing networking and sync-related properties.
 
 Access properties like:
 - config.authorization.accessToke
 - config.authorization.refreshUrl

 */
@property (nonatomic, strong, readonly) TSAuthorizationConfig *authorization;

/**
 Geolocation configuration module containing location tracking properties.
 
 Access properties like:
 - config.geolocation.desiredAccuracy
 - config.geolocation.distanceFilter
 - config.geolocation.locationAuthorizationRequest
 - config.geolocation.geofenceProximityRadius
 */
@property (nonatomic, strong, readonly) TSGeolocationConfig *geolocation;

/**
 Persistence configuration module containing data storage and sync properties.
 
 Access properties like:
 - config.persistence.autoSync
 - config.persistence.maxDaysToPersist
 - config.persistence.persistMode
 */
@property (nonatomic, strong, readonly) TSPersistenceConfig *persistence;

/**
 Activity recognition configuration module containing motion detection properties.
 
 Access properties like:
 - config.activity.activityType
 - config.activity.stopTimeout
 - config.activity.minimumActivityRecognitionConfidence
 */
@property (nonatomic, strong, readonly) TSActivityConfig *activity;

/**
 Application lifecycle configuration module containing app behavior properties.
 
 Access properties like:
 - config.application.debug
 - config.application.startOnBoot
 - config.application.preventSuspend
 - config.application.logLevel
 */
@property (nonatomic, strong, readonly) TSAppConfig *app;

/**
 Application lifecycle configuration module containing app behavior properties.
 
 Access properties like:
 - config.application.debug
 - config.application.startOnBoot
 - config.application.preventSuspend
 - config.application.logLevel
 */
@property (nonatomic, strong, readonly) TSLoggerConfig *logger;


/**
 Authorization configuration module for HTTP authentication.
 
 Access properties like:
 - config.authorization.accessToken
 - config.authorization.strategy
 - config.authorization.refreshUrl
 */
/// TODO: @property (nonatomic, strong, readonly) TSAuthorization *authorization;

#pragma mark - State Properties

/**
 Is tracking currently enabled?
 */
@property (nonatomic) BOOL enabled;

/**
 Current motion state of the device (moving or stationary).
 */
@property (nonatomic) BOOL isMoving;

/**
 Is the scheduler currently enabled?
 */
@property (nonatomic) BOOL schedulerEnabled;

/**
 Current tracking mode (location or geofence-only).
 */
@property (nonatomic) TSTrackingMode trackingMode;

/**
 Last known location authorization status.
 */
@property (nonatomic) CLAuthorizationStatus lastLocationAuthorizationStatus;

/**
 Has iOS shown the location services disabled warning?
 */
@property (nonatomic) BOOL iOSHasWarnedLocationServicesOff;

/**
 Has the SDK requested location authorization upgrade?
 */
@property (nonatomic) BOOL didRequestUpgradeLocationAuthorization;

/**
 Was the app launched in the background?
 */
@property (nonatomic) BOOL didLaunchInBackground;

#pragma mark - Transition Control

/**
 Include deprecated flat properties in toDictionary output.
 
 When YES (default), toDictionary returns both modular and flat properties:
 ```json
 {
   "url": "https://api.example.com",           // Flat (deprecated)
   "desiredAccuracy": -1,                      // Flat (deprecated)
   "http": {"url": "https://api.example.com"}, // Modular (preferred)
   "geolocation": {"desiredAccuracy": -1}      // Modular (preferred)
 }
 ```
 
 When NO, only modular structure is included:
 ```json
 {
   "http": {"url": "https://api.example.com"},
   "geolocation": {"desiredAccuracy": -1}
 }
 ```
 
 Default: YES (to ease transition), will change to NO in future release.
 */
@property (nonatomic) BOOL includeDeprecatedPropertiesInDictionary;

#pragma mark - Configuration Update Methods

/**
 Update configuration from dictionary with intelligent property routing.
 
 Supports multiple input formats:
 
 1. Flat properties (backward compatible):
 ```objc
 [config updateWithDictionary:@{
     @"url": @"https://api.example.com",
     @"desiredAccuracy": @(-1),
     @"debug": @(YES)
 }];
 ```
 
 2. Nested modules (preferred):
 ```objc
 [config updateWithDictionary:@{
     @"http": @{@"url": @"https://api.example.com"},
     @"geolocation": @{@"desiredAccuracy": @(-1)},
     @"application": @{@"debug": @(YES)}
 }];
 ```
 
 3. Mixed format:
 ```objc
 [config updateWithDictionary:@{
     @"http": @{@"url": @"https://api.example.com"},
     @"desiredAccuracy": @(-1),  // Routed to geolocation module
     @"includeDeprecatedPropertiesInDictionary": @(NO)
 }];
 ```
 
 Properties are automatically routed to the correct module using the canHandleProperty: protocol method.
 Nested module objects are deep-merged, preserving existing properties.
 
 @param config Dictionary containing configuration updates
 */
- (void)updateWithDictionary:(NSDictionary *)config;

- (void)batchUpdate:(void(^)(TSConfig *config))block;

/**
 Reset all configuration to default values.
 Emits change events for all modified properties.
 */
- (void)reset;

#pragma mark - Event Listeners

/**
 Add a listener for configuration property changes.
 
 Supports both flat property names and hierarchical module.property names:
 
 ```objc
 // Flat property names (backward compatible)
 [config addListener:@"url" callback:^(id value) { ... }];
 [config addListener:@"desiredAccuracy" callback:^(id value) { ... }];
 
 // Hierarchical property names (preferred)
 [config addListener:@"http.url" callback:^(id value) { ... }];
 [config addListener:@"geolocation.desiredAccuracy" callback:^(id value) { ... }];
 
 // Module-level changes
 [config addListener:@"http" callback:^(id moduleDict) { ... }];
 ```
 
 @param property Property name to listen for
 @param block Callback block called when property changes
 @return Token for removing the listener
 */
- (NSString *)addListener:(NSString *)property callback:(void(^)(id))block;

/**
 Remove a specific listener by token.
 */
- (void)removeListener:(NSString *)token forProperty:(NSString *)property;

/**
 Remove all listeners for a specific property.
 */
- (void)removeAllListenersForProperty:(NSString *)property;

/**
 Remove all configuration listeners.
 */
- (void)removeAllListeners;

#pragma mark - Serialization

/**
 Returns a dictionary representation of all configuration.
 
 Format depends on includeDeprecatedPropertiesInDictionary setting:
 - When YES: Includes both flat and modular properties
 - When NO: Includes only modular structure
 
 Compatible with cross-platform frameworks and persistence.
 */
- (NSDictionary *)toDictionary;

/**
 Returns a dictionary representation with optional sensitive data redaction.
 @param redact Whether to redact sensitive information like access tokens
 */
- (NSDictionary *)toDictionary:(BOOL)redact;

/**
 Returns a JSON string representation of the configuration.
 */
- (NSString *)toJson;

#pragma mark - Utility Methods

/**
 Register a plugin for specific events.
 */
- (void)registerPlugin:(NSString *)pluginName;

/**
 Check if a plugin is registered for a specific event.
 */
- (BOOL)hasPluginForEvent:(NSString *)eventName;

/**
 Check if device rebooted since last launch.
 */
- (BOOL)didDeviceReboot;
/**
 Check if a valid HTTP URL is configured.
 */
- (BOOL)hasValidUrl;

/**
 Check if a schedule is configured.
 */
- (BOOL)hasSchedule;

/**
 Check if trigger activities are configured.
 */
- (BOOL)hasTriggerActivities;

/**
 Determine if a location type should be persisted based on current settings.
 */
- (BOOL)shouldPersist:(TSLocationType)type;

/**
 Get location authorization alert strings with interpolated values.
 */
- (NSDictionary *)getLocationAuthorizationAlertStrings;

@end

NS_ASSUME_NONNULL_END
