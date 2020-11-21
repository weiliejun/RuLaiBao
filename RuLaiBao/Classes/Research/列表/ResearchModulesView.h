//
//  ResearchModulesView.h
//  RuLaiBao
//
//  Created by qiu on 2018/4/2.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

/*!
 顶部按钮
 */
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ControlType){
    ControlTypeCourse     = 1000,//课程
    ControlTypeQA           ,//问答
    ControlTypeGroup        ,//圈子
    ControlTypeFuture       ,//展业
};

/** 返回值 */
typedef void(^ControlClickBlock)(ControlType index);

@interface ResearchModulesView : UIView

@property (nonatomic, copy) ControlClickBlock controlClick;

@end
