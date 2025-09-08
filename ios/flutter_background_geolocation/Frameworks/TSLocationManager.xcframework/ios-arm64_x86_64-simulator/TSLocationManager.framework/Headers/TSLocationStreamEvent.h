//
//  TSLocationStreamEvent.h
//  TSLocationManager
//
//  Created by Christopher Scott on 2025-08-29.
//  Copyright © 2025 Christopher Scott. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "TSLocationEvent.h"

NS_ASSUME_NONNULL_BEGIN

@class TSLocationEvent;

/// Public identifier for a running watch/stream
typedef NSInteger TSLocationStreamId;

@interface TSLocationStreamEvent : NSObject

@property (nonatomic, assign, readonly) TSLocationStreamId streamId;
@property (nonatomic, strong, readonly) TSLocationEvent *locationEvent;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithStreamId:(TSLocationStreamId)streamId
                    locationEvent:(TSLocationEvent *)locationEvent NS_DESIGNATED_INITIALIZER;

/// Convenience for JS bridges, logging, etc.
- (NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END