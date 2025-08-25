//
//  TSEnabledChangeEvent.h
//  TSLocationManager
//
//  Created by Christopher Scott on 2018-02-22.
//  Copyright © 2018 Transistor Software. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface TSEnabledChangeEvent : NSObject

@property (nonatomic, readonly) BOOL enabled;
-(instancetype) initWithEnabled:(BOOL)enabled;

@end

NS_ASSUME_NONNULL_END
