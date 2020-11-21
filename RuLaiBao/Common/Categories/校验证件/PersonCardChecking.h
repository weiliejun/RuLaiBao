//
//  PersonCardChecking.h
//  WeiJinKe
//
//  Created by mac2015 on 15/3/12.
//  Copyright (c) 2015年 mac2015. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PersonCardChecking : NSObject

/*!
 @method
 @abstract 验证是否不为空
 @result   返回结果
 */
+ (BOOL)verifyIsNotEmpty:(NSString *)str;

/*!
 @method
 @abstract 验证身份证
 @result   返回结果
 */
+ (BOOL)verifyIDCardNumber:(NSString *)value;

/*!
 @method
 @abstract 得到身份证的生日****这个方法中不做身份证校验，请确保传入的是正确身份证
 @result   返回结果
 */
+ (NSString *)getIDCardBirthday:(NSString *)card;

/*!
 @method
 @abstract 得到身份证的性别（1男0女）****这个方法中不做身份证校验，请确保传入的是正确身份证
 @result   返回结果
 */
+ (NSInteger)getIDCardSex:(NSString *)card;

//+ (BOOL)verifyText:(NSString *)text withRegex:(NSString *)regex;    //正则验证
//+ (BOOL)verifyCardNumberWithSoldier:(NSString *)value;   //验证军官证或警官证
//+ (BOOL)verifyIDCardHadAdult:(NSString *)card;  //验证身份证是否成年且小于100岁****这个方法中不做身份证校验，请确保传入的是正确身份证
//+ (BOOL)verifyIDCardMoreThanPointDate:(NSString *)card withNumber:(NSInteger)number withAddTimeInterval:(NSTimeInterval)interval withDateType:(DateType)dateType; //验证身份证加上指定天数是否大于指定number的类型
//+ (BOOL)verifyIDCardLessThanPointDate:(NSString *)card withNumber:(NSInteger)number withAddTimeInterval:(NSTimeInterval)interval withDateType:(DateType)dateType;  //验证身份证是否小于指定number的类型


@end


