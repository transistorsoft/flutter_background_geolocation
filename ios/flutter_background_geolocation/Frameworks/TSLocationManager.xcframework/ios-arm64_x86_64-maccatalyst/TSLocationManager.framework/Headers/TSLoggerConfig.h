//
//  TSLoggerConfig.h
//  TSLocationManager
//
//  Created by Christopher Scott on 2025-09-11.
//  Copyright © 2025 Christopher Scott. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "TSConfigModuleBase.h"
#import "TSLogLevel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Logger configuration module (debug + log level + retention).
 */
@interface TSLoggerConfig : TSConfigModuleBase

/// Enable debug mode with verbose logging / notifications. Default: NO
@property (nonatomic) BOOL debug;

/// Log level for console output and log files. Default: TSLogLevelOff
@property (nonatomic) TSLogLevel logLevel;

/// Max days to retain log files (older are deleted). Default: 3
@property (nonatomic) NSInteger logMaxDays;

/// Helpers for mapping
+ (NSString *)stringForLogLevel:(TSLogLevel)logLevel;
+ (TSLogLevel)logLevelFromString:(NSString *)logLevelString;

@end

NS_ASSUME_NONNULL_END
