//
//  GeofenceManager.h
//  TSLocationManager
//
//  Created by Christopher Scott on 2016-10-04.
//  Copyright © 2016 Transistor Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "TSGeofence.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString *const STATIONARY_REGION_IDENTIFIER;

@interface TSGeofenceManager : NSObject<CLLocationManagerDelegate>
{
    
}

+ (instancetype)sharedInstance;

-(void) start;
-(void) stop;
-(void) ready;
-(void) setLocation:(CLLocation*)location isMoving:(BOOL)isMoving;
-(void) setProximityRadius:(CLLocationDistance)radius;
-(BOOL) isMonitoringRegion:(CLCircularRegion*)region;
-(NSString*) identifierFor:(CLCircularRegion*)region;
-(void) create:(NSArray*)geofences success:(void (^)(void))success failure:(void (^)(NSString*))failure;
-(void) destroy:(NSArray*)identifiers success:(void (^)(void))success failure:(void (^)(NSString*))failure;
-(BOOL) isInfiniteMonitoring;
-(void) startMonitoringGeofence:(TSGeofence*)geofence;
- (void) handleGeofenceEvent:(CLCircularRegion*)region action:(NSString*)action;

@end

NS_ASSUME_NONNULL_END
