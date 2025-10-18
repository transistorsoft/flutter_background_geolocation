//
//  TSPersistMode.h
//  TSLocationManager
//
//  Created by Christopher Scott on 2025-09-09.
//  Copyright © 2025 Christopher Scott. All rights reserved.
//
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TSPersistMode) {
    TSPersistModeNone      = 0,
    TSPersistModeAll       = 2,
    TSPersistModeLocation  = 1,
    TSPersistModeGeofence  = -1
};
