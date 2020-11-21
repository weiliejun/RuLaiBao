//
//  UIImage+extend.h
//  RuLaiBao
//
//  Created by qiu on 2018/4/8.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (extend)
- (UIImage *)drawRectWithRoundedCornerWithSize:(CGSize)size;

/** UIButton 圆角 */ 
+ (UIImage *)pureColorImageWithSize:(CGSize)size color:(UIColor *)color cornRadius:(CGFloat)cornRadius;
@end
