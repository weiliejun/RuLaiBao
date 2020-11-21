//
//  QLMBProgressHUD.h
//  QLXMPPDemo
//
//  Created by qiu on 16/9/7.
//  Copyright © 2016年 QiuFairy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QLMBProgressHUD : NSObject

#pragma mark - 单例对象,用于调用网络请求方法
+ (instancetype)sharedInstance;

/** 显示加载 */
- (void)showLoadWithTitle:(NSString *)title;
/** 加载完毕 */
- (void)hideLoad;

+ (void)showPromptViewInView:(UIView *)view WithTitle:(NSString *)title;

@end
