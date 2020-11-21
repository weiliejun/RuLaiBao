//
//  CourseDiretoryModel.m
//  RuLaiBao
//
//  Created by qiu on 2018/4/28.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "CourseDiretoryModel.h"
#import "CourseListModel.h"

@implementation CourseDiretoryModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"courseList":[CourseListModel class]};
}
@end
