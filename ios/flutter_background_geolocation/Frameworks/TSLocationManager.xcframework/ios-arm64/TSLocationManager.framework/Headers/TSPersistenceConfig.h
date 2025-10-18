//
//  TSPersistenceConfig.h
//  TSLocationManager
//
//  Created by Christopher Scott on 2025-09-05.
//  Copyright © 2025 Christopher Scott. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "TSConfigModuleBase.h"
#import "TSPersistMode.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Persistence configuration module for data storage and sync behavior.
 * Controls how location data is stored, when it syncs, and retention policies.
 */
@interface TSPersistenceConfig : TSConfigModuleBase

#pragma mark - Data Templates

/**
 * Custom template for location data structure.
 * Use placeholder variables like {lat}, {lng}, {timestamp}.
 * Default: "" (use SDK default format)
 */
@property (nonatomic, copy) NSString *locationTemplate;

/**
 * Custom template for geofence event data structure.
 * Use placeholder variables for geofence-specific data.
 * Default: "" (use SDK default format)
 */
@property (nonatomic, copy) NSString *geofenceTemplate;

#pragma mark - Retention Policies

/**
 * Maximum number of days to keep location data in local database.
 * Older data is automatically purged.
 * Default: 1 day
 */
@property (nonatomic) NSInteger maxDaysToPersist;

/**
 * Maximum number of location records to keep in local database.
 * Set to -1 for no limit, 0 to disable persistence entirely.
 * Default: -1 (no limit)
 */
@property (nonatomic) NSInteger maxRecordsToPersist;

/**
 * Order for retrieving stored locations from database.
 * Valid values: "ASC" (oldest first), "DESC" (newest first)
 * Default: "ASC"
 */
@property (nonatomic, copy) NSString *locationsOrderDirection;

/**
 * Control what types of location data to persist.
 * Default: tsPersistModeAll
 */
@property (nonatomic) TSPersistMode persistMode;

/**
 * Additional data to include in the request body.
 * This data will be merged with the location data in the request body.
 * Default: {} (empty dictionary)
 */
@property (nonatomic, copy) NSDictionary<NSString*, id> *extras;

#pragma mark - Utility Methods

/**
 * Check if persistence is effectively disabled.
 */
- (BOOL)isPersistenceDisabled;

@end

NS_ASSUME_NONNULL_END

