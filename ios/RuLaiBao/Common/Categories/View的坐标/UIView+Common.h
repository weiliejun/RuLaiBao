//
//  UIView+Common.h
//  BlueMobiProject
//
//  Created by 朱 亮亮 on 14-4-28.
//  Copyright (c) 2014年 朱 亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 @category
 @abstract  UIView通用Category
 */
@interface UIView (Common)

/*!
 @method
 @abstract  获取左上角横坐标
 @result    坐标值
 */
- (CGFloat)left;

/*!
 @method
 @abstract  获取左上角纵坐标
 @result    坐标值
 */
- (CGFloat)top;

/*!
 @method
 @abstract  获取视图右下角横坐标
 @result    坐标值
 */
- (CGFloat)right;

/*!
 @method
 @abstract  获取视图右下角纵坐标
 @result    坐标值
 */
- (CGFloat)bottom;

/*!
 @method
 @abstract  获取视图宽度
 @result    宽度值（像素）
 */
- (CGFloat)width;

/*!
 @method
 @abstract  获取视图高度
 @result    高度值（像素）
 */
- (CGFloat)height;

/*!
 @method
 @abstract  删除所有子对象
 */
- (void)removeAllSubviews;

/**
 调用此方法的对象,必须是要装换成PDF文件的视图对象,一般都是加载显示PDF文件链接的webView
 返回转换成的二进制文件,需要保存到文档目录中,文件名格式后缀必须是.pdf
 
 @param Width 需要打印的文件的宽度,默认是当前屏幕宽度,当设置为默认时设置为小于等于0的值即可
 @param Height 需要打印的文件的高度,默认是当前屏幕高度,当设置为默认时设置为小于等于0的值即可
 @return 返回本视图转换之后的二进制文件,这里主要用于转换PDF文件
 */
- (NSData *)viewConvertToPDFWithWidth:(CGFloat)Width height:(CGFloat)Height;

@end
