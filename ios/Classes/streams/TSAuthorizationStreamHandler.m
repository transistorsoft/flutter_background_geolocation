//
//  TSAuthenticationStreamHandler.m
//  Pods
//
//  Created by Christopher Scott on 2019-11-27.
//
#import "TSAuthorizationStreamHandler.h"

static NSString *const EVENT_NAME    = @"authorization";

@implementation TSAuthorizationStreamHandler

- (NSString*) event {
    return EVENT_NAME;
}

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events {
    self.callback = ^void(TSAuthorizationEvent *event) {
        events([event toDictionary]);
    };
    [[TSHttpService sharedInstance] onAuthorization:self.callback];
    
    return nil;
}

@end




