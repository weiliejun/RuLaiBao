//
//  QLColorLabel.h
//  WeiJinKe
//
//  Created by qiu on 16/7/13.
//  Copyright © 2016年 QiuFairy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QLColorLabel : UILabel
/**
 *  Set a highlight color to show emphasis between the beginmark and endmark
 *
 *  @param color A color different from label.TextColor
 */
+ (void)setAnotherColor:(UIColor *)color;

/**
 *  Set a highlight font to show emphasis between the beginmark and endmark
 *
 *  @param font A font different from label.font
 */
+ (void)setAnotherFont:(UIFont *)font;

/**
 *  Instance method to set color, the priority is higher.
 *
 */
- (void)setAnotherColor:(UIColor *)color;

/**
 *  Instance method to set font, the priority is higher.
 *
 */
- (void)setAnotherFont:(UIFont *)font;

/**
 *  The color for this label instance
 */
@property(nonatomic,strong)UIColor *anotherColor;

//设置两种不同的颜色
@property(nonatomic,strong)UIColor *anotherColor2;

/** 设置两种不同的颜色 */
- (void)setColor1:(UIColor *)color1 withColor2:(UIColor *)color2;


/**
 *  The font for this label instance
 */
@property(nonatomic,strong)UIFont *anotherFont;
@end
