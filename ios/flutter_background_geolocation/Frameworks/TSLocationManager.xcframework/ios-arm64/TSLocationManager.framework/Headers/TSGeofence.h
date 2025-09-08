//
//  TSGeofence.h
//  TSLocationManager
//
//  Created by Christopher Scott on 2016-12-21.
//  Copyright © 2016 Transistor Software. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class TSPolygonStreamRequest;;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TSGeofenceEntryState) {
    TSGeofenceEntryStateOutside = 0,
    TSGeofenceEntryStateInside  = 1
};

@interface TSGeofence : NSObject

@property (nonatomic, copy)   NSString *identifier;
@property (nonatomic)         CLLocationDistance radius;
@property (nonatomic)         CLLocationDegrees latitude;
@property (nonatomic)         CLLocationDegrees longitude;
@property (nonatomic, readonly) BOOL isMonitoring;
@property (nonatomic)         BOOL notifyOnEntry;
@property (nonatomic)         BOOL notifyOnExit;
@property (nonatomic)         BOOL notifyOnDwell;
@property (nonatomic)         double loiteringDelay;
@property (nonatomic, copy, nullable) NSDictionary *extras;
@property (nonatomic, assign, readonly) TSGeofenceEntryState entryState;  // Outside/Inside
@property (nonatomic, assign, readonly) NSTimeInterval stateUpdatedAt;    // seconds since 1970
@property (nonatomic, assign, readonly) NSInteger hits;                   // total ENTER count
@property (nonatomic, readonly) BOOL isLoitering;
@property (nonatomic, strong, readonly) TSPolygonStreamRequest* request;

/// Always normalized to array of [NSNumber(latitude), NSNumber(longitude)] pairs.
/// Accepts on input any of the following per-vertex shapes:
///  • NSValue wrapping CLLocationCoordinate2D
///  • NSArray [lat, lng] where elements are NSNumber or NSString convertible to double
///  • NSDictionary with keys { latitude/lat/y, longitude/lng/lon/x } (case-insensitive)
///  • CLLocation
@property (nonatomic, copy, nullable) NSArray<NSArray<NSNumber *> *> *vertices;

- (instancetype)init;

// Designated initializer (everything)
- (instancetype)initWithIdentifier:(NSString*)identifier
                            radius:(CLLocationDistance)radius
                          latitude:(CLLocationDegrees)latitude
                         longitude:(CLLocationDegrees)longitude
                     notifyOnEntry:(BOOL)notifyOnEntry
                      notifyOnExit:(BOOL)notifyOnExit
                     notifyOnDwell:(BOOL)notifyOnDwell
                    loiteringDelay:(double)loiteringDelay
                            extras:(nullable NSDictionary*)extras
                          vertices:(nullable NSArray *)vertices
                        entryState:(TSGeofenceEntryState)entryState
                   stateUpdatedAt:(NSTimeInterval)stateUpdatedAt
                             hits:(NSInteger)hits NS_DESIGNATED_INITIALIZER;

// Convenience: app creating a geofence (defaults state fields)
- (instancetype)initForCreateWithIdentifier:(NSString*)identifier
                                     radius:(CLLocationDistance)radius
                                   latitude:(CLLocationDegrees)latitude
                                  longitude:(CLLocationDegrees)longitude
                              notifyOnEntry:(BOOL)notifyOnEntry
                               notifyOnExit:(BOOL)notifyOnExit
                              notifyOnDwell:(BOOL)notifyOnDwell
                             loiteringDelay:(double)loiteringDelay
                                     extras:(nullable NSDictionary*)extras
                                   vertices:(nullable NSArray *)vertices;

// Convenience: DAO hydrating from DB
- (instancetype)initForHydrationWithIdentifier:(NSString*)identifier
                                        radius:(CLLocationDistance)radius
                                      latitude:(CLLocationDegrees)latitude
                                     longitude:(CLLocationDegrees)longitude
                                 notifyOnEntry:(BOOL)notifyOnEntry
                                  notifyOnExit:(BOOL)notifyOnExit
                                 notifyOnDwell:(BOOL)notifyOnDwell
                                loiteringDelay:(double)loiteringDelay
                                        extras:(nullable NSDictionary*)extras
                                      vertices:(nullable NSArray *)vertices
                                     entryState:(TSGeofenceEntryState)entryState
                                stateUpdatedAt:(NSTimeInterval)stateUpdatedAt
                                          hits:(NSInteger)hits;

+ (instancetype)circleWithIdentifier:(NSString*)identifier
                              radius:(CLLocationDistance)radius
                            latitude:(CLLocationDegrees)latitude
                           longitude:(CLLocationDegrees)longitude
                       notifyOnEntry:(BOOL)notifyOnEntry
                        notifyOnExit:(BOOL)notifyOnExit
                       notifyOnDwell:(BOOL)notifyOnDwell
                      loiteringDelay:(double)loiteringDelay
                              extras:(nullable NSDictionary*)extras
NS_SWIFT_NAME(circle(identifier:radius:latitude:longitude:notifyOnEntry:notifyOnExit:notifyOnDwell:loiteringDelay:extras:));

+ (instancetype)polygonWithIdentifier:(NSString*)identifier
                             vertices:(NSArray *)vertices // accepts NSValue(CLLocationCoordinate2D) or [lat, lng]
                        notifyOnEntry:(BOOL)notifyOnEntry
                         notifyOnExit:(BOOL)notifyOnExit
                        notifyOnDwell:(BOOL)notifyOnDwell
                       loiteringDelay:(double)loiteringDelay
                               extras:(nullable NSDictionary*)extras
NS_SWIFT_NAME(polygon(identifier:vertices:notifyOnEntry:notifyOnExit:notifyOnDwell:loiteringDelay:extras:));

/// Legacy initializer (no extras / vertices)
- (instancetype)initWithIdentifier:(NSString*)identifier
                            radius:(CLLocationDistance)radius
                          latitude:(CLLocationDegrees)latitude
                         longitude:(CLLocationDegrees)longitude
                     notifyOnEntry:(BOOL)notifyOnEntry
                      notifyOnExit:(BOOL)notifyOnExit
                     notifyOnDwell:(BOOL)notifyOnDwell
                    loiteringDelay:(double)loiteringDelay
API_DEPRECATED("Use initForCreateWithIdentifier:... (or the designated initializer) instead.",
               ios(9.0, 18.0));

#pragma mark - Back-compat initializers

/// Legacy initializer (with extras / vertices)
- (instancetype)initWithIdentifier:(NSString*)identifier
                            radius:(CLLocationDistance)radius
                          latitude:(CLLocationDegrees)latitude
                         longitude:(CLLocationDegrees)longitude
                     notifyOnEntry:(BOOL)notifyOnEntry
                      notifyOnExit:(BOOL)notifyOnExit
                     notifyOnDwell:(BOOL)notifyOnDwell
                    loiteringDelay:(double)loiteringDelay
                            extras:(nullable NSDictionary*)extras
                          vertices:(nullable NSArray *)vertices
API_DEPRECATED("Use initForCreateWithIdentifier:... (or the designated initializer) instead.",
               ios(9.0, 18.0));

- (void) startMonitoringPolygon;
- (void) stopMonitoringPolygon;
- (NSDictionary*)toDictionary;
- (BOOL) isPolygon;
- (void) startMonitoringWithLocationManager:(CLLocationManager*)locationManager prefix:(NSString*)identifierPrefix;
- (void) setState:(enum TSGeofenceEntryState)state;
- (void) startLoitering;
- (void) cancelLoitering;
// Exit the containing geofence of a Polygon.  This ALWAYS means fire the geofence exit event.
- (void) exitMEC;


@end

NS_ASSUME_NONNULL_END
