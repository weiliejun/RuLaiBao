//
//  Utils.m
//  KanGou
//
//  Created by 张黎征 on 14-3-14.
//  Copyright (c) 2014年 Mrzhang. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (NSString *)bundlePath:(NSString *)fileName {
    return [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:fileName];
}

+ (NSString *)documentsPath:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

+ (NSString *)tempPath:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"temp"];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

//手机号检查
+ (BOOL) validPhone:(NSString*)value {
    //    电信号段:133/153/180/181/189/177
    //    联通号段:130/131/132/155/156/185/186/145/176
    //    移动号段:134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178
    //    虚拟运营商:170
    
    value = [value stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (!value.length) {
        return NO;
    }
    // *********** 以下两种两种判断正则,暂时选个简洁的 ******************
    //    NSString *phoneRegex = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
    NSString *phoneRegex = @"1[3-9]([0-9]){9}";
    
    NSPredicate *phone = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return  [phone evaluateWithObject:value];
}

/** 正则匹配用户密码8-16位数字和字母组合 */
+ (BOOL)validPassword:(NSString *)password {
    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,16}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
}

/** 校验银行卡 */
+ (BOOL)isBankCard:(NSString *)cardNumber {
    if(cardNumber.length == 0) {
        return NO;
        
    }
    
    NSString *digitsOnly = @"";
    char c;
    for (int i = 0; i < cardNumber.length; i++) {
        c = [cardNumber characterAtIndex:i];
        if (isdigit(c)) {
            digitsOnly =[digitsOnly stringByAppendingFormat:@"%c",c];
            
        }
    }
    
    int sum = 0;
    int digit = 0;
    int addend = 0;
    
    BOOL timesTwo = false;
    for (NSInteger i = digitsOnly.length - 1; i >= 0; i--) {
        digit = [digitsOnly characterAtIndex:i] - '0';
        if (timesTwo) {
            addend = digit * 2;
            if (addend > 9) {
                addend -= 9;
                
            }
        } else {
            addend = digit;
            
        }
        sum += addend;
        timesTwo = !timesTwo;
    }
    
    int modulus = sum % 10;
    return modulus == 0;
    
}


@end
