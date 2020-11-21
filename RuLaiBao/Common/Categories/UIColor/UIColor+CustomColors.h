//
//  UIColor+CustomColors.h
//  WeiJinKe
//
//  Created by mac2015 on 15/2/28.
//  Copyright (c) 2015年 mac2015. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 @category
 @abstract  UIColor的Category
 */
@interface UIColor (CustomColors)

//背景色
+(UIColor *)customBackgroundColor;
//主色调 深黄
+(UIColor *)customDeepYellowColor;
//辅助色 浅黄
+(UIColor *)customLightYellowColor;
//辅助色 蓝色
+(UIColor *)customBlueColor;
//辅助色 红色
+(UIColor *)customRedColor;
//导航
+(UIColor *)customNavBarColor;
//标题
+(UIColor *)customTitleColor;
//备注
+(UIColor *)customDetailColor;
//分割线 
+(UIColor *)customLineColor;


+(UIColor *)customcolorWithRed:(NSUInteger)red green:(NSUInteger)green blue:(NSUInteger)blue;

// 透明度固定为1，以0x开头的十六进制转换成的颜色
+ (UIColor *)colorWithHex:(long)hexColor;
// 0x开头的十六进制转换成的颜色,透明度可调整
+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity;
// 颜色转换三：iOS中十六进制的颜色（以#开头）转换为UIColor
+ (UIColor *) colorWithHexString: (NSString *)color;

@end
