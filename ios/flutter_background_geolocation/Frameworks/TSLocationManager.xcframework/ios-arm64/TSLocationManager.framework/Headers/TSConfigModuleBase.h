//
//  TSConfigModuleBase.m
//  TSLocationManager
//
//  Created by Christopher Scott on 2025-01-XX.
//  Copyright © 2025 Transistor Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSConfigModule.h"
#import "TSPropertySpec.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Base class that provides common implementations for TSConfigModule protocol.
 * Config modules can inherit from this class to get default behavior for
 * serialization, property management, validation, and deprecated property handling.
 *
 * Subclasses should override specific methods to customize behavior:
 * - applyDefaults: Set default values for all properties
 * - deprecatedPropertyMappings: Map old property names to new ones
 * - sensitivePropertyNames: List properties that should be redacted
 * - validateValue:forKey: Custom validation logic
 * - contributeDeprecatedProperties:redact: Add flat properties for transition period
 */
@interface TSConfigModuleBase : NSObject <TSConfigModule>

#pragma mark - TSConfigModule Protocol Implementation

// Base returns a map: prop-name -> spec
- (NSDictionary<NSString*, TSPropertySpec*> *)propertySpecs;

/**
 * Apply default values to all properties.
 * Base implementation does nothing - subclasses must override.
 */
- (void)applyDefaults;

/**
 * Update module properties from a dictionary with deprecated property name handling.
 * Automatically maps deprecated property names and logs warnings.
 */
- (void)updateWithDictionary:(NSDictionary *)config;

/**
 * Apply a config dictionary to this module and return a diff of changed properties.
 *
 * @param config Dictionary of updates (possibly including deprecated keys)
 * @return A dictionary keyed by property name, where each value is a dictionary
 *         with @"old" and @"new" keys for the property values.
 */
- (NSDictionary<NSString *, NSDictionary *> *)applyAndDiff:(NSDictionary *)config;

/**
 * Convert the module to a dictionary representation using runtime introspection.
 * Automatically includes all declared properties.
 */
- (NSDictionary *)toDictionary;

/**
 * Convert the module to a dictionary with optional redaction of sensitive data.
 * Uses sensitivePropertyNames to determine what to redact.
 */
- (NSDictionary *)toDictionary:(BOOL)redact;

/**
 * Get all property names for this class using runtime introspection.
 * Results are cached for performance.
 */
- (NSArray<NSString *> *)allPropertyNames;

#pragma mark - Property Management

/**
 * Check if this module can handle the given property key.
 * Checks both current properties and deprecated property mappings.
 */
- (BOOL)canHandleProperty:(NSString *)key;

/**
 * Map a deprecated property name to its current name.
 * Subclasses should override deprecatedPropertyMappings to provide mappings.
 */
- (nullable NSString *)currentPropertyNameForDeprecated:(NSString *)deprecatedKey;

/**
 * Validate a value before setting it on a property.
 * Base implementation returns the value unchanged.
 * Subclasses can override for custom validation.
 */
- (nullable id)validateValue:(id)value forKey:(NSString *)key;

/**
 * Called when a property value changes.
 * Base implementation does nothing.
 * Subclasses can override to perform additional actions.
 */
- (void)propertyDidChange:(NSString *)key oldValue:(nullable id)oldValue newValue:(nullable id)newValue;

/**
 * Reset a specific property to its default value.
 * Base implementation creates a temporary instance and copies the default value.
 */
- (void)resetPropertyToDefault:(NSString *)propertyName;

/**
 * Perform validation after all properties have been updated.
 * Base implementation returns YES.
 * Subclasses can override for cross-property validation.
 */
- (BOOL)validateConfiguration;

/**
 * Contribute deprecated properties for transition period.
 * Base implementation does nothing.
 * Subclasses should override to add their flat properties to the dictionary.
 */
- (void)contributeDeprecatedProperties:(NSMutableDictionary *)dictionary redact:(BOOL)redact;

#pragma mark - Subclass Override Points

/**
 * Return a dictionary mapping deprecated property names to current names.
 * Subclasses should override to provide their specific mappings.
 *
 * @return Dictionary where keys are deprecated names, values are current names
 */
- (NSDictionary<NSString *, NSString *> *)deprecatedPropertyMappings;

/**
 * Return an array of property names that should be considered "sensitive"
 * and redacted when toDictionary:(YES) is called.
 * Base implementation returns empty array.
 *
 * @return Array of sensitive property names
 */
- (NSArray<NSString *> *)sensitivePropertyNames;

#pragma mark - Utility Methods

/**
 * Check if a property exists on this class.
 *
 * @param propertyName Property name to check
 * @return YES if property exists
 */
- (BOOL)hasProperty:(NSString *)propertyName;

/**
 * Helper method to check if two values are equal, handling nil cases properly.
 *
 * @param value1 First value to compare
 * @param value2 Second value to compare
 * @return YES if values are equal (including both being nil)
 */
- (BOOL)isValue:(nullable id)value1 equalTo:(nullable id)value2;

/**
 * Get the current value of a property, handling potential nil cases.
 *
 * @param propertyName Property name
 * @return Current property value, or appropriate default for nil
 */
- (nullable id)valueForProperty:(NSString *)propertyName;

/**
 * Set a property value with validation and change notification.
 *
 * @param value New value to set
 * @param propertyName Property name
 * @return YES if value was set successfully
 */
- (BOOL)setValue:(nullable id)value forProperty:(NSString *)propertyName;

@end


NS_ASSUME_NONNULL_END
