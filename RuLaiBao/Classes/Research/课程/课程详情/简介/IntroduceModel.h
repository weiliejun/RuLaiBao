//
//  IntroduceModel.h
//  RuLaiBao
//
//  Created by qiu on 2018/4/27.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IntroduceModel : NSObject
/** 课程id */
@property (nonatomic, copy) NSString *courseId;
/** 从业岗位 */
@property (nonatomic, copy) NSString *position;
/** 客户姓名 */
@property (nonatomic, copy) NSString *realName;
/** 演讲人Id */
@property (nonatomic, copy) NSString *speechmakeId;
/** 头像 */
@property (nonatomic, copy) NSString *headPhoto;
/** 课程名称 */
@property (nonatomic, copy) NSString *courseName;
/** 课程时间 */
@property (nonatomic, copy) NSString *courseTime;
/** 课程内容 */
@property (nonatomic, copy) NSString *courseContent;
/** 课程视频链接 */
@property (nonatomic, copy) NSString *courseVideo;
/** 类型名称 */
@property (nonatomic, copy) NSString *typeName;
@end
