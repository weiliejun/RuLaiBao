//
//  MyCollectionModel.h
//  RuLaiBao
//
//  Created by kingstartimes on 2018/5/3.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCollectionModel : NSObject
/** 编号 */
@property (nonatomic,copy)NSString *productId;
/** 保险名称 */
@property (nonatomic,copy)NSString *name;
/** 收藏Id */
@property (nonatomic,copy)NSString *collectionId;

+ (instancetype)collectionListModelWithDictionary:(NSDictionary *)KVCDic;


@end
