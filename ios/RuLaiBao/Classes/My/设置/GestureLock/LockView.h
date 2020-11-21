//
//  LockView.h
//  LockViewDemo
//
//  Created by qiu on 2017/6/26.
//  Copyright © 2017年 QiuFairy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LockHeader.h"

@class LockView;
@protocol QLLockViewDelegate <NSObject>
//自定义一个协议
//协议方法，把当前视图作为参数
-(void)LockViewDidClick:(LockView *)lockView andPwd:(NSString *)pwd;
@end

@interface LockView : UIView
//代理
@property(nonatomic,weak) id<QLLockViewDelegate>delegate;

@end
