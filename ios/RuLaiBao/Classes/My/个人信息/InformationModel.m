//
//  InformationModel.m
//  RuLaiBao
//
//  Created by kingstartimes on 2018/4/26.
//  Copyright © 2018年 junde. All rights reserved.
//

#import "InformationModel.h"

@implementation InformationModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if([key isEqualToString:@"id"]){
        //        self.productId = value;
    }
}

- (id)initWithKVCDictionary:(NSDictionary *)KVCDic{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:KVCDic];
    }
    return self;
}

+ (instancetype)informationModelWithDictionary:(NSDictionary *)KVCDic
{
    return [[self alloc] initWithKVCDictionary:KVCDic];
}

@end
