#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#include <TSBackgroundFetch/TSBackgroundFetch.h>
#include <TSLocationManager/TSLocationManager.h>

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
    
    // [OPTIONAL] This block is called before a location is inserted into the background_geolocation SQLite database.
    // - The returned NSDictionary will be inserted.
    // - If you return nil, no record will be inserted.
    TSLocationManager *bgGeo = [TSLocationManager sharedInstance];
    bgGeo.beforeInsertBlock = ^NSDictionary *(TSLocation *tsLocation) {
        CLLocation *location = tsLocation.location;
        
        NSLog(@"[beforeInsertBlock] %@: %@", tsLocation.uuid, location);
        
        // Return a custom schema or nil to cancel SQLite insert.
        return @{
            @"lat": @(location.coordinate.latitude),
            @"lng": @(location.coordinate.longitude),
            @"battery": @{
                @"level": tsLocation.batteryLevel,
                @"is_charding": @(tsLocation.batteryIsCharging)
            }
        };
    };
    
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
