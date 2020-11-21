//
//  ResearchModel.h
//  RuLaiBao
//
//  Created by qiu on 2018/4/25.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

/*!
 研修首页-课程推荐 + 精品课程model
 */
#import <Foundation/Foundation.h>

/*
 courseRecommend =     {
     courseId = 18040809331701583466;
     courseLogo = 1;
     courseName = aa;
     courseTime = "2018-04-10";
     courseVideo = aaaaaaaaaaaa;
     position = 0000000;
     speechmakeName = leige;
 };
 qualityCourseList =     (
 {
         courseId = 18032709463185347070;
         courseLogo = 1;
         courseName = "\U513f\U7ae5\U4fdd\U969c\U57fa\U91d1";
         courseTime = "2018-03-30";
         courseVideo = "https://v.qq.com/x/page/y0637r23h19.html";
         position = 0000000;
         speechmakeName = leige;
         typeCode = 126666;
         typeName = "";
     },
     {
         courseId = 19932709463185347070;
         courseLogo = 1;
         courseName = "\U8001\U4eba\U533b\U7597\U4fdd\U969c";
         courseTime = "2018-03-30";
         courseVideo = "https://v.qq.com/x/page/y0637r23h19.html";
         position = 0000000;
         speechmakeName = leige;
         typeCode = 126666;
         typeName = "";
     }
 );
 };
 */

@class CourseListModel;
@interface ResearchModel : NSObject

@property (nonatomic, strong) CourseListModel *courseRecommend;
@property (nonatomic, strong) NSArray <CourseListModel *> *qualityCourseList;
@end
