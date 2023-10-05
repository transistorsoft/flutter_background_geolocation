#import "TSConnectivityChangeStreamHandler.h"

static NSString *const EVENT_NAME    = @"connectivitychange";

@implementation TSConnectivityChangeStreamHandler

- (NSString*) event {
    return EVENT_NAME;
}

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events {
    self.callback = ^void(TSConnectivityChangeEvent *event) {
        events([event toDictionary]);
    };
    [[TSLocationManager sharedInstance] onConnectivityChange:self.callback];
    
    return nil;
}

@end


