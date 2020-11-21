//
//  ResearchModel.m
//  RuLaiBao
//
//  Created by qiu on 2018/4/25.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "ResearchModel.h"
#import "CourseListModel.h"

@implementation ResearchModel

//Model 包含其他 Model

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"qualityCourseList":[CourseListModel class]};
}
@end
