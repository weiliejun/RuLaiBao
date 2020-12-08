//
//  StoreTool.m
//  RuLaiBao
//
//  Created by qiu on 2018/3/28.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "StoreTool.h"
#import "DES3Util.h"

@implementation StoreTool

#pragma mark -存储usrID
+ (BOOL)storeUserID:(NSString *)userID
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *Des3str = [DES3Util encrypt:userID];
    [userDefaults setObject:Des3str forKey:@"userID"];
    [userDefaults synchronize];
    return YES;
}
+ (NSString *)getUserID
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"userID"]) {
        NSString *Des3strde = [DES3Util decrypt:[userDefaults objectForKey:@"userID"]];
        return Des3strde;
    }else {
        return @"";
    }
}

#pragma mark -存储真实username
+ (BOOL)storeRealname:(NSString *)realname
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *Des3str = [DES3Util encrypt:realname];
    [userDefaults setObject:Des3str forKey:@"realname"];
    [userDefaults synchronize];
    return YES;
}
+ (NSString *)getRealname
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"realname"]) {
        NSString *Des3strde = [DES3Util decrypt:[userDefaults objectForKey:@"realname"]];
        return Des3strde;
    }else {
        return @"";
    }
}

#pragma mark -存储userpwd
+ (BOOL)storeUserpwd:(NSString *)userpwd
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:userpwd forKey:@"userpwd"];
    [userDefaults synchronize];
    return YES;
}
+ (NSString *)getUserpwd
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"userpwd"]) {
        return [userDefaults objectForKey:@"userpwd"];
    }else {
        return @"";
    }
}

#pragma mark -手机号
+ (BOOL)storePhone:(NSString *)Phone
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *Des3str = [DES3Util encrypt:Phone];
    [userDefaults setObject:Des3str forKey:@"Phone"];
    [userDefaults synchronize];
    return YES;
}
+ (NSString *)getPhone
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"Phone"]) {
        NSString *Des3strde = [DES3Util decrypt:[userDefaults objectForKey:@"Phone"]];
        return Des3strde;
    }else {
        return @"";
    }
}

#pragma mark -存储登录状态
+ (BOOL)storeLoginStates:(BOOL)loginStates
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:loginStates forKey:@"loginStates"];
    [userDefaults synchronize];
    return YES;
}
+ (BOOL)getLoginStates
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"loginStates"]) {
        return [userDefaults boolForKey:@"loginStates"];
    }else {
        return NO;
    }
}

#pragma mark -存身份证
+ (BOOL)storePresonCardID:(NSString *)presonCardID
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *Des3str = [DES3Util encrypt:presonCardID];
    [userDefaults setObject:Des3str forKey:@"presonCardID"];
    [userDefaults synchronize];
    return YES;
}
+ (NSString *)getPresonCardID
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"presonCardID"]) {
        NSString *Des3strde = [DES3Util decrypt:[userDefaults objectForKey:@"presonCardID"]];
        return Des3strde;
    }else {
        return @"";
    }
}

#pragma mark - 存储认证状态
/*!
 init未认证（注册后未填写认证信息）
 submit待认证(提交认证信息待审核)
 success - 认证成功(后台审核通过)
 fail - 认证失败(后台审核未通过)
 */
+ (BOOL)storeCheckStatus:(NSString *)checkStatus {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *Des3str = [DES3Util encrypt:checkStatus];
    [userDefaults setObject:Des3str forKey:@"checkStatus"];
    [userDefaults synchronize];
    return YES;
}

+ (NSString *)getCheckStatus {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"checkStatus"]) {
        NSString *Des3strde = [DES3Util decrypt:[userDefaults objectForKey:@"checkStatus"]];
        
        return Des3strde;
    }else {
        return @"";
    }
}
+ (BOOL)getCheckStatusForSuccess{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"checkStatus"]) {
        NSString *Des3strde = [DES3Util decrypt:[userDefaults objectForKey:@"checkStatus"]];
        if([Des3strde isEqualToString:@"success"]){
            return YES;
        }else{
            return NO;
        }
    }else {
        return NO;
    }
}
#pragma mark - 存手势密码
+ (BOOL)storeHandpwd:(NSString *)handpwd
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *Des3str = [DES3Util encrypt:handpwd];
    [userDefaults setObject:Des3str forKey:@"handpwd"];
    [userDefaults synchronize];
    return YES;
}
+ (NSString *)getHandpwd
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"handpwd"]) {
        NSString *Des3strde = [DES3Util decrypt:[userDefaults objectForKey:@"handpwd"]];
        return Des3strde;
    }else {
        return @"";
    }
}

#pragma mark - 存储眼睛的状态
+ (BOOL)storeEyeStatus:(BOOL)isOpen
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:isOpen forKey:@"eyeStatus"];
    [userDefaults synchronize];
    return YES;
}

+ (BOOL)getEyeStatus
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"eyeStatus"]) {
        return [userDefaults boolForKey:@"eyeStatus"];
    }else {
        return NO;
    }
}

#pragma mark - 存储隐私政策的状态
+ (BOOL)storeSerectStatus:(BOOL)isOpen{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:isOpen forKey:@"SerectStatus"];
    [userDefaults synchronize];
    return YES;
}
+ (BOOL)getSerectStatus{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"SerectStatus"]) {
        return [userDefaults boolForKey:@"SerectStatus"];
    }else {
        return NO;
    }
}

@end
