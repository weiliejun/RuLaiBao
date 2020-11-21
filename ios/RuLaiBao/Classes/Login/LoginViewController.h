//
//  LoginViewController.h
//  RuLaiBao
//
//  Created by qiu on 2018/4/18.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "MainViewController.h"
typedef NS_ENUM (NSInteger, LogInAppearType) {
    LogInAppearTypePresent = 10010,
    LogInAppearTypePush
};

@interface LoginViewController : MainViewController

@property (nonatomic, assign) LogInAppearType type;

@end
