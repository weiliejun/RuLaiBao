//
//  QLLockView.h
//  WeiJinKe
//
//  Created by qiu on 16/7/6.
//  Copyright © 2016年 mac2015. All rights reserved.
//

#import <UIKit/UIKit.h>



@class QLLockView;
@protocol QLLockViewDelegate <NSObject>
//自定义一个协议
//协议方法，把当前视图作为参数
-(void)LockViewDidClick:(QLLockView *)lockView andPwd:(NSString *)pwd;
@end

@interface QLLockView : UIView
//代理
@property(nonatomic,weak) id<QLLockViewDelegate>delegate;

@end
