//
//  TSTrackingMode.h
//  TSLocationManager
//
//  Created by Christopher Scott on 2025-09-09.
//  Copyright © 2025 Christopher Scott. All rights reserved.
//
#import <Foundation/Foundation.h>

/// Tracking strategy.
/// In Swift this appears as `TSTrackingMode` with cases `.geofence` and `.location`.
typedef NS_ENUM(NSInteger, TSTrackingMode) {
    TSTrackingModeGeofence = 0,
    TSTrackingModeLocation = 1
};
