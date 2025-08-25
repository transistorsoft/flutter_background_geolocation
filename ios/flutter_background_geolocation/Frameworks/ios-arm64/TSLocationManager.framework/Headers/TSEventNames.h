//
//  TSEventNames.h
//  TSLocationManager
//
//  Defines canonical event-name strings used by the event system.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

# pragma mark - TSLocationManager API events

extern NSString *const TSEventNameLocation;
extern NSString *const TSEventNameLocationError;
extern NSString *const TSEventNameHttp;
extern NSString *const TSEventNameGeofence;
extern NSString *const TSEventNameHeartbeat;
extern NSString *const TSEventNameMotionChange;
extern NSString *const TSEventNameActivityChange;
extern NSString *const TSEventNameProviderChange;
extern NSString *const TSEventNameGeofencesChange;
extern NSString *const TSEventNameSchedule;
extern NSString *const TSEventNamePowerSaveChange;
extern NSString *const TSEventNameConnectivityChange;
extern NSString *const TSEventNameEnabledChange;
extern NSString *const TSEventNameAuthorization;
extern NSString *const TSEventNameCLLocation;

# pragma mark - EventBus Events

extern NSString *const TSEventNameStopMonitoringSignificantLocationChanges;
extern NSString *const TSEventBusNameAppSuspend;
extern NSString *const TSEventBusNameAppResume;
extern NSString *const TSEventBusNamePersist;

NS_ASSUME_NONNULL_END
