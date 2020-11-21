 //
//  Utils.h
//  KanGou
//
//  Created by 张黎征 on 14-3-14.
//  Copyright (c) 2014年 Mrzhang. All rights reserved.
//

/*
 校验类
 */

#import <Foundation/Foundation.h>

@interface Utils : NSObject

//bundle目录
+ (NSString *)bundlePath:(NSString *)fileName;
//document目录
+ (NSString *)documentsPath:(NSString *)fileName;
//临时目录
+ (NSString *)tempPath:(NSString *)fileName;

/** 校验手机号 */
+ (BOOL) validPhone:(NSString*)value;
/** 校验密码是否合法（密码必须包含字母和数字且6-16位 */
+ (BOOL)validPassword:(NSString *)password;

/** 校验银行卡 */
+ (BOOL)isBankCard:(NSString *)cardNumber;

@end
