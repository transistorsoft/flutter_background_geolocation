//
//  TSLocationEvent.h
//  TSLocationManager
//
//  Created by Christopher Scott on 2025-08-17.
//  Copyright © 2025 Christopher Scott. All rights reserved.
//
// TSLocationEvent.h
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
NS_ASSUME_NONNULL_BEGIN
@interface TSLocationEvent : NSObject
/// ISO-8601 timestamp of the CLLocation
@property (nonatomic, copy, readonly) NSString *timestamp;
/// Compact, JSON-safe location payload (same shape as TSLocation.toDictionary()["coords"] plus meta)
@property (nonatomic, copy, readonly) NSDictionary *data;   // { coords:{...}, battery:{...}, activity:{...}, ... }
/// Native CLLocation object
@property (nonatomic, strong, readonly) CLLocation *location;
/// Optional "event" string (eg: "geofence", "motionchange", "heartbeat")
@property (nonatomic, copy, readonly, nullable) NSString *event;

@property (nonatomic, readonly) BOOL isMoving;

/// Convenience construction from a TSLocation’s dictionary and CLLocation
- (instancetype)initWithLocationDictionary:(NSDictionary *)dict
                                  location:(CLLocation *)location;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

+ (instancetype)createWithTSLocation:(id)tsLocation;

/// JSON-safe dictionary for clients
- (NSDictionary *)toDictionary;
@end
NS_ASSUME_NONNULL_END
