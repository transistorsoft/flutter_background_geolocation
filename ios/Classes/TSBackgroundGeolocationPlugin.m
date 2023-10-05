#import "TSBackgroundGeolocationPlugin.h"


static NSString *const PLUGIN_PATH = @"com.transistorsoft/flutter_background_geolocation";
static NSString *const METHOD_CHANNEL_NAME      = @"methods";

// Action names
static NSString *const ACTION_READY = @"ready";
static NSString *const ACTION_START = @"start";
static NSString *const ACTION_STOP = @"stop";
static NSString *const ACTION_GET_STATE = @"getState";
static NSString *const ACTION_START_GEOFENCES = @"startGeofences";
static NSString *const ACTION_START_SCHEDULE = @"startSchedule";
static NSString *const ACTION_STOP_SCHEDULE = @"stopSchedule";
static NSString *const ACTION_START_BACKGROUND_TASK = @"startBackgroundTask";
static NSString *const ACTION_FINISH = @"finish";
static NSString *const ACTION_RESET = @"reset";
static NSString *const ACTION_SET_CONFIG = @"setConfig";
static NSString *const ACTION_CHANGE_PACE = @"changePace";
static NSString *const ACTION_GET_CURRENT_POSITION = @"getCurrentPosition";
static NSString *const ACTION_WATCH_POSITION = @"watchPosition";
static NSString *const ACTION_GET_LOCATIONS = @"getLocations";
static NSString *const ACTION_INSERT_LOCATION = @"insertLocation";
static NSString *const ACTION_GET_COUNT = @"getCount";
static NSString *const ACTION_DESTROY_LOCATIONS = @"destroyLocations";
static NSString *const ACTION_DESTROY_LOCATION  = @"destroyLocation";
static NSString *const ACTION_SYNC = @"sync";
static NSString *const ACTION_GET_ODOMETER = @"getOdometer";
static NSString *const ACTION_SET_ODOMETER = @"setOdometer";
static NSString *const ACTION_ADD_GEOFENCE = @"addGeofence";
static NSString *const ACTION_ADD_GEOFENCES = @"addGeofences";
static NSString *const ACTION_REMOVE_GEOFENCE = @"removeGeofence";
static NSString *const ACTION_REMOVE_GEOFENCES = @"removeGeofences";
static NSString *const ACTION_GET_GEOFENCES = @"getGeofences";
static NSString *const ACTION_GET_GEOFENCE = @"getGeofence";
static NSString *const ACTION_GEOFENCE_EXISTS = @"geofenceExists";

static NSString *const ACTION_GET_LOG = @"getLog";
static NSString *const ACTION_EMAIL_LOG = @"emailLog";
static NSString *const ACTION_UPLOAD_LOG = @"uploadLog";
static NSString *const ACTION_DESTROY_LOG = @"destroyLog";
static NSString *const ACTION_LOG = @"log";
static NSString *const ACTION_GET_SENSORS = @"getSensors";
static NSString *const ACTION_IS_POWER_SAVE_MODE = @"isPowerSaveMode";
static NSString *const ACTION_PLAY_SOUND = @"playSound";
static NSString *const ACTION_REGISTER_HEADLESS_TASK = @"registerHeadlessTask";
static NSString *const ACTION_INITIALIZED = @"initialized";
static NSString *const ACTION_REQUEST_PERMISSION = @"requestPermission";
static NSString *const ACTION_REQUEST_TEMPORARY_FULL_ACCURACY = @"requestTemporaryFullAccuracy";
static NSString *const ACTION_GET_PROVIDER_STATE = @"getProviderState";
static NSString *const ACTION_IS_IGNORING_BATTERY_OPTIMIZATIONS = @"isIgnoringBatteryOptimizations";
static NSString *const ACTION_REQUEST_SETTINGS = @"requestSettings";
static NSString *const ACTION_SHOW_SETTINGS = @"showSettings";
static NSString *const ACTION_REGISTER_PLUGIN = @"registerPlugin";
static NSString *const ACTION_GET_DEVICE_INFO = @"getDeviceInfo";
static NSString *const ACTION_GET_TRANSISTOR_TOKEN = @"getTransistorToken";
static NSString *const ACTION_DESTROY_TRANSISTOR_TOKEN = @"destroyTransistorToken";

@implementation TSBackgroundGeolocationPlugin {
    BOOL ready;
}


+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    // Method Channel
    NSString *path = [NSString stringWithFormat:@"%@/%@", PLUGIN_PATH, METHOD_CHANNEL_NAME];
    FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:path binaryMessenger:[registrar messenger]];

    TSBackgroundGeolocationPlugin* instance = [[TSBackgroundGeolocationPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];

    // Event Channels
    [TSLocationStreamHandler register:registrar];
    [TSMotionChangeStreamHandler register:registrar];
    [TSActivityChangeStreamHandler register:registrar];
    [TSProviderChangeStreamHandler register:registrar];
    [TSHttpStreamHandler register:registrar];
    [TSScheduleStreamHandler register:registrar];
    [TSGeofencesChangeStreamHandler register:registrar];
    [TSGeofenceStreamHandler register:registrar];
    [TSHeartbeatStreamHandler register:registrar];
    [TSPowerSaveChangeStreamHandler register:registrar];
    [TSConnectivityChangeStreamHandler register:registrar];
    [TSEnabledChangeStreamHandler register:registrar];
    [TSNotificationActionStreamHandler register:registrar];
    [TSAuthorizationStreamHandler register:registrar];
}

- (instancetype) init {
    self = [super init];

    if (self) {
        ready = NO;
        _locationManager = [TSLocationManager sharedInstance];

        // Provide reference to rootViewController for #emailLog method.
        UIViewController *root = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        _locationManager.viewController = root;
    }
    return self;
}
- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString *action = call.method;

    if ([self method:ACTION_READY is:action]) {
        [self ready:call.arguments result:result];
    } else if ([self method:ACTION_START is:action]) {
        [self start:result];
    } else if ([self method:ACTION_STOP is:action]) {
        [self stop:result];
    } else if ([self method:ACTION_GET_STATE is:action]) {
        [self getState:result];
    } else if ([self method:ACTION_START_GEOFENCES is:action]) {
        [self startGeofences:result];
    } else if ([self method:ACTION_START_SCHEDULE is:action]) {
        [self startSchedule:result];
    } else if ([self method:ACTION_STOP_SCHEDULE is:action]) {
        [self stopSchedule:result];
    } else if ([self method:ACTION_START_BACKGROUND_TASK is:action]) {
        [self startBackgroundTask:result];
    } else if ([self method:ACTION_FINISH is:action]) {
        [self finish:[call.arguments intValue] result:result];
    } else if ([self method:ACTION_RESET is:action]) {
        [self reset:call.arguments result:result];
    } else if ([self method:ACTION_SET_CONFIG is:action]) {
        [self setConfig:call.arguments result:result];
    } else if ([self method:ACTION_CHANGE_PACE is:action]) {
        [self changePace:[call.arguments boolValue] result:result];
    } else if ([self method:ACTION_GET_CURRENT_POSITION is:action]) {
        [self getCurrentPosition:call.arguments result:result];
    } else if ([self method:ACTION_WATCH_POSITION is:action]) {
        [self watchPosition:call.arguments result:result];
    } else if ([self method:ACTION_GET_LOCATIONS is:action]) {
        [self getLocations:result];
    } else if ([self method:ACTION_INSERT_LOCATION is:action]) {
        [self insertLocation:call.arguments result:result];
    } else if ([self method:ACTION_GET_COUNT is:action]) {
        [self getCount:result];
    } else if ([self method:ACTION_DESTROY_LOCATIONS is:action]) {
        [self destroyLocations:result];
    } else if ([self method:ACTION_DESTROY_LOCATION is:action]) {
        [self destroyLocation:call.arguments result:result];
    } else if ([self method:ACTION_SYNC is:action]) {
        [self sync:result];
    } else if ([self method:ACTION_GET_ODOMETER is:action]) {
        [self getOdometer:result];
    } else if ([self method:ACTION_SET_ODOMETER is:action]) {
        [self setOdometer:[call.arguments doubleValue] result:result];
    } else if ([self method:ACTION_ADD_GEOFENCE is:action]) {
        [self addGeofence:call.arguments result:result];
    } else if ([self method:ACTION_ADD_GEOFENCES is:action]) {
        [self addGeofences:call.arguments result:result];
    } else if ([self method:ACTION_REMOVE_GEOFENCE is:action]) {
        [self removeGeofence:call.arguments result:result];
    } else if ([self method:ACTION_REMOVE_GEOFENCES is:action]) {
        [self removeGeofences:result];
    } else if ([self method:ACTION_GET_GEOFENCES is:action]) {
        [self getGeofences:result];
    } else if ([self method:ACTION_GET_GEOFENCE is:action]) {
        [self getGeofence:call.arguments result:result];
    } else if ([self method:ACTION_GEOFENCE_EXISTS is:action]) {
        [self geofenceExists:call.arguments result:result];
    } else if ([self method:ACTION_GET_LOG is:action]) {
        [self getLog:call.arguments result:result];
    } else if ([self method:ACTION_UPLOAD_LOG is:action]) {
        [self uploadLog:call.arguments result:result];
    }  else if ([self method:ACTION_DESTROY_LOG is:action]) {
        [self destroyLog:result];
    } else if ([self method:ACTION_EMAIL_LOG is:action]) {
        [self emailLog:call.arguments result:result];
    } else if ([self method:ACTION_LOG is:action]) {
        NSArray *args = (NSArray*) call.arguments;
        NSString *level = [args objectAtIndex:0];
        NSString *message = [args objectAtIndex:1];
        [self log:level message:message result:result];
    } else if ([self method:ACTION_GET_SENSORS is:action]) {
        [self getSensors:result];
    } else if ([self method:ACTION_GET_DEVICE_INFO is:action]) {
        [self getDeviceInfo:result];
    } else if ([self method:ACTION_GET_TRANSISTOR_TOKEN is:action]) {
        [self getTransistorToken:call.arguments result:result];
    } else if ([self method:ACTION_DESTROY_TRANSISTOR_TOKEN is:action]) {
        [self destroyTransistorToken:call.arguments result:result];
    } else if ([self method:ACTION_IS_POWER_SAVE_MODE is:action]) {
        [self isPowerSaveMode:result];
    } else if ([self method:ACTION_IS_IGNORING_BATTERY_OPTIMIZATIONS is:action]) {
        result(@NO);
    } else if ([self method:ACTION_REQUEST_SETTINGS is:action]) {
        result([FlutterError errorWithCode:@"0" message:@"No iOS implementation" details:nil]);
    } else if ([self method:ACTION_SHOW_SETTINGS is:action]) {
        result([FlutterError errorWithCode:@"0" message:@"No iOS implementation" details:nil]);
    } else if ([self method:ACTION_PLAY_SOUND is:action]) {
        [self playSound:[call.arguments intValue] result:result];
    } else if ([@"getPlatformVersion" isEqualToString:call.method]) {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    } else if ([self method:ACTION_REGISTER_HEADLESS_TASK is:action]) {
        [self registerHeadlessTask:call.arguments result:result];
    } else if ([self method:ACTION_GET_PROVIDER_STATE is:action]) {
        [self getProviderState:result];
    } else if ([self method:ACTION_REQUEST_PERMISSION is:action]) {
        [self requestPermission:call.arguments result:result];
    } else if ([self method:ACTION_REQUEST_TEMPORARY_FULL_ACCURACY is:action]) {
        [self requestTemporaryFullAccuracy:call.arguments result:result];
    } else if ([self method:ACTION_INITIALIZED is:action]) {
        // Headless task initialization ignored on iOS.
        result(@YES);
    } else if ([self method:ACTION_REGISTER_PLUGIN is:action]) {
        [self registerPlugin:call.arguments result:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

// See issue https://github.com/flutter/flutter/issues/44256#issuecomment-583507578
- (void)detachFromEngineForRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    NSLog(@"[BackgroundGeolocation detachFromEngineForRegistrar -- NO IMPLEMENTATION");
}

- (void) getProviderState:(FlutterResult)result {
    TSProviderChangeEvent *event = [_locationManager getProviderState];
    result([event toDictionary]);
}

/// NOTE: For future implementation, this method accepts an unused NSString* permission for future implementation of requesting individual permissions.
- (void) requestPermission:(NSString*)permission result:(FlutterResult)result {
    [_locationManager requestPermission:^(NSNumber *status) {
        result(status);
    } failure:^(NSNumber *status) {
        result([FlutterError errorWithCode:@"DENIED" message:nil details:status]);
    }];
}

- (void) requestTemporaryFullAccuracy:(NSString*)purpose result:(FlutterResult)result {
    [_locationManager requestTemporaryFullAccuracy:purpose success:^(NSInteger accuracyAuthorization) {
        result(@(accuracyAuthorization));
    } failure:^(NSError *error) {
        result([FlutterError errorWithCode:[NSString stringWithFormat:@"%ld", (long) error.code] message:error.userInfo[@"NSDebugDescription"] details:nil]);
    }];
}

#pragma mark API methods
- (void) ready:(NSDictionary*)params result:(FlutterResult)result {
    BOOL reset = (params[@"reset"]) ? [params[@"reset"] boolValue] : YES;
    TSLocationManager *locationManager = [TSLocationManager sharedInstance];

    if (ready) {
        if (reset) {
            [locationManager log:@"warn" message:@"#ready already called.  Redirecting to #setConfig"];
            [self setConfig:params result:result];
        } else {
            [locationManager log:@"warn" message:@"#ready already called.  Ignored Config since reset: false"];
            result([[TSConfig sharedInstance] toDictionary]);
        }
        return;
    }
    ready = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        TSConfig *config = [TSConfig sharedInstance];
        if (config.isFirstBoot) {
            [config updateWithDictionary:params];
        } else {
            if (reset) {
                [config reset:YES];
                [config updateWithDictionary:params];
            } else if ([params objectForKey:@"authorization"]) {
                [config updateWithBlock:^(TSConfigBuilder *builder) {
                    builder.authorization = [TSAuthorization createWithDictionary:[params objectForKey:@"authorization"]];
                }];
            }
        }
        [self.locationManager ready];
        result([config toDictionary]);
    });
}

- (void) getState:(FlutterResult)result {
    result([_locationManager getState]);
}

- (void) start:(FlutterResult)result {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.locationManager start];
        result([self.locationManager getState]);
    });
}

- (void) stop:(FlutterResult)result {
    [_locationManager stop];
    result([_locationManager getState]);
}

- (void) startGeofences:(FlutterResult)result {
    dispatch_async(dispatch_get_main_queue(), ^{
        TSConfig *config = [TSConfig sharedInstance];
        [self.locationManager startGeofences];
        result([config toDictionary]);
    });
}

- (void) startSchedule:(FlutterResult)result {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.locationManager startSchedule];
        result([self.locationManager getState]);
    });
}

- (void) stopSchedule:(FlutterResult)result {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.locationManager stopSchedule];
        result([self.locationManager getState]);
    });
}

- (void) reset:(NSDictionary*)params result:(FlutterResult)result {
    TSConfig *config = [TSConfig sharedInstance];
    if (params) {
        [config reset:YES];
        [config updateWithDictionary:params];
    } else {
        [config reset];
    }
    result([config toDictionary]);
}

- (void) setConfig:(NSDictionary*)params result:(FlutterResult)result {
    TSConfig *config = [TSConfig sharedInstance];
    [config updateWithDictionary:params];
    result([config toDictionary]);
}

- (void) changePace:(BOOL)isMoving result:(FlutterResult)result {
    TSConfig *config = [TSConfig sharedInstance];
    if (!config.enabled) {
        result([FlutterError errorWithCode:@"0" message:@"BackgroundGeolocation is disabled" details:nil]);
        return;
    }
    [_locationManager changePace:isMoving];
    result(@(isMoving));
}

- (void) getCurrentPosition:(NSDictionary*)options result:(FlutterResult)result {

    TSCurrentPositionRequest *request = [[TSCurrentPositionRequest alloc] initWithSuccess:^(TSLocation *location) {
        result([location toDictionary]);
    } failure:^(NSError *error) {
        result([FlutterError errorWithCode: [NSString stringWithFormat:@"%lu", (long) error.code] message:nil details:nil]);
    }];

    if (options[@"timeout"]) {
        request.timeout = [options[@"timeout"] doubleValue];
    }
    if (options[@"maximumAge"]) {
        request.maximumAge = [options[@"maximumAge"] doubleValue];
    }
    if (options[@"persist"]) {
        request.persist = [options[@"persist"] boolValue];
    }
    if (options[@"samples"]) {
        request.samples = [options[@"samples"] intValue];
    }
    if (options[@"desiredAccuracy"]) {
        request.desiredAccuracy = [options[@"desiredAccuracy"] doubleValue];
    }
    if (options[@"extras"]) {
        request.extras = options[@"extras"];
    }
    [_locationManager getCurrentPosition:request];
}

- (void) watchPosition:(NSDictionary*)options result:(FlutterResult)result {
    /*
    TSWatchPositionRequest *request = [[TSWatchPositionRequest alloc] initWithSuccess:^(TSLocation *location) {
        [self sendEvent:EVENT_WATCHPOSITION body:[location toDictionary]];
    } failure:^(NSError *error) {

    }];

    if (options[@"interval"])           { request.interval = [options[@"interval"] doubleValue]; }
    if (options[@"desiredAccuracy"])    { request.desiredAccuracy = [options[@"desiredAccuracy"] doubleValue]; }
    if (options[@"persist"])            { request.persist = [options[@"persist"] boolValue]; }
    if (options[@"extras"])             { request.extras = options[@"extras"]; }
    if (options[@"timeout"])            { request.timeout = [options[@"timeout"] doubleValue]; }

    [locationManager watchPosition:request];
    success(@[]);
     */
}

- (void) getOdometer:(FlutterResult)result {
    result(@([_locationManager getOdometer]));
}

- (void) setOdometer:(double)value result:(FlutterResult)result {
    TSCurrentPositionRequest *request = [[TSCurrentPositionRequest alloc] initWithSuccess:^(TSLocation *location) {
        result([location toDictionary]);
    } failure:^(NSError *error) {
        result([FlutterError errorWithCode: [NSString stringWithFormat:@"%lu", (long) error.code] message:nil details:nil]);
    }];
    [_locationManager setOdometer:value request:request];
}

- (void) startBackgroundTask:(FlutterResult)result {
    result(@([_locationManager createBackgroundTask]));
}

- (void) finish:(int)taskId result:(FlutterResult)result {
    [_locationManager stopBackgroundTask:taskId];
    result(@(taskId));
}

#pragma mark HTTP & Persistence Methods

- (void) getLocations:(FlutterResult)result {
    [_locationManager getLocations:^(NSArray* records) {
        result(records);
    } failure:^(NSString* error) {
        result([FlutterError errorWithCode:error message:nil details:nil]);
    }];
}

- (void) insertLocation:(NSDictionary*)params result:(FlutterResult)result {
    [_locationManager insertLocation: params success:^(NSString* uuid) {
        result(uuid);
    } failure:^(NSString* error) {
        result([FlutterError errorWithCode:error message:nil details:nil]);
    }];
}

- (void) getCount:(FlutterResult)result {
    int count = [_locationManager getCount];
    if (count >= 0) {
        result(@(count));
    } else {
        result([FlutterError errorWithCode:@"GET_COUNT_ERROR" message:@"Unknown database error" details:nil]);
    }
}

- (void) destroyLocations:(FlutterResult)result {
    if ([_locationManager destroyLocations]) {
        result(@(YES));
    } else {
        result([FlutterError errorWithCode:@"DESTROY_LOCATIONS_ERROR" message:@"Failed to destroy locations" details:nil]);
    }
}

- (void) destroyLocation:(NSString*)uuid result:(FlutterResult)result {
    [_locationManager destroyLocation:uuid success:^{
        result(@(YES));
    } failure:^(NSString* error) {
        result([FlutterError errorWithCode:error message:error details:nil]);
    }];
}

- (void) sync:(FlutterResult)result {
    [_locationManager sync:^(NSArray* records) {
        result(records);
    } failure:^(NSError* error) {
        result([FlutterError errorWithCode:[NSString stringWithFormat:@"%lu", (long) error.code] message:@"Sync failure" details:nil]);
    }];
}

#pragma mark Geofencing Methods

- (void) addGeofence:(NSDictionary*)params result:(FlutterResult)result {

    TSGeofence *geofence = [self buildGeofence:params];
    if (!geofence) {
        NSString *error = [NSString stringWithFormat:@"Invalid geofence data: %@", params];
        result([FlutterError errorWithCode:@"BUILD_GEOFENCE_ERROR" message:error details:nil]);
        return;
    }
    [_locationManager addGeofence:geofence success:^{
        result(@(YES));
    } failure:^(NSString *error) {
        result([FlutterError errorWithCode:error message:nil details:nil]);
    }];
}

- (void) addGeofences:(NSArray*)data result:(FlutterResult)result {
    NSMutableArray *geofences = [NSMutableArray new];
    for (NSDictionary *params in data) {
        TSGeofence *geofence = [self buildGeofence:params];
        if (geofence != nil) {
            [geofences addObject:geofence];
        } else {
            NSString *error = [NSString stringWithFormat:@"Invalid geofence data: %@", params];
            result([FlutterError errorWithCode:@"BUILD_GEOFENCE_ERROR" message:error details:nil]);
            return;
        }
    }
    [_locationManager addGeofences:geofences success:^{
        result(@(YES));
    } failure:^(NSString *error) {
        result([FlutterError errorWithCode:error message:nil details:nil]);
    }];
}

-(TSGeofence*) buildGeofence:(NSDictionary*)params {
    // Sanity check.
    double radius;
    double latitude;
    double longitude;
    NSArray *vertices;
    BOOL isPolygon = ((params[@"vertices"] != nil) && (params[@"vertices"] != [NSNull null]));
    if (!isPolygon) {
        if ((params[@"radius"] == [NSNull null]) || (params[@"latitude"] == [NSNull null]) || (params[@"longitude"] == [NSNull null])) {
            return nil;
        }
        vertices = @[];
        radius = [params[@"radius"] doubleValue];
        latitude = [params[@"latitude"] doubleValue];
        longitude = [params[@"longitude"] doubleValue];
    } else {
        if (params[@"identifier"] == [NSNull null]) {
            return nil;
        }
        vertices = params[@"vertices"];
        radius = 0;
        latitude = 0;
        longitude = 0;
    }
        
    return [[TSGeofence alloc] initWithIdentifier: params[@"identifier"]
                                           radius: radius
                                         latitude: latitude
                                        longitude: longitude
                                    notifyOnEntry: (params[@"notifyOnEntry"]) ? [params[@"notifyOnEntry"] boolValue]  : NO
                                     notifyOnExit: (params[@"notifyOnExit"])  ? [params[@"notifyOnExit"] boolValue] : NO
                                    notifyOnDwell: (params[@"notifyOnDwell"]) ? [params[@"notifyOnDwell"] boolValue] : NO
                                   loiteringDelay: (params[@"loiteringDelay"]) ? [params[@"loiteringDelay"] doubleValue] : 0
                                           extras: params[@"extras"]
                                         vertices: vertices];
}

- (void) removeGeofence:(NSString*)identifier result:(FlutterResult)result {
    [_locationManager removeGeofence:identifier success:^{
        result(@(YES));
    } failure:^(NSString* error) {
        result([FlutterError errorWithCode:error message:nil details:nil]);
    }];
}

- (void) removeGeofences:(FlutterResult)result {
    NSArray *geofences = @[];
    [_locationManager removeGeofences:geofences success:^{
        result(@(YES));
    } failure:^(NSString* error) {
        result([FlutterError errorWithCode:error message:nil details:nil]);
    }];
}

- (void) getGeofence:(NSString*)identifier result:(FlutterResult)result {
    if (!identifier) {
        result([FlutterError errorWithCode:[NSString stringWithFormat:@"Invalid identifier: %@", identifier] message:nil details:nil]);
        return;
    }
    [_locationManager getGeofence:identifier success:^(TSGeofence *geofence) {
        result([geofence toDictionary]);
    } failure:^(NSString *error) {
        result([FlutterError errorWithCode:error message:nil details:nil]);
    }];
}

- (void) getGeofences:(FlutterResult)result {
    [_locationManager getGeofences:^(NSArray* geofences) {
        NSMutableArray *rs = [NSMutableArray new];
        for (TSGeofence *geofence in geofences) { [rs addObject:[geofence toDictionary]]; }
        result(rs);
    } failure:^(NSString* error) {
        result([FlutterError errorWithCode:error message:nil details:nil]);
    }];
}

- (void) geofenceExists:(NSString*)identifier result:(FlutterResult)result {
    if (!identifier) {
        result([FlutterError errorWithCode:[NSString stringWithFormat:@"Invalid identifier: %@", identifier] message:nil details:nil]);
        return;
    }

    [_locationManager geofenceExists:identifier callback:^(BOOL exists){
        result(@(exists));
    }];
}

#pragma mark Logging & Debug Methods

- (void) getLog:(NSDictionary*)params result:(FlutterResult)result {
    LogQuery *query = [[LogQuery alloc] initWithDictionary:params];
    [_locationManager getLog:query success:^(NSString* log) {
        result(log);
    } failure:^(NSString* error) {
        result([FlutterError errorWithCode:error message:nil details:nil]);
    }];
}

- (void) destroyLog:(FlutterResult)result {
    BOOL success = [_locationManager destroyLog];
    if (success) {
        result(@(YES));
    } else {
        result([FlutterError errorWithCode:@"UNKNOWN_ERROR" message:nil details:nil]);
    }
}

- (void) emailLog:(NSArray*)args result:(FlutterResult)result {
    NSString *email = [args objectAtIndex:0];
    NSDictionary *params = [args objectAtIndex:1];
    LogQuery *query = [[LogQuery alloc] initWithDictionary:params];
    [_locationManager emailLog:email query:query success:^{
        result(@(YES));
    } failure:^(NSString* error) {
        result([FlutterError errorWithCode:error message:nil details:nil]);
    }];
}

- (void) uploadLog:(NSArray*)args result:(FlutterResult)result {
    NSString *url = [args objectAtIndex:0];
    NSDictionary *params = [args objectAtIndex:1];
    LogQuery *query = [[LogQuery alloc] initWithDictionary:params];
    [_locationManager uploadLog:url query:query success:^{
        result(@(YES));
    } failure:^(NSString* error) {
        result([FlutterError errorWithCode:error message:nil details:nil]);
    }];
}

- (void) log:(NSString*)level message:(NSString*)message result:(FlutterResult)result {
    [_locationManager log:level message:message];
    result(@(YES));
}

- (void) getSensors:(FlutterResult)result {
    NSDictionary *sensors = @{
          @"platform": @"ios",
          @"accelerometer": @([_locationManager isAccelerometerAvailable]),
          @"gyroscope": @([_locationManager isGyroAvailable]),
          @"magnetometer": @([_locationManager isMagnetometerAvailable]),
          @"motion_hardware": @([_locationManager isMotionHardwareAvailable])
    };
    result(sensors);
}

- (void) getDeviceInfo:(FlutterResult)result {
    TSDeviceInfo *deviceInfo = [TSDeviceInfo sharedInstance];
    result([deviceInfo toDictionary:@"flutter"]);
}

- (void) getTransistorToken:(NSArray*)args result:(FlutterResult)result {
    NSString *orgname = [args objectAtIndex:0];
    NSString *username = [args objectAtIndex:1];
    NSString *url = [args objectAtIndex:2];

    [TransistorAuthorizationToken findOrCreateWithOrg:orgname
                                             username:username
                                                 url:url
                                            framework:@"flutter"
                                              success:^(TransistorAuthorizationToken *token) {
        result([token toDictionary]);
    } failure:^(NSError *error) {
        NSString *errorCode = [NSString stringWithFormat:@"%ld", (long) error.code];
        result([FlutterError errorWithCode:errorCode message:error.localizedDescription details:nil]);
    }];
}

- (void) destroyTransistorToken:(NSString*)url result:(FlutterResult)result {
    [TransistorAuthorizationToken destroyWithUrl:url];
    result(@(YES));
}

- (void) isPowerSaveMode:(FlutterResult)result {
    result(@([_locationManager isPowerSaveMode]));
}

- (void) playSound:(int) soundId result:(FlutterResult)result {
     [_locationManager playSound: soundId];
    result(@(YES));
}

- (void) registerHeadlessTask:(NSArray*)callbacks result:(FlutterResult)result {
    // iOS:  No implementation should be necessary.
}

- (void) registerPlugin:(NSString*)plugin result:(FlutterResult)result {
    TSConfig *config = [TSConfig sharedInstance];
    [config registerPlugin:plugin];
}

#pragma mark Util Methods

- (BOOL) method:(NSString*)method is:(NSString*)action {
    return [method isEqualToString:action];
}

@end
