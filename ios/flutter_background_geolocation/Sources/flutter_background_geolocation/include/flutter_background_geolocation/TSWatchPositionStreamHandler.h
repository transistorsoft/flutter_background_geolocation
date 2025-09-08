#import <Flutter/Flutter.h>
#import <TSLocationManager/TSLocationStreamEvent.h>

//
//  TSWatchPositionStreamHandler.h
//  flutter_background_geolocation
//
//  Created by Christopher Scott on 2025-08-29.
//
@interface TSWatchPositionStreamHandler : NSObject <FlutterStreamHandler>
+ (instancetype)sharedInstance;
+ (void)register:(NSObject<FlutterPluginRegistrar>*)registrar;
- (void)emit:(TSLocationStreamEvent *)event;
@end
