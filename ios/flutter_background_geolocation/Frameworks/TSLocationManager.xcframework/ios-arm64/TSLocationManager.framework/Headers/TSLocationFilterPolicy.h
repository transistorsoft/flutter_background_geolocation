//
//  TSLocationFilterPolicy.h
//  TSLocationManager
//
//  Created by Christopher Scott on 2025-09-11.
//  Copyright © 2025 Christopher Scott. All rights reserved.
//

/// High-level policy for how to treat dubious samples
typedef NS_ENUM(NSInteger, TSLocationFilterPolicy) {
    TSLocationFilterPolicyPassThrough = 0,
    TSLocationFilterPolicyAdjust,
    TSLocationFilterPolicyConservative
};
