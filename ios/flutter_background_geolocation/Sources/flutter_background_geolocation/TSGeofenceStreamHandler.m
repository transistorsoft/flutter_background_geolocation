
#import "./include/flutter_background_geolocation/TSGeofenceStreamHandler.h"

static NSString *const EVENT_NAME    = @"geofence";

@implementation TSGeofenceStreamHandler

- (NSString*) event {
    return EVENT_NAME;
}

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events {
    self.callback = ^void(TSGeofenceEvent *event) {
        events([event toDictionary]);
    };
    [[TSLocationManager sharedInstance] onGeofence:self.callback];
    return nil;
}

@end


