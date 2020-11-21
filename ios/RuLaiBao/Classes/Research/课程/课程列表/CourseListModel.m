//
//  CourseListModel.m
//  RuLaiBao
//
//  Created by qiu on 2018/4/25.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "CourseListModel.h"
#import "CoursePageBarModel.h"

@implementation CourseListModel
//Model 属性名和 JSON 中的 Key 不相同
//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
//+ (NSDictionary *)modelCustomPropertyMapper {
//    return @{@"courseId" : @"id"};
//}
@end

@implementation CourseListInterModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"courseTypeList":[CoursePageBarModel class],
             @"courseList":[CourseListModel class]};
}
@end
