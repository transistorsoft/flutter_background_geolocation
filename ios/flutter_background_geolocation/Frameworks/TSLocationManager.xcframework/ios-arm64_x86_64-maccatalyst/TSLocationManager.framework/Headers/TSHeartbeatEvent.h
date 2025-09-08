//
//  TSHeartbeat.h
//  TSLocationManager
//
//  Created by Christopher Scott on 2017-07-28.
//  Copyright © 2017 Transistor Software. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface TSHeartbeatEvent : NSObject

@property (nonatomic, readonly) CLLocation* location;
@property (nonatomic, readonly) NSDictionary *data;

-(id) initWithLocation:(CLLocation*)location;
-(NSDictionary*) toDictionary;
@end

NS_ASSUME_NONNULL_END
