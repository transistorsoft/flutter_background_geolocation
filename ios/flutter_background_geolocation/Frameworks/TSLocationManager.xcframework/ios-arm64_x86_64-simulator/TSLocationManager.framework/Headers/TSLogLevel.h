//
//  TSLogLevel.h
//  TSLocationManager
//
//  Created by Christopher Scott on 2025-09-09.
//  Copyright © 2025 Christopher Scott. All rights reserved.
//
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TSLogLevel) {
    TSLogLevelOff = 0,
    TSLogLevelError,
    TSLogLevelWarning,
    TSLogLevelInfo,
    TSLogLevelDebug,
    TSLogLevelVerbose
};

FOUNDATION_EXPORT NSString *TSLogLevelToString(TSLogLevel level);
FOUNDATION_EXPORT TSLogLevel TSLogLevelFromString(NSString * _Nullable s, TSLogLevel fallback);

NS_ASSUME_NONNULL_END

