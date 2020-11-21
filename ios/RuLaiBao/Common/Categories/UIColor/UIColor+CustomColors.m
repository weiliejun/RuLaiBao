//
//  UIColor+CustomColors.m
//  WeiJinKe
//
//  Created by mac2015 on 15/2/28.
//  Copyright (c) 2015年 mac2015. All rights reserved.
//

#import "UIColor+CustomColors.h"

@implementation UIColor (CustomColors)

//背景色 #f9f9f9 249,249,249
+(UIColor *)customBackgroundColor
{
    return [UIColor colorWithHexString:@"#f9f9f9"];
}
//主色调 深黄 #f59e01 245,158,1
+(UIColor *)customDeepYellowColor
{
    return [UIColor colorWithHexString:@"#f59e01"];
}
//辅助色 浅黄 #fab22c 250,178,44
+(UIColor *)customLightYellowColor
{
    return [UIColor colorWithHexString:@"#fab22c"];
}
//辅助色 蓝色 #0087fd   0, 135, 253
+(UIColor *)customBlueColor
{
    return [UIColor colorWithHexString:@"#0087fd"];
}
//辅助色 红色 #f3482e 243,72,46
+(UIColor *)customRedColor
{
    return [UIColor colorWithHexString:@"#f3482e"];
}
//导航 #333333  51，51，51
+(UIColor *)customNavBarColor{
    return [UIColor colorWithHexString:@"#333333"];
}
//标题 #666666   102, 102, 102
+(UIColor *)customTitleColor{
    return [UIColor colorWithHexString:@"#666666"];
}
//备注 #999999   153, 153, 153
+(UIColor *)customDetailColor{
    return [UIColor colorWithHexString:@"#999999"];
}
//分割线 #eaeaea   234,234,234
+(UIColor *)customLineColor{
    return [UIColor colorWithHexString:@"#eaeaea"];
}

#pragma mark
+(UIColor *)customcolorWithRed:(NSUInteger)red green:(NSUInteger)green blue:(NSUInteger)blue
{

    return [UIColor colorWithRed:(float)(red/255.f) green:(float)(green/255.f) blue:(float)(blue/225.f) alpha:1.f];
}

// 透明度固定为1，以0x开头的十六进制转换成的颜色
+ (UIColor*) colorWithHex:(long)hexColor;
{
    return [UIColor colorWithHex:hexColor alpha:1.];
}
// 0x开头的十六进制转换成的颜色,透明度可调整
+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity
{
    float red = ((float)((hexColor & 0xFF0000) >> 16))/255.0;
    float green = ((float)((hexColor & 0xFF00) >> 8))/255.0;
    float blue = ((float)(hexColor & 0xFF))/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:opacity];
}
// 颜色转换三：iOS中十六进制的颜色（以#开头）转换为UIColor
+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // 判断前缀并剪切掉
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

@end
