//
//  DetailLabel.h
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/16.
//  Copyright © 2018年 junde. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailLabel : UILabel

/**
 创建文本标签

 @param frame   frame
 @param text      内容字符串
 @param font     字体大小
 @param color    字体颜色
 @return              根据内容自适应的标签
 */
- (instancetype)initWithFrame:(CGRect)frame
                         text:(NSString *)text
                     fontSize:(CGFloat)font
                    textColor:(UIColor *)color;

@end
