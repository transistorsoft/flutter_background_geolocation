
#import "GeofencesChangeStreamHandler.h"

static NSString *const EVENT_NAME    = @"geofenceschange";

@implementation GeofencesChangeStreamHandler

- (NSString*) event {
    return EVENT_NAME;
}

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events {
    self.callback = ^void(TSGeofencesChangeEvent *event) {
        events([event toDictionary]);
    };

    [[TSLocationManager sharedInstance] onGeofencesChange:self.callback];
    return nil;
}

@end


