#import <Flutter/Flutter.h>
#import <TSLocationManager/TSLocationManager.h>

@interface FLTBackgroundGeolocationPlugin : NSObject<FlutterPlugin>

@property (nonatomic, strong) TSLocationManager* locationManager;

@end
