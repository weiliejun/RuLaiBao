//
//  CommissionListModel.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/11/21.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "CommissionListModel.h"

@implementation CommissionListModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if([key isEqualToString:@"id"]){
        
        self.commissionListId = value;
    }
}

- (id)initWithKVCDictionary:(NSDictionary *)KVCDic{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:KVCDic];
        
    }
    return self;
}

+ (instancetype)commissionListModelWithDictionary:(NSDictionary *)KVCDic {
    return [[self alloc] initWithKVCDictionary:KVCDic];

}

@end
