//
//  TSLocationTypes.h
//  TSLocationManager
//
//  Created by Christopher Scott on 2025-08-11.
//  Copyright © 2025 Christopher Scott. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_CLOSED_ENUM(NSInteger, TSLocationType) {
    TSLocationTypeMotionChange = 0,
    TSLocationTypeTracking     = 1,
    TSLocationTypeCurrent      = 2,
    TSLocationTypeSample       = 3,
    TSLocationTypeWatch        = 4,
    TSLocationTypeGeofence     = 5,
    TSLocationTypePolygon      = 6,
    TSLocationTypeHeartbeat    = 7,
    TSLocationTypeMotionState  = 8,
    TSLocationTypeOdometer     = 9,
    TSLocationTypeStream       = 10
};

// A unique identifier for an active location stream (watchPosition)
typedef NSInteger TSLocationStreamId;
