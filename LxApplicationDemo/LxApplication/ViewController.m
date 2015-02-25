//
//  ViewController.m
//  LxApplication
//
//  Created by Gener-health-li.x on 15/2/21.
//  Copyright (c) 2015年 Gener-health-li.x. All rights reserved.
//

#import "ViewController.h"
#import "LxApplication.h"
#import <objc/runtime.h>
#import "LxView.h"

@interface UIView (tools)

- (void)deepTraverseSubviewsWithActionBlock:(void (^)(UIView * subV))actionBlock;

@end

@implementation UIView (tools)

- (void)deepTraverseSubviewsWithActionBlock:(void (^)(UIView * subV))actionBlock
{
    actionBlock(self);
    for (UIView * v in self.subviews) {
        [v deepTraverseSubviewsWithActionBlock:actionBlock];
    }
}

@end

@interface ViewController () <UITextFieldDelegate>

@end

@implementation ViewController

//- (void)loadView
//{
//    [super loadView];
//    self.view = (LxView *)self.view;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UITextField * tf = [[UITextField alloc]initWithFrame:CGRectMake(20, 50, 300, 40)];
    tf.delegate = self;
    tf.backgroundColor = [UIColor cyanColor];
    tf.alpha = 0.3;
//    [self.view addSubview:tf];
    
    LxView * view1 = [[LxView alloc]initWithFrame:CGRectMake(40, 40, 295, 600)];
    view1.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:view1];
    
    LxView * view2 = [[LxView alloc]initWithFrame:CGRectMake(40, 40, 200, 100)];
    view2.backgroundColor = [UIColor yellowColor];
    [view1 addSubview:view2];
    
    LxView * view3 = [[LxView alloc]initWithFrame:CGRectMake(40, 180, 200, 100)];
    view3.backgroundColor = [UIColor greenColor];
    [view1 addSubview:view3];
    
    
    
//    SHARED_APPLICATION.theStatusBar.backgroundColor = [UIColor yellowColor];
//    [SHARED_APPLICATION.theStatusBar addSubview:tf];
//    [SHARED_APPLICATION.statusBarForegroundView deepTraverseSubviewsWithActionBlock:^(UIView *subV) {
//        
//        NSLog(@"--%@--%@", [subV.superview class], [subV class]); //
//        
//        unsigned int ivarCount = 0;
//        
//        Ivar * ivarList = class_copyIvarList([subV class], &ivarCount);
//        
//        if (ivarCount <= 0) {
//            return;
//        }
//
//        NSMutableArray * memberVariableArray = [NSMutableArray array];
//        
//        for (int i = 0; i < ivarCount; i++) {
//            
//            NSString * iVarName = [NSString stringWithUTF8String:ivar_getName(ivarList[i])];
//            
//            @try {
//                NSLog(@"{ %@ : %@ }", iVarName, [subV valueForKey:iVarName]);  //
//            }
//            @catch (NSException *exception) {
//                
//            }
//            @finally {
//                
//            }
//
//            [memberVariableArray addObject:iVarName];
//
//        }
//        
//        free(ivarList);
//        
////        NSLog(@"memberVariableArray = %@", memberVariableArray); //
//    }];  //
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
//    id a = SHARED_APPLICATION.currentKeyboard;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
