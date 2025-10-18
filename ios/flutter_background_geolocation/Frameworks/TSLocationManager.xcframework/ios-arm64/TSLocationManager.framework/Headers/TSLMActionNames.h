//
//  TSLMActionName.h
//  TSLMActionName.h
//  TSLocationManager
//
//  Created by Christopher Scott on 2025-09-02.
//  Copyright © 2025 Christopher Scott. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// Action names
extern NSString *const TSLMActionReady;
extern NSString *const TSLMActionStart;
extern NSString *const TSLMActionStop;
extern NSString *const TSLMActionGetState;
extern NSString *const TSLMActionStartGeofences;
extern NSString *const TSLMActionStartSchedule;
extern NSString *const TSLMActionStopSchedule;
extern NSString *const TSLMActionStartBackgroundTask;
extern NSString *const TSLMActionFinish;
extern NSString *const TSLMActionReset;
extern NSString *const TSLMActionSetConfig;
extern NSString *const TSLMActionChangePace;
extern NSString *const TSLMActionGetCurrentPosition;
extern NSString *const TSLMActionWatchPosition;
extern NSString *const TSLMActionStopWatchPosition;
extern NSString *const TSLMActionGetLocations;
extern NSString *const TSLMActionInsertLocation;
extern NSString *const TSLMActionGetCount;
extern NSString *const TSLMActionDestroyLocations;
extern NSString *const TSLMActionDestroyLocation;
extern NSString *const TSLMActionSync;
extern NSString *const TSLMActionGetOdometer;
extern NSString *const TSLMActionSetOdometer;
extern NSString *const TSLMActionResetOdometer;
extern NSString *const TSLMActionAddGeofence;
extern NSString *const TSLMActionAddGeofences;
extern NSString *const TSLMActionRemoveGeofence;
extern NSString *const TSLMActionRemoveGeofences;
extern NSString *const TSLMActionGetGeofences;
extern NSString *const TSLMActionGetGeofence;
extern NSString *const TSLMActionGeofenceExists;

extern NSString *const TSLMActionGetLog;
extern NSString *const TSLMActionEmailLog;
extern NSString *const TSLMActionUploadLog;
extern NSString *const TSLMActionDestroyLog;
extern NSString *const TSLMActionLog;
extern NSString *const TSLMActionGetSensors;
extern NSString *const TSLMActionIsPowerSaveMode;
extern NSString *const TSLMActionPlaySound;
extern NSString *const TSLMActionRegisterHeadlessTask;
extern NSString *const TSLMActionInitialized;
extern NSString *const TSLMActionRequestPermission;
extern NSString *const TSLMActionRequestTemporaryFullAccuracy;
extern NSString *const TSLMActionGetProviderState;
extern NSString *const TSLMActionIsIgnoringBatteryOptimizations;
extern NSString *const TSLMActionRequestSettings;
extern NSString *const TSLMActionShowSettings;
extern NSString *const TSLMActionRegisterPlugin;
extern NSString *const TSLMActionGetDeviceInfo;
extern NSString *const TSLMActionGetTransistorToken;
extern NSString *const TSLMActionDestroyTransistorToken;

NS_ASSUME_NONNULL_END
