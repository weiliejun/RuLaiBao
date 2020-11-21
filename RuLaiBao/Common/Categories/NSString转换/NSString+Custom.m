//
//  NSString+Custom.m
//  WeiJinKe
//
//  Created by mac2015 on 15/5/18.
//  Copyright (c) 2015年 mac2015. All rights reserved.
//

#import "NSString+Custom.h"

@implementation NSString (Custom)

//11位手机号码加****
+(NSString *)changePhoneNum:(NSString *)phoneNum{
    NSString *OKNum = [NSString stringWithFormat:@"%@",phoneNum];
    if (phoneNum.length>=7) {
        OKNum =[OKNum stringByReplacingCharactersInRange:NSMakeRange(3,4) withString:@"****"];
    }
    return OKNum;
}

/** name加*** */
+(NSString *)changeUserName:(NSString *)userName{
    NSString *name = [NSString stringWithFormat:@"%@",userName];
    NSString *xingStr=@"";
    for (int i=0; i<name.length-1; i++) {
        xingStr =[NSString stringWithFormat:@"%@*",xingStr];
    }
    name =[name stringByReplacingCharactersInRange:NSMakeRange(1,name.length-1) withString:xingStr];
    return name;
}

/** 身份证加*** */
+(NSString *)changeIDCard:(NSString *)IDCard{
    NSString *OKNum = [NSString stringWithFormat:@"%@",IDCard];
    
    if(OKNum.length<=8){
        return OKNum;
    }
    if (OKNum.length == 15) {
        OKNum =[OKNum stringByReplacingCharactersInRange:NSMakeRange(6,OKNum.length-9) withString:@"******"];
    }else{
        OKNum =[OKNum stringByReplacingCharactersInRange:NSMakeRange(6,OKNum.length-10) withString:@"********"];
    }
    
    return OKNum;
}

//银行卡加****
+(NSString *)changeIDBankCard:(NSString *)IDCard{
    NSString *OKNum = [NSString stringWithFormat:@"%@",IDCard];
    NSString *xingStr = @"";
    if(OKNum.length<=8){
        return OKNum;
    }
    for (int i=0; i<OKNum.length-8; i++) {
        xingStr =[NSString stringWithFormat:@"%@*",xingStr];
    }
    OKNum =[OKNum stringByReplacingCharactersInRange:NSMakeRange(4,OKNum.length-8) withString:xingStr];
    return OKNum;
}
//银行卡每四位加空格
+ (NSString *)formatterBankCardNum:(NSString *)string{
    NSString *tempStr=string;
    NSInteger size =(tempStr.length / 4);
    NSMutableArray *tmpStrArr = [[NSMutableArray alloc] init];
    for (int n = 0;n < size; n++){
        [tmpStrArr addObject:[tempStr substringWithRange:NSMakeRange(n*4, 4)]];
    }
    if (tempStr.length %4 != 0) {
        [tmpStrArr addObject:[tempStr substringWithRange:NSMakeRange(size*4, (tempStr.length % 4))]];
    }
    
    tempStr = [tmpStrArr componentsJoinedByString:@" "];
    return tempStr;
}


//数字加","分隔
+(NSString *)fenGeText:(double)text
{
    NSString *ketou = [NSString stringWithFormat:@"%.2f",text];
    NSRange rangesx = [ketou rangeOfString:@"."];
    //    NSUInteger leightx = rangesx.length;
    NSUInteger locationx = rangesx.location;
    NSString *pointk = [ketou substringToIndex:locationx];
    NSString *pointH = [ketou substringFromIndex:locationx];
    //添加,号
    NSMutableString *numberstr = [[NSMutableString alloc] initWithString:pointk];
    NSInteger count = (numberstr.length-1)/3;
    for (int i = 0;i<count;i++) {
        [numberstr insertString:@"," atIndex:(numberstr.length-3*(i+1)-i)];
        NSLog(@"String1:%@",numberstr);
    }
    [numberstr appendString:pointH];
    return numberstr;
}
//加***隐藏
+ (NSString *)jiaxingText:(NSString *)text
{
    NSString *sellName = [NSString stringWithFormat:@"%@",text];
    NSMutableString *xing = [[NSMutableString alloc]init];
    if (sellName.length>=3) {
        for (int i =0; i<sellName.length-2; i++) {
            [xing appendString:@"*"];
        }
        sellName = [sellName stringByReplacingCharactersInRange:NSMakeRange(1,sellName.length-2) withString:xing];
    }else if(sellName.length>=2){
        [xing appendString:@"*"];
        sellName = [sellName stringByReplacingCharactersInRange:NSMakeRange(sellName.length-1,1) withString:xing];
    }else{
        
    }
    return sellName;
}
+ (BOOL)isBlankString:(NSString *)string{
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

#pragma mark -- 动态计算高度
+(CGSize)sizeWithFont:(UIFont *)font Size:(CGSize)size Str:(NSString *)Str{
    //根据系统版本确定使用哪个api
    CGSize resultSize;
    //段落样式
    NSDictionary *attributes = @{NSFontAttributeName:font};
    resultSize = [Str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    
    return resultSize;
}

/**
 * 计算文字高度，可以处理计算带行间距的
 */
+ (NSArray *)boundingRectWithSize:(CGSize)size font:(UIFont*)font lineSpacing:(CGFloat)lineSpacing Str:(NSString *)Str{
    NSMutableArray *muArr = [NSMutableArray arrayWithCapacity:2];
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:Str];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    [attributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, Str.length)];
    [attributeString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, Str.length)];
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
    CGRect rect = [attributeString boundingRectWithSize:size options:options context:nil];
    [muArr addObject:attributeString];
    [muArr addObject:NSStringFromCGSize(rect.size)];
    
    return muArr;
}

/**
 *  计算是否超过一行
 */
- (BOOL)isMoreThanOneLineWithSize:(CGSize)size font:(UIFont *)font lineSpaceing:(CGFloat)lineSpacing{
    NSArray *arr = [NSString boundingRectWithSize:size font:font lineSpacing:lineSpacing Str:self];
    CGFloat height = [arr[1] floatValue];
    if (height > font.lineHeight  ) {
        return YES;
    }else{
        return NO;
    }
}

//判断是否包含中文
- (BOOL)containChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fa6){
            return YES;
        }
    }
    return NO;
}

//检测中文或者中文符号
- (BOOL)validateChineseChar:(NSString *)string{
    NSString *nameRegEx = @"[\\u0391-\\uFFE5]";
    if (![string isMatchesRegularExp:nameRegEx]) {
        return NO;
    }
    return YES;
}

- (BOOL)isMatchesRegularExp:(NSString *)regex {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

/**
 *  判断字符串中是否存在emoji
 * @param string 字符串
 * @return YES(含有表情)
 */
+ (BOOL)hasEmoji:(NSString*)string{
    NSString *pattern = @"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]";
    return [string isMatchesRegularExp:pattern];
}
/**
 判断是不是九宫格
 @param string  输入的字符
 @return YES(是九宫格拼音键盘)
 */
+(BOOL)isNineKeyBoard:(NSString *)string{
    NSString *other = @"➋➌➍➎➏➐➑➒";
    int len = (int)string.length;
    for(int i=0;i<len;i++){
        if(!([other rangeOfString:string].location != NSNotFound))
            return NO;
    }
    return YES;
}


@end

