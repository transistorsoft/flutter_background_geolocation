#import "TSProviderChangeStreamHandler.h"

static NSString *const EVENT_NAME    = @"providerchange";

@implementation TSProviderChangeStreamHandler

- (NSString*) event {
    return EVENT_NAME;
}

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events {

    self.callback = ^void(TSProviderChangeEvent *event) {
        events([event toDictionary]);
    };
    [[TSLocationManager sharedInstance] onProviderChange: self.callback];
    
    return nil;
}
@end


