//
//  TransistorAuthorizationToken.h
//  TSLocationManager
//
//  Created by Christopher Scott on 2019-11-21.
//  Copyright © 2019 Christopher Scott. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "TSConfig.h"

NS_ASSUME_NONNULL_BEGIN
/**
 * TransistorAuthorizationToken for demo server tracker.transistorsoft.com
 */
@interface TransistorAuthorizationToken : NSObject

@property (nonatomic, copy, readonly) NSString *accessToken;
@property (nonatomic, copy, readonly) NSString *refreshToken;
@property (nonatomic, readonly) long expires;

+ (void)findOrCreateWithOrg:(NSString *)orgname
                    username:(NSString *)username
                         url:(NSString *)apiUrl
                    framework:(NSString *)framework
                      success:(void(^)(TransistorAuthorizationToken *token))success
                      failure:(void(^)(NSError *error))error;
+ (void)destroyWithUrl:(NSString *)url;
+ (BOOL)hasTokenForHost:(NSString *)host;

- (instancetype)initWithAccessToken:(NSString *)accessToken
                      refreshToken:(NSString *)refreshToken
                            expires:(long)expires;
- (instancetype)initWithDictionary:(NSDictionary *)data;

- (NSDictionary *)toDictionary;
    
@end

NS_ASSUME_NONNULL_END
