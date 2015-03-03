//
//  ViewController.m
//  LxApplication
//

#import "ViewController.h"
#import "LxApplication.h"
#import <objc/runtime.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

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
    
    SHARED_APPLICATION.forbidAllDeviceEvents = YES;  //
    
    [SHARED_APPLICATION dismissKeyboard];
    [SHARED_APPLICATION vibrate];
    
    NSString * SOUND_PATH = [[NSBundle mainBundle]pathForResource:@"NOTI" ofType:@"caf"];
    [SHARED_APPLICATION playSoundForPath:SOUND_PATH];
}

@end
