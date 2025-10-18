//
//  TSConfigModule2.h
//  TSLocationManager
//
//  Created by Christopher Scott on 2025-09-05.
//  Copyright © 2025 Christopher Scott. All rights reserved.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Protocol that all TSConfig modules must implement.
 * Provides a consistent interface for configuration management,
 * serialization, validation, and property routing across all module types.
 */
@protocol TSConfigModule <NSObject>

@required

/**
 * Apply default values to all properties in this module.
 * Called during initialization and reset operations.
 */
- (void)applyDefaults;

/**
 * Update module properties from a dictionary with deep merging.
 * Should only update properties that are present in the dictionary,
 * leaving others unchanged. Handles deprecated property name mapping.
 *
 * @param config Dictionary containing property updates
 */
- (void)updateWithDictionary:(NSDictionary *)config;

/**
 * Convert the module to a dictionary representation.
 * Used for serialization, persistence, and cross-platform marshalling.
 *
 * @return Dictionary containing all module properties
 */
- (NSDictionary *)toDictionary;

/**
 * Convert the module to a dictionary with optional redaction of sensitive data.
 * Used when sensitive information (like access tokens) should be excluded.
 *
 * @param redact Whether to redact sensitive information
 * @return Dictionary containing module properties, potentially with sensitive data redacted
 */
- (NSDictionary *)toDictionary:(BOOL)redact;

/**
 * Get all property names for this module using runtime introspection.
 * Used by TSConfig for automatic KVO setup and property routing.
 *
 * @return Array of all declared property names
 */
- (NSArray<NSString *> *)allPropertyNames;

@optional

/**
 * Check if this module can handle the given property key.
 * Used by TSConfig to route flat properties to appropriate modules.
 * Default implementation checks if property exists on the class.
 *
 * @param key Property name to check
 * @return YES if this module owns this property (current or deprecated name)
 */
- (BOOL)canHandleProperty:(NSString *)key;

/**
 * Map a deprecated property name to its current name.
 * Enables backward compatibility for renamed properties.
 *
 * @param deprecatedKey The old property name
 * @return The current property name, or nil if not a deprecated key
 */
- (nullable NSString *)currentPropertyNameForDeprecated:(NSString *)deprecatedKey;

/**
 * Validate a value before setting it on a property.
 * Modules can implement custom validation logic for their properties.
 *
 * @param value The value to validate
 * @param key The property name
 * @return The validated (and potentially modified) value, or original value if no validation
 */
- (nullable id)validateValue:(id)value forKey:(NSString *)key;

/**
 * Called when a property value changes.
 * Allows modules to perform additional actions on property changes,
 * such as updating dependent properties.
 *
 * @param key The property that changed
 * @param oldValue The previous value
 * @param newValue The new value
 */
- (void)propertyDidChange:(NSString *)key oldValue:(nullable id)oldValue newValue:(nullable id)newValue;

/**
 * Return an array of property names that should be considered "sensitive"
 * and redacted when toDictionary:(YES) is called.
 *
 * @return Array of sensitive property names
 */
- (NSArray<NSString *> *)sensitivePropertyNames;

/**
 * Reset a specific property to its default value.
 * If not implemented, the module will use setValue:forKey: with the default value.
 *
 * @param propertyName The property to reset
 */
- (void)resetPropertyToDefault:(NSString *)propertyName;

/**
 * Perform validation after all properties have been updated.
 * Useful for cross-property validation or dependent property updates.
 *
 * @return YES if the module state is valid, NO otherwise
 */
- (BOOL)validateConfiguration;

/**
 * Contribute deprecated property names and values to the main dictionary.
 * Used during transition period to provide both flat and modular representations.
 *
 * @param dictionary Mutable dictionary to add deprecated properties to
 * @param redact Whether to redact sensitive information
 */
- (void)contributeDeprecatedProperties:(NSMutableDictionary *)dictionary redact:(BOOL)redact;

@end

NS_ASSUME_NONNULL_END
