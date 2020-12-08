//
//  Configure.h
//  RuLaiBao
//
//  Created by qiu on 2018/3/28.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#ifndef Configure_h
#define Configure_h

#ifdef DEBUG
# define NSLog(FORMAT, ...) NSLog((@"%s:%d \n" FORMAT), [[[NSString stringWithUTF8String: __FILE__] lastPathComponent] UTF8String], __LINE__, ##__VA_ARGS__);
#else
# define NSLog(...);
#endif

#define WeakSelf __weak typeof(self) weakSelf = self;
#define StrongSelf __strong typeof(weakSelf) strongSelf = weakSelf;

//扩展
#import "AppConfig.h"

//提示信息
#import "QLMBProgressHUD.h"
//view的坐标
#import "UIView+Common.h"
//校验类
#import "Utils.h"
//存储类
#import "StoreTool.h"
//刷新类
#import <MJRefresh.h>
//autolayout
#import <Masonry.h>
//model类
#import <YYModel.h>
//图片
#import "UIImageView+WebCache.h"
//颜色
#import "UIColor+CustomColors.h"
//NSString的Category
#import "NSString+Custom.h"
//网络请求
#import "RequestManager.h"
//跳转到登陆
#import "JumpToLoginVCTool.h"
//跳转到认证
#import "JumpToSellCertifyVCTool.h"

// 所有请求协议宏定义  http / https
#define DataHttp  @"http"
//所有web的头
#define webHttp  @"http"

// 开发环境--> 请求头设置
/** 正式环境 */
#define RequestHeader @"app.ksghi.com"

//* 内网测试环境
//#define RequestHeader  @"192.168.1.82:93"

/** 外网测试环境 */
//#define RequestHeader  @"123.126.102.219:30093"

//代树理
//#define RequestHeader  @"192.168.1.106:9999/rulaibao-app"

// 张亚磊
//#define RequestHeader  @"192.168.1.193:9999/rulaibao-app"

// 沈楠
//#define RequestHeader  @"192.168.1.138:9999/rulaibao-app"

// 邢玉洁
//#define RequestHeader  @"192.168.1.125:9999/rulaibao-app"

//冯艳敏
//#define RequestHeader @"192.168.1.164:8887/rulaibao-app"

#endif /* Configure_h */
