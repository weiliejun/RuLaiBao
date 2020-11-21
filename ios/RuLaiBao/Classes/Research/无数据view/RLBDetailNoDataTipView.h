//
//  RLBDetailNoDataTipView.h
//  RuLaiBao
//
//  Created by qiu on 2018/5/21.
//  Copyright © 2018年 junde. All rights reserved.
//

/*!
 此view 是错误数据view
 */
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NoDataTipType) {
    NoDataTipTypeRequestLoading = 1000010,//请求中
    NoDataTipTypeRequestError            ,//请求失败
    NoDataTipTypeNoData                   //无数据(被删除)
};


typedef void(^ViewTapGestureClick)(NoDataTipType tipType);


@interface RLBDetailNoDataTipView : UIView
/**
 返回提示视图 --> 主要用于列表没有数据的时候
 
 @param frame       frame - self的frame
 @param imageName   图片名字
 @param tipText     提示内容
 @return            自定义的提示视图
 */
- (instancetype)initWithFrame:(CGRect)frame
                    imageName:(NSString *)imageName
                      tipText:(NSString *)tipText;

/*!
 用于一个view在某个控制器中显示不同的imgae时
 @param imageName 替换image
 @param tipLabelStr 替换提示文字信息
 */
-(void)changeImageViewWithImageName:(NSString *)imageName TipLabel:(NSString *)tipLabelStr;
/*!
 用于一个view在某个控制器中显示不同的提示信息时
 */
-(void)changeTipLabel:(NSString *)tipLabelStr;
/*!
 默认 NoDataTipTypeNoData
 */
@property (nonatomic, assign) NoDataTipType tipType;

@property (nonatomic, copy) ViewTapGestureClick tapClick;
@end
