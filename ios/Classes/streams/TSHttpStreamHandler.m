
#import "TSHttpStreamHandler.h"

static NSString *const EVENT_NAME    = @"http";

@implementation TSHttpStreamHandler

- (NSString*) event {
    return EVENT_NAME;
}

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events {
    
    self.callback = ^void(TSHttpEvent *event) {
        events([event toDictionary]);
    };

    [[TSLocationManager sharedInstance] onHttp:self.callback];
    
    return nil;
}

@end


