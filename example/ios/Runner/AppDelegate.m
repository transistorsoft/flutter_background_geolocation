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
    
    
    TSLocationManager *bgGeo = [TSLocationManager sharedInstance];
    
    bgGeo.beforeInsertBlock = ^NSDictionary* (TSLocation *location) {
        NSLog(@"[BackgroundGeolocation] beforeInsertBlock: %@", location);
        BOOL doInsert = YES;
        //
        // Your logic here
        //
        return (doInsert) ? [location toDictionary] : nil;
    };
        
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
