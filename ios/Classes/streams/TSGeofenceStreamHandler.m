
#import "TSGeofenceStreamHandler.h"

static NSString *const EVENT_NAME    = @"geofence";

@implementation TSGeofenceStreamHandler

- (NSString*) event {
    return EVENT_NAME;
}

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events {
    self.callback = ^void(TSGeofenceEvent *event) {
        NSMutableDictionary *params = [[event toDictionary] mutableCopy];
        [params setObject:[event.location toDictionary] forKey:@"location"];
        events(params);
    };
    [[TSLocationManager sharedInstance] onGeofence:self.callback];
    return nil;
}

@end


