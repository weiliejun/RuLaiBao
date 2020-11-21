//
//  AppDelegate.h
//  RuLaiBao
//
//  Created by qiu on 2018/3/26.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MainTabBarController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/** 窗口转换的类 */
@property (nonatomic, retain) MainTabBarController *mainTabBarController;

@end

