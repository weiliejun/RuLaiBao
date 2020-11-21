//
//  MyBankCardModel.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/11/19.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "MyBankCardModel.h"

@implementation MyBankCardModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if([key isEqualToString:@"id"]){
        self.bankCardId = value;
        
    }
}

- (id)initWithKVCDictionary:(NSDictionary *)KVCDic {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:KVCDic];
        
    }
    return self;
}

+ (instancetype)myBankCardModelWithDictionary:(NSDictionary *)KVCDic {
    return [[self alloc] initWithKVCDictionary:KVCDic];
}


@end
