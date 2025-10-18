//
//  TSAuthorizationConfig.h
//  TSLocationManager
//
//  Created by Christopher Scott on 2025-09-09.
//  Copyright © 2025 Christopher Scott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSConfigModuleBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface TSAuthorizationConfig : TSConfigModuleBase
@property (nonatomic, copy, nullable) NSString *strategy;
@property (nonatomic, copy, nullable) NSString *accessToken;
@property (nonatomic, copy, nullable) NSString *refreshToken;
@property (nonatomic, copy, nullable) NSDictionary<NSString*, id> *refreshPayload;
@property (nonatomic, copy, nullable) NSDictionary<NSString*, NSString*> *refreshHeaders;
@property (nonatomic, copy, nullable) NSString *refreshUrl;
@property (nonatomic) NSTimeInterval expires;

-(void) apply:(NSMutableURLRequest*)request;
-(void) updateWithDictionary:(NSDictionary*)data;

@end

NS_ASSUME_NONNULL_END

