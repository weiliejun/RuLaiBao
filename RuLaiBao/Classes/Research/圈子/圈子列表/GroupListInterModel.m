//
//  GroupListInterModel.m
//  RuLaiBao
//
//  Created by qiu on 2018/5/2.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "GroupListInterModel.h"
#import "GroupListModel.h"

@implementation GroupListInterModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"myAppCircle":[GroupListModel class],
             @"myJoinAppCircle":[GroupListModel class],
             @"myRecomAppCircle":[GroupListModel class]
             };
}
@end
