//
//  LxApplication.m
//  LxApplication
//

#define PRINTF(fmt, ...)    printf("%s\n",[[NSString stringWithFormat:fmt,##__VA_ARGS__]UTF8String])

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

@synthesize applicationOrientation = _applicationOrientation;

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
    id dataNetworkType = [self.statusBarDataNetworkItemView valueForKey:@"dataNetworkType"];
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

- (UIInterfaceOrientation)applicationOrientation
{
    return _applicationOrientation;
}

- (void)setApplicationOrientation:(UIInterfaceOrientation)applicationOrientation
{
    _applicationOrientation = applicationOrientation;
    
    NSAssert([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)], @"Cannot rotate the orientation"); //
    
#if __has_feature(objc_arc)
    NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:@selector(setOrientation:)]];
    invocation.selector = @selector(setOrientation:);
    invocation.target = [UIDevice currentDevice];
    [invocation setArgument:&applicationOrientation atIndex:2];
    [invocation invoke];
#else
    [[UIDevice currentDevice] performSelector:@selector(setOrientation:) withObject:@(applicationOrientation)];
#endif
}

- (void)dismissKeyboard
{
    [self sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (void)vibrate
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void)playSoundForPath:(NSString *)soundPath
{
    NSAssert([[NSFileManager defaultManager]fileExistsAtPath:soundPath], @"The soundPath(%@) is error or not exists.", soundPath);  //
    
    static SystemSoundID soundID = 0;
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:soundPath], &soundID);
    AudioServicesPlaySystemSound(soundID);
}

- (void)sendEvent:(UIEvent *)event
{
    if (self.forbidAllDeviceEvents) {
        return;
    }
    
#if OPEN_EVENTS_OBSERVER
    switch (event.type) {
        case UIEventTypeTouches:
        {
            switch ([[event.allTouches anyObject] phase]) {
                case UITouchPhaseBegan:
                {
                    PRINTF(@"LxApplication: Touch Began");   //
                }
                    break;
                case UITouchPhaseMoved:
                {
                    PRINTF(@"LxApplication: Touch Moved");   //
                }
                    break;
                case UITouchPhaseStationary:
                {
                    PRINTF(@"LxApplication: Touch Stationary");   //
                }
                    break;
                case UITouchPhaseEnded:
                {
                    PRINTF(@"LxApplication: Touch Ended");   //
                }
                    break;
                case UITouchPhaseCancelled:
                {
                    PRINTF(@"LxApplication: Touch Cancelled");   //
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case UIEventTypeMotion:
        {
            switch (event.subtype) {
                case UIEventSubtypeMotionShake:
                {
                    PRINTF(@"LxApplication: Motion Shake");   //
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case UIEventTypeRemoteControl:
        {
            switch (event.subtype) {
                case UIEventSubtypeRemoteControlPlay:
                {
                    PRINTF(@"LxApplication: RemoteControl Play");   //
                }
                    break;
                case UIEventSubtypeRemoteControlPause:
                {
                    PRINTF(@"LxApplication: RemoteControl Pause");   //
                }
                    break;
                case UIEventSubtypeRemoteControlStop:
                {
                    PRINTF(@"LxApplication: RemoteControl Stop");   //
                }
                    break;
                case UIEventSubtypeRemoteControlTogglePlayPause:
                {
                    PRINTF(@"LxApplication: RemoteControl TogglePlayPause");   //
                }
                    break;
                case UIEventSubtypeRemoteControlNextTrack:
                {
                    PRINTF(@"LxApplication: RemoteControl NextTrack");   //
                }
                    break;
                case UIEventSubtypeRemoteControlPreviousTrack:
                {
                    PRINTF(@"LxApplication: RemoteControl PreviousTrack");   //
                }
                    break;
                case UIEventSubtypeRemoteControlBeginSeekingBackward:
                {
                    PRINTF(@"LxApplication: RemoteControl BeginSeekingBackward");   //
                }
                    break;
                case UIEventSubtypeRemoteControlEndSeekingBackward:
                {
                    PRINTF(@"LxApplication: RemoteControl EndSeekingBackward");   //
                }
                    break;
                case UIEventSubtypeRemoteControlBeginSeekingForward:
                {
                    PRINTF(@"LxApplication: RemoteControl BeginSeekingForward");   //
                }
                    break;
                case UIEventSubtypeRemoteControlEndSeekingForward:
                {
                    PRINTF(@"LxApplication: RemoteControl EndSeekingForward");   //
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
#endif
    
    [super sendEvent:event];
}

@end
