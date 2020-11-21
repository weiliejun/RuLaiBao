//
//  JumpToLoginVC.h
//  RuLaiBao
//
//  Created by kingstartimes on 2018/5/8.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

/*!
 登录页跳转处理
 主要用于分辨present or push
 */
#import <UIKit/UIKit.h>

#import "LoginViewController.h"
@interface JumpToLoginVCTool : NSObject

+(void)jumpToLoginVCWithFatherViewController:(UIViewController *)viewController methodType:(LogInAppearType)methodType;

@end
