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
#import "AtomicBoolean.h"
#import "HttpRequest.h"
#import "TSReachability.h"
#import "TSCallback.h"

NS_ASSUME_NONNULL_BEGIN

@class TSHttpService;

@interface TSHttpService : NSObject

#pragma mark - Singleton
+ (TSHttpService *)sharedInstance;

#pragma mark - Properties

@property (nonatomic) AtomicBoolean *isBusy;
@property (nonatomic) BOOL hasNetworkConnection;

@property (nonatomic, readonly) NSMutableArray *syncedRecords;
@property (nonatomic, readonly) TSReachability *reachability;
@property (nonatomic, readonly) UIBackgroundTaskIdentifier bgTask;

@property (nullable, nonatomic) TSCallback *callback;
@property (nonatomic) long autoSyncThreshold;

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
