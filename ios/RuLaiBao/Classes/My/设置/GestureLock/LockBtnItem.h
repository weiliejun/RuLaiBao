//
//  LockBtnItem.h
//  HaiDeHui
//
//  Created by qiu on 2017/6/26.
//  Copyright © 2017年 junde. All rights reserved.
//

#import <UIKit/UIKit.h>
/** 状态 */
typedef enum {
    wrongStyle  ,
    selectStyle ,
    normalStyle
} selectStyleModel;


@interface LockBtnItem : UIView

@property(nonatomic , assign)selectStyleModel model;

@property(nonatomic , strong)CAShapeLayer *outterLayer;
@property(nonatomic , strong)CAShapeLayer *innerLayer;
@property(nonatomic , strong)CAShapeLayer *triangleLayer;

@property(nonatomic , assign)BOOL isSelect;
/** 调整位置方向 */
- (void)judegeDirectionActionx1:(CGFloat)x1 y1:(CGFloat)y1 x2:(CGFloat)x2 y2:(CGFloat)y2 isHidden:(BOOL)isHidden;
@end
