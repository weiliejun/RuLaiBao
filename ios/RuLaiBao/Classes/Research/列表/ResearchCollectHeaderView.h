//
//  ResearchCollectHeaderView.h
//  RuLaiBao
//
//  Created by qiu on 2018/4/2.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//
/*!
 课程推荐
 */
#import <UIKit/UIKit.h>

/** 返回值 */
typedef void(^ControlBlock)(void);

@class CourseListModel;
@interface ResearchCollectHeaderView : UIView

@property (nonatomic, copy) ControlBlock controlClick;

@property (nonatomic, strong) CourseListModel *infoModel;

@end
