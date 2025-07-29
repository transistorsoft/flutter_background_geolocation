#import <Flutter/Flutter.h>
#import <TSLocationManager/TSLocationManager.h>

#import "TSMotionChangeStreamHandler.h"
#import "TSLocationStreamHandler.h"
#import "TSActivityChangeStreamHandler.h"
#import "TSProviderChangeStreamHandler.h"
#import "TSGeofenceStreamHandler.h"
#import "TSGeofencesChangeStreamHandler.h"
#import "TSHeartbeatStreamHandler.h"
#import "TSHttpStreamHandler.h"
#import "TSScheduleStreamHandler.h"
#import "TSPowerSaveChangeStreamHandler.h"
#import "TSConnectivityChangeStreamHandler.h"
#import "TSEnabledChangeStreamHandler.h"
#import "TSNotificationActionStreamHandler.h"
#import "TSAuthorizationStreamHandler.h"

@interface TSBackgroundGeolocationPlugin : NSObject<FlutterPlugin>

@property (nonatomic, strong) TSLocationManager* locationManager;

@end
