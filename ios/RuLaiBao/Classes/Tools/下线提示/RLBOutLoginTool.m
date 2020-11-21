//
//  RLBOutLoginTool.m
//  RuLaiBao
//
//  Created by qiu on 2018/5/29.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "RLBOutLoginTool.h"
#import "Configure.h"
#import "AppDelegate.h"
#import "MainNavigationController.h"
#import "MainTabBarController.h"

@implementation RLBOutLoginTool
#pragma mark --//9999退出登录
+(void)logOutUserInfo{
    //退出登录状态，跳到登录页
    // 清空用户数据信息
    [StoreTool storeLoginStates:NO];
    [StoreTool storeUserID:@""];
    [StoreTool storePhone:@""];
    [StoreTool storeRealname:@""];
    [StoreTool storeCheckStatus:@""];
    [StoreTool storeHandpwd:@""];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationLogOff object:nil];
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"下线通知" message:@"您的账号被禁止使用，请联系客服！" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelction1 = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UINavigationController *seleVC = app.mainTabBarController.selectedViewController;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                //跳转登录页
                LoginViewController *loginVC = [[LoginViewController alloc]init];
                loginVC.type = LogInAppearTypePresent;
                MainNavigationController *loginNav = [[MainNavigationController alloc]initWithRootViewController:loginVC];
                
                [app.mainTabBarController presentViewController:loginNav animated:YES completion:nil];
            });
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [seleVC popToRootViewControllerAnimated:YES];
        });
    }];
    [alertVC addAction:cancelction1];
    [app.mainTabBarController presentViewController:alertVC animated:YES completion:nil];
}
@end
