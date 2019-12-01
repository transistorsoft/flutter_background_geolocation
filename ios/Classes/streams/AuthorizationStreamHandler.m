//
//  AuthenticationStreamHandler.m
//  Pods
//
//  Created by Christopher Scott on 2019-11-27.
//
#import "AuthorizationStreamHandler.h"

static NSString *const EVENT_NAME    = @"authorization";

@implementation AuthorizationStreamHandler

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




