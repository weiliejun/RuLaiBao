//
//  ReplyModel.m
//  RuLaiBao
//
//  Created by qiu on 2018/4/28.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "ReplyModel.h"

@implementation ReplyModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
}

-(instancetype)initReplyModelWithDic:(NSDictionary *)dic;{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
@end
