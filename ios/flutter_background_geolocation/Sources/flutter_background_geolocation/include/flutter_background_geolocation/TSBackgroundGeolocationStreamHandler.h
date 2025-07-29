#import <Flutter/Flutter.h>
#import <TSLocationManager/TSLocationManager.h>

@interface TSBackgroundGeolocationStreamHandler : NSObject<FlutterStreamHandler>

+(void)register:(NSObject<FlutterPluginRegistrar>*)registrar;

@property (nonatomic, strong) NSString* event;
@property (nonatomic, strong) void(^callback)(id);

@end

