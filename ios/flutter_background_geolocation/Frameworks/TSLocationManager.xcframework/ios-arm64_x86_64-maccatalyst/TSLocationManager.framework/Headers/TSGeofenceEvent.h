// TSGeofenceEvent.h
#import <Foundation/Foundation.h>
#import "TSGeofence.h"

NS_ASSUME_NONNULL_BEGIN
@interface TSGeofenceEvent : NSObject
@property (nonatomic, copy, readonly) NSString *identifier;     // geofence id
@property (nonatomic, copy, readonly) NSString *action;         // ENTER / EXIT / DWELL
@property (nonatomic, readonly) NSDate* timestamp;      // ISO-8601
@property (nonatomic, strong, readonly) TSGeofence *geofence;   // full TSLocation dictionary (safe)
@property (nonatomic, copy, readonly) NSDictionary *location;   // full TSLocation dictionary (safe)
@property (nonatomic, copy, readonly, nullable) NSDictionary *extras;

- (instancetype)initWithIdentifier:(NSString *)identifier
                            action:(NSString *)action
                         timestamp:(NSDate *)timestamp
                          geofence:(TSGeofence *)geofence
                          location:(NSDictionary *)location
                            extras:(nullable NSDictionary *)extras NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (NSDictionary *)toDictionary;
@end
NS_ASSUME_NONNULL_END
