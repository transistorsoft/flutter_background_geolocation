//
//  TransistorAuthorizationToken.h
//  TSLocationManager
//
//  Created by Christopher Scott on 2019-11-21.
//  Copyright © 2019 Christopher Scott. All rights reserved.
//
#import <Foundation/Foundation.h>

@class TSAuthorization;

NS_ASSUME_NONNULL_BEGIN
/**
 * TransistorAuthorizationToken for demo server tracker.transistorsoft.com
 */
@interface TransistorAuthorizationToken : NSObject

@property (nonatomic, copy, readonly) NSString *accessToken;
@property (nonatomic, copy, readonly) NSString *refreshToken;
@property (nonatomic, readonly) long expires;
@property (nonatomic, copy, readonly) NSString *apiUrl;
@property (nonatomic, copy, readonly) NSString *refreshUrl;

/// Convenience: fetch (or reuse) a demo token and apply it to TSConfig.authorization.

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
- (instancetype)initWithDictionary:(NSDictionary *)data forUrl:(NSString*)url;

- (NSDictionary *)toDictionary;
    
@end

NS_ASSUME_NONNULL_END
