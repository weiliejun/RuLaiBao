//
//  NewsInterModel.m
//  RuLaiBao
//
//  Created by qiu on 2018/5/11.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "NewsInterModel.h"

@implementation NewsInterModel
//未知参数映照
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"messageId" : @"id",@"messageType":@"type"};
}
@end
