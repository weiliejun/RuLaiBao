//
//  CourseDiretoryModel.h
//  RuLaiBao
//
//  Created by qiu on 2018/4/28.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CourseListModel;
@interface CourseDiretoryModel : NSObject
/** 课程列表 */
@property (nonatomic, strong) NSArray <CourseListModel *> *courseList;
@end
