#import <Flutter/Flutter.h>
#import <TSLocationManager/TSLocationManager.h>

#import "MotionChangeStreamHandler.h"
#import "LocationStreamHandler.h"
#import "ActivityChangeStreamHandler.h"
#import "ProviderChangeStreamHandler.h"
#import "GeofenceStreamHandler.h"
#import "GeofencesChangeStreamHandler.h"
#import "HeartbeatStreamHandler.h"
#import "HttpStreamHandler.h"
#import "ScheduleStreamHandler.h"
#import "PowerSaveChangeStreamHandler.h"
#import "ConnectivityChangeStreamHandler.h"
#import "EnabledChangeStreamHandler.h"
#import "NotificationActionStreamHandler.h"
#import "AuthorizationStreamHandler.h"

@interface FLTBackgroundGeolocationPlugin : NSObject<FlutterPlugin>

@property (nonatomic, strong) TSLocationManager* locationManager;

@end
