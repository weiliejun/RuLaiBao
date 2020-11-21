//
//  CourseListModel.m
//  RuLaiBao
//
//  Created by qiu on 2018/4/25.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

/*!
 课程model
 */
#import <Foundation/Foundation.h>

/*
 courseId = 18032709463185347070;
 courseLogo = 1;
 courseName = "\U513f\U7ae5\U4fdd\U969c\U57fa\U91d1";
 courseTime = "2018-03-30";
 courseVideo = "https://v.qq.com/x/page/y0637r23h19.html";
 position = 0000000;
 speechmakeName = leige;
 typeCode = 126666;
 typeName = "";
 */

@interface CourseListModel : NSObject
/** 课程名称 */
@property (nonatomic, copy) NSString *courseName;
/** 课程时间 */
@property (nonatomic, copy) NSString *courseTime;
/** 课程图片 */
@property (nonatomic, copy) NSString *courseLogo;
/** 课程id */
@property (nonatomic, copy) NSString *courseId;
/** 从业岗位 */
@property (nonatomic, copy) NSString *position;
/** 演讲人 */
@property (nonatomic, copy) NSString *speechmakeName;
/** 演讲人Id */
@property (nonatomic, copy) NSString *speechmakeId;
/** 课程视频链接 */
@property (nonatomic, copy) NSString *courseVideo;
/** 课程类型编号 */
@property (nonatomic, copy) NSString *typeCode;
/** 类型名称 */
@property (nonatomic, copy) NSString *typeName;
@end

/** 中间处理用的model */
@class CoursePageBarModel;
@interface CourseListInterModel : NSObject
/** 课程列表 */
@property (nonatomic, strong) NSArray <CourseListModel *> *courseList;
/** 课程类型列表 */
@property (nonatomic, strong) NSArray <CoursePageBarModel *> *courseTypeList;
@end
