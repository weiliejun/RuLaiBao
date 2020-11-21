//
//  ChangeNumber.m
//  jundehui
//
//  Created by kingstartimes on 16/8/1.
//  Copyright © 2016年 QiuFairy. All rights reserved.
//

#import "ChangeNumber.h"
#import <UIKit/UIKit.h>

@implementation ChangeNumber

- (id)changeNumber:(NSString *)string{
    
    NSString *str = string;
    
    NSMutableString *moneyString=[NSMutableString string];
    
    str = [str stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    NSString *folatString;
    
    NSArray *array=[str componentsSeparatedByString:@"."];
    if (array.count>1) {
        [moneyString insertString:array[0] atIndex:0];
        folatString=[NSString stringWithFormat:@".%@",array[1]];
        
    }else{
        [moneyString insertString:array[0] atIndex:0];
    }
    
    for (NSInteger i=[moneyString length]-3; i>0; i-=3) {
        [moneyString insertString:@"," atIndex:i];
    }
    if (folatString != nil) {
        [moneyString insertString:folatString atIndex:moneyString.length];
    }
    return moneyString;
}

- (id)changeFont:(NSString *)string{
    NSString *str = string;
    NSRange range = [str rangeOfString:@"."];
    NSString *str00 = [str substringFromIndex:range.location];
    NSRange range11 = [str rangeOfString:str00];
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc]initWithString:str];
    [attr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]}range:range11];
    
    return attr;
    
}


@end
