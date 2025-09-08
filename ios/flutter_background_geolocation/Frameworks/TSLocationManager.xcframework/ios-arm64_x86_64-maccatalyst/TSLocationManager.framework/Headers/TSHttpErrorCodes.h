//
//  TSHttpErrorCodes.h
//  TSLocationManager
//
//  Created by Christopher Scott on 2025-08-27.
//  Copyright © 2025 Christopher Scott. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Error domain for all TSHttpService/HttpResponse produced errors.
FOUNDATION_EXPORT NSString * const TSHttpServiceErrorDomain;

/// Common userInfo keys for richer error context
FOUNDATION_EXPORT NSString * const TSHttpErrorKeyUnderlying;      // NSString or NSError explaining underlying cause
FOUNDATION_EXPORT NSString * const TSHttpErrorKeyStatus;          // NSNumber (HTTP status)
FOUNDATION_EXPORT NSString * const TSHttpErrorKeyResponseBody;    // NSData or NSString of raw response body
FOUNDATION_EXPORT NSString * const TSHttpErrorKeyURL;             // NSString of request URL
FOUNDATION_EXPORT NSString * const TSHttpErrorKeyFromURL;         // For redirects: source URL string
FOUNDATION_EXPORT NSString * const TSHttpErrorKeyToURL;           // For redirects: destination URL string

/// HTTP service error codes
typedef NS_ENUM(NSInteger, TSHttpServiceError) {
    TSHttpServiceErrorInvalidUrl        = 1,
    TSHttpServiceErrorNetworkConnection = 2,
    TSHttpServiceErrorSyncInProgress    = 3,
    TSHttpServiceErrorResponse          = 4,
    TSHttpServiceErrorRedirect          = 5
};

@interface TSHttpErrorCodes : NSObject

/// Base factory
+ (NSError *)errorWithCode:(TSHttpServiceError)code
               description:(nullable NSString *)description
                  userInfo:(nullable NSDictionary *)userInfo;

/// Convenience factories
+ (NSError *)invalidURLError:(nullable NSString *)urlString;
+ (NSError *)noNetworkError;
+ (NSError *)syncInProgressError;
+ (NSError *)responseErrorWithStatus:(NSInteger)status
                                 url:(nullable NSString *)url
                           bodyBytes:(nullable NSData *)body
                          underlying:(nullable NSError *)underlying;
+ (NSError *)redirectErrorFrom:(NSString *)fromURL to:(NSString *)toURL;

/// Localized strings
+ (NSString *)localizedDescriptionForErrorCode:(TSHttpServiceError)code;

@end

NS_ASSUME_NONNULL_END
