#import "LocationStreamHandler.h"

static NSString *const EVENT_NAME    = @"location";

@implementation LocationStreamHandler

- (NSString*) event {
    return EVENT_NAME;
}

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events {
    self.callback = ^void(TSLocation *tsLocation) {
        events([tsLocation toDictionary]);
    };
    
    [[TSLocationManager sharedInstance] onLocation:self.callback failure:^(NSError *error) {
        events(@(error.code));
    }];
    
    return nil;
}
@end

