#import "./include/flutter_background_geolocation/TSMotionChangeStreamHandler.h"

static NSString *const EVENT_NAME       = @"motionchange";

@implementation TSMotionChangeStreamHandler

- (NSString*) event {
    return EVENT_NAME;
}

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events {
    
    self.callback = ^void(TSLocationEvent *event) {
        events(event.data);
    };
    [[TSLocationManager sharedInstance] onMotionChange: self.callback];
    return nil;
}

@end

