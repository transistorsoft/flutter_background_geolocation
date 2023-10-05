#import "TSLocationStreamHandler.h"

static NSString *const EVENT_NAME    = @"location";

// TODO: define const for each type of error
static NSString *const LOCATION_ERROR = @"LOCATION_ERROR";

@implementation TSLocationStreamHandler

- (NSString*) event {
    return EVENT_NAME;
}

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events {
    self.callback = ^void(TSLocation *tsLocation) {
        events([tsLocation toDictionary]);
    };
    
    [[TSLocationManager sharedInstance] onLocation:self.callback failure:^(NSError *error) {    
        events([FlutterError errorWithCode: [NSString stringWithFormat:@"%lu", (long) error.code] message:LOCATION_ERROR details:nil]);
    }];
    
    return nil;
}
@end

