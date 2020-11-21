//
//  MyAppointListModel.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/5/5.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "MyAppointListModel.h"

@implementation MyAppointListModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if([key isEqualToString:@"id"]){
        self.Id = value;
    }
    
    if ([key isEqualToString:@"auditStatus"]) {
        NSString *turnStr;
        if ([value isEqualToString:@"confirming"]) {
            turnStr = @"待确认";
        }else if ([value isEqualToString:@"confirmed"]){
            turnStr = @"已确认";
        }else if ([value isEqualToString:@"refuse"]){
            turnStr = @"已驳回";
        }else if ([value isEqualToString:@"canceled"]){
            turnStr = @"已取消";
        }else {
            turnStr = value;
        }
        self.statusStr = turnStr;
    }
}

- (id)initWithKVCDictionary:(NSDictionary *)KVCDic{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:KVCDic];
        
    }
    return self;
}

+ (instancetype)appointListModelWithDictionary:(NSDictionary *)KVCDic
{
    return [[self alloc] initWithKVCDictionary:KVCDic];
}


@end
