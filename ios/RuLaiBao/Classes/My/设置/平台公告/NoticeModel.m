//
//  NoticeModel.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/5/5.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "NoticeModel.h"

@implementation NoticeModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
        if([key isEqualToString:@"id"]){
            self.Id = value;
        }
    
    if([key isEqualToString:@"description"]){
        self.descriptionStr = value;
    }
}

- (id)initWithKVCDictionary:(NSDictionary *)KVCDic{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:KVCDic];
        
    }
    return self;
}

+ (instancetype)noticeListModelWithDictionary:(NSDictionary *)KVCDic
{
    return [[self alloc] initWithKVCDictionary:KVCDic];
}

@end
