//
//  RenewListModel.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/5/4.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "RenewListModel.h"

@implementation RenewListModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //    if([key isEqualToString:@"id"]){
    //        self.productId = value;
    //    }
}

- (id)initWithKVCDictionary:(NSDictionary *)KVCDic{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:KVCDic];
        
    }
    return self;
}

+ (instancetype)renewListModelWithDictionary:(NSDictionary *)KVCDic
{
    return [[self alloc] initWithKVCDictionary:KVCDic];
}

@end
