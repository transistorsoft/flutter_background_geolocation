#import "TSBackgroundGeolocationStreamHandler.h"

static NSString *const EVENT_PATH = @"com.transistorsoft/flutter_background_geolocation/events";

@implementation TSBackgroundGeolocationStreamHandler

+(void)register:(NSObject<FlutterPluginRegistrar>*)registrar {
    TSBackgroundGeolocationStreamHandler *handler = [self new];
    NSString *path = [NSString stringWithFormat:@"%@/%@", EVENT_PATH, handler.event];
    FlutterEventChannel *eventChannel = [FlutterEventChannel eventChannelWithName:path binaryMessenger: [registrar messenger]];

    [eventChannel setStreamHandler:handler];
}

// @override by derived StreamHandler
-(NSString*) event {
    return @"streamhandler_default_event_name";
}

// @override by derived StreamHandler
- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events {
    return nil;
}

- (FlutterError*)onCancelWithArguments:(id)arguments {    
    [[TSLocationManager sharedInstance] removeListener: self.event callback: _callback];
    return nil;
}

@end


