//
//  MySalaryModel.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/11/21.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "MySalaryModel.h"

@implementation MySalaryModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if([key isEqualToString:@"id"]){
        self.mySalaryId = value;
        
    }
}

- (id)initWithKVCDictionary:(NSDictionary *)KVCDic {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:KVCDic];
    }
    return self;
}


+ (instancetype)mySalaryModelWithDictionary:(NSDictionary *)KVCDic {
    return [[self alloc] initWithKVCDictionary:KVCDic];
}

@end
