//
//  NSString+Custom.h
//  WeiJinKe
//
//  Created by mac2015 on 15/5/18.
//  Copyright (c) 2015年 mac2015. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*!
 @category
 @abstract  NSString的Category
 */
@interface NSString (Custom)

//11位手机号码加****
+(NSString *)changePhoneNum:(NSString *)phoneNum;
/** name加*** */
+(NSString *)changeUserName:(NSString *)userName;
/** 身份证加*** */
+(NSString *)changeIDCard:(NSString *)IDCard;

//银行卡加****
//适用于前4，后4中间加*的Str
+(NSString *)changeIDBankCard:(NSString *)IDCard;

//银行卡每四位加空格
+ (NSString *)formatterBankCardNum:(NSString *)string;

//数字加","分隔
+(NSString *)fenGeText:(double)text;

//加***隐藏
+ (NSString *)jiaxingText:(NSString *)text;
/** 为空判断 */
+ (BOOL)isBlankString:(NSString *)string;

#pragma mark -- 动态计算高度
+(CGSize)sizeWithFont:(UIFont *)font Size:(CGSize)size Str:(NSString *)Str;

/**
 * 计算文字高度，可以处理计算带行间距的
 * 若计算高度则，高度置成 MAXFLOAT
 */
+ (NSArray *)boundingRectWithSize:(CGSize)size font:(UIFont*)font  lineSpacing:(CGFloat)lineSpacing Str:(NSString *)Str;

/**
 *  计算是否超过一行
 */
- (BOOL)isMoreThanOneLineWithSize:(CGSize)size font:(UIFont *)font lineSpaceing:(CGFloat)lineSpacing;

/** 判断字符串中是否存在emoji */
+(BOOL)hasEmoji:(NSString*)string;
/** 判断是不是九宫格 */
+(BOOL)isNineKeyBoard:(NSString *)string;

@end

