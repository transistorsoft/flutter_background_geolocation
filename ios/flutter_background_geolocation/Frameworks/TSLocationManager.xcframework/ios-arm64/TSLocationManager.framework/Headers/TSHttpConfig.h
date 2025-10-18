//
//  TSHttpConfig2.h
//  TSLocationManager
//
//  Created by Christopher Scott on 2025-09-05.
//  Copyright © 2025 Christopher Scott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSConfigModuleBase.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * HTTP configuration module for network requests and sync behavior.
 * Contains all properties related to HTTP communication with your server.
 */
@interface TSHttpConfig : TSConfigModuleBase

#pragma mark - HTTP Request Properties

/**
 * The URL to send location data to.
 * Must be a valid HTTP or HTTPS URL.
 * Default: "" (empty string)
 */
@property (nonatomic, copy) NSString *url;

/**
 * HTTP method to use for requests.
 * Valid values: POST, PUT, OPTIONS, PATCH
 * Default: "POST"
 */
@property (nonatomic, copy) NSString *method;

/**
 * Root property name for location data in HTTP requests.
 * The location object will be nested under this key in the request body.
 * Default: "location"
 */
@property (nonatomic, copy) NSString *rootProperty;

/**
 * Additional HTTP headers to include in requests.
 * Common use: Authentication headers, Content-Type overrides
 * Default: {} (empty dictionary)
 */
@property (nonatomic, copy) NSDictionary<NSString*, id> *headers;

/**
 * URL query parameters to append to all requests.
 * These will be appended to the URL as ?key=value&key2=value2
 * Default: {} (empty dictionary)
 */
@property (nonatomic, copy) NSDictionary<NSString*, id> *params;

/**
 * HTTP request timeout in milliseconds.
 * How long to wait for server response before timing out.
 * Default: 60000 (60 seconds)
 */
@property (nonatomic) NSInteger timeout;

#pragma mark - Sync Behavior

/**
 * Automatically sync recorded locations to the server.
 * Default: YES
 */
@property (nonatomic) BOOL autoSync;

/**
 * Number of locations to store before forcing a sync.
 * Set to 0 to sync every location immediately.
 * Default: 0
 */
@property (nonatomic) NSInteger autoSyncThreshold;

/**
 * Sync locations in batches rather than individually.
 * More efficient for high-frequency location updates.
 * Default: NO
 */
@property (nonatomic) BOOL batchSync;

/**
 * Maximum number of locations to include in a single batch.
 * Set to -1 for no limit.
 * Default: -1
 */
@property (nonatomic) NSInteger maxBatchSize;


/**
 * Disable automatic sync when device is on cellular connection.
 * When YES, locations will only sync when on WiFi.
 * Default: NO
 */
@property (nonatomic) BOOL disableAutoSyncOnCellular;

#pragma mark - Utility Methods

/**
 * Check if the configured URL is valid.
 * Validates URL format, scheme (http/https), and host presence.
 *
 * @return YES if URL is properly formatted and accessible
 */
- (BOOL)hasValidUrl;

/**
 * Get the complete URL including query parameters.
 * Appends configured params as query string to the base URL.
 *
 * @return Full URL string with params appended, or base URL if no params
 */
- (NSString *)fullUrlWithParams;

/**
 * Get effective batch size considering maxBatchSize setting.
 */
- (NSInteger)effectiveBatchSize;

/**
 * Check if immediate sync is enabled (autoSyncThreshold == 0).
 */
- (BOOL)isImmediateSyncEnabled;

/**
 * Get headers merged with additional authentication headers.
 * Combines configured headers with provided auth headers.
 * Auth headers take precedence over configured headers for duplicate keys.
 *
 * @param authHeaders Additional headers to merge (typically from TSAuthorization)
 * @return Combined headers dictionary
 */
- (NSDictionary *)headersWithAuth:(nullable NSDictionary *)authHeaders;

/**
 * Validate and normalize a URL string.
 * Trims whitespace, validates format, and returns cleaned URL.
 *
 * @param urlString Raw URL string to validate
 * @return Cleaned and validated URL string, or empty string if invalid
 */
- (NSString *)validateAndCleanUrl:(NSString *)urlString;

@end

NS_ASSUME_NONNULL_END
