//
//  LxApplication.m
//  LxApplication
//

#import "LxApplication.h"
#import <AudioToolbox/AudioToolbox.h>
#import <ifaddrs.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <sys/utsname.h>

@interface UIResponder (Lx)

+ (UIResponder *)currentFirstResponder;

@end

@implementation UIResponder (Lx)

static __weak UIResponder * currentFirstResponder = nil;

+ (UIResponder *)currentFirstResponder
{
    currentFirstResponder = nil;
    [SHARED_APPLICATION sendAction:@selector(currentFirstResponderExecute:) to:nil from:nil forEvent:nil];
    return currentFirstResponder;
}

- (void)currentFirstResponderExecute:(id)sender
{
    currentFirstResponder = self;
}

@end



@interface LxApplication ()

@end

@implementation LxApplication

- (UIResponder *)currentFirstResponder
{
    return [UIResponder currentFirstResponder];
}

- (UIView *)currentKeyboard
{
    UIView * currentKeyboard = nil;
    
    for (UIWindow * window in [self.windows reverseObjectEnumerator]) {
        currentKeyboard = [self findKeyboardInView:window];
        if (currentKeyboard) {
            return currentKeyboard;
        }
    }
    printf("There is no keyboard currently!"); //
    return nil;
}

- (UIView *)findKeyboardInView:(UIView *)view
{
    for (UIView * subview in view.subviews) {
        if ([NSStringFromClass([subview class]) hasPrefix:@"UIKeyboard"]) {
            return subview;
        }
        else {
            UIView * possibleKeyboardView = [self findKeyboardInView:subview];
            if (possibleKeyboardView) {
                return possibleKeyboardView;
            }
        }
    }
    return nil;
}

- (UIView *)theStatusBar
{
    return [self valueForKeyPath:@"statusBar"];
}

- (NSString *)localIPAddress
{
    NSString * localIPAddress = @"Fetch local IP address error.";
    struct ifaddrs * addrs = 0;
    if (getifaddrs(&addrs) == 0) {
        const struct ifaddrs * cursor = addrs;
        while (cursor) {
            if (cursor->ifa_addr->sa_family == AF_INET) {
                printf("cursor -> ifa_name = %s", cursor -> ifa_name); //
                if (0 == strcmp(cursor->ifa_name, "en0")) {
                    
                    localIPAddress = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor -> ifa_addr) -> sin_addr)];
                }
            }
            cursor = cursor->ifa_next;
        }
    }
    
    freeifaddrs(addrs);
    
    return localIPAddress;
}

- (NSString *)architectureName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

- (UIView *)statusBarBackgroundView
{
    return [self.theStatusBar valueForKey:@"backgroundView"];
}

- (UIView *)statusBarForegroundView
{
    return [self.theStatusBar valueForKey:@"foregroundView"];
}

- (UIView *)statusBarServiceItemView
{
    for (UIView * v in self.statusBarForegroundView.subviews) {
        if ([v isKindOfClass:NSClassFromString(@"UIStatusBarServiceItemView")]) {
            return v;
        }
    }
    return nil;
}

- (UIView *)statusBarDataNetworkItemView
{
    for (UIView * v in self.statusBarForegroundView.subviews) {
        if ([v isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            return v;
        }
    }
    return nil;
}

- (UIView *)statusBarBatteryItemView
{
    for (UIView * v in self.statusBarForegroundView.subviews) {
        if ([v isKindOfClass:NSClassFromString(@"UIStatusBarBatteryItemView")]) {
            return v;
        }
    }
    return nil;
}

- (UIView *)statusBarTimeItemView
{
    for (UIView * v in self.statusBarForegroundView.subviews) {
        if ([v isKindOfClass:NSClassFromString(@"UIStatusBarTimeItemView")]) {
            return v;
        }
    }
    return nil;
}

- (NSString *)serviceProvider
{
    return [self.statusBarServiceItemView valueForKey:@"serviceString"];
}

- (NSString *)networkType
{
    id dataNetworkType = [self.statusBarForegroundView valueForKey:@"dataNetworkType"];
    switch ([dataNetworkType integerValue]) {
        case 0:
        {
            return @"null";
        }
            break;
        case 1:
        {
            return @"2G";
        }
            break;
        case 2:
        {
            return @"3G";
        }
            break;
        case 3:
        {
            return @"4G";
        }
            break;
        case 4:
        {
            return @"";
        }
            break;
        case 5:
        {
            return @"WIFI";
        }
            break;
        default:
        {
            return @"";
        }
            break;
    }
}

- (NSInteger)wifiStrength
{
    return [[self.statusBarDataNetworkItemView valueForKey:@"wifiStrengthBars"]integerValue];
}

- (NSString *)statusBarTimeString
{
    return [self.statusBarTimeItemView valueForKey:@"timeString"];
}

- (NSInteger)batteryCapacity
{
    return [[self.statusBarBatteryItemView valueForKey:@"capacity"]integerValue];
}

- (BOOL)isChargingBattery
{
    return [[self.statusBarBatteryItemView valueForKey:@"state"]boolValue];
}

- (void)dismissKeyboard
{
    [self sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (void)vibrate
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void)palySoundForPath:(NSString *)soundPath
{
    NSAssert([[NSFileManager defaultManager]fileExistsAtPath:soundPath], @"The soundPath(%@) is error or not exists.", soundPath);  //
    
    static SystemSoundID soundID = 0;
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:soundPath], &soundID);
    AudioServicesPlaySystemSound(soundID);
}

- (void)sendEvent:(UIEvent *)event
{
    NSLog(@"sendEvent"); //
//    NSLog(@"self.currentFirstResponder = %@", self.currentFirstResponder); //
    
//    UITouch * aTouch = [event.allTouches anyObject];
//    NSLog(@"window = %@", aTouch.window);    // 0x7f8a7a633940  0x7f8a7a469fe0
//    NSLog(@"view = %@", aTouch.view);    //
//    NSLog(@"gestureRecognizers = %@", aTouch.gestureRecognizers);    //
//    NSLog(@"majorRadius = %f", aTouch.majorRadius);    //
//    NSLog(@"majorRadiusTolerance = %f", aTouch.majorRadiusTolerance);    //
    
    switch (event.type) {
        case UIEventTypeTouches:
        {
            switch ([[event.allTouches anyObject] phase]) {
                case UITouchPhaseBegan:
                {
                    
                }
                    break;
                case UITouchPhaseMoved:
                {
                    
                }
                    break;
                case UITouchPhaseStationary:
                {
                    
                }
                    break;
                case UITouchPhaseEnded:
                {
                    
                }
                    break;
                case UITouchPhaseCancelled:
                {
                    
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case UIEventTypeMotion:
        {
            
        }
            break;
        case UIEventTypeRemoteControl:
        {
            
        }
            break;
        default:
            break;
    }
    [super sendEvent:event];
}

@end
