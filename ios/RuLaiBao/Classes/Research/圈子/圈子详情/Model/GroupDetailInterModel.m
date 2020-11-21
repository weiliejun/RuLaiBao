//
//  GroupDetailInterModel.m
//  RuLaiBao
//
//  Created by qiu on 2018/5/2.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "GroupDetailInterModel.h"
#import "GroupDetailTopicModel.h"

@implementation GroupDetailInterModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"topAppTopics":[GroupDetailTopicModel class]};
}
@end
