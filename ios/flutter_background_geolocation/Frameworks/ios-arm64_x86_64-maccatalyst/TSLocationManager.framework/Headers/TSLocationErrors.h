//
//  TSLocationError.h
//  TSLocationManager
//
//  Created by Christopher Scott on 2025-08-10.
//  Copyright © 2025 Christopher Scott. All rights reserved.
//
//  Shared location error codes, using HTTP-inspired values.
//

#import <Foundation/Foundation.h>

extern NSString * const TSLocationErrorDomain;

typedef NS_ENUM(NSInteger, TSLocationError) {
    TSLocationErrorOK                  = 200, // Success, no error
    TSLocationErrorAcceptableAccuracy  = 100, // Accuracy threshold met but not ideal
    TSLocationErrorBadRequest          = 400, // Invalid request parameters
    TSLocationErrorUnauthorized        = 401, // Authorization not granted
    TSLocationErrorNotFound            = 404, // No location fix available
    TSLocationErrorTimeout             = 408, // Timed out waiting for location
    TSLocationErrorCancelled           = 499,
    TSLocationErrorServiceUnavailable  = 503,  // Location services disabled/unavailable
    TSLocationErrorUnknown             = 0
};

/// Returns the canonical, user-facing message for a TSLocationError code.
FOUNDATION_EXPORT NSString * TSLocationErrorMessage(TSLocationError code);

/// Build an NSError in **TSLocationErrorDomain** with a canonical message.
FOUNDATION_EXPORT NSError * TSMakeLocationError(TSLocationError code);

/// Build an NSError using a **custom domain & code** but with a canonical message
/// (useful when you want to keep kCLError* codes/domains at the call site).
FOUNDATION_EXPORT NSError * TSMakeError(NSString *domain, TSLocationError code);

