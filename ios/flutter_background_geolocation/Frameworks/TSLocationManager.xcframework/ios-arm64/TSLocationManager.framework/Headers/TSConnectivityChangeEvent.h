//
//  TSConnectivityChangeEvent.h
//  TSLocationManager
//
//  Created by Christopher Scott on 2018-02-22.
//  Copyright © 2018 Transistor Software. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface TSConnectivityChangeEvent : NSObject

@property (nonatomic, readonly) BOOL hasConnection;

-(instancetype) initWithHasConnection:(BOOL)hasConnection;

- (NSDictionary<NSString *, id> *)toDictionary;

@end

NS_ASSUME_NONNULL_END
