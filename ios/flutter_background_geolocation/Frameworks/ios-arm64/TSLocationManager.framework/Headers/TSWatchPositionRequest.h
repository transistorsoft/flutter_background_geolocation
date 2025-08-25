//
//  TSWatchPositionRequest.h
//  TSLocationManager
//
//  Created by Christopher Scott on 2018-02-12.
//  Copyright © 2018 Transistor Software. All rights reserved.
//
#import "TSLocationEvent.h"

NS_ASSUME_NONNULL_BEGIN

@interface TSWatchPositionRequest : NSObject

@property (nonatomic) double interval;
@property (atomic) CLLocationAccuracy desiredAccuracy;
@property (atomic) BOOL persist;
@property (atomic) NSDictionary* extras;
@property (atomic) double timeout;
@property (atomic, copy) void (^success)(TSLocationEvent*);
@property (atomic, copy) void (^failure)(NSError*);

-(instancetype) init;
-(instancetype) initWithSuccess:(void (^)(TSLocationEvent*))success failure:(void (^)(NSError*))failure;

-(instancetype) initWithInterval:(double)interval
                        success:(void (^)(TSLocationEvent*))success
                        failure:(void (^)(NSError*))failure;

-(instancetype) initWithInterval:(double)interval
                        persist:(BOOL)persist
                        success:(void (^)(TSLocationEvent*))success
                        failure:(void (^)(NSError*))failure;

-(instancetype) initWithInterval:(double)interval
                        persist:(BOOL)persist
                 desiredAccuracy:(CLLocationAccuracy)desiredAccuracy
                         extras:(nullable NSDictionary*)extras
                         timeout:(double)timeout
                        success:(void (^)(TSLocationEvent*))success
                        failure:(void (^)(NSError*))failure;

@end

NS_ASSUME_NONNULL_END
