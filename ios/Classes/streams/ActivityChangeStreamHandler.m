#import "ActivityChangeStreamHandler.h"

static NSString *const EVENT_NAME    = @"activitychange";

@implementation ActivityChangeStreamHandler

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


