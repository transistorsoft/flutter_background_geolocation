
#import "NotificationActionStreamHandler.h"

static NSString *const EVENT_NAME    = @"notificationaction";

@implementation NotificationActionStreamHandler

- (NSString*) event {
    return EVENT_NAME;
}

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events {
    return nil;
}

@end



