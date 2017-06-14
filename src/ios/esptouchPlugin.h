#import <Cordova/CDVPlugin.h>
#import <Cordova/CDVPluginResult.h>
#import "ESPTouchTask.h"
#import "ESPTouchResult.h"
#import "ESP_NetUtil.h"

//#import <Esptouch/ESPTouchDelegate.h>



@interface esptouchPlugin : CDVPlugin
@property (nonatomic, strong) NSCondition *_condition;
@property (atomic, strong) ESPTouchTask *_esptouchTask;
- (void)getWifiSSid:(CDVInvokedUrlCommand*)command;
- (void)startSearch:(CDVInvokedUrlCommand*)command;

- (void)stopSearch:(CDVInvokedUrlCommand*)command;

@end
