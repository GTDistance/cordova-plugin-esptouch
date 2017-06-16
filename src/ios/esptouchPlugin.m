#import "esptouchPlugin.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@interface EspTouchDelegateImpl : NSObject<ESPTouchDelegate>
@property (nonatomic, strong) CDVInvokedUrlCommand *command;
@property (nonatomic, weak) id <CDVCommandDelegate> commandDelegate;

@end

@implementation EspTouchDelegateImpl

-(void) onEsptouchResultAddedWithResult: (ESPTouchResult *) result
{
    NSString *InetAddress=[ESP_NetUtil descriptionInetAddrByData:result.ipAddrData];
    NSString *text=[NSString stringWithFormat:@"bssid=%@,InetAddress=%@",result.bssid,InetAddress];
    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: text];
    [pluginResult setKeepCallbackAsBool:true];
    //[self.commandDelegate sendPluginResult:pluginResult callbackId:self.command.callbackId];  //add by lianghuiyuan
}
@end


@implementation esptouchPlugin
- (void) getWifiSSid:(CDVInvokedUrlCommand *)command{
    NSString *apSsid = [self currentWifiSSID];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:apSsid];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

//- (void) startSearch:(CDVInvokedUrlCommand *)command{
//    
//    [self._condition lock];
//    NSString *apSsid = (NSString *)[command.arguments objectAtIndex:0];
////    NSString *apBssid = (NSString *)[command.arguments objectAtIndex:1];
//    NSString *apPwd = (NSString *)[command.arguments objectAtIndex:1];
////    NSString *isSsidHiddenStr=(NSString *)[command.arguments objectAtIndex:3];
//    
////    BOOL isSsidHidden = true;
//    BOOL isSsidHidden = false;
////    if([isSsidHiddenStr compare:@"NO"]==NSOrderedSame){
////        isSsidHidden=false;
////    }
////    int taskCount = (int)[command.arguments objectAtIndex:4];
//    NSString *apBssid = [self currentWifiBSSID];
//    int taskCount = 1;
//    self._esptouchTask =
//    [[ESPTouchTask alloc]initWithApSsid:apSsid andApBssid:apBssid andApPwd:apPwd andIsSsidHiden:isSsidHidden];
//    EspTouchDelegateImpl *esptouchDelegate=[[EspTouchDelegateImpl alloc]init];
//    esptouchDelegate.command=command;
//    esptouchDelegate.commandDelegate=self.commandDelegate;
//    [self._esptouchTask setEsptouchDelegate:esptouchDelegate];
//    [self._condition unlock];
//    NSArray * esptouchResultArray = [self._esptouchTask executeForResults:taskCount];
//    NSLog(@"ESPViewController executeForResult() result is: %@",esptouchResultArray);
//    [self.commandDelegate runInBackground:^{
//    dispatch_queue_t  queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(queue, ^{
//        // show the result to the user in UI Main Thread
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//            
//            ESPTouchResult *firstResult = [esptouchResultArray objectAtIndex:0];
//            // check whether the task is cancelled and no results received
//            if (!firstResult.isCancelled)
//            {
//                NSMutableString *mutableStr = [[NSMutableString alloc]init];
//                NSUInteger count = 0;
////                 max results to be displayed, if it is more than maxDisplayCount,
////                 just show the count of redundant ones
//                const int maxDisplayCount = 5;
//                if ([firstResult isSuc])
//                {
//                    
//                    for (int i = 0; i < [esptouchResultArray count]; ++i)
//                    {
//                        ESPTouchResult *resultInArray = [esptouchResultArray objectAtIndex:i];
//                        [mutableStr appendString:[resultInArray description]];
//                        [mutableStr appendString:@"\n"];
//                        count++;
//                        if (count >= maxDisplayCount)
//                        {
//                            break;
//                        }
//                    }
//                    
//                    if (count < [esptouchResultArray count])
//                    {
//                        [mutableStr appendString:[NSString stringWithFormat:@"\nthere's %lu more result(s) without showing\n",(unsigned long)([esptouchResultArray count] - count)]];
//                    }
//                    CDVPluginResult* pluginResult = nil;
//                    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: mutableStr];
//                    [pluginResult setKeepCallbackAsBool:true];
//                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//                }
//                
//                else
//                {
//                    CDVPluginResult* pluginResult = nil;
//                    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: @"Esptouch fail"];
//                    [pluginResult setKeepCallbackAsBool:true];
//                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//                }
//            }
//            
//        });
//    });
//    }];
//}
- (void) startSearch:(CDVInvokedUrlCommand *)command
{
    // do confirm
   
        NSLog(@"ESPViewController do confirm action...");
        dispatch_queue_t  queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            NSLog(@"ESPViewController do the execute work...");
            // execute the task
            NSArray *esptouchResultArray = [self executeForResults:command];
            // show the result to the user in UI Main Thread
            dispatch_async(dispatch_get_main_queue(), ^{
                
                ESPTouchResult *firstResult = [esptouchResultArray objectAtIndex:0];
                // check whether the task is cancelled and no results received
                if (!firstResult.isCancelled)
                {
                    NSMutableString *mutableStr = [[NSMutableString alloc]init];
                    NSUInteger count = 0;
                    // max results to be displayed, if it is more than maxDisplayCount,
                    // just show the count of redundant ones
                    const int maxDisplayCount = 5;
                    if ([firstResult isSuc])
                    {
                        
                        for (int i = 0; i < [esptouchResultArray count]; ++i)
                        {
                            ESPTouchResult *resultInArray = [esptouchResultArray objectAtIndex:i];
                            [mutableStr appendString:[resultInArray description]];
                            [mutableStr appendString:@"\n"];
                            count++;
                            if (count >= maxDisplayCount)
                            {
                                break;
                            }
                        }
                        
                        if (count < [esptouchResultArray count])
                        {
                            [mutableStr appendString:[NSString stringWithFormat:@"\nthere's %lu more result(s) without showing\n",(unsigned long)([esptouchResultArray count] - count)]];
                        }
                        CDVPluginResult* pluginResult = nil;
                        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: mutableStr];
                        [pluginResult setKeepCallbackAsBool:true];
                        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                    }
                    
                    else
                    {
                        CDVPluginResult* pluginResult = nil;
                        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: @"Esptouch fail"];
                        [pluginResult setKeepCallbackAsBool:true];
                        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                    }
                }
                
            });
        });
}

#pragma mark - the example of how to use executeForResults
- (NSArray *) executeForResults:(CDVInvokedUrlCommand *)command
    {
        [self._condition lock];
        NSString *apSsid = (NSString *)[command.arguments objectAtIndex:0];
        //    NSString *apBssid = (NSString *)[command.arguments objectAtIndex:1];
        NSString *apPwd = (NSString *)[command.arguments objectAtIndex:1];
        //    NSString *isSsidHiddenStr=(NSString *)[command.arguments objectAtIndex:3];
        
        //    BOOL isSsidHidden = true;
        BOOL isSsidHidden = false;
        //    if([isSsidHiddenStr compare:@"NO"]==NSOrderedSame){
        //        isSsidHidden=false;
        //    }
        //    int taskCount = (int)[command.arguments objectAtIndex:4];
        NSString *apBssid = [self currentWifiBSSID];
        int taskCount = 1;

        self._esptouchTask =
        [[ESPTouchTask alloc]initWithApSsid:apSsid andApBssid:apBssid andApPwd:apPwd andIsSsidHiden:isSsidHidden];
        EspTouchDelegateImpl *esptouchDelegate=[[EspTouchDelegateImpl alloc]init];
        esptouchDelegate.command=command;
        esptouchDelegate.commandDelegate=self.commandDelegate;
        [self._esptouchTask setEsptouchDelegate:esptouchDelegate];
        [self._condition unlock];
        NSArray * esptouchResults = [self._esptouchTask executeForResults:taskCount];
        
//        self._esptouchTask =
//        [[ESPTouchTask alloc]initWithApSsid:apSsid andApBssid:apBssid andApPwd:apPwd andIsSsidHiden:isSsidHidden];
        // set delegate
//        [self._esptouchTask setEsptouchDelegate:self._esptouchDelegate];
//        [self._condition unlock];
//        NSArray * esptouchResults = [self._esptouchTask executeForResults:taskCount];
        NSLog(@"ESPViewController executeForResult() result is: %@",esptouchResults);
        return esptouchResults;
    }

- (void) stopSearch:(CDVInvokedUrlCommand *)command{
    [self._condition lock];
    if (self._esptouchTask != nil)
    {
        [self._esptouchTask interrupt];
    }
    [self._condition unlock];
    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: @"cancel success"];
    [pluginResult setKeepCallbackAsBool:true];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
- (NSString *)currentWifiSSID {
    // Does not work on the simulator.
    NSString *ssid = nil;
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    for (NSString *ifnam in ifs) {
        NSDictionary *info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info[@"SSID"]) {
            ssid = info[@"SSID"];
        }
    }
    return ssid;
}
- (NSString *)currentWifiBSSID {
    // Does not work on the simulator.
    NSString *bssid = nil;
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    for (NSString *ifnam in ifs) {
        NSDictionary *info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info[@"BSSID"]) {
            bssid = info[@"BSSID"];
        }
    }
    return bssid;
}

@end
