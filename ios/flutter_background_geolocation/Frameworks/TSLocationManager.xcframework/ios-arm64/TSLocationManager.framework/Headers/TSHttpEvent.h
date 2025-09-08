//
//  TSHttpEvent.h
//  TSLocationManager
//
//  Created by Christopher Scott on 2017-07-28.
//  Copyright © 2017 Transistor Software. All rights reserved.
//
#import "TSJSON.h"  // for TSJSON typedef (id)

NS_ASSUME_NONNULL_BEGIN

@interface TSHttpEvent : NSObject

@property (nonatomic, readonly) BOOL isSuccess;
@property (nonatomic, readonly) NSInteger statusCode;
@property (nonatomic, readonly, nullable) TSJSON requestData;   // was NSDictionary *
@property (nonatomic, readonly, copy) NSString *responseText;   // add 'copy' for NSString
@property (nonatomic, readonly, strong, nullable) NSError *error;

- (instancetype)initWithStatusCode:(NSInteger)statusCode
                       requestData:(nullable TSJSON)requestData
                      responseData:(nullable NSData *)responseData
                             error:(nullable NSError *)error;

-(NSDictionary*) toDictionary;
@end

NS_ASSUME_NONNULL_END
