
#import "TSEnabledChangeStreamHandler.h"

static NSString *const EVENT_NAME    = @"enabledchange";

@implementation TSEnabledChangeStreamHandler

- (NSString*) event {
    return EVENT_NAME;
}

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events {
    self.callback = ^void(TSEnabledChangeEvent *event) {
        events(@(event.enabled));
    };
    [[TSLocationManager sharedInstance] onEnabledChange:self.callback];

    return nil;
}

@end


