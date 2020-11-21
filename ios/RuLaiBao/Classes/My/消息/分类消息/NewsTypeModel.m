//
//  NewsTypeModel.m
//  RuLaiBao
//
//  Created by qiu on 2018/5/8.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "NewsTypeModel.h"

@implementation NewsTypeModel
//未知参数映照
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"newsId" : @"id"};
}
@end
