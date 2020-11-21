//
//  ProspectusModel.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/5/2.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "ProspectusModel.h"

@implementation ProspectusModel
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

+ (instancetype)prospectusListModelWithDictionary:(NSDictionary *)KVCDic{
     return [[self alloc] initWithKVCDictionary:KVCDic];
}


@end
