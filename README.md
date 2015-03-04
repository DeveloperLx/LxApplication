# LxApplication
    A feature-rich application help class inherited from UIApplication.
Installation
------------
    You only need drag LxApplication.h and LxApplication.m to your project.
Support
------------
    Minimum support iOS version: iOS 5.0
Usage
-----------
###
    NSLog(@"currentFirstResponder = %@", SHARED_APPLICATION.currentFirstResponder);   //
    NSLog(@"currentKeyboard = %@", SHARED_APPLICATION.currentKeyboard);   //
    NSLog(@"theStatusBar = %@", SHARED_APPLICATION.theStatusBar);   //
    NSLog(@"localIPAddress = %@", SHARED_APPLICATION.localIPAddress);   //
    NSLog(@"architectureName = %@", SHARED_APPLICATION.architectureName);   //
    NSLog(@"statusBarBackgroundView = %@", SHARED_APPLICATION.statusBarBackgroundView);   //
    NSLog(@"statusBarServiceItemView = %@", SHARED_APPLICATION.statusBarServiceItemView);   //
    NSLog(@"statusBarDataNetworkItemView = %@", SHARED_APPLICATION.statusBarDataNetworkItemView);   //
    NSLog(@"statusBarBatteryItemView = %@", SHARED_APPLICATION.statusBarBatteryItemView);   //
    NSLog(@"statusBarTimeItemView = %@", SHARED_APPLICATION.statusBarTimeItemView);   //
    
    NSLog(@"serviceProvider = %@", SHARED_APPLICATION.serviceProvider);   //
    NSLog(@"networkType = %@", SHARED_APPLICATION.networkType);   //
    NSLog(@"wifiStrength = %ld", SHARED_APPLICATION.wifiStrength);   //
    NSLog(@"statusBarTimeString = %@", SHARED_APPLICATION.statusBarTimeString);   //
    NSLog(@"batteryCapacity = %ld", SHARED_APPLICATION.batteryCapacity);   //
    NSLog(@"isChargingBattery = %@", SHARED_APPLICATION.isChargingBattery?@"YES":@"NO");   //
    
    SHARED_APPLICATION.forbidAllDeviceEvents = YES;
    
    [SHARED_APPLICATION dismissKeyboard];
    [SHARED_APPLICATION vibrate];
    [SHARED_APPLICATION playSoundForPath:SOUND_PATH];
    
    .....................................
    
Be careful            
-----------
    You need overwrite main.m like 
###
    #import <UIKit/UIKit.h>
    #import "AppDelegate.h"
    #import "LxApplication.h"

    int main(int argc, char * argv[]) {
        @autoreleasepool {
            return UIApplicationMain(argc, argv, NSStringFromClass([LxApplication class]), NSStringFromClass([AppDelegate class]));
        }
    }
License
-----------
    LxApplication is available under the Apache License 2.0. See the LICENSE file for more info.
