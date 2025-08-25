#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>
#import <AudioToolbox/AudioToolbox.h>

#import <TSLocationManager/TSConfig.h>

#import <TSLocationManager/TSHttpService.h>
#import <TSLocationManager/TSAuthorization.h>
#import <TSLocationManager/TSGeofenceManager.h>
#import <TSLocationManager/TSGeofence.h>

#import <TSLocationManager/TSSchedule.h>
#import <TSLocationManager/TSActivityChangeEvent.h>
#import <TSLocationManager/TSProviderChangeEvent.h>
#import <TSLocationManager/TSLocationEvent.h>
#import <TSLocationManager/TSHttpEvent.h>
#import <TSLocationManager/TSHeartbeatEvent.h>
#import <TSLocationManager/TSScheduleEvent.h>
#import <TSLocationManager/TSGeofencesChangeEvent.h>
#import <TSLocationManager/TSPowerSaveChangeEvent.h>
#import <TSLocationManager/TSConnectivityChangeEvent.h>
#import <TSLocationManager/TSEnabledChangeEvent.h>
#import <TSLocationManager/TSGeofenceEvent.h>
#import <TSLocationManager/TSAuthorizationEvent.h>

#import <TSLocationManager/TSCurrentPositionRequest.h>
#import <TSLocationManager/TSWatchPositionRequest.h>

#import <TSLocationManager/TSEventNames.h>
#import <TSLocationManager/TSLocationErrors.h>

#import <TSLocationManager/LogQuery.h>
#import <TSLocationManager/TSDeviceInfo.h>

#import <TSLocationManager/TSTimerService.h>


NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT double TSLocationManagerVersionNumber;
FOUNDATION_EXPORT const unsigned char TSLocationManagerVersionString[];
FOUNDATION_EXPORT NSString* TSLocationManagerVersion;

/**
 The main API interface.
 */
NS_SWIFT_NAME(BackgroundGeolocation)
@interface TSLocationManager : NSObject


#pragma mark - Properties

// Flags
@property (atomic, readonly) BOOL enabled;
/// :nodoc:


# pragma mark - Services

/// The application's `ViewController` instance.  Used for presenting dialogs.
@property (nonatomic) UIViewController* viewController;

/// configChangeBufferTimer
@property (nonatomic, strong) TSTimerService *configChangeBufferTimer;

/// [Optional] User-supplied block to render location-data for SQLite database / Firebase adapter INSERT.
@property (copy) NSDictionary* (^beforeInsertBlock) (NSDictionary *data);

/// Returns the API's singleton instance.
+ (TSLocationManager *)sharedInstance;

#pragma mark - Event Listener Methods

- (void) onLocation:(void(^)(TSLocationEvent* location))success failure:(void(^)(NSError*))failure;
- (void) onHttp:(void(^)(TSHttpEvent* event))success;
- (void) onGeofence:(void(^)(TSGeofenceEvent* event))success;
- (void) onHeartbeat:(void(^)(TSHeartbeatEvent* event))success;
- (void) onMotionChange:(void(^)(TSLocationEvent* event))success;
- (void) onActivityChange:(void(^)(TSActivityChangeEvent* event))success;
- (void) onProviderChange:(void(^)(TSProviderChangeEvent* event))success;
- (void) onGeofencesChange:(void(^)(TSGeofencesChangeEvent* event))success;
- (void) onSchedule:(void(^)(TSScheduleEvent* event))success;
- (void) onPowerSaveChange:(void(^)(TSPowerSaveChangeEvent* event))success;
- (void) onConnectivityChange:(void(^)(TSConnectivityChangeEvent* event))succes;
- (void) onEnabledChange:(void(^)(TSEnabledChangeEvent* event))success;
- (void) onAuthorization:(void(^)(TSAuthorizationEvent*))callback;

- (void) removeListener:(NSString*)event callback:(void(^)(id))callback;
- (void) removeListeners:(NSString*)event;
- (void) removeListenersForEvent:(NSString*)event;
- (void) removeListeners;

#pragma mark - Core API Methods

- (void) ready;
- (void) start;
- (void) stop;
- (void) startSchedule;
- (void) stopSchedule;
- (void) startGeofences;
- (NSMutableDictionary*) getState;

#pragma mark - Geolocation Methods

- (void) changePace:(BOOL)value;
- (void) getCurrentPosition:(TSCurrentPositionRequest*)request;
- (void) setOdometer:(CLLocationDistance)odometer request:(TSCurrentPositionRequest*)request;
- (CLLocationDistance)getOdometer;
- (void) watchPosition:(TSWatchPositionRequest*)request;
- (void) stopWatchPosition;
- (NSDictionary*) getStationaryLocation;
- (TSProviderChangeEvent*) getProviderState;
- (void) requestPermission:(void(^)(NSNumber *status))success failure:(void(^)(NSNumber *status))failure;
- (void) requestTemporaryFullAccuracy:(NSString*)purpose success:(void(^)(NSInteger))success failure:(void(^)(NSError*))failure;

#pragma mark - HTTP & Persistence Methods

- (void) sync:(void(^)(NSArray* locations))success failure:(void(^)(NSError* error))failure;
- (void) getLocations:(void(^)(NSArray* locations))success failure:(void(^)(NSString* error))failure;
- (BOOL) clearDatabase;
- (BOOL) destroyLocations;
- (void) destroyLocations:(void(^)(void))success failure:(void(^)(NSString* error))failure;
- (void) destroyLocation:(NSString*)uuid;
- (void) destroyLocation:(NSString*)uuid success:(void(^)(void))success failure:(void(^)(NSString* error))failure;
- (void) insertLocation:(NSDictionary*)params success:(void(^)(NSString* uuid))success failure:(void(^)(NSString* error))failure;
- (void) persistLocation:(NSDictionary*)location;
- (int) getCount;

#pragma mark - Application Methods

- (UIBackgroundTaskIdentifier) createBackgroundTask;
- (void) stopBackgroundTask:(UIBackgroundTaskIdentifier)taskId;
- (BOOL) isPowerSaveMode;

#pragma mark - Logging & Debug Methods

- (void) getLog:(void(^)(NSString* log))success failure:(void(^)(NSString* error))failure;
- (void) getLog:(LogQuery*)query success:(void(^)(NSString* log))success failure:(void(^)(NSString* error))failure;
- (void) emailLog:(NSString*)email success:(void(^)(void))success failure:(void(^)(NSString* error))failure;
- (void) emailLog:(NSString*)email query:(LogQuery*)query success:(void(^)(void))success failure:(void(^)(NSString* error))failure;
- (void) uploadLog:(NSString*)url query:(LogQuery*)query success:(void(^)(void))success failure:(void(^)(NSString* error))failure;

- (BOOL) destroyLog;
- (void) setLogLevel:(TSLogLevel)level;
- (void) playSound:(SystemSoundID)soundId;
- (void) error:(UIBackgroundTaskIdentifier)taskId message:(NSString*)message;
- (void) log:(NSString*)level message:(NSString*)message;
#pragma mark - Geofencing Methods

- (void) addGeofence:(TSGeofence*)geofence success:(void (^)(void))success failure:(void (^)(NSString* error))failure;
- (void) addGeofences:(NSArray*)geofences success:(void (^)(void))success failure:(void (^)(NSString* error))failure;
- (void) removeGeofence:(NSString*)identifier success:(void (^)(void))success failure:(void (^)(NSString* error))failure;
- (void) removeGeofences:(NSArray*)identifiers success:(void (^)(void))success failure:(void (^)(NSString* error))failure;;
- (void) removeGeofences;
- (NSArray*) getGeofences;
- (void) getGeofences:(void (^)(NSArray*))success failure:(void (^)(NSString*))failure;
- (void) getGeofence:(NSString*)identifier success:(void (^)(TSGeofence*))success failure:(void (^)(NSString*))failure;
- (void) geofenceExists:(NSString*)identifier callback:(void (^)(BOOL))callback;

#pragma mark - Sensor Methods

-(BOOL) isMotionHardwareAvailable;
-(BOOL) isDeviceMotionAvailable;
-(BOOL) isAccelerometerAvailable;
-(BOOL) isGyroAvailable;
-(BOOL) isMagnetometerAvailable;

@end

NS_ASSUME_NONNULL_END
