//
//  TSKalmanProfile.h
//  TSLocationManager
//
//  Created by Christopher Scott on 2025-09-10.
//  Copyright © 2025 Christopher Scott. All rights reserved.
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TSKalmanProfile) {
    TSKalmanProfileDefault = 0,      // balanced
    TSKalmanProfileAggressive = 1,   // very smooth, slow to react
    TSKalmanProfileConservative = 2  // quick to react, less smoothing
};



