#import "./include/flutter_background_geolocation/TSWatchPositionStreamHandler.h"

//
//  TSWatchPositionStreamHandler.m
//  flutter_background_geolocation
//
//  Created by Christopher Scott on 2025-08-29.
//
// TSWatchPositionStreamHandler.m

@implementation TSWatchPositionStreamHandler {
    FlutterEventSink _eventSink;
}

+ (void)register:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterEventChannel *channel = [FlutterEventChannel
        eventChannelWithName:@"com.transistorsoft/flutter_background_geolocation/events/watchPosition"
             binaryMessenger:[registrar messenger]];

    [channel setStreamHandler:[TSWatchPositionStreamHandler sharedInstance]];
}

+ (instancetype)sharedInstance {
    static TSWatchPositionStreamHandler *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TSWatchPositionStreamHandler alloc] init];
    });
    return instance;
}

- (FlutterError* _Nullable)onListenWithArguments:(id _Nullable)arguments
                                       eventSink:(FlutterEventSink)events {
    _eventSink = events;
    return nil;
}

- (FlutterError* _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    _eventSink = nil;
    return nil;
}

- (void)emit:(TSLocationStreamEvent *)event {
    if (_eventSink != nil) {
        _eventSink([event toDictionary]);
    }
}
@end

