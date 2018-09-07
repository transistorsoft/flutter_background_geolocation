
#import "HeartbeatStreamHandler.h"

static NSString *const EVENT_NAME    = @"heartbeat";

@implementation HeartbeatStreamHandler

- (NSString*) event {
    return EVENT_NAME;
}

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events {
    
    self.callback = ^void(TSHeartbeatEvent *event) {        
        events([event toDictionary]);
    };
    
    [[TSLocationManager sharedInstance] onHeartbeat:self.callback];
    
    return nil;
}

@end


