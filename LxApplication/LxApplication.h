//
//  LxApplication.h
//  LxApplication
//

#import <UIKit/UIKit.h>

#warning You need rewrite main.m like \
\
   ........................    \
   #import "LxApplication.h"   \
\
   int main(int argc, char * argv[]) { \
       @autoreleasepool {  \
            return UIApplicationMain(argc, argv, NSStringFromClass([LxApplication class]), NSStringFromClass([AppDelegate class]));    \
        }   \
   }   \

#define SHARED_APPLICATION  ((LxApplication *)[UIApplication sharedApplication])

@interface LxApplication : UIApplication

@property (nonatomic,readonly) UIView * currentFirstResponder;
@property (nonatomic,readonly) UIView * currentKeyboard;
@property (nonatomic,readonly) UIView * theStatusBar;

@property (nonatomic,readonly) NSString * localIPAddress;
@property (nonatomic,readonly) NSString * architectureName;

@property (nonatomic,readonly) UIView * statusBarBackgroundView;
@property (nonatomic,readonly) UIView * statusBarForegroundView;
@property (nonatomic,readonly) UIView * statusBarServiceItemView;
@property (nonatomic,readonly) UIView * statusBarDataNetworkItemView;
@property (nonatomic,readonly) UIView * statusBarBatteryItemView;
@property (nonatomic,readonly) UIView * statusBarTimeItemView;

@property (nonatomic,readonly) NSString * serviceProvider;
@property (nonatomic,readonly) NSString * networkType;
@property (nonatomic,readonly) NSInteger wifiStrength;
@property (nonatomic,readonly) NSString * statusBarTimeString;
@property (nonatomic,readonly) NSInteger batteryCapacity;
@property (nonatomic,readonly) BOOL isChargingBattery;

- (void)dismissKeyboard;
- (void)vibrate;
- (void)palySoundForPath:(NSString *)soundPath;

@end
