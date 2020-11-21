//
//  JumpToLoginVC.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/5/8.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "JumpToLoginVCTool.h"
#import "MainNavigationController.h"

@implementation JumpToLoginVCTool
+(void)jumpToLoginVCWithFatherViewController:(UIViewController *)viewController methodType:(LogInAppearType)methodType{
    if (methodType == LogInAppearTypePush) {
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        loginVC.type = LogInAppearTypePush;
        [viewController.navigationController pushViewController:loginVC animated:YES];
    }else{
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        loginVC.type = LogInAppearTypePresent;
        MainNavigationController *loginNav = [[MainNavigationController alloc]initWithRootViewController:loginVC];
        [viewController presentViewController:loginNav animated:YES completion:nil];
    }
}
@end
