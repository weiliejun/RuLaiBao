//
//  SearchListModel.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/5/2.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "SearchListModel.h"

@implementation SearchListModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if([key isEqualToString:@"id"]){
        self.Id = value;
    }
}

- (id)initWithKVCDictionary:(NSDictionary *)KVCDic{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:KVCDic];
        
    }
    return self;
}

+ (instancetype)searchListModelWithDictionary:(NSDictionary *)KVCDic{
    return [[self alloc] initWithKVCDictionary:KVCDic];
}

@end
