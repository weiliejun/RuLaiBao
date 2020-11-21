//
//  QLMBProgressHUD.m
//  QLXMPPDemo
//
//  Created by qiu on 16/9/7.
//  Copyright © 2016年 QiuFairy. All rights reserved.
//

#import "QLMBProgressHUD.h"
#import "MBProgressHUD.h"

/*!
 若将MBProgressHUD.h升级到1.0.0版本,则在添加GrowingIO的情况下使用MBProgressHUDModeText会多出来一个按钮
 在此情况下去掉GrowingIO即可
 特此注明,此处有坑;苦熬半夜,脱坑
 */

@implementation QLMBProgressHUD

+ (instancetype)sharedInstance{
    static QLMBProgressHUD *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
- (void)showLoadWithTitle:(NSString *)title{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[self currentView] animated:YES];
//            hud.mode = MBProgressHUDModeText;
            hud.userInteractionEnabled = YES;
            hud.labelText = title;
            hud.labelFont = [UIFont systemFontOfSize:15.0f];
            hud.removeFromSuperViewOnHide = YES;
        });
    });
    
}
- (void)hideLoad {
    [MBProgressHUD hideAllHUDsForView:[self currentView] animated:YES];
}
- (UIView *)currentView{
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    if ([vc isKindOfClass:[UITabBarController class]]) {
        vc = [(UITabBarController *)vc selectedViewController];
    }
    if([vc isKindOfClass:[UINavigationController class]]) {
        vc = [(UINavigationController *)vc visibleViewController]; //当前显示的控制器
    }
    if (!vc) {
        return [UIApplication sharedApplication].keyWindow;
    }
    return vc.view;
}
+ (void)showPromptViewInView:(UIView *)view WithTitle:(NSString *)title{
    UIView *hudView = view;
    if (hudView == nil) {
        hudView = [[UIApplication sharedApplication] windows].lastObject;//如果view为nil，则把当前的window赋值为view，把提示框添加到当前的window上
    }
//    [MBProgressHUD hideAllHUDsForView:hudView animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:hudView animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.userInteractionEnabled = NO;
    hud.detailsLabelText = title;
    hud.detailsLabelFont = [UIFont systemFontOfSize:15.0f];
    hud.removeFromSuperViewOnHide = YES;
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:YES afterDelay:2.0f];
        });
    });
}
@end
