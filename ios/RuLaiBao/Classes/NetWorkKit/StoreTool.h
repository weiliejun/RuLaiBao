//
//  StoreTool.h
//  RuLaiBao
//
//  Created by qiu on 2018/3/28.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//
/*
 储存类
 */
#import <Foundation/Foundation.h>

@interface StoreTool : NSObject

/** 存储userid */
+ (BOOL)storeUserID:(NSString *)userID;
+ (NSString *)getUserID;

/** 存储realname */
+ (BOOL)storeRealname:(NSString *)realname;
+ (NSString *)getRealname;

/** 存储Phone */
+ (BOOL)storePhone:(NSString *)Phone;
+ (NSString *)getPhone;

/** 存储登录状态 */
+ (BOOL)storeLoginStates:(BOOL)loginStates;
+ (BOOL)getLoginStates;

/** 存储认证状态 */
+ (BOOL)storeCheckStatus:(NSString *)checkStatus;
+ (NSString *)getCheckStatus;
+ (BOOL)getCheckStatusForSuccess;

/** 存身份证 */
+ (BOOL)storePresonCardID:(NSString *)presonCardID;
+ (NSString *)getPresonCardID;

//存手势密码
+ (BOOL)storeHandpwd:(NSString *)handpwd;
+ (NSString *)getHandpwd;

//存储眼睛的状态
+ (BOOL)storeEyeStatus:(BOOL)isOpen;
+ (BOOL)getEyeStatus;

//存储隐私政策的状态
+ (BOOL)storeSerectStatus:(BOOL)isOpen;
+ (BOOL)getSerectStatus;

@end
