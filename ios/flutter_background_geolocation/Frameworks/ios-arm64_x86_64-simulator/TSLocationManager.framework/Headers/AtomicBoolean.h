//
//  AtomicBoolean.h
//  TSLocationManager
//
//  Created by Christopher Scott on 2018-11-14.
//  Modernized with C11 atomic support
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Thread-safe boolean using C11 atomic operations
@interface AtomicBoolean : NSObject

- (instancetype)initWithValue:(BOOL)value;
- (BOOL)getValue;
- (void)setValue:(BOOL)value;
- (BOOL)compareTo:(BOOL)expected andSetValue:(BOOL)value;
- (BOOL)getAndSetValue:(BOOL)value;

@end

NS_ASSUME_NONNULL_END
