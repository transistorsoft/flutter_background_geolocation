//
//  TSPropertySpec.h
//  TSLocationManager
//
//  Created by Christopher Scott on 2025-09-08.
//  Copyright © 2025 Christopher Scott. All rights reserved.
//
// TSPropertySpec.h
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef id _Nullable (^TSPropTransform)(id _Nullable incoming);
typedef BOOL        (^TSPropValidate)(id _Nullable value);
typedef BOOL        (^TSPropEquals)(id _Nullable a, id _Nullable b);

@interface TSPropertySpec : NSObject <NSCopying>
@property (nonatomic, copy) NSString *name;                       // KVC name
@property (nonatomic, copy, nullable) NSArray<NSString*> *deprecatedKeys;
@property (nonatomic, copy, nullable) TSPropTransform transform;  // coerce inbound types
@property (nonatomic, copy, nullable) TSPropValidate  validate;   // per-prop validation
@property (nonatomic, copy, nullable) TSPropEquals    equals;     // custom equality if needed

// Factory helpers moved onto TSPropertySpec (no category/linking issues)

/// Core “prototype” specs. You still give them a name per property via the Named: helpers.
+ (TSPropertySpec *)boolSpec;
+ (TSPropertySpec *)doubleSpec;
+ (TSPropertySpec *)integerSpec;
+ (TSPropertySpec *)nonNegativeIntegerSpec;
+ (TSPropertySpec *)nonNegativeDoubleSpec;
+ (TSPropertySpec *)positiveDoubleSpec;
+ (TSPropertySpec *)dictionarySpec;     // accepts only NSDictionary, else {}
+ (TSPropertySpec *)stringSpec;         // coerces to NSString (via -description)
+ (TSPropertySpec *)nonEmptyStringSpec; // trims; returns @"" if nil
+ (TSPropertySpec *)arraySpec;

/// Helpers to create named copies in one call.
+ (TSPropertySpec *)boolNamed:(NSString *)name;
+ (TSPropertySpec *)doubleNamed:(NSString *)name;
+ (TSPropertySpec *)doubleNamed:(NSString *)name
                          clamp:(nullable double(^)(double n, BOOL *warn))clamp;
+ (TSPropertySpec *)integerNamed:(NSString *)name;
+ (TSPropertySpec *)integerNamed:(NSString *)name
                           clamp:(nullable NSInteger(^)(NSInteger n, BOOL *warn))clamp;
+ (TSPropertySpec *)nonNegativeIntegerNamed:(NSString *)name;
+ (TSPropertySpec *)nonNegativeDoubleNamed:(NSString *)name;
+ (TSPropertySpec *)positiveDoubleNamed:(NSString *)name;
+ (TSPropertySpec *)dictionaryNamed:(NSString *)name;
+ (TSPropertySpec *)stringNamed:(NSString *)name;
+ (TSPropertySpec *)nonEmptyStringNamed:(NSString *)name;
+ (TSPropertySpec *)arrayNamed:(NSString *)name;

+ (TSPropertySpec *)objectNamed:(NSString *)name;
+ (TSPropertySpec *)moduleNamed:(NSString *)name class:(Class)cls;

/// Enum helpers
+ (TSPropertySpec *)enumNamed:(NSString *)name
                  fromStrings:(NSDictionary<NSString*, NSNumber*> *)map
                  defaultEnum:(NSNumber *)fallback;

@end

NS_ASSUME_NONNULL_END
