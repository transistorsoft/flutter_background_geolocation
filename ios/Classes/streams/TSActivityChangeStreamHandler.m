#import "TSActivityChangeStreamHandler.h"

static NSString *const EVENT_NAME    = @"activitychange";

@implementation TSActivityChangeStreamHandler

- (NSString*) event {
    return EVENT_NAME;
}

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events {

    self.callback = ^void(TSActivityChangeEvent *event) {
        events([event toDictionary]);
    };
    [[TSLocationManager sharedInstance] onActivityChange:self.callback];
    
    return nil;
}
@end


