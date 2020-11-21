//
//  RecordListModel.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/27.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "RecordListModel.h"

@implementation RecordListModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if([key isEqualToString:@"id"]){
//        self.Id = value;
    }
}

- (id)initWithKVCDictionary:(NSDictionary *)KVCDic{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:KVCDic];
        
    }
    return self;
}

+ (instancetype)recordListModelWithDictionary:(NSDictionary *)KVCDic
{
    return [[self alloc] initWithKVCDictionary:KVCDic];
}


@end
