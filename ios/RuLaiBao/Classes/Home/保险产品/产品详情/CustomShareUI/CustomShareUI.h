//
//  CustomShareUI.h
//  RuLaiBao
//
//  Created by kingstartimes on 2018/5/9.
//  Copyright © 2018年 junde. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomShareUI : NSObject

//自定义分享界面
+(void)shareWithUrl:(NSString *)urlStr;
+(void)shareWithUrl:(NSString *)urlStr Title:(NSString *)titleStr DesStr:(NSString *)desStr;

@end
