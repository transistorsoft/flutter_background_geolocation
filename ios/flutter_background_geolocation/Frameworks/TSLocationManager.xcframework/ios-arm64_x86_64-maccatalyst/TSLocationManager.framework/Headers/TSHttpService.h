//
//  TSScheduler.h
//  TSLocationManager
//
//  Created by Christopher Scott on 2016-04-26.
//  Copyright © 2016 Transistor Software. All rights reserved.
//
//
// TSScheduler
// TODO This should be decoupled into some sort of plugin
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TSConnectivityChangeEvent.h"
#import "TSAuthorizationEvent.h"
#import "TSReachability.h"
#import "TSCallback.h"

NS_ASSUME_NONNULL_BEGIN

@class TSHttpService;

@interface TSHttpService : NSObject

#pragma mark - Singleton
+ (TSHttpService *)sharedInstance;

#pragma mark - Properties

/// Single-flight guard. All reads/writes happen under a private lock; never more than one upload loop runs concurrently.
@property (nonatomic, readonly) BOOL isBusy;
@property (nonatomic, strong, readonly) TSReachability *reachability;

#pragma mark - Methods
-(void)flush;
-(void)flush:(BOOL)overrideSyncThreshold;
-(void)flush:(void(^)(NSArray*))success failure:(void(^)(NSError*))failure;
-(void)startMonitoring;
-(void)stopMonitoring;

-(void)onConnectivityChange:(void (^)(TSConnectivityChangeEvent*))success;
-(void)onAuthorization:(void(^)(TSAuthorizationEvent*))callback;

@end

NS_ASSUME_NONNULL_END
