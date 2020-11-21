//
//  UnpayCommissionModel.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/11/20.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "UnpayCommissionModel.h"

@implementation UnpayCommissionModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if([key isEqualToString:@"id"]){
        
        self.commissionId = value;
    }
}

- (id)initWithKVCDictionary:(NSDictionary *)KVCDic{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:KVCDic];
        
    }
    return self;
}


+ (instancetype)unpayCommissionModelWithDictionary:(NSDictionary *)KVCDic {
    return [[self alloc] initWithKVCDictionary:KVCDic];
}

@end
