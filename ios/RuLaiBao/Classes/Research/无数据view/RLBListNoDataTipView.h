//
//  RLBListNoDataTipView.h
//  RuLaiBao
//
//  Created by qiu on 2018/5/9.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

/*!
 此view是无数据view
 */
#import <UIKit/UIKit.h>

@interface RLBListNoDataTipView : UIView
/**
 返回提示视图 --> 主要用于列表没有数据的时候
 
 @param frame       frame - self的frame
 @param backgroundColor self 背景颜色
 @param imageName   图片名字
 @param imageFrame  图片再self上的frame
 @param titleFrame  提示文字在self上的frame
 @param tipText     提示内容
 @return            自定义的提示视图
 */
- (instancetype)initWithFrame:(CGRect)frame
              backgroundColor:(UIColor *)backgroundColor
                   imageFrame:(CGRect)imageFrame
                    imageName:(NSString *)imageName
                   titleFrame:(CGRect)titleFrame
                      tipText:(NSString *)tipText;

/*!
 用于一个view在某个控制器中显示不同的imgae时
 @param imageName 替换image
 @param tipLabelStr 替换提示文字信息
 */
-(void)changeImageViewWithImageName:(NSString *)imageName TipLabel:(NSString *)tipLabelStr;
@end
