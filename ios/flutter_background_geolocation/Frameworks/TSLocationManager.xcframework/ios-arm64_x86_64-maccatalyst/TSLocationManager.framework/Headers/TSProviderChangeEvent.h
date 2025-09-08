//
//  TSProviderChange.h
//  TSLocationManager
//
//  Created by Christopher Scott on 2017-07-28.
//  Copyright © 2017 Transistor Software. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN


@interface TSProviderChangeEvent : NSObject

@property (nonatomic, readonly) CLAuthorizationStatus status;
@property (nonatomic, readonly) NSInteger accuracyAuthorization;
@property (nonatomic, readonly) BOOL gps;
@property (nonatomic, readonly) BOOL network;
@property (nonatomic, readonly) BOOL enabled;

- (NSDictionary<NSString *, id> *)toDictionary;

@end

NS_ASSUME_NONNULL_END
